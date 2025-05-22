/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include "../r8168_base.h"
#include "../r8168_hw.h"
#include "../r8168_phy.h"

#include "rtl8168ep.h"

//for RTL8111EP, CFG_METHOD_23,27,28

void hw_init_rxcfg_8168ep(struct rtl_hw *hw)
{
        RTL_W32(hw, RxConfig, Rx_Single_fetch_V2 | (RX_DMA_BURST << RxCfgDMAShift) | RxEarly_off_V2);
}

static void hw_ephy_config_8168ep(struct rtl_hw *hw)
{
        u16 ephy_data;

        switch (hw->mcfg) {
        case CFG_METHOD_23:
                rtl8168_ephy_write(hw, 0x00, 0x10AB);
                rtl8168_ephy_write(hw, 0x06, 0xf030);
                rtl8168_ephy_write(hw, 0x08, 0x2006);
                rtl8168_ephy_write(hw, 0x0D, 0x1666);

                ephy_data = rtl8168_ephy_read(hw, 0x0C);
                ephy_data &= ~(BIT_13 | BIT_12 | BIT_11 | BIT_10 | BIT_9 | BIT_8 | BIT_7 | BIT_6 | BIT_5 | BIT_4);
                rtl8168_ephy_write(hw, 0x0C, ephy_data);

                break;
        case CFG_METHOD_27:
                rtl8168_ephy_write(hw, 0x00, 0x10A3);
                rtl8168_ephy_write(hw, 0x19, 0xFC00);
                rtl8168_ephy_write(hw, 0x1E, 0x20EA);

                break;
        case CFG_METHOD_28:
                rtl8168_ephy_write(hw, 0x00, 0x10AB);
                rtl8168_ephy_write(hw, 0x19, 0xFC00);
                rtl8168_ephy_write(hw, 0x1E, 0x20EB);
                rtl8168_ephy_write(hw, 0x0D, 0x1666);
                ClearPCIePhyBit(hw, 0x0B, BIT_0);
                SetPCIePhyBit(hw, 0x1D, BIT_14);
                ClearAndSetPCIePhyBit(hw,
                                      0x0C,
                                      BIT_13 | BIT_12 | BIT_11 | BIT_10 | BIT_8 | BIT_7 | BIT_6 | BIT_5,
                                      BIT_9 | BIT_4
                                     );

                break;
        default:
                break;
        }
}

static void hw_phy_config_8168ep(struct rtl_hw *hw)
{
        if (hw->mcfg == CFG_METHOD_23) {
                rtl8168_mdio_write(hw, 0x1F, 0x0A44);
                rtl8168_mdio_write(hw, 0x11, rtl8168_mdio_read(hw, 0x11) | (BIT_3 | BIT_2));
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

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
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x8012);
                rtl8168_mdio_write(hw, 0x14, rtl8168_mdio_read(hw, 0x14) | BIT_15);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                rtl8168_mdio_write(hw, 0x1F, 0x0C42);
                ClearAndSetEthPhyBit(hw,
                                     0x11,
                                     BIT_13,
                                     BIT_14
                                    );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                /*
                if (aspm) {
                        if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                                rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_2);
                        }
                }
                */
        } else if (hw->mcfg == CFG_METHOD_27 || hw->mcfg == CFG_METHOD_28) {
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
                rtl8168_mdio_write(hw, 0x11, (rtl8168_mdio_read(hw, 0x11) & ~BIT_13) | BIT_14);

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
                /*
                if (aspm) {
                        if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                                rtl8168_mdio_write(hw, 0x10, rtl8168_mdio_read(hw, 0x10) | BIT_2);
                        }
                }
                */
        }
}

static void hw_config_8168ep(struct rtl_hw *hw)
{
        u16 mac_ocp_data;
        //set_offset70F(hw, 0x27);

        rtl8168_eri_write(hw, 0xC8, 4, 0x00080002, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xCC, 1, 0x2F, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xD0, 1, 0x5F, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xE8, 4, 0x00100006, ERIAR_ExGMAC);

        /* adjust the trx fifo*/
        rtl8168_eri_write(hw, 0xCA, 2, 0x0370, ERIAR_ExGMAC);
        rtl8168_eri_write(hw, 0xEA, 1, 0x10, ERIAR_ExGMAC);

        /* disable share fifo */
        RTL_W32(hw, TxConfig, RTL_R32(hw, TxConfig) & ~BIT_7);

        RTL_W8(hw, Config3, RTL_R8(hw, Config3) & ~Beacon_en);

        //aldps pwr save and d3c en
        //RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) | BIT_6);
        //RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) | BIT_6);

        //10m idle en
        //RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) | BIT_7);

        //rss setting eri 0xC0 B8 moved to rx_init

        //EEE led enable
        RTL_W8(hw, 0x1B, RTL_R8(hw, 0x1B) & ~0x07);

        /*
        if (aspm)
        RTL_W8(hw, 0xF1, RTL_R8(hw, 0xF1) | BIT_7);
        */

        //csi_tmp = rtl8168_eri_read(hw, 0x1B0, 4, ERIAR_ExGMAC);
        //csi_tmp &= ~BIT_12;
        //rtl8168_eri_write(hw, 0x1B0, 4, csi_tmp, ERIAR_ExGMAC);

        //csi_tmp = rtl8168_eri_read(hw, 0x2FC, 1, ERIAR_ExGMAC);
        //csi_tmp &= ~(BIT_0 | BIT_1 | BIT_2);
        //csi_tmp |= (BIT_0 | BIT_1);
        //rtl8168_eri_write(hw, 0x2FC, 1, csi_tmp, ERIAR_ExGMAC);

        //csi_tmp = rtl8168_eri_read(hw, 0x1D0, 1, ERIAR_ExGMAC);
        //csi_tmp |= BIT_1;
        //rtl8168_eri_write(hw, 0x1D0, 1, csi_tmp, ERIAR_ExGMAC);

        if (hw->mcfg == CFG_METHOD_27 || hw->mcfg == CFG_METHOD_28) {
                rtl8168_oob_mutex_lock(hw);
                rtl8168_eri_write(hw, 0x5F0, 2, 0x4F87, ERIAR_ExGMAC);
                rtl8168_oob_mutex_unlock(hw);
        }

        rtl8168_mac_ocp_write(hw, 0xC140, 0xFFFF);
        rtl8168_mac_ocp_write(hw, 0xC142, 0xFFFF);

        if (hw->mcfg == CFG_METHOD_28) {
                mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xD3E2);
                mac_ocp_data &= 0xF000;
                mac_ocp_data |= 0xAFD;
                rtl8168_mac_ocp_write(hw, 0xD3E2, mac_ocp_data);

                mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xD3E4);
                mac_ocp_data &= 0xFF00;
                rtl8168_mac_ocp_write(hw, 0xD3E4, mac_ocp_data);

                mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xE860);
                mac_ocp_data |= BIT_7;
                rtl8168_mac_ocp_write(hw, 0xE860, mac_ocp_data);
        }
}

const struct rtl_hw_ops rtl8111ep_ops = {
        .hw_config = hw_config_8168ep,
        .hw_init_rxcfg = hw_init_rxcfg_8168ep,
        .hw_ephy_config = hw_ephy_config_8168ep,
        .hw_phy_config = hw_phy_config_8168ep,
        .hw_mac_mcu_config = hw_mac_mcu_config_8168ep,
        .hw_phy_mcu_config = hw_phy_mcu_config_8168ep,
};
