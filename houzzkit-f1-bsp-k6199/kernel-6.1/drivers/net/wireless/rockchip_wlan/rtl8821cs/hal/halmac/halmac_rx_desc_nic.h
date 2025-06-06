/******************************************************************************
 *
 * Copyright(c) 2016 - 2019 Realtek Corporation. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 ******************************************************************************/

#ifndef _HALMAC_RX_DESC_NIC_H_
#define _HALMAC_RX_DESC_NIC_H_
#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

/*RXDESC_WORD0*/

#define GET_RX_DESC_EOR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 30, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_PHYPKTIDC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 28, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_EVT_PKT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 28, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_SWDEC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 27, 1)
#define GET_RX_DESC_PHYST(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 26, 1)
#define GET_RX_DESC_SHIFT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 24, 2)
#define GET_RX_DESC_QOS(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 23, 1)
#define GET_RX_DESC_SECURITY(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 20, 3)
#define GET_RX_DESC_DRV_INFO_SIZE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 16, 4)
#define GET_RX_DESC_ICV_ERR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 15, 1)
#define GET_RX_DESC_CRC32(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 14, 1)
#define GET_RX_DESC_PKT_LEN(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 0, 14)

/*RXDESC_WORD1*/

#define GET_RX_DESC_BC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 31, 1)
#define GET_RX_DESC_MC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 30, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_TY_PE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 28, 2)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_TYPE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 28, 2)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_MF(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 27, 1)
#define GET_RX_DESC_MD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 26, 1)
#define GET_RX_DESC_PWR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 25, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_PAM(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 24, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_A1_MATCH(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 24, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_CHK_VLD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 23, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_TCP_CHKSUM_VLD(rxdesc)                                     \
	LE_BITS_TO_4BYTE(rxdesc + 0x04, 23, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RX_IS_TCP_UDP(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 22, 1)
#define GET_RX_DESC_RX_IPV(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 21, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_CHKERR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 20, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_TCP_CHKSUM_ERR(rxdesc)                                     \
	LE_BITS_TO_4BYTE(rxdesc + 0x04, 20, 1)
#define GET_RX_DESC_PHY_PKT_IDC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 17, 1)
#define GET_RX_DESC_FW_FIFO_FULL(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 16, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_PAGGR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 15, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_AMPDU(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 15, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RXID_MATCH(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 14, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_RXCMD_IDC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 14, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_AMSDU(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 13, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_MACID_VLD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 12, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_TID(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 8, 4)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_MACID(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 0, 7)

/*RXDESC_WORD2*/

#define GET_RX_DESC_FCS_OK(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 31, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_AMSDU_CUT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 31, 1)

#endif

#if (HALMAC_8822B_SUPPORT || HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT ||   \
     HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT ||   \
     HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_PPDU_CNT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 29, 2)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_C2H(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 28, 1)

#endif

#if (HALMAC_8198F_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT)

#define GET_RX_DESC_HWRSVD_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 25, 3)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8822C_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_HWRSVD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 24, 4)

#endif

#if (HALMAC_8198F_SUPPORT || HALMAC_8192F_SUPPORT)

#define GET_RX_DESC_RXMAGPKT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 24, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_WLANHD_IV_LEN(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 18, 6)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_LAST_MSDU(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 17, 1)

#endif

#if (HALMAC_8822C_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RX_STATISTICS(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 17, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RX_IS_QOS(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 16, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_EXT_SEC_TYPE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 16, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_FRAG(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 12, 4)
#define GET_RX_DESC_SEQ(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 0, 12)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

/*RXDESC_WORD3*/

#define GET_RX_DESC_MAGIC_WAKE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 31, 1)
#define GET_RX_DESC_UNICAST_WAKE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 30, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_PATTERN_MATCH(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 29, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_PATTERN_WAKE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 29, 1)

#endif

#if (HALMAC_8822B_SUPPORT || HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT ||   \
     HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RXPAYLOAD_MATCH(rxdesc)                                    \
	LE_BITS_TO_4BYTE(rxdesc + 0x0C, 28, 1)
#define GET_RX_DESC_RXPAYLOAD_ID(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 24, 4)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_DMA_AGG_NUM(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 16, 8)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_BSSID_FIT_1_0(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 12, 2)
#define GET_RX_DESC_EOSP(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 11, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_BSSID_FIT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 11, 5)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_HTC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 10, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_AMPDU_END_PKT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 9, 1)
#define GET_RX_DESC_ADDRESS_CAM_VLD(rxdesc)                                    \
	LE_BITS_TO_4BYTE(rxdesc + 0x0C, 8, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_BSSID_FIT_4_2(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 7, 3)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_EOSP_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 7, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RX_RATE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 0, 7)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT ||   \
     HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

/*RXDESC_WORD4*/

#define GET_RX_DESC_A1_FIT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 24, 5)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_ADDRESS_CAM(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 24, 8)

#endif

#if (HALMAC_8198F_SUPPORT || HALMAC_8197G_SUPPORT)

#define GET_RX_DESC_A1_FIT_A1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 24, 7)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_MACID_VLD_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 23, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_MACID_RPT_BUFF(rxdesc)                                     \
	LE_BITS_TO_4BYTE(rxdesc + 0x10, 17, 7)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RX_PRE_NDP_VLD(rxdesc)                                     \
	LE_BITS_TO_4BYTE(rxdesc + 0x10, 16, 1)

#endif

#if (HALMAC_8192F_SUPPORT)

#define GET_RX_DESC_SWPS_RPT_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 16, 1)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_MACID_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 15, 8)

#endif

#if (HALMAC_8192F_SUPPORT)

#define GET_RX_DESC_FC_POWER_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 15, 1)
#define GET_RX_DESC_TXRPTMID_CTL_MASK_V1(rxdesc)                               \
	LE_BITS_TO_4BYTE(rxdesc + 0x10, 14, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT || HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_RX_SCRAMBLER(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 9, 7)
#define GET_RX_DESC_RX_EOF(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 8, 1)

#endif

#if (HALMAC_8192F_SUPPORT)

#define GET_RX_DESC_SNIF_INFO(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 8, 6)

#endif

#if (HALMAC_8197F_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8197G_SUPPORT)

#define GET_RX_DESC_FC_POWER(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 7, 1)

#endif

#if (HALMAC_8198F_SUPPORT || HALMAC_8197G_SUPPORT)

#define GET_RX_DESC_TXRPTMID_CTL_MASK(rxdesc)                                  \
	LE_BITS_TO_4BYTE(rxdesc + 0x10, 6, 1)

#endif

#if (HALMAC_8814B_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8197G_SUPPORT)

#define GET_RX_DESC_SWPS_RPT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 5, 1)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8821C_SUPPORT ||   \
     HALMAC_8822C_SUPPORT || HALMAC_8192F_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

#define GET_RX_DESC_PATTERN_IDX(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 0, 8)

#endif

#if (HALMAC_8197F_SUPPORT || HALMAC_8198F_SUPPORT)

#define GET_RX_DESC_PATTERN_IDX_V1(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 0, 5)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_PATTERN_IDX_V2(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 0, 5)

#endif

#if (HALMAC_8814A_SUPPORT || HALMAC_8822B_SUPPORT || HALMAC_8197F_SUPPORT ||   \
     HALMAC_8821C_SUPPORT || HALMAC_8198F_SUPPORT || HALMAC_8822C_SUPPORT ||   \
     HALMAC_8192F_SUPPORT || HALMAC_8197G_SUPPORT || HALMAC_8812F_SUPPORT ||   \
     HALMAC_8822E_SUPPORT)

/*RXDESC_WORD5*/

#define GET_RX_DESC_TSFL(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x14, 0, 32)

#endif

#if (HALMAC_8814B_SUPPORT)

#define GET_RX_DESC_FREERUN_CNT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x14, 0, 32)

#endif

#endif
