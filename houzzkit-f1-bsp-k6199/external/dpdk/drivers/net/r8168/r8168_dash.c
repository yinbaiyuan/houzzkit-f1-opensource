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

static void
rtl8168_clear_and_set_other_fun_pci_bit(struct rtl_hw *hw,
                                        u8 multi_fun_sel_bit,
                                        u32 addr,
                                        u32 clearmask,
                                        u32 setmask)
{
        u32 TmpUlong;

        TmpUlong = rtl8168_csi_other_fun_read(hw, multi_fun_sel_bit, addr);
        TmpUlong &= ~clearmask;
        TmpUlong |= setmask;
        rtl8168_csi_other_fun_write(hw, multi_fun_sel_bit, addr, TmpUlong);
}

static void
rtl8168_other_fun_dev_pci_setting(struct rtl_hw *hw,
                                  u32 addr,
                                  u32 clearmask,
                                  u32 setmask,
                                  u8 multi_fun_sel_bit)
{
        u32 TmpUlong;
        u8 i;
        u8 FunBit;

        for (i = 0; i < 8; i++) {
                FunBit = (1 << i);
                if (FunBit & multi_fun_sel_bit) {
                        u8 set_other_fun = TRUE;

                        switch (hw->mcfg) {
                        case CFG_METHOD_23:
                        case CFG_METHOD_27:
                        case CFG_METHOD_28:
                                //0: UMAC, 1: TCR1, 2: TCR2, 3: KCS, 4: EHCI(Control by EHCI Driver)
                                if (i < 5) {
                                        TmpUlong = rtl8168_csi_other_fun_read(hw, i, 0x00);
                                        if (TmpUlong == 0xFFFFFFFF)
                                                set_other_fun = TRUE;
                                        else
                                                set_other_fun = FALSE;
                                }
                                break;
                        case CFG_METHOD_31:
                        case CFG_METHOD_32:
                        case CFG_METHOD_33:
                        case CFG_METHOD_34:
                                //0: BMC, 1: NIC, 2: TCR, 3: VGA/PCIE_TO_USB, 4: EHCI, 5: WIFI, 6: WIFI, 7: KCS
                                if (i == 5 || i == 6) {
                                        if (hw->DASH) {
                                                TmpUlong = rtl8168_ocp_read(hw, 0x184, 4);
                                                if (TmpUlong & BIT_26)
                                                        set_other_fun = FALSE;
                                                else
                                                        set_other_fun = TRUE;
                                        }
                                } else { //function 0/1/2/3/4/7
                                        TmpUlong = rtl8168_csi_other_fun_read(hw, i, 0x00);
                                        if (TmpUlong == 0xFFFFFFFF)
                                                set_other_fun = TRUE;
                                        else
                                                set_other_fun = FALSE;
                                }
                                break;
                        default:
                                return;
                        }

                        if (set_other_fun)
                                rtl8168_clear_and_set_other_fun_pci_bit(hw, i, addr, clearmask, setmask);
                }
        }
}

static void
rtl8168_set_dash_other_fun_dev_state_change(struct rtl_hw *hw,
                u8 dev_state,
                u8 multi_fun_sel_bit)
{
        u32 clearmask;
        u32 setmask;

        if (dev_state == 0) {
                //
                // goto D0
                //
                clearmask = (BIT_0 | BIT_1);
                setmask = 0;

                rtl8168_other_fun_dev_pci_setting(hw, 0x44, clearmask, setmask, multi_fun_sel_bit);
        } else {
                //
                // goto D3
                //
                clearmask = 0;
                setmask = (BIT_0 | BIT_1);

                rtl8168_other_fun_dev_pci_setting(hw, 0x44, clearmask, setmask, multi_fun_sel_bit);
        }
}

static void
rtl8168_set_dash_other_fun_dev_aspm_clkreq(struct rtl_hw *hw,
                u8 aspm_val,
                u8 clkreq_en,
                u8 multi_fun_sel_bit)
{
        u32 clearmask;
        u32 setmask;

        aspm_val &= (BIT_0 | BIT_1);
        clearmask = (BIT_0 | BIT_1 | BIT_8);
        setmask = aspm_val;
        if (clkreq_en)
                setmask |= BIT_8;

        rtl8168_other_fun_dev_pci_setting(hw, 0x80, clearmask, setmask, multi_fun_sel_bit);
}

static void rtl8168_oob_notify(struct rtl_hw *hw, u8 cmd)
{
        rtl8168_eri_write(hw, 0xE8, 1, cmd, ERIAR_ExGMAC);

        rtl8168_ocp_write(hw, 0x30, 1, 0x01);
}

static int rtl8168_wait_dash_fw_ready(struct rtl_hw *hw)
{
        int rc = -1;

        if (!HW_DASH_SUPPORT_DASH(hw))
                goto out;

        if (!hw->DASH)
                goto out;

        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                int timeout;
                for (timeout = 0; timeout < 10; timeout++) {
                        mdelay(10);
                        if (rtl8168_ocp_read(hw, 0x124, 1) & BIT_0) {
                                rc = 1;
                                goto out;
                        }
                }
        } else {
                u32 reg;
                int timeout;

                if (hw->mcfg == CFG_METHOD_13)
                        reg = 0xB8;
                else
                        reg = 0x10;

                for (timeout = 0; timeout < 10; timeout++) {
                        mdelay(10);
                        if (rtl8168_ocp_read(hw, reg, 2) & BIT_11) {
                                rc = 1;
                                goto out;
                        }
                }
        }
        rc = 0;
out:
        return rc;
}

void rtl8168_driver_start(struct rtl_hw *hw)
{
        //change other device state to D0.
        switch (hw->mcfg) {
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
                rtl8168_set_dash_other_fun_dev_aspm_clkreq(hw, 3, 1, 0x1E);
                rtl8168_set_dash_other_fun_dev_state_change(hw, 3, 0x1E);
                break;
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                rtl8168_set_dash_other_fun_dev_aspm_clkreq(hw, 3, 1, 0xFC);
                rtl8168_set_dash_other_fun_dev_state_change(hw, 3, 0xFC);
                break;
        }

        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                u32 tmp_value;

                rtl8168_ocp_write(hw, 0x180, 1, OOB_CMD_DRIVER_START);
                tmp_value = rtl8168_ocp_read(hw, 0x30, 1);
                tmp_value |= BIT_0;
                rtl8168_ocp_write(hw, 0x30, 1, tmp_value);

                rtl8168_wait_dash_fw_ready(hw);
        } else {
                if (hw->mcfg == CFG_METHOD_13)
                        RTL_W8(hw, TwiCmdReg, RTL_R8(hw, TwiCmdReg) | (BIT_7));

                rtl8168_oob_notify(hw, OOB_CMD_DRIVER_START);

                rtl8168_wait_dash_fw_ready(hw);
        }
}

void rtl8168_driver_stop(struct rtl_hw *hw)
{
        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                u32 tmp_value;

                rtl8168_dash2_disable_txrx(hw);

                rtl8168_ocp_write(hw, 0x180, 1, OOB_CMD_DRIVER_STOP);
                tmp_value = rtl8168_ocp_read(hw, 0x30, 1);
                tmp_value |= BIT_0;
                rtl8168_ocp_write(hw, 0x30, 1, tmp_value);

                rtl8168_wait_dash_fw_ready(hw);
        } else {

                rtl8168_oob_notify(hw, OOB_CMD_DRIVER_STOP);

                rtl8168_wait_dash_fw_ready(hw);

                if (hw->mcfg == CFG_METHOD_13)
                        RTL_W8(hw, TwiCmdReg, RTL_R8(hw, TwiCmdReg) & ~(BIT_7));

        }

        //change other device state to D3.
        switch (hw->mcfg) {
        case CFG_METHOD_23:
        case CFG_METHOD_27:
        case CFG_METHOD_28:
                rtl8168_set_dash_other_fun_dev_state_change(hw, 3, 0x0E);
                break;
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                rtl8168_set_dash_other_fun_dev_state_change(hw, 3, 0xFD);
                break;
        }
}

int rtl8168_check_dash(struct rtl_hw *hw)
{
        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                if (rtl8168_ocp_read(hw, 0x128, 1) & BIT_0)
                        return 1;
                else
                        return 0;
        } else {
                u32 reg;

                if (hw->mcfg == CFG_METHOD_13)
                        reg = 0xb8;
                else
                        reg = 0x10;

                if (rtl8168_ocp_read(hw, reg, 2) & 0x00008000)
                        return 1;
                else
                        return 0;
        }
}
/*
void DisableDashFp(struct rtl_hw *hw)
{
        int EnableDash = 1;
        u32 tmpUshort = 0;
        int WaitCnt = 0;
        if (HW_DASH_SUPPORT_TYPE_3(hw))
        {
                //check dash status
                EnableDash = rtl8168_check_dash(hw);
                if (!EnableDash) return;

                //inform risc to disable dash
                rtl8168_ocp_write(hw, 0x180, 1, 0x55);
                tmpUshort = rtl8168_ocp_read(hw, 0x30, 1);
                tmpUshort |= BIT_0;
                rtl8168_ocp_write(hw, 0x30, 1, tmpUshort);

                //wait for dash disable OK.
                do
                {
                        EnableDash = rtl8168_check_dash(hw);
                        if (!EnableDash) break;

                        mdelay(1); //1ms
                        WaitCnt++;
                } while (WaitCnt < 20);

                if (WaitCnt == 20) {
                        printf("Disable FP Dash timeout.\n");
                }
        }
        return;
}
*/

bool rtl8168_check_dash_other_fun_present(struct rtl_hw *hw)
{
        //check if func 2 exist
        if (rtl8168_csi_other_fun_read(hw, 2, 0x00) != 0xffffffff)
                return true;

        return false;
}

static u32 RTL_CMAC_R32(struct rtl_hw *hw)
{
        u32 cmd;
        int i;
        u32 value = 0;
        u8 multi_fun_sel_bit;

        if (hw->mcfg == CFG_METHOD_20)
                multi_fun_sel_bit = 2;
        else if (hw->mcfg == CFG_METHOD_26 || hw->mcfg == CFG_METHOD_31 ||
                 hw->mcfg == CFG_METHOD_32 || hw->mcfg == CFG_METHOD_33 ||
                 hw->mcfg == CFG_METHOD_34)
                multi_fun_sel_bit = 1;
        else
                multi_fun_sel_bit = 0;

        cmd = CSIAR_Read | CSIAR_ByteEn << CSIAR_ByteEn_shift | 0xf9;

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

static u8 RTL_CMAC_R8(struct rtl_hw *hw, u32 reg)
{
        u32 value1 = 0, mask;
        u8 val_shift, value2 = 0;

        val_shift = reg - 0xf8;

        if (val_shift == 0)           mask = 0xFF;
        else if (val_shift == 1)      mask = 0xFF00;
        else if (val_shift == 2)      mask = 0xFF0000;
        else if (val_shift == 3)      mask = 0xFF000000;

        value1 = RTL_CMAC_R32(hw) & mask;
        value2 = value1 >> (val_shift * 8);

        return value2;
}

static void RTL_CMAC_W8(struct rtl_hw *hw, u32 reg, u8 value)
{
        u32 cmd, mask;
        int i;
        u8 multi_fun_sel_bit, val_shift;
        u32 value32;

        val_shift = reg - 0xf8;

        if (val_shift == 0)           mask = 0xFF;
        else if (val_shift == 1)      mask = 0xFF00;
        else if (val_shift == 2)      mask = 0xFF0000;
        else if (val_shift == 3)      mask = 0xFF000000;

        if (hw->mcfg == CFG_METHOD_20)
                multi_fun_sel_bit = 2;
        else if (hw->mcfg == CFG_METHOD_26 || hw->mcfg == CFG_METHOD_31 ||
                 hw->mcfg == CFG_METHOD_32 || hw->mcfg == CFG_METHOD_33 ||
                 hw->mcfg == CFG_METHOD_34)
                multi_fun_sel_bit = 1;
        else
                multi_fun_sel_bit = 0;

        value32 = RTL_CMAC_R32(hw) & ~mask;
        value32 |= value << (val_shift * 8);
        RTL_W32(hw, CSIDR, value32);

        cmd = CSIAR_Write | CSIAR_ByteEn << CSIAR_ByteEn_shift | 0xf9;

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

static void rtl8168_dash2_disable_tx(struct rtl_hw *hw)
{
        if (!hw->DASH)
                return;

        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                u16 WaitCnt;
                u8 TmpUchar;

                //Disable oob Tx
                RTL_CMAC_W8(hw, CMAC_IBCR2, RTL_CMAC_R8(hw, CMAC_IBCR2) & ~(BIT_0));
                WaitCnt = 0;

                //wait oob tx disable
                do {
                        TmpUchar = RTL_CMAC_R8(hw, CMAC_IBISR0);

                        if (TmpUchar & ISRIMR_DASH_TYPE2_TX_DISABLE_IDLE) {
                                break;
                        }

                        udelay(50);
                        WaitCnt++;
                } while (WaitCnt < 2000);

                //Clear ISRIMR_DASH_TYPE2_TX_DISABLE_IDLE
                RTL_CMAC_W8(hw, CMAC_IBISR0, RTL_CMAC_R8(hw, CMAC_IBISR0) | ISRIMR_DASH_TYPE2_TX_DISABLE_IDLE);
        }
}

static void rtl8168_dash2_disable_rx(struct rtl_hw *hw)
{
        if (!hw->DASH)
                return;

        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                RTL_CMAC_W8(hw, CMAC_IBCR0, RTL_CMAC_R8(hw, CMAC_IBCR0) & ~(BIT_0));
        }
}

void rtl8168_dash2_disable_txrx(struct rtl_hw *hw)
{
        if (HW_DASH_SUPPORT_TYPE_2(hw) || HW_DASH_SUPPORT_TYPE_3(hw)) {
                rtl8168_dash2_disable_tx(hw);
                rtl8168_dash2_disable_rx(hw);
        }
}
