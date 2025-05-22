/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

#ifndef __COMMON_H__
#define __COMMON_H__

#include <rte_io.h>
#include <net/if.h>
#include "stmmac_pmd_logs.h"
#include "descs.h"
#include "hwif.h"
#include "mmc.h"
#include "stmmac.h"
#include "stmmac_uio.h"

#define SPEED_10		10
#define SPEED_100		100
#define SPEED_1000		1000
#define SPEED_2500		2500
#define SPEED_5000		5000
#define SPEED_10000		10000
#define SPEED_14000		14000
#define SPEED_20000		20000
#define SPEED_25000		25000
#define SPEED_40000		40000
#define SPEED_50000		50000
#define SPEED_56000		56000
#define SPEED_100000		100000

/* Synopsys Core versions */
#define	DWMAC_CORE_3_40		0x34
#define	DWMAC_CORE_3_50		0x35
#define	DWMAC_CORE_4_00		0x40
#define DWMAC_CORE_4_10		0x41
#define DWMAC_CORE_5_00		0x50
#define DWMAC_CORE_5_10		0x51
#define DWXGMAC_CORE_2_10	0x21
#define DWXLGMAC_CORE_2_00	0x20

/* Device ID */
#define DWXGMAC_ID		0x76
#define DWXLGMAC_ID		0x27

#define STMMAC_CHAN0		0	/* Always supported and default for all chips */

/* TX and RX Descriptor Length, these need to be power of two.
 * TX descriptor length less than 64 may cause transmit queue timed out error.
 * RX descriptor length less than 64 may cause inconsistent Rx chain error.
 */
#define DMA_MIN_TX_SIZE		64
#define DMA_MAX_TX_SIZE		1024
#define DMA_DEFAULT_TX_SIZE	1024
#define DMA_MIN_RX_SIZE		64
#define DMA_MAX_RX_SIZE		1024
#define DMA_DEFAULT_RX_SIZE	1024
#define STMMAC_GET_ENTRY(x, size)	((x + 1) & (size - 1))

#undef FRAME_FILTER_DEBUG
/* #define FRAME_FILTER_DEBUG */

/* Extra statistic and debug information exposed by ethtool */
struct stmmac_extra_stats {
	/* Transmit errors */
	unsigned long tx_underflow;
	unsigned long tx_carrier;
	unsigned long tx_losscarrier;
	unsigned long vlan_tag;
	unsigned long tx_deferred;
	unsigned long tx_vlan;
	unsigned long tx_jabber;
	unsigned long tx_frame_flushed;
	unsigned long tx_payload_error;
	unsigned long tx_ip_header_error;
	/* Receive errors */
	unsigned long rx_desc;
	unsigned long sa_filter_fail;
	unsigned long overflow_error;
	unsigned long ipc_csum_error;
	unsigned long rx_collision;
	unsigned long rx_crc_errors;
	unsigned long dribbling_bit;
	unsigned long rx_length;
	unsigned long rx_mii;
	unsigned long rx_multicast;
	unsigned long rx_gmac_overflow;
	unsigned long rx_watchdog;
	unsigned long da_rx_filter_fail;
	unsigned long sa_rx_filter_fail;
	unsigned long rx_missed_cntr;
	unsigned long rx_overflow_cntr;
	unsigned long rx_vlan;
	unsigned long rx_split_hdr_pkt_n;
	/* Tx/Rx IRQ error info */
	unsigned long tx_undeflow_irq;
	unsigned long tx_process_stopped_irq;
	unsigned long tx_jabber_irq;
	unsigned long rx_overflow_irq;
	unsigned long rx_buf_unav_irq;
	unsigned long rx_process_stopped_irq;
	unsigned long rx_watchdog_irq;
	unsigned long tx_early_irq;
	unsigned long fatal_bus_error_irq;
	/* Tx/Rx IRQ Events */
	unsigned long rx_early_irq;
	unsigned long threshold;
	unsigned long tx_pkt_n;
	unsigned long rx_pkt_n;
	unsigned long normal_irq_n;
	unsigned long rx_normal_irq_n;
	unsigned long napi_poll;
	unsigned long tx_normal_irq_n;
	unsigned long tx_clean;
	unsigned long tx_set_ic_bit;
	unsigned long irq_receive_pmt_irq_n;
	/* MMC info */
	unsigned long mmc_tx_irq_n;
	unsigned long mmc_rx_irq_n;
	unsigned long mmc_rx_csum_offload_irq_n;
	/* EEE */
	unsigned long irq_tx_path_in_lpi_mode_n;
	unsigned long irq_tx_path_exit_lpi_mode_n;
	unsigned long irq_rx_path_in_lpi_mode_n;
	unsigned long irq_rx_path_exit_lpi_mode_n;
	unsigned long phy_eee_wakeup_error_n;
	/* Extended RDES status */
	unsigned long ip_hdr_err;
	unsigned long ip_payload_err;
	unsigned long ip_csum_bypassed;
	unsigned long ipv4_pkt_rcvd;
	unsigned long ipv6_pkt_rcvd;
	unsigned long no_ptp_rx_msg_type_ext;
	unsigned long ptp_rx_msg_type_sync;
	unsigned long ptp_rx_msg_type_follow_up;
	unsigned long ptp_rx_msg_type_delay_req;
	unsigned long ptp_rx_msg_type_delay_resp;
	unsigned long ptp_rx_msg_type_pdelay_req;
	unsigned long ptp_rx_msg_type_pdelay_resp;
	unsigned long ptp_rx_msg_type_pdelay_follow_up;
	unsigned long ptp_rx_msg_type_announce;
	unsigned long ptp_rx_msg_type_management;
	unsigned long ptp_rx_msg_pkt_reserved_type;
	unsigned long ptp_frame_type;
	unsigned long ptp_ver;
	unsigned long timestamp_dropped;
	unsigned long av_pkt_rcvd;
	unsigned long av_tagged_pkt_rcvd;
	unsigned long vlan_tag_priority_val;
	unsigned long l3_filter_match;
	unsigned long l4_filter_match;
	unsigned long l3_l4_filter_no_match;
	/* PCS */
	unsigned long irq_pcs_ane_n;
	unsigned long irq_pcs_link_n;
	unsigned long irq_rgmii_n;
	unsigned long pcs_link;
	unsigned long pcs_duplex;
	unsigned long pcs_speed;
	/* debug register */
	unsigned long mtl_tx_status_fifo_full;
	unsigned long mtl_tx_fifo_not_empty;
	unsigned long mmtl_fifo_ctrl;
	unsigned long mtl_tx_fifo_read_ctrl_write;
	unsigned long mtl_tx_fifo_read_ctrl_wait;
	unsigned long mtl_tx_fifo_read_ctrl_read;
	unsigned long mtl_tx_fifo_read_ctrl_idle;
	unsigned long mac_tx_in_pause;
	unsigned long mac_tx_frame_ctrl_xfer;
	unsigned long mac_tx_frame_ctrl_idle;
	unsigned long mac_tx_frame_ctrl_wait;
	unsigned long mac_tx_frame_ctrl_pause;
	unsigned long mac_gmii_tx_proto_engine;
	unsigned long mtl_rx_fifo_fill_level_full;
	unsigned long mtl_rx_fifo_fill_above_thresh;
	unsigned long mtl_rx_fifo_fill_below_thresh;
	unsigned long mtl_rx_fifo_fill_level_empty;
	unsigned long mtl_rx_fifo_read_ctrl_flush;
	unsigned long mtl_rx_fifo_read_ctrl_read_data;
	unsigned long mtl_rx_fifo_read_ctrl_status;
	unsigned long mtl_rx_fifo_read_ctrl_idle;
	unsigned long mtl_rx_fifo_ctrl_active;
	unsigned long mac_rx_frame_ctrl_fifo;
	unsigned long mac_gmii_rx_proto_engine;
	/* TSO */
	unsigned long tx_tso_frames;
	unsigned long tx_tso_nfrags;
};

/* Safety Feature statistics exposed by ethtool */
struct stmmac_safety_stats {
	unsigned long mac_errors[32];
	unsigned long mtl_errors[32];
	unsigned long dma_errors[32];
};

/* Number of fields in Safety Stats */
#define STMMAC_SAFETY_FEAT_SIZE	\
	(sizeof(struct stmmac_safety_stats) / sizeof(unsigned long))

/* CSR Frequency Access Defines*/
#define CSR_F_35M	35000000
#define CSR_F_60M	60000000
#define CSR_F_100M	100000000
#define CSR_F_150M	150000000
#define CSR_F_250M	250000000
#define CSR_F_300M	300000000

#define	MAC_CSR_H_FRQ_MASK	0x20

#define HASH_TABLE_SIZE 64
#define PAUSE_TIME 0xffff

/* Flow Control defines */
#define FLOW_OFF	0
#define FLOW_RX		1
#define FLOW_TX		2
#define FLOW_AUTO	(FLOW_TX | FLOW_RX)

/* PCS defines */
#define STMMAC_PCS_RGMII	(1 << 0)
#define STMMAC_PCS_SGMII	(1 << 1)
#define STMMAC_PCS_TBI		(1 << 2)
#define STMMAC_PCS_RTBI		(1 << 3)

#define SF_DMA_MODE 1		/* DMA STORE-AND-FORWARD Operation Mode */

/* DAM HW feature register fields */
#define DMA_HW_FEAT_MIISEL	0x00000001	/* 10/100 Mbps Support */
#define DMA_HW_FEAT_GMIISEL	0x00000002	/* 1000 Mbps Support */
#define DMA_HW_FEAT_HDSEL	0x00000004	/* Half-Duplex Support */
#define DMA_HW_FEAT_EXTHASHEN	0x00000008	/* Expanded DA Hash Filter */
#define DMA_HW_FEAT_HASHSEL	0x00000010	/* HASH Filter */
#define DMA_HW_FEAT_ADDMAC	0x00000020	/* Multiple MAC Addr Reg */
#define DMA_HW_FEAT_PCSSEL	0x00000040	/* PCS registers */
#define DMA_HW_FEAT_L3L4FLTREN	0x00000080	/* Layer 3 & Layer 4 Feature */
#define DMA_HW_FEAT_SMASEL	0x00000100	/* SMA(MDIO) Interface */
#define DMA_HW_FEAT_RWKSEL	0x00000200	/* PMT Remote Wakeup */
#define DMA_HW_FEAT_MGKSEL	0x00000400	/* PMT Magic Packet */
#define DMA_HW_FEAT_MMCSEL	0x00000800	/* RMON Module */
#define DMA_HW_FEAT_TSVER1SEL	0x00001000	/* Only IEEE 1588-2002 */
#define DMA_HW_FEAT_TSVER2SEL	0x00002000	/* IEEE 1588-2008 PTPv2 */
#define DMA_HW_FEAT_EEESEL	0x00004000	/* Energy Efficient Ethernet */
#define DMA_HW_FEAT_AVSEL	0x00008000	/* AV Feature */
#define DMA_HW_FEAT_TXCOESEL	0x00010000	/* Checksum Offload in Tx */
#define DMA_HW_FEAT_RXTYP1COE	0x00020000	/* IP COE (Type 1) in Rx */
#define DMA_HW_FEAT_RXTYP2COE	0x00040000	/* IP COE (Type 2) in Rx */
#define DMA_HW_FEAT_RXFIFOSIZE	0x00080000	/* Rx FIFO > 2048 Bytes */
#define DMA_HW_FEAT_RXCHCNT	0x00300000	/* No. additional Rx Channels */
#define DMA_HW_FEAT_TXCHCNT	0x00c00000	/* No. additional Tx Channels */
#define DMA_HW_FEAT_ENHDESSEL	0x01000000	/* Alternate Descriptor */
/* Timestamping with Internal System Time */
#define DMA_HW_FEAT_INTTSEN	0x02000000
#define DMA_HW_FEAT_FLEXIPPSEN	0x04000000	/* Flexible PPS Output */
#define DMA_HW_FEAT_SAVLANINS	0x08000000	/* Source Addr or VLAN */
#define DMA_HW_FEAT_ACTPHYIF	0x70000000	/* Active/selected PHY iface */
#define DEFAULT_DMA_PBL		8

/* PCS status and mask defines */
#define	PCS_ANE_IRQ		BIT(2)	/* PCS Auto-Negotiation */
#define	PCS_LINK_IRQ		BIT(1)	/* PCS Link */
#define	PCS_RGSMIIIS_IRQ	BIT(0)	/* RGMII or SMII Interrupt */

/* Max/Min RI Watchdog Timer count value */
#define MAX_DMA_RIWT		0xff
#define MIN_DMA_RIWT		0x10
#define DEF_DMA_RIWT		0xa0
/* Tx coalesce parameters */
#define STMMAC_COAL_TX_TIMER	1000
#define STMMAC_MAX_COAL_TX_TICK	100000
#define STMMAC_TX_MAX_FRAMES	256
#define STMMAC_TX_FRAMES	25
#define STMMAC_RX_FRAMES	0

/* Packets types */
enum packets_types {
	PACKET_AVCPQ = 0x1, /* AV Untagged Control packets */
	PACKET_PTPQ = 0x2, /* PTP Packets */
	PACKET_DCBCPQ = 0x3, /* DCB Control Packets */
	PACKET_UPQ = 0x4, /* Untagged Packets */
	PACKET_MCBCQ = 0x5, /* Multicast & Broadcast Packets */
};

/* Rx IPC status */
enum rx_frame_status {
	good_frame = 0x0,
	discard_frame = 0x1,
	csum_none = 0x2,
	llc_snap = 0x4,
	dma_own = 0x8,
	rx_not_ls = 0x10,
};

/* Tx status */
enum tx_frame_status {
	tx_done = 0x0,
	tx_not_ls = 0x1,
	tx_err = 0x2,
	tx_dma_own = 0x4,
};

enum dma_irq_status {
	tx_hard_error = 0x1,
	tx_hard_error_bump_tc = 0x2,
	handle_rx = 0x4,
	handle_tx = 0x8,
};

/* EEE and LPI defines */
#define	CORE_IRQ_TX_PATH_IN_LPI_MODE	(1 << 0)
#define	CORE_IRQ_TX_PATH_EXIT_LPI_MODE	(1 << 1)
#define	CORE_IRQ_RX_PATH_IN_LPI_MODE	(1 << 2)
#define	CORE_IRQ_RX_PATH_EXIT_LPI_MODE	(1 << 3)

#define CORE_IRQ_MTL_RX_OVERFLOW	BIT(8)

/* Physical Coding Sublayer */
struct rgmii_adv {
	unsigned int pause;
	unsigned int duplex;
	unsigned int lp_pause;
	unsigned int lp_duplex;
};

#define STMMAC_PCS_PAUSE	1
#define STMMAC_PCS_ASYM_PAUSE	2

/* DMA HW capabilities */
struct dma_features {
	unsigned int mbps_10_100;
	unsigned int mbps_1000;
	unsigned int half_duplex;
	unsigned int hash_filter;
	unsigned int multi_addr;
	unsigned int pcs;
	unsigned int sma_mdio;
	unsigned int pmt_remote_wake_up;
	unsigned int pmt_magic_frame;
	unsigned int rmon;
	/* IEEE 1588-2002 */
	unsigned int time_stamp;
	/* IEEE 1588-2008 */
	unsigned int atime_stamp;
	/* 802.3az - Energy-Efficient Ethernet (EEE) */
	unsigned int eee;
	unsigned int av;
	unsigned int hash_tb_sz;
	unsigned int tsoen;
	/* TX and RX csum */
	unsigned int tx_coe;
	unsigned int rx_coe;
	unsigned int rx_coe_type1;
	unsigned int rx_coe_type2;
	unsigned int rxfifo_over_2048;
	/* TX and RX number of channels */
	unsigned int number_rx_channel;
	unsigned int number_tx_channel;
	/* TX and RX number of queues */
	unsigned int number_rx_queues;
	unsigned int number_tx_queues;
	/* PPS output */
	unsigned int pps_out_num;
	/* Alternate (enhanced) DESC mode */
	unsigned int enh_desc;
	/* TX and RX FIFO sizes */
	unsigned int tx_fifo_size;
	unsigned int rx_fifo_size;
	/* Automotive Safety Package */
	unsigned int asp;
	/* RX Parser */
	unsigned int frpsel;
	unsigned int frpbs;
	unsigned int frpes;
	unsigned int addr64;
	unsigned int rssen;
	unsigned int vlhash;
	unsigned int sphen;
	unsigned int vlins;
	unsigned int dvlan;
	unsigned int l3l4fnum;
	unsigned int arpoffsel;
	/* TSN Features */
	unsigned int estwid;
	unsigned int estdep;
	unsigned int estsel;
	unsigned int fpesel;
	unsigned int tbssel;
};

/* RX Buffer size must be multiple of 4/8/16 bytes */
#define BUF_SIZE_16KiB 16368
#define BUF_SIZE_8KiB 8188
#define BUF_SIZE_4KiB 4096
#define BUF_SIZE_2KiB 2048

/* Power Down and WOL */
#define PMT_NOT_SUPPORTED 0
#define PMT_SUPPORTED 1

/* Common MAC defines */
#define MAC_CTRL_REG		0x00000000	/* MAC Control */
#define MAC_ENABLE_TX		0x00000008	/* Transmitter Enable */
#define MAC_ENABLE_RX		0x00000004	/* Receiver Enable */

/* Default LPI timers */
#define STMMAC_DEFAULT_LIT_LS	0x3E8
#define STMMAC_DEFAULT_TWT_LS	0x1E

#define STMMAC_CHAIN_MODE	0x1
#define STMMAC_RING_MODE	0x2

#define STMMAC_BUFFER_ALIGN	64
#define STMMAC_ALIGN_LENGTH	1536
#define JUMBO_LEN		9000

/* Receive Side Scaling */
#define STMMAC_RSS_HASH_KEY_SIZE	40
#define STMMAC_RSS_MAX_TABLE_SIZE	256

/* VLAN */
#define STMMAC_VLAN_NONE	0x0
#define STMMAC_VLAN_REMOVE	0x1
#define STMMAC_VLAN_INSERT	0x2
#define STMMAC_VLAN_REPLACE	0x3

#define STMMAC_HW_VLAN_CTAG_FILTER 1

extern const struct stmmac_desc_ops enh_desc_ops;
extern const struct stmmac_desc_ops ndesc_ops;

struct mac_device_info;

extern const struct stmmac_hwtimestamp stmmac_ptp;
extern const struct stmmac_mode_ops dwmac4_ring_mode_ops;

/* Interface Mode definitions */
typedef enum {
	PHY_INTERFACE_MODE_NA,
	PHY_INTERFACE_MODE_INTERNAL,
	PHY_INTERFACE_MODE_MII,
	PHY_INTERFACE_MODE_GMII,
	PHY_INTERFACE_MODE_SGMII,
	PHY_INTERFACE_MODE_TBI,
	PHY_INTERFACE_MODE_REVMII,
	PHY_INTERFACE_MODE_RMII,
	PHY_INTERFACE_MODE_RGMII,
	PHY_INTERFACE_MODE_RGMII_ID,
	PHY_INTERFACE_MODE_RGMII_RXID,
	PHY_INTERFACE_MODE_RGMII_TXID,
	PHY_INTERFACE_MODE_RTBI,
	PHY_INTERFACE_MODE_SMII,
	PHY_INTERFACE_MODE_XGMII,
	PHY_INTERFACE_MODE_MOCA,
	PHY_INTERFACE_MODE_QSGMII,
	PHY_INTERFACE_MODE_TRGMII,
	PHY_INTERFACE_MODE_1000BASEX,
	PHY_INTERFACE_MODE_2500BASEX,
	PHY_INTERFACE_MODE_RXAUI,
	PHY_INTERFACE_MODE_XAUI,
	/* 10GBASE-KR, XFI, SFI - single lane 10G Serdes */
	PHY_INTERFACE_MODE_10GKR,
	PHY_INTERFACE_MODE_MAX,
} phy_interface_t;

struct mac_link {
	uint32_t speed_mask;
	uint32_t speed10;
	uint32_t speed100;
	uint32_t speed1000;
	uint32_t speed2500;
	uint32_t duplex;
	struct {
		uint32_t speed2500;
		uint32_t speed5000;
		uint32_t speed10000;
	} xgmii;
	struct {
		uint32_t speed25000;
		uint32_t speed40000;
		uint32_t speed50000;
		uint32_t speed100000;
	} xlgmii;
};

struct mii_regs {
	unsigned int addr;	/* MII Address */
	unsigned int data;	/* MII Data */
	unsigned int addr_shift;	/* MII address shift */
	unsigned int reg_shift;		/* MII reg shift */
	unsigned int addr_mask;		/* MII address mask */
	unsigned int reg_mask;		/* MII reg mask */
	unsigned int clk_csr_shift;
	unsigned int clk_csr_mask;
};

struct mac_device_info {
	const struct stmmac_ops *mac;
	const struct stmmac_desc_ops *desc;
	const struct stmmac_dma_ops *dma;
	const struct stmmac_mode_ops *mode;
	const struct stmmac_hwtimestamp *ptp;
	const struct stmmac_tc_ops *tc;
	const struct stmmac_mmc_ops *mmc;
	struct mac_link link;
	void *pcsr;     /* vpointer to device CSRs */
	unsigned int multicast_filter_bins;
	unsigned int unicast_filter_entries;
	unsigned int mcast_bits_log2;
	unsigned int rx_csum;
	unsigned int pcs;
	unsigned int pmt;
	unsigned int ps;
	unsigned int xlgmac;
	unsigned int num_vlan;
	uint32_t vlan_filter[32];
	unsigned int promisc;
	bool vlan_fail_q_en;
	uint8_t vlan_fail_q;
};

struct stmmac_rx_routing {
	uint32_t reg_mask;
	uint32_t reg_shift;
};

/*
 * STMMAC can support 1 rx and tx queue..
 */

#define STMMAC_MAX_Q		1

struct stmmac_tx_info {
	dma_addr_t buf;
	bool map_as_page;
	unsigned len;
	bool last_segment;
	bool is_jumbo;
};

#define STMMAC_TBS_AVAIL	BIT(0)
#define STMMAC_TBS_EN		BIT(1)

struct stmmac_rx_buffer {
	struct page *page;
	struct page *sec_page;
	dma_addr_t addr;
	dma_addr_t sec_addr;
};

struct bufdesc_prop {
	int			queue_id;
	/* Addresses of Tx and Rx buffers */
	struct bufdesc		*base;
	struct bufdesc		*last;
	struct bufdesc		*cur;
	void 		*active_reg_desc;
	uint64_t			descr_baseaddr_p;
	unsigned short		ring_size;
	unsigned char		d_size;
	unsigned char		d_size_log2;
};

/* Frequently used values are kept adjacent for cache effect */
struct stmmac_tx_queue {
	uint32_t tx_count_frames;
	int tbs;
	uint32_t queue_index;
	struct dma_desc *dma_tx;
	struct dma_extended_desc *dma_etx;
	struct dma_edesc *dma_entx;
	struct rte_mbuf *tx_mbuf[DMA_MAX_TX_SIZE];
	struct stmmac_tx_info *tx_mbuf_dma;
	unsigned int cur_tx;
	unsigned int dirty_tx;
	unsigned short	 dma_tx_size;
	dma_addr_t dma_tx_phy;
	uint32_t tx_tail_addr;
	uint32_t mss;
	struct rte_mempool	*pool;
	struct stmmac_private *private;
};

struct stmmac_rx_queue {
	uint32_t rx_count_frames;
	uint32_t queue_index;
	struct dma_desc *dma_rx;
	struct dma_extended_desc *dma_erx;
	unsigned int cur_rx;
	unsigned int dirty_rx;
	uint32_t rx_zeroc_thresh;
	dma_addr_t dma_rx_phy;
	uint32_t rx_tail_addr;
	unsigned int state_saved;
	unsigned short dma_rx_size;
	struct {
		struct sk_buff *skb;
		unsigned int len;
		unsigned int error;
	} state;
	struct rte_mbuf		*rx_mbuf[DMA_MAX_RX_SIZE];
	struct rte_mempool		*pool;
	struct stmmac_private	*private;
};

struct stmmac_private {
	struct rte_eth_dev *dev;
	struct rte_eth_stats stats;
	struct mac_device_info *hw;
	struct plat_stmmacenet_data *plat;
	struct dma_features dma_cap;
	struct uio_job stmmac_uio_job;
	unsigned int mode;
	unsigned int chain_mode;
	int extend_desc;
	void *mmcaddr;
	void *ptpaddr;
	unsigned int dma_buf_sz;
	int use_riwt;
	uint32_t rx_riwt;
	int hwts_rx_en;
	unsigned int synopsys_id;
	int hw_cap_support;
	struct stmmac_counters mmc;
	int speed;
	unsigned int flow_ctrl;
	unsigned int pause;
	int (*hwif_quirks)(struct stmmac_private *priv);
	int			full_duplex;
	int			flag_pause;
	int			flag_csum;
	uint32_t		quirks;
	uint16_t		rx_queues_to_use;
	uint16_t		tx_queues_to_use;
	unsigned int		total_tx_ring_size;
	unsigned int		total_rx_ring_size;
	unsigned int		reg_size;
	unsigned int		dma_rx_size;
	unsigned int		dma_tx_size;
	unsigned int		bd_r_size[STMMAC_MAX_Q];
	unsigned int		bd_t_size[STMMAC_MAX_Q];
	bool			bufdesc_ex;
	bool			rgmii_txc_delay;
	bool			rgmii_rxc_delay;
	void			*ioaddr_v;
	uint32_t		ioaddr_p;
	void			*bd_addr_r_v;
	uint32_t		bd_addr_r_p;
	void			*bd_addr_t_v;
	uint32_t		bd_addr_t_p;
	dma_addr_t		desc_addr_p_r[STMMAC_MAX_Q];
	dma_addr_t		desc_addr_p_t[STMMAC_MAX_Q];
	void			*dma_baseaddr_v_r[STMMAC_MAX_Q];
	void			*dma_baseaddr_v_t[STMMAC_MAX_Q];
	struct stmmac_rx_queue *rx_queues[STMMAC_MAX_Q];
	struct stmmac_tx_queue *tx_queues[STMMAC_MAX_Q];
	unsigned long		flags;
	unsigned long		features;
	unsigned long		uc_count;
};


int dwmac100_setup(struct stmmac_private *priv);
int dwmac1000_setup(struct stmmac_private *priv);
extern int dwmac4_setup(struct stmmac_private *priv);
int dwxgmac2_setup(struct stmmac_private *priv);
int dwxlgmac2_setup(struct stmmac_private *priv);

void stmmac_set_mac_addr(void *ioaddr, uint8_t addr[6],
			 unsigned int high, unsigned int low);
void stmmac_get_mac_addr(void *ioaddr, unsigned char *addr,
			 unsigned int high, unsigned int low);
void stmmac_set_mac(void *ioaddr, bool enable);

void stmmac_dwmac4_set_mac_addr(void *ioaddr, uint8_t addr[6],
				unsigned int high, unsigned int low);
void stmmac_dwmac4_get_mac_addr(void *ioaddr, unsigned char *addr,
				unsigned int high, unsigned int low);
void stmmac_dwmac4_set_mac(void *ioaddr, bool enable);

void dwmac_dma_flush_tx_fifo(void *ioaddr);

extern const struct stmmac_mode_ops ring_mode_ops;
extern const struct stmmac_mode_ops chain_mode_ops;
extern const struct stmmac_desc_ops dwmac4_desc_ops;

#endif /* __COMMON_H__ */
