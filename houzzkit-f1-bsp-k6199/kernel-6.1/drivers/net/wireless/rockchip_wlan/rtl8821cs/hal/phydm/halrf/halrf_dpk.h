/******************************************************************************
 *
 * Copyright(c) 2007 - 2017  Realtek Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * The full GNU General Public License is included in this distribution in the
 * file called LICENSE.
 *
 * Contact Information:
 * wlanfae <wlanfae@realtek.com>
 * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
 * Hsinchu 300, Taiwan.
 *
 * Larry Finger <Larry.Finger@lwfinger.net>
 *
 *****************************************************************************/

#ifndef __HALRF_DPK_H__
#define __HALRF_DPK_H__

/*@--------------------------Define Parameters-------------------------------*/
#define LBK_RXIQK 0
#define GAIN_LOSS 1
#define DO_DPK 2
#define DPK_ON 3
#define GAIN_LOSS_PULSE 4
#define DPK_PAS 5
#define DPK_LMS 6
#define DPK_LOK 4
#define DPK_TXK 5
#define DAGC 4
#define SYNC_DC 5
#define MDPK_DC 6
#define LOSS_CHK 0
#define GAIN_CHK 1
#define SYNC_CHK 3
#define PAS_READ 2
#define AVG_THERMAL_NUM 8
#define AVG_THERMAL_NUM_DPK 8
#define THERMAL_DPK_AVG_NUM 4

#define DPK_RF18 2

/*define RF path numer*/
#if (RTL8198F_SUPPORT == 1 || RTL8814B_SUPPORT == 1|| RTL8814C_SUPPORT == 1)
#define KPATH 4
#elif (RTL8192F_SUPPORT == 1 || RTL8197F_SUPPORT == 1 ||RTL8197G_SUPPORT == 1 ||\
	RTL8822C_SUPPORT == 1 || RTL8812F_SUPPORT == 1 || RTL8723F_SUPPORT == 1 ||\
	RTL8822E_SUPPORT == 1)
#define KPATH 2
#else
#define KPATH 1
#endif

#if (RTL8814B_SUPPORT == 1 || RTL8721D_SUPPORT == 1)
#define GROUP_5G 6
#elif (RTL8195B_SUPPORT == 1)
#define GROUP_5G 13
#endif

/*@---------------------------End Define Parameters---------------------------*/

struct dm_dpk_info {

	boolean	is_dpk_enable;
	boolean	is_dpk_pwr_on;
	boolean	is_dpk_by_channel;
	boolean is_tssi_mode;
	u8	dpk_status;			/*bit[0]:reload;bit[1]:cal;bit[2]:cal_ok*/
	u16	dpk_path_ok;
	/*@BIT(15)~BIT(12) : 5G reserved, BIT(11)~BIT(8) 5G_S3~5G_S0*/
	/*@BIT(7)~BIT(4) : 2G reserved, BIT(3)~BIT(0) 2G_S3~2G_S0*/
	u8	thermal_dpk[KPATH];					/*path*/	
	u8	thermal_dpk_avg[KPATH][AVG_THERMAL_NUM_DPK];	/*path*/
	u8	pre_pwsf[KPATH];
	u16	pwsf[KPATH];				/*path*/
	u8	thermal_dpk_avg_index;
	u32	gnt_control;
	u32	gnt_value;
	u8	dpk_ch;
	u8	dpk_band;
	u8	dpk_bw;
	u32	dpk_rf18[DPK_RF18];
	u32	dpk_cal_cnt;
	u32	dpk_ok_cnt;
	u32	dpk_reload_cnt;
	u8	txagc_k[KPATH];		/*txagc@dpk with path*/

#if (RTL8822C_SUPPORT == 1 || RTL8812F_SUPPORT == 1 || RTL8197G_SUPPORT == 1 || RTL8735B_SUPPORT == 1 || \
	RTL8822E_SUPPORT == 1)
	u16	dc_i[2];			/*MDPD DC I path*/
	u16	dc_q[2];			/*MDPD DC Q path*/
	u8	corr_val[2];			/*Corr value path*/
	u8	corr_idx[2];			/*Corr index path*/
#endif

#if (RTL8822C_SUPPORT == 1 || RTL8812F_SUPPORT == 1 || RTL8822E_SUPPORT == 1)
	u8	result[2];			/*path*/
	u8	dpk_txagc[2];			/*path*/
	u32	coef[2][20];			/*path/MDPD coefficient*/
	u16	dpk_gs[2];			/*MDPD coef gs*/
	u8	thermal_dpk_delta[2];		/*path*/
	u32	dpk_lms_err[2];			/*path*/
	u32	dpk_data[11];			/*path/MDPD coefficient*/
#endif

#if (RTL8198F_SUPPORT == 1 || RTL8192F_SUPPORT == 1 || RTL8197F_SUPPORT == 1 ||\
	RTL8814B_SUPPORT == 1 || RTL8197G_SUPPORT == 1)
	/*2G DPK data*/
	u8 	dpk_result[KPATH][3];			/*path/group*/
	u8 	pwsf_2g[KPATH][3];			/*path/group*/	
	u32	lut_2g_even[KPATH][3][64];		/*path/group/LUT data*/
	u32	lut_2g_odd[KPATH][3][64];		/*path/group/LUT data*/
	s16	tmp_pas_i[32];			/*PAScan I data*/
	s16	tmp_pas_q[32];			/*PAScan Q data*/
#endif

#if (RTL8814B_SUPPORT == 1)
	/*5G DPK data*/
	u8	dpk_5g_result[KPATH][GROUP_5G];			/*path/group*/
	u8	pwsf_5g[KPATH][GROUP_5G];			/*path/group*/
	u32	lut_5g[KPATH][GROUP_5G][64];			/*path/group/LUT data*/
	u32	lut_2g[KPATH][3][64];			/*path/group/LUT data*/
	u8	rxbb[4];			/*path/group*/
	u8	txbb[4];			/*path/group*/
	u8	tx_gain;
#endif

#if (RTL8814C_SUPPORT == 1)
	u8	thr_pwsf[KPATH];
#endif


#if (RTL8195B_SUPPORT == 1)
		u8	dpk_txagc;
		/*2G DPK data*/
	u8	dpk_2g_result[KPATH][3];			/*path/group*/
	u8	pwsf_2g[KPATH][3];			/*path/group*/
	u32	lut_2g_even[KPATH][3][16];		/*path/group/LUT data*/
	u32	lut_2g_odd[KPATH][3][16];		/*path/group/LUT data*/
		/*5G DPK data*/
	u8	dpk_5g_result[KPATH][GROUP_5G];			/*path/group*/
	u8	pwsf_5g[KPATH][GROUP_5G];			/*path/group*/
	u32	lut_5g_even[KPATH][GROUP_5G][16];		/*path/group/LUT data*/
	u32	lut_5g_odd[KPATH][GROUP_5G][16];		/*path/group/LUT data*/
#endif

#if (RTL8721D_SUPPORT == 1)
	s16	tmp_pas_i[32];			/*PAScan I data*/
	s16	tmp_pas_q[32];			/*PAScan Q data*/
	u8	dpk_txagc;			/*path*/
#if (DPK_BY_GROUP_K_8721D)
	/*2G DPK data*/
	u8	dpk_2g_result[1][3];		/*path/group*/
	u8	pwsf_2g[1][3];			/*path/group*/
	u32	lut_2g_even[1][3][16];		/*path/group/LUT data*/
	u32	lut_2g_odd[1][3][16];		/*path/group/LUT data*/
	/*5G DPK data*/
	u8	dpk_5g_result[1][6];		/*path/group*/
	u8	pwsf_5g[1][6];			/*path/group*/
	u32	lut_5g_even[1][6][16];		/*path/group/LUT data*/
	u32	lut_5g_odd[1][6][16];		/*path/group/LUT data*/
#else
	u8	dpk_2g_result[1][1];		/*path/group*/
	u8	pwsf_2g[1][1];			/*path/group*/
	u32	lut_2g_even[1][1][16];		/*path/group/LUT data*/
	u32	lut_2g_odd[1][1][16];		/*path/group/LUT data*/
	u8	dpk_5g_result[1][1];		/*path/group*/
	u8	pwsf_5g[1][1];			/*path/group*/
	u32	lut_5g_even[1][1][16];		/*path/group/LUT data*/
	u32	lut_5g_odd[1][1][16];		/*path/group/LUT data*/
#endif
#endif

#if(RTL8723F_SUPPORT == 1 || RTL8730A_SUPPORT == 1)
	u8	one_shot_cnt;
	u8	dpk_current_path;
	u8	thermal_init[KPATH];
	u8	dpk_delta_thermal[KPATH];		/*path*/
	s8	last_offset[KPATH];			/*path*/
	u8	txagc[KPATH];				/*path*/
	u8	tssi_txagc[KPATH][2];			/*path/0:txagc_rf,1:tssi_offset*/
	u16	digital_bbgain[KPATH];			/*path*/
	//u16	pwsf[KPATH];				/*path*/

#endif
};

#if (RTL8822C_SUPPORT == 1 || RTL8822E_SUPPORT == 1)
struct dm_dpk_c2h_report {
	u8	result[2];		/*ch0_result/ch1_result*/
	u8	therm[2][2];		/*therm0_s0/therm0_s1/therm1_s0/therm1_s1*/
	u8	therm_delta[2][2];	/*therm_delta0_s0/therm_delta0_s1/therm_delta1_s0/therm_delta1_s1*/
	u32	dpk_rf18[2];		/*dpk_ch0/dpk_ch1*/
	u8	dpk_status;		/*dpk_status*/
};
#endif

#endif /*__HALRF_DPK_H__*/
