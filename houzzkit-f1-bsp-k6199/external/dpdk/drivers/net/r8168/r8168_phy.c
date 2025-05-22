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
#include "r8168_phy.h"
#include "base/rtl8168g.h"
#include "base/rtl8168h.h"
#include "base/rtl8168ep.h"
#include "base/rtl8168fp.h"

static u16 map_phy_ocp_addr(u16 PageNum, u8 RegNum)
{
        u16 OcpPageNum = 0;
        u8 OcpRegNum = 0;
        u16 OcpPhyAddress = 0;

        if ( PageNum == 0 ) {
                OcpPageNum = OCP_STD_PHY_BASE_PAGE + ( RegNum / 8 );
                OcpRegNum = 0x10 + ( RegNum % 8 );
        } else {
                OcpPageNum = PageNum;
                OcpRegNum = RegNum;
        }

        OcpPageNum <<= 4;

        if ( OcpRegNum < 16 ) {
                OcpPhyAddress = 0;
        } else {
                OcpRegNum -= 16;
                OcpRegNum <<= 1;

                OcpPhyAddress = OcpPageNum + OcpRegNum;
        }


        return OcpPhyAddress;
}

static u32 mdio_real_direct_read_phy_ocp(struct rtl_hw *hw,
                u32 RegAddr)
{
        u32 data32;
        int i, value = 0;

        if (hw->HwSuppPhyOcpVer == 0) return value;

        data32 = RegAddr/2;
        data32 <<= OCPR_Addr_Reg_shift;

        RTL_W32(hw, PHYOCP, data32);
        for (i = 0; i < 100; i++) {
                udelay(1);

                if (RTL_R32(hw, PHYOCP) & OCPR_Flag)
                        break;
        }
        value = RTL_R32(hw, PHYOCP) & OCPDR_Data_Mask;

        return value;
}

static u32 rtl8168_mdio_read_phy_ocp(struct rtl_hw *hw,
                                     u16 PageNum,
                                     u32 RegAddr)
{
        u16 ocp_addr;

        //if (hw->rtk_enable_diag) return;

        ocp_addr = map_phy_ocp_addr(PageNum, RegAddr);

        return mdio_real_direct_read_phy_ocp(hw, ocp_addr);
}

static u32 rtl8168_mdio_real_read_phy_ocp(struct rtl_hw *hw,
                u16 PageNum,
                u32 RegAddr)
{
        u16 ocp_addr;

        ocp_addr = map_phy_ocp_addr(PageNum, RegAddr);

        return mdio_real_direct_read_phy_ocp(hw, ocp_addr);
}

static u32 mdio_real_read(struct rtl_hw *hw,
                          u32 RegAddr)
{
        int i, value = 0;

        if (hw->mcfg==CFG_METHOD_11) {
                RTL_W32(hw, OCPDR, OCPDR_Read |
                        (RegAddr & OCPDR_Reg_Mask) << OCPDR_GPHY_Reg_shift);
                RTL_W32(hw, OCPAR, OCPAR_GPHY_Write);
                RTL_W32(hw, EPHY_RXER_NUM, 0);

                for (i = 0; i < 100; i++) {
                        mdelay(1);
                        if (!(RTL_R32(hw, OCPAR) & OCPAR_Flag))
                                break;
                }

                mdelay(1);
                RTL_W32(hw, OCPAR, OCPAR_GPHY_Read);
                RTL_W32(hw, EPHY_RXER_NUM, 0);

                for (i = 0; i < 100; i++) {
                        mdelay(1);
                        if (RTL_R32(hw, OCPAR) & OCPAR_Flag)
                                break;
                }

                value = RTL_R32(hw, OCPDR) & OCPDR_Data_Mask;
        } else {
                if (hw->HwSuppPhyOcpVer > 0) {
                        value = rtl8168_mdio_real_read_phy_ocp(hw, hw->cur_page, RegAddr);
                } else {
                        if (hw->mcfg == CFG_METHOD_12 || hw->mcfg == CFG_METHOD_13)
                                RTL_W32(hw, 0xD0, RTL_R32(hw, 0xD0) & ~0x00020000);

                        RTL_W32(hw, PHYAR,
                                PHYAR_Read | (RegAddr & PHYAR_Reg_Mask) << PHYAR_Reg_shift);

                        for (i = 0; i < 10; i++) {
                                udelay(100);

                                /* Check if the RTL8168 has completed retrieving data from the specified MII register */
                                if (RTL_R32(hw, PHYAR) & PHYAR_Flag) {
                                        value = RTL_R32(hw, PHYAR) & PHYAR_Data_Mask;
                                        udelay(20);
                                        break;
                                }
                        }

                        if (hw->mcfg == CFG_METHOD_12 || hw->mcfg == CFG_METHOD_13)
                                RTL_W32(hw, 0xD0, RTL_R32(hw, 0xD0) | 0x00020000);
                }
        }

        return value;
}

static void mdio_real_direct_write_phy_ocp(struct rtl_hw *hw,
                u32 RegAddr,
                u32 value)
{
        u32 data32;
        int i;

        if (hw->HwSuppPhyOcpVer == 0) return;

        data32 = RegAddr/2;
        data32 <<= OCPR_Addr_Reg_shift;
        data32 |= OCPR_Write | value;

        RTL_W32(hw, PHYOCP, data32);
        for (i = 0; i < 100; i++) {
                udelay(1);

                if (!(RTL_R32(hw, PHYOCP) & OCPR_Flag))
                        break;
        }
}

static void rtl8168_mdio_write_phy_ocp(struct rtl_hw *hw,
                                       u16 PageNum,
                                       u32 RegAddr,
                                       u32 value)
{
        u16 ocp_addr;

        //if (hw->rtk_enable_diag) return;

        ocp_addr = map_phy_ocp_addr(PageNum, RegAddr);

        mdio_real_direct_write_phy_ocp(hw, ocp_addr, value);
}

static void rtl8168_mdio_real_write_phy_ocp(struct rtl_hw *hw,
                u16 PageNum,
                u32 RegAddr,
                u32 value)
{
        u16 ocp_addr;

        ocp_addr = map_phy_ocp_addr(PageNum, RegAddr);

        mdio_real_direct_write_phy_ocp(hw, ocp_addr, value);
}

static void mdio_real_write(struct rtl_hw *hw, u32 RegAddr, u32 value)
{
        int i;

        if (RegAddr == 0x1F) {
                hw->cur_page = value;
        }

        if (hw->mcfg == CFG_METHOD_11) {
                RTL_W32(hw, OCPDR, OCPDR_Write |
                        (RegAddr & OCPDR_Reg_Mask) << OCPDR_GPHY_Reg_shift |
                        (value & OCPDR_Data_Mask));
                RTL_W32(hw, OCPAR, OCPAR_GPHY_Write);
                RTL_W32(hw, EPHY_RXER_NUM, 0);

                for (i = 0; i < 100; i++) {
                        mdelay(1);
                        if (!(RTL_R32(hw, OCPAR) & OCPAR_Flag))
                                break;
                }
        } else {
                if (hw->HwSuppPhyOcpVer > 0) {
                        if (RegAddr == 0x1F) {
                                return;
                        }
                        rtl8168_mdio_real_write_phy_ocp(hw, hw->cur_page, RegAddr, value);
                } else {
                        if (hw->mcfg == CFG_METHOD_12 || hw->mcfg == CFG_METHOD_13)
                                RTL_W32(hw, 0xD0, RTL_R32(hw, 0xD0) & ~0x00020000);

                        RTL_W32(hw, PHYAR, PHYAR_Write |
                                (RegAddr & PHYAR_Reg_Mask) << PHYAR_Reg_shift |
                                (value & PHYAR_Data_Mask));

                        for (i = 0; i < 10; i++) {
                                udelay(100);

                                /* Check if the RTL8168 has completed writing to the specified MII register */
                                if (!(RTL_R32(hw, PHYAR) & PHYAR_Flag)) {
                                        udelay(20);
                                        break;
                                }
                        }

                        if (hw->mcfg == CFG_METHOD_12 || hw->mcfg == CFG_METHOD_13)
                                RTL_W32(hw, 0xD0, RTL_R32(hw, 0xD0) | 0x00020000);
                }
        }
}

u32 rtl8168_mdio_read(struct rtl_hw *hw, u32 RegAddr)
{
        //if (hw->rtk_enable_diag) return 0xffffffff;
        return mdio_real_read(hw, RegAddr);
}

void rtl8168_mdio_write(struct rtl_hw *hw, u32 RegAddr, u32 value)
{
        //if (hw->rtk_enable_diag) return;
        mdio_real_write(hw, RegAddr, value);
}

void ClearAndSetEthPhyBit(struct rtl_hw *hw, u8 addr, u16 clearmask, u16 setmask)
{
        u16 PhyRegValue;

        PhyRegValue = rtl8168_mdio_read(hw, addr);
        PhyRegValue &= ~clearmask;
        PhyRegValue |= setmask;
        rtl8168_mdio_write(hw, addr, PhyRegValue);
}

void rtl8168_clear_eth_phy_bit(struct rtl_hw *hw, u8 addr, u16 mask)
{
        ClearAndSetEthPhyBit(hw, addr, mask, 0);
}

void rtl8168_set_eth_phy_bit(struct rtl_hw *hw, u8 addr, u16  mask)
{
        ClearAndSetEthPhyBit(hw, addr, 0, mask);
}

static void
ClearAndSetEthPhyOcpBit(struct rtl_hw *hw, u16  addr, u16 clearmask, u16 setmask)
{
        u16 PhyRegValue;

        PhyRegValue = mdio_real_direct_read_phy_ocp(hw, addr);
        PhyRegValue &= ~clearmask;
        PhyRegValue |= setmask;
        mdio_real_direct_write_phy_ocp(hw, addr, PhyRegValue);
}

static void
rtl8168_clear_eth_phy_ocp_bit(struct rtl_hw *hw, u16 addr, u16 mask)
{
        ClearAndSetEthPhyOcpBit(hw, addr, mask, 0);
}

/*
static void
rtl8168_set_eth_phy_ocp_bit(struct rtl_hw *hw, u16 addr, u16  mask)
{
        ClearAndSetEthPhyOcpBit(hw, addr, 0, mask);
}
*/

static int
rtl8168_check_hw_phy_mcu_code_ver(struct rtl_hw *hw)
{
        int ram_code_ver_match = 0;

        switch (hw->mcfg) {
        case CFG_METHOD_14:
        case CFG_METHOD_15:
                rtl8168_mdio_write(hw, 0x1F, 0x0005);
                rtl8168_mdio_write(hw, 0x05, 0x8B60);
                hw->hw_ram_code_ver = rtl8168_mdio_read(hw, 0x06);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                break;
        case CFG_METHOD_16 ... CFG_METHOD_20:
                rtl8168_mdio_write(hw, 0x1F, 0x0005);
                rtl8168_mdio_write(hw, 0x05, 0x8B30);
                hw->hw_ram_code_ver = rtl8168_mdio_read(hw, 0x06);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                break;
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x801E);
                hw->hw_ram_code_ver = rtl8168_mdio_read(hw, 0x14);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                break;
        default:
                hw->hw_ram_code_ver = ~0;
                break;
        }

        //printf("xing check print phy code hw version %d\n", hw->hw_ram_code_ver);

        if ( hw->hw_ram_code_ver == hw->sw_ram_code_ver) {
                ram_code_ver_match = 1;
                hw->HwHasWrRamCodeToMicroP = TRUE;
        }

        return ram_code_ver_match;
}

static void
rtl8168_write_hw_phy_mcu_code_ver(struct rtl_hw *hw)
{

        switch (hw->mcfg) {
        case CFG_METHOD_14:
        case CFG_METHOD_15:
                rtl8168_mdio_write(hw, 0x1F, 0x0005);
                rtl8168_mdio_write(hw, 0x05, 0x8B60);
                rtl8168_mdio_write(hw, 0x06, hw->sw_ram_code_ver);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                hw->hw_ram_code_ver = hw->sw_ram_code_ver;
                break;
        case CFG_METHOD_16 ... CFG_METHOD_20:
                rtl8168_mdio_write(hw, 0x1F, 0x0005);
                rtl8168_mdio_write(hw, 0x05, 0x8B30);
                rtl8168_mdio_write(hw, 0x06, hw->sw_ram_code_ver);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                hw->hw_ram_code_ver = hw->sw_ram_code_ver;
                break;
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x801E);
                rtl8168_mdio_write(hw, 0x14, hw->sw_ram_code_ver);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                hw->hw_ram_code_ver = hw->sw_ram_code_ver;
                break;
        }
}

int
rtl8168_set_phy_mcu_patch_request(struct rtl_hw *hw)
{
        u16 PhyRegValue;
        u32 WaitCnt;
        int retval = TRUE;

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_mdio_write(hw,0x1f, 0x0B82);
                rtl8168_set_eth_phy_bit(hw, 0x10, BIT_4);

                rtl8168_mdio_write(hw,0x1f, 0x0B80);
                WaitCnt = 0;
                do {
                        PhyRegValue = rtl8168_mdio_read(hw, 0x10);
                        PhyRegValue &= 0x0040;
                        udelay(100);
                        WaitCnt++;
                } while(PhyRegValue != 0x0040 && WaitCnt <1000);

                if (WaitCnt == 1000) {
                        retval = FALSE;
                }

                rtl8168_mdio_write(hw,0x1f, 0x0000);
                break;
        }

        return retval;
}


int
rtl8168_clear_phy_mcu_patch_request(struct rtl_hw *hw)
{
        u16 PhyRegValue;
        u32 WaitCnt;
        int retval = TRUE;

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_mdio_write(hw, 0x1f, 0x0B82);
                rtl8168_clear_eth_phy_bit(hw, 0x10, BIT_4);

                rtl8168_mdio_write(hw,0x1f, 0x0A22);
                WaitCnt = 0;
                do {
                        PhyRegValue = rtl8168_mdio_read(hw, 0x12);
                        PhyRegValue &= 0x0010;
                        udelay(100);
                        WaitCnt++;
                } while(PhyRegValue != 0x0010 && WaitCnt <1000);

                if (WaitCnt == 1000) {
                        retval = FALSE;
                }

                rtl8168_mdio_write(hw,0x1f, 0x0000);
                break;
        }

        return retval;
}

void
rtl8168_enable_ocp_phy_power_saving(struct rtl_hw *hw)
{
        u16 val;

        switch (hw->mcfg) {
        case CFG_METHOD_25 ... CFG_METHOD_35:
                val = rtl8168_mdio_read_phy_ocp(hw, 0x0C41, 0x13);
                if (val != 0x0050) {
                        rtl8168_set_phy_mcu_patch_request(hw);
                        rtl8168_mdio_write_phy_ocp(hw, 0x0C41, 0x13, 0x0000);
                        rtl8168_mdio_write_phy_ocp(hw, 0x0C41, 0x13, 0x0050);
                        rtl8168_clear_phy_mcu_patch_request(hw);
                }
                break;
        }
}

void
rtl8168_disable_ocp_phy_power_saving(struct rtl_hw *hw)
{
        u16 val;

        switch (hw->mcfg) {
        case CFG_METHOD_25 ... CFG_METHOD_35:
                val = rtl8168_mdio_read_phy_ocp(hw, 0x0C41, 0x13);
                if (val != 0x0050) {
                        rtl8168_set_phy_mcu_patch_request(hw);
                        rtl8168_mdio_write_phy_ocp(hw, 0x0C41, 0x13, 0x0000);
                        rtl8168_mdio_write_phy_ocp(hw, 0x0C41, 0x13, 0x0500);
                        rtl8168_clear_phy_mcu_patch_request(hw);
                }
                break;
        }
}

static void
rtl8168_enable_phy_disable_mode(struct rtl_hw *hw)
{

        switch (hw->HwSuppCheckPhyDisableModeVer) {
        case 1:
                rtl8168_mac_ocp_write(hw, 0xDC20, rtl8168_mac_ocp_read(hw, 0xDC20) | BIT_1);
                break;
        case 2:
        case 3:
                RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) | BIT_5);
                break;
        }

}

static void
rtl8168_disable_phy_disable_mode(struct rtl_hw *hw)
{

        switch (hw->HwSuppCheckPhyDisableModeVer) {
        case 1:
                rtl8168_mac_ocp_write(hw, 0xDC20, rtl8168_mac_ocp_read(hw, 0xDC20) & ~BIT_1);
                break;
        case 2:
        case 3:
                RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) & ~BIT_5);
                break;
        }

        mdelay(1);

}

static u8
rtl8168_is_phy_disable_mode_enabled(struct rtl_hw *hw)
{
        u8 phy_disable_mode_enabled = FALSE;

        switch (hw->HwSuppCheckPhyDisableModeVer) {
        case 1:
                if (rtl8168_mac_ocp_read(hw, 0xDC20) & BIT_1)
                        phy_disable_mode_enabled = TRUE;
                break;
        case 2:
        case 3:
                if (RTL_R8(hw, 0xF2) & BIT_5)
                        phy_disable_mode_enabled = TRUE;
                break;
        }

        return phy_disable_mode_enabled;
}

static u8
rtl8168_is_gpio_low(struct rtl_hw *hw)
{
        u8 gpio_low = FALSE;

        switch (hw->HwSuppCheckPhyDisableModeVer) {
        case 1:
        case 2:
                if (!(rtl8168_mac_ocp_read(hw, 0xDC04) & BIT_9))
                        gpio_low = TRUE;
                break;
        case 3:
                if (!(rtl8168_mac_ocp_read(hw, 0xDC04) & BIT_13))
                        gpio_low = TRUE;
                break;
        }

        return gpio_low;
}

static u8
rtl8168_is_in_phy_disable_mode(struct rtl_hw *hw)
{
        u8 in_phy_disable_mode = FALSE;

        if (rtl8168_is_phy_disable_mode_enabled(hw) && rtl8168_is_gpio_low(hw))
                in_phy_disable_mode = TRUE;

        return in_phy_disable_mode;
}

static int
rtl8168_phy_ram_code_check(struct rtl_hw *hw)
{
        u16 PhyRegValue;
        int retval = TRUE;
        u16 TmpUshort;

        if (hw->mcfg != CFG_METHOD_21)
                goto exit;

        rtl8168_mdio_write(hw, 0x1f, 0x0A40);
        PhyRegValue = rtl8168_mdio_read(hw, 0x10);
        PhyRegValue &= ~(BIT_11);
        rtl8168_mdio_write(hw, 0x10, PhyRegValue);


        rtl8168_mdio_write(hw, 0x1f, 0x0A00);
        PhyRegValue = rtl8168_mdio_read(hw, 0x10);
        PhyRegValue &= ~(BIT_12 | BIT_13 | BIT_14 | BIT_15);
        rtl8168_mdio_write(hw, 0x10, PhyRegValue);

        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8010);
        PhyRegValue = rtl8168_mdio_read(hw, 0x14);
        PhyRegValue &= ~(BIT_11);
        rtl8168_mdio_write(hw, 0x14, PhyRegValue);

        retval = rtl8168_set_phy_mcu_patch_request(hw);

        rtl8168_mdio_write(hw, 0x1f, 0x0A40);
        rtl8168_mdio_write(hw, 0x10, 0x0140);

        rtl8168_mdio_write(hw, 0x1f, 0x0A4A);
        PhyRegValue = rtl8168_mdio_read(hw, 0x13);
        PhyRegValue &= ~(BIT_6);
        PhyRegValue |= (BIT_7);
        rtl8168_mdio_write(hw, 0x13, PhyRegValue);

        rtl8168_mdio_write(hw, 0x1f, 0x0A44);
        PhyRegValue = rtl8168_mdio_read(hw, 0x14);
        PhyRegValue |= (BIT_2);
        rtl8168_mdio_write(hw, 0x14, PhyRegValue);

        rtl8168_mdio_write(hw, 0x1f, 0x0A50);
        PhyRegValue = rtl8168_mdio_read(hw, 0x11);
        PhyRegValue |= (BIT_11|BIT_12);
        rtl8168_mdio_write(hw, 0x11, PhyRegValue);

        retval = rtl8168_clear_phy_mcu_patch_request(hw);

        rtl8168_mdio_write(hw, 0x1f, 0x0A40);
        rtl8168_mdio_write(hw, 0x10, 0x1040);

        rtl8168_mdio_write(hw, 0x1f, 0x0A4A);
        PhyRegValue = rtl8168_mdio_read(hw, 0x13);
        PhyRegValue &= ~(BIT_6|BIT_7);
        rtl8168_mdio_write(hw, 0x13, PhyRegValue);

        rtl8168_mdio_write(hw, 0x1f, 0x0A44);
        PhyRegValue = rtl8168_mdio_read(hw, 0x14);
        PhyRegValue &= ~(BIT_2);
        rtl8168_mdio_write(hw, 0x14, PhyRegValue);

        rtl8168_mdio_write(hw, 0x1f, 0x0A50);
        PhyRegValue = rtl8168_mdio_read(hw, 0x11);
        PhyRegValue &= ~(BIT_11|BIT_12);
        rtl8168_mdio_write(hw, 0x11, PhyRegValue);

        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8010);
        PhyRegValue = rtl8168_mdio_read(hw, 0x14);
        PhyRegValue |= (BIT_11);
        rtl8168_mdio_write(hw, 0x14, PhyRegValue);

        retval = rtl8168_set_phy_mcu_patch_request(hw);

        rtl8168_mdio_write(hw, 0x1f, 0x0A20);
        PhyRegValue = rtl8168_mdio_read(hw, 0x13);
        if (PhyRegValue & BIT_11) {
                if (PhyRegValue & BIT_10) {
                        retval = FALSE;
                }
        }

        retval = rtl8168_clear_phy_mcu_patch_request(hw);

        mdelay(2);

        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        if (FALSE == retval) {
                //rtl8168_set_phy_ram_code_check_fail_flag()
                TmpUshort = rtl8168_mac_ocp_read(hw, 0xD3C0);
                TmpUshort |= BIT_0;
                rtl8168_mac_ocp_write(hw, 0xD3C0, TmpUshort);
        }

exit:

        return retval;
}

int
rtl8168_init_hw_phy_mcu(struct rtl_hw *hw)
{
        u8 require_disable_phy_disable_mode = FALSE;

        if (hw->HwIcVerUnknown) {
                printf("xing get hw version unknown!\n");
                return FALSE;
        }

        if (rtl8168_check_hw_phy_mcu_code_ver(hw)) {
                //printf("xing check phy mcu code version sucess!\n");
                //we need not update phy fw
                return FALSE;
        }

        if ((hw->mcfg == CFG_METHOD_21) && (FALSE == rtl8168_phy_ram_code_check(hw))) {
                printf("xing 8111g cfg21 check phy code fail!\n");
                return FALSE;
        }

        if ((hw->HwSuppCheckPhyDisableModeVer > 0) && rtl8168_is_in_phy_disable_mode(hw))
                require_disable_phy_disable_mode = TRUE;

        if (require_disable_phy_disable_mode)
                rtl8168_disable_phy_disable_mode(hw);

        hw->hw_ops.hw_phy_mcu_config(hw);

        if (require_disable_phy_disable_mode)
                rtl8168_enable_phy_disable_mode(hw);

        rtl8168_write_hw_phy_mcu_code_ver(hw);

        rtl8168_mdio_write(hw,0x1F, 0x0000);

        hw->HwHasWrRamCodeToMicroP = TRUE;

        return TRUE;
}

static void
rtl8168_xmii_reset_enable(struct rtl_hw *hw)
{
        int i, val;

        if (rtl8168_is_in_phy_disable_mode(hw))
                return;

        rtl8168_mdio_write(hw, 0x1f, 0x0000);
        rtl8168_mdio_write(hw, MII_ADVERTISE, rtl8168_mdio_read(hw, MII_ADVERTISE) &
                           ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
                             ADVERTISE_100HALF | ADVERTISE_100FULL));
        rtl8168_mdio_write(hw, MII_CTRL1000, rtl8168_mdio_read(hw, MII_CTRL1000) &
                           ~(ADVERTISE_1000HALF | ADVERTISE_1000FULL));
        rtl8168_mdio_write(hw, MII_BMCR, BMCR_RESET | BMCR_ANENABLE);

        for (i = 0; i < 2500; i++) {
                val = rtl8168_mdio_read(hw, MII_BMCR) & BMCR_RESET;

                if (!val) {
                        return;
                }

                mdelay(1);
        }
}

static void
rtl8168_phy_restart_nway(struct rtl_hw *hw)
{

        if (rtl8168_is_in_phy_disable_mode(hw)) return;

        rtl8168_mdio_write(hw, 0x1F, 0x0000);
        rtl8168_mdio_write(hw, MII_BMCR, BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
}

static int
rtl8168_phy_setup_force_mode(struct rtl_hw *hw, u32 speed, u8 duplex)
{
        int ret = FALSE;
        u16 bmcr_true_force = 0;

        if (rtl8168_is_in_phy_disable_mode(hw)) return ret;

        if ((speed == SPEED_10) && (duplex == DUPLEX_HALF)) {
                bmcr_true_force = BMCR_SPEED10;
        } else if ((speed == SPEED_10) && (duplex == DUPLEX_FULL)) {
                bmcr_true_force = BMCR_SPEED10 | BMCR_FULLDPLX;
        } else if ((speed == SPEED_100) && (duplex == DUPLEX_HALF)) {
                bmcr_true_force = BMCR_SPEED100;
        } else if ((speed == SPEED_100) && (duplex == DUPLEX_FULL)) {
                bmcr_true_force = BMCR_SPEED100 | BMCR_FULLDPLX;
        } else if ((speed == SPEED_1000) && (duplex == DUPLEX_FULL) &&
                   hw->HwSuppGigaForceMode) {
                bmcr_true_force = BMCR_SPEED1000 | BMCR_FULLDPLX;
        } else {
                //log print
                return FALSE;
        }

        rtl8168_mdio_write(hw, 0x1F, 0x0000);
        rtl8168_mdio_write(hw, MII_BMCR, bmcr_true_force);

        return TRUE;
}

void
rtl8168_link_option(u8 *aut, u32 *spd, u8 *dup, u32 *adv)
{
        if ((*spd != SPEED_1000) && (*spd != SPEED_100) && (*spd != SPEED_10))
                *spd = SPEED_1000;

        if ((*dup != DUPLEX_FULL) && (*dup != DUPLEX_HALF))
                *dup = DUPLEX_FULL;

        if ((*aut != AUTONEG_ENABLE) && (*aut != AUTONEG_DISABLE))
                *aut = AUTONEG_ENABLE;

        *adv &= (ADVERTISE_10_HALF |
                 ADVERTISE_10_FULL |
                 ADVERTISE_100_HALF |
                 ADVERTISE_100_FULL |
                 ADVERTISE_1000_HALF |
                 ADVERTISE_1000_FULL);
        if (*adv == 0)
                *adv = (ADVERTISE_10_HALF |
                        ADVERTISE_10_FULL |
                        ADVERTISE_100_HALF |
                        ADVERTISE_100_FULL |
                        ADVERTISE_1000_HALF |
                        ADVERTISE_1000_FULL);
}

static int
rtl8168_set_speed_xmii(struct rtl_hw *hw, u8 autoneg, u32 speed, u8 duplex, u32 adv)
{
        int auto_nego = 0;
        int giga_ctrl = 0;
        int rc = -EINVAL;

        if (hw->mcfg == CFG_METHOD_29 || hw->mcfg == CFG_METHOD_30 ||
            hw->mcfg == CFG_METHOD_31 || hw->mcfg == CFG_METHOD_32 ||
            hw->mcfg == CFG_METHOD_33 || hw->mcfg == CFG_METHOD_34 ||
            hw->mcfg == CFG_METHOD_35) {
                //Disable Giga Lite
                rtl8168_mdio_write(hw, 0x1F, 0x0A42);
                rtl8168_clear_eth_phy_bit(hw, 0x14, BIT_9);

                if (hw->mcfg == CFG_METHOD_31 || hw->mcfg == CFG_METHOD_32 ||
                    hw->mcfg == CFG_METHOD_33 || hw->mcfg == CFG_METHOD_34)
                        rtl8168_clear_eth_phy_bit(hw, 0x14, BIT_7);

                rtl8168_mdio_write(hw, 0x1F, 0x0A40);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
        }

        if ((speed != SPEED_1000) && (speed != SPEED_100) && (speed != SPEED_10)) {
                speed = SPEED_1000;
                duplex = DUPLEX_FULL;
        }

        giga_ctrl = rtl8168_mdio_read(hw, MII_CTRL1000);
        giga_ctrl &= ~(ADVERTISE_1000HALF | ADVERTISE_1000FULL);

        if (autoneg == AUTONEG_ENABLE) {
                /*n-way force*/
                auto_nego = rtl8168_mdio_read(hw, MII_ADVERTISE);
                auto_nego &= ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
                               ADVERTISE_100HALF | ADVERTISE_100FULL |
                               ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM);

                if (adv & ADVERTISE_10_HALF)
                        auto_nego |= ADVERTISE_10HALF;
                if (adv & ADVERTISE_10_FULL)
                        auto_nego |= ADVERTISE_10FULL;
                if (adv & ADVERTISE_100_HALF)
                        auto_nego |= ADVERTISE_100HALF;
                if (adv & ADVERTISE_100_FULL)
                        auto_nego |= ADVERTISE_100FULL;
                if (adv & ADVERTISE_1000_HALF)
                        giga_ctrl |= ADVERTISE_1000HALF;
                if (adv & ADVERTISE_1000_FULL)
                        giga_ctrl |= ADVERTISE_1000FULL;

                //flow control
                if (hw->mtu <= ETH_DATA_LEN)
                        auto_nego |= ADVERTISE_PAUSE_CAP|ADVERTISE_PAUSE_ASYM;

                hw->phy_auto_nego_reg = auto_nego;
                hw->phy_1000_ctrl_reg = giga_ctrl;

                rtl8168_mdio_write(hw, 0x1f, 0x0000);
                rtl8168_mdio_write(hw, MII_ADVERTISE, auto_nego);
                rtl8168_mdio_write(hw, MII_CTRL1000, giga_ctrl);

                rtl8168_phy_restart_nway(hw);
                mdelay(20);

        } else {
                /*true force*/
                if (speed == SPEED_10 || speed == SPEED_100 ||
                    (speed == SPEED_1000 && duplex == DUPLEX_FULL &&
                     hw->HwSuppGigaForceMode)) {
                        if (FALSE == rtl8168_phy_setup_force_mode(hw, speed, duplex))
                                goto out;
                } else
                        goto out;
        }

        hw->autoneg = autoneg;
        hw->speed = speed;
        hw->duplex = duplex;
        hw->advertising = adv;

        //if (hw->mcfg == CFG_METHOD_11)
        //        rtl8168dp_10mbps_gphy_para(dev);

        rc = 0;
out:
        return rc;
}

static void
rtl8168_wait_phy_ups_resume(struct rtl_hw *hw, u16 PhyState)
{
        u16 TmpPhyState;
        int i=0;

        do {
                TmpPhyState = rtl8168_mdio_read_phy_ocp(hw, 0x0A42, 0x10);
                TmpPhyState &= 0x7;
                mdelay(1);
                i++;
        } while ((i < 100) && (TmpPhyState != PhyState));
}

static void
rtl8168_phy_power_up(struct rtl_hw *hw)
{

        if (rtl8168_is_in_phy_disable_mode(hw))
                return;

        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        switch (hw->mcfg) {
        case CFG_METHOD_1 ... CFG_METHOD_13:
                rtl8168_mdio_write(hw, 0x0E, 0x0000);
                break;
        }

        rtl8168_mdio_write(hw, MII_BMCR, BMCR_ANENABLE);

        //wait mdc/mdio ready
        switch (hw->mcfg) {
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
                mdelay(10);
                break;
        }

        //wait ups resume (phy state 3)
        switch (hw->mcfg) {
        case CFG_METHOD_29 ... CFG_METHOD_35:
                rtl8168_wait_phy_ups_resume(hw, 3);
                break;
        }
}

void rtl8168_powerup_pll(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_9 ... CFG_METHOD_35:
                RTL_W8(hw, PMCH, RTL_R8(hw, PMCH) | BIT_7 | BIT_6);
                break;
        }

        rtl8168_phy_power_up(hw);
}

static void
rtl8168_phy_power_down(struct rtl_hw *hw)
{
        u32 csi_tmp;

        //mcu pme intr masks
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_24:
                csi_tmp = rtl8168_eri_read(hw, 0x1AB, 1, ERIAR_ExGMAC);
                csi_tmp &= ~( BIT_2 | BIT_3 | BIT_4 | BIT_5 | BIT_6 | BIT_7 );
                rtl8168_eri_write(hw, 0x1AB, 1, csi_tmp, ERIAR_ExGMAC);
                break;
        }

        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        switch (hw->mcfg) {
        case CFG_METHOD_1 ... CFG_METHOD_13:
                rtl8168_mdio_write(hw, 0x0E, 0x0200);
                rtl8168_mdio_write(hw, MII_BMCR, BMCR_PDOWN);
                break;
        case CFG_METHOD_14:
        case CFG_METHOD_15:
        case CFG_METHOD_29:
        case CFG_METHOD_30:
        case CFG_METHOD_35:
                rtl8168_mdio_write(hw, MII_BMCR, BMCR_ANENABLE | BMCR_PDOWN);
                break;
        case CFG_METHOD_21:
        case CFG_METHOD_22:
                rtl8168_mdio_write(hw, MII_BMCR, BMCR_ANENABLE | BMCR_PDOWN);
                break;
        case CFG_METHOD_23:
        case CFG_METHOD_24:
                rtl8168_mdio_write(hw, MII_BMCR, BMCR_ANENABLE | BMCR_PDOWN);
                break;
        default:
                rtl8168_mdio_write(hw, MII_BMCR, BMCR_PDOWN);
                break;
        }
}

void rtl8168_powerdown_pll(struct rtl_hw *hw)
{
        if (hw->DASH)
                return;

        rtl8168_phy_power_down(hw);

        switch (hw->mcfg) {
        case CFG_METHOD_9:
        case CFG_METHOD_10:
        //case CFG_METHOD_11:
        case CFG_METHOD_12:
        case CFG_METHOD_13:
        case CFG_METHOD_14:
        case CFG_METHOD_15:
        case CFG_METHOD_17:
        case CFG_METHOD_18:
        case CFG_METHOD_19:
        case CFG_METHOD_21:
        case CFG_METHOD_22:
        case CFG_METHOD_24:
        case CFG_METHOD_25:
        case CFG_METHOD_26:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
        case CFG_METHOD_29:
        case CFG_METHOD_30:
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
        case CFG_METHOD_35:
                RTL_W8(hw, PMCH, RTL_R8(hw, PMCH) & ~BIT_7);
                break;
        }

        //aldps pwrsave settings
        //switch (hw->mcfg) {
        //case CFG_METHOD_14 ... CFG_METHOD_15:
        //        RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) & ~BIT_6);
        //        break;
        //case CFG_METHOD_16 ... CFG_METHOD_33:
        //        RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) & ~BIT_6);
        //        RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) & ~BIT_6);
        //        break;
        //}
}


int
rtl8168_set_speed(struct rtl_hw *hw)
{
        int rc = TRUE;
        if (FALSE == rtl8168_set_speed_xmii(hw, hw->autoneg, hw->speed, hw->duplex, hw->advertising)) {
                //log set speed fail;
                rc = FALSE;
        }
        return rc;
}

static void
rtl8168_disable_aldps(struct rtl_hw *hw)
{
        u16 TmpUshort;

        TmpUshort = mdio_real_direct_read_phy_ocp(hw, 0xA430);
        if (TmpUshort & BIT_2) {
                u32 Timeout = 0, WaitCount = 200;

                rtl8168_clear_eth_phy_ocp_bit(hw, 0xA430, BIT_2);

                do {
                        udelay(100);

                        TmpUshort = rtl8168_mac_ocp_read(hw, 0xE908);

                        Timeout++;
                } while (!(TmpUshort & BIT_7) && Timeout < WaitCount);
        }
}

void
rtl8168_hw_phy_config(struct rtl_hw *hw)
{
        rtl8168_xmii_reset_enable(hw);

        if (HW_DASH_SUPPORT_TYPE_3(hw) && hw->HwPkgDet == 0x06)
                return;

        if (FALSE == rtl8168_init_hw_phy_mcu(hw)) {
                //TODO log print
                //printf("xing bypass phy mcu init!\n");
        }

        hw->hw_ops.hw_phy_config(hw);

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                rtl8168_disable_aldps(hw);
                break;
        }

        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        //if (hw->HwHasWrRamCodeToMicroP == TRUE) {
        //        if (hw->eee_enabled)
        //                rtl8168_enable_EEE(hw);
        //        else
        //                rtl8168_disable_EEE(hw);
        //}
}
