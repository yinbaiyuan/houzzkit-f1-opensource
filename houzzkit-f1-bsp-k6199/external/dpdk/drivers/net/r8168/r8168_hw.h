/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#ifndef _R8168_HW_H_
#define _R8168_HW_H_

#include <stdint.h>
#include <rte_ethdev.h>
#include <rte_ethdev_core.h>

#include "r8168_base.h"
#include "r8168_dash.h"

#define HW_SUPP_SERDES_PHY(_M)        ((_M)->HwSuppSerDesPhyVer > 0)
#define HW_HAS_WRITE_PHY_MCU_RAM_CODE(_M)        (((_M)->HwHasWrRamCodeToMicroP == TRUE) ? 1 : 0)
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

#define NO_BASE_ADDRESS 0x00000000
#define RTL8168FP_OOBMAC_BASE 0xBAF70000
#define RTL8168FP_CMAC_IOBASE 0xBAF20000
#define RTL8168FP_KVM_BASE 0xBAF80400
#define CMAC_SYNC_REG 0x20
#define CMAC_RXDESC_OFFSET 0x90    //RX: 0x90 - 0x98
#define CMAC_TXDESC_OFFSET 0x98    //TX: 0x98 - 0x9F

//Channel Wait Count
#define R8168_CHANNEL_WAIT_COUNT (20000)
#define R8168_CHANNEL_WAIT_TIME (1)  // 1us
#define R8168_CHANNEL_EXIT_DELAY_TIME (20)  //20us

u16 rtl8168_mac_ocp_read(struct rtl_hw *hw, u16 addr);
void rtl8168_mac_ocp_write(struct rtl_hw *hw, u16 addr, u16 value);

void ClearAndSetPCIePhyBit(struct rtl_hw *hw, u8 addr, u16 clearmask, u16 setmask);
void ClearPCIePhyBit(struct rtl_hw *hw, u8 addr, u16 mask);
void SetPCIePhyBit( struct rtl_hw *hw, u8 addr, u16 mask);

u16 rtl8168_ephy_read(struct rtl_hw *hw, int addr);
void rtl8168_ephy_write(struct rtl_hw *hw, int addr, int value);

u32 rtl8168_mdio_read(struct rtl_hw *hw, u32 addr);
void rtl8168_mdio_write(struct rtl_hw *hw, u32 addr, u32 value);

u32 rtl8168_eri_read(struct rtl_hw *hw, int addr, int len, int type);
int rtl8168_eri_write(struct rtl_hw *hw, int addr, int len, u32 value, int type);

u32 rtl8168_csi_read(struct rtl_hw *hw, u32 addr);
u32 rtl8168_csi_other_fun_read(struct rtl_hw *hw, u8 multi_fun_sel_bit, u32 addr);
void rtl8168_csi_other_fun_write(struct rtl_hw *hw, u8 multi_fun_sel_bit, u32 addr, u32 value);

void rtl8168_get_mac_version(struct rtl_hw *hw);
int rtl8168_get_mac_address(struct rtl_hw *hw, struct rte_ether_addr *ea);

void rtl8168_enable_cfg9346_write(struct rtl_hw *hw);
void rtl8168_disable_cfg9346_write(struct rtl_hw *hw);

void rtl8168_rar_set(struct rtl_hw *hw, uint8_t *addr);

void rtl8168_wait_txrx_fifo_empty(struct rtl_hw *hw);

void rtl8168_disable_now_is_oob(struct rtl_hw *hw);
void rtl8168_init_ll_share_fifo(struct rtl_hw *hw);

void rtl8168_hw_disable_mac_mcu_bps(struct rtl_hw *hw);

void rtl8168_disable_aspm_clkreq_internal(struct rtl_hw *hw);
void rtl8168_disable_ups(struct rtl_hw *hw);
void rtl8168_disable_dma_agg(struct rtl_hw *hw);

void rtl8168_enable_rxdvgate(struct rtl_hw *hw);
void rtl8168_disable_rxdvgate(struct rtl_hw *hw);

void rtl8168_init_software_variable(struct rtl_hw *hw);
void rtl8168_link_option(u8 *aut, u32 *spd, u8 *dup, u32 *adv);

void rtl8168_get_tally_stats(struct rtl_hw *hw, struct rte_eth_stats *stats);
void rtl8168_clear_tally_stats(struct rtl_hw *hw);

void rtl8168_exit_oob(struct rtl_hw *hw);
void rtl8168_nic_reset(struct rtl_hw *hw);

void rtl8168_set_hw_ops(struct rtl_hw *hw);

u32 rtl8168_ocp_read(struct rtl_hw *hw, u16 addr, u8 len);
void rtl8168_ocp_write(struct rtl_hw *hw, u16 addr, u8 len, u32 value);
void rtl8168_oob_mutex_lock(struct rtl_hw *hw);
void rtl8168_oob_mutex_unlock(struct rtl_hw *hw);

void rtl8168_csi_write(struct rtl_hw *hw, u32 addr, u32 value);

void rtl8168_clear_mcu_ocp_bit(struct rtl_hw *hw, u16 addr, u16 mask);
void rtl8168_set_mcu_ocp_bit(struct rtl_hw *hw, u16 addr, u16 mask);

#endif
