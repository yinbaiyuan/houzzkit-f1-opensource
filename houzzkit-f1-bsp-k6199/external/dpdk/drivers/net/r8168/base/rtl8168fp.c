/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include "../r8168_base.h"
#include "../r8168_hw.h"
#include "../r8168_phy.h"

#include "rtl8168fp.h"

//for RTL8111FP, CFG_METHOD_31,32,33,34

void hw_init_rxcfg_8168fp(struct rtl_hw *hw)
{
        RTL_W32(hw, RxConfig, Rx_Single_fetch_V2 | (RX_DMA_BURST << RxCfgDMAShift) | RxEarly_off_V2);
}

static void hw_ephy_config_8168fp(struct rtl_hw *hw)
{
        ClearAndSetPCIePhyBit(hw,
                              0x19,
                              BIT_6,
                              (BIT_12 | BIT_8)
                             );
        ClearAndSetPCIePhyBit(hw,
                              0x59,
                              BIT_6,
                              (BIT_12 | BIT_8)
                             );

        ClearPCIePhyBit(hw, 0x0C, BIT_4);
        ClearPCIePhyBit(hw, 0x4C, BIT_4);
        ClearPCIePhyBit(hw, 0x0B, BIT_0);
}

static void hw_phy_config_8168fp(struct rtl_hw *hw)
{
        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x808E);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x4800
                            );
        rtl8168_mdio_write(hw, 0x13, 0x8090);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0xCC00
                            );
        rtl8168_mdio_write(hw, 0x13, 0x8092);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0xB000
                            );
        rtl8168_mdio_write(hw, 0x13, 0x8088);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x6000
                            );
        rtl8168_mdio_write(hw, 0x13, 0x808B);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0x3F00,
                             0x0B00
                            );
        rtl8168_mdio_write(hw, 0x13, 0x808D);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0x1F00,
                             0x0600
                            );
        rtl8168_mdio_write(hw, 0x13, 0x808C);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0xB000
                            );

        rtl8168_mdio_write(hw, 0x13, 0x80A0);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x2800
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80A2);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x5000
                            );
        rtl8168_mdio_write(hw, 0x13, 0x809B);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xF800,
                             0xB000
                            );
        rtl8168_mdio_write(hw, 0x13, 0x809A);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x4B00
                            );
        rtl8168_mdio_write(hw, 0x13, 0x809D);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0x3F00,
                             0x0800
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80A1);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x7000
                            );
        rtl8168_mdio_write(hw, 0x13, 0x809F);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0x1F00,
                             0x0300
                            );
        rtl8168_mdio_write(hw, 0x13, 0x809E);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x8800
                            );

        rtl8168_mdio_write(hw, 0x13, 0x80B2);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x2200
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80AD);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xF800,
                             0x9800
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80AF);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0x3F00,
                             0x0800
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80B3);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x6F00
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80B1);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0x1F00,
                             0x0300
                            );
        rtl8168_mdio_write(hw, 0x13, 0x80B0);
        ClearAndSetEthPhyBit(hw,
                             0x14,
                             0xFF00,
                             0x9300
                            );
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8011);
        rtl8168_set_eth_phy_bit(hw, 0x14, BIT_11);
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_set_eth_phy_bit(hw, 0x11, BIT_11);
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8016);
        rtl8168_set_eth_phy_bit(hw, 0x14, BIT_10);
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        /*
        if (aspm) {
                if (!HW_SUPP_SERDES_PHY(hw) &&
                        HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                        rtl8168_set_eth_phy_bit(hw, 0x10, BIT_2);
                        rtl8168_mdio_write(hw, 0x1F, 0x0000);
                }
        }
        */

        //disable EthPhyPPSW
        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_clear_eth_phy_bit( hw, 0x11, BIT_7 );
        rtl8168_mdio_write(hw, 0x1F, 0x0000);
}

static void hw_config_8168fp(struct rtl_hw *hw)
{
        u16 mac_ocp_data;
        u32 csi_tmp;
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

        //UPS params
        //if (hw->RequireAdjustUpsTxLinkPulseTiming) {
        //        mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xD412);
        //        mac_ocp_data &= ~(0x0FFF);
        //        mac_ocp_data |= hw->SwrCnt1msIni;
        //        rtl8168_mac_ocp_write(hw, 0xD412, mac_ocp_data);
        //}

        //EEE pwrsave params
        mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xE056);
        mac_ocp_data &= ~(BIT_7 | BIT_6 | BIT_5 | BIT_4);
        rtl8168_mac_ocp_write(hw, 0xE056, mac_ocp_data);

        //hw->HwSuppSerDesPhyVer = 1 or 2
        if (FALSE == HW_SUPP_SERDES_PHY(hw))
                rtl8168_mac_ocp_write(hw, 0xEA80, 0x0003);
        else
                rtl8168_mac_ocp_write(hw, 0xEA80, 0x0000);

        rtl8168_oob_mutex_lock(hw);
        mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xE052);
        mac_ocp_data &= ~(BIT_3 | BIT_0);
        rtl8168_mac_ocp_write(hw, 0xE052, mac_ocp_data);
        rtl8168_oob_mutex_unlock(hw);

        //UPS reg save
        //mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xD420);
        //mac_ocp_data &= ~(BIT_11 | BIT_10 | BIT_9 | BIT_8 | BIT_7 | BIT_6 | BIT_5 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0);
        //mac_ocp_data |= 0x45F;
        //rtl8168_mac_ocp_write(hw, 0xD420, mac_ocp_data);

        RTL_W8(hw, Config3, RTL_R8(hw, Config3) & ~Beacon_en);

        RTL_W8(hw, 0x1B, RTL_R8(hw, 0x1B) & ~0x07);

        RTL_W8(hw, Config2, RTL_R8(hw, Config2) & ~PMSTS_En);

        /*
        if (aspm)
        RTL_W8(hw, 0xF1, RTL_R8(hw, 0xF1) | BIT_7);
        */

        //hw->HwSuppSerDesPhyVer = 1 or 2
        if (FALSE == HW_SUPP_SERDES_PHY(hw)) {
                RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) | BIT_6);
                RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) | BIT_6);
                RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) | BIT_7);
        } else {
                RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) & ~BIT_6);
                RTL_W8(hw, 0xF2, RTL_R8(hw, 0xF2) & ~BIT_6);
                RTL_W8(hw, 0xD0, RTL_R8(hw, 0xD0) & ~BIT_7);
        }

        //rss setting eri 0xC0 B8 moved to rx_init

        rtl8168_oob_mutex_lock(hw);
        rtl8168_eri_write(hw, 0x5F0, 2, 0x4000, ERIAR_ExGMAC);
        rtl8168_oob_mutex_unlock(hw);

        if (hw->mcfg == CFG_METHOD_32 || hw->mcfg == CFG_METHOD_33) {
                csi_tmp = rtl8168_eri_read(hw, 0xD4, 4, ERIAR_ExGMAC);
                csi_tmp |= BIT_4;
                rtl8168_eri_write(hw, 0xD4, 4, csi_tmp, ERIAR_ExGMAC);
        }

        rtl8168_mac_ocp_write(hw, 0xC140, 0xFFFF);
        rtl8168_mac_ocp_write(hw, 0xC142, 0xFFFF);

        //csi_tmp = rtl8168_eri_read(hw, 0x1B0, 4, ERIAR_ExGMAC);
        //csi_tmp &= ~BIT_12;
        //rtl8168_eri_write(hw, 0x1B0, 4, csi_tmp, ERIAR_ExGMAC);

        csi_tmp = rtl8168_eri_read(hw, 0x2FC, 1, ERIAR_ExGMAC);
        csi_tmp &= ~(BIT_0 | BIT_1);
        csi_tmp |= BIT_0;
        rtl8168_eri_write(hw, 0x2FC, 1, csi_tmp, ERIAR_ExGMAC);

        csi_tmp = rtl8168_eri_read(hw, 0x1D0, 1, ERIAR_ExGMAC);
        csi_tmp &= ~BIT_1;
        rtl8168_eri_write(hw, 0x1D0, 1, csi_tmp, ERIAR_ExGMAC);
}

const struct rtl_hw_ops rtl8111fp_ops = {
        .hw_config = hw_config_8168fp,
        .hw_init_rxcfg = hw_init_rxcfg_8168fp,
        .hw_ephy_config = hw_ephy_config_8168fp,
        .hw_phy_config = hw_phy_config_8168fp,
        .hw_mac_mcu_config = hw_mac_mcu_config_8168fp,
        .hw_phy_mcu_config = hw_phy_mcu_config_8168fp,
};
