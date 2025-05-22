/*
 * Copyright (c) 2021 Rockchip, Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include "rkadk_common.h"
#include "rkadk_media_comm.h"
#include "rkadk_log.h"
#include "rkadk_param.h"
#include "rkadk_record.h"
#include "isp/sample_isp.h"
#include <getopt.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifdef ENABLE_AOV
#include "rkadk_aov.h"
#include "sensor_iq_info.h"
#endif

extern int optind;
extern char *optarg;

static RKADK_CHAR optstr[] = "a:I:p:m:P:M:S:l:d:r:kh";

static bool is_quit = false;
#define IQ_FILE_PATH "/etc/iqfiles"

static void print_usage(const RKADK_CHAR *name) {
  printf("usage example:\n");
  printf("\t%s [-a /etc/iqfiles] [-I 0] [-t 0]\n", name);
  printf("\t-a: enable aiq with dirpath provided, eg:-a "
         "/oem/etc/iqfiles/, Default /etc/iqfiles,"
         "without this option aiq should run in other application\n");
  printf("\t-I: Camera id, Default:0\n");
  printf("\t-p: param ini directory path, Default:/data/rkadk\n");
  printf("\t-k: key frame fragment, Default: disable\n");
  printf("\t-m: multiple sensors, Default:0, options: 1(all isp sensors), 2(isp+ahd sensors)\n");
  printf("\t-l: loop switch normal record and aov lapse record count, Default: 0\n");
  printf("\t-d: loop switch once duration(second), Default: 30s\n");
  printf("\t-P: path of meta.img, Deafult: /oem/usr/share/meta_sc200ai.img\n");
  printf("\t-M: aov ae wakeup mode, 0: MD wakupe: 1: always wakeup, 2: no wakeup, Default: 0\n");
  printf("\t-S: aov suspend time, Default: 1000ms\n");
  printf("\t-r: path of rtthread_wakeup.bin, Deafult: /oem/usr/share/rtthread_wakeup.bin\n");
}

static RKADK_S32
GetRecordFileName(RKADK_MW_PTR pRecorder, RKADK_U32 u32FileCnt,
                  RKADK_CHAR (*paszFilename)[RKADK_MAX_FILE_PATH_LEN]) {
  static RKADK_U32 u32FileIdx = 0;

  RKADK_LOGD("u32FileCnt:%d, pRecorder:%p", u32FileCnt, pRecorder);

  if (u32FileIdx >= 4)
    u32FileIdx = 0;

  for (RKADK_U32 i = 0; i < u32FileCnt; i++) {
    sprintf(paszFilename[i], "/mnt/sdcard/RecordTest_%u.mp4", u32FileIdx);
    u32FileIdx++;
  }

  return 0;
}

static RKADK_VOID
RecordEventCallback(RKADK_MW_PTR pRecorder,
                    const RKADK_MUXER_EVENT_INFO_S *pstEventInfo) {
  switch (pstEventInfo->enEvent) {
  case RKADK_MUXER_EVENT_STREAM_START:
    printf("+++++ RKADK_MUXER_EVENT_STREAM_START +++++\n");
    break;
  case RKADK_MUXER_EVENT_STREAM_STOP:
    printf("+++++ RKADK_MUXER_EVENT_STREAM_STOP +++++\n");
    break;
  case RKADK_MUXER_EVENT_FILE_BEGIN:
    printf("+++++ RKADK_MUXER_EVENT_FILE_BEGIN +++++\n");
    printf("\tstFileInfo: %s\n",
           pstEventInfo->unEventInfo.stFileInfo.asFileName);
    printf("\tu32Duration: %d\n",
           pstEventInfo->unEventInfo.stFileInfo.u32Duration);
    break;
  case RKADK_MUXER_EVENT_FILE_END:
    printf("+++++ RKADK_MUXER_EVENT_FILE_END +++++\n");
    printf("\tstFileInfo: %s\n",
           pstEventInfo->unEventInfo.stFileInfo.asFileName);
    printf("\tu32Duration: %d\n",
           pstEventInfo->unEventInfo.stFileInfo.u32Duration);
    break;
  case RKADK_MUXER_EVENT_MANUAL_SPLIT_END:
    printf("+++++ RKADK_MUXER_EVENT_MANUAL_SPLIT_END +++++\n");
    printf("\tstFileInfo: %s\n",
           pstEventInfo->unEventInfo.stFileInfo.asFileName);
    printf("\tu32Duration: %d\n",
           pstEventInfo->unEventInfo.stFileInfo.u32Duration);
    break;
  case RKADK_MUXER_EVENT_ERR_CREATE_FILE_FAIL:
    printf("+++++ RKADK_MUXER_EVENT_ERR_CREATE_FILE_FAIL[%d, %s] +++++\n",
            pstEventInfo->unEventInfo.stErrorInfo.s32ErrorCode,
            strerror(pstEventInfo->unEventInfo.stErrorInfo.s32ErrorCode));
    break;
  case RKADK_MUXER_EVENT_ERR_WRITE_FILE_FAIL:
    printf("+++++ RKADK_MUXER_EVENT_ERR_WRITE_FILE_FAIL[%d, %s] +++++\n",
            pstEventInfo->unEventInfo.stErrorInfo.s32ErrorCode,
            strerror(pstEventInfo->unEventInfo.stErrorInfo.s32ErrorCode));
    break;
  case RKADK_MUXER_EVENT_FILE_WRITING_SLOW:
    printf("+++++ RKADK_MUXER_EVENT_FILE_WRITING_SLOW +++++\n");
    break;
  case RKADK_MUXER_EVENT_ERR_CARD_NONEXIST:
    printf("+++++ RKADK_MUXER_EVENT_ERR_CARD_NONEXIST +++++\n");
    break;
  default:
    printf("+++++ Unknown event(%d) +++++\n", pstEventInfo->enEvent);
    break;
  }
}

#ifdef RKAIQ
static int IspProcess(RKADK_S32 u32CamId) {
  int ret;
  bool mirror = false, flip = false;

  // set mirror flip
  ret = RKADK_PARAM_GetCamParam(u32CamId, RKADK_PARAM_TYPE_MIRROR, &mirror);
  if (ret)
    RKADK_LOGE("RKADK_PARAM_GetCamParam mirror failed");

  ret = RKADK_PARAM_GetCamParam(u32CamId, RKADK_PARAM_TYPE_FLIP, &flip);
  if (ret)
    RKADK_LOGE("RKADK_PARAM_GetCamParam flip failed");

  if (mirror || flip) {
    ret = SAMPLE_ISP_SET_MirrorFlip(u32CamId, mirror, flip);
    if (ret)
      RKADK_LOGE("SAMPLE_ISP_SET_MirrorFlip failed");
  }

#ifdef RKADK_DUMP_ISP_RESULT
  // mirror flip
  ret = SAMPLE_ISP_GET_MirrorFlip(u32CamId, &mirror, &flip);
  if (ret)
    RKADK_LOGE("SAMPLE_ISP_GET_MirrorFlip failed");
  else
    RKADK_LOGD("GET mirror = %d, flip = %d", mirror, flip);
#endif

  return 0;
}
#endif

static void sigterm_handler(int sig) {
  fprintf(stderr, "signal %d\n", sig);
  is_quit = true;
}

int main(int argc, char *argv[]) {
  int c, ret;
  RKADK_RECORD_ATTR_S stRecAttr;
  RKADK_MW_PTR pRecorder = NULL, pRecorder1 = NULL;
  RK_BOOL bMultiSensor = RK_FALSE;
  const char *iniPath = NULL;
  RKADK_REC_TYPE_E enRecType;
  RKADK_PARAM_RES_E type;
  RKADK_PARAM_FPS_S stFps;
  RKADK_PARAM_CODEC_CFG_S stCodecType;
  char path[RKADK_PATH_LEN];
  char sensorPath[RKADK_MAX_SENSOR_CNT][RKADK_PATH_LEN];
  RKADK_S32 s32CamId = 0;
  FILE_CACHE_ATTR_S stFileCacheAttr;
  int loopCount = -1, loopDuration = 30;

#ifdef ENABLE_AOV
  RKADK_S32 s32SuspendTime = 1000;
  RKADK_META_PARA_VIR *pstMetaVir = NULL;
  RKADK_CHAR *pMetaPath = "/oem/usr/share/meta_sc200ai.img";
  RKADK_CHAR *rttWakeupBinPath = "/oem/usr/share/rtthread_wakeup.bin";
  struct wakeup_param_info *wakeupParam;
  RKADK_S32 s32AeMode = 0;
#endif

#ifdef RKAIQ
  int inCmd = 0;
  RK_BOOL bMultiCam = RK_FALSE;
  const char *tmp_optarg = optarg;
  SAMPLE_ISP_PARAM stIspParam;

  memset(&stIspParam, 0, sizeof(SAMPLE_ISP_PARAM));
  stIspParam.iqFileDir = IQ_FILE_PATH;
#endif


  system("mount -t vfat /dev/mmcblk1p1 /mnt/sdcard/");

  memset(&stRecAttr, 0, sizeof(RKADK_RECORD_ATTR_S));

  while ((c = getopt(argc, argv, optstr)) != -1) {
    switch (c) {
#ifdef RKAIQ
    case 'a':
      if (!optarg && NULL != argv[optind] && '-' != argv[optind][0]) {
        tmp_optarg = argv[optind++];
      }

      if (tmp_optarg)
        stIspParam.iqFileDir = (char *)tmp_optarg;
      break;
    case 'm':
      inCmd = atoi(optarg);
      if (inCmd == 1) {
        bMultiCam = RKADK_TRUE;
        bMultiSensor = RKADK_TRUE;
      } else if (inCmd == 2)
        bMultiSensor = RKADK_TRUE;
      break;
#endif
    case 'I':
      s32CamId = atoi(optarg);
      break;
    case 'p':
      iniPath = optarg;
      RKADK_LOGD("iniPath: %s", iniPath);
      break;
    case 'k':
      stRecAttr.u32FragKeyFrame = 1;
      break;
#ifdef ENABLE_AOV
    case 'S':
      s32SuspendTime = atoi(optarg);
      break;
    case 'P':
      pMetaPath = optarg;
      break;
    case 'M':
      s32AeMode = atoi(optarg);
      break;
    case 'r':
      rttWakeupBinPath = optarg;
      break;
#endif
    case 'l':
      loopCount = atoi(optarg);
      break;
    case 'd':
      loopDuration = atoi(optarg);
      break;
    case 'h':
    default:
      print_usage(argv[0]);
      optind = 0;
      return -1;
    }
  }
  optind = 0;

#ifdef ENABLE_AOV
  RKADK_LOGD("s32SuspendTime: %d, s32AeMode: %d", s32SuspendTime, s32AeMode);
  RKADK_LOGD("pMetaPath: %s", pMetaPath);
  RKADK_LOGD("#Rtt Wakeup Bin Path: %s", rttWakeupBinPath);

  if (RKADK_AOV_WakeupBinMmap(rttWakeupBinPath)) {
    RKADK_LOGE("rtthread wakeup bin load fail");
    return -1;
  }

  RKADK_AOV_SetSuspendTime(s32SuspendTime);
#endif

  if (bMultiSensor)
    s32CamId = 0;

  RKADK_MPI_SYS_Init();

  if (iniPath) {
    memset(path, 0, RKADK_PATH_LEN);
    memset(sensorPath, 0, RKADK_MAX_SENSOR_CNT * RKADK_PATH_LEN);
    sprintf(path, "%s/rkadk_setting.ini", iniPath);
    for (int i = 0; i < RKADK_MAX_SENSOR_CNT; i++)
      sprintf(sensorPath[i], "%s/rkadk_setting_sensor_%d.ini", iniPath, i);

    /*
    lg:
      char *sPath[] = {"/data/rkadk/rkadk_setting_sensor_0.ini",
      "/data/rkadk/rkadk_setting_sensor_1.ini", NULL};
    */
    char *sPath[] = {sensorPath[0], sensorPath[1], NULL};

    RKADK_PARAM_Init(path, sPath);
  } else {
    RKADK_PARAM_Init(NULL, NULL);
  }

record:
#ifdef RKAIQ
  stFps.enStreamType = RKADK_STREAM_TYPE_SENSOR;
  ret = RKADK_PARAM_GetCamParam(s32CamId, RKADK_PARAM_TYPE_FPS, &stFps);
  if (ret) {
    RKADK_LOGE("RKADK_PARAM_GetCamParam u32CamId[%d] fps failed", s32CamId);
    return -1;
  }

#ifdef ENABLE_AOV
  ret = RKADK_AOV_MetaMmap(&pstMetaVir, pMetaPath);
  if (ret || pstMetaVir == NULL) {
    RKADK_LOGE("RKADK_AOV_MetaMmap failed[%d]", ret);
    return -1;
  }

  wakeupParam = (struct wakeup_param_info *)pstMetaVir->wakeupParamOffset;
  wakeupParam->ae_wakeup_mode = s32AeMode;
  wakeupParam->arm_max_run_count = -1;
  wakeupParam->mcu_max_run_count = -1;

  struct sensor_iq_info *sensor_iq = (struct sensor_iq_info *)pstMetaVir->sensorIqBinOffset;
  stIspParam.iqAddr = (uint8_t *)((void *)sensor_iq + sizeof(struct sensor_iq_info));
  stIspParam.iqLen = sensor_iq->main_sensor_iq_size;
  stIspParam.aiqRttShare = pstMetaVir->wakeupAovParamOffset;
#endif

  stIspParam.WDRMode = RK_AIQ_WORKING_MODE_NORMAL;
  stIspParam.bMultiCam = bMultiCam;
  stIspParam.fps = stFps.u32Framerate;
  SAMPLE_ISP_Start(s32CamId, stIspParam);
  //IspProcess(s32CamId);

  if (bMultiCam) {
    ret = RKADK_PARAM_GetCamParam(1, RKADK_PARAM_TYPE_FPS, &stFps);
    if (ret) {
      RKADK_LOGE("RKADK_PARAM_GetCamParam u32CamId[1] fps failed");
      SAMPLE_ISP_Stop(s32CamId);
      return -1;
    }

    SAMPLE_ISP_Start(1, stIspParam);
    //IspProcess(1);
  }
#endif

  stFileCacheAttr.pSdcardPath = "/dev/mmcblk1p1";
  stFileCacheAttr.u32TotalCache = 7 * 1024 * 1024; // 7M
  stFileCacheAttr.u32WriteCache = 1024 * 1024; // 1M
  RKADK_RECORD_FileCacheInit(&stFileCacheAttr);

  stRecAttr.s32CamID = s32CamId;
  stRecAttr.pfnRequestFileNames = GetRecordFileName;
  stRecAttr.pfnEventCallback = RecordEventCallback;

#ifdef ENABLE_AOV
  stRecAttr.stAovAttr.pMetaVir = pstMetaVir;
  stRecAttr.stAovAttr.pfnWakeUpPause = SAMPLE_ISP_WakeUpPause;
  stRecAttr.stAovAttr.pfnWakeUpResume = SAMPLE_ISP_WakeUpResume;
  stRecAttr.stAovAttr.pfnSetFrameRate = SAMPLE_ISP_SET_FrameRate;
#endif

  if (RKADK_RECORD_Create(&stRecAttr, &pRecorder)) {
    RKADK_LOGE("s32CamId[%d] Create recorder failed", s32CamId);
#ifdef RKAIQ
    SAMPLE_ISP_Stop(s32CamId);
    if (bMultiCam)
      SAMPLE_ISP_Stop(1);
#endif
    return -1;
  }
  RKADK_RECORD_Start(pRecorder);

  if (bMultiSensor) {
    stRecAttr.s32CamID = 1;
    if (RKADK_RECORD_Create(&stRecAttr, &pRecorder1)) {
      RKADK_LOGE("s32CamId[1] Create recorder failed");
#ifdef RKAIQ
      SAMPLE_ISP_Stop(s32CamId);
      if (bMultiCam)
        SAMPLE_ISP_Stop(1);
#endif
      return -1;
    }

    RKADK_RECORD_Start(pRecorder1);
  }

  RKADK_LOGD("initial finish\n");

  signal(SIGINT, sigterm_handler);
  char cmd[64];
  printf("\n#Usage: input 'quit' to exit programe!\n"
         "peress any other key to quit\n");

  while (!is_quit) {
    if (loopCount >= 0) {
      sleep(loopDuration);
      if (loopCount == 0) {
        RKADK_LOGD("loop switch end!");
        is_quit = true;
        goto __EXIT;
      }

      RKADK_PARAM_GetCamParam(s32CamId, RKADK_PARAM_TYPE_RECORD_TYPE, &enRecType);
      if (enRecType == RKADK_REC_TYPE_NORMAL) {
        enRecType = RKADK_REC_TYPE_AOV_LAPSE;
        printf("\n\n\n----- switch aov lapse record -----\n");
      } else {
        printf("\n\n\n----- switch normal record -----\n");
        enRecType = RKADK_REC_TYPE_NORMAL;
      }

      RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_RECORD_TYPE, &enRecType);
      RKADK_RECORD_Reset(&pRecorder);
      RKADK_RECORD_Start(pRecorder);

      loopCount--;
    } else {
      fgets(cmd, sizeof(cmd), stdin);
      if (strstr(cmd, "quit") || is_quit) {
        RKADK_LOGD("#Get 'quit' cmd!");
        break;
      } else if (strstr(cmd, "LR")) { //Lapse Record
        enRecType = RKADK_REC_TYPE_LAPSE;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_RECORD_TYPE, &enRecType);
        RKADK_RECORD_Reset(&pRecorder);
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "NR")) { //Normal Record
        enRecType = RKADK_REC_TYPE_NORMAL;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_RECORD_TYPE, &enRecType);
        RKADK_RECORD_Reset(&pRecorder);
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "720")) {
        type = RKADK_RES_720P;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_RES, &type);
        ret = RKADK_RECORD_Reset(&pRecorder);
        if (ret < 0) {
#ifndef RV1106_1103
          RKADK_RECORD_Stop(pRecorder);
          RKADK_RECORD_Destroy(pRecorder);
          pRecorder = NULL;
#ifdef RKAIQ
          SAMPLE_ISP_Stop(stRecAttr.s32CamID);
#endif
          goto record;
#endif
        }
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "1080")) {
        type = RKADK_RES_1080P;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_RES, &type);
        ret = RKADK_RECORD_Reset(&pRecorder);
        if (ret < 0) {
#ifndef RV1106_1103
          RKADK_RECORD_Stop(pRecorder);
          RKADK_RECORD_Destroy(pRecorder);
          pRecorder = NULL;
#ifdef RKAIQ
          SAMPLE_ISP_Stop(stRecAttr.s32CamID);
#endif
          goto record;
#endif
        }
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "264")) {
        stCodecType.enCodecType = RKADK_CODEC_TYPE_H264;
        stCodecType.enStreamType = RKADK_STREAM_TYPE_VIDEO_MAIN;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_CODEC_TYPE, &stCodecType);
        stCodecType.enStreamType = RKADK_STREAM_TYPE_VIDEO_SUB;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_CODEC_TYPE, &stCodecType);
        ret = RKADK_RECORD_Reset(&pRecorder);
        if (ret < 0) {
#ifndef RV1106_1103
          RKADK_RECORD_Stop(pRecorder);
          RKADK_RECORD_Destroy(pRecorder);
          pRecorder = NULL;
#ifdef RKAIQ
          SAMPLE_ISP_Stop(stRecAttr.s32CamID);
#endif
          goto record;
#endif
        }
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "265")) {
        stCodecType.enCodecType = RKADK_CODEC_TYPE_H265;
        stCodecType.enStreamType = RKADK_STREAM_TYPE_VIDEO_MAIN;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_CODEC_TYPE, &stCodecType);
        stCodecType.enStreamType = RKADK_STREAM_TYPE_VIDEO_SUB;
        RKADK_PARAM_SetCamParam(s32CamId, RKADK_PARAM_TYPE_CODEC_TYPE, &stCodecType);
        ret = RKADK_RECORD_Reset(&pRecorder);
        if (ret < 0) {
#ifndef RV1106_1103
          RKADK_RECORD_Stop(pRecorder);
          RKADK_RECORD_Destroy(pRecorder);
          pRecorder = NULL;
#ifdef RKAIQ
          SAMPLE_ISP_Stop(stRecAttr.s32CamID);
#endif
          goto record;
#endif
        }
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "start")) {
        RKADK_RECORD_Start(pRecorder);
      } else if (strstr(cmd, "stop")) {
        RKADK_RECORD_Stop(pRecorder);
      }

      usleep(500000);
    }
  }

__EXIT:
  RKADK_RECORD_Stop(pRecorder);
  RKADK_RECORD_Destroy(pRecorder);

#ifdef RKAIQ
  SAMPLE_ISP_Stop(s32CamId);
#endif

  if (bMultiSensor) {
    RKADK_RECORD_Stop(pRecorder1);
    RKADK_RECORD_Destroy(pRecorder1);

#ifdef RKAIQ
    if (bMultiCam)
      SAMPLE_ISP_Stop(1);
#endif
  }

#ifdef ENABLE_AOV
  RKADK_AOV_MetaMunmap(pstMetaVir);
#endif

  RKADK_RECORD_FileCacheDeInit();
  RKADK_MPI_SYS_Exit();
  RKADK_LOGD("exit!");
  return 0;
}
