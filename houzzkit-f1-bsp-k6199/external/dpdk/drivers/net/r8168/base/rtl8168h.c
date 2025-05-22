/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include "../r8168_base.h"
#include "../r8168_hw.h"
#include "../r8168_phy.h"

#include "rtl8168h.h"

//for RTL8111H, CFG_METHOD_29,30,35

void hw_init_rxcfg_8168h(struct rtl_hw *hw)
{
        RTL_W32(hw, RxConfig, Rx_Single_fetch_V2 | (RX_DMA_BURST << RxCfgDMAShift) | RxEarly_off_V2);
}

static void hw_ephy_config_8168h(struct rtl_hw* hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_29:
        case CFG_METHOD_30:
                ClearPCIePhyBit(hw, 0x1E, BIT_11);

                SetPCIePhyBit(hw, 0x1E, BIT_0);
                SetPCIePhyBit(hw, 0x1D, BIT_11);

                rtl8168_ephy_write(hw, 0x05, 0x2089);
                rtl8168_ephy_write(hw, 0x06, 0x5881);

                rtl8168_ephy_write(hw, 0x04, 0x854A);
                rtl8168_ephy_write(hw, 0x01, 0x068B);

                break;
        case CFG_METHOD_35:
                rtl8168_clear_mcu_ocp_bit(hw, 0xDE28, (BIT_1 | BIT_0));
                rtl8168_set_mcu_ocp_bit(hw, 0xDE38, (BIT_2));

                break;
        default:
                break;
        }
}

static int rtl8168h_RequireAdcBiasPatch_check(struct rtl_hw *hw, u16 *offset)
{
        int ret;
        u16 ioffset_p3, ioffset_p2, ioffset_p1, ioffset_p0;
        u16 TmpUshort;

        rtl8168_mac_ocp_write( hw, 0xDD02, 0x807D);
        TmpUshort = rtl8168_mac_ocp_read( hw, 0xDD02 );
        ioffset_p3 = ( (TmpUshort & BIT_7) >>7 );
        ioffset_p3 <<= 3;
        TmpUshort = rtl8168_mac_ocp_read( hw, 0xDD00 );

        ioffset_p3 |= ((TmpUshort & (BIT_15 | BIT_14 | BIT_13))>>13);

        ioffset_p2 = ((TmpUshort & (BIT_12|BIT_11|BIT_10|BIT_9))>>9);
        ioffset_p1 = ((TmpUshort & (BIT_8|BIT_7|BIT_6|BIT_5))>>5);

        ioffset_p0 = ( (TmpUshort & BIT_4) >>4 );
        ioffset_p0 <<= 3;
        ioffset_p0 |= (TmpUshort & (BIT_2| BIT_1 | BIT_0));

        if ((ioffset_p3 == 0x0F) && (ioffset_p2 == 0x0F) && (ioffset_p1 == 0x0F) && (ioffset_p0 == 0x0F)) {
                ret = FALSE;
        } else {
                ret = TRUE;
                *offset = (ioffset_p3<<12)|(ioffset_p2<<8)|(ioffset_p1<<4)|(ioffset_p0);
        }

        return ret;
}

static void hw_phy_config_8168h(struct rtl_hw *hw)
{
        if (hw->mcfg == CFG_METHOD_29) {
                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x809b);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xF800,
                                      0x8000
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x80A2);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0x8000
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x80A4);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0x8500
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x809C);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0xbd00
                                    );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x80AD);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xF800,
                                      0x7000
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x80B4);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0x5000
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x80AC);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0x4000
                                    );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x808E);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0x1200
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x8090);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0xE500
                                    );
                rtl8168_mdio_write(hw, 0x13, 0x8092);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      0xFF00,
                                      0x9F00
                                    );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                        u16 dout_tapbin;
                        u32 gphy_val;

                        dout_tapbin = 0x0000;
                        rtl8168_mdio_write( hw, 0x1F, 0x0A46 );
                        gphy_val = rtl8168_mdio_read( hw, 0x13 );
                        gphy_val &= (BIT_1|BIT_0);
                        gphy_val <<= 2;
                        dout_tapbin |= gphy_val;

                        gphy_val = rtl8168_mdio_read( hw, 0x12 );
                        gphy_val &= (BIT_15|BIT_14);
                        gphy_val >>= 14;
                        dout_tapbin |= gphy_val;

                        dout_tapbin = ~( dout_tapbin^BIT_3 );
                        dout_tapbin <<= 12;
                        dout_tapbin &= 0xF000;

                        rtl8168_mdio_write( hw, 0x1F, 0x0A43 );

                        rtl8168_mdio_write( hw, 0x13, 0x827A );
                        ClearAndSetEthPhyBit( hw,
                                              0x14,
                                              BIT_15|BIT_14|BIT_13|BIT_12,
                                              dout_tapbin
                                            );


                        rtl8168_mdio_write( hw, 0x13, 0x827B );
                        ClearAndSetEthPhyBit( hw,
                                              0x14,
                                              BIT_15|BIT_14|BIT_13|BIT_12,
                                              dout_tapbin
                                            );


                        rtl8168_mdio_write( hw, 0x13, 0x827C );
                        ClearAndSetEthPhyBit( hw,
                                              0x14,
                                              BIT_15|BIT_14|BIT_13|BIT_12,
                                              dout_tapbin
                                            );


                        rtl8168_mdio_write( hw, 0x13, 0x827D );
                        ClearAndSetEthPhyBit( hw,
                                              0x14,
                                              BIT_15|BIT_14|BIT_13|BIT_12,
                                              dout_tapbin
                                            );

                        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                        rtl8168_mdio_write(hw, 0x13, 0x8011);
                        rtl8168_set_eth_phy_bit(hw, 0x14, BIT_11);
                        rtl8168_mdio_write(hw, 0x1F, 0x0A42);
                        rtl8168_set_eth_phy_bit(hw, 0x16, BIT_1);
                }

                rtl8168_mdio_write(hw, 0x1F, 0x0A44);
                rtl8168_set_eth_phy_bit( hw, 0x11, BIT_11 );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);


                rtl8168_mdio_write(hw, 0x1F, 0x0BCA);
                ClearAndSetEthPhyBit( hw,
                                      0x17,
                                      (BIT_13 | BIT_12),
                                      BIT_14
                                    );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x803F);
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x13, 0x8047);
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x13, 0x804F);
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x13, 0x8057);
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x13, 0x805F);
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x13, 0x8067 );
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x13, 0x806F );
                rtl8168_clear_eth_phy_bit( hw, 0x14, (BIT_13 | BIT_12));
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                //if (aspm) {
                //        if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                //                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                //                rtl8168_set_eth_phy_bit( hw, 0x10, BIT_2 );
                //                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                //        }
                //}
        } else if (hw->mcfg == CFG_METHOD_30) {
                u16 offset;

                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x808A);
                ClearAndSetEthPhyBit( hw,
                                      0x14,
                                      BIT_5 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0,
                                      0x0A );

                if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                        rtl8168_mdio_write(hw, 0x13, 0x8011);
                        rtl8168_set_eth_phy_bit(hw, 0x14, BIT_11);
                        rtl8168_mdio_write(hw, 0x1F, 0x0A42);
                        rtl8168_set_eth_phy_bit(hw, 0x16, BIT_1);
                }

                rtl8168_mdio_write(hw, 0x1F, 0x0A44);
                rtl8168_set_eth_phy_bit( hw, 0x11, BIT_11 );
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                if (rtl8168h_RequireAdcBiasPatch_check(hw, &offset)) {
                        rtl8168_mdio_write(hw, 0x1F, 0x0BCF);
                        rtl8168_mdio_write(hw, 0x16, offset);
                        rtl8168_mdio_write(hw, 0x1F, 0x0000);
                }

                {
                        u16 rlen;
                        u32 gphy_val;

                        rtl8168_mdio_write(hw, 0x1F, 0x0BCD);
                        gphy_val = rtl8168_mdio_read( hw, 0x16 );
                        gphy_val &= 0x000F;

                        if ( gphy_val > 3 ) {
                                rlen = gphy_val - 3;
                        } else {
                                rlen = 0;
                        }

                        gphy_val = rlen | (rlen<<4) | (rlen<<8) | (rlen<<12);

                        rtl8168_mdio_write(hw, 0x1F, 0x0BCD);
                        rtl8168_mdio_write(hw, 0x17, gphy_val);
                        rtl8168_mdio_write(hw, 0x1F, 0x0000);
                }

                if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                        rtl8168_mdio_write(hw, 0x13, 0x85FE);
                        ClearAndSetEthPhyBit(
                                hw,
                                0x14,
                                BIT_15|BIT_14|BIT_13|BIT_12|BIT_11|BIT_10|BIT_8,
                                BIT_9);
                        rtl8168_mdio_write(hw, 0x13, 0x85FF);
                        ClearAndSetEthPhyBit(
                                hw,
                                0x14,
                                BIT_15|BIT_14|BIT_13|BIT_12,
                                BIT_11|BIT_10|BIT_9|BIT_8);
                        rtl8168_mdio_write(hw, 0x13, 0x814B);
                        ClearAndSetEthPhyBit(
                                hw,
                                0x14,
                                BIT_15|BIT_14|BIT_13|BIT_11|BIT_10|BIT_9|BIT_8,
                                BIT_12);
                }

                //if (aspm) {
                //        if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                //                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                //                rtl8168_set_eth_phy_bit( hw, 0x10, BIT_2 );
                //                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                //        }
                //}
        } else if (hw->mcfg == CFG_METHOD_35) {
                rtl8168_mdio_write(hw, 0x1F, 0x0A44);
                rtl8168_set_eth_phy_bit(hw, 0x11, BIT_11);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);


                rtl8168_mdio_write(hw, 0x1F, 0x0A4C);
                rtl8168_clear_eth_phy_bit(hw, 0x15, (BIT_14 | BIT_13));
                rtl8168_mdio_write(hw, 0x1F, 0x0000);


                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x81B9);
                rtl8168_mdio_write(hw, 0x14, 0x2000);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);


                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x81D4);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0xFF00,
                                     0x6600);
                rtl8168_mdio_write(hw, 0x13, 0x81CB);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0xFF00,
                                     0x3500);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);


                rtl8168_mdio_write(hw, 0x1F, 0x0A80);
                ClearAndSetEthPhyBit(hw,
                                     0x16,
                                     0x000F,
                                     0x0005);
                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x8016);
                rtl8168_set_eth_phy_bit(hw, 0x14, BIT_13);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x811E);
                rtl8168_mdio_write(hw, 0x14, 0xDECA);

                rtl8168_mdio_write(hw, 0x13, 0x811C);
                rtl8168_mdio_write(hw, 0x14, 0x8008);
                rtl8168_mdio_write(hw, 0x13, 0x8118);
                rtl8168_mdio_write(hw, 0x14, 0xF8B4);
                rtl8168_mdio_write(hw, 0x13, 0x811A);
                rtl8168_mdio_write(hw, 0x14, 0x1A04);

                rtl8168_mdio_write(hw, 0x13, 0x8134);
                rtl8168_mdio_write(hw, 0x14, 0xDECA);
                rtl8168_mdio_write(hw, 0x13, 0x8132);
                rtl8168_mdio_write(hw, 0x14, 0xA008);
                rtl8168_mdio_write(hw, 0x13, 0x812E);
                rtl8168_mdio_write(hw, 0x14, 0x00B5);
                rtl8168_mdio_write(hw, 0x13, 0x8130);
                rtl8168_mdio_write(hw, 0x14, 0x1A04);

                rtl8168_mdio_write(hw, 0x13, 0x8112);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0xFF00,
                                     0x7300);
                rtl8168_mdio_write(hw, 0x13, 0x8106);
                rtl8168_mdio_write(hw, 0x14, 0xA209);
                rtl8168_mdio_write(hw, 0x13, 0x8108);
                rtl8168_mdio_write(hw, 0x14, 0x13B0);
                rtl8168_mdio_write(hw, 0x13, 0x8103);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0xF800,
                                     0xB800);
                rtl8168_mdio_write(hw, 0x13, 0x8105);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0xFF00,
                                     0x0A00);


                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x87EB);
                rtl8168_mdio_write(hw, 0x14, 0x0018);
                rtl8168_mdio_write(hw, 0x13, 0x87EB);
                rtl8168_mdio_write(hw, 0x14, 0x0018);
                rtl8168_mdio_write(hw, 0x13, 0x87ED);
                rtl8168_mdio_write(hw, 0x14, 0x0733);
                rtl8168_mdio_write(hw, 0x13, 0x87EF);
                rtl8168_mdio_write(hw, 0x14, 0x08DC);
                rtl8168_mdio_write(hw, 0x13, 0x87F1);
                rtl8168_mdio_write(hw, 0x14, 0x08DF);
                rtl8168_mdio_write(hw, 0x13, 0x87F3);
                rtl8168_mdio_write(hw, 0x14, 0x0C79);
                rtl8168_mdio_write(hw, 0x13, 0x87F5);
                rtl8168_mdio_write(hw, 0x14, 0x0D93);
                rtl8168_mdio_write(hw, 0x13, 0x87F9);
                rtl8168_mdio_write(hw, 0x14, 0x0010);
                rtl8168_mdio_write(hw, 0x13, 0x87FB);
                rtl8168_mdio_write(hw, 0x14, 0x0800);
                rtl8168_mdio_write(hw, 0x13, 0x8015);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0x7000,
                                     0x7000);


                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                rtl8168_mdio_write(hw, 0x13, 0x8111);
                ClearAndSetEthPhyBit(hw,
                                     0x14,
                                     0xFF00,
                                     0x7C00);
                rtl8168_mdio_write(hw, 0x1F, 0x0000);

                //if (aspm) {
                //        if (HW_HAS_WRITE_PHY_MCU_RAM_CODE(hw)) {
                //                rtl8168_mdio_write(hw, 0x1F, 0x0A43);
                //                rtl8168_set_eth_phy_bit( hw, 0x10, BIT_2 );
                //                rtl8168_mdio_write(hw, 0x1F, 0x0000);
                //        }
                //}
        }

        //disable EthPhyPPSW
        rtl8168_mdio_write(hw, 0x1F, 0x0A44);
        rtl8168_clear_eth_phy_bit( hw, 0x11, BIT_7 );
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

}

static void hw_config_8168h(struct rtl_hw *hw)
{
        u32 csi_tmp;
        u16 mac_ocp_data;

        //set_offset70F(hw, 0x27);

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

        if (hw->mcfg == CFG_METHOD_35)
                rtl8168_set_mcu_ocp_bit(hw, 0xD438, (BIT_1 | BIT_0));
        //UPS params
        //if (hw->RequireAdjustUpsTxLinkPulseTiming) {
        //        mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xD412);
        //        mac_ocp_data &= ~(0x0FFF);
        //        mac_ocp_data |= hw->SwrCnt1msIni;
        //        rtl8168_mac_ocp_write(hw, 0xD412, mac_ocp_data);
        //}

        //EEE pwrsave params
        //mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xE056);
        //mac_ocp_data &= ~(BIT_7 | BIT_6 | BIT_5 | BIT_4);
        //mac_ocp_data |= (BIT_6 | BIT_5 | BIT_4);
        //rtl8168_mac_ocp_write(hw, 0xE056, mac_ocp_data);
        //mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xE052);
        //mac_ocp_data &= ~( BIT_14 | BIT_13);
        //mac_ocp_data |= BIT_15;
        //mac_ocp_data |= BIT_3;
        //rtl8168_mac_ocp_write(hw, 0xE052, mac_ocp_data);

        //UPS reg save
        //mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xD420);
        //mac_ocp_data &= ~(BIT_11 | BIT_10 | BIT_9 | BIT_8 | BIT_7 | BIT_6 | BIT_5 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0);
        //mac_ocp_data |= 0x47F;
        //rtl8168_mac_ocp_write(hw, 0xD420, mac_ocp_data);

        //ephy err mask
        mac_ocp_data = rtl8168_mac_ocp_read(hw, 0xE0D6);
        mac_ocp_data &= ~(BIT_8 | BIT_7 | BIT_6 | BIT_5 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0);
        mac_ocp_data |= 0x17F;
        rtl8168_mac_ocp_write(hw, 0xE0D6, mac_ocp_data);

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

        //speed down setting
        //rtl8168_mac_ocp_write(hw, 0xE054, 0xFC01);

        //pwrcut CR
        //rtl8168_eri_write(hw, 0x5F0, 2, 0x4F87, ERIAR_ExGMAC);

        //clkreq exit masks
        csi_tmp = rtl8168_eri_read(hw, 0xD4, 4, ERIAR_ExGMAC);
        csi_tmp |= (BIT_8 | BIT_9 | BIT_10 | BIT_11 | BIT_12);
        rtl8168_eri_write(hw, 0xD4, 4, csi_tmp, ERIAR_ExGMAC);

        csi_tmp = rtl8168_eri_read(hw, 0xDC, 4, ERIAR_ExGMAC);
        csi_tmp |= (BIT_2 | BIT_3 | BIT_4);
        rtl8168_eri_write(hw, 0xDC, 4, csi_tmp, ERIAR_ExGMAC);

        //crc wake disable
        rtl8168_mac_ocp_write(hw, 0xC140, 0xFFFF);
        rtl8168_mac_ocp_write(hw, 0xC142, 0xFFFF);

        //EEE CR
        //csi_tmp = rtl8168_eri_read(hw, 0x1B0, 4, ERIAR_ExGMAC);
        //csi_tmp &= ~BIT_12;
        //rtl8168_eri_write(hw, 0x1B0, 4, csi_tmp, ERIAR_ExGMAC);

        //clk req params
        //csi_tmp = rtl8168_eri_read(hw, 0x2FC, 1, ERIAR_ExGMAC);
        //csi_tmp &= ~(BIT_2);
        //rtl8168_eri_write(hw, 0x2FC, 1, csi_tmp, ERIAR_ExGMAC);

        //EEE CR
        //csi_tmp = rtl8168_eri_read(hw, 0x1D0, 1, ERIAR_ExGMAC);
        //csi_tmp |= BIT_1;
        //rtl8168_eri_write(hw, 0x1D0, 1, csi_tmp, ERIAR_ExGMAC);

}

const struct rtl_hw_ops rtl8111h_ops = {
        .hw_config = hw_config_8168h,
        .hw_init_rxcfg = hw_init_rxcfg_8168h,
        .hw_ephy_config = hw_ephy_config_8168h,
        .hw_phy_config = hw_phy_config_8168h,
        .hw_mac_mcu_config = hw_mac_mcu_config_8168h,
        .hw_phy_mcu_config = hw_phy_mcu_config_8168h,
};
