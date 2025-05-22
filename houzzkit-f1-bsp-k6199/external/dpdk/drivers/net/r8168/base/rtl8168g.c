/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include "../r8168_base.h"
#include "../r8168_hw.h"
#include "../r8168_phy.h"

#include "rtl8168g.h"

//for RTL8111G,RTL8111GU, CFG_METHOD_21,22,24,25

void hw_init_rxcfg_8168g(struct rtl_hw *hw)
{
        RTL_W32(hw, RxConfig, Rx_Single_fetch_V2 | (RX_DMA_BURST << RxCfgDMAShift) | RxEarly_off_V2);
}

static void hw_ephy_config_8168g(struct rtl_hw *hw)
{
        u16 ephy_data;

        switch (hw->mcfg) {
        case CFG_METHOD_21:
        case CFG_METHOD_22:
                ephy_data = rtl8168_ephy_read(hw, 0x00);
                ephy_data &= ~(BIT_3);
                rtl8168_ephy_write(hw, 0x00, ephy_data);
                ephy_data = rtl8168_ephy_read(hw, 0x0C);
                ephy_data &= ~(BIT_13 | BIT_12 | BIT_11 | BIT_10 | BIT_9 | BIT_8 | BIT_7 | BIT_6 | BIT_5 | BIT_4);
                ephy_data |= (BIT_5 | BIT_11);
                rtl8168_ephy_write(hw, 0x0C, ephy_data);

                ephy_data = rtl8168_ephy_read(hw, 0x1E);
                ephy_data |= (BIT_0);
                rtl8168_ephy_write(hw, 0x1E, ephy_data);

                ephy_data = rtl8168_ephy_read(hw, 0x19);
                ephy_data &= ~(BIT_15);
                rtl8168_ephy_write(hw, 0x19, ephy_data);

                break;
        case CFG_METHOD_25:
                ephy_data = rtl8168_ephy_read(hw, 0x00);
                ephy_data &= ~BIT_3;
                rtl8168_ephy_write(hw, 0x00, ephy_data);
                ephy_data = rtl8168_ephy_read(hw, 0x0C);
                ephy_data &= ~(BIT_13 | BIT_12 | BIT_11 | BIT_10| BIT_9 | BIT_8 | BIT_7 | BIT_6 | BIT_5 | BIT_4);
                ephy_data |= (BIT_5 | BIT_11);
                rtl8168_ephy_write(hw, 0x0C, ephy_data);

                rtl8168_ephy_write(hw, 0x19, 0x7C00);
                rtl8168_ephy_write(hw, 0x1E, 0x20EB);
                rtl8168_ephy_write(hw, 0x0D, 0x1666);
                rtl8168_ephy_write(hw, 0x00, 0x10A3);
                rtl8168_ephy_write(hw, 0x06, 0xF050);

                SetPCIePhyBit(hw, 0x04, BIT_4);
                ClearPCIePhyBit(hw, 0x1D, BIT_14);

                break;
        default:
                break;
        }
}

static void hw_phy_config_cfg21(struct rtl_hw *hw)
{
        u16 gphy_val;

        rtl8168_mdio_write(hw, 0x1F, 0x0A46);
        gphy_val = rtl8168_mdio_read(hw, 0x10);
        rtl8168_mdio_write(hw, 0x1F, 0x0BCC);
        if (gphy_val & BIT_8)
                rtl8168_clear_eth_phy_bit(hw, 0x12, BIT_15);
        else
                rtl8168_set_eth_phy_bit(hw, 0x12, BIT_15);
        rtl8168_mdio_write(hw, 0x1F, 0x0A46);
        gphy_val = rtl8168_mdio_read(hw, 0x13);
        rtl8168_mdio_write(hw, 0x1F, 0x0C41);
        if (gphy_val & BIT_8)
                rtl8168_set_eth_phy_bit(hw, 0x15, BIT_1);
        else
                rtl8168_clear_eth_phy_bit(hw, 0x15, BIT_1);

        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_2 | BIT_3);

        rtl8168_mdio_write(hw, 0x1F, 0x0BCC);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) & ~BIT_8);
        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_7);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_6);
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8084);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) & ~(BIT_14 | BIT_13));
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_12);
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_1);
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_0);

        rtl8168_mdio_write(hw, 0x1F, 0x0A4B);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_2);

        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8012);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) | BIT_15);

        rtl8168_mdio_write(hw, 0x1F, 0x0C42);
        gphy_val = rtl8168_mdio_read(hw, 0x11);
        gphy_val |= BIT_14;
        gphy_val &= ~BIT_13;
        rtl8168_mdio_write(hw, 0x11, gphy_val);

        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x809A);
        rtl8168_mdio_write(hw, 0x14, 0x8022);
        rtl8168_mdio_write(hw, 0x13, 0x80A0);
        gphy_val = rtl8168_mdio_read(hw, 0x14) & 0x00FF;
        gphy_val |= 0x1000;
        rtl8168_mdio_write(hw, 0x14, gphy_val);
        rtl8168_mdio_write(hw, 0x13, 0x8088);
        rtl8168_mdio_write(hw, 0x14, 0x9222);

        //if (aspm) {
        //        if (hw->HwHasWrRamCodeToMicroP == TRUE) {
        //                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        //                rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_2);
        //        }
        //}

        rtl8168_mdio_write(hw, 0x1F, 0x0000);
}

static void hw_phy_config_cfg24(struct rtl_hw *hw)
{
        u16 gphy_val;
        rtl8168_mdio_write(hw, 0x1F, 0x0BCC);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) & ~BIT_8);
        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_7);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_6);
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8084);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) & ~(BIT_14 | BIT_13));
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_12);
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_1);
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_0);
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8012);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) | BIT_15);

        rtl8168_mdio_write(hw, 0x1F, 0x0C42);
        gphy_val = rtl8168_mdio_read(hw, 0x11);
        gphy_val |= BIT_14;
        gphy_val &= ~BIT_13;
        rtl8168_mdio_write(hw, 0x11, gphy_val);

        //if (aspm) {
        //        if (hw->HwHasWrRamCodeToMicroP == TRUE) {
        //                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        //                rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_2);
        //        }
        //}

}

static void hw_phy_config_cfg25(struct rtl_hw *hw)
{
        rtl8168_mdio_write(hw, 0x1F, 0x0BCC);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) & ~BIT_8);
        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_7);
        rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | BIT_6);
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8084);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) & ~(BIT_14 | BIT_13));
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_12);
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_1);
        rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_0);

        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8012);
        rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) | BIT_15);

        rtl8168_mdio_write(hw, 0x1F, 0x0BCE);
        rtl8168_mdio_write(hw, 0x12, 0x8860);

        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x80F3);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x8B00);
        rtl8168_mdio_write(hw, 0x13, 0x80F0);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x3A00);
        rtl8168_mdio_write(hw, 0x13, 0x80EF);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x0500);
        rtl8168_mdio_write(hw, 0x13, 0x80F6);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x6E00);
        rtl8168_mdio_write(hw, 0x13, 0x80EC);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x6800);
        rtl8168_mdio_write(hw, 0x13, 0x80ED);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x7C00);
        rtl8168_mdio_write(hw, 0x13, 0x80F2);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0xF400);
        rtl8168_mdio_write(hw, 0x13, 0x80F4);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x8500);
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8110);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0xA800);
        rtl8168_mdio_write(hw, 0x13, 0x810F);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x1D00);
        rtl8168_mdio_write(hw, 0x13, 0x8111);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0xF500);
        rtl8168_mdio_write(hw, 0x13, 0x8113);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x6100);
        rtl8168_mdio_write(hw, 0x13, 0x8115);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x9200);
        rtl8168_mdio_write(hw, 0x13, 0x810E);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x0400);
        rtl8168_mdio_write(hw, 0x13, 0x810C);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x7C00);
        rtl8168_mdio_write(hw, 0x13, 0x810B);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x5A00);
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x80D1);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0xFF00);
        rtl8168_mdio_write(hw, 0x13, 0x80CD);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x9E00);
        rtl8168_mdio_write(hw, 0x13, 0x80D3);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x0E00);
        rtl8168_mdio_write(hw, 0x13, 0x80D5);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0xCA00);
        rtl8168_mdio_write(hw, 0x13, 0x80D7);
        rtl8168_mdio_write(hw, 0x14, (rtl8168_mdio_read(hw, 0x14) & ~0xFF00) | 0x8400);

        //if (aspm) {
        //        if (hw->HwHasWrRamCodeToMicroP == TRUE) {
        //                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        //                rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_2);
        //        }
        //}

}

static void hw_phy_config_8168g(struct rtl_hw *hw)
{

        if (hw->mcfg == CFG_METHOD_21) {

                hw_phy_config_cfg21(hw);

        } else if (hw->mcfg == CFG_METHOD_22) {
                //do nothing
        } else if (hw->mcfg == CFG_METHOD_24) {

                hw_phy_config_cfg24(hw);

        } else if (hw->mcfg == CFG_METHOD_25) {

                hw_phy_config_cfg25(hw);

        }

        //disable EthPhyPPSW
        rtl8168_mdio_write(hw, 0x1F, 0x0BCD);
        rtl8168_mdio_write(hw, 0x14, 0x5065);
        rtl8168_mdio_write(hw, 0x14, 0xD065);
        rtl8168_mdio_write(hw, 0x1F, 0x0BC8);
        rtl8168_mdio_write(hw, 0x11, 0x5655);
        rtl8168_mdio_write(hw, 0x1F, 0x0BCD);
        rtl8168_mdio_write(hw, 0x14, 0x1065);
        rtl8168_mdio_write(hw, 0x14, 0x9065);
        rtl8168_mdio_write(hw, 0x14, 0x1065);
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        //if (aspm)
        //	rtl8168_enable_ocp_phy_power_saving(hw);

}

static void hw_config_8168g(struct rtl_hw *hw)
{
        u32 csi_tmp;

        //set_offset70F(hw, 0x27);

        //if (hw->mcfg == CFG_METHOD_21 || hw->mcfg == CFG_METHOD_22)
        //        set_offset711(hw, 0x04);

        //share fifo rx params
        rtl8168_eri_write(hw, 0xC8, 4, 0x00080002, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xCC, 1, 0x38, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xD0, 1, 0x48, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xE8, 4, 0x00100006, ERIAR_ExGMAC);

        /* adjust the trx fifo*/
        rtl8168_eri_write(hw, 0xCA, 2, 0x0370, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xEA, 1, 0x10, ERIAR_ExGMAC);

        /* disable share fifo */
        RTL_W32(hw, TxConfig, RTL_R32(hw, TxConfig) & ~BIT_7);

        //ERI 0xDC[0] moved to rx_init

        RTL_W8(hw, Config3, RTL_R8(hw, Config3) & ~Beacon_en);

        //EEE led enable
        RTL_W8(hw, 0x1B, RTL_R8(hw, 0x1B) & ~0x07);

        RTL_W8(hw, Config2, RTL_R8(hw, Config2) & ~PMSTS_En);

        //if (aspm)
        //        RTL_W8(hw, 0xF1, RTL_R8(hw, 0xF1) | BIT_7);

        //aldps pwr save and d3c en
        //RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) | BIT_6);
        //RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) | BIT_6);

        //10m idle en
        //RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) | BIT_7);

        //rss setting eri 0xC0 B8 moved to rx_init

        //pwrcut CR
        //rtl8168_eri_write(hw, 0x5F0, 2, 0x4F87, ERIAR_ExGMAC);

        //clkreq exit masks
        csi_tmp = rtl8168_eri_read(hw, 0xD4, 4, ERIAR_ExGMAC);
        csi_tmp |= (BIT_7 | BIT_8 | BIT_9 | BIT_10 | BIT_11 | BIT_12);
        rtl8168_eri_write(hw, 0xD4, 4, csi_tmp, ERIAR_ExGMAC);

        //crc wake disable
        rtl8168_mac_ocp_write(hw, 0xC140, 0xFFFF);

        //EEE CR
        //csi_tmp = rtl8168_eri_read(hw, 0x1B0, 4, ERIAR_ExGMAC);
        //csi_tmp &= ~BIT_12;
        //rtl8168_eri_write(hw, 0x1B0, 4, csi_tmp, ERIAR_ExGMAC);

        //clk req params
        //csi_tmp = rtl8168_eri_read(hw, 0x2FC, 1, ERIAR_ExGMAC);
        //csi_tmp &= ~(BIT_0 | BIT_1 | BIT_2);
        //csi_tmp |= BIT_0;
        //rtl8168_eri_write(hw, 0x2FC, 1, csi_tmp, ERIAR_ExGMAC);

        //EEEP CR
        //csi_tmp = rtl8168_eri_read(hw, 0x1D0, 1, ERIAR_ExGMAC);
        //csi_tmp |= BIT_1;
        //rtl8168_eri_write(hw, 0x1D0, 1, csi_tmp, ERIAR_ExGMAC);

}

const struct rtl_hw_ops rtl8111g_ops = {
        .hw_config = hw_config_8168g,
        .hw_init_rxcfg = hw_init_rxcfg_8168g,
        .hw_ephy_config = hw_ephy_config_8168g,
        .hw_phy_config = hw_phy_config_8168g,
        .hw_mac_mcu_config = hw_mac_mcu_config_8168g,
        .hw_phy_mcu_config = hw_phy_mcu_config_8168g,
};
