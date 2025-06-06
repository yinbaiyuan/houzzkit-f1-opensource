// SPDX-License-Identifier: GPL-2.0
/*
 * dw-hdmi-qp-i2s-audio.c
 *
 * Copyright (c) 2021 Rockchip Electronics Co., Ltd.
 * Author: Sugar Zhang <sugar.zhang@rock-chips.com>
 */

#include <linux/dma-mapping.h>
#include <linux/module.h>

#include <drm/bridge/dw_hdmi.h>
#include <drm/drm_crtc.h>

#include <sound/hdmi-codec.h>

#include "dw-hdmi-qp.h"
#include "dw-hdmi-qp-audio.h"

#define DRIVER_NAME "dw-hdmi-qp-i2s-audio"

static inline void hdmi_write(struct dw_hdmi_qp_i2s_audio_data *audio,
			      u32 val, int offset)
{
	struct dw_hdmi_qp *hdmi = audio->hdmi;

	audio->write(hdmi, val, offset);
}

static inline u32 hdmi_read(struct dw_hdmi_qp_i2s_audio_data *audio, int offset)
{
	struct dw_hdmi_qp *hdmi = audio->hdmi;

	return audio->read(hdmi, offset);
}

static inline void hdmi_mod(struct dw_hdmi_qp_i2s_audio_data *audio,
			    u32 data, u32 mask, u32 reg)
{
	struct dw_hdmi_qp *hdmi = audio->hdmi;

	return audio->mod(hdmi, data, mask, reg);
}

static int dw_hdmi_qp_i2s_hw_params(struct device *dev, void *data,
				    struct hdmi_codec_daifmt *fmt,
				    struct hdmi_codec_params *hparms)
{
	struct dw_hdmi_qp_i2s_audio_data *audio = data;
	struct dw_hdmi_qp *hdmi = audio->hdmi;
	bool ref2stream = false;

	if (fmt->bit_clk_provider | fmt->frame_clk_provider) {
		dev_err(dev, "unsupported clock settings\n");
		return -EINVAL;
	}

	if (fmt->bit_fmt == SNDRV_PCM_FORMAT_IEC958_SUBFRAME_LE)
		ref2stream = true;

	dw_hdmi_qp_set_audio_interface(hdmi, fmt, hparms);
	dw_hdmi_qp_set_sample_rate(hdmi, hparms->sample_rate);
	dw_hdmi_qp_set_channel_status(hdmi, hparms->iec.status, ref2stream);
	dw_hdmi_qp_set_channel_count(hdmi, hparms->channels);
	dw_hdmi_qp_set_channel_allocation(hdmi, hparms->cea.channel_allocation);
	dw_hdmi_qp_set_audio_infoframe(hdmi, hparms);

	return 0;
}

static int dw_hdmi_qp_i2s_audio_startup(struct device *dev, void *data)
{
	struct dw_hdmi_qp_i2s_audio_data *audio = data;
	struct dw_hdmi_qp *hdmi = audio->hdmi;

	dw_hdmi_qp_audio_enable(hdmi);

	return 0;
}

static void dw_hdmi_qp_i2s_audio_shutdown(struct device *dev, void *data)
{
	struct dw_hdmi_qp_i2s_audio_data *audio = data;
	struct dw_hdmi_qp *hdmi = audio->hdmi;

	dw_hdmi_qp_audio_disable(hdmi);
}

static int dw_hdmi_qp_i2s_get_eld(struct device *dev, void *data, uint8_t *buf,
				  size_t len)
{
	struct dw_hdmi_qp_i2s_audio_data *audio = data;

	memcpy(buf, audio->eld, min_t(size_t, MAX_ELD_BYTES, len));

	return 0;
}

static int dw_hdmi_qp_i2s_get_dai_id(struct snd_soc_component *component,
				     struct device_node *endpoint)
{
	struct of_endpoint of_ep;
	int ret;

	ret = of_graph_parse_endpoint(endpoint, &of_ep);
	if (ret < 0)
		return ret;

	/*
	 * HDMI sound should be located as reg = <2>
	 * Then, it is sound port 0
	 */
	if (of_ep.port == 2)
		return 0;

	return -EINVAL;
}

static int dw_hdmi_qp_i2s_hook_plugged_cb(struct device *dev, void *data,
					  hdmi_codec_plugged_cb fn,
					  struct device *codec_dev)
{
	struct dw_hdmi_qp_i2s_audio_data *audio = data;
	struct dw_hdmi_qp *hdmi = audio->hdmi;

	return dw_hdmi_qp_set_plugged_cb(hdmi, fn, codec_dev);
}

static struct hdmi_codec_ops dw_hdmi_qp_i2s_ops = {
	.hw_params	= dw_hdmi_qp_i2s_hw_params,
	.audio_startup  = dw_hdmi_qp_i2s_audio_startup,
	.audio_shutdown	= dw_hdmi_qp_i2s_audio_shutdown,
	.get_eld	= dw_hdmi_qp_i2s_get_eld,
	.get_dai_id	= dw_hdmi_qp_i2s_get_dai_id,
	.hook_plugged_cb = dw_hdmi_qp_i2s_hook_plugged_cb,
};

static int snd_dw_hdmi_qp_probe(struct platform_device *pdev)
{
	struct dw_hdmi_qp_i2s_audio_data *audio = pdev->dev.platform_data;
	struct platform_device_info pdevinfo;
	struct hdmi_codec_pdata pdata;
	struct platform_device *platform;

	pdata.ops		= &dw_hdmi_qp_i2s_ops;
	pdata.i2s		= 1;
	pdata.max_i2s_channels	= 8;
	pdata.data		= audio;

	if (device_property_read_bool(pdev->dev.parent, "audio-no-capture")) {
		pdata.no_i2s_capture    = 1;
		pdata.no_spdif_capture  = 1;
	}

	memset(&pdevinfo, 0, sizeof(pdevinfo));
	pdevinfo.parent		= pdev->dev.parent;
	pdevinfo.id		= PLATFORM_DEVID_AUTO;
	pdevinfo.name		= HDMI_CODEC_DRV_NAME;
	pdevinfo.data		= &pdata;
	pdevinfo.size_data	= sizeof(pdata);
	pdevinfo.dma_mask	= DMA_BIT_MASK(32);

	platform = platform_device_register_full(&pdevinfo);
	if (IS_ERR(platform))
		return PTR_ERR(platform);

	dev_set_drvdata(&pdev->dev, platform);

	return 0;
}

static int snd_dw_hdmi_qp_remove(struct platform_device *pdev)
{
	struct platform_device *platform = dev_get_drvdata(&pdev->dev);

	platform_device_unregister(platform);

	return 0;
}

static struct platform_driver snd_dw_hdmi_qp_driver = {
	.probe	= snd_dw_hdmi_qp_probe,
	.remove	= snd_dw_hdmi_qp_remove,
	.driver	= {
		.name = DRIVER_NAME,
	},
};
module_platform_driver(snd_dw_hdmi_qp_driver);

MODULE_AUTHOR("Sugar Zhang <sugar.zhang@rock-chips.com>");
MODULE_DESCRIPTION("Synopsis Designware HDMI QP I2S ALSA SoC interface");
MODULE_LICENSE("GPL v2");
MODULE_ALIAS("platform:" DRIVER_NAME);
