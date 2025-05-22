/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <ethdev_vdev.h>
#include <ethdev_driver.h>
#include <rte_io.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include "stmmac_pmd_logs.h"
#include "stmmac_ethdev.h"
#include "stmmac_regs.h"
#include "common.h"
#include "stmmac_ptp.h"
#include "stmmac.h"
#include "hwif.h"

#define STMMAC_NAME_PMD                net_stmmac

/* FEC receive acceleration */
#define STMMAC_RACC_IPDIS		RTE_BIT32(1)
#define STMMAC_RACC_PRODIS		RTE_BIT32(2)
#define STMMAC_RACC_SHIFT16		RTE_BIT32(7)
#define STMMAC_RACC_OPTIONS		(STMMAC_RACC_IPDIS | \
					STMMAC_RACC_PRODIS)

#define STMMAC_PAUSE_FLAG_AUTONEG	0x1
#define STMMAC_PAUSE_FLAG_ENABLE	0x2

/* Pause frame field and FIFO threshold */
#define STMMAC_FCE			RTE_BIT32(5)
#define STMMAC_RSEM_V			0x84
#define STMMAC_RSFL_V			16
#define STMMAC_RAEM_V			0x8
#define STMMAC_RAFL_V			0x8
#define STMMAC_OPD_V			0xFFF0

#define TC_DEFAULT 64
static int tc = TC_DEFAULT;

/* Supported Rx offloads */
static uint64_t dev_rx_offloads_sup =
		RTE_ETH_RX_OFFLOAD_CHECKSUM |
		RTE_ETH_RX_OFFLOAD_VLAN;

static uint32_t
stmmac_get_id(struct stmmac_private *priv, uint32_t id_reg)
{
	uint32_t reg = rte_read32((uint8_t *)priv->ioaddr_v + id_reg);

	if (!reg) {
		STMMAC_PMD_ERR("Version ID not available\n");
		return 0x0;
	}

	STMMAC_PMD_INFO("User ID: 0x%x, Synopsys ID: 0x%x\n",
			(unsigned int)(reg & GENMASK(15, 8)) >> 8,
			(unsigned int)(reg & GENMASK(7, 0)));
	return reg & GENMASK(7, 0);
}

static const struct stmmac_hwif_entry {
	bool gmac;
	bool gmac4;
	uint32_t min_id;
	uint32_t dev_id;
	const struct stmmac_regs_off regs;
	const void *desc;
	const void *dma;
	const void *mac;
	const void *hwtimestamp;
	const void *mode;
	const void *tc;
	const void *mmc;
	int (*setup)(struct stmmac_private *priv);
	int (*quirks)(struct stmmac_private *priv);
} stmmac_hw[] = {
	{
		.gmac = false,
		.gmac4 = true,
		.min_id = DWMAC_CORE_4_10,
		.regs = {
			.ptp_off = PTP_GMAC4_OFFSET,
			.mmc_off = MMC_GMAC4_OFFSET,
		},
		.desc = &dwmac4_desc_ops,
		.dma = &dwmac410_dma_ops,
		.mac = &dwmac410_ops,
		.mode = &dwmac4_ring_mode_ops,
		.mmc = &dwmac_mmc_ops,
		.setup = dwmac4_setup,
	},
};

static int
stmmac_hwif_init(struct stmmac_private *priv)
{
	const struct stmmac_hwif_entry *entry;
	struct mac_device_info *mac;
	bool needs_setup = true;
	bool needs_gmac4;
	bool needs_gmac;
	uint32_t id;
	int i, ret;

	needs_gmac4 = priv->plat->has_gmac4;
	needs_gmac = priv->plat->has_gmac;

	if (needs_gmac) {
		id = stmmac_get_id(priv, GMAC_VERSION);
	} else if (needs_gmac4) {
		id = stmmac_get_id(priv, GMAC4_VERSION);
	} else {
		id = 0;
	}

	/* Save ID for later use */
	priv->synopsys_id = id;

	/* Lets assume some safe values first */
	priv->ptpaddr = (uint8_t *)priv->ioaddr_v +
		(needs_gmac4 ? PTP_GMAC4_OFFSET : PTP_GMAC3_X_OFFSET);
	priv->mmcaddr = (uint8_t *)priv->ioaddr_v +
		(needs_gmac4 ? MMC_GMAC4_OFFSET : MMC_GMAC3_X_OFFSET);

	mac = rte_zmalloc("mac_device_info", sizeof(*mac), 0);
	if (!mac)
		return -ENOMEM;

	/* Fallback to generic HW */
	for (i = ARRAY_SIZE(stmmac_hw) - 1; i >= 0; i--) {
		entry = &stmmac_hw[i];

		if (needs_gmac ^ entry->gmac)
			continue;
		if (needs_gmac4 ^ entry->gmac4)
			continue;
		/* Use synopsys_id var because some setups can override this */
		if (priv->synopsys_id < entry->min_id)
			continue;

		/* Only use generic HW helpers if needed */
		mac->desc = mac->desc ? : entry->desc;
		mac->dma = mac->dma ? : entry->dma;
		mac->mac = mac->mac ? : entry->mac;
		mac->ptp = mac->ptp ? : entry->hwtimestamp;
		mac->mode = mac->mode ? : entry->mode;
		mac->tc = mac->tc ? : entry->tc;
		mac->mmc = mac->mmc ? : entry->mmc;

		priv->hw = mac;
		priv->ptpaddr = (uint8_t *)priv->ioaddr_v + entry->regs.ptp_off;
		priv->mmcaddr = (uint8_t *)priv->ioaddr_v + entry->regs.mmc_off;

		/* Entry found */
		if (needs_setup) {
			ret = entry->setup(priv);
			if (ret)
				return ret;
		}

		return 0;
	}

	STMMAC_PMD_INFO("Failed to find HW IF (id=0x%x, gmac=%d/%d)\n",
			id, needs_gmac, needs_gmac4);
	return -EINVAL;
}

static void
stmmac_mac_enable_rx_queues(struct stmmac_private *priv)
{
	u32 rx_queues_count = priv->rx_queues_to_use;
	u32 queue;
	u8 mode;

	for (queue = 0; queue < rx_queues_count; queue++) {
		mode = priv->plat->rx_queues_cfg[queue].mode_to_use;
		stmmac_rx_queue_enable(priv, priv->hw, mode, queue);
	}
}

static void
stmmac_start_rx_dma(struct stmmac_private *priv, uint32_t chan)
{
	STMMAC_PMD_INFO("DMA RX processes started in channel %d\n", chan);
	stmmac_start_rx(priv, priv->ioaddr_v, chan);
}

static void
stmmac_start_tx_dma(struct stmmac_private *priv, uint32_t chan)
{
	STMMAC_PMD_INFO("DMA TX processes started in channel %d\n", chan);
	stmmac_start_tx(priv, priv->ioaddr_v, chan);
}

static void
stmmac_stop_rx_dma(struct stmmac_private *priv, uint32_t chan)
{
	STMMAC_PMD_INFO("DMA RX processes stopped in channel %d\n", chan);
	stmmac_stop_rx(priv, priv->ioaddr_v, chan);
}

/**
 * stmmac_stop_tx_dma - stop TX DMA channel
 * @priv: driver private structure
 * @chan: TX channel index
 * Description:
 * This stops a TX DMA channel
 */
static void
stmmac_stop_tx_dma(struct stmmac_private *priv, uint32_t chan)
{
	STMMAC_PMD_INFO("DMA TX processes stopped in channel %d\n", chan);
	stmmac_stop_tx(priv, priv->ioaddr_v, chan);
}

static void
stmmac_start_all_dma(struct stmmac_private *priv)
{
	uint32_t rx_channels_count = priv->rx_queues_to_use;
	uint32_t tx_channels_count = priv->tx_queues_to_use;
	uint32_t chan = 0;

	for (chan = 0; chan < rx_channels_count; chan++)
		stmmac_start_rx_dma(priv, chan);

	for (chan = 0; chan < tx_channels_count; chan++)
		stmmac_start_tx_dma(priv, chan);
}

static void
stmmac_stop_all_dma(struct stmmac_private *priv)
{
	uint32_t rx_channels_count = priv->rx_queues_to_use;
	uint32_t tx_channels_count = priv->tx_queues_to_use;
	uint32_t chan = 0;

	for (chan = 0; chan < rx_channels_count; chan++)
		stmmac_stop_rx_dma(priv, chan);

	for (chan = 0; chan < tx_channels_count; chan++)
		stmmac_stop_tx_dma(priv, chan);
}

static void
stmmac_dma_operation_mode(struct stmmac_private *priv)
{
	u32 rx_channels_count = priv->plat->rx_queues_to_use;
	u32 tx_channels_count = priv->plat->tx_queues_to_use;
	int rxfifosz = priv->plat->rx_fifo_size;
	int txfifosz = priv->plat->tx_fifo_size;
	u32 txmode = 0;
	u32 rxmode = 0;
	u32 chan = 0;
	u8 qmode = 0;

	if (rxfifosz == 0)
		rxfifosz = priv->dma_cap.rx_fifo_size;
	if (txfifosz == 0)
		txfifosz = priv->dma_cap.tx_fifo_size;

	/* Adjust for real per queue fifo size */
	rxfifosz /= rx_channels_count;
	txfifosz /= tx_channels_count;

	if (priv->plat->force_thresh_dma_mode) {
		txmode = tc;
		rxmode = tc;
	} else if (priv->plat->force_sf_dma_mode || priv->plat->tx_coe) {
		/*
		 * In case of GMAC, SF mode can be enabled
		 * to perform the TX COE in HW. This depends on:
		 * 1) TX COE if actually supported
		 * 2) There is no bugged Jumbo frame support
		 *    that needs to not insert csum in the TDES.
		 */
		txmode = SF_DMA_MODE;
		rxmode = SF_DMA_MODE;
	} else {
		txmode = tc;
		rxmode = SF_DMA_MODE;
	}

	/* configure all channels */
	for (chan = 0; chan < rx_channels_count; chan++) {
		qmode = priv->plat->rx_queues_cfg[chan].mode_to_use;
		stmmac_dma_rx_mode(priv, priv->ioaddr_v, rxmode, chan,
				rxfifosz, qmode);
		stmmac_set_dma_bfsize(priv, priv->ioaddr_v, priv->dma_buf_sz,
				chan);
	}

	for (chan = 0; chan < tx_channels_count; chan++) {
		qmode = priv->plat->tx_queues_cfg[chan].mode_to_use;
		stmmac_dma_tx_mode(priv, priv->ioaddr_v, txmode, chan,
				txfifosz, qmode);
	}
}

static int
stmmac_start(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;

	STMMAC_PMD_INFO("stmmac_start\n");

	/* Start the ball rolling... */
	stmmac_start_all_dma(private);

	rte_delay_us(200);

	return 0;
}

static void
stmmac_free_buffers(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;
	unsigned int i, q;
	struct rte_mbuf *mbuf;
	struct stmmac_rx_queue *rxq;
	struct stmmac_tx_queue *txq;

	for (q = 0; q < dev->data->nb_rx_queues; q++) {
		rxq = private->rx_queues[q];
		for (i = 0; i < rxq->dma_rx_size; i++) {
			mbuf = rxq->rx_mbuf[i];
			rxq->rx_mbuf[i] = NULL;
			rte_pktmbuf_free(mbuf);
		}
	}

	for (q = 0; q < dev->data->nb_tx_queues; q++) {
		txq = private->tx_queues[q];
		for (i = 0; i < txq->dma_tx_size; i++) {
			mbuf = txq->tx_mbuf[i];
			txq->tx_mbuf[i] = NULL;
			rte_pktmbuf_free(mbuf);
		}
	}
}

static int
stmmac_eth_configure(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;

	if (dev->data->dev_conf.rxmode.offloads & RTE_ETH_RX_OFFLOAD_CHECKSUM)
		private->flag_csum |= RX_FLAG_CSUM_EN;

	if (dev->data->dev_conf.rxmode.offloads & RTE_ETH_RX_OFFLOAD_KEEP_CRC)
		STMMAC_PMD_ERR("PMD does not support KEEP_CRC offload");

	return 0;
}

static int
stmmac_eth_start(struct rte_eth_dev *dev)
{
	stmmac_start(dev);
	dev->rx_pkt_burst = &stmmac_recv_pkts;
	dev->tx_pkt_burst = &stmmac_xmit_pkts;

	return 0;
}

static void
stmmac_disable(struct stmmac_private *private)
{
	stmmac_stop_all_dma(private);
}

static int
stmmac_eth_stop(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;
	struct stmmac_rx_queue *rxq;
	struct stmmac_tx_queue *txq;
	unsigned int q;

	dev->data->dev_started = 0;
	stmmac_disable(private);

	for (q = 0; q < dev->data->nb_rx_queues; q++) {
		STMMAC_PMD_ERR("stmmac_eth_stop rx queue");
		rxq = private->rx_queues[q];
		rxq->cur_rx = 0;
	}

	for (q = 0; q < dev->data->nb_tx_queues; q++) {
		STMMAC_PMD_ERR("stmmac_eth_stop tx queue");
		txq = private->tx_queues[q];
		txq->cur_tx = 0;
	}

	return 0;
}

static int
stmmac_eth_close(struct rte_eth_dev *dev)
{
	stmmac_free_buffers(dev);
	return 0;
}
static void
stmmac_mac_flow_ctrl(struct stmmac_private *priv, u32 duplex)
{
	u32 tx_cnt = priv->plat->tx_queues_to_use;

	stmmac_flow_ctrl(priv, priv->hw, duplex, priv->flow_ctrl,
			priv->pause, tx_cnt);
}

static void
stmmac_mac_link_up(struct stmmac_private *priv, unsigned int mode,
		  phy_interface_t interface, int speed, int duplex,
		  bool tx_pause, bool rx_pause)
{
	u32 ctrl;

	ctrl = readl(priv->ioaddr_v + MAC_CTRL_REG);
	ctrl &= ~priv->hw->link.speed_mask;

	switch (speed) {
	case SPEED_2500:
		ctrl |= priv->hw->link.speed2500;
		break;
	case SPEED_1000:
		ctrl |= priv->hw->link.speed1000;
		break;
	case SPEED_100:
		ctrl |= priv->hw->link.speed100;
		break;
	case SPEED_10:
		ctrl |= priv->hw->link.speed10;
		break;
	default:
		return;
	}

	priv->speed = speed;

	if (!duplex)
		ctrl &= ~priv->hw->link.duplex;
	else
		ctrl |= priv->hw->link.duplex;

	/* Flow Control operation */
	if (rx_pause && tx_pause)
		priv->flow_ctrl = FLOW_AUTO;
	else if (rx_pause && !tx_pause)
		priv->flow_ctrl = FLOW_RX;
	else if (!rx_pause && tx_pause)
		priv->flow_ctrl = FLOW_TX;
	else
		priv->flow_ctrl = FLOW_OFF;

	stmmac_mac_flow_ctrl(priv, duplex);

	writel(ctrl, priv->ioaddr_v + MAC_CTRL_REG);

	stmmac_mac_set(priv, priv->ioaddr_v, true);
}

static int
stmmac_eth_link_update(struct rte_eth_dev *dev,
			int wait_to_complete __rte_unused)
{
	struct stmmac_private *private = dev->data->dev_private;
	struct rte_eth_link link;
	unsigned int lstatus = 1;

	memset(&link, 0, sizeof(struct rte_eth_link));

	link.link_status = lstatus;
	link.link_speed = RTE_ETH_SPEED_NUM_1G;

	stmmac_mac_link_up(private, 0, PHY_INTERFACE_MODE_RGMII, SPEED_1000,
			  1, true, true);

	STMMAC_PMD_ERR("Port (%d) link is %s\n", dev->data->port_id, "Up");

	return rte_eth_linkstatus_set(dev, &link);
}

/* Set a MAC change in hardware. */
static int
stmmac_set_mac_address(struct rte_eth_dev *dev,
		    struct rte_ether_addr *addr)
{
	struct stmmac_private *private = dev->data->dev_private;

	/* Copy the MAC addr into the HW  */
	stmmac_set_umac_addr(private, private->hw, addr->addr_bytes, 0);

	rte_ether_addr_copy(addr, &dev->data->mac_addrs[0]);

	return 0;
}

static int
stmmac_stats_get(struct rte_eth_dev *dev, struct rte_eth_stats *stats)
{
	struct stmmac_private *private = dev->data->dev_private;
	struct rte_eth_stats *eth_stats = &private->stats;

	stats->ipackets = eth_stats->ipackets;
	stats->ibytes = eth_stats->ibytes;
	stats->ierrors = eth_stats->ierrors;
	stats->opackets = eth_stats->opackets;
	stats->obytes = eth_stats->obytes;
	stats->oerrors = eth_stats->oerrors;
	stats->rx_nombuf = eth_stats->rx_nombuf;

	return 0;
}

static int
stmmac_eth_info(__rte_unused struct rte_eth_dev *dev,
		struct rte_eth_dev_info *dev_info)
{
	dev_info->max_rx_pktlen = STMMAC_MAX_RX_PKT_LEN;
	dev_info->max_rx_queues = STMMAC_MAX_Q;
	dev_info->max_tx_queues = STMMAC_MAX_Q;
	dev_info->rx_offload_capa = dev_rx_offloads_sup;
	return 0;
}

static void
stmmac_free_queue(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;
	unsigned int i;

	for (i = 0; i < dev->data->nb_rx_queues; i++)
		rte_free(private->rx_queues[i]);
	for (i = 0; i < dev->data->nb_tx_queues; i++)
		rte_free(private->rx_queues[i]);
}

static void
stmmac_clear_rx_descriptors(struct stmmac_private *priv, uint32_t queue)
{
	struct stmmac_rx_queue *rx_q = priv->rx_queues[queue];
	unsigned int i;

	/* Clear the RX descriptors */
	for (i = 0; i < rx_q->dma_rx_size; i++)
		if (priv->extend_desc)
			stmmac_init_rx_desc(priv, &rx_q->dma_erx[i].basic,
					priv->use_riwt, priv->mode,
					(i == priv->dma_rx_size - 1),
					priv->dma_buf_sz);
		else
			stmmac_init_rx_desc(priv, &rx_q->dma_rx[i],
					priv->use_riwt, priv->mode,
					(i == priv->dma_rx_size - 1),
					priv->dma_buf_sz);
}

static void
stmmac_clear_tx_descriptors(struct stmmac_private *priv, uint32_t queue)
{
	struct stmmac_tx_queue *tx_q = priv->tx_queues[queue];
	unsigned int i;

	/* Clear the TX descriptors */
	for (i = 0; i < tx_q->dma_tx_size; i++) {
		int last = (i == (priv->dma_tx_size - 1));
		struct dma_desc *p;

		if (priv->extend_desc)
			p = &tx_q->dma_etx[i].basic;
		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
			p = &tx_q->dma_entx[i].basic;
		else
			p = &tx_q->dma_tx[i];

		stmmac_init_tx_desc(priv, p, priv->mode, last);
	}
}

static int
stmmac_init_rx_buffers(struct stmmac_private *priv, struct dma_desc *p,
		       struct rte_mbuf *buf)
{
	stmmac_set_desc_addr(priv, p, rte_cpu_to_le_32(rte_pktmbuf_iova(buf)));
	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
		stmmac_init_desc3(priv, p);

	return 0;
}

static int
stmmac_tx_queue_setup(struct rte_eth_dev *dev,
		      uint16_t queue_idx,
		      uint16_t nb_desc,
		      unsigned int socket_id __rte_unused,
		      const struct rte_eth_txconf *tx_conf)
{
	struct stmmac_private *private = dev->data->dev_private;
	struct stmmac_tx_queue *txq =  private->tx_queues[queue_idx];
	unsigned int i;
	int ret;

	/* Tx deferred start is not supported */
	if (tx_conf->tx_deferred_start) {
		STMMAC_PMD_ERR("Tx deferred start not supported\n");
		return -EINVAL;
	}

	/* allocate transmit queue */
	txq = rte_zmalloc(NULL, sizeof(*txq), RTE_CACHE_LINE_SIZE);
	if (txq == NULL) {
		STMMAC_PMD_ERR("transmit queue allocation failed\n");
		return -ENOMEM;
	}

	if (nb_desc > DMA_MAX_TX_SIZE) {
		nb_desc = DMA_MAX_TX_SIZE;
		STMMAC_PMD_WARN("modified the nb_desc to MAX_TX_BD_RING_SIZE\n");
	}

	txq->dma_tx_size = nb_desc;
	private->total_tx_ring_size += txq->dma_tx_size;
	private->tx_queues[queue_idx] = txq;
	txq->dma_tx = private->bd_addr_t_v;
	txq->dma_tx_phy = private->bd_addr_t_p;
	txq->private = private;

	txq->tx_mbuf_dma = rte_zmalloc(NULL, nb_desc * sizeof(struct stmmac_tx_info), 0);
	if (txq->tx_mbuf_dma == NULL) {
		STMMAC_PMD_ERR("transmit queue tx_mbuf_dma allocation failed\n");
		ret = -ENOMEM;
		goto fail;
	}

	stmmac_clear_tx_descriptors(private, queue_idx);
	STMMAC_PMD_INFO("%s nb_desc: %d, total_tx_ring_size: %d\n", __func__,
			nb_desc, private->total_tx_ring_size);

	for (i = 0; i <txq->dma_tx_size; i++) {
		struct dma_desc *p;
		if (private->extend_desc)
			p = &((txq->dma_etx + i)->basic);
		else if (txq->tbs & STMMAC_TBS_AVAIL)
			p = &((txq->dma_entx + i)->basic);
		else
			p = txq->dma_tx + i;

		stmmac_clear_desc(private, p);

		txq->tx_mbuf_dma[i].buf = 0;
		txq->tx_mbuf_dma[i].len = 0;
		txq->tx_mbuf_dma[i].last_segment = false;
		txq->tx_mbuf[i] = NULL;
	}

	txq->dirty_tx = 0;
	txq->cur_tx = 0;
	txq->mss = 0;

	dev->data->tx_queues[queue_idx] = private->tx_queues[queue_idx];

	stmmac_init_tx_chan(private, private->ioaddr_v, &private->plat->dma_cfg,
			    txq->dma_tx_phy, queue_idx);

	txq->tx_tail_addr = txq->dma_tx_phy;
	stmmac_set_tx_tail_ptr(private, private->ioaddr_v,
			       txq->tx_tail_addr, queue_idx);

	return 0;
fail:
	if (txq)
		rte_free(txq);

	return ret;
}

static int
stmmac_rx_queue_setup(struct rte_eth_dev *dev,
		      uint16_t queue_idx,
		      uint16_t nb_rx_desc,
		      unsigned int socket_id __rte_unused,
		      const struct rte_eth_rxconf *rx_conf,
		      struct rte_mempool *mb_pool)
{
	struct stmmac_private *private = dev->data->dev_private;
	struct stmmac_rx_queue *rxq;
	unsigned int i;
	int ret;

	/* Rx deferred start is not supported */
	if (rx_conf->rx_deferred_start) {
		STMMAC_PMD_ERR("Rx deferred start not supported\n");
		return -EINVAL;
	}

	/* allocate receive queue */
	rxq = rte_zmalloc(NULL, sizeof(*rxq), RTE_CACHE_LINE_SIZE);
	if (rxq == NULL) {
		STMMAC_PMD_ERR("receive queue allocation failed\n");
		return -ENOMEM;
	}

	if (nb_rx_desc > DMA_MAX_RX_SIZE) {
		nb_rx_desc = DMA_MAX_RX_SIZE;
		STMMAC_PMD_WARN("modified the nb_desc to MAX_RX_BD_RING_SIZE\n");
	}

	rxq->dma_rx_size = nb_rx_desc;
	private->total_rx_ring_size += rxq->dma_rx_size;
	private->rx_queues[queue_idx] = rxq;
	rxq->pool = mb_pool;
	rxq->private = private;
	rxq->queue_index = queue_idx;
	rxq->dma_rx = private->bd_addr_r_v;
	rxq->dma_rx_phy = private->bd_addr_r_p;

	STMMAC_PMD_INFO("%s nb_rx_desc: %d, total_rx_ring_size: %d\n",
			__func__, nb_rx_desc, private->total_rx_ring_size);

	stmmac_clear_rx_descriptors(private, queue_idx);

	for (i = 0; i < rxq->dma_rx_size; i++) {
		struct dma_desc *p;
		void *data;
		int size;
		/* Initialize Rx buffers from pktmbuf pool */
		struct rte_mbuf *mbuf = rte_pktmbuf_alloc(mb_pool);
		if (mbuf == NULL) {
			STMMAC_PMD_ERR("mbuf failed");
			ret = -ENOMEM;
			goto err_alloc;
		}
		data = rte_pktmbuf_mtod(mbuf, uint8_t *);
		for (size = 0; size <= STMMAC_ALIGN_LENGTH; size += 64) {
			dcivac((uint8_t *)data + i);
		}

		if (private->extend_desc)
			p = &((rxq->dma_erx + i)->basic);
		else
			p = rxq->dma_rx + i;

		stmmac_init_rx_buffers(private, p, mbuf);
		rxq->rx_mbuf[i] = mbuf;
	}

	rxq->cur_rx = 0;
	rxq->dirty_rx = (unsigned int)(i - private->dma_rx_size);

	/* Setup the chained descriptor addresses */
	if (private->mode == STMMAC_CHAIN_MODE) {
		if (private->extend_desc)
			stmmac_mode_init(private, rxq->dma_erx,
					 rxq->dma_rx_phy,
					 rxq->dma_rx_size, 1);
		else
			stmmac_mode_init(private, rxq->dma_rx,
					 rxq->dma_rx_phy,
					 rxq->dma_rx_size, 0);
	}

	stmmac_init_rx_chan(private, private->ioaddr_v, &private->plat->dma_cfg,
			   rxq->dma_rx_phy, queue_idx);

	dev->data->rx_queues[queue_idx] = private->rx_queues[queue_idx];
	rxq->rx_tail_addr = rxq->dma_rx_phy +
			    (rxq->dma_rx_size * sizeof(struct dma_desc));
	wmb();
	stmmac_set_rx_tail_ptr(private, private->ioaddr_v, rxq->rx_tail_addr, queue_idx);

	return 0;

err_alloc:
	rte_free(rxq);

	return ret;
}

static void
stmmac_mmc_setup(struct stmmac_private *priv)
{
	unsigned int mode = MMC_CNTRL_RESET_ON_READ | MMC_CNTRL_COUNTER_RESET |
			    MMC_CNTRL_PRESET | MMC_CNTRL_FULL_HALF_PRESET;

	stmmac_mmc_intr_all_mask(priv, priv->mmcaddr);

	if (priv->dma_cap.rmon) {
		stmmac_mmc_ctrl(priv, priv->mmcaddr, mode);
		memset(&priv->mmc, 0, sizeof(struct stmmac_counters));
	} else
		STMMAC_PMD_LOG(INFO, "No MAC Management Counters available\n");
}

static int
stmmac_get_hw_features(struct stmmac_private *priv)
{
	return stmmac_get_hw_feature(priv, priv->ioaddr_v, &priv->dma_cap) == 0;
}

static int
stmmac_init_dma_engine(struct stmmac_private *priv)
{
	unsigned int rx_channels_count = priv->rx_queues_to_use;
	unsigned int tx_channels_count = priv->tx_queues_to_use;
	unsigned int dma_csr_ch = max(rx_channels_count, tx_channels_count);
	unsigned int chan = 0;
	int ret = 0;

	ret = stmmac_reset(priv, priv->ioaddr_v);
	if (ret) {
		STMMAC_PMD_ERR("Failed to reset the dma\n");
		return ret;
	}
	/* DMA Configuration */
	stmmac_dma_init(priv, priv->ioaddr_v, &priv->plat->dma_cfg);

	/* see dwmac1000 if needed */
	stmmac_axi(priv, priv->ioaddr_v, &priv->plat->axi);

	/* DMA CSR Channel configuration */
	for (chan = 0; chan < dma_csr_ch; chan++)
		stmmac_init_chan(priv, priv->ioaddr_v, &priv->plat->dma_cfg, chan);

	return ret;
}

static void
stmmac_set_rings_length(struct stmmac_private *priv)
{
	unsigned int rx_channels_count = priv->rx_queues_to_use;
	unsigned int tx_channels_count = priv->tx_queues_to_use;
	unsigned int chan;

	/* set TX ring length */
	for (chan = 0; chan < tx_channels_count; chan++)
		stmmac_set_tx_ring_len(priv, priv->ioaddr_v,
				(priv->dma_tx_size - 1), chan);

	/* set RX ring length */
	for (chan = 0; chan < rx_channels_count; chan++)
		stmmac_set_rx_ring_len(priv, priv->ioaddr_v,
				(priv->dma_rx_size - 1), chan);
}

static void
stmmac_set_tx_queue_weight(struct stmmac_private *priv)
{
	u32 tx_queues_count = priv->plat->tx_queues_to_use;
	u32 weight;
	u32 queue;

	for (queue = 0; queue < tx_queues_count; queue++) {
		weight = priv->plat->tx_queues_cfg[queue].weight;
		stmmac_set_mtl_tx_queue_weight(priv, priv->hw, weight, queue);
	}
}

static void
stmmac_configure_cbs(struct stmmac_private *priv)
{
	u32 tx_queues_count = priv->tx_queues_to_use;
	u32 mode_to_use;
	u32 queue;

	/* queue 0 is reserved for legacy traffic */
	for (queue = 1; queue < tx_queues_count; queue++) {
		mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
		if (mode_to_use == MTL_QUEUE_DCB)
			continue;

		stmmac_config_cbs(priv, priv->hw,
				priv->plat->tx_queues_cfg[queue].send_slope,
				priv->plat->tx_queues_cfg[queue].idle_slope,
				priv->plat->tx_queues_cfg[queue].high_credit,
				priv->plat->tx_queues_cfg[queue].low_credit,
				queue);
	}
}

static void
stmmac_rx_queue_dma_chan_map(struct stmmac_private *priv)
{
	u32 rx_queues_count = priv->rx_queues_to_use;
	u32 queue;
	u32 chan;

	for (queue = 0; queue < rx_queues_count; queue++) {
		chan = priv->plat->rx_queues_cfg[queue].chan;
		stmmac_map_mtl_to_dma(priv, priv->hw, queue, chan);
	}
}

static void
stmmac_mac_config_rx_queues_prio(struct stmmac_private *priv)
{
	u32 rx_queues_count = priv->rx_queues_to_use;
	u32 queue;
	u32 prio;

	for (queue = 0; queue < rx_queues_count; queue++) {
		if (!priv->plat->rx_queues_cfg[queue].use_prio)
			continue;

		prio = priv->plat->rx_queues_cfg[queue].prio;
		stmmac_rx_queue_prio(priv, priv->hw, prio, queue);
	}
}

static void
stmmac_mac_config_tx_queues_prio(struct stmmac_private *priv)
{
	u32 tx_queues_count = priv->tx_queues_to_use;
	u32 queue;
	u32 prio;

	for (queue = 0; queue < tx_queues_count; queue++) {
		if (!priv->plat->tx_queues_cfg[queue].use_prio)
			continue;

		prio = priv->plat->tx_queues_cfg[queue].prio;
		stmmac_tx_queue_prio(priv, priv->hw, prio, queue);
	}
}

static void
stmmac_mac_config_rx_queues_routing(struct stmmac_private *priv)
{
	u32 rx_queues_count = priv->plat->rx_queues_to_use;
	u32 queue;
	u8 packet;

	for (queue = 0; queue < rx_queues_count; queue++) {
		/* no specific packet type routing specified for the queue */
		if (priv->plat->rx_queues_cfg[queue].pkt_route == 0x0)
			continue;

		packet = priv->plat->rx_queues_cfg[queue].pkt_route;
		stmmac_rx_queue_routing(priv, priv->hw, packet, queue);
	}
}

static void
stmmac_safety_feat_configuration(struct stmmac_private *priv)
{
	if (priv->dma_cap.asp) {
		STMMAC_PMD_LOG(INFO, "Enabling Safety Features\n");
		stmmac_safety_feat_config(priv, priv->ioaddr_v, priv->dma_cap.asp);
	} else {
		STMMAC_PMD_LOG(INFO, "No Safety Features support found\n");
	}
}

static void
stmmac_mtl_configuration(struct stmmac_private *priv)
{
	u32 rx_queues_count = priv->plat->rx_queues_to_use;
	u32 tx_queues_count = priv->plat->tx_queues_to_use;

	if (tx_queues_count > 1)
		stmmac_set_tx_queue_weight(priv);

	/* Configure MTL RX algorithms */
	if (rx_queues_count > 1)
		stmmac_prog_mtl_rx_algorithms(priv, priv->hw,
				priv->plat->rx_sched_algorithm);

	/* Configure MTL TX algorithms */
	if (tx_queues_count > 1)
		stmmac_prog_mtl_tx_algorithms(priv, priv->hw,
				priv->plat->tx_sched_algorithm);

	/* Configure CBS in AVB TX queues */
	if (tx_queues_count > 1)
		stmmac_configure_cbs(priv);

	/* Map RX MTL to DMA channels */
	stmmac_rx_queue_dma_chan_map(priv);

	/* Enable MAC RX Queues */
	stmmac_mac_enable_rx_queues(priv);

	/* Set RX priorities */
	if (rx_queues_count > 1)
		stmmac_mac_config_rx_queues_prio(priv);

	/* Set TX priorities */
	if (tx_queues_count > 1)
		stmmac_mac_config_tx_queues_prio(priv);

	/* Set RX routing */
	if (rx_queues_count > 1)
		stmmac_mac_config_rx_queues_routing(priv);
}

static int
stmmac_hw_setup(struct rte_eth_dev *dev)
{
	struct stmmac_private *priv = dev->data->dev_private;
	unsigned int rx_cnt = priv->rx_queues_to_use;
	unsigned int tx_cnt = priv->tx_queues_to_use;
	unsigned int chan;
	int ret;

	/* DMA initialization and SW reset */
	ret = stmmac_init_dma_engine(priv);
	if (ret < 0) {
		STMMAC_PMD_ERR("%s: DMA engine initialization failed\n",
			   __func__);
		return ret;
	}

	/* Initialize the MAC Core */
	stmmac_core_init(priv, priv->hw, priv);

	/* Initialize MTL*/
	stmmac_mtl_configuration(priv);

	/* Initialize Safety Features */
	stmmac_safety_feat_configuration(priv);

	ret = stmmac_rx_ipc(priv, priv->hw);
	if (!ret) {
		STMMAC_PMD_WARN("RX IPC Checksum Offload disabled\n");
		priv->plat->rx_coe = STMMAC_RX_COE_NONE;
		priv->hw->rx_csum = 0;
	}

	/* Enable the MAC Rx/Tx */
	stmmac_mac_set(priv, priv->ioaddr_v, true);

	/* Set the HW DMA mode and the COE */
	stmmac_dma_operation_mode(priv);

	stmmac_mmc_setup(priv);

	if (priv->use_riwt) {
		ret = stmmac_rx_watchdog(priv, priv->ioaddr_v, MAX_DMA_RIWT, rx_cnt);
		if (!ret)
			priv->rx_riwt = MAX_DMA_RIWT;
	}

	/* set TX and RX rings length */
	stmmac_set_rings_length(priv);

	/* Enable TSO */
	if (priv->plat->tso_en) {
		for (chan = 0; chan < tx_cnt; chan++)
			stmmac_enable_tso(priv, priv->ioaddr_v, 1, chan);
	}

	return 0;
}

#define GMAC_PACKET_FILTER		0x00000008
#define GMAC_PACKET_FILTER_PR		BIT(0)

static int
stmmac_promiscuous_enable(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;
	uint32_t tmp;

	private->flags |= IFF_PROMISC;
	tmp = rte_read32((uint8_t *)private->ioaddr_v + GMAC_PACKET_FILTER);
	tmp |= GMAC_PACKET_FILTER_PR;
	rte_write32(rte_cpu_to_le_32(tmp),
		(uint8_t *)private->ioaddr_v + GMAC_PACKET_FILTER);

	return 0;
}

static int
stmmac_promiscuous_disable(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;
	uint32_t tmp;

	private->flags &= ~IFF_PROMISC;
	tmp = rte_read32((uint8_t *)private->ioaddr_v + GMAC_PACKET_FILTER);
	tmp &= ~GMAC_PACKET_FILTER_PR;
	rte_write32(rte_cpu_to_le_32(tmp),
		(uint8_t *)private->ioaddr_v + GMAC_PACKET_FILTER);

	return 0;
}

static int
stmmac_allmulticast_enable(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;

	private->flags |= IFF_ALLMULTI;
	/* To-do */

	return 0;
}

static int
stmmac_allmulticast_disable(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;

	private->flags &= ~IFF_ALLMULTI;
	/* To-do */

	return 0;
}
static const struct eth_dev_ops stmmac_dev_ops = {
	.dev_configure          = stmmac_eth_configure,
	.dev_start              = stmmac_eth_start,
	.dev_stop               = stmmac_eth_stop,
	.dev_close              = stmmac_eth_close,
	.link_update            = stmmac_eth_link_update,
	.promiscuous_enable     = stmmac_promiscuous_enable,
	.promiscuous_disable	= stmmac_promiscuous_disable,
	.allmulticast_enable	= stmmac_allmulticast_enable,
	.allmulticast_disable	= stmmac_allmulticast_disable,
	.mac_addr_set           = stmmac_set_mac_address,
	.stats_get              = stmmac_stats_get,
	.dev_infos_get          = stmmac_eth_info,
	.rx_queue_setup         = stmmac_rx_queue_setup,
	.tx_queue_setup         = stmmac_tx_queue_setup
};

static int
stmmac_eth_init(struct rte_eth_dev *dev)
{
	struct stmmac_private *private = dev->data->dev_private;
	int ret;

	ret = stmmac_hw_setup(dev);
	if (ret < 0) {
		STMMAC_PMD_ERR("%s failed: %d\n", __func__, ret);
		return ret;
	}

	private->full_duplex = FULL_DUPLEX;
	dev->dev_ops = &stmmac_dev_ops;
	rte_eth_dev_probing_finish(dev);

	return 0;
}

static int
stmmac_hw_init(struct stmmac_private *priv)
{
	int ret;

	/* Initialize HW Interface */
	ret = stmmac_hwif_init(priv);
	if (ret)
		return ret;

	/* Get the HW capability (new GMAC newer than 3.50a) */
	priv->hw_cap_support = stmmac_get_hw_features(priv);
	if (priv->hw_cap_support) {
		STMMAC_PMD_LOG(INFO, "DMA HW capability register supported\n");

		/* We can override some gmac/dma configuration fields: e.g.
		 * enh_desc, tx_coe (e.g. that are passed through the
		 * platform) with the values from the HW capability
		 * register (if supported).
		 */
		priv->plat->enh_desc = priv->dma_cap.enh_desc;
		priv->plat->pmt = priv->dma_cap.pmt_remote_wake_up;
		priv->hw->pmt = priv->plat->pmt;

		/* TXCOE doesn't work in thresh DMA mode */
		if (priv->plat->force_thresh_dma_mode)
			priv->plat->tx_coe = 0;
		else
			priv->plat->tx_coe = priv->dma_cap.tx_coe;

		/* In case of GMAC4 rx_coe is from HW cap register. */
		priv->plat->rx_coe = priv->dma_cap.rx_coe;

		if (priv->dma_cap.rx_coe_type2)
			priv->plat->rx_coe = STMMAC_RX_COE_TYPE2;
		else if (priv->dma_cap.rx_coe_type1)
			priv->plat->rx_coe = STMMAC_RX_COE_TYPE1;
	} else {
		STMMAC_PMD_LOG(INFO, "No HW DMA feature register supported\n");
	}

	if (priv->plat->rx_coe) {
		priv->hw->rx_csum = priv->plat->rx_coe;
		STMMAC_PMD_LOG(INFO, "RX Checksum Offload Engine supported\n");
		if (priv->synopsys_id < DWMAC_CORE_4_00)
			STMMAC_PMD_LOG(INFO, "COE Type %d\n", priv->hw->rx_csum);
	}
	if (priv->plat->tx_coe)
		STMMAC_PMD_LOG(INFO, "TX Checksum insertion supported\n");

	if (priv->dma_cap.tsoen) {
		STMMAC_PMD_LOG(INFO, "TSO supported\n");
		priv->plat->tso_en = true;
	}

	/* Run HW quirks, if any */
	if (priv->hwif_quirks) {
		ret = priv->hwif_quirks(priv);
		if (ret)
			return ret;
	}

	/* Rx Watchdog is available in the COREs newer than the 3.40.
	 * In some case, for example on bugged HW this feature
	 * has to be disable and this can be done by passing the
	 * riwt_off field from the platform.
	 */
	if (((priv->synopsys_id >= DWMAC_CORE_3_50) ||
	    (priv->plat->has_xgmac)) && (!priv->plat->riwt_off)) {
		priv->use_riwt = 1;
		STMMAC_PMD_LOG(INFO,
			 "Enable RX Mitigation via HW Watchdog Timer\n");
	}

	return 0;
}

static void
stmmac_hw_config_init(struct stmmac_private *priv)
{
	priv->plat->rx_queues_to_use = STMMAC_MAX_Q;
	priv->plat->tx_queues_to_use = STMMAC_MAX_Q;

	priv->plat->has_gmac4 = true;
	priv->plat->has_gmac = false;

	/* mtu 1500 */
	priv->dma_buf_sz = 1536;

	priv->plat->force_thresh_dma_mode = 0;

	priv->plat->tx_queues_cfg[0].mode_to_use = MTL_QUEUE_DCB;
	priv->plat->rx_queues_cfg[0].mode_to_use = MTL_QUEUE_DCB;

	/* DMA cfg */
	priv->plat->dma_cfg.pbl = 8;
	priv->plat->dma_cfg.pblx8 = 1;
	priv->plat->dma_cfg.mixed_burst = 1;

	/* axi */
	priv->plat->axi.axi_wr_osr_lmt = 4;
	priv->plat->axi.axi_rd_osr_lmt = 8;
	priv->plat->axi.axi_blen[4] = 16;
	priv->plat->axi.axi_blen[5] = 8;
	priv->plat->axi.axi_blen[6] = 4;
}

static int
pmd_stmmac_probe(struct rte_vdev_device *vdev)
{
	struct rte_eth_dev *dev = NULL;
	struct stmmac_private *private;
	const char *name;
	struct rte_ether_addr macaddr = {
		.addr_bytes = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 }
	};
	int rc, i, id = 0, fd = socket(AF_INET, SOCK_DGRAM, 0);
	struct ifreq req;
	char if_name[16] = {0};

	name = rte_vdev_device_name(vdev);
	STMMAC_PMD_LOG(INFO, "Initializing pmd_stmmac for %s\n", name);

	if (strncmp(name, RTE_STR(STMMAC_NAME_PMD), sizeof(RTE_STR(STMMAC_NAME_PMD))) > 0) {
		sscanf(&name[strlen(RTE_STR(STMMAC_NAME_PMD))], "%d", &id);
		STMMAC_PMD_LOG(INFO, "Initializing pmd_stmmac for id %d\n", id);
	}

	dev = rte_eth_vdev_allocate(vdev, sizeof(*private));
	if (dev == NULL)
		return -ENOMEM;
	private = dev->data->dev_private;
	private->dev = dev;

	private->plat = rte_zmalloc("plat_stmmacenet_data", sizeof(*private->plat), 0);
	if (private->plat == NULL) {
		rc = -ENOMEM;
		goto err;
	}

	/* setup board info structure */
	stmmac_hw_config_init(private);

	rc = stmmac_configure(private, id);
	if (rc != 0)
		return -ENOMEM;
	rc = config_stmmac_uio(private);
	if (rc != 0)
		return -ENOMEM;

	private->rx_queues_to_use = private->plat->rx_queues_to_use;
	private->tx_queues_to_use = private->plat->tx_queues_to_use;

	for (i = 0; i < private->rx_queues_to_use; i++) {
		private->desc_addr_p_r[i] = private->bd_addr_r_p;
		private->dma_baseaddr_v_r[i] = private->bd_addr_r_v;
		private->bd_addr_r_v = (uint8_t *)private->bd_addr_r_v + private->bd_r_size[i] * i;
		private->bd_addr_r_p = private->bd_addr_r_p + private->bd_r_size[i] * i;
	}

	for (i = 0; i < private->tx_queues_to_use; i++) {
		private->desc_addr_p_t[i] = private->bd_addr_t_p;
		private->dma_baseaddr_v_t[i] = private->bd_addr_t_v;
		private->bd_addr_t_v = (uint8_t *)private->bd_addr_t_v + private->bd_t_size[i] * i;
		private->bd_addr_t_p = private->bd_addr_t_p + private->bd_t_size[i] * i;
	}

	/* Copy the station address into the dev structure, */
	dev->data->mac_addrs = rte_zmalloc("mac_addr", RTE_ETHER_ADDR_LEN, 0);
	if (dev->data->mac_addrs == NULL) {
		STMMAC_PMD_ERR("Failed to allocate mem %d to store MAC addresses\n",
			       RTE_ETHER_ADDR_LEN);
		rc = -ENOMEM;
		goto err;
	}

	/* Initialize HW Interface */
	rc  = stmmac_hw_init(private);
	if (rc )
		goto err;

	rc = stmmac_eth_init(dev);
	if (rc)
		goto failed_init;

	memset(&req, 0, sizeof(req));
	snprintf(if_name, sizeof(if_name), "%s%d", "eth", id);
	strcpy(req.ifr_name, if_name);
	rc = ioctl(fd, SIOCGIFHWADDR, &req);
	if (rc)
		goto failed_init;
	memcpy(macaddr.addr_bytes,
	       req.ifr_addr.sa_data, RTE_ETHER_ADDR_LEN);
	/*
	 * Set default mac address
	 */
	stmmac_set_mac_address(dev, &macaddr);

	return 0;

failed_init:
	if (private->plat)
	rte_free(private->plat);
		STMMAC_PMD_ERR("Failed to init");
err:
	rte_eth_dev_release_port(dev);

	return rc;
}

static int
pmd_stmmac_remove(struct rte_vdev_device *vdev)
{
	struct rte_eth_dev *eth_dev = NULL;
	struct stmmac_private *private;
	int ret;

	/* find the ethdev entry */
	eth_dev = rte_eth_dev_allocated(rte_vdev_device_name(vdev));
	if (eth_dev == NULL)
		return -ENODEV;

	private = eth_dev->data->dev_private;
	/* Free descriptor base of first RX queue as it was configured
	 * first in stmmac_eth_init().
	 */
	stmmac_free_queue(eth_dev);
	stmmac_eth_stop(eth_dev);

	ret = rte_eth_dev_release_port(eth_dev);
	if (ret != 0)
		return -EINVAL;

	STMMAC_PMD_INFO("Release stmmac sw device");
	stmmac_cleanup(private);

	return 0;
}

static struct rte_vdev_driver pmd_stmmac_drv = {
	.probe = pmd_stmmac_probe,
	.remove = pmd_stmmac_remove,
};

RTE_PMD_REGISTER_VDEV(STMMAC_NAME_PMD, pmd_stmmac_drv);
RTE_LOG_REGISTER_DEFAULT(stmmac_logtype_pmd, NOTICE);
