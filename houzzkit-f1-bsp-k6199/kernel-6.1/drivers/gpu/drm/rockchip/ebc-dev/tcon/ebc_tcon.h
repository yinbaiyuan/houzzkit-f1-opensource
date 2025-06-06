// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020 Rockchip Electronics Co., Ltd.
 *
 * Author: Zorro Liu <zorro.liu@rock-chips.com>
 */

#ifndef _EBC_TCON_H_
#define _EBC_TCON_H_

#include "../ebc_panel.h"

/* update mode */
#define NORMAL_UPDATE	0
#define DIFF_UPDATE	1

/* display mode */
#define DIRECT_MODE	0
#define LUT_MODE	1
#define THREE_WIN_MODE	1
#define EINK_MODE	1

enum ebc_tcon_data_format {
	EBC_Y4_FORMAT = 0,
	EBC_Y8_FORMAT = 1,
	EBC_RGB565_FORMAT = 2,
	EBC_XBGR8888_FORMAT = 3,
	EBC_Y5_FORMAT = 4,
};

enum ebc_tcon_version {
	EBC_VERSION_RK3568 = 0,
	EBC_VERSION_RK3576 = 1,
};

struct ebc_tcon {
	struct device *dev;
	void __iomem *regs;
	unsigned int len;
	int irq;

	struct clk *aclk;
	struct clk *hclk;
	struct clk *dclk;
	struct regmap *regmap_base;

	struct ebc_panel *panel;
	int display_mode;
	u32 version;

	int (*enable)(struct ebc_tcon *tcon, struct ebc_panel *panel);
	void (*disable)(struct ebc_tcon *tcon);
	void (*dsp_mode_set)(struct ebc_tcon *tcon, int update_mode, int display_mode, int three_win_mode, int eink_mode);
	void (*image_addr_set)(struct ebc_tcon *tcon, u32 pre_image_addr, u32 cur_image_addr);
	void (*frame_addr_set)(struct ebc_tcon *tcon, u32 frame_addr);
	int (*lut_data_set)(struct ebc_tcon *tcon, unsigned int *lut_data, int frame_count, int lut_32);
	void (*data_format_set)(struct ebc_tcon *tcon, enum ebc_tcon_data_format format);
	void (*frame_start)(struct ebc_tcon *tcon, int frame_total);
	void (*dsp_end_callback)(void);
	void (*set_line_flag_event)(struct ebc_tcon *tcon, u32 line, bool enable);
	void (*line_flag_callback)(void);
};

static inline int ebc_tcon_enable(struct ebc_tcon *tcon, struct ebc_panel *panel)
{
	return tcon->enable(tcon, panel);
}

static inline void ebc_tcon_disable(struct ebc_tcon *tcon)
{
	tcon->disable(tcon);
}

static inline void ebc_tcon_dsp_mode_set(struct ebc_tcon *tcon, int update_mode,
					 int display_mode, int three_win_mode, int eink_mode)
{
	return tcon->dsp_mode_set(tcon, update_mode, display_mode, three_win_mode, eink_mode);
}

static inline void ebc_tcon_image_addr_set(struct ebc_tcon *tcon, u32 pre_image_addr, u32 cur_image_addr)
{
	tcon->image_addr_set(tcon, pre_image_addr, cur_image_addr);
}

static inline void ebc_tcon_frame_addr_set(struct ebc_tcon *tcon, u32 frame_addr)
{
	tcon->frame_addr_set(tcon, frame_addr);
}

static inline int ebc_tcon_lut_data_set(struct ebc_tcon *tcon, unsigned int *lut_data, int frame_count, int lut_32)
{
	return tcon->lut_data_set(tcon, lut_data, frame_count, lut_32);
}

static inline void ebc_tcon_frame_start(struct ebc_tcon *tcon, int frame_total)
{
	tcon->frame_start(tcon, frame_total);
}

static inline void ebc_tcon_data_format_set(struct ebc_tcon *tcon, enum ebc_tcon_data_format format)
{
	tcon->data_format_set(tcon, format);
}

static inline void ebc_tcon_set_line_flag_event(struct ebc_tcon *tcon, u32 line, bool enable)
{
	tcon->set_line_flag_event(tcon, line, enable);
}

struct eink_tcon {
	struct device *dev;
	void __iomem *regs;
	unsigned int len;
	int irq;

	struct clk *hclk;
	struct clk *pclk;
	struct regmap *regmap_base;

	int (*enable)(struct eink_tcon *tcon, struct ebc_panel *panel);
	void (*disable)(struct eink_tcon *tcon);
	void (*image_addr_set)(struct eink_tcon *tcon, u32 pre_image_buf_addr,
			       u32 cur_image_buf_addr, u32 image_process_buf_addr);
	void (*frame_start)(struct eink_tcon *tcon);

	void (*dsp_end_callback)(void);
};

static inline int eink_tcon_enable(struct eink_tcon *tcon, struct ebc_panel *panel)
{
	return tcon->enable(tcon, panel);
}

static inline void eink_tcon_disable(struct eink_tcon *tcon)
{
	tcon->disable(tcon);
}

static inline void eink_tcon_image_addr_set(struct eink_tcon *tcon, u32 pre_image_buf_addr,
					    u32 cur_image_buf_addr, u32 image_process_buf_addr)
{
	tcon->image_addr_set(tcon, pre_image_buf_addr, cur_image_buf_addr, image_process_buf_addr);
}

static inline void eink_tcon_frame_start(struct eink_tcon *tcon)
{
	tcon->frame_start(tcon);
}
#endif
