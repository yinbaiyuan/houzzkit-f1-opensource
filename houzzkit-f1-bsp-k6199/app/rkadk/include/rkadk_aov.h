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

#ifndef __RKADK_AOV_H__
#define __RKADK_AOV_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "rkadk_common.h"

#ifdef ENABLE_AOV
#include "rk_meta.h"
#include "rk_meta_wakeup_param.h"
#endif

// Memory region definitions
#define RKADK_MEAT_PHY_ADDR 0x800000

// Meta region
#define RKADK_META_SIZE (384 * 1024)

typedef struct {
  int memFd;
  void *mappedBase;
  void *metaHead;
  int metaHeadSize;
  void *paramShare2kernelOffset;
  int paramShare2kernelOffsetSize;
  void *sensorInitOffset;
  int sensorInitOffsetSize;
  void *cmdlineOffset;
  int cmdlineOffsetSize;
  void *aeTableOffset;
  int aeTableOffsetSize;
  void *appParamOffset;
  int appParamOffsetSize;
  void *secondarySensorInitOffset;
  int secondarySensorInitOffsetSize;
  void *wakeupParamOffset;
  int wakeupParamOffsetSize;
  void *reserve;
  int reserveSize;
  void *backup;
  int backupSize;
  void *sensorIqBinOffset;
  int sensorIqBinOffsetSize;
  void *secondarySensorIqBinOffset;
  int secondarySensorIqBinOffsetSize;
  void *wakeupAovParamOffset;
  int wakeupAovParamMaxSize;
} RKADK_META_PARA_VIR;

// meta
int RKADK_AOV_MetaMmap(RKADK_META_PARA_VIR **pMetaVir, char *pMetaFilePath);
int RKADK_AOV_MetaMunmap(RKADK_META_PARA_VIR *pMetaVir);
int RKADK_AOV_WakeupBinMmap(char *rtthreadWakeupBinPath);
void RKADK_AOV_EnterSleep();
int RKADK_AOV_IsExitAOV(RKADK_META_PARA_VIR *pMetaVir);
void RKADK_AOV_SetSuspendTime(int u32WakeupSuspendTime);

#ifdef __cplusplus
}
#endif
#endif
