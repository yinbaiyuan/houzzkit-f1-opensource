/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include <sys/queue.h>
#include <stdio.h>
#include <errno.h>
#include <stdint.h>
#include <stdarg.h>

#include <rte_ether.h>
#include <ethdev_driver.h>

#include "r8168_base.h"
#include "r8168_dash.h"
#include "r8168_hw.h"
#include "base/rtl8168g.h"
#include "base/rtl8168h.h"
#include "base/rtl8168ep.h"
#include "base/rtl8168fp.h"

static u32 real_ocp_read(struct rtl_hw *hw, u16 addr, u8 len);
static int real_ocp_write(struct rtl_hw *hw, u16 addr, u8 len, u32 value);
static void rtl8168_clear_and_set_mcu_ocp_bit(struct rtl_hw *hw, u16 addr, u16 clearmask, u16 setmask);

void rtl8168_mac_ocp_write(struct rtl_hw *hw, u16 addr, u16 value)
{
        u32 data32;

        data32 = addr/2;
        data32 <<= OCPR_Addr_Reg_shift;
        data32 += value;
        data32 |= OCPR_Write;

        RTL_W32(hw, MACOCP, data32);
}

u16 rtl8168_mac_ocp_read(struct rtl_hw *hw, u16 addr)
{
        u32 data32;
        u16 data16 = 0;

        data32 = addr/2;
        data32 <<= OCPR_Addr_Reg_shift;

        RTL_W32(hw, MACOCP, data32);
        data16 = (u16)RTL_R32(hw, MACOCP);

        return data16;
}

void
rtl8168_clear_mcu_ocp_bit(
        struct rtl_hw *hw,
        u16   addr,
        u16   mask
)
{
        rtl8168_clear_and_set_mcu_ocp_bit(hw,
                                          addr,
                                          mask,
                                          0
                                         );
}

void ClearAndSetPCIePhyBit(struct rtl_hw *hw, u8 addr, u16 clearmask, u16 setmask)
{
        u16 EphyValue;

        EphyValue = rtl8168_ephy_read(hw, addr);
        EphyValue &= ~clearmask;
        EphyValue |= setmask;
        rtl8168_ephy_write(hw, addr, EphyValue);
}

void ClearPCIePhyBit(struct rtl_hw *hw, u8 addr, u16 mask)
{
        ClearAndSetPCIePhyBit( hw, addr, mask, 0);
}

void SetPCIePhyBit( struct rtl_hw *hw, u8 addr, u16 mask)
{
        ClearAndSetPCIePhyBit( hw, addr, 0, mask);
}

void rtl8168_ephy_write(struct rtl_hw *hw, int addr, int value)
{
        int i;

        RTL_W32(hw, EPHYAR,
                EPHYAR_Write |
                (addr & EPHYAR_Reg_Mask) << EPHYAR_Reg_shift |
                (value & EPHYAR_Data_Mask));

        for (i = 0; i < 10; i++) {
                udelay(100);

                /* Check if the RTL8168 has completed EPHY write */
                if (!(RTL_R32(hw, EPHYAR) & EPHYAR_Flag))
                        break;
        }

        udelay(20);
}

u16 rtl8168_ephy_read(struct rtl_hw *hw, int addr)
{
        int i;
        u16 value = 0xffff;

        RTL_W32(hw, EPHYAR,
                EPHYAR_Read | (addr & EPHYAR_Reg_Mask) << EPHYAR_Reg_shift);

        for (i = 0; i < 10; i++) {
                udelay(100);

                /* Check if the RTL8168 has completed EPHY read */
                if (RTL_R32(hw, EPHYAR) & EPHYAR_Flag) {
                        value = (u16) (RTL_R32(hw, EPHYAR) & EPHYAR_Data_Mask);
                        break;
                }
        }

        udelay(20);

        return value;
}

static u32 rtl8168_eri_read_with_oob_base_address(struct rtl_hw *hw, int addr, int len, int type, const u32 base_address)
{
        int i, val_shift, shift = 0;
        u32 value1, value2 = 0, mask;
        u32 eri_cmd;
        const u32 transformed_base_address = ((base_address & 0x00FFF000) << 6) | (base_address & 0x000FFF);

        if (len > 4 || len <= 0)
                return -1;

        while (len > 0) {
                val_shift = addr % ERIAR_Addr_Align;
                addr = addr & ~0x3;

                eri_cmd = ERIAR_Read |
                          transformed_base_address |
                          type << ERIAR_Type_shift |
                          ERIAR_ByteEn << ERIAR_ByteEn_shift |
                          (addr & 0x0FFF);
                if (addr & 0xF000) {
                        u32 tmp;

                        tmp = addr & 0xF000;
                        tmp >>= 12;
                        eri_cmd |= (tmp << 20) & 0x00F00000;
                }

                RTL_W32(hw, ERIAR, eri_cmd);

                for (i = 0; i < 10; i++) {
                        udelay(100);

                        /* Check if the RTL8168 has completed ERI read */
                        if (RTL_R32(hw, ERIAR) & ERIAR_Flag)
                                break;
                }

                if (len == 1)       mask = (0xFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 2)  mask = (0xFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 3)  mask = (0xFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else            mask = (0xFFFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;

                value1 = RTL_R32(hw, ERIDR) & mask;
                value2 |= (value1 >> val_shift * 8) << shift * 8;

                if (len <= 4 - val_shift) {
                        len = 0;
                } else {
                        len -= (4 - val_shift);
                        shift = 4 - val_shift;
                        addr += 4;
                }
        }

        udelay(20);

        return value2;
}

u32 rtl8168_eri_read(struct rtl_hw *hw, int addr, int len, int type)
{
        return rtl8168_eri_read_with_oob_base_address(hw, addr, len, type, 0);
}

static int rtl8168_eri_write_with_oob_base_address(struct rtl_hw *hw, int addr, int len, u32 value, int type, const u32 base_address)
{
        int i, val_shift, shift = 0;
        u32 value1, mask;
        u32 eri_cmd;
        const u32 transformed_base_address = ((base_address & 0x00FFF000) << 6) | (base_address & 0x000FFF);

        if (len > 4 || len <= 0)
                return -1;

        while (len > 0) {
                val_shift = addr % ERIAR_Addr_Align;
                addr = addr & ~0x3;

                if (len == 1)       mask = (0xFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 2)  mask = (0xFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 3)  mask = (0xFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else            mask = (0xFFFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;

                value1 = rtl8168_eri_read_with_oob_base_address(hw, addr, 4, type, base_address) & ~mask;
                value1 |= ((value << val_shift * 8) >> shift * 8);

                RTL_W32(hw, ERIDR, value1);

                eri_cmd = ERIAR_Write |
                          transformed_base_address |
                          type << ERIAR_Type_shift |
                          ERIAR_ByteEn << ERIAR_ByteEn_shift |
                          (addr & 0x0FFF);
                if (addr & 0xF000) {
                        u32 tmp;

                        tmp = addr & 0xF000;
                        tmp >>= 12;
                        eri_cmd |= (tmp << 20) & 0x00F00000;
                }

                RTL_W32(hw, ERIAR, eri_cmd);

                for (i = 0; i < 10; i++) {
                        udelay(100);

                        /* Check if the RTL8168 has completed ERI write */
                        if (!(RTL_R32(hw, ERIAR) & ERIAR_Flag))
                                break;
                }

                if (len <= 4 - val_shift) {
                        len = 0;
                } else {
                        len -= (4 - val_shift);
                        shift = 4 - val_shift;
                        addr += 4;
                }
        }

        udelay(20);

        return 0;
}

int rtl8168_eri_write(struct rtl_hw *hw, int addr, int len, u32 value, int type)
{
        return rtl8168_eri_write_with_oob_base_address(hw, addr, len, value, type, NO_BASE_ADDRESS);
}

u32 rtl8168_csi_other_fun_read(struct rtl_hw *hw,
                               u8 multi_fun_sel_bit,
                               u32 addr)
{
        u32 cmd;
        int i;
        u32 value = 0;

        cmd = CSIAR_Read | CSIAR_ByteEn << CSIAR_ByteEn_shift | (addr & CSIAR_Addr_Mask);

        if (hw->mcfg != CFG_METHOD_20 && hw->mcfg != CFG_METHOD_23 &&
            hw->mcfg != CFG_METHOD_26 && hw->mcfg != CFG_METHOD_27 &&
            hw->mcfg != CFG_METHOD_28 && hw->mcfg != CFG_METHOD_31 &&
            hw->mcfg != CFG_METHOD_32 && hw->mcfg != CFG_METHOD_33 &&
            hw->mcfg != CFG_METHOD_34) {
                multi_fun_sel_bit = 0;
        }

        if (multi_fun_sel_bit > 7) {
                return 0xffffffff;
        }

        cmd |= multi_fun_sel_bit << 16;

        RTL_W32(hw, CSIAR, cmd);

        for (i = 0; i < R8168_CHANNEL_WAIT_COUNT; i++) {
                udelay(R8168_CHANNEL_WAIT_TIME);

                /* Check if the RTL8168 has completed CSI read */
                if (RTL_R32(hw, CSIAR) & CSIAR_Flag) {
                        value = (u32)RTL_R32(hw, CSIDR);
                        break;
                }
        }

        udelay(R8168_CHANNEL_EXIT_DELAY_TIME);

        return value;
}

void rtl8168_csi_other_fun_write(struct rtl_hw *hw,
                                 u8 multi_fun_sel_bit,
                                 u32 addr,
                                 u32 value)
{
        u32 cmd;
        int i;

        RTL_W32(hw, CSIDR, value);
        cmd = CSIAR_Write | CSIAR_ByteEn << CSIAR_ByteEn_shift | (addr & CSIAR_Addr_Mask);
        if (hw->mcfg != CFG_METHOD_20 && hw->mcfg != CFG_METHOD_23 &&
            hw->mcfg != CFG_METHOD_26 && hw->mcfg != CFG_METHOD_27 &&
            hw->mcfg != CFG_METHOD_28 && hw->mcfg != CFG_METHOD_31 &&
            hw->mcfg != CFG_METHOD_32 && hw->mcfg != CFG_METHOD_33 &&
            hw->mcfg != CFG_METHOD_34) {
                multi_fun_sel_bit = 0;
        }

        if (multi_fun_sel_bit > 7) {
                return;
        }

        cmd |= multi_fun_sel_bit << 16;

        RTL_W32(hw, CSIAR, cmd);

        for (i = 0; i < R8168_CHANNEL_WAIT_COUNT; i++) {
                udelay(R8168_CHANNEL_WAIT_TIME);

                /* Check if the RTL8168 has completed CSI write */
                if (!(RTL_R32(hw, CSIAR) & CSIAR_Flag))
                        break;
        }

        udelay(R8168_CHANNEL_EXIT_DELAY_TIME);
}

void
rtl8168_csi_write(struct rtl_hw *hw, u32 addr, u32 value)
{
        u8 multi_fun_sel_bit;

        if (hw->mcfg == CFG_METHOD_20)
                multi_fun_sel_bit = 2;
        else if (hw->mcfg == CFG_METHOD_26 || hw->mcfg == CFG_METHOD_31 ||
                 hw->mcfg == CFG_METHOD_32 || hw->mcfg == CFG_METHOD_33 ||
                 hw->mcfg == CFG_METHOD_34)
                multi_fun_sel_bit = 1;
        else
                multi_fun_sel_bit = 0;

        rtl8168_csi_other_fun_write(hw, multi_fun_sel_bit, addr, value);
}

u32 rtl8168_csi_read(struct rtl_hw *hw, u32 addr)
{
        u8 multi_fun_sel_bit;

        if (hw->mcfg == CFG_METHOD_20)
                multi_fun_sel_bit = 2;
        else if (hw->mcfg == CFG_METHOD_26 || hw->mcfg == CFG_METHOD_31 ||
                 hw->mcfg == CFG_METHOD_32 || hw->mcfg == CFG_METHOD_33 ||
                 hw->mcfg == CFG_METHOD_34)
                multi_fun_sel_bit = 1;
        else
                multi_fun_sel_bit = 0;

        return rtl8168_csi_other_fun_read(hw, multi_fun_sel_bit, addr);
}

void rtl8168_get_mac_version(struct rtl_hw *hw)
{
        u32 reg,val32;
        u32 ICVerID;

        val32 = RTL_R32(hw, TxConfig);
        reg = val32 & 0x7c800000;
        ICVerID = val32 & 0x00700000;

        hw->HwSuppPhyOcpVer = 0;
        hw->HwHasWrRamCodeToMicroP = 0;

        switch (reg) {
        case 0x30000000:
                hw->mcfg = CFG_METHOD_1;
                hw->efuse_ver = EFUSE_NOT_SUPPORT;
                break;
        case 0x38000000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_2;
                } else if (ICVerID == 0x00500000) {
                        hw->mcfg = CFG_METHOD_3;
                } else {
                        hw->mcfg = CFG_METHOD_3;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_NOT_SUPPORT;
                break;
        case 0x3C000000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_4;
                } else if (ICVerID == 0x00200000) {
                        hw->mcfg = CFG_METHOD_5;
                } else if (ICVerID == 0x00400000) {
                        hw->mcfg = CFG_METHOD_6;
                } else {
                        hw->mcfg = CFG_METHOD_6;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_NOT_SUPPORT;
                break;
        case 0x3C800000:
                if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_7;
                } else if (ICVerID == 0x00300000) {
                        hw->mcfg = CFG_METHOD_8;
                } else {
                        hw->mcfg = CFG_METHOD_8;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_NOT_SUPPORT;
                break;
        case 0x28000000:
                if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_9;
                } else if (ICVerID == 0x00300000) {
                        hw->mcfg = CFG_METHOD_10;
                } else {
                        hw->mcfg = CFG_METHOD_10;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V1;
                break;
        case 0x28800000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_11;
                } else if (ICVerID == 0x00200000) {
                        hw->mcfg = CFG_METHOD_12;
                        RTL_W32(hw, 0xD0, RTL_R32(hw, 0xD0) | 0x00020000);
                } else if (ICVerID == 0x00300000) {
                        hw->mcfg = CFG_METHOD_13;
                } else {
                        hw->mcfg = CFG_METHOD_13;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V1;
                break;
        case 0x2C000000:
                if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_14;
                } else if (ICVerID == 0x00200000) {
                        hw->mcfg = CFG_METHOD_15;
                } else {
                        hw->mcfg = CFG_METHOD_15;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V2;
                break;
        case 0x2C800000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_16;
                } else if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_17;
                } else {
                        hw->mcfg = CFG_METHOD_17;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x48000000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_18;
                } else if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_19;
                } else {
                        hw->mcfg = CFG_METHOD_19;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x48800000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_20;
                } else {
                        hw->mcfg = CFG_METHOD_20;
                        hw->HwIcVerUnknown = TRUE;
                }

                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x4C000000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_21;
                } else if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_22;
                } else {
                        hw->mcfg = CFG_METHOD_22;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x50000000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_23;
                } else if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_27;
                } else if (ICVerID == 0x00200000) {
                        hw->mcfg = CFG_METHOD_28;
                } else {
                        hw->mcfg = CFG_METHOD_28;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x50800000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_24;
                } else if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_25;
                } else {
                        hw->mcfg = CFG_METHOD_25;
                        hw->HwIcVerUnknown = TRUE;
                }
                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x5C800000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_26;
                } else {
                        hw->mcfg = CFG_METHOD_26;
                        hw->HwIcVerUnknown = TRUE;
                }

                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x54000000:
                if (ICVerID == 0x00000000) {
                        hw->mcfg = CFG_METHOD_29;
                } else if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_30;
                } else {
                        hw->mcfg = CFG_METHOD_30;
                        hw->HwIcVerUnknown = TRUE;
                }

                if (hw->mcfg == CFG_METHOD_30 &&
                    (rtl8168_mac_ocp_read(hw, 0xD006) & 0xFF00) == 0x0100)
                        hw->mcfg = CFG_METHOD_35;

                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        case 0x54800000:
                if (ICVerID == 0x00100000) {
                        hw->mcfg = CFG_METHOD_31;
                } else if (ICVerID == 0x00200000) {
                        hw->mcfg = CFG_METHOD_32;
                } else if (ICVerID == 0x00300000) {
                        hw->mcfg = CFG_METHOD_33;
                } else if (ICVerID == 0x00400000) {
                        hw->mcfg = CFG_METHOD_34;
                } else {
                        hw->mcfg = CFG_METHOD_34;
                        hw->HwIcVerUnknown = TRUE;
                }

                hw->efuse_ver = EFUSE_SUPPORT_V3;
                break;
        default:
                hw->mcfg = CFG_METHOD_DEFAULT;
                hw->HwIcVerUnknown = TRUE;
                hw->efuse_ver = EFUSE_NOT_SUPPORT;
                break;
        }
}

void rtl8168_enable_cfg9346_write(struct rtl_hw *hw)
{
        RTL_W8(hw, Cfg9346, RTL_R8(hw, Cfg9346) | Cfg9346_Unlock);
}

void rtl8168_disable_cfg9346_write(struct rtl_hw *hw)
{
        RTL_W8(hw, Cfg9346, RTL_R8(hw, Cfg9346) & ~Cfg9346_Unlock);
}

void rtl8168_rar_set(struct rtl_hw *hw, uint8_t *addr)
{
        uint32_t rar_low = 0;
        uint32_t rar_high = 0;

        rar_low = ((uint32_t) addr[0] |
                   ((uint32_t) addr[1] << 8) |
                   ((uint32_t) addr[2] << 16) |
                   ((uint32_t) addr[3] << 24));

        rar_high = ((uint32_t) addr[4] |
                    ((uint32_t) addr[5] << 8));

        rtl8168_enable_cfg9346_write(hw);
        RTL_W32(hw, MAC0, rar_low);
        RTL_W32(hw, MAC4, rar_high);

        switch (hw->mcfg) {
        case CFG_METHOD_14:
        case CFG_METHOD_15:
                RTL_W32(hw, SecMAC0, rar_low);
                RTL_W16(hw, SecMAC4, (uint16_t)rar_high);
                break;
        }

        if (hw->mcfg == CFG_METHOD_17) {
                rtl8168_eri_write(hw, 0xf0, 4, rar_low << 16, ERIAR_ExGMAC);
                rtl8168_eri_write(hw, 0xf4, 4, rar_low >> 16 | rar_high << 16, ERIAR_ExGMAC);
        }

        rtl8168_disable_cfg9346_write(hw);
}

int rtl8168_get_mac_address(struct rtl_hw *hw, struct rte_ether_addr *ea)
{
        int i;
        u8 mac_addr[MAC_ADDR_LEN];

        for (i = 0; i < MAC_ADDR_LEN; i++)
                mac_addr[i] = RTL_R8(hw, MAC0 + i);

        switch (hw->mcfg) {
        case CFG_METHOD_18 ... CFG_METHOD_35:
                *(u32*)&mac_addr[0] = rtl8168_eri_read(hw, 0xE0, 4, ERIAR_ExGMAC);
                *(u16*)&mac_addr[4] = rtl8168_eri_read(hw, 0xE4, 2, ERIAR_ExGMAC);
                break;
        default:
                break;
        }

        rte_ether_addr_copy((struct rte_ether_addr *)mac_addr, ea);

        return 0;
}

void rtl8168_set_hw_ops(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        //8111G
        case CFG_METHOD_21:
        case CFG_METHOD_22:
        //8111GU
        case CFG_METHOD_24:
        case CFG_METHOD_25:
                hw->hw_ops = rtl8111g_ops;
                break;
        //8111EP
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
                hw->hw_ops = rtl8111ep_ops;
                break;
        //8111H
        case CFG_METHOD_29:
        case CFG_METHOD_30:
        case CFG_METHOD_35:
                hw->hw_ops = rtl8111h_ops;
                break;
        //8111FP
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                hw->hw_ops = rtl8111fp_ops;
                break;
        default:
                hw->hw_ops = rtl8111g_ops;
                break;
        }
}

void rtl8168_wait_txrx_fifo_empty(struct rtl_hw *hw)
{
        int i;
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                for (i = 0; i < 10; i++) {
                        udelay(100);
                        if (RTL_R32(hw, TxConfig) & BIT_11)
                                break;
                }

                for (i = 0; i < 10; i++) {
                        udelay(100);
                        if ((RTL_R8(hw, MCUCmd_reg) & (Txfifo_empty | Rxfifo_empty)) == (Txfifo_empty | Rxfifo_empty))
                                break;

                }

                mdelay(1);
                break;
        }
}

static void rtl8168_wait_ll_share_fifo_ready(struct rtl_hw *hw)
{
        int i;

        for (i = 0; i < 10; i++) {
                udelay(100);
                if (RTL_R16(hw, 0xD2) & BIT_9)
                        break;
        }
}

void rtl8168_disable_now_is_oob(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                RTL_W8(hw, MCUCmd_reg, RTL_R8(hw, MCUCmd_reg) & ~Now_is_oob);
                break;
        }
}

void rtl8168_init_ll_share_fifo(struct rtl_hw *hw)
{
        u16 data16;

        switch (hw->mcfg) {
        case CFG_METHOD_20:
                rtl8168_wait_ll_share_fifo_ready(hw);

                data16 = rtl8168_mac_ocp_read(hw, 0xD4DE) | BIT_15;
                rtl8168_mac_ocp_write(hw, 0xD4DE, data16);

                rtl8168_wait_ll_share_fifo_ready(hw);
                break;
        case CFG_METHOD_21 ... CFG_METHOD_35:

                data16 = rtl8168_mac_ocp_read(hw, 0xE8DE) & ~BIT_14;
                rtl8168_mac_ocp_write(hw, 0xE8DE, data16);
                rtl8168_wait_ll_share_fifo_ready(hw);

                data16 = rtl8168_mac_ocp_read(hw, 0xE8DE) | BIT_15;
                rtl8168_mac_ocp_write(hw, 0xE8DE, data16);

                rtl8168_wait_ll_share_fifo_ready(hw);
                break;
        }
}

void
rtl8168_hw_disable_mac_mcu_bps(struct rtl_hw *hw)
{

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_enable_cfg9346_write(hw);
                RTL_W8(hw, Config2, RTL_R8(hw, Config2) & ~BIT_7);
                RTL_W8(hw, Config5, RTL_R8(hw, Config5) & ~BIT_0);
                rtl8168_disable_cfg9346_write(hw);
                break;
        }

        switch (hw->mcfg) {
        case CFG_METHOD_29 ... CFG_METHOD_35:
                rtl8168_mac_ocp_write(hw, 0xFC38, 0x0000);
                break;
        }

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_mac_ocp_write(hw, 0xFC28, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC2A, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC2C, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC2E, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC30, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC32, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC34, 0x0000);
                rtl8168_mac_ocp_write(hw, 0xFC36, 0x0000);
                mdelay(3);
                rtl8168_mac_ocp_write(hw, 0xFC26, 0x0000);
                break;
        }
}

void
rtl8168_enable_rxdvgate(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) | BIT_3);
                mdelay(2);
                break;
        }
}

void
rtl8168_disable_rxdvgate(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) & ~BIT_3);
                mdelay(2);
                break;
        }
}

void
rtl8168_nic_reset(struct rtl_hw *hw)
{
        int i;

        RTL_W32(hw, RxConfig, (RX_DMA_BURST << RxCfgDMAShift));

        rtl8168_enable_rxdvgate(hw);

        switch (hw->mcfg) {
        case CFG_METHOD_1 ... CFG_METHOD_3:
                mdelay(10);
                break;
        case CFG_METHOD_4 ... CFG_METHOD_10:
        case CFG_METHOD_14:
        case CFG_METHOD_15:
                RTL_W8(hw, ChipCmd, StopReq | CmdRxEnb | CmdTxEnb);
                udelay(100);
                break;
        case CFG_METHOD_11 ... CFG_METHOD_13:
                for (i = 0; i < 2000; i++) {
                        if (!(RTL_R8(hw, TxPoll) & NPQ)) break;
                        udelay(100);
                }
                break;
        case CFG_METHOD_21 ... CFG_METHOD_35:
                mdelay(2);
                break;
        default:
                mdelay(10);
                break;
        }

        rtl8168_wait_txrx_fifo_empty(hw);

        /* Soft reset the chip. */
        RTL_W8(hw, ChipCmd, CmdReset);

        /* Check that the chip has finished the reset. */
        for (i = 100; i > 0; i--) {
                udelay(100);
                if ((RTL_R8(hw, ChipCmd) & CmdReset) == 0)
                        break;
        }
        //8111DP (CFG11) has extra action, omit it currently
}

static void
rtl8168_exit_realwow(struct rtl_hw *hw)
{
        u32 csi_tmp;

        //Disable realwow  function
        switch (hw->mcfg) {
        case CFG_METHOD_18:
        case CFG_METHOD_19:
                RTL_W32(hw, MACOCP, 0xE5A90000);
                RTL_W32(hw, MACOCP, 0xF2100010);
                break;
        case CFG_METHOD_20:
                RTL_W32(hw, MACOCP, 0xE5A90000);
                RTL_W32(hw, MACOCP, 0xE4640000);
                RTL_W32(hw, MACOCP, 0xF2100010);
                break;
        case CFG_METHOD_21:
        case CFG_METHOD_22:
                RTL_W32(hw, MACOCP, 0x605E0000);
                RTL_W32(hw, MACOCP, (0xE05E << 16) | (RTL_R32(hw, MACOCP) & 0xFFFE));
                RTL_W32(hw, MACOCP, 0xE9720000);
                RTL_W32(hw, MACOCP, 0xF2140010);
                break;
        case CFG_METHOD_26:
                RTL_W32(hw, MACOCP, 0xE05E00FF);
                RTL_W32(hw, MACOCP, 0xE9720000);
                rtl8168_mac_ocp_write(hw, 0xE428, 0x0010);
                break;
        }

        switch (hw->mcfg) {
        case CFG_METHOD_21:
        case CFG_METHOD_22:
                rtl8168_eri_write(hw, 0x174, 2, 0x0000, ERIAR_ExGMAC);
                rtl8168_mac_ocp_write(hw, 0xE428, 0x0010);
                break;
        case CFG_METHOD_24 ... CFG_METHOD_26:
        case CFG_METHOD_28:
        case CFG_METHOD_31 ... CFG_METHOD_34:
                rtl8168_eri_write(hw, 0x174, 2, 0x00FF, ERIAR_ExGMAC);
                rtl8168_mac_ocp_write(hw, 0xE428, 0x0010);
                break;
        case CFG_METHOD_29:
        case CFG_METHOD_30:
        case CFG_METHOD_35:
                csi_tmp = rtl8168_eri_read(hw, 0x174, 2, ERIAR_ExGMAC);
                csi_tmp &= ~(BIT_8);
                csi_tmp |= (BIT_15);
                rtl8168_eri_write(hw, 0x174, 2, csi_tmp, ERIAR_ExGMAC);
                rtl8168_mac_ocp_write(hw, 0xE428, 0x0010);
                break;
        }
}

static void
rtl8168_switch_to_sgmii_mode(struct rtl_hw *hw)
{
        if (FALSE == HW_SUPP_SERDES_PHY(hw)) return;

        switch (hw->HwSuppSerDesPhyVer) {
        case 1:
                rtl8168_mac_ocp_write(hw, 0xEB00, 0x2);
                rtl8168_set_mcu_ocp_bit(hw, 0xEB16, BIT_1);
                break;
        }
}

void
rtl8168_exit_oob(struct rtl_hw *hw)
{
        RTL_W32(hw, RxConfig, RTL_R32(hw, RxConfig) & ~(AcceptErr | AcceptRunt | AcceptBroadcast | AcceptMulticast | AcceptMyPhys |  AcceptAllPhys));

        if (HW_SUPP_SERDES_PHY(hw)) {
                if (hw->HwSuppSerDesPhyVer == 1) {
                        rtl8168_switch_to_sgmii_mode(hw);
                }
        }

        if (HW_DASH_SUPPORT_DASH(hw)) {
                rtl8168_driver_start(hw);
                rtl8168_dash2_disable_txrx(hw);
        }

        rtl8168_exit_realwow(hw);

        rtl8168_nic_reset(hw);

        rtl8168_disable_now_is_oob(hw);
        rtl8168_init_ll_share_fifo(hw);

        //wait ups resume (phy state 2)
        //switch (hw->mcfg) {
        //case CFG_METHOD_29 ... CFG_METHOD_33:
        //        if (rtl8168_is_ups_resume(hw)) {
        //                rtl8168_wait_phy_ups_resume(hw, 2);
        //                rtl8168_clear_ups_resume_bit(hw);
        //        }
        //}

        //omit fiber nic setting

        hw->phy_reg_anlpar = 0;
}

void rtl8168_disable_aspm_clkreq_internal(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_14 ... CFG_METHOD_35:
                RTL_W8(hw, 0xF1, RTL_R8(hw, 0xF1) & ~BIT_7);
                rtl8168_enable_cfg9346_write(hw);
                RTL_W8(hw, Config2, RTL_R8(hw, Config2) & ~BIT_7);
                RTL_W8(hw, Config5, RTL_R8(hw, Config5) & ~BIT_0);
                rtl8168_disable_cfg9346_write(hw);
                break;
        }
}

void rtl8168_disable_ups(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_29 ... CFG_METHOD_35:
                rtl8168_mac_ocp_write(hw, 0xD400, rtl8168_mac_ocp_read( hw, 0xD400) & ~(BIT_0));
                break;
        }
}

void rtl8168_disable_dma_agg(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_29 ... CFG_METHOD_35:
                rtl8168_mac_ocp_write(hw, 0xE63E, rtl8168_mac_ocp_read( hw, 0xE63E) & ~(BIT_3 | BIT_2 | BIT_1));
                rtl8168_mac_ocp_write(hw, 0xE63E, rtl8168_mac_ocp_read( hw, 0xE63E) | (BIT_0));
                rtl8168_mac_ocp_write(hw, 0xE63E, rtl8168_mac_ocp_read( hw, 0xE63E) & ~(BIT_0));
                rtl8168_mac_ocp_write(hw, 0xC094, 0x0);
                rtl8168_mac_ocp_write(hw, 0xC09E, 0x0);
                break;
        }
}

void
rtl8168_init_software_variable(struct rtl_hw *hw)
{

        unsigned int speed_mode = SPEED_1000;
        unsigned int duplex_mode = DUPLEX_FULL;
        unsigned int autoneg_mode = AUTONEG_ENABLE;
        unsigned int advertising_mode =  ADVERTISE_10_HALF |
                                         ADVERTISE_10_FULL |
                                         ADVERTISE_100_HALF |
                                         ADVERTISE_100_FULL |
                                         ADVERTISE_1000_HALF |
                                         ADVERTISE_1000_FULL;

        switch (hw->mcfg) {
        case CFG_METHOD_11:
        case CFG_METHOD_12:
        case CFG_METHOD_13:
                hw->HwSuppDashVer = 1;
                break;
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
                hw->HwSuppDashVer = 2;
                break;
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                hw->HwSuppDashVer = 3;
                break;
        default:
                hw->HwSuppDashVer = 0;
                break;
        }

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                hw->HwSuppPhyOcpVer = 1;
                break;
        }

        //switch (hw->mcfg) {
        //case CFG_METHOD_1 ... CFG_METHOD_3:
        //        hw->ShortPacketSwChecksum = TRUE;
        //        break;
        //case CFG_METHOD_16:
        //case CFG_METHOD_17:
        //        hw->ShortPacketSwChecksum = TRUE;
        //        hw->UseSwPaddingShortPkt = TRUE;
        //        break;
        //}


        switch (hw->mcfg) {
        case CFG_METHOD_16:
        case CFG_METHOD_17:
                hw->HwSuppCheckPhyDisableModeVer = 1;
                break;
        case CFG_METHOD_18:
        case CFG_METHOD_19:
        case CFG_METHOD_21:
        case CFG_METHOD_22:
        case CFG_METHOD_24:
        case CFG_METHOD_25:
        case CFG_METHOD_26:
        case CFG_METHOD_29:
        case CFG_METHOD_30:
        case CFG_METHOD_35:
                hw->HwSuppCheckPhyDisableModeVer = 2;
                break;
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                hw->HwSuppCheckPhyDisableModeVer = 3;
                break;
        }

        //switch (hw->mcfg) {
        //case CFG_METHOD_21 ... CFG_METHOD_33:
        //        hw->HwSuppGigaForceMode = TRUE;
        //        break;
        //}

        switch (hw->mcfg) {
        case CFG_METHOD_14:
        case CFG_METHOD_15:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_14;
                break;
        case CFG_METHOD_16:
        case CFG_METHOD_17:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_16;
                break;
        case CFG_METHOD_18:
        case CFG_METHOD_19:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_18;
                break;
        case CFG_METHOD_20:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_20;
                break;
        case CFG_METHOD_21:
        case CFG_METHOD_22:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_21;
                break;
        case CFG_METHOD_23:
        case CFG_METHOD_27:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_23;
                break;
        case CFG_METHOD_24:
        case CFG_METHOD_25:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_24;
                break;
        case CFG_METHOD_26:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_26;
                break;
        case CFG_METHOD_28:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_28;
                break;
        case CFG_METHOD_29:
        case CFG_METHOD_30:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_29;
                break;
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_31;
                break;
        case CFG_METHOD_35:
                hw->sw_ram_code_ver = NIC_RAMCODE_VERSION_CFG_METHOD_35;
                break;
        }

        switch (hw->mcfg) {
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                hw->HwPkgDet = rtl8168_mac_ocp_read(hw, 0xDC00);
                hw->HwPkgDet = (hw->HwPkgDet >> 3) & 0x0F;
                break;
        }

        switch (hw->mcfg) {
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                if (hw->HwPkgDet == 0x06) {
                        u8 tmpUchar = rtl8168_eri_read(hw, 0xE6, 1, ERIAR_ExGMAC);
                        if (tmpUchar == 0x02)
                                hw->HwSuppSerDesPhyVer = 1;
                        else if (tmpUchar == 0x00)
                                hw->HwSuppSerDesPhyVer = 2;
                }
                break;
        }

        if (HW_DASH_SUPPORT_DASH(hw) && rtl8168_check_dash(hw))
                hw->DASH = 1;
        else
                hw->DASH = 0;

        rtl8168_link_option((u8*)&autoneg_mode, (u32*)&speed_mode, (u8*)&duplex_mode, (u32*)&advertising_mode);

        hw->autoneg = autoneg_mode;
        hw->speed = speed_mode;
        hw->duplex = duplex_mode;
        hw->advertising = advertising_mode;
        /*
                hw->max_jumbo_frame_size = rtl_chip_info[hw->chipset].jumbo_frame_sz;
                // MTU range: 60 - hw-specific max
                hw->eee_enabled = eee_enable;
                hw->eee_adv_t = MDIO_EEE_1000T | MDIO_EEE_100TX;
        */
}

void
rtl8168_get_tally_stats(struct rtl_hw *hw, struct rte_eth_stats *rte_stats)
{
        struct rtl8168_counters *counters;
        uint64_t paddr;
        u32 cmd;
        u32 WaitCnt;

        counters = hw->tally_vaddr;
        paddr = hw->tally_paddr;
        if (!counters)
                return;

        RTL_W32(hw, CounterAddrHigh, (u64)paddr >> 32);
        cmd = (u64)paddr & DMA_BIT_MASK(32);
        RTL_W32(hw, CounterAddrLow, cmd);
        RTL_W32(hw, CounterAddrLow, cmd | CounterDump);

        WaitCnt = 0;
        while (RTL_R32(hw, CounterAddrLow) & CounterDump) {
                udelay(10);

                WaitCnt++;
                if (WaitCnt > 20)
                        break;
        }

        /* Rx Errors */
        rte_stats->imissed = rte_le_to_cpu_64(counters->rx_missed);
        rte_stats->ierrors = rte_le_to_cpu_64(counters->rx_errors);

        /* Tx Errors */
        rte_stats->oerrors = rte_le_to_cpu_64(counters->tx_errors);

        rte_stats->ipackets = rte_le_to_cpu_64(counters->rx_packets);
        rte_stats->opackets = rte_le_to_cpu_64(counters->tx_packets);

}

void
rtl8168_clear_tally_stats(struct rtl_hw *hw)
{
        if (!hw->tally_paddr)
                return;

        RTL_W32(hw, CounterAddrHigh, (u64)hw->tally_paddr >> 32);
        RTL_W32(hw, CounterAddrLow, ((u64)hw->tally_paddr & (DMA_BIT_MASK(32))) | CounterReset);

}

static void
rtl8168_clear_and_set_mcu_ocp_bit(
        struct rtl_hw *hw,
        u16   addr,
        u16   clearmask,
        u16   setmask
)
{
        u16 RegValue;

        RegValue = rtl8168_mac_ocp_read(hw, addr);
        RegValue &= ~clearmask;
        RegValue |= setmask;
        rtl8168_mac_ocp_write(hw, addr, RegValue);
}

void
rtl8168_set_mcu_ocp_bit(
        struct rtl_hw *hw,
        u16   addr,
        u16   mask
)
{
        rtl8168_clear_and_set_mcu_ocp_bit(hw,
                                          addr,
                                          0,
                                          mask
                                         );
}

static u32 real_ocp_read(struct rtl_hw *hw, u16 addr, u8 len)
{
        int i, val_shift, shift = 0;
        u32 value1 = 0, value2 = 0, mask;

        if (len > 4 || len <= 0)
                return -1;

        while (len > 0) {
                val_shift = addr % 4;
                addr = addr & ~0x3;

                RTL_W32(hw, OCPAR, (0x0F << 12) | (addr & 0xFFF));

                for (i = 0; i < 20; i++) {
                        udelay(100);
                        if (RTL_R32(hw, OCPAR) & OCPAR_Flag)
                                break;
                }

                if (len == 1)       mask = (0xFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 2)  mask = (0xFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 3)  mask = (0xFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else            mask = (0xFFFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;

                value1 = RTL_R32(hw, OCPDR) & mask;
                value2 |= (value1 >> val_shift * 8) << shift * 8;

                if (len <= 4 - val_shift) {
                        len = 0;
                } else {
                        len -= (4 - val_shift);
                        shift = 4 - val_shift;
                        addr += 4;
                }
        }

        udelay(20);

        return value2;
}

static int real_ocp_write(struct rtl_hw *hw, u16 addr, u8 len, u32 value)
{
        int i, val_shift, shift = 0;
        u32 value1 = 0, mask;

        if (len > 4 || len <= 0)
                return -1;

        while (len > 0) {
                val_shift = addr % 4;
                addr = addr & ~0x3;

                if (len == 1)       mask = (0xFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 2)  mask = (0xFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else if (len == 3)  mask = (0xFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;
                else            mask = (0xFFFFFFFF << (val_shift * 8)) & 0xFFFFFFFF;

                value1 = rtl8168_ocp_read(hw, addr, 4) & ~mask;
                value1 |= ((value << val_shift * 8) >> shift * 8);

                RTL_W32(hw, OCPDR, value1);
                RTL_W32(hw, OCPAR, OCPAR_Flag | (0x0F << 12) | (addr & 0xFFF));

                for (i = 0; i < 10; i++) {
                        udelay(100);

                        /* Check if the RTL8168 has completed ERI write */
                        if (!(RTL_R32(hw, OCPAR) & OCPAR_Flag))
                                break;
                }

                if (len <= 4 - val_shift) {
                        len = 0;
                } else {
                        len -= (4 - val_shift);
                        shift = 4 - val_shift;
                        addr += 4;
                }
        }

        udelay(20);

        return 0;
}

static u32 rtl8168_ocp_read_with_oob_base_address(struct rtl_hw *hw, u16 addr, u8 len, const u32 base_address)
{
        return rtl8168_eri_read_with_oob_base_address(hw, addr, len, ERIAR_OOB, base_address);
}

static u32 rtl8168_ocp_write_with_oob_base_address(struct rtl_hw *hw, u16 addr, u8 len, u32 value, const u32 base_address)
{
        return rtl8168_eri_write_with_oob_base_address(hw, addr, len, value, ERIAR_OOB, base_address);
}

u32 rtl8168_ocp_read(struct rtl_hw *hw, u16 addr, u8 len)
{
        u32 value = 0;

        if (HW_DASH_SUPPORT_TYPE_2(hw))
                value = rtl8168_ocp_read_with_oob_base_address(hw, addr, len, NO_BASE_ADDRESS);
        else if (HW_DASH_SUPPORT_TYPE_3(hw))
                value = rtl8168_ocp_read_with_oob_base_address(hw, addr, len, RTL8168FP_OOBMAC_BASE);
        else
                value = real_ocp_read(hw, addr, len);

        return value;
}

void rtl8168_ocp_write(struct rtl_hw *hw, u16 addr, u8 len, u32 value)
{
        if (HW_DASH_SUPPORT_TYPE_2(hw))
                rtl8168_ocp_write_with_oob_base_address(hw, addr, len, value, NO_BASE_ADDRESS);
        else if (HW_DASH_SUPPORT_TYPE_3(hw))
                rtl8168_ocp_write_with_oob_base_address(hw, addr, len, value, RTL8168FP_OOBMAC_BASE);
        else
                real_ocp_write(hw, addr, len, value);
}

void rtl8168_oob_mutex_lock(struct rtl_hw *hw)
{
        u8 reg_16, reg_a0;
        u32 wait_cnt_0, wait_Cnt_1;
        u16 ocp_reg_mutex_ib;
        u16 ocp_reg_mutex_oob;
        u16 ocp_reg_mutex_prio;

        if (!hw->DASH)
                return;

        switch (hw->mcfg) {
        case CFG_METHOD_11:
        case CFG_METHOD_12:
                ocp_reg_mutex_oob = 0x16;
                ocp_reg_mutex_ib = 0x17;
                ocp_reg_mutex_prio = 0x9C;
                break;
        case CFG_METHOD_13:
                ocp_reg_mutex_oob = 0x06;
                ocp_reg_mutex_ib = 0x07;
                ocp_reg_mutex_prio = 0x9C;
                break;
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
        default:
                ocp_reg_mutex_oob = 0x110;
                ocp_reg_mutex_ib = 0x114;
                ocp_reg_mutex_prio = 0x11C;
                break;
        }

        rtl8168_ocp_write(hw, ocp_reg_mutex_ib, 1, BIT_0);
        reg_16 = rtl8168_ocp_read(hw, ocp_reg_mutex_oob, 1);
        wait_cnt_0 = 0;
        while (reg_16) {
                reg_a0 = rtl8168_ocp_read(hw, ocp_reg_mutex_prio, 1);
                if (reg_a0) {
                        rtl8168_ocp_write(hw, ocp_reg_mutex_ib, 1, 0x00);
                        reg_a0 = rtl8168_ocp_read(hw, ocp_reg_mutex_prio, 1);
                        wait_Cnt_1 = 0;
                        while (reg_a0) {
                                reg_a0 = rtl8168_ocp_read(hw, ocp_reg_mutex_prio, 1);

                                wait_Cnt_1++;

                                if (wait_Cnt_1 > 2000)
                                        break;
                        };
                        rtl8168_ocp_write(hw, ocp_reg_mutex_ib, 1, BIT_0);

                }
                reg_16 = rtl8168_ocp_read(hw, ocp_reg_mutex_oob, 1);

                wait_cnt_0++;

                if (wait_cnt_0 > 2000)
                        break;
        };
}

void rtl8168_oob_mutex_unlock(struct rtl_hw *hw)
{
        u16 ocp_reg_mutex_ib;
        //u16 ocp_reg_mutex_oob;
        u16 ocp_reg_mutex_prio;

        if (!hw->DASH)
                return;

        switch (hw->mcfg) {
        case CFG_METHOD_11:
        case CFG_METHOD_12:
                //ocp_reg_mutex_oob = 0x16;
                ocp_reg_mutex_ib = 0x17;
                ocp_reg_mutex_prio = 0x9C;
                break;
        case CFG_METHOD_13:
                //ocp_reg_mutex_oob = 0x06;
                ocp_reg_mutex_ib = 0x07;
                ocp_reg_mutex_prio = 0x9C;
                break;
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
        default:
                //ocp_reg_mutex_oob = 0x110;
                ocp_reg_mutex_ib = 0x114;
                ocp_reg_mutex_prio = 0x11C;
                break;
        }

        rtl8168_ocp_write(hw, ocp_reg_mutex_prio, 1, BIT_0);
        rtl8168_ocp_write(hw, ocp_reg_mutex_ib, 1, 0x00);
}
