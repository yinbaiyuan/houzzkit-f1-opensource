/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

#ifndef __STMMAC_PLATFORM_DATA
#define __STMMAC_PLATFORM_DATA

#define __iomem
typedef uint8_t		u8;
typedef int8_t		s8;
typedef uint16_t	u16;
typedef uint32_t	u32;
typedef int32_t		s32;
typedef uint64_t	u64;
#ifndef LINUX_MACROS
#ifndef BITS_PER_LONG
#define BITS_PER_LONG	(__SIZEOF_LONG__ * 8)
#endif
#ifndef BITS_PER_LONG_LONG
#define BITS_PER_LONG_LONG  (__SIZEOF_LONG_LONG__ * 8)
#endif
#ifndef BIT
#define BIT(a) (1UL << (a))
#endif /* BIT */
#ifndef BIT_ULL
#define BIT_ULL(a) (1ULL << (a))
#endif /* BIT_ULL */
#ifndef GENMASK
#define GENMASK(h, l)	(((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
#endif /* GENMASK */
#ifndef GENMASK_ULL
#define GENMASK_ULL(h, l) \
	(((~0ULL) << (l)) & (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
#endif /* GENMASK_ULL */
#endif /* LINUX_MACROS */
#define cpu_to_be16(o) rte_cpu_to_be_16(o)
#define cpu_to_be32(o) rte_cpu_to_be_32(o)
#define cpu_to_be64(o) rte_cpu_to_be_64(o)
#define cpu_to_le32(o) rte_cpu_to_le_32(o)
#define be16_to_cpu(o) rte_be_to_cpu_16(o)
#define be32_to_cpu(o) rte_be_to_cpu_32(o)
#define be64_to_cpu(o) rte_be_to_cpu_64(o)
#define le32_to_cpu(o) rte_le_to_cpu_32(o)
#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
#define DELAY(x) rte_delay_us(x)
#define udelay(x) DELAY(x)
#define msleep(x) DELAY(1000 * (x))
#define usleep_range(min, max) msleep(DIV_ROUND_UP(min, 1000))
#define lower_32_bits(x) ((uint32_t)(x))
#define upper_32_bits(x) ((uint32_t)(((x) >> 16) >> 16))
#define writel(v, p) rte_write32(v, (uint8_t *)p)//({*(volatile unsigned int *)(p) = (v); })
#define readl(p) rte_read32((uint8_t *)p)
#define min(a, b) RTE_MIN(a, b)
#define max(a, b) RTE_MAX(a, b)

#define MTL_MAX_RX_QUEUES	8
#define MTL_MAX_TX_QUEUES	8
#define STMMAC_CH_MAX		8

#define STMMAC_RX_COE_NONE	0
#define STMMAC_RX_COE_TYPE1	1
#define STMMAC_RX_COE_TYPE2	2

/* Define the macros for CSR clock range parameters to be passed by
 * platform code.
 * This could also be configured at run time using CPU freq framework. */

/* MDC Clock Selection define*/
#define	STMMAC_CSR_60_100M	0x0	/* MDC = clk_scr_i/42 */
#define	STMMAC_CSR_100_150M	0x1	/* MDC = clk_scr_i/62 */
#define	STMMAC_CSR_20_35M	0x2	/* MDC = clk_scr_i/16 */
#define	STMMAC_CSR_35_60M	0x3	/* MDC = clk_scr_i/26 */
#define	STMMAC_CSR_150_250M	0x4	/* MDC = clk_scr_i/102 */
#define	STMMAC_CSR_250_300M	0x5	/* MDC = clk_scr_i/122 */

/* MTL algorithms identifiers */
#define MTL_TX_ALGORITHM_WRR	0x0
#define MTL_TX_ALGORITHM_WFQ	0x1
#define MTL_TX_ALGORITHM_DWRR	0x2
#define MTL_TX_ALGORITHM_SP	0x3
#define MTL_RX_ALGORITHM_SP	0x4
#define MTL_RX_ALGORITHM_WSP	0x5

/* RX/TX Queue Mode */
#define MTL_QUEUE_AVB		0x0
#define MTL_QUEUE_DCB		0x1

/* The MDC clock could be set higher than the IEEE 802.3
 * specified frequency limit 0f 2.5 MHz, by programming a clock divider
 * of value different than the above defined values. The resultant MDIO
 * clock frequency of 12.5 MHz is applicable for the interfacing chips
 * supporting higher MDC clocks.
 * The MDC clock selection macros need to be defined for MDC clock rate
 * of 12.5 MHz, corresponding to the following selection.
 */
#define STMMAC_CSR_I_4		0x8	/* clk_csr_i/4 */
#define STMMAC_CSR_I_6		0x9	/* clk_csr_i/6 */
#define STMMAC_CSR_I_8		0xA	/* clk_csr_i/8 */
#define STMMAC_CSR_I_10		0xB	/* clk_csr_i/10 */
#define STMMAC_CSR_I_12		0xC	/* clk_csr_i/12 */
#define STMMAC_CSR_I_14		0xD	/* clk_csr_i/14 */
#define STMMAC_CSR_I_16		0xE	/* clk_csr_i/16 */
#define STMMAC_CSR_I_18		0xF	/* clk_csr_i/18 */

/* AXI DMA Burst length supported */
#define DMA_AXI_BLEN_4		(1 << 1)
#define DMA_AXI_BLEN_8		(1 << 2)
#define DMA_AXI_BLEN_16		(1 << 3)
#define DMA_AXI_BLEN_32		(1 << 4)
#define DMA_AXI_BLEN_64		(1 << 5)
#define DMA_AXI_BLEN_128	(1 << 6)
#define DMA_AXI_BLEN_256	(1 << 7)
#define DMA_AXI_BLEN_ALL (DMA_AXI_BLEN_4 | DMA_AXI_BLEN_8 | DMA_AXI_BLEN_16 \
			| DMA_AXI_BLEN_32 | DMA_AXI_BLEN_64 \
			| DMA_AXI_BLEN_128 | DMA_AXI_BLEN_256)

/* Platfrom data for platform device structure's platform_data field */

struct stmmac_mdio_bus_data {
	unsigned int phy_mask;
	unsigned int has_xpcs;
	int *irqs;
	int probed_phy_irq;
	bool needs_reset;
};

struct stmmac_dma_cfg {
	int pbl;
	int txpbl;
	int rxpbl;
	bool pblx8;
	int fixed_burst;
	int mixed_burst;
	bool aal;
	bool eame;
};

#define AXI_BLEN	7
struct stmmac_axi {
	bool axi_lpi_en;
	bool axi_xit_frm;
	uint32_t axi_wr_osr_lmt;
	uint32_t axi_rd_osr_lmt;
	bool axi_kbbe;
	uint32_t axi_blen[AXI_BLEN];
	bool axi_fb;
	bool axi_mb;
	bool axi_rb;
};

#define EST_GCL		1024
struct stmmac_est {
	int enable;
	uint32_t btr_offset[2];
	uint32_t btr[2];
	uint32_t ctr[2];
	uint32_t ter;
	uint32_t gcl_unaligned[EST_GCL];
	uint32_t gcl[EST_GCL];
	uint32_t gcl_size;
};

struct stmmac_rxq_cfg {
	uint8_t mode_to_use;
	uint32_t chan;
	uint8_t pkt_route;
	bool use_prio;
	uint32_t prio;
};

struct stmmac_txq_cfg {
	uint32_t weight;
	uint8_t mode_to_use;
	/* Credit Base Shaper parameters */
	uint32_t send_slope;
	uint32_t idle_slope;
	uint32_t high_credit;
	uint32_t low_credit;
	bool use_prio;
	uint32_t prio;
	int tbs_en;
};

struct plat_stmmacenet_data {
	int bus_id;
	struct stmmac_dma_cfg dma_cfg;
	struct stmmac_est *est;
	int clk_csr;
	int has_gmac;
	int has_gmac4;
	int enh_desc;
	int tx_coe;
	int rx_coe;
	int bugged_jumbo;
	int pmt;
	int force_sf_dma_mode;
	int force_thresh_dma_mode;
	int riwt_off;
	int max_speed;
	int maxmtu;
	int multicast_filter_bins;
	int unicast_filter_entries;
	int tx_fifo_size;
	int rx_fifo_size;
	uint32_t addr64;
	uint32_t rx_queues_to_use;
	uint32_t tx_queues_to_use;
	uint8_t rx_sched_algorithm;
	uint8_t tx_sched_algorithm;
	struct stmmac_rxq_cfg rx_queues_cfg[MTL_MAX_RX_QUEUES];
	struct stmmac_txq_cfg tx_queues_cfg[MTL_MAX_TX_QUEUES];
	void (*get_eth_addr)(void *priv, unsigned char *addr);
	struct mac_device_info *(*setup)(void *priv);
	uint32_t ptp_max_adj;
	struct stmmac_axi axi;
	bool tso_en;
	int rss_en;
	int mac_port_sel_speed;
	bool en_tx_lpi_clockgating;
	int has_xgmac;
	bool vlan_fail_q_en;
	uint8_t vlan_fail_q;
	unsigned int eee_usecs_rate;
	bool uio;
};
#endif
