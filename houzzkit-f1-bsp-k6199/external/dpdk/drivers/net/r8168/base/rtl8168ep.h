/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#ifndef _RTL8168EP_H_
#define _RTL8168EP_H_

#include "../r8168_base.h"

extern const struct rtl_hw_ops rtl8111ep_ops;

void hw_init_rxcfg_8168ep(struct rtl_hw *hw);
void hw_mac_mcu_config_8168ep(struct rtl_hw *hw);
void hw_phy_mcu_config_8168ep(struct rtl_hw *hw);

#endif
