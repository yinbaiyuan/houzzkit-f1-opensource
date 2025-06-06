// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2024 Rockchip Electronics Co., Ltd.
 *
 * lt6911c HDMI to MIPI CSI-2 bridge driver.
 *
 * Author: Jianwei Fan <jianwei.fan@rock-chips.com>
 *
 * V0.0X01.0X00 first version.
 *
 */

#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/gpio/consumer.h>
#include <linux/hdmi.h>
#include <linux/i2c.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/of_graph.h>
#include <linux/rk-camera-module.h>
#include <linux/slab.h>
#include <linux/timer.h>
#include <linux/v4l2-dv-timings.h>
#include <linux/version.h>
#include <linux/videodev2.h>
#include <linux/workqueue.h>
#include <linux/compat.h>
#include <media/v4l2-controls_rockchip.h>
#include <media/v4l2-ctrls.h>
#include <media/v4l2-device.h>
#include <media/v4l2-dv-timings.h>
#include <media/v4l2-event.h>
#include <media/v4l2-fwnode.h>

#define DRIVER_VERSION			KERNEL_VERSION(0, 0x01, 0x00)

static int debug;
module_param(debug, int, 0644);
MODULE_PARM_DESC(debug, "debug level (0-3)");

#define I2C_MAX_XFER_SIZE	128
#define POLL_INTERVAL_MS	1000

#define LT6911C_LINK_FREQ	400000000
#define LT6911C_PIXEL_RATE	400000000

#define LT6911C_CHIPID	0x0516
#define CHIPID_REGH	0xA001
#define CHIPID_REGL	0xA000
#define I2C_EN_REG	0x80EE
#define I2C_ENABLE	0x1
#define I2C_DISABLE	0x0

#define AD_HALF_PIX_CLK         0x21
#define SOURCE_DP_RX            0x10
#define RECEIVED_INT		1

#define HTOTAL_H		0xd289
#define HTOTAL_L		0xd28a
#define HACT_H			0xd28b
#define HACT_L			0xd28c
#define HFP_H			0xd29c
#define HFP_L			0xd29d
#define HS_H			0xd294
#define HS_L			0xd295
#define HBP_H			0xd298
#define HBP_L			0xd299

#define VTOTAL_H		0xd29e
#define VTOTAL_L		0xd29f
#define VACT_H			0xd296
#define VACT_L			0xd297
#define VBP			0xd287
#define VFP			0xd288
#define VS			0xd286

#define FM_CLK_SEL              0xa034
#define FREQ_METER_H		0xb8b1
#define FREQ_METER_M		0xb8b2
#define FREQ_METER_L		0xb8b3
#define RG_MK_PRESET_SEL        0xd283

#define STREAM_CTL		0x900a
#define ENABLE_STREAM		0xbf
#define DISABLE_STREAM		0xbe

#define LT6911C_NAME			"LT6911C"

static const s64 link_freq_menu_items[] = {
	LT6911C_LINK_FREQ,
};

struct lt6911c_state {
	struct v4l2_mbus_config_mipi_csi2 bus;
	struct v4l2_subdev sd;
	struct media_pad pad;
	struct v4l2_ctrl_handler hdl;
	struct i2c_client *i2c_client;
	struct mutex confctl_mutex;
	struct v4l2_ctrl *detect_tx_5v_ctrl;
	struct v4l2_ctrl *audio_sampling_rate_ctrl;
	struct v4l2_ctrl *audio_present_ctrl;
	struct v4l2_ctrl *link_freq;
	struct v4l2_ctrl *pixel_rate;
	struct delayed_work delayed_work_enable_hotplug;
	struct delayed_work delayed_work_res_change;
	struct v4l2_dv_timings timings;
	struct clk *xvclk;
	struct gpio_desc *reset_gpio;
	struct gpio_desc *plugin_det_gpio;
	struct gpio_desc *hpd_ctl_gpio;
	struct gpio_desc *power_gpio;
	struct work_struct work_i2c_poll;
	struct timer_list timer;
	const char *module_facing;
	const char *module_name;
	const char *len_name;
	const struct lt6911c_mode *cur_mode;
	bool nosignal;
	bool enable_hdcp;
	bool is_audio_present;
	int plugin_irq;
	u32 mbus_fmt_code;
	u8 csi_lanes_in_use;
	u32 module_index;
	u32 audio_sampling_rate;
};

static const struct v4l2_dv_timings_cap lt6911c_timings_cap = {
	.type = V4L2_DV_BT_656_1120,
	.reserved = { 0 },
	V4L2_INIT_BT_TIMINGS(1, 10000, 1, 10000, 0, 400000000,
			V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
			V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_INTERLACED |
			V4L2_DV_BT_CAP_REDUCED_BLANKING |
			V4L2_DV_BT_CAP_CUSTOM)
};

struct lt6911c_mode {
	u32 width;
	u32 height;
	struct v4l2_fract max_fps;
	u32 hts_def;
	u32 vts_def;
	u32 exp_def;
};

static const struct lt6911c_mode supported_modes[] = {
	{
		.width = 1920,
		.height = 1080,
		.max_fps = {
			.numerator = 10000,
			.denominator = 600000,
		},
		.hts_def = 2200,
		.vts_def = 1125,
	}, {
		.width = 1280,
		.height = 720,
		.max_fps = {
			.numerator = 10000,
			.denominator = 600000,
		},
		.hts_def = 1650,
		.vts_def = 750,
	}, {
		.width = 720,
		.height = 576,
		.max_fps = {
			.numerator = 10000,
			.denominator = 500000,
		},
		.hts_def = 864,
		.vts_def = 625,
	}, {
		.width = 720,
		.height = 480,
		.max_fps = {
			.numerator = 10000,
			.denominator = 600000,
		},
		.hts_def = 858,
		.vts_def = 525,
	},
};

static void lt6911c_format_change(struct v4l2_subdev *sd);
static int lt6911c_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd);
static int lt6911c_s_dv_timings(struct v4l2_subdev *sd,
				struct v4l2_dv_timings *timings);

static inline struct lt6911c_state *to_state(struct v4l2_subdev *sd)
{
	return container_of(sd, struct lt6911c_state, sd);
}

static void i2c_rd(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	struct i2c_client *client = lt6911c->i2c_client;
	int err;
	u8 buf[2] = { 0xFF, reg >> 8};
	u8 reg_addr = reg & 0xFF;
	struct i2c_msg msgs[3];

	msgs[0].addr = client->addr;
	msgs[0].flags = 0;
	msgs[0].len = 2;
	msgs[0].buf = buf;

	msgs[1].addr = client->addr;
	msgs[1].flags = 0;
	msgs[1].len = 1;
	msgs[1].buf = &reg_addr;

	msgs[2].addr = client->addr;
	msgs[2].flags = I2C_M_RD;
	msgs[2].len = n;
	msgs[2].buf = values;

	err = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
	if (err != ARRAY_SIZE(msgs)) {
		v4l2_err(sd, "%s: reading register 0x%x from 0x%x failed\n",
				__func__, reg, client->addr);
	}

	if (!debug)
		return;

	switch (n) {
	case 1:
		v4l2_info(sd, "I2C read 0x%04x = 0x%02x\n",
			reg, values[0]);
		break;
	case 2:
		v4l2_info(sd, "I2C read 0x%04x = 0x%02x%02x\n",
			reg, values[1], values[0]);
		break;
	case 4:
		v4l2_info(sd, "I2C read 0x%04x = 0x%02x%02x%02x%02x\n",
			reg, values[3], values[2], values[1], values[0]);
		break;
	default:
		v4l2_info(sd, "I2C read %d bytes from address 0x%04x\n",
			n, reg);
	}
}

static void i2c_wr(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	struct i2c_client *client = lt6911c->i2c_client;
	int err, i;
	struct i2c_msg msgs[2];
	u8 data[I2C_MAX_XFER_SIZE];
	u8 buf[2] = { 0xFF, reg >> 8};

	if ((1 + n) > I2C_MAX_XFER_SIZE) {
		n = I2C_MAX_XFER_SIZE - 1;
		v4l2_warn(sd, "i2c wr reg=%04x: len=%d is too big!\n",
			  reg, 1 + n);
	}

	msgs[0].addr = client->addr;
	msgs[0].flags = 0;
	msgs[0].len = 2;
	msgs[0].buf = buf;

	msgs[1].addr = client->addr;
	msgs[1].flags = 0;
	msgs[1].len = 1 + n;
	msgs[1].buf = data;

	data[0] = reg & 0xff;
	for (i = 0; i < n; i++)
		data[1 + i] = values[i];

	err = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
	if (err < 0) {
		v4l2_err(sd, "%s: writing register 0x%x from 0x%x failed\n",
				__func__, reg, client->addr);
		return;
	}

	if (!debug)
		return;

	switch (n) {
	case 1:
		v4l2_info(sd, "I2C write 0x%04x = 0x%02x\n",
				reg, data[1]);
		break;
	case 2:
		v4l2_info(sd, "I2C write 0x%04x = 0x%02x%02x\n",
				reg, data[2], data[1]);
		break;
	case 4:
		v4l2_info(sd, "I2C write 0x%04x = 0x%02x%02x%02x%02x\n",
				reg, data[4], data[3], data[2], data[1]);
		break;
	default:
		v4l2_info(sd, "I2C write %d bytes from address 0x%04x\n",
				n, reg);
	}
}

static u8 i2c_rd8(struct v4l2_subdev *sd, u16 reg)
{
	u32 val;

	i2c_rd(sd, reg, (u8 __force *)&val, 1);
	return val;
}

static void i2c_wr8(struct v4l2_subdev *sd, u16 reg, u8 val)
{
	i2c_wr(sd, reg, &val, 1);
}

static void lt6911c_i2c_enable(struct v4l2_subdev *sd)
{
	i2c_wr8(sd, I2C_EN_REG, I2C_ENABLE);
}

static void lt6911c_i2c_disable(struct v4l2_subdev *sd)
{
	i2c_wr8(sd, I2C_EN_REG, I2C_DISABLE);
}

static inline bool tx_5v_power_present(struct v4l2_subdev *sd)
{
	bool ret;
	int val, i, cnt;
	struct lt6911c_state *lt6911c = to_state(sd);

	/* if not use plugin det gpio */
	if (!lt6911c->plugin_det_gpio)
		return true;

	cnt = 0;
	for (i = 0; i < 5; i++) {
		val = gpiod_get_value(lt6911c->plugin_det_gpio);
		if (val > 0)
			cnt++;
		usleep_range(500, 600);
	}

	ret = (cnt >= 3) ? true : false;
	v4l2_dbg(1, debug, sd, "%s: %d\n", __func__, ret);

	return ret;
}

static inline bool no_signal(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	v4l2_dbg(1, debug, sd, "%s no signal:%d\n", __func__,
			lt6911c->nosignal);

	return lt6911c->nosignal;
}

static inline bool audio_present(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	return lt6911c->is_audio_present;
}

static int get_audio_sampling_rate(struct v4l2_subdev *sd)
{
	static const int code_to_rate[] = {
		44100, 0, 48000, 32000, 22050, 384000, 24000, 352800,
		88200, 768000, 96000, 705600, 176400, 0, 192000, 0
	};

	if (no_signal(sd))
		return 0;

	return code_to_rate[2];
}

static inline unsigned int fps_calc(const struct v4l2_bt_timings *t)
{
	if (!V4L2_DV_BT_FRAME_HEIGHT(t) || !V4L2_DV_BT_FRAME_WIDTH(t))
		return 0;

	return DIV_ROUND_CLOSEST((unsigned int)t->pixelclock,
			V4L2_DV_BT_FRAME_HEIGHT(t) * V4L2_DV_BT_FRAME_WIDTH(t));
}

static bool lt6911c_rcv_supported_res(struct v4l2_subdev *sd, u32 width,
		u32 height)
{
	u32 i;

	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
		if ((supported_modes[i].width == width) &&
		    (supported_modes[i].height == height)) {
			break;
		}
	}

	if (i == ARRAY_SIZE(supported_modes)) {
		v4l2_err(sd, "%s do not support res wxh: %dx%d\n", __func__,
				width, height);
		return false;
	} else {
		return true;
	}
}

static int lt6911c_get_detected_timings(struct v4l2_subdev *sd,
				     struct v4l2_dv_timings *timings)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	struct v4l2_bt_timings *bt = &timings->bt;
	u32 hact, vact, htotal, vtotal;
	u32 hbp, hs, hfp, vbp, vs, vfp;
	u32 pixel_clock, fps, halt_pix_clk;
	u8 clk_h, clk_m, clk_l;
	u8 value, val_h, val_l;

	memset(timings, 0, sizeof(struct v4l2_dv_timings));

	lt6911c_i2c_enable(sd);
	i2c_wr8(sd, FM_CLK_SEL, AD_HALF_PIX_CLK);
	mdelay(10);
	clk_h = i2c_rd8(sd, FREQ_METER_H);
	clk_m = i2c_rd8(sd, FREQ_METER_M);
	clk_l = i2c_rd8(sd, FREQ_METER_L);
	halt_pix_clk = (((clk_h & 0xf) << 16) | (clk_m << 8) | clk_l);
	pixel_clock = halt_pix_clk * 2 * 1000;

	i2c_wr8(sd, RG_MK_PRESET_SEL, SOURCE_DP_RX);
	mdelay(10);
	val_h = i2c_rd8(sd, HTOTAL_H);
	val_l = i2c_rd8(sd, HTOTAL_L);
	htotal = ((val_h << 8) | val_l) * 2;
	val_h = i2c_rd8(sd, VTOTAL_H);
	val_l = i2c_rd8(sd, VTOTAL_L);
	vtotal = (val_h << 8) | val_l;
	val_h = i2c_rd8(sd, HACT_H);
	val_l = i2c_rd8(sd, HACT_L);
	hact = ((val_h << 8) | val_l) * 2;
	val_h = i2c_rd8(sd, VACT_H);
	val_l = i2c_rd8(sd, VACT_L);
	vact = (val_h << 8) | val_l;
	val_h = i2c_rd8(sd, HS_H);
	val_l = i2c_rd8(sd, HS_L);
	hs = ((val_h << 8) | val_l) * 2;
	value = i2c_rd8(sd, VS);
	vs = value;
	val_h = i2c_rd8(sd, HFP_H);
	val_l = i2c_rd8(sd, HFP_L);
	hfp = ((val_h << 8) | val_l) * 2;
	value = i2c_rd8(sd, VFP);
	vfp = value;
	val_h = i2c_rd8(sd, HBP_H);
	val_l = i2c_rd8(sd, HBP_L);
	hbp = ((val_h << 8) | val_l) * 2;
	value = i2c_rd8(sd, VBP);
	vbp = value;

	lt6911c_i2c_disable(sd);

	if (!lt6911c_rcv_supported_res(sd, hact, vact)) {
		lt6911c->nosignal = true;
		v4l2_err(sd, "%s: rcv err res, return no signal!\n", __func__);
		return -EINVAL;
	}

	lt6911c->nosignal = false;
	lt6911c->is_audio_present = true;
	timings->type = V4L2_DV_BT_656_1120;
	bt->interlaced = V4L2_DV_PROGRESSIVE;
	bt->width = hact;
	bt->height = vact;
	bt->vsync = vs;
	bt->hsync = hs;
	bt->pixelclock = pixel_clock;
	bt->hfrontporch = hfp;
	bt->vfrontporch = vfp;
	bt->hbackporch = hbp;
	bt->vbackporch = vbp;
	fps = fps_calc(bt);

	v4l2_info(sd, "act:%dx%d, total:%dx%d, pixclk:%d, fps:%d\n",
			hact, vact, htotal, vtotal, pixel_clock, fps);
	v4l2_info(sd, "hfp:%d, hs:%d, hbp:%d, vfp:%d, vs:%d, vbp:%d\n",
			bt->hfrontporch, bt->hsync, bt->hbackporch,
			bt->vfrontporch, bt->vsync, bt->vbackporch);
	v4l2_info(sd, "inerlaced:%d,\n", bt->interlaced);

	return 0;
}

static void lt6911c_config_hpd(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	bool plugin;

	plugin = tx_5v_power_present(sd);
	v4l2_dbg(2, debug, sd, "%s: plugin: %d\n", __func__, plugin);

	if (plugin) {
		gpiod_set_value(lt6911c->hpd_ctl_gpio, 1);
	} else {
		lt6911c->nosignal = true;
		gpiod_set_value(lt6911c->hpd_ctl_gpio, 0);
	}
}

static void lt6911c_delayed_work_enable_hotplug(struct work_struct *work)
{
	struct delayed_work *dwork = to_delayed_work(work);
	struct lt6911c_state *lt6911c = container_of(dwork,
			struct lt6911c_state, delayed_work_enable_hotplug);
	struct v4l2_subdev *sd = &lt6911c->sd;

	lt6911c_s_ctrl_detect_tx_5v(sd);
}

static void lt6911c_delayed_work_res_change(struct work_struct *work)
{
	struct delayed_work *dwork = to_delayed_work(work);
	struct lt6911c_state *lt6911c = container_of(dwork,
			struct lt6911c_state, delayed_work_res_change);
	struct v4l2_subdev *sd = &lt6911c->sd;

	lt6911c_format_change(sd);
}

static int lt6911c_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	return v4l2_ctrl_s_ctrl(lt6911c->detect_tx_5v_ctrl,
			tx_5v_power_present(sd));
}

static int lt6911c_s_ctrl_audio_sampling_rate(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	return v4l2_ctrl_s_ctrl(lt6911c->audio_sampling_rate_ctrl,
			get_audio_sampling_rate(sd));
}

static int lt6911c_s_ctrl_audio_present(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	return v4l2_ctrl_s_ctrl(lt6911c->audio_present_ctrl,
			audio_present(sd));
}

static int lt6911c_update_controls(struct v4l2_subdev *sd)
{
	int ret = 0;

	ret |= lt6911c_s_ctrl_detect_tx_5v(sd);
	ret |= lt6911c_s_ctrl_audio_sampling_rate(sd);
	ret |= lt6911c_s_ctrl_audio_present(sd);

	return ret;
}

static inline void enable_stream(struct v4l2_subdev *sd, bool enable)
{
	v4l2_dbg(2, debug, sd, "%s: %sable\n",
			__func__, enable ? "en" : "dis");
}

static void lt6911c_format_change(struct v4l2_subdev *sd)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	struct v4l2_dv_timings timings;
	const struct v4l2_event lt6911c_ev_fmt = {
		.type = V4L2_EVENT_SOURCE_CHANGE,
		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
	};

	if (lt6911c_get_detected_timings(sd, &timings)) {
		enable_stream(sd, false);

		v4l2_dbg(1, debug, sd, "%s: No signal\n", __func__);
	} else {
		if (!v4l2_match_dv_timings(&lt6911c->timings, &timings, 0, false)) {
			enable_stream(sd, false);
			/* automatically set timing rather than set by user */
			lt6911c_s_dv_timings(sd, &timings);
			v4l2_print_dv_timings(sd->name,
					"Format_change: New format: ",
					&timings, false);
		}
	}

	if (sd->devnode)
		v4l2_subdev_notify_event(sd, &lt6911c_ev_fmt);
}

static int lt6911c_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	schedule_delayed_work(&lt6911c->delayed_work_res_change, HZ / 20);
	*handled = true;

	return 0;
}

static irqreturn_t lt6911c_res_change_irq_handler(int irq, void *dev_id)
{
	struct lt6911c_state *lt6911c = dev_id;
	bool handled;

	lt6911c_isr(&lt6911c->sd, 0, &handled);

	return handled ? IRQ_HANDLED : IRQ_NONE;
}

static irqreturn_t plugin_detect_irq_handler(int irq, void *dev_id)
{
	struct lt6911c_state *lt6911c = dev_id;
	struct v4l2_subdev *sd = &lt6911c->sd;

	/* control hpd output level after 25ms */
	schedule_delayed_work(&lt6911c->delayed_work_enable_hotplug,
			HZ / 40);
	tx_5v_power_present(sd);

	return IRQ_HANDLED;
}

static void lt6911c_irq_poll_timer(struct timer_list *t)
{
	struct lt6911c_state *lt6911c = from_timer(lt6911c, t, timer);

	schedule_work(&lt6911c->work_i2c_poll);
	mod_timer(&lt6911c->timer, jiffies + msecs_to_jiffies(POLL_INTERVAL_MS));
}

static void lt6911c_work_i2c_poll(struct work_struct *work)
{
	struct lt6911c_state *lt6911c = container_of(work,
			struct lt6911c_state, work_i2c_poll);
	struct v4l2_subdev *sd = &lt6911c->sd;

	lt6911c_format_change(sd);
}

static int lt6911c_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
				    struct v4l2_event_subscription *sub)
{
	switch (sub->type) {
	case V4L2_EVENT_SOURCE_CHANGE:
		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
	case V4L2_EVENT_CTRL:
		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
	default:
		return -EINVAL;
	}
}

static int lt6911c_g_input_status(struct v4l2_subdev *sd, u32 *status)
{
	*status = 0;
	*status |= no_signal(sd) ? V4L2_IN_ST_NO_SIGNAL : 0;

	v4l2_dbg(1, debug, sd, "%s: status = 0x%x\n", __func__, *status);

	return 0;
}

static int lt6911c_s_dv_timings(struct v4l2_subdev *sd,
				 struct v4l2_dv_timings *timings)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	if (!timings)
		return -EINVAL;

	if (debug)
		v4l2_print_dv_timings(sd->name, "s_dv_timings: ",
				timings, false);

	if (v4l2_match_dv_timings(&lt6911c->timings, timings, 0, false)) {
		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
		return 0;
	}

	if (!v4l2_valid_dv_timings(timings,
				&lt6911c_timings_cap, NULL, NULL)) {
		v4l2_dbg(1, debug, sd, "%s: timings out of range\n", __func__);
		return -ERANGE;
	}

	lt6911c->timings = *timings;

	enable_stream(sd, false);

	return 0;
}

static int lt6911c_g_dv_timings(struct v4l2_subdev *sd,
				struct v4l2_dv_timings *timings)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	*timings = lt6911c->timings;

	return 0;
}

static int lt6911c_enum_dv_timings(struct v4l2_subdev *sd,
				struct v4l2_enum_dv_timings *timings)
{
	if (timings->pad != 0)
		return -EINVAL;

	return v4l2_enum_dv_timings_cap(timings,
			&lt6911c_timings_cap, NULL, NULL);
}

static int lt6911c_query_dv_timings(struct v4l2_subdev *sd,
				struct v4l2_dv_timings *timings)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	*timings = lt6911c->timings;
	if (debug)
		v4l2_print_dv_timings(sd->name,
				"query_dv_timings: ", timings, false);

	if (!v4l2_valid_dv_timings(timings, &lt6911c_timings_cap, NULL,
				NULL)) {
		v4l2_dbg(1, debug, sd, "%s: timings out of range\n",
				__func__);

		return -ERANGE;
	}

	return 0;
}

static int lt6911c_dv_timings_cap(struct v4l2_subdev *sd,
				struct v4l2_dv_timings_cap *cap)
{
	if (cap->pad != 0)
		return -EINVAL;

	*cap = lt6911c_timings_cap;

	return 0;
}

static int lt6911c_g_mbus_config(struct v4l2_subdev *sd,
			unsigned int pad, struct v4l2_mbus_config *cfg)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	cfg->type = V4L2_MBUS_CSI2_DPHY;
	cfg->bus.mipi_csi2 = lt6911c->bus;

	return 0;
}

static int lt6911c_s_stream(struct v4l2_subdev *sd, int enable)
{
	enable_stream(sd, enable);

	return 0;
}

static int lt6911c_enum_mbus_code(struct v4l2_subdev *sd,
			struct v4l2_subdev_state *sd_state,
			struct v4l2_subdev_mbus_code_enum *code)
{
	switch (code->index) {
	case 0:
		code->code = MEDIA_BUS_FMT_UYVY8_2X8;
		break;

	default:
		return -EINVAL;
	}

	return 0;
}

static int lt6911c_enum_frame_sizes(struct v4l2_subdev *sd,
				   struct v4l2_subdev_state *sd_state,
				   struct v4l2_subdev_frame_size_enum *fse)
{
	if (fse->index >= ARRAY_SIZE(supported_modes))
		return -EINVAL;

	if (fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
		return -EINVAL;

	fse->min_width  = supported_modes[fse->index].width;
	fse->max_width  = supported_modes[fse->index].width;
	fse->max_height = supported_modes[fse->index].height;
	fse->min_height = supported_modes[fse->index].height;

	return 0;
}

static int lt6911c_get_fmt(struct v4l2_subdev *sd,
			struct v4l2_subdev_state *sd_state,
			struct v4l2_subdev_format *format)
{
	struct lt6911c_state *lt6911c = to_state(sd);

	mutex_lock(&lt6911c->confctl_mutex);
	format->format.code = lt6911c->mbus_fmt_code;
	format->format.width = lt6911c->timings.bt.width;
	format->format.height = lt6911c->timings.bt.height;
	format->format.field =
		lt6911c->timings.bt.interlaced ?
		V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE;
	format->format.colorspace = V4L2_COLORSPACE_SRGB;
	mutex_unlock(&lt6911c->confctl_mutex);

	v4l2_dbg(1, debug, sd, "%s: fmt code:%d, w:%d, h:%d, field code:%d\n",
			__func__, format->format.code, format->format.width,
			format->format.height, format->format.field);

	return 0;
}

static int lt6911c_enum_frame_interval(struct v4l2_subdev *sd,
				struct v4l2_subdev_state *sd_state,
				struct v4l2_subdev_frame_interval_enum *fie)
{
	if (fie->index >= ARRAY_SIZE(supported_modes))
		return -EINVAL;

	if (fie->code != MEDIA_BUS_FMT_UYVY8_2X8)
		return -EINVAL;

	fie->width = supported_modes[fie->index].width;
	fie->height = supported_modes[fie->index].height;
	fie->interval = supported_modes[fie->index].max_fps;

	return 0;
}

static int lt6911c_get_reso_dist(const struct lt6911c_mode *mode,
				struct v4l2_mbus_framefmt *framefmt)
{
	return abs(mode->width - framefmt->width) +
		abs(mode->height - framefmt->height);
}

static const struct lt6911c_mode *
lt6911c_find_best_fit(struct v4l2_subdev_format *fmt)
{
	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
	int dist;
	int cur_best_fit = 0;
	int cur_best_fit_dist = -1;
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
		dist = lt6911c_get_reso_dist(&supported_modes[i], framefmt);
		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
			cur_best_fit_dist = dist;
			cur_best_fit = i;
		}
	}

	return &supported_modes[cur_best_fit];
}

static int lt6911c_set_fmt(struct v4l2_subdev *sd,
			struct v4l2_subdev_state *sd_state,
			struct v4l2_subdev_format *format)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	const struct lt6911c_mode *mode;

	/* is overwritten by get_fmt */
	u32 code = format->format.code;
	int ret = lt6911c_get_fmt(sd, sd_state, format);

	format->format.code = code;

	if (ret)
		return ret;

	switch (code) {
	case MEDIA_BUS_FMT_UYVY8_2X8:
		break;

	default:
		return -EINVAL;
	}

	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
		return 0;

	lt6911c->mbus_fmt_code = format->format.code;
	mode = lt6911c_find_best_fit(format);
	lt6911c->cur_mode = mode;
	enable_stream(sd, false);

	return 0;
}

static int lt6911c_g_frame_interval(struct v4l2_subdev *sd,
			struct v4l2_subdev_frame_interval *fi)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	const struct lt6911c_mode *mode = lt6911c->cur_mode;

	mutex_lock(&lt6911c->confctl_mutex);
	fi->interval = mode->max_fps;
	mutex_unlock(&lt6911c->confctl_mutex);

	return 0;
}

static void lt6911c_get_module_inf(struct lt6911c_state *lt6911c,
				  struct rkmodule_inf *inf)
{
	memset(inf, 0, sizeof(*inf));
	strscpy(inf->base.sensor, LT6911C_NAME, sizeof(inf->base.sensor));
	strscpy(inf->base.module, lt6911c->module_name, sizeof(inf->base.module));
	strscpy(inf->base.lens, lt6911c->len_name, sizeof(inf->base.lens));
}

static long lt6911c_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
{
	struct lt6911c_state *lt6911c = to_state(sd);
	long ret = 0;

	switch (cmd) {
	case RKMODULE_GET_MODULE_INFO:
		lt6911c_get_module_inf(lt6911c, (struct rkmodule_inf *)arg);
		break;
	case RKMODULE_GET_HDMI_MODE:
		*(int *)arg = RKMODULE_HDMIIN_MODE;
		break;
	default:
		ret = -ENOIOCTLCMD;
		break;
	}

	return ret;
}

#ifdef CONFIG_COMPAT
static long lt6911c_compat_ioctl32(struct v4l2_subdev *sd,
				  unsigned int cmd, unsigned long arg)
{
	void __user *up = compat_ptr(arg);
	struct rkmodule_inf *inf;
	long ret;
	int *seq;

	switch (cmd) {
	case RKMODULE_GET_MODULE_INFO:
		inf = kzalloc(sizeof(*inf), GFP_KERNEL);
		if (!inf) {
			ret = -ENOMEM;
			return ret;
		}

		ret = lt6911c_ioctl(sd, cmd, inf);
		if (!ret) {
			ret = copy_to_user(up, inf, sizeof(*inf));
			if (ret)
				ret = -EFAULT;
		}
		kfree(inf);
		break;
	case RKMODULE_GET_HDMI_MODE:
		seq = kzalloc(sizeof(*seq), GFP_KERNEL);
		if (!seq) {
			ret = -ENOMEM;
			return ret;
		}

		ret = lt6911c_ioctl(sd, cmd, seq);
		if (!ret) {
			ret = copy_to_user(up, seq, sizeof(*seq));
			if (ret)
				ret = -EFAULT;
		}
		kfree(seq);
		break;
	default:
		ret = -ENOIOCTLCMD;
		break;
	}

	return ret;
}
#endif

static const struct v4l2_subdev_core_ops lt6911c_core_ops = {
	.interrupt_service_routine = lt6911c_isr,
	.subscribe_event = lt6911c_subscribe_event,
	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
	.ioctl = lt6911c_ioctl,
#ifdef CONFIG_COMPAT
	.compat_ioctl32 = lt6911c_compat_ioctl32,
#endif
};

static const struct v4l2_subdev_video_ops lt6911c_video_ops = {
	.g_input_status = lt6911c_g_input_status,
	.s_dv_timings = lt6911c_s_dv_timings,
	.g_dv_timings = lt6911c_g_dv_timings,
	.query_dv_timings = lt6911c_query_dv_timings,
	.s_stream = lt6911c_s_stream,
	.g_frame_interval = lt6911c_g_frame_interval,
};

static const struct v4l2_subdev_pad_ops lt6911c_pad_ops = {
	.enum_mbus_code = lt6911c_enum_mbus_code,
	.enum_frame_size = lt6911c_enum_frame_sizes,
	.enum_frame_interval = lt6911c_enum_frame_interval,
	.set_fmt = lt6911c_set_fmt,
	.get_fmt = lt6911c_get_fmt,
	.enum_dv_timings = lt6911c_enum_dv_timings,
	.dv_timings_cap = lt6911c_dv_timings_cap,
	.get_mbus_config = lt6911c_g_mbus_config,
};

static const struct v4l2_subdev_ops lt6911c_ops = {
	.core = &lt6911c_core_ops,
	.video = &lt6911c_video_ops,
	.pad = &lt6911c_pad_ops,
};

static const struct v4l2_ctrl_config lt6911c_ctrl_audio_sampling_rate = {
	.id = RK_V4L2_CID_AUDIO_SAMPLING_RATE,
	.name = "Audio sampling rate",
	.type = V4L2_CTRL_TYPE_INTEGER,
	.min = 0,
	.max = 768000,
	.step = 1,
	.def = 0,
	.flags = V4L2_CTRL_FLAG_READ_ONLY,
};

static const struct v4l2_ctrl_config lt6911c_ctrl_audio_present = {
	.id = RK_V4L2_CID_AUDIO_PRESENT,
	.name = "Audio present",
	.type = V4L2_CTRL_TYPE_BOOLEAN,
	.min = 0,
	.max = 1,
	.step = 1,
	.def = 0,
	.flags = V4L2_CTRL_FLAG_READ_ONLY,
};

static void lt6911c_reset(struct lt6911c_state *lt6911c)
{
	gpiod_set_value(lt6911c->reset_gpio, 0);
	usleep_range(2000, 2100);
	gpiod_set_value(lt6911c->reset_gpio, 1);
	usleep_range(120*1000, 121*1000);
	gpiod_set_value(lt6911c->reset_gpio, 0);
	usleep_range(300*1000, 310*1000);
}

static int lt6911c_init_v4l2_ctrls(struct lt6911c_state *lt6911c)
{
	struct v4l2_subdev *sd;
	int ret;

	sd = &lt6911c->sd;
	ret = v4l2_ctrl_handler_init(&lt6911c->hdl, 5);
	if (ret)
		return ret;

	lt6911c->link_freq = v4l2_ctrl_new_int_menu(&lt6911c->hdl, NULL,
			V4L2_CID_LINK_FREQ,
			ARRAY_SIZE(link_freq_menu_items) - 1, 0,
			link_freq_menu_items);
	lt6911c->pixel_rate = v4l2_ctrl_new_std(&lt6911c->hdl, NULL,
			V4L2_CID_PIXEL_RATE,
			0, LT6911C_PIXEL_RATE, 1, LT6911C_PIXEL_RATE);

	lt6911c->detect_tx_5v_ctrl = v4l2_ctrl_new_std(&lt6911c->hdl,
			NULL, V4L2_CID_DV_RX_POWER_PRESENT,
			0, 1, 0, 0);

	lt6911c->audio_sampling_rate_ctrl =
		v4l2_ctrl_new_custom(&lt6911c->hdl,
				&lt6911c_ctrl_audio_sampling_rate, NULL);
	lt6911c->audio_present_ctrl = v4l2_ctrl_new_custom(&lt6911c->hdl,
			&lt6911c_ctrl_audio_present, NULL);

	sd->ctrl_handler = &lt6911c->hdl;
	if (lt6911c->hdl.error) {
		ret = lt6911c->hdl.error;
		v4l2_err(sd, "cfg v4l2 ctrls failed! ret:%d\n", ret);
		return ret;
	}

	__v4l2_ctrl_s_ctrl(lt6911c->link_freq, link_freq_menu_items[0]);
	__v4l2_ctrl_s_ctrl_int64(lt6911c->pixel_rate, LT6911C_PIXEL_RATE);

	if (lt6911c_update_controls(sd)) {
		ret = -ENODEV;
		v4l2_err(sd, "update v4l2 ctrls failed! ret:%d\n", ret);
		return ret;
	}

	return 0;
}

#ifdef CONFIG_OF
static int lt6911c_probe_of(struct lt6911c_state *lt6911c)
{
	struct device *dev = &lt6911c->i2c_client->dev;
	struct device_node *node = dev->of_node;
	struct v4l2_fwnode_endpoint endpoint = { .bus_type = 0 };
	struct device_node *ep;
	int ret;

	ret = of_property_read_u32(node, RKMODULE_CAMERA_MODULE_INDEX,
			&lt6911c->module_index);
	ret |= of_property_read_string(node, RKMODULE_CAMERA_MODULE_FACING,
			&lt6911c->module_facing);
	ret |= of_property_read_string(node, RKMODULE_CAMERA_MODULE_NAME,
			&lt6911c->module_name);
	ret |= of_property_read_string(node, RKMODULE_CAMERA_LENS_NAME,
			&lt6911c->len_name);
	if (ret) {
		dev_err(dev, "could not get module information!\n");
		return -EINVAL;
	}

	lt6911c->power_gpio = devm_gpiod_get_optional(dev, "power",
			GPIOD_OUT_LOW);
	if (IS_ERR(lt6911c->power_gpio)) {
		dev_err(dev, "failed to get power gpio\n");
		ret = PTR_ERR(lt6911c->power_gpio);
		return ret;
	}

	lt6911c->reset_gpio = devm_gpiod_get_optional(dev, "reset",
			GPIOD_OUT_HIGH);
	if (IS_ERR(lt6911c->reset_gpio)) {
		dev_err(dev, "failed to get reset gpio\n");
		ret = PTR_ERR(lt6911c->reset_gpio);
		return ret;
	}

	lt6911c->plugin_det_gpio = devm_gpiod_get_optional(dev, "plugin-det",
			GPIOD_IN);
	if (IS_ERR(lt6911c->plugin_det_gpio)) {
		dev_err(dev, "failed to get plugin det gpio\n");
		ret = PTR_ERR(lt6911c->plugin_det_gpio);
		return ret;
	}

	lt6911c->hpd_ctl_gpio = devm_gpiod_get_optional(dev, "hpd-ctl",
			GPIOD_OUT_HIGH);
	if (IS_ERR(lt6911c->hpd_ctl_gpio)) {
		dev_err(dev, "failed to get hpd ctl gpio\n");
		ret = PTR_ERR(lt6911c->hpd_ctl_gpio);
		return ret;
	}

	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
	if (!ep) {
		dev_err(dev, "missing endpoint node\n");
		return -EINVAL;
	}

	ret = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep), &endpoint);
	if (ret) {
		dev_err(dev, "failed to parse endpoint\n");
		goto put_node;
	}

	if (endpoint.bus_type != V4L2_MBUS_CSI2_DPHY ||
			endpoint.bus.mipi_csi2.num_data_lanes == 0) {
		dev_err(dev, "missing CSI-2 properties in endpoint\n");
		ret = -EINVAL;
		goto free_endpoint;
	}

	lt6911c->xvclk = devm_clk_get(dev, "xvclk");
	if (IS_ERR(lt6911c->xvclk)) {
		dev_err(dev, "failed to get xvclk\n");
		ret = -EINVAL;
		goto free_endpoint;
	}

	ret = clk_prepare_enable(lt6911c->xvclk);
	if (ret) {
		dev_err(dev, "Failed! to enable xvclk\n");
		goto free_endpoint;
	}

	lt6911c->csi_lanes_in_use = endpoint.bus.mipi_csi2.num_data_lanes;
	lt6911c->bus = endpoint.bus.mipi_csi2;
	lt6911c->enable_hdcp = false;

	gpiod_set_value(lt6911c->hpd_ctl_gpio, 0);
	gpiod_set_value(lt6911c->power_gpio, 1);
	lt6911c_reset(lt6911c);

	ret = 0;

free_endpoint:
	v4l2_fwnode_endpoint_free(&endpoint);
put_node:
	of_node_put(ep);
	return ret;
}
#else
static inline int lt6911c_probe_of(struct lt6911c_state *state)
{
	return -ENODEV;
}
#endif
static int lt6911c_check_chip_id(struct lt6911c_state *lt6911c)
{
	struct device *dev = &lt6911c->i2c_client->dev;
	struct v4l2_subdev *sd = &lt6911c->sd;
	u8 id_h, id_l;
	u32 chipid;
	int ret = 0;

	lt6911c_i2c_enable(sd);
	id_l  = i2c_rd8(sd, CHIPID_REGL);
	id_h  = i2c_rd8(sd, CHIPID_REGH);
	lt6911c_i2c_disable(sd);

	chipid = (id_h << 8) | id_l;
	if (chipid != LT6911C_CHIPID) {
		dev_err(dev, "chipid err, read:%#x, expect:%#x\n",
				chipid, LT6911C_CHIPID);
		return -EINVAL;
	}
	dev_info(dev, "check chipid ok, id:%#x", chipid);

	return ret;
}

static int lt6911c_probe(struct i2c_client *client,
			  const struct i2c_device_id *id)
{
	struct lt6911c_state *lt6911c;
	struct v4l2_subdev *sd;
	struct device *dev = &client->dev;
	char facing[2];
	int err;

	dev_info(dev, "driver version: %02x.%02x.%02x",
		DRIVER_VERSION >> 16,
		(DRIVER_VERSION & 0xff00) >> 8,
		DRIVER_VERSION & 0x00ff);

	lt6911c = devm_kzalloc(dev, sizeof(struct lt6911c_state), GFP_KERNEL);
	if (!lt6911c)
		return -ENOMEM;

	sd = &lt6911c->sd;
	lt6911c->i2c_client = client;
	lt6911c->cur_mode = &supported_modes[0];
	lt6911c->mbus_fmt_code = MEDIA_BUS_FMT_UYVY8_2X8;

	err = lt6911c_probe_of(lt6911c);
	if (err) {
		v4l2_err(sd, "lt6911c_parse_of failed! err:%d\n", err);
		return err;
	}

	err = lt6911c_check_chip_id(lt6911c);
	if (err < 0)
		return err;

	lt6911c_reset(lt6911c);

	mutex_init(&lt6911c->confctl_mutex);
	err = lt6911c_init_v4l2_ctrls(lt6911c);
	if (err)
		goto err_free_hdl;

	client->flags |= I2C_CLIENT_SCCB;
#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
	v4l2_i2c_subdev_init(sd, client, &lt6911c_ops);
	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
#endif

#if defined(CONFIG_MEDIA_CONTROLLER)
	lt6911c->pad.flags = MEDIA_PAD_FL_SOURCE;
	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
	err = media_entity_pads_init(&sd->entity, 1, &lt6911c->pad);
	if (err < 0) {
		v4l2_err(sd, "media entity init failed! err:%d\n", err);
		goto err_free_hdl;
	}
#endif
	memset(facing, 0, sizeof(facing));
	if (strcmp(lt6911c->module_facing, "back") == 0)
		facing[0] = 'b';
	else
		facing[0] = 'f';

	snprintf(sd->name, sizeof(sd->name), "m%02d_%s_%s %s",
		 lt6911c->module_index, facing,
		 LT6911C_NAME, dev_name(sd->dev));
	err = v4l2_async_register_subdev_sensor(sd);
	if (err < 0) {
		v4l2_err(sd, "v4l2 register subdev failed! err:%d\n", err);
		goto err_clean_entity;
	}

	INIT_DELAYED_WORK(&lt6911c->delayed_work_enable_hotplug,
			lt6911c_delayed_work_enable_hotplug);
	INIT_DELAYED_WORK(&lt6911c->delayed_work_res_change,
			lt6911c_delayed_work_res_change);

	if (lt6911c->i2c_client->irq) {
		v4l2_dbg(1, debug, sd, "cfg lt6911c irq!\n");
		err = devm_request_threaded_irq(dev,
				lt6911c->i2c_client->irq,
				NULL, lt6911c_res_change_irq_handler,
				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
				"lt6911c", lt6911c);
		if (err) {
			v4l2_err(sd, "request irq failed! err:%d\n", err);
			goto err_work_queues;
		}
	} else {
		v4l2_dbg(1, debug, sd, "no irq, cfg poll!\n");
		INIT_WORK(&lt6911c->work_i2c_poll, lt6911c_work_i2c_poll);
		timer_setup(&lt6911c->timer, lt6911c_irq_poll_timer, 0);
		lt6911c->timer.expires = jiffies +
				       msecs_to_jiffies(POLL_INTERVAL_MS);
		add_timer(&lt6911c->timer);
	}

	lt6911c->plugin_irq = gpiod_to_irq(lt6911c->plugin_det_gpio);
	if (lt6911c->plugin_irq < 0)
		dev_err(dev, "failed to get plugin det irq, maybe no use\n");

	err = devm_request_threaded_irq(dev, lt6911c->plugin_irq, NULL,
			plugin_detect_irq_handler, IRQF_TRIGGER_FALLING |
			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "lt6911c",
			lt6911c);
	if (err)
		dev_err(dev, "failed to register plugin det irq (%d), maybe no use\n", err);

	err = v4l2_ctrl_handler_setup(sd->ctrl_handler);
	if (err) {
		v4l2_err(sd, "v4l2 ctrl handler setup failed! err:%d\n", err);
		goto err_work_queues;
	}

	lt6911c_config_hpd(sd);
	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
			client->addr << 1, client->adapter->name);

	return 0;

err_work_queues:
	if (!lt6911c->i2c_client->irq)
		flush_work(&lt6911c->work_i2c_poll);
	cancel_delayed_work(&lt6911c->delayed_work_enable_hotplug);
	cancel_delayed_work(&lt6911c->delayed_work_res_change);
err_clean_entity:
#if defined(CONFIG_MEDIA_CONTROLLER)
	media_entity_cleanup(&sd->entity);
#endif
err_free_hdl:
	v4l2_ctrl_handler_free(&lt6911c->hdl);
	mutex_destroy(&lt6911c->confctl_mutex);
	return err;
}

static void lt6911c_remove(struct i2c_client *client)
{
	struct v4l2_subdev *sd = i2c_get_clientdata(client);
	struct lt6911c_state *lt6911c = to_state(sd);

	if (!lt6911c->i2c_client->irq) {
		del_timer_sync(&lt6911c->timer);
		flush_work(&lt6911c->work_i2c_poll);
	}
	cancel_delayed_work_sync(&lt6911c->delayed_work_enable_hotplug);
	cancel_delayed_work_sync(&lt6911c->delayed_work_res_change);
	v4l2_async_unregister_subdev(sd);
	v4l2_device_unregister_subdev(sd);
#if defined(CONFIG_MEDIA_CONTROLLER)
	media_entity_cleanup(&sd->entity);
#endif
	v4l2_ctrl_handler_free(&lt6911c->hdl);
	mutex_destroy(&lt6911c->confctl_mutex);
	clk_disable_unprepare(lt6911c->xvclk);
}

#if IS_ENABLED(CONFIG_OF)
static const struct of_device_id lt6911c_of_match[] = {
	{ .compatible = "lontium,lt6911c" },
	{},
};
MODULE_DEVICE_TABLE(of, lt6911c_of_match);
#endif

static struct i2c_driver lt6911c_driver = {
	.driver = {
		.name = LT6911C_NAME,
		.of_match_table = of_match_ptr(lt6911c_of_match),
	},
	.probe = lt6911c_probe,
	.remove = lt6911c_remove,
};

static int __init lt6911c_driver_init(void)
{
	return i2c_add_driver(&lt6911c_driver);
}

static void __exit lt6911c_driver_exit(void)
{
	i2c_del_driver(&lt6911c_driver);
}

device_initcall_sync(lt6911c_driver_init);
module_exit(lt6911c_driver_exit);

MODULE_DESCRIPTION("Lontium lt6911c HDMI to CSI-2 bridge driver");
MODULE_AUTHOR("Jianwei Fan <jianwei.fan@rock-chips.com>");
MODULE_LICENSE("GPL");
