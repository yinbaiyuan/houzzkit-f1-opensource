/*
 * Copyright (c) 2023 Rockchip, Inc. All Rights Reserved.
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
#include "rkadk_log.h"
#include "rkadk_aov.h"
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static pthread_mutex_t gWakeupRunMutex;

static void RKADK_AOV_MetaDump(RKADK_META_PARA_VIR *pMetaVir) {
  printf("pMetaVir->memFd: %d\n", pMetaVir->memFd);
  printf("pMetaVir->mappedBase: %p\n", pMetaVir->mappedBase);
  printf("pMetaVir->metaHead: %p\n", pMetaVir->metaHead);
  printf("pMetaVir->metaHeadSize: %d\n", pMetaVir->metaHeadSize);
  printf("pMetaVir->paramShare2kernelOffset: %p\n", pMetaVir->paramShare2kernelOffset);
  printf("pMetaVir->paramShare2kernelOffsetSize: %d\n", pMetaVir->paramShare2kernelOffsetSize);
  printf("pMetaVir->sensorInitOffset: %p\n", pMetaVir->sensorInitOffset);
  printf("pMetaVir->sensorInitOffsetSize: %d\n", pMetaVir->sensorInitOffsetSize);
  printf("pMetaVir->cmdlineOffset: %p\n", pMetaVir->cmdlineOffset);
  printf("pMetaVir->cmdlineOffsetSize: %d\n", pMetaVir->cmdlineOffsetSize);
  printf("pMetaVir->aeTableOffset: %p\n", pMetaVir->aeTableOffset);
  printf("pMetaVir->aeTableOffsetSize: %d\n", pMetaVir->aeTableOffsetSize);
  printf("pMetaVir->appParamOffset: %p\n", pMetaVir->appParamOffset);
  printf("pMetaVir->appParamOffsetSize: %d\n", pMetaVir->appParamOffsetSize);
  printf("pMetaVir->secondarySensorInitOffset: %p\n", pMetaVir->secondarySensorInitOffset);
  printf("pMetaVir->secondarySensorInitOffsetSize: %d\n", pMetaVir->wakeupParamOffsetSize);
  printf("pMetaVir->wakeupParamOffset: %p\n", pMetaVir->wakeupParamOffset);
  printf("pMetaVir->wakeupParamOffsetSize: %d\n", pMetaVir->secondarySensorInitOffsetSize);
  printf("pMetaVir->reserve: %p\n", pMetaVir->reserve);
  printf("pMetaVir->reserveSize: %d\n", pMetaVir->reserveSize);
  printf("pMetaVir->backup: %p\n", pMetaVir->backup);
  printf("pMetaVir->backupSize: %d\n", pMetaVir->backupSize);
  printf("pMetaVir->sensorIqBinOffset: %p\n", pMetaVir->sensorIqBinOffset);
  printf("pMetaVir->sensorIqBinOffsetSize: %d\n", pMetaVir->sensorIqBinOffsetSize);
  printf("pMetaVir->secondarySensorIqBinOffset: %p\n", pMetaVir->secondarySensorIqBinOffset);
  printf("pMetaVir->secondarySensorIqBinOffsetSize: %d\n", pMetaVir->secondarySensorIqBinOffsetSize);
  printf("meta_vir->wakeupAovParamOffset: %p\n", pMetaVir->wakeupAovParamOffset);
  printf("meta_vir->wakeupAovParamMaxSize: %d\n", pMetaVir->wakeupAovParamMaxSize);
}

int RKADK_AOV_MetaMmap(RKADK_META_PARA_VIR **ppMetaVir, char *pMetaFilePath) {
  int memFd = -1;
  void *mappedBase;
  FILE *metaFile;
  char buffer[1024];
  size_t readBytes;
  RKADK_META_PARA_VIR *pMetaVir = NULL;

  if (*ppMetaVir) {
    RKADK_LOGE("MetaVir has been mmap");
    return -1;
  }

  pMetaVir = (RKADK_META_PARA_VIR *)malloc(sizeof(RKADK_META_PARA_VIR));
  if (!pMetaVir) {
    RKADK_LOGE("malloc pMetaVir failed");
    return -1;
  }
  memset(pMetaVir, 0, sizeof(RKADK_META_PARA_VIR));

  memFd = open("/dev/mem", O_RDWR | O_SYNC);
  if (memFd == -1) {
    RKADK_LOGE("Error opening /dev/mem");
    return -1;
  }

  mappedBase = mmap(0, RKADK_META_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, memFd, RKADK_MEAT_PHY_ADDR);
  if (mappedBase == MAP_FAILED) {
    RKADK_LOGE("Error mapping physical address to virtual address");
    close(memFd);
    return -1;
  }

  pMetaVir->memFd = memFd;
  pMetaVir->mappedBase = mappedBase;
  pMetaVir->metaHead = mappedBase + META_INFO_HEAD_OFFSET;
  pMetaVir->metaHeadSize = META_INFO_SIZE;
  pMetaVir->paramShare2kernelOffset = mappedBase + PARAM_SHARE2KERNEL_OFFSET;
  pMetaVir->paramShare2kernelOffsetSize = PARAM_SHARE2KERNEL_SIZE;
  pMetaVir->sensorInitOffset = mappedBase + SENSOR_INIT_OFFSET;
  pMetaVir->sensorInitOffsetSize = SENSOR_INIT_MAX_SIZE;
  pMetaVir->cmdlineOffset = mappedBase + CMDLINE_OFFSET;
  pMetaVir->cmdlineOffsetSize = CMDLINE_MAX_SIZE;
  pMetaVir->aeTableOffset = mappedBase + AE_TABLE_OFFSET;
  pMetaVir->aeTableOffsetSize = AE_TABLE_MAX_SIZE;
  pMetaVir->appParamOffset = mappedBase + APP_PARAM_OFFSET;
  pMetaVir->appParamOffsetSize = APP_PARAM_MAX_SIZE;
  pMetaVir->secondarySensorInitOffset = mappedBase + SECONDARY_SENSOR_INIT_OFFSET;
  pMetaVir->secondarySensorInitOffsetSize = SECONDARY_SENSOR_INIT_MAX_SIZE;
  pMetaVir->wakeupParamOffset = mappedBase + WAKEUP_PARAM_OFFSET;
  pMetaVir->wakeupParamOffsetSize = WAKEUP_PARAM_MAX_SIZE;
  pMetaVir->sensorIqBinOffset = mappedBase + SENSOR_IQ_BIN_OFFSET;
  pMetaVir->sensorIqBinOffsetSize = SENSOR_IQ_BIN_MAX_SIZE;
  pMetaVir->secondarySensorIqBinOffset = mappedBase + SECONDARY_SENSOR_IQ_BIN_OFFSET;
  pMetaVir->wakeupAovParamOffset = mappedBase + WAKEUP_AOV_PARAM_OFFSET;
  pMetaVir->wakeupAovParamMaxSize = WAKEUP_AOV_PARAM_MAX_SIZE;

#if 1
  RKADK_AOV_MetaDump(pMetaVir);
#endif

  // Write pMetaFilePath content to mappedBase
  if (access(pMetaFilePath, F_OK) == 0) {
    metaFile = fopen(pMetaFilePath, "r");
    if (metaFile == NULL) {
      RKADK_LOGE("Error opening meta file");
      munmap(mappedBase, RKADK_META_SIZE);
      close(memFd);
      return -1;
    }

    while ((readBytes = fread(buffer, 1, sizeof(buffer), metaFile)) > 0) {
      memcpy(mappedBase, buffer, readBytes);
      mappedBase += readBytes;
    }

    fclose(metaFile);
  }

  // init mcu mode
  struct wakeup_param_info *pWakeupParam = (struct wakeup_param_info *)pMetaVir->wakeupParamOffset;
  pWakeupParam->wakeup_mode = 0;
  pWakeupParam->ae_wakeup_mode = 0;
  pWakeupParam->arm_run_count = 0;
  pWakeupParam->arm_max_run_count = -1;
  pWakeupParam->mcu_run_count = 0;
  pWakeupParam->mcu_max_run_count = -1;

  *ppMetaVir = pMetaVir;
  pthread_mutex_init(&gWakeupRunMutex, NULL);
  return 0;
}

int RKADK_AOV_MetaMunmap(RKADK_META_PARA_VIR *pMetaVir) {
  RKADK_CHECK_POINTER(pMetaVir, RKADK_FAILURE);

  if (pMetaVir->mappedBase)
    munmap(pMetaVir->mappedBase, RKADK_META_SIZE);

  if (pMetaVir->memFd >= 0)
    close(pMetaVir->memFd);

  free(pMetaVir);
  pMetaVir = NULL;
  pthread_mutex_destroy(&gWakeupRunMutex);
  return 0;
}

static int RKADK_AOV_GetWakeupBinInfo(uint32_t *addr, uint32_t *size) {
#define RTT_BIN_PARAM "/proc/device-tree/reserved-memory/rtos@40000/reg"
#define uswap_32(x)                                                                      \
  ((((x)&0xff000000) >> 24) | (((x)&0x00ff0000) >> 8) | (((x)&0x0000ff00) << 8) |      \
   (((x)&0x000000ff) << 24))

  int rttBinParamFd = -1;
  struct RttBinParam {
    unsigned int addr;
    unsigned int size;
  };

  struct RttBinParam binParam = {0, 0};
  if ((rttBinParamFd = open(RTT_BIN_PARAM, O_RDONLY)) < 0) {
    RKADK_LOGE("cannot open [%s]", RTT_BIN_PARAM);
    return -1;
  }

  if (read(rttBinParamFd, (void *)&binParam, sizeof(binParam)) == -1) {
    RKADK_LOGE("read log param error");
    if (rttBinParamFd != -1)
      close(rttBinParamFd);
    return -1;
  }

  if (rttBinParamFd != -1)
    close(rttBinParamFd);

  binParam.addr = uswap_32(binParam.addr);
  binParam.size = uswap_32(binParam.size);
  RKADK_LOGD("rtt wakeup bin addr [%#x]", binParam.addr);
  RKADK_LOGD("rtt wakeup bin size [%#x]", binParam.size);

  *addr = binParam.addr;
  *size = binParam.size;
  return 0;
}

int RKADK_AOV_WakeupBinMmap(char *rtthreadWakeupBinPath) {
  int memFd = -1;
  uint32_t rttBinAddr, rttBinMaxSize;
  void *mappedBase;
  char buffer[1024];
  size_t read_bytes;

  if (access(rtthreadWakeupBinPath, F_OK) != 0) {
    RKADK_LOGE("read rtt wakeup bin info error, please ensure you needn't it");
    return 0;
  }

  if (RKADK_AOV_GetWakeupBinInfo(&rttBinAddr, &rttBinMaxSize) != 0)
    return -1;

  FILE *rttBinFile = fopen(rtthreadWakeupBinPath, "r");
  if (rttBinFile == NULL) {
    RKADK_LOGE("Error opening meta file");
    close(memFd);
    return -1;
  }

  memFd = open("/dev/mem", O_RDWR | O_SYNC);
  if (memFd == -1) {
    RKADK_LOGE("Error opening /dev/mem");
    fclose(rttBinFile);
    return -1;
  }

  mappedBase = mmap(0, rttBinMaxSize, PROT_READ | PROT_WRITE, MAP_SHARED, memFd, rttBinAddr);
  if (mappedBase == MAP_FAILED) {
    RKADK_LOGE("Error mapping physical address to virtual address");
    fclose(rttBinFile);
    close(memFd);
    return EXIT_FAILURE;
  }

  memset(mappedBase, 0, rttBinMaxSize);
  while ((read_bytes = fread(buffer, 1, sizeof(buffer), rttBinFile)) > 0) {
    memcpy(mappedBase, buffer, read_bytes);
    mappedBase += read_bytes;
  }

  fclose(rttBinFile);
  munmap(mappedBase, rttBinMaxSize);
  close(memFd);

  return 0;
}

int RKADK_AOV_IsExitAOV(RKADK_META_PARA_VIR *pMetaVir) {
  struct wakeup_param_info *pWakeupParam = NULL;

  RKADK_CHECK_POINTER(pMetaVir, 1);
  RKADK_CHECK_POINTER(pMetaVir->wakeupParamOffset, 1);

  pWakeupParam = (struct wakeup_param_info *)pMetaVir->wakeupParamOffset;
  if (pWakeupParam->arm_max_run_count != -1 &&
      pWakeupParam->arm_run_count > pWakeupParam->arm_max_run_count) {
    RKADK_LOGD("Exit wakeupe arm_run_count = %d,%d, mcu_run_count = %d,%d",
           pWakeupParam->arm_run_count, pWakeupParam->arm_max_run_count,
           pWakeupParam->mcu_run_count, pWakeupParam->mcu_max_run_count);
    return 1;
  }

  if (pWakeupParam->mcu_max_run_count != -1 &&
      pWakeupParam->mcu_run_count > pWakeupParam->mcu_max_run_count) {
    RKADK_LOGD("Exit wakeupe arm_run_count = %d,%d, mcu_run_count = %d,%d",
           pWakeupParam->arm_run_count, pWakeupParam->arm_max_run_count,
           pWakeupParam->mcu_run_count, pWakeupParam->mcu_max_run_count);
    return 1;
  }

  return 0;
}

void RKADK_AOV_EnterSleep() {
  FILE *file;
  const char *state = "mem";
  size_t writtenBytes;

  pthread_mutex_lock(&gWakeupRunMutex);

  //open file
  file = fopen("/sys/power/state", "w");
  if (file == NULL) {
    RKADK_LOGE("Failed to open /sys/power/state");
    pthread_mutex_unlock(&gWakeupRunMutex);
    exit(EXIT_FAILURE);
  }

  RKADK_LOGD("start echo mem > /sys/power/state");

  //enter sleep
  writtenBytes = fwrite(state, sizeof(char), strlen(state), file);
  if (writtenBytes != strlen(state)) {
    RKADK_LOGE("Failed to write to /sys/power/state");
    fclose(file);
    pthread_mutex_unlock(&gWakeupRunMutex);
    exit(EXIT_FAILURE);
  }

  fflush(file);
  fclose(file);

  pthread_mutex_unlock(&gWakeupRunMutex);
}

void RKADK_AOV_SetSuspendTime(int u32WakeupSuspendTime) {
  char wakeupCmd[256];

  memset(wakeupCmd, 0, 256);
  sprintf(wakeupCmd, "io -4 0xff300048 %d", u32WakeupSuspendTime * 32);
  system(wakeupCmd);
  RKADK_LOGD("wakeup susoend time = %d", u32WakeupSuspendTime);
}
