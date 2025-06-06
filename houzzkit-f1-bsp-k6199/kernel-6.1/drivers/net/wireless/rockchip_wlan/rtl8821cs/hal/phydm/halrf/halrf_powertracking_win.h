/******************************************************************************
 *
 * Copyright(c) 2007 - 2017 Realtek Corporation.
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
 *****************************************************************************/

#ifndef __HALRF_POWERTRACKING_H__
#define __HALRF_POWERTRACKING_H__

#define	DPK_DELTA_MAPPING_NUM	13
#define	index_mapping_HP_NUM	15
#define	TXSCALE_TABLE_SIZE		37
#define	OFDM_TABLE_SIZE			43
#define	CCK_TABLE_SIZE			33
#define	CCK_TABLE_SIZE_8723D    41
#define	TXPWR_TRACK_TABLE_SIZE	30
#define	DELTA_SWINGIDX_SIZE     30
#define	DELTA_SWINTSSI_SIZE     61
#define	BAND_NUM				3
#define	MAX_RF_PATH	4
#define	CCK_TABLE_SIZE_88F	21
#define	AVG_THERMAL_NUM_LCK	2


/* JJ ADD 20161014 */
#define	CCK_TABLE_SIZE_8710B   41
#define	CCK_TABLE_SIZE_8192F   41


#define	dm_check_txpowertracking	odm_txpowertracking_check

#define IQK_MATRIX_SETTINGS_NUM	(14+24+21) /* Channels_2_4G_NUM + Channels_5G_20M_NUM + Channels_5G */
#define	AVG_THERMAL_NUM		8
#define	iqk_matrix_reg_num	8
#define	IQK_MAC_REG_NUM		4
#define	IQK_ADDA_REG_NUM		16

#define	IQK_BB_REG_NUM		9


extern	u32 ofdm_swing_table[OFDM_TABLE_SIZE];
extern	u8 cck_swing_table_ch1_ch13[CCK_TABLE_SIZE][8];
extern	u8 cck_swing_table_ch14[CCK_TABLE_SIZE][8];

extern	u32 ofdm_swing_table_new[OFDM_TABLE_SIZE];
extern	u8 cck_swing_table_ch1_ch13_new[CCK_TABLE_SIZE][8];
extern	u8 cck_swing_table_ch14_new[CCK_TABLE_SIZE][8];
extern	u8 cck_swing_table_ch1_ch14_88f[CCK_TABLE_SIZE_88F][16];
extern	u8 cck_swing_table_ch1_ch13_88f[CCK_TABLE_SIZE_88F][16];
extern	u8 cck_swing_table_ch14_88f[CCK_TABLE_SIZE_88F][16];
extern	u32 cck_swing_table_ch1_ch14_8723d[CCK_TABLE_SIZE_8723D];
/* JJ ADD 20161014 */
extern	u32 cck_swing_table_ch1_ch14_8710b[CCK_TABLE_SIZE_8710B];
extern	u32 cck_swing_table_ch1_ch14_8192f[CCK_TABLE_SIZE_8192F];

extern  u32 tx_scaling_table_jaguar[TXSCALE_TABLE_SIZE];

/* <20121018, Kordan> In case fail to read TxPowerTrack.txt, we use the table of 88E as the default table. */
static u8 delta_swing_table_idx_2ga_p_8188e[] = {0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4,  4,  4,  4,  4,  4,  5,  5,  7,  7,  8,  8,  8,  9,  9,  9,  9,  9};
static u8 delta_swing_table_idx_2ga_n_8188e[] = {0, 0, 0, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5,  6,  6,  7,  7,  7,  7,  8,  8,  9,  9, 10, 10, 10, 11, 11, 11, 11};

void
odm_txpowertracking_check(
	void		*dm_void
);

void
odm_txpowertracking_check_ap(
	void		*dm_void
);

void
odm_txpowertracking_thermal_meter_init(
	void		*dm_void
);

void
odm_txpowertracking_init(
	void		*dm_void
);

void
odm_txpowertracking_check_mp(
	void		*dm_void
);


void
odm_txpowertracking_check_ce(
	void		*dm_void
);

#if (DM_ODM_SUPPORT_TYPE & (ODM_WIN))


void
odm_txpowertracking_thermal_meter_check(
	void		*adapter
);

#endif

struct iqk_matrix_regs_setting {
	boolean	is_iqk_done;
	s32		value[3][iqk_matrix_reg_num];
	boolean	is_bw_iqk_result_saved[3];
};

struct dm_rf_calibration_struct {
	/* for tx power tracking */

	u32	rega24; /* for TempCCK */
	s32	rege94;
	s32	rege9c;
	s32	regeb4;
	s32	regebc;
	/* u8 is_txpowertracking; */
	u8	tx_powercount;
	boolean is_txpowertracking_init;
	boolean is_txpowertracking;
	u8  	txpowertrack_control; /* for mp mode, turn off txpwrtracking as default */
	u8	tm_trigger;
	u8  	internal_pa_5g[2];	/* pathA / pathB */

	u8  	thermal_meter[2];    /* thermal_meter, index 0 for RFIC0, and 1 for RFIC1 */
	u8	thermal_value;
	u8	thermal_value_path[MAX_RF_PATH];
	u8	thermal_value_lck;
	u8	thermal_value_iqk;
	u8	thermal_value_dpk;
	s8	thermal_value_delta; /* delta of thermal_value and efuse thermal */
	u8	thermal_value_avg[AVG_THERMAL_NUM];
	u8	thermal_value_avg_path[MAX_RF_PATH][AVG_THERMAL_NUM];
	u8	thermal_value_avg_index;
	u8	thermal_value_avg_index_path[MAX_RF_PATH];
	u8	thermal_value_rx_gain;
	u8	thermal_value_avg_pwrtrk[MAX_RF_PATH];


	boolean	is_reloadtxpowerindex;
	u8	is_rf_pi_enable;
	u32 	txpowertracking_callback_cnt; /* cosa add for debug */


	/* ------------------------- Tx power Tracking ------------------------- */
	u8	is_cck_in_ch14;
	u8	CCK_index;
	u8	OFDM_index[MAX_RF_PATH];
	s8	power_index_offset[MAX_RF_PATH];
	s8	delta_power_index[MAX_RF_PATH];
	s8	delta_power_index_last[MAX_RF_PATH];
	boolean is_tx_power_changed;
	s8	xtal_offset;
	s8	xtal_offset_last;

	struct iqk_matrix_regs_setting iqk_matrix_reg_setting[IQK_MATRIX_SETTINGS_NUM];
	u8	delta_lck;
	s8  bb_swing_diff_2g, bb_swing_diff_5g; /* Unit: dB */
	u8  delta_swing_table_idx_2g_cck_a_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_a_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_b_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_b_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_c_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_c_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_d_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2g_cck_d_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2ga_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2ga_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2gb_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2gb_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2gc_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2gc_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2gd_p[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2gd_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5ga_p[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5ga_n[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5gb_p[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5gb_n[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5gc_p[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5gc_n[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5gd_p[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_5gd_n[BAND_NUM][DELTA_SWINGIDX_SIZE];
	u8  delta_swing_tssi_table_2g_cck_a[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2g_cck_b[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2g_cck_c[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2g_cck_d[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2ga[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2gb[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2gc[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_2gd[DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_5ga[BAND_NUM][DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_5gb[BAND_NUM][DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_5gc[BAND_NUM][DELTA_SWINTSSI_SIZE];
	u8  delta_swing_tssi_table_5gd[BAND_NUM][DELTA_SWINTSSI_SIZE];
	s8  delta_swing_table_xtal_p[DELTA_SWINGIDX_SIZE];
	s8  delta_swing_table_xtal_n[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2ga_p_8188e[DELTA_SWINGIDX_SIZE];
	u8  delta_swing_table_idx_2ga_n_8188e[DELTA_SWINGIDX_SIZE];

	u8			bb_swing_idx_ofdm[MAX_RF_PATH];
	u8			bb_swing_idx_ofdm_current;
#if (DM_ODM_SUPPORT_TYPE & (ODM_WIN | ODM_CE))
	u8			bb_swing_idx_ofdm_base[MAX_RF_PATH];
#else
	u8			bb_swing_idx_ofdm_base;
#endif
	boolean		default_bb_swing_index_flag;
	boolean			bb_swing_flag_ofdm;
	u8			bb_swing_idx_cck;
	u8			bb_swing_idx_cck_current;
	u8			bb_swing_idx_cck_base;
	u8			default_ofdm_index;
	u8			default_cck_index;
	s8			default_txagc_index;
	boolean			bb_swing_flag_cck;

	s8			absolute_ofdm_swing_idx[MAX_RF_PATH];
	s8			remnant_ofdm_swing_idx[MAX_RF_PATH];
	s8			absolute_cck_swing_idx[MAX_RF_PATH];
	s8			remnant_cck_swing_idx;
	s8			modify_tx_agc_value;       /*Remnat compensate value at tx_agc */
	boolean			modify_tx_agc_flag_path_a;
	boolean			modify_tx_agc_flag_path_b;
	boolean			modify_tx_agc_flag_path_c;
	boolean			modify_tx_agc_flag_path_d;
	boolean			modify_tx_agc_flag_path_a_cck;
	boolean			modify_tx_agc_flag_path_b_cck;

	s8			kfree_offset[MAX_RF_PATH];

	/* -------------------------------------------------------------------- */

	/* for IQK */
	u32	regc04;
	u32	reg874;
	u32	regc08;
	u32	regb68;
	u32	regb6c;
	u32	reg870;
	u32	reg860;
	u32	reg864;

	boolean	is_iqk_initialized;
	boolean is_lck_in_progress;
	boolean	is_antenna_detected;
	boolean	is_need_iqk;
	boolean	is_iqk_in_progress;
	boolean	is_iqk_pa_off;
	u8	delta_iqk;
	u32	ADDA_backup[IQK_ADDA_REG_NUM];
	u32	IQK_MAC_backup[IQK_MAC_REG_NUM];
	u32	IQK_BB_backup_recover[9];
	u32	IQK_BB_backup[IQK_BB_REG_NUM];
	u32	tx_iqc_8723b[2][3][2]; /* { {S1: 0xc94, 0xc80, 0xc4c} , {S0: 0xc9c, 0xc88, 0xc4c}} */
	u32	rx_iqc_8723b[2][2][2]; /* { {S1: 0xc14, 0xca0} ,           {S0: 0xc14, 0xca0}} */
	u32	tx_iqc_8703b[3][2];	/* { {S1: 0xc94, 0xc80, 0xc4c} , {S0: 0xc9c, 0xc88, 0xc4c}}*/
	u32	rx_iqc_8703b[2][2];	/* { {S1: 0xc14, 0xca0} ,           {S0: 0xc14, 0xca0}}*/
	u32	tx_iqc_8723d[2][3][2];	/* { {S1: 0xc94, 0xc80, 0xc4c} , {S0: 0xc9c, 0xc88, 0xc4c}}*/
	u32	rx_iqc_8723d[2][2][2];	/* { {S1: 0xc14, 0xca0} ,           {S0: 0xc14, 0xca0}}*/
	/* JJ ADD 20161014 */
	u32	tx_iqc_8710b[2][3][2];	/* { {S1: 0xc94, 0xc80, 0xc4c} , {S0: 0xc9c, 0xc88, 0xc4c}}*/
	u32	rx_iqc_8710b[2][2][2];	/* { {S1: 0xc14, 0xca0} ,           {S0: 0xc14, 0xca0}}*/

	u64	iqk_start_time;
	u64	iqk_total_progressing_time;
	u64	iqk_progressing_time;
	u64	lck_progressing_time;
	u32  lok_result;
	u8	iqk_step;
	u8	kcount;
	u8	retry_count[4][2]; /* [4]: path ABCD, [2] TXK, RXK */
	boolean	is_mp_mode;

	/* for APK */
	u32 	ap_koutput[2][2]; /* path A/B; output1_1a/output1_2a */
	u8	is_ap_kdone;
	u8	is_apk_thermal_meter_ignore;

	/* DPK */
	boolean is_dpk_fail;
	u8	is_dp_done;
	u8	is_dp_path_aok;
	u8	is_dp_path_bok;

	u32	tx_lok[2];
	u32  dpk_tx_agc;
	s32  dpk_gain;
	u32  dpk_thermal[4];

	s8 modify_tx_agc_value_ofdm;
	s8 modify_tx_agc_value_cck;

	/*Add by Yuchen for Kfree Phydm*/
	u8	reg_rf_kfree_enable;	/*for registry*/
	u8	rf_kfree_enable;	/*for efuse enable check*/
	u8	thermal_lck[MAX_RF_PATH];
	u8	thermal_lck_avg[MAX_RF_PATH][AVG_THERMAL_NUM_LCK];
	u8	thermal_lck_avg_index;
};




#endif	/*#ifndef __HALRF_POWER_TRACKING_H__*/
