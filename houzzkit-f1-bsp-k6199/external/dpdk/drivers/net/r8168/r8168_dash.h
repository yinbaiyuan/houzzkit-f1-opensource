/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#ifndef _R8168_DASH_H_
#define _R8168_DASH_H_

#include <stdint.h>
#include <stdbool.h>
#include <rte_ethdev.h>
#include <rte_ethdev_core.h>

#include "r8168_base.h"
#include "r8168_hw.h"

#define HW_DASH_SUPPORT_DASH(_M)        ((_M)->HwSuppDashVer > 0)
#define HW_DASH_SUPPORT_TYPE_1(_M)        ((_M)->HwSuppDashVer == 1)
#define HW_DASH_SUPPORT_TYPE_2(_M)        ((_M)->HwSuppDashVer == 2)
#define HW_DASH_SUPPORT_TYPE_3(_M)        ((_M)->HwSuppDashVer == 3)

#define OOB_CMD_RESET       0x00
#define OOB_CMD_DRIVER_START    0x05
#define OOB_CMD_DRIVER_STOP 0x06
#define OOB_CMD_SET_IPMAC   0x41

#define ISRIMR_DASH_TYPE2_ROK BIT_0
#define ISRIMR_DASH_TYPE2_RDU BIT_1
#define ISRIMR_DASH_TYPE2_TOK BIT_2
#define ISRIMR_DASH_TYPE2_TDU BIT_3
#define ISRIMR_DASH_TYPE2_TX_FIFO_FULL BIT_4
#define ISRIMR_DASH_TYPE2_TX_DISABLE_IDLE BIT_5
#define ISRIMR_DASH_TYPE2_RX_DISABLE_IDLE BIT_6

void rtl8168_driver_start(struct rtl_hw *hw);
void rtl8168_driver_stop(struct rtl_hw *hw);

void rtl8168_dash2_disable_txrx(struct rtl_hw *hw);

int rtl8168_check_dash(struct rtl_hw *hw);
bool rtl8168_check_dash_other_fun_present(struct rtl_hw *hw);
#endif
