// SPDX-License-Identifier: GPL-2.0
/*
 * Rockchip PIPE USB3.0 PCIE SATA Combo Phy driver
 *
 * Copyright (C) 2021 Rockchip Electronics Co., Ltd.
 */

#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/io.h>
#include <linux/iopoll.h>
#include <linux/kernel.h>
#include <linux/mfd/syscon.h>
#include <linux/module.h>
#include <linux/of_device.h>
#include <linux/phy/phy.h>
#include <linux/regmap.h>
#include <linux/reset.h>
#include <dt-bindings/phy/phy.h>

#define BIT_WRITEABLE_SHIFT		16

struct rockchip_combphy_priv;

struct combphy_reg {
	u32 offset;
	u16 bitend;
	u16 bitstart;
	u16 disable;
	u16 enable;
};

struct rockchip_combphy_grfcfg {
	struct combphy_reg pcie_mode_set;
	struct combphy_reg usb_mode_set;
	struct combphy_reg sgmii_mode_set;
	struct combphy_reg qsgmii_mode_set;
	struct combphy_reg pipe_ebuff_mode;
	struct combphy_reg pipe_rxterm_set;
	struct combphy_reg pipe_txelec_set;
	struct combphy_reg pipe_txcomp_set;
	struct combphy_reg pipe_clk_24m;
	struct combphy_reg pipe_clk_25m;
	struct combphy_reg pipe_clk_100m;
	struct combphy_reg pipe_phymode_sel;
	struct combphy_reg pipe_rate_sel;
	struct combphy_reg pipe_rxterm_sel;
	struct combphy_reg pipe_txelec_sel;
	struct combphy_reg pipe_txcomp_sel;
	struct combphy_reg pipe_clk_ext;
	struct combphy_reg pipe_sel_usb;
	struct combphy_reg pipe_sel_qsgmii;
	struct combphy_reg pipe_phy_status;
	struct combphy_reg con0_for_pcie;
	struct combphy_reg con1_for_pcie;
	struct combphy_reg con2_for_pcie;
	struct combphy_reg con3_for_pcie;
	struct combphy_reg con0_for_sata;
	struct combphy_reg con1_for_sata;
	struct combphy_reg con2_for_sata;
	struct combphy_reg con3_for_sata;
	struct combphy_reg pipe_con0_for_sata;
	struct combphy_reg pipe_con1_for_sata;
	struct combphy_reg pipe_sgmii_mac_sel;
	struct combphy_reg pipe_xpcs_phy_ready;
	struct combphy_reg u3otg0_port_en;
	struct combphy_reg u3otg1_port_en;
	struct combphy_reg pipe_phy_grf_reset;
};

struct rockchip_combphy_cfg {
	const int num_clks;
	const struct clk_bulk_data *clks;
	const struct rockchip_combphy_grfcfg *grfcfg;
	bool force_det_out; /* Tx detect Rx errata */
	int (*combphy_cfg)(struct rockchip_combphy_priv *priv);
};

struct rockchip_combphy_priv {
	u8 mode;
	void __iomem *mmio;
	int num_clks;
	struct clk_bulk_data *clks;
	struct device *dev;
	struct regmap *pipe_grf;
	struct regmap *phy_grf;
	struct phy *phy;
	struct reset_control *apb_rst;
	struct reset_control *phy_rst;
	const struct rockchip_combphy_cfg *cfg;
};

static void rockchip_combphy_updatel(struct rockchip_combphy_priv *priv,
				     int mask, int val, int reg)
{
	unsigned int temp;

	temp = readl(priv->mmio + reg);
	temp = (temp & ~(mask)) | val;
	writel(temp, priv->mmio + reg);
}

static int rockchip_combphy_param_write(struct regmap *base,
					const struct combphy_reg *reg, bool en)
{
	u32 val, mask, tmp;

	tmp = en ? reg->enable : reg->disable;
	mask = GENMASK(reg->bitend, reg->bitstart);
	val = (tmp << reg->bitstart) | (mask << BIT_WRITEABLE_SHIFT);

	return regmap_write(base, reg->offset, val);
}

static u32 rockchip_combphy_is_ready(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	u32 mask, val;

	mask = GENMASK(cfg->pipe_phy_status.bitend,
		       cfg->pipe_phy_status.bitstart);

	regmap_read(priv->phy_grf, cfg->pipe_phy_status.offset, &val);
	val = (val & mask) >> cfg->pipe_phy_status.bitstart;

	return val;
}

static int rockchip_combphy_pcie_init(struct rockchip_combphy_priv *priv)
{
	int ret = 0;

	if (priv->cfg->combphy_cfg) {
		ret = priv->cfg->combphy_cfg(priv);
		if (ret) {
			dev_err(priv->dev, "failed to init phy for pcie\n");
			return ret;
		}
	}

	if (priv->cfg->force_det_out)
		rockchip_combphy_updatel(priv, GENMASK(5, 5), BIT(5), 0x19 << 2);

	return ret;
}

static int rockchip_combphy_usb3_init(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	int ret = 0;

	if (device_property_present(priv->dev, "rockchip,dis-u3otg0-port")) {
		ret = rockchip_combphy_param_write(priv->pipe_grf,
						   &cfg->u3otg0_port_en, false);
		return ret;
	} else if (device_property_present(priv->dev, "rockchip,dis-u3otg1-port")) {
		ret = rockchip_combphy_param_write(priv->pipe_grf,
						   &cfg->u3otg1_port_en, false);
		if (of_device_is_compatible(priv->dev->of_node, "rockchip,rk3576-naneng-combphy"))
			rockchip_combphy_param_write(priv->phy_grf,
						     &cfg->usb_mode_set, true);
		return ret;
	}

	if (priv->cfg->combphy_cfg) {
		ret = priv->cfg->combphy_cfg(priv);
		if (ret) {
			dev_err(priv->dev, "failed to init phy for usb3\n");
			return ret;
		}
	}

	return ret;
}

static int rockchip_combphy_sata_init(struct rockchip_combphy_priv *priv)
{
	int ret = 0;

	if (priv->cfg->combphy_cfg) {
		ret = priv->cfg->combphy_cfg(priv);
		if (ret) {
			dev_err(priv->dev, "failed to init phy for sata\n");
			return ret;
		}
	}

	return ret;
}

static int rockchip_combphy_sgmii_init(struct rockchip_combphy_priv *priv)
{
	int ret = 0;

	if (priv->cfg->combphy_cfg) {
		ret = priv->cfg->combphy_cfg(priv);
		if (ret) {
			dev_err(priv->dev, "failed to init phy for sgmii\n");
			return ret;
		}
	}

	return ret;
}

static int rockchip_combphy_set_mode(struct rockchip_combphy_priv *priv)
{
	switch (priv->mode) {
	case PHY_TYPE_PCIE:
		rockchip_combphy_pcie_init(priv);
		break;
	case PHY_TYPE_USB3:
		rockchip_combphy_usb3_init(priv);
		break;
	case PHY_TYPE_SATA:
		rockchip_combphy_sata_init(priv);
		break;
	case PHY_TYPE_SGMII:
	case PHY_TYPE_QSGMII:
		return rockchip_combphy_sgmii_init(priv);
	default:
		dev_err(priv->dev, "incompatible PHY type\n");
		return -EINVAL;
	}

	return 0;
}

static int rockchip_combphy_init(struct phy *phy)
{
	struct rockchip_combphy_priv *priv = phy_get_drvdata(phy);
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	u32 val;
	int ret;

	ret = clk_bulk_prepare_enable(priv->num_clks, priv->clks);
	if (ret) {
		dev_err(priv->dev, "failed to enable clks\n");
		return ret;
	}

	ret = rockchip_combphy_set_mode(priv);
	if (ret)
		goto err_clk;

	ret = reset_control_deassert(priv->phy_rst);
	if (ret)
		goto err_clk;

	if (cfg->pipe_phy_grf_reset.enable)
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_phy_grf_reset, false);

	if (priv->mode == PHY_TYPE_USB3 &&
	    !device_property_present(priv->dev, "rockchip,dis-u3otg0-port") &&
	    !device_property_present(priv->dev, "rockchip,dis-u3otg1-port")) {
		ret = readx_poll_timeout_atomic(rockchip_combphy_is_ready,
						priv, val,
						val == cfg->pipe_phy_status.enable,
						10, 1000);
		if (ret)
			dev_warn(priv->dev, "wait phy status ready timeout\n");
	}

	return 0;

err_clk:
	clk_bulk_disable_unprepare(priv->num_clks, priv->clks);

	return ret;
}

static int rockchip_combphy_exit(struct phy *phy)
{
	struct rockchip_combphy_priv *priv = phy_get_drvdata(phy);
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;

	if (cfg->pipe_phy_grf_reset.enable)
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_phy_grf_reset, true);

	clk_bulk_disable_unprepare(priv->num_clks, priv->clks);
	reset_control_assert(priv->phy_rst);

	return 0;
}

static const char *rockchip_combphy_mode2str(enum phy_mode mode)
{
	switch (mode) {
	case PHY_TYPE_SATA:
		return "SATA";
	case PHY_TYPE_PCIE:
		return "PCIe";
	case PHY_TYPE_USB3:
		return "USB3";
	case PHY_TYPE_SGMII:
	case PHY_TYPE_QSGMII:
		return "GMII";
	default:
		return "Unknown";
	}
}

static int rockchip_combphy_validate(struct phy *phy, enum phy_mode mode, int submode,
			      union phy_configure_opts *opts)
{
	struct rockchip_combphy_priv *priv = phy_get_drvdata(phy);

	if (mode != priv->mode) {
		dev_err(priv->dev, "expected mode is %s, but current mode is %s\n",
			rockchip_combphy_mode2str(mode),
			rockchip_combphy_mode2str(priv->mode));
		return -EINVAL;
	}

	return 0;
}

static const struct phy_ops rockchip_combphy_ops = {
	.init = rockchip_combphy_init,
	.exit = rockchip_combphy_exit,
	.validate = rockchip_combphy_validate,
	.owner = THIS_MODULE,
};

static struct phy *rockchip_combphy_xlate(struct device *dev,
					  struct of_phandle_args *args)
{
	struct rockchip_combphy_priv *priv = dev_get_drvdata(dev);
	bool no_overwrite = false;

	if (args->args_count < 1) {
		dev_err(dev, "invalid number of arguments\n");
		return ERR_PTR(-EINVAL);
	}

	if (args->args_count == 2 && args->args[1] == 1)
		no_overwrite = true;

	if (priv->mode != PHY_NONE && priv->mode != args->args[0]) {
		dev_warn(dev, "phy type select %d %soverwriting type %d\n",
			 args->args[0], no_overwrite ? "no-" : "", priv->mode);

		if (no_overwrite)
			return ERR_PTR(-EBUSY);
	}

	priv->mode = args->args[0];

	return priv->phy;
}

static int rockchip_combphy_parse_dt(struct device *dev,
				     struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	int ret, mac_id;
	u32 vals[4];

	ret = devm_clk_bulk_get(dev, priv->num_clks, priv->clks);
	if (ret == -EPROBE_DEFER)
		return -EPROBE_DEFER;
	if (ret)
		priv->num_clks = 0;

	priv->pipe_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
							 "rockchip,pipe-grf");
	if (IS_ERR(priv->pipe_grf)) {
		dev_err(dev, "failed to find peri_ctrl pipe-grf regmap\n");
		return PTR_ERR(priv->pipe_grf);
	}

	priv->phy_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
							"rockchip,pipe-phy-grf");
	if (IS_ERR(priv->phy_grf)) {
		dev_err(dev, "failed to find peri_ctrl pipe-phy-grf regmap\n");
		return PTR_ERR(priv->phy_grf);
	}

	if (device_property_present(dev, "rockchip,dis-u3otg0-port")) {
		rockchip_combphy_param_write(priv->pipe_grf,
					     &cfg->u3otg0_port_en, false);
	} else if (device_property_present(dev, "rockchip,dis-u3otg1-port")) {
		rockchip_combphy_param_write(priv->pipe_grf,
					     &cfg->u3otg1_port_en, false);
		if (of_device_is_compatible(dev->of_node, "rockchip,rk3576-naneng-combphy"))
			rockchip_combphy_param_write(priv->phy_grf,
						     &cfg->usb_mode_set, true);
	}

	if (!device_property_read_u32(dev, "rockchip,sgmii-mac-sel", &mac_id) &&
	    (mac_id > 0))
		rockchip_combphy_param_write(priv->pipe_grf,
					     &cfg->pipe_sgmii_mac_sel, true);

	if (!device_property_read_u32_array(dev, "rockchip,pcie1ln-sel-bits",
					    vals, ARRAY_SIZE(vals)))
		regmap_write(priv->pipe_grf, vals[0],
			     (GENMASK(vals[2], vals[1]) << 16) | (vals[3] << vals[1]));

	priv->apb_rst = devm_reset_control_get_optional(dev, "combphy-apb");
	if (IS_ERR(priv->apb_rst)) {
		ret = PTR_ERR(priv->apb_rst);

		if (ret != -EPROBE_DEFER)
			dev_warn(dev, "failed to get apb reset\n");

		return ret;
	}

	priv->phy_rst = devm_reset_control_get_optional(dev, "combphy");
	if (IS_ERR(priv->phy_rst)) {
		ret = PTR_ERR(priv->phy_rst);

		if (ret != -EPROBE_DEFER)
			dev_warn(dev, "failed to get phy reset\n");

		return ret;
	}

	return reset_control_assert(priv->phy_rst);
}

static int rockchip_combphy_probe(struct platform_device *pdev)
{
	struct phy_provider *phy_provider;
	struct device *dev = &pdev->dev;
	struct rockchip_combphy_priv *priv;
	const struct rockchip_combphy_cfg *phy_cfg;
	struct resource *res;
	int ret;

	phy_cfg = of_device_get_match_data(dev);
	if (!phy_cfg) {
		dev_err(dev, "No OF match data provided\n");
		return -EINVAL;
	}

	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
	if (!priv)
		return -ENOMEM;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	priv->mmio = devm_ioremap_resource(dev, res);
	if (IS_ERR(priv->mmio)) {
		ret = PTR_ERR(priv->mmio);
		return ret;
	}

	priv->num_clks = phy_cfg->num_clks;

	priv->clks = devm_kmemdup(dev, phy_cfg->clks,
				  phy_cfg->num_clks * sizeof(struct clk_bulk_data),
				  GFP_KERNEL);

	if (!priv->clks)
		return -ENOMEM;

	priv->dev = dev;
	priv->mode = PHY_NONE;
	priv->cfg = phy_cfg;

	ret = rockchip_combphy_parse_dt(dev, priv);
	if (ret)
		return ret;

	priv->phy = devm_phy_create(dev, NULL, &rockchip_combphy_ops);
	if (IS_ERR(priv->phy)) {
		dev_err(dev, "failed to create combphy\n");
		return PTR_ERR(priv->phy);
	}

	dev_set_drvdata(dev, priv);
	phy_set_drvdata(priv->phy, priv);

	phy_provider = devm_of_phy_provider_register(dev, rockchip_combphy_xlate);

	return PTR_ERR_OR_ZERO(phy_provider);
}

static int rk3528_combphy_cfg(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	struct clk *refclk = NULL;
	unsigned long rate;
	int i;
	u32 val;

	/* Configure PHY reference clock frequency */
	for (i = 0; i < priv->num_clks; i++) {
		if (!strncmp(priv->clks[i].id, "refclk", 6)) {
			refclk = priv->clks[i].clk;
			break;
		}
	}

	if (!refclk) {
		dev_err(priv->dev, "No refclk found\n");
		return -EINVAL;
	}

	switch (priv->mode) {
	case PHY_TYPE_PCIE:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x18);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_pcie, true);
		break;
	case PHY_TYPE_USB3:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x18);

		/* Enable adaptive CTLE for USB3.0 Rx */
		rockchip_combphy_updatel(priv, GENMASK(17, 17), BIT(17), 0x200);

		/* Set slow slew rate control for PI */
		rockchip_combphy_updatel(priv, GENMASK(2, 0), 0x07, 0x204);

		/* Set CDR phase path with 2x gain */
		rockchip_combphy_updatel(priv, GENMASK(5, 5), BIT(5), 0x204);

		/* Set Rx squelch input filler bandwidth */
		rockchip_combphy_updatel(priv, GENMASK(2, 0), 0x06, 0x20c);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->usb_mode_set, true);
		break;
	default:
		dev_err(priv->dev, "incompatible PHY type\n");
		return -EINVAL;
	}

	rate = clk_get_rate(refclk);

	switch (rate) {
	case 24000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_24m, true);
		if (priv->mode == PHY_TYPE_USB3)
			/* Set ssc_cnt[10:0]=00101111101 & 31.5KHz */
			rockchip_combphy_updatel(priv, GENMASK(10, 0), 0x17d, 0x100);
		else if (priv->mode == PHY_TYPE_PCIE)
			/* tx_trim[14]=1, Enable the counting clock of the rterm detect */
			rockchip_combphy_updatel(priv, GENMASK(14, 14), BIT(14), 0x218);
		break;
	case 100000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
		if (priv->mode == PHY_TYPE_PCIE) {
			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(12, 10), 0x2 << 10, 0x18);

			/* su_trim[6:4]=111, [10:7]=1001, [2:0]=000, swing 650mv */
			writel(0x570804f0, priv->mmio + 0x108);
		}
		break;
	default:
		dev_err(priv->dev, "Unsupported rate: %lu\n", rate);
		return -EINVAL;
	}

	if (device_property_read_bool(priv->dev, "rockchip,ext-refclk")) {
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
		if (priv->mode == PHY_TYPE_PCIE && rate == 100000000) {
			/*
			 * PLL charge pump current adjust = 111
			 * PLL LPF R1 adjust = 1001
			 * PLL KVCO adjust = 000 (min)
			 * PLL KVCO fine tuning signals = 01
			 */
			rockchip_combphy_updatel(priv, GENMASK(2, 0),
						 BIT(29) | (0x7 << 4 | 0x9 << 7), 0x108);
			rockchip_combphy_updatel(priv, GENMASK(12, 10), 0x2 << 10, 0x18);
		}
	}

	if (priv->mode == PHY_TYPE_PCIE) {
		if (device_property_read_bool(priv->dev, "rockchip,enable-ssc")) {
			val = readl(priv->mmio + 0x100);
			val |= BIT(20);
			writel(val, priv->mmio + 0x100);
		}
	}

	return 0;
}

static const struct rockchip_combphy_grfcfg rk3528_combphy_grfcfgs = {
	/* pipe-phy-grf */
	.pcie_mode_set		= { 0x48000, 5, 0, 0x00, 0x11 },
	.usb_mode_set		= { 0x48000, 5, 0, 0x00, 0x04 },
	.pipe_rxterm_set	= { 0x48000, 12, 12, 0x00, 0x01 },
	.pipe_txelec_set	= { 0x48004, 1, 1, 0x00, 0x01 },
	.pipe_txcomp_set	= { 0x48004, 4, 4, 0x00, 0x01 },
	.pipe_clk_24m		= { 0x48004, 14, 13, 0x00, 0x00 },
	.pipe_clk_100m		= { 0x48004, 14, 13, 0x00, 0x02 },
	.pipe_rxterm_sel	= { 0x48008, 8, 8, 0x00, 0x01 },
	.pipe_txelec_sel	= { 0x48008, 12, 12, 0x00, 0x01 },
	.pipe_txcomp_sel	= { 0x48008, 15, 15, 0x00, 0x01 },
	.pipe_clk_ext		= { 0x4800c, 9, 8, 0x02, 0x01 },
	.pipe_phy_status	= { 0x48034, 6, 6, 0x01, 0x00 },
	.con0_for_pcie		= { 0x48000, 15, 0, 0x00, 0x110 },
	.con1_for_pcie		= { 0x48004, 15, 0, 0x00, 0x00 },
	.con2_for_pcie		= { 0x48008, 15, 0, 0x00, 0x101 },
	.con3_for_pcie		= { 0x4800c, 15, 0, 0x00, 0x0200 },
	/* pipe-grf */
	.u3otg0_port_en		= { 0x40044, 15, 0, 0x0181, 0x1100 },
};

static const struct clk_bulk_data rk3528_clks[] = {
	{ .id = "refclk" },
	{ .id = "apbclk" },
	{ .id = "pipe_clk" },
};

static const struct rockchip_combphy_cfg rk3528_combphy_cfgs = {
	.num_clks	= ARRAY_SIZE(rk3528_clks),
	.clks		= rk3528_clks,
	.grfcfg		= &rk3528_combphy_grfcfgs,
	.combphy_cfg	= rk3528_combphy_cfg,
};

static int rk3562_combphy_cfg(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	struct clk *refclk = NULL;
	unsigned long rate;
	int i;

	/* Configure PHY reference clock frequency */
	for (i = 0; i < priv->num_clks; i++) {
		if (!strncmp(priv->clks[i].id, "refclk", 6)) {
			refclk = priv->clks[i].clk;
			break;
		}
	}

	if (!refclk) {
		dev_err(priv->dev, "No refclk found\n");
		return -EINVAL;
	}

	switch (priv->mode) {
	case PHY_TYPE_PCIE:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_pcie, true);
		break;
	case PHY_TYPE_USB3:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		/* Enable adaptive CTLE for USB3.0 Rx */
		rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0x0e << 2);

		/* Set PLL KVCO fine tuning signals */
		rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x2 << 2, 0x20 << 2);

		/* Set PLL LPF R1 to su_trim[10:7]=1001 */
		writel(0x4, priv->mmio + (0xb << 2));

		/* Set PLL input clock divider 1/2 */
		rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x5 << 2);

		/* Set PLL loop divider */
		writel(0x32, priv->mmio + (0x11 << 2));

		/* Set PLL KVCO to min and set PLL charge pump current to max */
		writel(0xf0, priv->mmio + (0xa << 2));

		/* Set Rx squelch input filler bandwidth */
		writel(0x0e, priv->mmio + (0x14 << 2));

		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_sel_usb, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->usb_mode_set, true);
		break;
	default:
		dev_err(priv->dev, "incompatible PHY type\n");
		return -EINVAL;
	}

	rate = clk_get_rate(refclk);

	switch (rate) {
	case 24000000:
		if (priv->mode == PHY_TYPE_USB3) {
			/* Set ssc_cnt[9:0]=0101111101 & 31.5KHz */
			rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x0e << 2);
			rockchip_combphy_updatel(priv, GENMASK(7, 0), 0x5f, 0x0f << 2);
		}
		break;
	case 25000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_25m, true);
		break;
	case 100000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
		if (priv->mode == PHY_TYPE_PCIE) {
			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x2 << 2, 0x20 << 2);

			/* Enable controlling random jitter, aka RMJ */
			writel(0x4, priv->mmio + (0xb << 2));

			rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x5 << 2);

			writel(0x32, priv->mmio + (0x11 << 2));
			writel(0xf0, priv->mmio + (0xa << 2));

			/* CKDRV output swing adjust to 650mv */
			rockchip_combphy_updatel(priv, GENMASK(4, 1), 0xb << 1, 0xd << 2);
		}
		break;
	default:
		dev_err(priv->dev, "Unsupported rate: %lu\n", rate);
		return -EINVAL;
	}

	if (device_property_read_bool(priv->dev, "rockchip,ext-refclk")) {
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
		if (priv->mode == PHY_TYPE_PCIE && rate == 100000000) {
			rockchip_combphy_updatel(priv, 0x3 << 4 | 0x1 << 7,
						 0x3 << 4 | 0x1 << 7, 0xc << 2);

			rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0xd << 2);
		}
	}

	if (device_property_read_bool(priv->dev, "rockchip,enable-ssc"))
		rockchip_combphy_updatel(priv, GENMASK(4, 4), BIT(4), 0x7 << 2);

	return 0;
}

static const struct rockchip_combphy_grfcfg rk3562_combphy_grfcfgs = {
	/* pipe-phy-grf */
	.pcie_mode_set		= { 0x0000, 5, 0, 0x00, 0x11 },
	.usb_mode_set		= { 0x0000, 5, 0, 0x00, 0x04 },
	.pipe_rxterm_set	= { 0x0000, 12, 12, 0x00, 0x01 },
	.pipe_txelec_set	= { 0x0004, 1, 1, 0x00, 0x01 },
	.pipe_txcomp_set	= { 0x0004, 4, 4, 0x00, 0x01 },
	.pipe_clk_25m		= { 0x0004, 14, 13, 0x00, 0x01 },
	.pipe_clk_100m		= { 0x0004, 14, 13, 0x00, 0x02 },
	.pipe_phymode_sel	= { 0x0008, 1, 1, 0x00, 0x01 },
	.pipe_rate_sel		= { 0x0008, 2, 2, 0x00, 0x01 },
	.pipe_rxterm_sel	= { 0x0008, 8, 8, 0x00, 0x01 },
	.pipe_txelec_sel	= { 0x0008, 12, 12, 0x00, 0x01 },
	.pipe_txcomp_sel	= { 0x0008, 15, 15, 0x00, 0x01 },
	.pipe_clk_ext		= { 0x000c, 9, 8, 0x02, 0x01 },
	.pipe_sel_usb		= { 0x000c, 14, 13, 0x00, 0x01 },
	.pipe_phy_status	= { 0x0034, 6, 6, 0x01, 0x00 },
	.con0_for_pcie		= { 0x0000, 15, 0, 0x00, 0x1000 },
	.con1_for_pcie		= { 0x0004, 15, 0, 0x00, 0x0000 },
	.con2_for_pcie		= { 0x0008, 15, 0, 0x00, 0x0101 },
	.con3_for_pcie		= { 0x000c, 15, 0, 0x00, 0x0200 },
	.pipe_phy_grf_reset	= { 0x0014, 1, 0, 0x3, 0x1 },
	/* peri-grf */
	.u3otg0_port_en		= { 0x0094, 15, 0, 0x0181, 0x1100 },
};

static const struct clk_bulk_data rk3562_clks[] = {
	{ .id = "refclk" },
	{ .id = "apbclk" },
	{ .id = "pipe_clk" },
};

static const struct rockchip_combphy_cfg rk3562_combphy_cfgs = {
	.num_clks	= ARRAY_SIZE(rk3562_clks),
	.clks		= rk3562_clks,
	.grfcfg		= &rk3562_combphy_grfcfgs,
	.combphy_cfg	= rk3562_combphy_cfg,
	.force_det_out	= true,
};

static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	struct clk *refclk = NULL;
	unsigned long rate;
	int i;

	/* Configure PHY reference clock frequency */
	for (i = 0; i < priv->num_clks; i++) {
		if (!strncmp(priv->clks[i].id, "refclk", 6)) {
			refclk = priv->clks[i].clk;
			break;
		}
	}

	if (!refclk) {
		dev_err(priv->dev, "No refclk found\n");
		return -EINVAL;
	}

	switch (priv->mode) {
	case PHY_TYPE_PCIE:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_pcie, true);
		break;
	case PHY_TYPE_USB3:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		/* Enable adaptive CTLE for USB3.0 Rx */
		rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0xe << 2);

		/* Set PLL KVCO fine tuning signals */
		rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x2 << 2, 0x20 << 2);

		/* Set PLL LPF R1 to su_trim[10:7]=1001 */
		writel(0x4, priv->mmio + (0xb << 2));

		/* Set PLL input clock divider 1/2 */
		rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x5 << 2);

		/* Set PLL loop divider */
		writel(0x32, priv->mmio + (0x11 << 2));

		/* Set PLL KVCO to min and set PLL charge pump current to max */
		writel(0xf0, priv->mmio + (0xa << 2));

		/* Set Rx squelch input filler bandwidth */
		writel(0x0e, priv->mmio + (0x14 << 2));

		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_sel_usb, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->usb_mode_set, true);
		break;
	case PHY_TYPE_SATA:
		writel(0x41, priv->mmio + 0x38);
		writel(0x8F, priv->mmio + 0x18);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_sata, true);
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_con0_for_sata, true);
		break;
	case PHY_TYPE_SGMII:
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_xpcs_phy_ready, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_phymode_sel, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_sel_qsgmii, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->sgmii_mode_set, true);
		break;
	case PHY_TYPE_QSGMII:
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_xpcs_phy_ready, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_phymode_sel, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_rate_sel, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_sel_qsgmii, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->qsgmii_mode_set, true);
		break;
	default:
		dev_err(priv->dev, "incompatible PHY type\n");
		return -EINVAL;
	}

	rate = clk_get_rate(refclk);

	switch (rate) {
	case 24000000:
		if (priv->mode == PHY_TYPE_USB3 || priv->mode == PHY_TYPE_SATA) {
			/* Set ssc_cnt[9:0]=0101111101 & 31.5KHz */
			rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0xe << 2);

			rockchip_combphy_updatel(priv, GENMASK(7, 0), 0x5f, 0xf << 2);
		}
		break;
	case 25000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_25m, true);
		break;
	case 100000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
		if (priv->mode == PHY_TYPE_PCIE) {
			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x2 << 2, 0x20 << 2);

			/* Enable controlling random jitter, aka RMJ */
			writel(0x4, priv->mmio + (0xb << 2));

			rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x5 << 2);

			writel(0x32, priv->mmio + (0x11 << 2));
			writel(0xf0, priv->mmio + (0xa << 2));
		} else if (priv->mode == PHY_TYPE_SATA) {
			/* downward spread spectrum +500ppm */
			rockchip_combphy_updatel(priv, GENMASK(7, 4), 0x50, 0x1f << 2);
		}
		break;
	default:
		dev_err(priv->dev, "Unsupported rate: %lu\n", rate);
		return -EINVAL;
	}

	if (device_property_read_bool(priv->dev, "rockchip,ext-refclk")) {
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
		if (priv->mode == PHY_TYPE_PCIE && rate == 100000000) {
			/*
			 * PLL charge pump current adjust = 111
			 * PLL LPF R1 adjust = 1001
			 * PLL KVCO adjust = 000 (min)
			 * PLL KVCO fine tuning signals = 01
			 */
			rockchip_combphy_updatel(priv, GENMASK(2, 0), 0xf << 4, 0xa << 2);
			rockchip_combphy_updatel(priv, GENMASK(2, 0), 0x4, 0xb << 2);
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x2 << 2, 0x20 << 2);
			rockchip_combphy_updatel(priv, 0x3 << 4 | 0x1 << 7,
						 0x3 << 4 | 0x1 << 7, 0xc << 2);

			rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0xd << 2);
		}
	}

	if (device_property_read_bool(priv->dev, "rockchip,enable-ssc"))
		rockchip_combphy_updatel(priv, GENMASK(4, 4), BIT(4), 0x7 << 2);

	return 0;
}

static const struct rockchip_combphy_grfcfg rk3568_combphy_grfcfgs = {
	/* pipe-phy-grf */
	.pcie_mode_set		= { 0x0000, 5, 0, 0x00, 0x11 },
	.usb_mode_set		= { 0x0000, 5, 0, 0x00, 0x04 },
	.sgmii_mode_set		= { 0x0000, 5, 0, 0x00, 0x01 },
	.qsgmii_mode_set	= { 0x0000, 5, 0, 0x00, 0x21 },
	.pipe_rxterm_set	= { 0x0000, 12, 12, 0x00, 0x01 },
	.pipe_txelec_set	= { 0x0004, 1, 1, 0x00, 0x01 },
	.pipe_txcomp_set	= { 0x0004, 4, 4, 0x00, 0x01 },
	.pipe_clk_25m		= { 0x0004, 14, 13, 0x00, 0x01 },
	.pipe_clk_100m		= { 0x0004, 14, 13, 0x00, 0x02 },
	.pipe_phymode_sel	= { 0x0008, 1, 1, 0x00, 0x01 },
	.pipe_rate_sel		= { 0x0008, 2, 2, 0x00, 0x01 },
	.pipe_rxterm_sel	= { 0x0008, 8, 8, 0x00, 0x01 },
	.pipe_txelec_sel	= { 0x0008, 12, 12, 0x00, 0x01 },
	.pipe_txcomp_sel	= { 0x0008, 15, 15, 0x00, 0x01 },
	.pipe_clk_ext		= { 0x000c, 9, 8, 0x02, 0x01 },
	.pipe_sel_usb		= { 0x000c, 14, 13, 0x00, 0x01 },
	.pipe_sel_qsgmii	= { 0x000c, 15, 13, 0x00, 0x07 },
	.pipe_phy_status	= { 0x0034, 6, 6, 0x01, 0x00 },
	.con0_for_pcie		= { 0x0000, 15, 0, 0x00, 0x1000 },
	.con1_for_pcie		= { 0x0004, 15, 0, 0x00, 0x0000 },
	.con2_for_pcie		= { 0x0008, 15, 0, 0x00, 0x0101 },
	.con3_for_pcie		= { 0x000c, 15, 0, 0x00, 0x0200 },
	.con0_for_sata		= { 0x0000, 15, 0, 0x00, 0x0119 },
	.con1_for_sata		= { 0x0004, 15, 0, 0x00, 0x0040 },
	.con2_for_sata		= { 0x0008, 15, 0, 0x00, 0x80c3 },
	.con3_for_sata		= { 0x000c, 15, 0, 0x00, 0x4407 },
	/* pipe-grf */
	.pipe_con0_for_sata	= { 0x0000, 15, 0, 0x00, 0x2220 },
	.pipe_sgmii_mac_sel	= { 0x0040, 1, 1, 0x00, 0x01 },
	.pipe_xpcs_phy_ready	= { 0x0040, 2, 2, 0x00, 0x01 },
	.u3otg0_port_en		= { 0x0104, 15, 0, 0x0181, 0x1100 },
	.u3otg1_port_en		= { 0x0144, 15, 0, 0x0181, 0x1100 },
};

static const struct clk_bulk_data rk3568_clks[] = {
	{ .id = "refclk" },
	{ .id = "apbclk" },
	{ .id = "pipe_clk" },
};

static const struct rockchip_combphy_cfg rk3568_combphy_cfgs = {
	.num_clks	= ARRAY_SIZE(rk3568_clks),
	.clks		= rk3568_clks,
	.grfcfg		= &rk3568_combphy_grfcfgs,
	.combphy_cfg	= rk3568_combphy_cfg,
	.force_det_out	= true,
};

static int rk3576_combphy_cfg(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	struct clk *refclk = NULL;
	unsigned long rate;
	int i;

	/* Configure PHY reference clock frequency */
	for (i = 0; i < priv->num_clks; i++) {
		if (!strncmp(priv->clks[i].id, "refclk", 6)) {
			refclk = priv->clks[i].clk;
			break;
		}
	}

	if (!refclk) {
		dev_err(priv->dev, "No refclk found\n");
		return -EINVAL;
	}

	switch (priv->mode) {
	case PHY_TYPE_PCIE:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_pcie, true);
		break;
	case PHY_TYPE_USB3:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		/* Enable adaptive CTLE for USB3.0 Rx */
		rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0x38);

		/* Set PLL KVCO fine tuning signals */
		rockchip_combphy_updatel(priv, GENMASK(4, 2), BIT(3), 0x80);

		/* Set PLL LPF R1 to su_trim[10:7]=1001 */
		writel(0x4, priv->mmio + (0xb << 2));

		/* Set PLL input clock divider 1/2 */
		rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x14);

		/* Set PLL loop divider */
		writel(0x32, priv->mmio + (0x11 << 2));

		/* Set PLL KVCO to min and set PLL charge pump current to max */
		writel(0xf0, priv->mmio + (0xa << 2));

		/* Set Rx squelch input filler bandwidth */
		writel(0x0d, priv->mmio + (0x14 << 2));

		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->usb_mode_set, true);
		break;
	case PHY_TYPE_SATA:
		/* Enable adaptive CTLE for SATA Rx */
		rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0x38);

		/* Set tx_rterm = 50 ohm and rx_rterm = 43.5 ohm */
		writel(0x8F, priv->mmio + (0x06 << 2));

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_sata, true);
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_con0_for_sata, true);
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_con1_for_sata, true);
		break;
	default:
		dev_err(priv->dev, "incompatible PHY type\n");
		return -EINVAL;
	}

	rate = clk_get_rate(refclk);

	switch (rate) {
	case 24000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_24m, true);
		if (priv->mode == PHY_TYPE_USB3 || priv->mode == PHY_TYPE_SATA) {
			/* Set ssc_cnt[9:0]=0101111101 & 31.5KHz */
			rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0xe << 2);

			rockchip_combphy_updatel(priv, GENMASK(7, 0), 0x5f, 0xf << 2);
		} else if (priv->mode == PHY_TYPE_PCIE) {
			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x4 << 2, 0x20 << 2);

			/* Set up rx_trim */
			writel(0x0, priv->mmio + (0x1b << 2));

			/* Set up su_trim: T0_1 */
			writel(0x90, priv->mmio + (0xa << 2));
			writel(0x02, priv->mmio + (0xb << 2));
			writel(0x57, priv->mmio + (0xd << 2));

			writel(0x5f, priv->mmio + (0xf << 2));
		}
		break;
	case 25000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_25m, true);
		break;
	case 100000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
		if (priv->mode == PHY_TYPE_PCIE) {
			/* gate_tx_pck_sel length select work for L1SS */
			writel(0xc0, priv->mmio + 0x74);

			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x4 << 2, 0x20 << 2);

			/* Set up rx_trim: PLL LPF C1 85pf R1 1.25kohm */
			writel(0x4c, priv->mmio + (0x1b << 2));

			/* Set up su_trim: T3_P1 650mv */
			writel(0x90, priv->mmio + (0xa << 2));
			writel(0x43, priv->mmio + (0xb << 2));
			writel(0x88, priv->mmio + (0xc << 2));
			writel(0x56, priv->mmio + (0xd << 2));
		} else if (priv->mode == PHY_TYPE_SATA) {
			/* downward spread spectrum +500ppm */
			rockchip_combphy_updatel(priv, GENMASK(7, 4), 0x50, 0x1f << 2);

			/* ssc ppm adjust to 3500ppm */
			rockchip_combphy_updatel(priv, GENMASK(3, 0), 0x7, 0x9 << 2);
		}
		break;
	default:
		dev_err(priv->dev, "Unsupported rate: %lu\n", rate);
		return -EINVAL;
	}

	if (device_property_read_bool(priv->dev, "rockchip,ext-refclk")) {
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
		if (priv->mode == PHY_TYPE_PCIE && rate == 100000000) {
			writel(0x10, priv->mmio + (0x20 << 2));

			writel(0x0c, priv->mmio + (0x1b << 2));

			/* Set up su_trim: T3_P1 650mv */
			writel(0x90, priv->mmio + (0xa << 2));
			writel(0x43, priv->mmio + (0xb << 2));
			writel(0x88, priv->mmio + (0xc << 2));
			writel(0x56, priv->mmio + (0xd << 2));
		}
	}

	if (device_property_read_bool(priv->dev, "rockchip,enable-ssc")) {
		rockchip_combphy_updatel(priv, GENMASK(4, 4), BIT(4), 0x7 << 2);

		if (priv->mode == PHY_TYPE_PCIE && rate == 24000000) {
			/* Xin24M T0_1 650mV */
			writel(0x00, priv->mmio + (0x10 << 2));
			writel(0x32, priv->mmio + (0x11 << 2));
			writel(0x00, priv->mmio + (0x1b << 2));
			writel(0x90, priv->mmio + (0x0a << 2));
			writel(0x02, priv->mmio + (0x0b << 2));
			writel(0x08, priv->mmio + (0x0c << 2));
			writel(0x57, priv->mmio + (0x0d << 2));
			writel(0x40, priv->mmio + (0x0e << 2));
			writel(0x5f, priv->mmio + (0x0f << 2));
			writel(0x10, priv->mmio + (0x20 << 2));
		}
	}

	return 0;
}

static const struct rockchip_combphy_grfcfg rk3576_combphy_grfcfgs = {
	/* pipe-phy-grf */
	.pcie_mode_set		= { 0x0000, 5, 0, 0x00, 0x11 },
	.usb_mode_set		= { 0x0000, 5, 0, 0x00, 0x04 },
	.pipe_rxterm_set	= { 0x0000, 12, 12, 0x00, 0x01 },
	.pipe_txelec_set	= { 0x0004, 1, 1, 0x00, 0x01 },
	.pipe_txcomp_set	= { 0x0004, 4, 4, 0x00, 0x01 },
	.pipe_clk_24m		= { 0x0004, 14, 13, 0x00, 0x00 },
	.pipe_clk_25m		= { 0x0004, 14, 13, 0x00, 0x01 },
	.pipe_clk_100m		= { 0x0004, 14, 13, 0x00, 0x02 },
	.pipe_phymode_sel	= { 0x0008, 1, 1, 0x00, 0x01 },
	.pipe_rate_sel		= { 0x0008, 2, 2, 0x00, 0x01 },
	.pipe_rxterm_sel	= { 0x0008, 8, 8, 0x00, 0x01 },
	.pipe_txelec_sel	= { 0x0008, 12, 12, 0x00, 0x01 },
	.pipe_txcomp_sel	= { 0x0008, 15, 15, 0x00, 0x01 },
	.pipe_clk_ext		= { 0x000c, 9, 8, 0x02, 0x01 },
	.pipe_phy_status	= { 0x0034, 6, 6, 0x01, 0x00 },
	.con0_for_pcie		= { 0x0000, 15, 0, 0x00, 0x1000 },
	.con1_for_pcie		= { 0x0004, 15, 0, 0x00, 0x0000 },
	.con2_for_pcie		= { 0x0008, 15, 0, 0x00, 0x0101 },
	.con3_for_pcie		= { 0x000c, 15, 0, 0x00, 0x0200 },
	.con0_for_sata		= { 0x0000, 15, 0, 0x00, 0x0129 },
	.con1_for_sata		= { 0x0004, 15, 0, 0x00, 0x0000 },
	.con2_for_sata		= { 0x0008, 15, 0, 0x00, 0x80c1 },
	.con3_for_sata		= { 0x000c, 15, 0, 0x00, 0x0407 },
	.pipe_phy_grf_reset	= { 0x0014, 1, 0, 0x3, 0x1 },
	/* php-grf */
	.pipe_con0_for_sata	= { 0x001C, 2, 0, 0x00, 0x2 },
	.pipe_con1_for_sata	= { 0x0020, 2, 0, 0x00, 0x2 },
	.u3otg1_port_en		= { 0x0038, 15, 0, 0x0189, 0x1100 },
};

static const struct clk_bulk_data rk3576_clks[] = {
	{ .id = "refclk" },
	{ .id = "apbclk" },
	{ .id = "pipe_clk" },
};

static const struct rockchip_combphy_cfg rk3576_combphy_cfgs = {
	.num_clks	= ARRAY_SIZE(rk3576_clks),
	.clks		= rk3576_clks,
	.grfcfg		= &rk3576_combphy_grfcfgs,
	.combphy_cfg	= rk3576_combphy_cfg,
	.force_det_out	= true,
};

static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
{
	const struct rockchip_combphy_grfcfg *cfg = priv->cfg->grfcfg;
	struct clk *refclk = NULL;
	unsigned long rate;
	int i;
	u32 val;

	/* Configure PHY reference clock frequency */
	for (i = 0; i < priv->num_clks; i++) {
		if (!strncmp(priv->clks[i].id, "refclk", 6)) {
			refclk = priv->clks[i].clk;
			break;
		}
	}

	if (!refclk) {
		dev_err(priv->dev, "No refclk found\n");
		return -EINVAL;
	}

	switch (priv->mode) {
	case PHY_TYPE_PCIE:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_pcie, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_pcie, true);
		break;
	case PHY_TYPE_USB3:
		/* Set SSC downward spread spectrum */
		rockchip_combphy_updatel(priv, GENMASK(5, 4), BIT(4), 0x7c);

		/* Enable adaptive CTLE for USB3.0 Rx */
		rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0xe << 2);

		/* Set PLL KVCO fine tuning signals */
		rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x2 << 2, 0x20 << 2);

		/* Set PLL LPF R1 to su_trim[10:7]=1001 */
		writel(0x4, priv->mmio + (0xb << 2));

		/* Set PLL input clock divider 1/2 */
		rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0x5 << 2);

		/* Set PLL loop divider */
		writel(0x32, priv->mmio + (0x11 << 2));

		/* Set PLL KVCO to min and set PLL charge pump current to max */
		writel(0xf0, priv->mmio + (0xa << 2));

		/* Set Rx squelch input filler bandwidth */
		writel(0x0d, priv->mmio + (0x14 << 2));

		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txcomp_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_txelec_sel, false);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->usb_mode_set, true);
		break;
	case PHY_TYPE_SATA:
		/* Enable adaptive CTLE for SATA Rx */
		rockchip_combphy_updatel(priv, GENMASK(0, 0), BIT(0), 0xe << 2);
		/* Set tx_rterm = 50 ohm and rx_rterm = 43.5 ohm */
		writel(0x8F, priv->mmio + (0x06 << 2));

		/* Invert RX output data polarity (TBC) */
		rockchip_combphy_updatel(priv, GENMASK(4, 4), BIT(4), 0x4c);

		rockchip_combphy_param_write(priv->phy_grf, &cfg->con0_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con1_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con2_for_sata, true);
		rockchip_combphy_param_write(priv->phy_grf, &cfg->con3_for_sata, true);
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_con0_for_sata, true);
		rockchip_combphy_param_write(priv->pipe_grf, &cfg->pipe_con1_for_sata, true);

		if (device_property_read_bool(priv->dev, "rockchip,ebuff-mode"))
			rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_ebuff_mode, true);

		break;
	case PHY_TYPE_SGMII:
	case PHY_TYPE_QSGMII:
	default:
		dev_err(priv->dev, "incompatible PHY type\n");
		return -EINVAL;
	}

	rate = clk_get_rate(refclk);

	switch (rate) {
	case 24000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_24m, true);
		if (priv->mode == PHY_TYPE_USB3 || priv->mode == PHY_TYPE_SATA) {
			/* Set ssc_cnt[9:0]=0101111101 & 31.5KHz */
			rockchip_combphy_updatel(priv, GENMASK(7, 6), BIT(6), 0xe << 2);

			rockchip_combphy_updatel(priv, GENMASK(7, 0), 0x5f, 0xf << 2);
		} else if (priv->mode == PHY_TYPE_PCIE) {
			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x4 << 2, 0x20 << 2);

			/* Set up rx_trim */
			val = 0x0;
			writel(val, priv->mmio + (0x1b << 2));

			/* Set up su_trim: T0_1 */
			val = 0x90;
			writel(val, priv->mmio + (0xa << 2));
			val = 0x02;
			writel(val, priv->mmio + (0xb << 2));
			val = 0x57;
			writel(val, priv->mmio + (0xd << 2));

			val = 0x5f;
			writel(val, priv->mmio + (0xf << 2));
		}
		break;
	case 25000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_25m, true);
		break;
	case 100000000:
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
		if (priv->mode == PHY_TYPE_PCIE) {
			/* gate_tx_pck_sel length select work for L1SS */
			val = 0xc0;
			writel(val, priv->mmio + 0x74);

			/* PLL KVCO tuning fine */
			rockchip_combphy_updatel(priv, GENMASK(4, 2), 0x4 << 2, 0x20 << 2);

			/* Set up rx_trim: PLL LPF C1 85pf R1 1.25kohm */
			val = 0x4c;
			writel(val, priv->mmio + (0x1b << 2));

			/* Set up su_trim: T3_P1 650mv */
			val = 0x90;
			writel(val, priv->mmio + (0xa << 2));
			val = 0x43;
			writel(val, priv->mmio + (0xb << 2));
			val = 0x88;
			writel(val, priv->mmio + (0xc << 2));
			val = 0x56;
			writel(val, priv->mmio + (0xd << 2));
		} else if (priv->mode == PHY_TYPE_SATA) {
			/* downward spread spectrum +500ppm */
			rockchip_combphy_updatel(priv, GENMASK(7, 4), 0x50, 0x1f << 2);

			/* ssc ppm adjust to 3500ppm */
			rockchip_combphy_updatel(priv, GENMASK(3, 0), 0x7, 0x9 << 2);
		}
		break;
	default:
		dev_err(priv->dev, "Unsupported rate: %lu\n", rate);
		return -EINVAL;
	}

	if (device_property_read_bool(priv->dev, "rockchip,ext-refclk")) {
		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_ext, true);
		if (priv->mode == PHY_TYPE_PCIE && rate == 100000000) {
			val = 0x10;
			writel(val, priv->mmio + (0x20 << 2));

			val = 0x0c;
			writel(val, priv->mmio + (0x1b << 2));

			/* Set up su_trim: T3_P1 650mv */
			val = 0x90;
			writel(val, priv->mmio + (0xa << 2));
			val = 0x43;
			writel(val, priv->mmio + (0xb << 2));
			val = 0x88;
			writel(val, priv->mmio + (0xc << 2));
			val = 0x56;
			writel(val, priv->mmio + (0xd << 2));
		}
	}

	if (device_property_read_bool(priv->dev, "rockchip,enable-ssc")) {
		rockchip_combphy_updatel(priv, GENMASK(4, 4), BIT(4), 0x7 << 2);

		if (priv->mode == PHY_TYPE_PCIE && rate == 24000000) {
			/* Xin24M T0_1 650mV */
			writel(0x00, priv->mmio + (0x10 << 2));
			writel(0x32, priv->mmio + (0x11 << 2));
			writel(0x00, priv->mmio + (0x1b << 2));
			writel(0x90, priv->mmio + (0x0a << 2));
			writel(0x02, priv->mmio + (0x0b << 2));
			writel(0x08, priv->mmio + (0x0c << 2));
			writel(0x57, priv->mmio + (0x0d << 2));
			writel(0x40, priv->mmio + (0x0e << 2));
			writel(0x5f, priv->mmio + (0x0f << 2));
			writel(0x10, priv->mmio + (0x20 << 2));
		}
	}

	return 0;
}

static const struct rockchip_combphy_grfcfg rk3588_combphy_grfcfgs = {
	/* pipe-phy-grf */
	.pcie_mode_set		= { 0x0000, 5, 0, 0x00, 0x11 },
	.usb_mode_set		= { 0x0000, 5, 0, 0x00, 0x04 },
	.pipe_ebuff_mode	= { 0x0000, 10, 10, 0x00, 0x01 },
	.pipe_rxterm_set	= { 0x0000, 12, 12, 0x00, 0x01 },
	.pipe_txelec_set	= { 0x0004, 1, 1, 0x00, 0x01 },
	.pipe_txcomp_set	= { 0x0004, 4, 4, 0x00, 0x01 },
	.pipe_clk_24m		= { 0x0004, 14, 13, 0x00, 0x00 },
	.pipe_clk_25m		= { 0x0004, 14, 13, 0x00, 0x01 },
	.pipe_clk_100m		= { 0x0004, 14, 13, 0x00, 0x02 },
	.pipe_rxterm_sel	= { 0x0008, 8, 8, 0x00, 0x01 },
	.pipe_txelec_sel	= { 0x0008, 12, 12, 0x00, 0x01 },
	.pipe_txcomp_sel	= { 0x0008, 15, 15, 0x00, 0x01 },
	.pipe_clk_ext		= { 0x000c, 9, 8, 0x02, 0x01 },
	.pipe_phy_status	= { 0x0034, 6, 6, 0x01, 0x00 },
	.con0_for_pcie		= { 0x0000, 15, 0, 0x00, 0x1000 },
	.con1_for_pcie		= { 0x0004, 15, 0, 0x00, 0x0000 },
	.con2_for_pcie		= { 0x0008, 15, 0, 0x00, 0x0101 },
	.con3_for_pcie		= { 0x000c, 15, 0, 0x00, 0x0200 },
	.con0_for_sata		= { 0x0000, 15, 0, 0x00, 0x0129 },
	.con1_for_sata		= { 0x0004, 15, 0, 0x00, 0x0000 },
	.con2_for_sata		= { 0x0008, 15, 0, 0x00, 0x80c1 },
	.con3_for_sata		= { 0x000c, 15, 0, 0x00, 0x4407 },
	/* pipe-grf */
	.pipe_con0_for_sata	= { 0x0000, 11, 5, 0x00, 0x22 },
	.pipe_con1_for_sata	= { 0x0004, 2, 0, 0x00, 0x2 },
};

static const struct clk_bulk_data rk3588_clks[] = {
	{ .id = "refclk" },
	{ .id = "apbclk" },
	{ .id = "phpclk" },
};

static const struct rockchip_combphy_cfg rk3588_combphy_cfgs = {
	.num_clks	= ARRAY_SIZE(rk3588_clks),
	.clks		= rk3588_clks,
	.grfcfg		= &rk3588_combphy_grfcfgs,
	.combphy_cfg	= rk3588_combphy_cfg,
	.force_det_out	= true,
};

static const struct of_device_id rockchip_combphy_of_match[] = {
	{
		.compatible = "rockchip,rk3528-naneng-combphy",
		.data = &rk3528_combphy_cfgs,
	},
	{
		.compatible = "rockchip,rk3562-naneng-combphy",
		.data = &rk3562_combphy_cfgs,
	},
	{
		.compatible = "rockchip,rk3568-naneng-combphy",
		.data = &rk3568_combphy_cfgs,
	},
	{
		.compatible = "rockchip,rk3576-naneng-combphy",
		.data = &rk3576_combphy_cfgs,
	},
	{
		.compatible = "rockchip,rk3588-naneng-combphy",
		.data = &rk3588_combphy_cfgs,
	},
	{ },
};
MODULE_DEVICE_TABLE(of, rockchip_combphy_of_match);

static struct platform_driver rockchip_combphy_driver = {
	.probe	= rockchip_combphy_probe,
	.driver = {
		.name = "naneng-combphy",
		.of_match_table = rockchip_combphy_of_match,
	},
};
module_platform_driver(rockchip_combphy_driver);

MODULE_DESCRIPTION("Rockchip NANENG COMBPHY driver");
MODULE_LICENSE("GPL v2");
