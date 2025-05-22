/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include "../r8168_base.h"
#include "../r8168_hw.h"
#include "../r8168_phy.h"

#include "rtl8168h.h"

//for RTL8111H, CFG_METHOD_29,30,35
//------------------------------------mac 8111h---------------------------------------
static void
rtl8168_set_mac_mcu_8168h_1(struct rtl_hw *hw)
{
        rtl8168_hw_disable_mac_mcu_bps(hw);
}

static void
rtl8168_set_mac_mcu_8168h_2(struct rtl_hw *hw)
{
        u16 i;
        static const u16 mcu_patch_code_8168h_1[] = {
                0xE008, 0xE00F, 0xE011, 0xE047, 0xE049, 0xE073, 0xE075, 0xE07A, 0xC707,
                0x1D00, 0x8DE2, 0x48C1, 0xC502, 0xBD00, 0x00E4, 0xE0C0, 0xC502, 0xBD00,
                0x0216, 0xC634, 0x75C0, 0x49D3, 0xF027, 0xC631, 0x75C0, 0x49D3, 0xF123,
                0xC627, 0x75C0, 0xB405, 0xC525, 0x9DC0, 0xC621, 0x75C8, 0x49D5, 0xF00A,
                0x49D6, 0xF008, 0x49D7, 0xF006, 0x49D8, 0xF004, 0x75D2, 0x49D9, 0xF111,
                0xC517, 0x9DC8, 0xC516, 0x9DD2, 0xC618, 0x75C0, 0x49D4, 0xF003, 0x49D0,
                0xF104, 0xC60A, 0xC50E, 0x9DC0, 0xB005, 0xC607, 0x9DC0, 0xB007, 0xC602,
                0xBE00, 0x1A06, 0xB400, 0xE86C, 0xA000, 0x01E1, 0x0200, 0x9200, 0xE84C,
                0xE004, 0xE908, 0xC502, 0xBD00, 0x0B58, 0xB407, 0xB404, 0x2195, 0x25BD,
                0x9BE0, 0x1C1C, 0x484F, 0x9CE2, 0x72E2, 0x49AE, 0xF1FE, 0x0B00, 0xF116,
                0xC71C, 0xC419, 0x9CE0, 0x1C13, 0x484F, 0x9CE2, 0x74E2, 0x49CE, 0xF1FE,
                0xC412, 0x9CE0, 0x1C13, 0x484F, 0x9CE2, 0x74E2, 0x49CE, 0xF1FE, 0xC70C,
                0x74F8, 0x48C3, 0x8CF8, 0xB004, 0xB007, 0xC502, 0xBD00, 0x0F24, 0x0481,
                0x0C81, 0xDE24, 0xE000, 0xC602, 0xBE00, 0x0CA4, 0x48C1, 0x48C2, 0x9C46,
                0xC402, 0xBC00, 0x0578, 0xC602, 0xBE00, 0x0000
        };

        rtl8168_hw_disable_mac_mcu_bps(hw);

        for (i = 0; i < ARRAY_SIZE(mcu_patch_code_8168h_1); i++) {
                rtl8168_mac_ocp_write(hw, 0xF800 + i * 2, mcu_patch_code_8168h_1[i]);
        }

        rtl8168_mac_ocp_write(hw, 0xFC26, 0x8000);

        rtl8168_mac_ocp_write(hw, 0xFC28, 0x00E2);
        rtl8168_mac_ocp_write(hw, 0xFC2A, 0x0210);
        rtl8168_mac_ocp_write(hw, 0xFC2C, 0x1A04);
        rtl8168_mac_ocp_write(hw, 0xFC2E, 0x0B26);
        rtl8168_mac_ocp_write(hw, 0xFC30, 0x0F02);
        rtl8168_mac_ocp_write(hw, 0xFC32, 0x0CA0);
        //rtl8168_mac_ocp_write(hw, 0xFC34, 0x056C);

        rtl8168_mac_ocp_write(hw, 0xFC38, 0x003F);
}

static void
rtl8168_set_mac_mcu_8168h_3(struct rtl_hw *hw)
{
        rtl8168_hw_disable_mac_mcu_bps(hw);
}
//------------------------------------phy 8111h---------------------------------------

static void
rtl8168_set_phy_mcu_8168h_1(struct rtl_hw *hw)
{
        unsigned int gphy_val;

        rtl8168_set_phy_mcu_patch_request(hw);

        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8028);
        rtl8168_mdio_write(hw, 0x14, 0x6200);
        rtl8168_mdio_write(hw, 0x13, 0xB82E);
        rtl8168_mdio_write(hw, 0x14, 0x0001);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0xB820);
        rtl8168_mdio_write(hw, 0x14, 0x0290);
        rtl8168_mdio_write(hw, 0x13, 0xA012);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x13, 0xA014);
        rtl8168_mdio_write(hw, 0x14, 0x2c04);
        rtl8168_mdio_write(hw, 0x14, 0x2c10);
        rtl8168_mdio_write(hw, 0x14, 0x2c10);
        rtl8168_mdio_write(hw, 0x14, 0x2c10);
        rtl8168_mdio_write(hw, 0x14, 0xa210);
        rtl8168_mdio_write(hw, 0x14, 0xa101);
        rtl8168_mdio_write(hw, 0x14, 0xce10);
        rtl8168_mdio_write(hw, 0x14, 0xe070);
        rtl8168_mdio_write(hw, 0x14, 0x0f40);
        rtl8168_mdio_write(hw, 0x14, 0xaf01);
        rtl8168_mdio_write(hw, 0x14, 0x8f01);
        rtl8168_mdio_write(hw, 0x14, 0x183e);
        rtl8168_mdio_write(hw, 0x14, 0x8e10);
        rtl8168_mdio_write(hw, 0x14, 0x8101);
        rtl8168_mdio_write(hw, 0x14, 0x8210);
        rtl8168_mdio_write(hw, 0x14, 0x28da);
        rtl8168_mdio_write(hw, 0x13, 0xA01A);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x13, 0xA006);
        rtl8168_mdio_write(hw, 0x14, 0x0017);
        rtl8168_mdio_write(hw, 0x13, 0xA004);
        rtl8168_mdio_write(hw, 0x14, 0x0015);
        rtl8168_mdio_write(hw, 0x13, 0xA002);
        rtl8168_mdio_write(hw, 0x14, 0x0013);
        rtl8168_mdio_write(hw, 0x13, 0xA000);
        rtl8168_mdio_write(hw, 0x14, 0x18d1);
        rtl8168_mdio_write(hw, 0x13, 0xB820);
        rtl8168_mdio_write(hw, 0x14, 0x0210);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x0000);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x1f, 0x0B82);
        gphy_val = rtl8168_mdio_read(hw, 0x17);
        gphy_val &= ~(BIT_0);
        rtl8168_mdio_write(hw, 0x17, gphy_val);
        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8028);
        rtl8168_mdio_write(hw, 0x14, 0x0000);

        rtl8168_clear_phy_mcu_patch_request(hw);
}

static void
rtl8168_set_phy_mcu_8168h_2(struct rtl_hw *hw)
{
        unsigned int gphy_val;

        rtl8168_set_phy_mcu_patch_request(hw);

        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8028);
        rtl8168_mdio_write(hw, 0x14, 0x6201);
        rtl8168_mdio_write(hw, 0x13, 0xB82E);
        rtl8168_mdio_write(hw, 0x14, 0x0001);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0xB820);
        rtl8168_mdio_write(hw, 0x14, 0x0290);
        rtl8168_mdio_write(hw, 0x13, 0xA012);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x13, 0xA014);
        rtl8168_mdio_write(hw, 0x14, 0x2c04);
        rtl8168_mdio_write(hw, 0x14, 0x2c09);
        rtl8168_mdio_write(hw, 0x14, 0x2c09);
        rtl8168_mdio_write(hw, 0x14, 0x2c09);
        rtl8168_mdio_write(hw, 0x14, 0xad01);
        rtl8168_mdio_write(hw, 0x14, 0xad01);
        rtl8168_mdio_write(hw, 0x14, 0xad01);
        rtl8168_mdio_write(hw, 0x14, 0xad01);
        rtl8168_mdio_write(hw, 0x14, 0x236c);
        rtl8168_mdio_write(hw, 0x13, 0xA01A);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x13, 0xA006);
        rtl8168_mdio_write(hw, 0x14, 0x0fff);
        rtl8168_mdio_write(hw, 0x13, 0xA004);
        rtl8168_mdio_write(hw, 0x14, 0x0fff);
        rtl8168_mdio_write(hw, 0x13, 0xA002);
        rtl8168_mdio_write(hw, 0x14, 0x0fff);
        rtl8168_mdio_write(hw, 0x13, 0xA000);
        rtl8168_mdio_write(hw, 0x14, 0x136b);
        rtl8168_mdio_write(hw, 0x13, 0xB820);
        rtl8168_mdio_write(hw, 0x14, 0x0210);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8323);
        rtl8168_mdio_write(hw, 0x14, 0xaf83);
        rtl8168_mdio_write(hw, 0x14, 0x2faf);
        rtl8168_mdio_write(hw, 0x14, 0x853d);
        rtl8168_mdio_write(hw, 0x14, 0xaf85);
        rtl8168_mdio_write(hw, 0x14, 0x3daf);
        rtl8168_mdio_write(hw, 0x14, 0x853d);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x45ad);
        rtl8168_mdio_write(hw, 0x14, 0x2052);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7ae3);
        rtl8168_mdio_write(hw, 0x14, 0x85fe);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f6);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7a1b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fa);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7be3);
        rtl8168_mdio_write(hw, 0x14, 0x85fe);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f7);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7b1b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fb);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7ce3);
        rtl8168_mdio_write(hw, 0x14, 0x85fe);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f8);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7c1b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fc);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7de3);
        rtl8168_mdio_write(hw, 0x14, 0x85fe);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f9);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7d1b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fd);
        rtl8168_mdio_write(hw, 0x14, 0xae50);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7ee3);
        rtl8168_mdio_write(hw, 0x14, 0x85ff);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f6);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7e1b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fa);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7fe3);
        rtl8168_mdio_write(hw, 0x14, 0x85ff);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f7);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x7f1b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fb);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x80e3);
        rtl8168_mdio_write(hw, 0x14, 0x85ff);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f8);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x801b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fc);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x81e3);
        rtl8168_mdio_write(hw, 0x14, 0x85ff);
        rtl8168_mdio_write(hw, 0x14, 0x1a03);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x85f9);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x811b);
        rtl8168_mdio_write(hw, 0x14, 0x03e4);
        rtl8168_mdio_write(hw, 0x14, 0x85fd);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf6ad);
        rtl8168_mdio_write(hw, 0x14, 0x2404);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xf610);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf7ad);
        rtl8168_mdio_write(hw, 0x14, 0x2404);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xf710);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf8ad);
        rtl8168_mdio_write(hw, 0x14, 0x2404);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xf810);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf9ad);
        rtl8168_mdio_write(hw, 0x14, 0x2404);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xf910);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfaad);
        rtl8168_mdio_write(hw, 0x14, 0x2704);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xfa00);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfbad);
        rtl8168_mdio_write(hw, 0x14, 0x2704);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xfb00);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfcad);
        rtl8168_mdio_write(hw, 0x14, 0x2704);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xfc00);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfdad);
        rtl8168_mdio_write(hw, 0x14, 0x2704);
        rtl8168_mdio_write(hw, 0x14, 0xee85);
        rtl8168_mdio_write(hw, 0x14, 0xfd00);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x44ad);
        rtl8168_mdio_write(hw, 0x14, 0x203f);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf6e4);
        rtl8168_mdio_write(hw, 0x14, 0x8288);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfae4);
        rtl8168_mdio_write(hw, 0x14, 0x8289);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x440d);
        rtl8168_mdio_write(hw, 0x14, 0x0458);
        rtl8168_mdio_write(hw, 0x14, 0x01bf);
        rtl8168_mdio_write(hw, 0x14, 0x8264);
        rtl8168_mdio_write(hw, 0x14, 0x0215);
        rtl8168_mdio_write(hw, 0x14, 0x38bf);
        rtl8168_mdio_write(hw, 0x14, 0x824e);
        rtl8168_mdio_write(hw, 0x14, 0x0213);
        rtl8168_mdio_write(hw, 0x14, 0x06a0);
        rtl8168_mdio_write(hw, 0x14, 0x010f);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x44f6);
        rtl8168_mdio_write(hw, 0x14, 0x20e4);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x580f);
        rtl8168_mdio_write(hw, 0x14, 0xe582);
        rtl8168_mdio_write(hw, 0x14, 0x5aae);
        rtl8168_mdio_write(hw, 0x14, 0x0ebf);
        rtl8168_mdio_write(hw, 0x14, 0x825e);
        rtl8168_mdio_write(hw, 0x14, 0xe382);
        rtl8168_mdio_write(hw, 0x14, 0x44f7);
        rtl8168_mdio_write(hw, 0x14, 0x3ce7);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x0212);
        rtl8168_mdio_write(hw, 0x14, 0xf0ad);
        rtl8168_mdio_write(hw, 0x14, 0x213f);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf7e4);
        rtl8168_mdio_write(hw, 0x14, 0x8288);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfbe4);
        rtl8168_mdio_write(hw, 0x14, 0x8289);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x440d);
        rtl8168_mdio_write(hw, 0x14, 0x0558);
        rtl8168_mdio_write(hw, 0x14, 0x01bf);
        rtl8168_mdio_write(hw, 0x14, 0x826b);
        rtl8168_mdio_write(hw, 0x14, 0x0215);
        rtl8168_mdio_write(hw, 0x14, 0x38bf);
        rtl8168_mdio_write(hw, 0x14, 0x824f);
        rtl8168_mdio_write(hw, 0x14, 0x0213);
        rtl8168_mdio_write(hw, 0x14, 0x06a0);
        rtl8168_mdio_write(hw, 0x14, 0x010f);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x44f6);
        rtl8168_mdio_write(hw, 0x14, 0x21e4);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x580f);
        rtl8168_mdio_write(hw, 0x14, 0xe582);
        rtl8168_mdio_write(hw, 0x14, 0x5bae);
        rtl8168_mdio_write(hw, 0x14, 0x0ebf);
        rtl8168_mdio_write(hw, 0x14, 0x8265);
        rtl8168_mdio_write(hw, 0x14, 0xe382);
        rtl8168_mdio_write(hw, 0x14, 0x44f7);
        rtl8168_mdio_write(hw, 0x14, 0x3de7);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x0212);
        rtl8168_mdio_write(hw, 0x14, 0xf0ad);
        rtl8168_mdio_write(hw, 0x14, 0x223f);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf8e4);
        rtl8168_mdio_write(hw, 0x14, 0x8288);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfce4);
        rtl8168_mdio_write(hw, 0x14, 0x8289);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x440d);
        rtl8168_mdio_write(hw, 0x14, 0x0658);
        rtl8168_mdio_write(hw, 0x14, 0x01bf);
        rtl8168_mdio_write(hw, 0x14, 0x8272);
        rtl8168_mdio_write(hw, 0x14, 0x0215);
        rtl8168_mdio_write(hw, 0x14, 0x38bf);
        rtl8168_mdio_write(hw, 0x14, 0x8250);
        rtl8168_mdio_write(hw, 0x14, 0x0213);
        rtl8168_mdio_write(hw, 0x14, 0x06a0);
        rtl8168_mdio_write(hw, 0x14, 0x010f);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x44f6);
        rtl8168_mdio_write(hw, 0x14, 0x22e4);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x580f);
        rtl8168_mdio_write(hw, 0x14, 0xe582);
        rtl8168_mdio_write(hw, 0x14, 0x5cae);
        rtl8168_mdio_write(hw, 0x14, 0x0ebf);
        rtl8168_mdio_write(hw, 0x14, 0x826c);
        rtl8168_mdio_write(hw, 0x14, 0xe382);
        rtl8168_mdio_write(hw, 0x14, 0x44f7);
        rtl8168_mdio_write(hw, 0x14, 0x3ee7);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x0212);
        rtl8168_mdio_write(hw, 0x14, 0xf0ad);
        rtl8168_mdio_write(hw, 0x14, 0x233f);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xf9e4);
        rtl8168_mdio_write(hw, 0x14, 0x8288);
        rtl8168_mdio_write(hw, 0x14, 0xe085);
        rtl8168_mdio_write(hw, 0x14, 0xfde4);
        rtl8168_mdio_write(hw, 0x14, 0x8289);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x440d);
        rtl8168_mdio_write(hw, 0x14, 0x0758);
        rtl8168_mdio_write(hw, 0x14, 0x01bf);
        rtl8168_mdio_write(hw, 0x14, 0x8279);
        rtl8168_mdio_write(hw, 0x14, 0x0215);
        rtl8168_mdio_write(hw, 0x14, 0x38bf);
        rtl8168_mdio_write(hw, 0x14, 0x8251);
        rtl8168_mdio_write(hw, 0x14, 0x0213);
        rtl8168_mdio_write(hw, 0x14, 0x06a0);
        rtl8168_mdio_write(hw, 0x14, 0x010f);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0x44f6);
        rtl8168_mdio_write(hw, 0x14, 0x23e4);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x580f);
        rtl8168_mdio_write(hw, 0x14, 0xe582);
        rtl8168_mdio_write(hw, 0x14, 0x5dae);
        rtl8168_mdio_write(hw, 0x14, 0x0ebf);
        rtl8168_mdio_write(hw, 0x14, 0x8273);
        rtl8168_mdio_write(hw, 0x14, 0xe382);
        rtl8168_mdio_write(hw, 0x14, 0x44f7);
        rtl8168_mdio_write(hw, 0x14, 0x3fe7);
        rtl8168_mdio_write(hw, 0x14, 0x8244);
        rtl8168_mdio_write(hw, 0x14, 0x0212);
        rtl8168_mdio_write(hw, 0x14, 0xf0ee);
        rtl8168_mdio_write(hw, 0x14, 0x8288);
        rtl8168_mdio_write(hw, 0x14, 0x10ee);
        rtl8168_mdio_write(hw, 0x14, 0x8289);
        rtl8168_mdio_write(hw, 0x14, 0x00af);
        rtl8168_mdio_write(hw, 0x14, 0x14aa);
        rtl8168_mdio_write(hw, 0x13, 0xb818);
        rtl8168_mdio_write(hw, 0x14, 0x13cf);
        rtl8168_mdio_write(hw, 0x13, 0xb81a);
        rtl8168_mdio_write(hw, 0x14, 0xfffd);
        rtl8168_mdio_write(hw, 0x13, 0xb81c);
        rtl8168_mdio_write(hw, 0x14, 0xfffd);
        rtl8168_mdio_write(hw, 0x13, 0xb81e);
        rtl8168_mdio_write(hw, 0x14, 0xfffd);
        rtl8168_mdio_write(hw, 0x13, 0xb832);
        rtl8168_mdio_write(hw, 0x14, 0x0001);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x0000);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x1f, 0x0B82);
        gphy_val = rtl8168_mdio_read(hw, 0x17);
        gphy_val &= ~(BIT_0);
        rtl8168_mdio_write(hw, 0x17, gphy_val);
        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8028);
        rtl8168_mdio_write(hw, 0x14, 0x0000);

        rtl8168_clear_phy_mcu_patch_request(hw);

        //if (hw->RequiredSecLanDonglePatch) {
        //        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        //        gphy_val = rtl8168_mdio_read(hw, 0x11);
        //        gphy_val &= ~BIT_6;
        //        rtl8168_mdio_write(hw, 0x11, gphy_val);
        //}
}

static void
rtl8168_set_phy_mcu_8168h_3(struct rtl_hw *hw)
{
        unsigned int gphy_val;

        rtl8168_set_phy_mcu_patch_request(hw);

        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8042);
        rtl8168_mdio_write(hw, 0x14, 0x3800);
        rtl8168_mdio_write(hw, 0x13, 0xB82E);
        rtl8168_mdio_write(hw, 0x14, 0x0001);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0xB820);
        rtl8168_mdio_write(hw, 0x14, 0x0090);
        rtl8168_mdio_write(hw, 0x13, 0xA016);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x13, 0xA012);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x13, 0xA014);
        rtl8168_mdio_write(hw, 0x14, 0x1800);
        rtl8168_mdio_write(hw, 0x14, 0x8002);
        rtl8168_mdio_write(hw, 0x14, 0x2b5d);
        rtl8168_mdio_write(hw, 0x14, 0x0c68);
        rtl8168_mdio_write(hw, 0x14, 0x1800);
        rtl8168_mdio_write(hw, 0x14, 0x0b3c);
        rtl8168_mdio_write(hw, 0x13, 0xA000);
        rtl8168_mdio_write(hw, 0x14, 0x0b3a);
        rtl8168_mdio_write(hw, 0x13, 0xA008);
        rtl8168_mdio_write(hw, 0x14, 0x0100);
        rtl8168_mdio_write(hw, 0x13, 0xB820);
        rtl8168_mdio_write(hw, 0x14, 0x0010);


        rtl8168_mdio_write(hw, 0x13, 0x83f3);
        rtl8168_mdio_write(hw, 0x14, 0xaf84);
        rtl8168_mdio_write(hw, 0x14, 0x0baf);
        rtl8168_mdio_write(hw, 0x14, 0x8466);
        rtl8168_mdio_write(hw, 0x14, 0xaf84);
        rtl8168_mdio_write(hw, 0x14, 0xcdaf);
        rtl8168_mdio_write(hw, 0x14, 0x8744);
        rtl8168_mdio_write(hw, 0x14, 0xaf87);
        rtl8168_mdio_write(hw, 0x14, 0x47af);
        rtl8168_mdio_write(hw, 0x14, 0x8747);
        rtl8168_mdio_write(hw, 0x14, 0xaf87);
        rtl8168_mdio_write(hw, 0x14, 0x47af);
        rtl8168_mdio_write(hw, 0x14, 0x8747);
        rtl8168_mdio_write(hw, 0x14, 0xef79);
        rtl8168_mdio_write(hw, 0x14, 0xfb89);
        rtl8168_mdio_write(hw, 0x14, 0xe987);
        rtl8168_mdio_write(hw, 0x14, 0xffd7);
        rtl8168_mdio_write(hw, 0x14, 0x0017);
        rtl8168_mdio_write(hw, 0x14, 0xd400);
        rtl8168_mdio_write(hw, 0x14, 0x051c);
        rtl8168_mdio_write(hw, 0x14, 0x421a);
        rtl8168_mdio_write(hw, 0x14, 0x741b);
        rtl8168_mdio_write(hw, 0x14, 0x97e9);
        rtl8168_mdio_write(hw, 0x14, 0x87fe);
        rtl8168_mdio_write(hw, 0x14, 0xffef);
        rtl8168_mdio_write(hw, 0x14, 0x97e0);
        rtl8168_mdio_write(hw, 0x14, 0x82aa);
        rtl8168_mdio_write(hw, 0x14, 0xa000);
        rtl8168_mdio_write(hw, 0x14, 0x08ef);
        rtl8168_mdio_write(hw, 0x14, 0x46dc);
        rtl8168_mdio_write(hw, 0x14, 0x19dd);
        rtl8168_mdio_write(hw, 0x14, 0xaf1a);
        rtl8168_mdio_write(hw, 0x14, 0x37a0);
        rtl8168_mdio_write(hw, 0x14, 0x012d);
        rtl8168_mdio_write(hw, 0x14, 0xe082);
        rtl8168_mdio_write(hw, 0x14, 0xa7ac);
        rtl8168_mdio_write(hw, 0x14, 0x2013);
        rtl8168_mdio_write(hw, 0x14, 0xe087);
        rtl8168_mdio_write(hw, 0x14, 0xffe1);
        rtl8168_mdio_write(hw, 0x14, 0x87fe);
        rtl8168_mdio_write(hw, 0x14, 0xac27);
        rtl8168_mdio_write(hw, 0x14, 0x05a1);
        rtl8168_mdio_write(hw, 0x14, 0x0807);
        rtl8168_mdio_write(hw, 0x14, 0xae0f);
        rtl8168_mdio_write(hw, 0x14, 0xa107);
        rtl8168_mdio_write(hw, 0x14, 0x02ae);
        rtl8168_mdio_write(hw, 0x14, 0x0aef);
        rtl8168_mdio_write(hw, 0x14, 0x4619);
        rtl8168_mdio_write(hw, 0x14, 0x19dc);
        rtl8168_mdio_write(hw, 0x14, 0x19dd);
        rtl8168_mdio_write(hw, 0x14, 0xaf1a);
        rtl8168_mdio_write(hw, 0x14, 0x37d8);
        rtl8168_mdio_write(hw, 0x14, 0x19d9);
        rtl8168_mdio_write(hw, 0x14, 0x19dc);
        rtl8168_mdio_write(hw, 0x14, 0x19dd);
        rtl8168_mdio_write(hw, 0x14, 0xaf1a);
        rtl8168_mdio_write(hw, 0x14, 0x3719);
        rtl8168_mdio_write(hw, 0x14, 0x19ae);
        rtl8168_mdio_write(hw, 0x14, 0xcfbf);
        rtl8168_mdio_write(hw, 0x14, 0x8771);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdc3c);
        rtl8168_mdio_write(hw, 0x14, 0x0005);
        rtl8168_mdio_write(hw, 0x14, 0xaaf5);
        rtl8168_mdio_write(hw, 0x14, 0x0249);
        rtl8168_mdio_write(hw, 0x14, 0xcaef);
        rtl8168_mdio_write(hw, 0x14, 0x67d7);
        rtl8168_mdio_write(hw, 0x14, 0x0014);
        rtl8168_mdio_write(hw, 0x14, 0x0249);
        rtl8168_mdio_write(hw, 0x14, 0xe5ad);
        rtl8168_mdio_write(hw, 0x14, 0x50f7);
        rtl8168_mdio_write(hw, 0x14, 0xd400);
        rtl8168_mdio_write(hw, 0x14, 0x01bf);
        rtl8168_mdio_write(hw, 0x14, 0x46a7);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0x98bf);
        rtl8168_mdio_write(hw, 0x14, 0x465c);
        rtl8168_mdio_write(hw, 0x14, 0x024a);
        rtl8168_mdio_write(hw, 0x14, 0x5fd4);
        rtl8168_mdio_write(hw, 0x14, 0x0003);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x8302);
        rtl8168_mdio_write(hw, 0x14, 0x4498);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x8002);
        rtl8168_mdio_write(hw, 0x14, 0x4a5f);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x7402);
        rtl8168_mdio_write(hw, 0x14, 0x4a5f);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x7702);
        rtl8168_mdio_write(hw, 0x14, 0x44dc);
        rtl8168_mdio_write(hw, 0x14, 0xad28);
        rtl8168_mdio_write(hw, 0x14, 0xf7bf);
        rtl8168_mdio_write(hw, 0x14, 0x877d);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdcad);
        rtl8168_mdio_write(hw, 0x14, 0x28f7);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x7a02);
        rtl8168_mdio_write(hw, 0x14, 0x4a5f);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x7a02);
        rtl8168_mdio_write(hw, 0x14, 0x4a56);
        rtl8168_mdio_write(hw, 0x14, 0xbf46);
        rtl8168_mdio_write(hw, 0x14, 0x5c02);
        rtl8168_mdio_write(hw, 0x14, 0x4a56);
        rtl8168_mdio_write(hw, 0x14, 0xbf45);
        rtl8168_mdio_write(hw, 0x14, 0x21af);
        rtl8168_mdio_write(hw, 0x14, 0x020e);
        rtl8168_mdio_write(hw, 0x14, 0xee82);
        rtl8168_mdio_write(hw, 0x14, 0x5000);
        rtl8168_mdio_write(hw, 0x14, 0x0284);
        rtl8168_mdio_write(hw, 0x14, 0xdd02);
        rtl8168_mdio_write(hw, 0x14, 0x8521);
        rtl8168_mdio_write(hw, 0x14, 0x0285);
        rtl8168_mdio_write(hw, 0x14, 0x36af);
        rtl8168_mdio_write(hw, 0x14, 0x03d2);
        rtl8168_mdio_write(hw, 0x14, 0xf8f9);
        rtl8168_mdio_write(hw, 0x14, 0xfafb);
        rtl8168_mdio_write(hw, 0x14, 0xef59);
        rtl8168_mdio_write(hw, 0x14, 0xbf45);
        rtl8168_mdio_write(hw, 0x14, 0x3002);
        rtl8168_mdio_write(hw, 0x14, 0x44dc);
        rtl8168_mdio_write(hw, 0x14, 0x3c00);
        rtl8168_mdio_write(hw, 0x14, 0x03aa);
        rtl8168_mdio_write(hw, 0x14, 0x2cbf);
        rtl8168_mdio_write(hw, 0x14, 0x8777);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdcad);
        rtl8168_mdio_write(hw, 0x14, 0x2823);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x7d02);
        rtl8168_mdio_write(hw, 0x14, 0x44dc);
        rtl8168_mdio_write(hw, 0x14, 0xad28);
        rtl8168_mdio_write(hw, 0x14, 0x1a02);
        rtl8168_mdio_write(hw, 0x14, 0x49ca);
        rtl8168_mdio_write(hw, 0x14, 0xef67);
        rtl8168_mdio_write(hw, 0x14, 0xd700);
        rtl8168_mdio_write(hw, 0x14, 0x0202);
        rtl8168_mdio_write(hw, 0x14, 0x49e5);
        rtl8168_mdio_write(hw, 0x14, 0xad50);
        rtl8168_mdio_write(hw, 0x14, 0xf7bf);
        rtl8168_mdio_write(hw, 0x14, 0x877a);
        rtl8168_mdio_write(hw, 0x14, 0x024a);
        rtl8168_mdio_write(hw, 0x14, 0x5fbf);
        rtl8168_mdio_write(hw, 0x14, 0x877a);
        rtl8168_mdio_write(hw, 0x14, 0x024a);
        rtl8168_mdio_write(hw, 0x14, 0x56ef);
        rtl8168_mdio_write(hw, 0x14, 0x95ff);
        rtl8168_mdio_write(hw, 0x14, 0xfefd);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8fa);
        rtl8168_mdio_write(hw, 0x14, 0xef69);
        rtl8168_mdio_write(hw, 0x14, 0xe080);
        rtl8168_mdio_write(hw, 0x14, 0x15ad);
        rtl8168_mdio_write(hw, 0x14, 0x2406);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x6e02);
        rtl8168_mdio_write(hw, 0x14, 0x4a56);
        rtl8168_mdio_write(hw, 0x14, 0xef96);
        rtl8168_mdio_write(hw, 0x14, 0xfefc);
        rtl8168_mdio_write(hw, 0x14, 0x04f8);
        rtl8168_mdio_write(hw, 0x14, 0xe087);
        rtl8168_mdio_write(hw, 0x14, 0xf9e1);
        rtl8168_mdio_write(hw, 0x14, 0x87fa);
        rtl8168_mdio_write(hw, 0x14, 0x1b10);
        rtl8168_mdio_write(hw, 0x14, 0x9f1e);
        rtl8168_mdio_write(hw, 0x14, 0xee87);
        rtl8168_mdio_write(hw, 0x14, 0xf900);
        rtl8168_mdio_write(hw, 0x14, 0xe080);
        rtl8168_mdio_write(hw, 0x14, 0x15ac);
        rtl8168_mdio_write(hw, 0x14, 0x2606);
        rtl8168_mdio_write(hw, 0x14, 0xee87);
        rtl8168_mdio_write(hw, 0x14, 0xf700);
        rtl8168_mdio_write(hw, 0x14, 0xae12);
        rtl8168_mdio_write(hw, 0x14, 0x0286);
        rtl8168_mdio_write(hw, 0x14, 0xa502);
        rtl8168_mdio_write(hw, 0x14, 0x8565);
        rtl8168_mdio_write(hw, 0x14, 0x0285);
        rtl8168_mdio_write(hw, 0x14, 0x9d02);
        rtl8168_mdio_write(hw, 0x14, 0x8668);
        rtl8168_mdio_write(hw, 0x14, 0xae04);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x87f9);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8f9);
        rtl8168_mdio_write(hw, 0x14, 0xfaef);
        rtl8168_mdio_write(hw, 0x14, 0x69fa);
        rtl8168_mdio_write(hw, 0x14, 0xbf45);
        rtl8168_mdio_write(hw, 0x14, 0x3002);
        rtl8168_mdio_write(hw, 0x14, 0x44dc);
        rtl8168_mdio_write(hw, 0x14, 0xa103);
        rtl8168_mdio_write(hw, 0x14, 0x22e0);
        rtl8168_mdio_write(hw, 0x14, 0x87eb);
        rtl8168_mdio_write(hw, 0x14, 0xe187);
        rtl8168_mdio_write(hw, 0x14, 0xecef);
        rtl8168_mdio_write(hw, 0x14, 0x64bf);
        rtl8168_mdio_write(hw, 0x14, 0x8756);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdc1b);
        rtl8168_mdio_write(hw, 0x14, 0x46aa);
        rtl8168_mdio_write(hw, 0x14, 0x0abf);
        rtl8168_mdio_write(hw, 0x14, 0x8759);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdc1b);
        rtl8168_mdio_write(hw, 0x14, 0x46ab);
        rtl8168_mdio_write(hw, 0x14, 0x06bf);
        rtl8168_mdio_write(hw, 0x14, 0x8753);
        rtl8168_mdio_write(hw, 0x14, 0x024a);
        rtl8168_mdio_write(hw, 0x14, 0x5ffe);
        rtl8168_mdio_write(hw, 0x14, 0xef96);
        rtl8168_mdio_write(hw, 0x14, 0xfefd);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8f9);
        rtl8168_mdio_write(hw, 0x14, 0xef59);
        rtl8168_mdio_write(hw, 0x14, 0xf9bf);
        rtl8168_mdio_write(hw, 0x14, 0x4530);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdca1);
        rtl8168_mdio_write(hw, 0x14, 0x0310);
        rtl8168_mdio_write(hw, 0x14, 0xe087);
        rtl8168_mdio_write(hw, 0x14, 0xf7ac);
        rtl8168_mdio_write(hw, 0x14, 0x2605);
        rtl8168_mdio_write(hw, 0x14, 0x0285);
        rtl8168_mdio_write(hw, 0x14, 0xc9ae);
        rtl8168_mdio_write(hw, 0x14, 0x0d02);
        rtl8168_mdio_write(hw, 0x14, 0x861b);
        rtl8168_mdio_write(hw, 0x14, 0xae08);
        rtl8168_mdio_write(hw, 0x14, 0xe287);
        rtl8168_mdio_write(hw, 0x14, 0xf7f6);
        rtl8168_mdio_write(hw, 0x14, 0x36e6);
        rtl8168_mdio_write(hw, 0x14, 0x87f7);
        rtl8168_mdio_write(hw, 0x14, 0xfdef);
        rtl8168_mdio_write(hw, 0x14, 0x95fd);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8f9);
        rtl8168_mdio_write(hw, 0x14, 0xfafb);
        rtl8168_mdio_write(hw, 0x14, 0xef79);
        rtl8168_mdio_write(hw, 0x14, 0xfbbf);
        rtl8168_mdio_write(hw, 0x14, 0x8756);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdcef);
        rtl8168_mdio_write(hw, 0x14, 0x64e2);
        rtl8168_mdio_write(hw, 0x14, 0x87e9);
        rtl8168_mdio_write(hw, 0x14, 0xe387);
        rtl8168_mdio_write(hw, 0x14, 0xea1b);
        rtl8168_mdio_write(hw, 0x14, 0x659e);
        rtl8168_mdio_write(hw, 0x14, 0x10e4);
        rtl8168_mdio_write(hw, 0x14, 0x87e9);
        rtl8168_mdio_write(hw, 0x14, 0xe587);
        rtl8168_mdio_write(hw, 0x14, 0xeae2);
        rtl8168_mdio_write(hw, 0x14, 0x87f7);
        rtl8168_mdio_write(hw, 0x14, 0xf636);
        rtl8168_mdio_write(hw, 0x14, 0xe687);
        rtl8168_mdio_write(hw, 0x14, 0xf7ae);
        rtl8168_mdio_write(hw, 0x14, 0x21e2);
        rtl8168_mdio_write(hw, 0x14, 0x87f7);
        rtl8168_mdio_write(hw, 0x14, 0xf736);
        rtl8168_mdio_write(hw, 0x14, 0xe687);
        rtl8168_mdio_write(hw, 0x14, 0xf7af);
        rtl8168_mdio_write(hw, 0x14, 0x8608);
        rtl8168_mdio_write(hw, 0x14, 0x0249);
        rtl8168_mdio_write(hw, 0x14, 0xcaef);
        rtl8168_mdio_write(hw, 0x14, 0x57e6);
        rtl8168_mdio_write(hw, 0x14, 0x87e7);
        rtl8168_mdio_write(hw, 0x14, 0xe787);
        rtl8168_mdio_write(hw, 0x14, 0xe802);
        rtl8168_mdio_write(hw, 0x14, 0x49ca);
        rtl8168_mdio_write(hw, 0x14, 0xef57);
        rtl8168_mdio_write(hw, 0x14, 0xe687);
        rtl8168_mdio_write(hw, 0x14, 0xe7e7);
        rtl8168_mdio_write(hw, 0x14, 0x87e8);
        rtl8168_mdio_write(hw, 0x14, 0xffef);
        rtl8168_mdio_write(hw, 0x14, 0x97ff);
        rtl8168_mdio_write(hw, 0x14, 0xfefd);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8f9);
        rtl8168_mdio_write(hw, 0x14, 0xfafb);
        rtl8168_mdio_write(hw, 0x14, 0xef79);
        rtl8168_mdio_write(hw, 0x14, 0xfbe2);
        rtl8168_mdio_write(hw, 0x14, 0x87e7);
        rtl8168_mdio_write(hw, 0x14, 0xe387);
        rtl8168_mdio_write(hw, 0x14, 0xe8ef);
        rtl8168_mdio_write(hw, 0x14, 0x65e2);
        rtl8168_mdio_write(hw, 0x14, 0x87fb);
        rtl8168_mdio_write(hw, 0x14, 0xe387);
        rtl8168_mdio_write(hw, 0x14, 0xfcef);
        rtl8168_mdio_write(hw, 0x14, 0x7502);
        rtl8168_mdio_write(hw, 0x14, 0x49e5);
        rtl8168_mdio_write(hw, 0x14, 0xac50);
        rtl8168_mdio_write(hw, 0x14, 0x1abf);
        rtl8168_mdio_write(hw, 0x14, 0x8756);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdcef);
        rtl8168_mdio_write(hw, 0x14, 0x64e2);
        rtl8168_mdio_write(hw, 0x14, 0x87e9);
        rtl8168_mdio_write(hw, 0x14, 0xe387);
        rtl8168_mdio_write(hw, 0x14, 0xea1b);
        rtl8168_mdio_write(hw, 0x14, 0x659e);
        rtl8168_mdio_write(hw, 0x14, 0x16e4);
        rtl8168_mdio_write(hw, 0x14, 0x87e9);
        rtl8168_mdio_write(hw, 0x14, 0xe587);
        rtl8168_mdio_write(hw, 0x14, 0xeaae);
        rtl8168_mdio_write(hw, 0x14, 0x06bf);
        rtl8168_mdio_write(hw, 0x14, 0x8753);
        rtl8168_mdio_write(hw, 0x14, 0x024a);
        rtl8168_mdio_write(hw, 0x14, 0x5fe2);
        rtl8168_mdio_write(hw, 0x14, 0x87f7);
        rtl8168_mdio_write(hw, 0x14, 0xf636);
        rtl8168_mdio_write(hw, 0x14, 0xe687);
        rtl8168_mdio_write(hw, 0x14, 0xf7ff);
        rtl8168_mdio_write(hw, 0x14, 0xef97);
        rtl8168_mdio_write(hw, 0x14, 0xfffe);
        rtl8168_mdio_write(hw, 0x14, 0xfdfc);
        rtl8168_mdio_write(hw, 0x14, 0x04f8);
        rtl8168_mdio_write(hw, 0x14, 0xf9fa);
        rtl8168_mdio_write(hw, 0x14, 0xef69);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x4d02);
        rtl8168_mdio_write(hw, 0x14, 0x44dc);
        rtl8168_mdio_write(hw, 0x14, 0xad28);
        rtl8168_mdio_write(hw, 0x14, 0x29bf);
        rtl8168_mdio_write(hw, 0x14, 0x874a);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdcef);
        rtl8168_mdio_write(hw, 0x14, 0x54bf);
        rtl8168_mdio_write(hw, 0x14, 0x8747);
        rtl8168_mdio_write(hw, 0x14, 0x0244);
        rtl8168_mdio_write(hw, 0x14, 0xdcac);
        rtl8168_mdio_write(hw, 0x14, 0x290d);
        rtl8168_mdio_write(hw, 0x14, 0xac28);
        rtl8168_mdio_write(hw, 0x14, 0x05a3);
        rtl8168_mdio_write(hw, 0x14, 0x020c);
        rtl8168_mdio_write(hw, 0x14, 0xae10);
        rtl8168_mdio_write(hw, 0x14, 0xa303);
        rtl8168_mdio_write(hw, 0x14, 0x07ae);
        rtl8168_mdio_write(hw, 0x14, 0x0ba3);
        rtl8168_mdio_write(hw, 0x14, 0x0402);
        rtl8168_mdio_write(hw, 0x14, 0xae06);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x5302);
        rtl8168_mdio_write(hw, 0x14, 0x4a5f);
        rtl8168_mdio_write(hw, 0x14, 0xef96);
        rtl8168_mdio_write(hw, 0x14, 0xfefd);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8f9);
        rtl8168_mdio_write(hw, 0x14, 0xfafb);
        rtl8168_mdio_write(hw, 0x14, 0xef69);
        rtl8168_mdio_write(hw, 0x14, 0xfae0);
        rtl8168_mdio_write(hw, 0x14, 0x8015);
        rtl8168_mdio_write(hw, 0x14, 0xad25);
        rtl8168_mdio_write(hw, 0x14, 0x41d2);
        rtl8168_mdio_write(hw, 0x14, 0x0002);
        rtl8168_mdio_write(hw, 0x14, 0x86fb);
        rtl8168_mdio_write(hw, 0x14, 0xe087);
        rtl8168_mdio_write(hw, 0x14, 0xebe1);
        rtl8168_mdio_write(hw, 0x14, 0x87ec);
        rtl8168_mdio_write(hw, 0x14, 0x1b46);
        rtl8168_mdio_write(hw, 0x14, 0xab26);
        rtl8168_mdio_write(hw, 0x14, 0xd40b);
        rtl8168_mdio_write(hw, 0x14, 0xff1b);
        rtl8168_mdio_write(hw, 0x14, 0x46aa);
        rtl8168_mdio_write(hw, 0x14, 0x1fac);
        rtl8168_mdio_write(hw, 0x14, 0x3204);
        rtl8168_mdio_write(hw, 0x14, 0xef32);
        rtl8168_mdio_write(hw, 0x14, 0xae02);
        rtl8168_mdio_write(hw, 0x14, 0xd304);
        rtl8168_mdio_write(hw, 0x14, 0x0c31);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0xeb1a);
        rtl8168_mdio_write(hw, 0x14, 0x93d8);
        rtl8168_mdio_write(hw, 0x14, 0x19d9);
        rtl8168_mdio_write(hw, 0x14, 0x1b46);
        rtl8168_mdio_write(hw, 0x14, 0xab0e);
        rtl8168_mdio_write(hw, 0x14, 0x19d8);
        rtl8168_mdio_write(hw, 0x14, 0x19d9);
        rtl8168_mdio_write(hw, 0x14, 0x1b46);
        rtl8168_mdio_write(hw, 0x14, 0xaa06);
        rtl8168_mdio_write(hw, 0x14, 0x12a2);
        rtl8168_mdio_write(hw, 0x14, 0x08c9);
        rtl8168_mdio_write(hw, 0x14, 0xae06);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x5002);
        rtl8168_mdio_write(hw, 0x14, 0x4a5f);
        rtl8168_mdio_write(hw, 0x14, 0xfeef);
        rtl8168_mdio_write(hw, 0x14, 0x96ff);
        rtl8168_mdio_write(hw, 0x14, 0xfefd);
        rtl8168_mdio_write(hw, 0x14, 0xfc04);
        rtl8168_mdio_write(hw, 0x14, 0xf8fb);
        rtl8168_mdio_write(hw, 0x14, 0xef79);
        rtl8168_mdio_write(hw, 0x14, 0xa200);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x8756);
        rtl8168_mdio_write(hw, 0x14, 0xae33);
        rtl8168_mdio_write(hw, 0x14, 0xa201);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x8759);
        rtl8168_mdio_write(hw, 0x14, 0xae2b);
        rtl8168_mdio_write(hw, 0x14, 0xa202);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x875c);
        rtl8168_mdio_write(hw, 0x14, 0xae23);
        rtl8168_mdio_write(hw, 0x14, 0xa203);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x875f);
        rtl8168_mdio_write(hw, 0x14, 0xae1b);
        rtl8168_mdio_write(hw, 0x14, 0xa204);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x8762);
        rtl8168_mdio_write(hw, 0x14, 0xae13);
        rtl8168_mdio_write(hw, 0x14, 0xa205);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x8765);
        rtl8168_mdio_write(hw, 0x14, 0xae0b);
        rtl8168_mdio_write(hw, 0x14, 0xa206);
        rtl8168_mdio_write(hw, 0x14, 0x05bf);
        rtl8168_mdio_write(hw, 0x14, 0x8768);
        rtl8168_mdio_write(hw, 0x14, 0xae03);
        rtl8168_mdio_write(hw, 0x14, 0xbf87);
        rtl8168_mdio_write(hw, 0x14, 0x6b02);
        rtl8168_mdio_write(hw, 0x14, 0x44dc);
        rtl8168_mdio_write(hw, 0x14, 0xef64);
        rtl8168_mdio_write(hw, 0x14, 0xef97);
        rtl8168_mdio_write(hw, 0x14, 0xfffc);
        rtl8168_mdio_write(hw, 0x14, 0x04af);
        rtl8168_mdio_write(hw, 0x14, 0x00ed);
        rtl8168_mdio_write(hw, 0x14, 0x54a4);
        rtl8168_mdio_write(hw, 0x14, 0x3474);
        rtl8168_mdio_write(hw, 0x14, 0xa600);
        rtl8168_mdio_write(hw, 0x14, 0x22a4);
        rtl8168_mdio_write(hw, 0x14, 0x3411);
        rtl8168_mdio_write(hw, 0x14, 0xb842);
        rtl8168_mdio_write(hw, 0x14, 0x22b8);
        rtl8168_mdio_write(hw, 0x14, 0x42f0);
        rtl8168_mdio_write(hw, 0x14, 0xa200);
        rtl8168_mdio_write(hw, 0x14, 0xf0a2);
        rtl8168_mdio_write(hw, 0x14, 0x02f0);
        rtl8168_mdio_write(hw, 0x14, 0xa204);
        rtl8168_mdio_write(hw, 0x14, 0xf0a2);
        rtl8168_mdio_write(hw, 0x14, 0x06f0);
        rtl8168_mdio_write(hw, 0x14, 0xa208);
        rtl8168_mdio_write(hw, 0x14, 0xf0a2);
        rtl8168_mdio_write(hw, 0x14, 0x0af0);
        rtl8168_mdio_write(hw, 0x14, 0xa20c);
        rtl8168_mdio_write(hw, 0x14, 0xf0a2);
        rtl8168_mdio_write(hw, 0x14, 0x0e55);
        rtl8168_mdio_write(hw, 0x14, 0xb820);
        rtl8168_mdio_write(hw, 0x14, 0xd9c6);
        rtl8168_mdio_write(hw, 0x14, 0x08aa);
        rtl8168_mdio_write(hw, 0x14, 0xc430);
        rtl8168_mdio_write(hw, 0x14, 0x00c6);
        rtl8168_mdio_write(hw, 0x14, 0x1433);
        rtl8168_mdio_write(hw, 0x14, 0xc41a);
        rtl8168_mdio_write(hw, 0x14, 0x88c4);
        rtl8168_mdio_write(hw, 0x14, 0x2e22);
        rtl8168_mdio_write(hw, 0x14, 0xc42e);
        rtl8168_mdio_write(hw, 0x14, 0x54c4);
        rtl8168_mdio_write(hw, 0x14, 0x1a00);
        rtl8168_mdio_write(hw, 0x13, 0xb818);
        rtl8168_mdio_write(hw, 0x14, 0x1a01);
        rtl8168_mdio_write(hw, 0x13, 0xb81a);
        rtl8168_mdio_write(hw, 0x14, 0x020b);
        rtl8168_mdio_write(hw, 0x13, 0xb81c);
        rtl8168_mdio_write(hw, 0x14, 0x03ce);
        rtl8168_mdio_write(hw, 0x13, 0xb81e);
        rtl8168_mdio_write(hw, 0x14, 0x00e7);
        rtl8168_mdio_write(hw, 0x13, 0xb846);
        rtl8168_mdio_write(hw, 0x14, 0xffff);
        rtl8168_mdio_write(hw, 0x13, 0xb848);
        rtl8168_mdio_write(hw, 0x14, 0xffff);
        rtl8168_mdio_write(hw, 0x13, 0xb84a);
        rtl8168_mdio_write(hw, 0x14, 0xffff);
        rtl8168_mdio_write(hw, 0x13, 0xb84c);
        rtl8168_mdio_write(hw, 0x14, 0xffff);
        rtl8168_mdio_write(hw, 0x13, 0xb832);
        rtl8168_mdio_write(hw, 0x14, 0x000f);


        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x0000);
        rtl8168_mdio_write(hw, 0x14, 0x0000);
        rtl8168_mdio_write(hw, 0x1f, 0x0B82);
        gphy_val = rtl8168_mdio_read(hw, 0x17);
        gphy_val &= ~(BIT_0);
        rtl8168_mdio_write(hw, 0x17, gphy_val);
        rtl8168_mdio_write(hw, 0x1f, 0x0A43);
        rtl8168_mdio_write(hw, 0x13, 0x8042);
        rtl8168_mdio_write(hw, 0x14, 0x0000);

        rtl8168_clear_phy_mcu_patch_request(hw);

        //if (hw->RequiredSecLanDonglePatch) {
        //        rtl8168_mdio_write(hw, 0x1F, 0x0A43);
        //        gphy_val = rtl8168_mdio_read(hw, 0x11);
        //        gphy_val &= ~BIT_6;
        //        rtl8168_mdio_write(hw, 0x11, gphy_val);
        //}
}

void
hw_mac_mcu_config_8168h(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_29:
                rtl8168_set_mac_mcu_8168h_1(hw);
                break;
        case CFG_METHOD_30:
                rtl8168_set_mac_mcu_8168h_2(hw);
                break;
        case CFG_METHOD_35:
                rtl8168_set_mac_mcu_8168h_3(hw);
                break;
        }
}

void
hw_phy_mcu_config_8168h(struct rtl_hw *hw)
{
        switch (hw->mcfg) {
        case CFG_METHOD_29:
                rtl8168_set_phy_mcu_8168h_1(hw);
                break;
        case CFG_METHOD_30:
                rtl8168_set_phy_mcu_8168h_2(hw);
                break;
        case CFG_METHOD_35:
                rtl8168_set_phy_mcu_8168h_3(hw);
                break;
        }
}
