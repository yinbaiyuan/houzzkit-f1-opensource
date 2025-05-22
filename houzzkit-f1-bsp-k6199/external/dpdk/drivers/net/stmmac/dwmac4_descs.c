/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

#include "common.h"
#include "dwmac4_descs.h"

#define wsb()		{asm volatile("dsb sy");}

static int dwmac4_wrback_get_tx_status(struct rte_eth_stats *x,
				       struct dma_desc *p)
{
	unsigned int tdes3;
	int ret = tx_done;

	tdes3 = rte_le_to_cpu_32(p->des3);

	/* Get tx owner first */
	if (unlikely(tdes3 & TDES3_OWN))
		return tx_dma_own;

	/* Verify tx error by looking at the last segment. */
	if (likely(!(tdes3 & TDES3_LAST_DESCRIPTOR)))
		return tx_not_ls;

	if (unlikely(tdes3 & TDES3_ERROR_SUMMARY))
		ret = tx_err;

	if (unlikely(tdes3 & TDES3_DEFERRED))
		ret = tx_err;

	if (ret == tx_err)
		x->ierrors++;

	return ret;
}

static int dwmac4_wrback_get_rx_status(struct rte_eth_stats *x,
				       struct dma_desc *p,unsigned int *len)
{
	unsigned int rdes2 = rte_le_to_cpu_32(p->des2);
	unsigned int rdes3 = rte_le_to_cpu_32(p->des3);
	int ret = good_frame;

	if (unlikely(rdes3 & RDES3_OWN))
		return dma_own;

	if (unlikely(rdes3 & RDES3_CONTEXT_DESCRIPTOR))
		return discard_frame;
	if (likely(!(rdes3 & RDES3_LAST_DESCRIPTOR)))
		return rx_not_ls;

	if (unlikely(rdes3 & RDES3_ERROR_SUMMARY))
		ret = discard_frame;

	if (unlikely(rdes2 & RDES2_SA_FILTER_FAIL))
		ret = discard_frame;
	if (unlikely(rdes2 & RDES2_DA_FILTER_FAIL))
		ret = discard_frame;

	if (ret == discard_frame)
		x->oerrors++;

	*len = rdes3 & RDES3_PACKET_SIZE_MASK;

	return ret;
}

static int dwmac4_rd_get_tx_len(struct dma_desc *p)
{
	return (rte_le_to_cpu_32(p->des2) & TDES2_BUFFER1_SIZE_MASK);
}

static int dwmac4_get_tx_owner(struct dma_desc *p)
{
	return (rte_le_to_cpu_32(p->des3) & TDES3_OWN) >> TDES3_OWN_SHIFT;
}

static void dwmac4_set_tx_owner(struct dma_desc *p)
{
	p->des3 |= rte_cpu_to_le_32(TDES3_OWN);
}

static void dwmac4_set_rx_owner(struct dma_desc *p, int disable_rx_ic)
{
	p->des3 = rte_cpu_to_le_32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);

	if (!disable_rx_ic)
		p->des3 |= rte_cpu_to_le_32(RDES3_INT_ON_COMPLETION_EN);
}

static int dwmac4_get_tx_ls(struct dma_desc *p)
{
	return (rte_le_to_cpu_32(p->des3) & TDES3_LAST_DESCRIPTOR)
		>> TDES3_LAST_DESCRIPTOR_SHIFT;
}

static int dwmac4_wrback_get_rx_frame_len(struct dma_desc *p, int rx_coe)
{
	return (rte_le_to_cpu_32(p->des3) & RDES3_PACKET_SIZE_MASK);
}

static void dwmac4_rd_enable_tx_timestamp(struct dma_desc *p)
{
	p->des2 |= rte_cpu_to_le_32(TDES2_TIMESTAMP_ENABLE);
}

static int dwmac4_wrback_get_tx_timestamp_status(struct dma_desc *p)
{
	/* Context type from W/B descriptor must be zero */
	if (rte_le_to_cpu_32(p->des3) & TDES3_CONTEXT_TYPE)
		return 0;

	/* Tx Timestamp Status is 1 so des0 and des1'll have valid values */
	if (rte_le_to_cpu_32(p->des3) & TDES3_TIMESTAMP_STATUS)
		return 1;

	return 0;
}

static inline void dwmac4_get_timestamp(void *desc, uint32_t ats, uint64_t *ts)
{
	struct dma_desc *p = (struct dma_desc *)desc;
	uint64_t ns;

	ns = rte_le_to_cpu_32(p->des0);
	/* convert high/sec time stamp value to nanosecond */
	ns += rte_le_to_cpu_32(p->des1) * 1000000000ULL;

	*ts = ns;
}

static int dwmac4_rx_check_timestamp(void *desc)
{
	struct dma_desc *p = (struct dma_desc *)desc;
	unsigned int rdes0 = rte_le_to_cpu_32(p->des0);
	unsigned int rdes1 = rte_le_to_cpu_32(p->des1);
	unsigned int rdes3 = rte_le_to_cpu_32(p->des3);
	uint32_t own, ctxt;
	int ret = 1;

	own = rdes3 & RDES3_OWN;
	ctxt = ((rdes3 & RDES3_CONTEXT_DESCRIPTOR)
		>> RDES3_CONTEXT_DESCRIPTOR_SHIFT);

	if (likely(!own && ctxt)) {
		if ((rdes0 == 0xffffffff) && (rdes1 == 0xffffffff))
			/* Corrupted value */
			ret = -EINVAL;
		else
			/* A valid Timestamp is ready to be read */
			ret = 0;
	}

	/* Timestamp not ready */
	return ret;
}

static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
						 uint32_t ats)
{
	struct dma_desc *p = (struct dma_desc *)desc;
	int ret = -EINVAL;

	/* Get the status from normal w/b descriptor */
	if (likely(rte_le_to_cpu_32(p->des3) & RDES3_RDES1_VALID)) {
		if (likely(rte_le_to_cpu_32(p->des1) & RDES1_TIMESTAMP_AVAILABLE)) {
			int i = 0;

			/* Check if timestamp is OK from context descriptor */
			do {
				ret = dwmac4_rx_check_timestamp(next_desc);
				if (ret < 0)
					goto exit;
				i++;

			} while ((ret == 1) && (i < 10));

			if (i == 10)
				ret = -EBUSY;
		}
	}
exit:
	if (likely(ret == 0))
		return 1;

	return 0;
}

static void dwmac4_rd_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
				   int mode, int end, int bfsize)
{
	dwmac4_set_rx_owner(p, disable_rx_ic);
}

static void dwmac4_rd_init_tx_desc(struct dma_desc *p, int mode, int end)
{
	p->des0 = 0;
	p->des1 = 0;
	p->des2 = 0;
	p->des3 = 0;
	mode = 0;
}

static void dwmac4_rd_prepare_tx_desc(struct dma_desc *p, int is_fs, int len,
				      bool csum_flag, int mode, bool tx_own,
				      bool ls, unsigned int tot_pkt_len)
{
	unsigned int tdes3 = 0;

	tdes3 |= tot_pkt_len & TDES3_PACKET_SIZE_MASK;
	if (is_fs)
		tdes3 |= TDES3_FIRST_DESCRIPTOR;
	else
		tdes3 &= ~TDES3_FIRST_DESCRIPTOR;

	if (likely(csum_flag))
		tdes3 |= (TX_CIC_FULL << TDES3_CHECKSUM_INSERTION_SHIFT);
	else
		tdes3 &= ~(TX_CIC_FULL << TDES3_CHECKSUM_INSERTION_SHIFT);

	if (ls)
		tdes3 |= TDES3_LAST_DESCRIPTOR;
	else
		tdes3 &= ~TDES3_LAST_DESCRIPTOR;

	/* Finally set the OWN bit. Later the DMA will start! */
	if (tx_own)
		tdes3 |= TDES3_OWN;

	p->des2 = rte_le_to_cpu_32(len & TDES2_BUFFER1_SIZE_MASK);
	p->des3 = rte_le_to_cpu_32(tdes3);
}

static void dwmac4_rd_prepare_tso_tx_desc(struct dma_desc *p, int is_fs,
					  int len1, int len2, bool tx_own,
					  bool ls, unsigned int tcphdrlen,
					  unsigned int tcppayloadlen)
{
	unsigned int tdes3 = rte_le_to_cpu_32(p->des3);

	if (len1)
		p->des2 |= rte_cpu_to_le_32((len1 & TDES2_BUFFER1_SIZE_MASK));

	if (len2)
		p->des2 |= rte_cpu_to_le_32((len2 << TDES2_BUFFER2_SIZE_MASK_SHIFT)
			    & TDES2_BUFFER2_SIZE_MASK);

	if (is_fs) {
		tdes3 |= TDES3_FIRST_DESCRIPTOR |
			 TDES3_TCP_SEGMENTATION_ENABLE |
			 ((tcphdrlen << TDES3_HDR_LEN_SHIFT) &
			  TDES3_SLOT_NUMBER_MASK) |
			 ((tcppayloadlen & TDES3_TCP_PKT_PAYLOAD_MASK));
	} else {
		tdes3 &= ~TDES3_FIRST_DESCRIPTOR;
	}

	if (ls)
		tdes3 |= TDES3_LAST_DESCRIPTOR;
	else
		tdes3 &= ~TDES3_LAST_DESCRIPTOR;

	/* Finally set the OWN bit. Later the DMA will start! */
	if (tx_own)
		tdes3 |= TDES3_OWN;

	if (is_fs && tx_own)
		/* When the own bit, for the first frame, has to be set, all
		 * descriptors for the same frame has to be set before, to
		 * avoid race condition.
		 */
		rte_wmb();

	p->des3 = rte_cpu_to_le_32(tdes3);
}

static void dwmac4_release_tx_desc(struct dma_desc *p, int mode)
{
	p->des0 = 0;
	p->des1 = 0;
	p->des2 = 0;
	p->des3 = 0;
}

static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
{
	p->des2 |= rte_cpu_to_le_32(TDES2_INTERRUPT_ON_COMPLETION);
}

static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
				dma_addr_t dma_rx_phy, unsigned int desc_size)
{
	dma_addr_t dma_addr;
	unsigned int i;

	STMMAC_PMD_INFO("%s descriptor ring:\n", rx ? "RX" : "TX");

	if (desc_size == sizeof(struct dma_desc)) {
		struct dma_desc *p = (struct dma_desc *)head;

		for (i = 0; i < size; i++) {
			dma_addr = dma_rx_phy + i * sizeof(*p);
			STMMAC_PMD_INFO("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
				i, &dma_addr,
				rte_le_to_cpu_32(p->des0), rte_le_to_cpu_32(p->des1),
				rte_le_to_cpu_32(p->des2), rte_le_to_cpu_32(p->des3));
			p++;
		}
	} else if (desc_size == sizeof(struct dma_extended_desc)) {
		struct dma_extended_desc *extp = (struct dma_extended_desc *)head;

		for (i = 0; i < size; i++) {
			dma_addr = dma_rx_phy + i * sizeof(*extp);
			STMMAC_PMD_INFO("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
				i, &dma_addr,
				rte_le_to_cpu_32(extp->basic.des0), rte_le_to_cpu_32(extp->basic.des1),
				rte_le_to_cpu_32(extp->basic.des2), rte_le_to_cpu_32(extp->basic.des3),
				rte_le_to_cpu_32(extp->des4), rte_le_to_cpu_32(extp->des5),
				rte_le_to_cpu_32(extp->des6), rte_le_to_cpu_32(extp->des7));
			extp++;
		}
	} else if (desc_size == sizeof(struct dma_edesc)) {
		struct dma_edesc *ep = (struct dma_edesc *)head;

		for (i = 0; i < size; i++) {
			dma_addr = dma_rx_phy + i * sizeof(*ep);
			STMMAC_PMD_INFO("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
				i, &dma_addr,
				rte_le_to_cpu_32(ep->des4), rte_le_to_cpu_32(ep->des5),
				rte_le_to_cpu_32(ep->des6), rte_le_to_cpu_32(ep->des7),
				rte_le_to_cpu_32(ep->basic.des0), rte_le_to_cpu_32(ep->basic.des1),
				rte_le_to_cpu_32(ep->basic.des2), rte_le_to_cpu_32(ep->basic.des3));
			ep++;
		}
	} else {
		STMMAC_PMD_ERR("unsupported descriptor!");
	}
}

static void dwmac4_set_mss_ctxt(struct dma_desc *p, unsigned int mss)
{
	p->des0 = 0;
	p->des1 = 0;
	p->des2 = rte_cpu_to_le_32(mss);
	p->des3 = rte_cpu_to_le_32(TDES3_CONTEXT_TYPE | TDES3_CTXT_TCMSSV);
}

static void dwmac4_get_addr(struct dma_desc *p, unsigned int *addr)
{
	*addr = rte_le_to_cpu_32(p->des0);
}

static void dwmac4_set_addr(struct dma_desc *p, dma_addr_t addr)
{
	p->des0 = rte_cpu_to_le_32(lower_32_bits(addr));
	p->des1 = rte_cpu_to_le_32(upper_32_bits(addr));
}

static void dwmac4_clear(struct dma_desc *p)
{
	p->des0 = 0;
	p->des1 = 0;
	p->des2 = 0;
	p->des3 = 0;
}

static void dwmac4_set_sarc(struct dma_desc *p, uint32_t sarc_type)
{
	sarc_type <<= TDES3_SA_INSERT_CTRL_SHIFT;

	p->des3 |= rte_cpu_to_le_32(sarc_type & TDES3_SA_INSERT_CTRL_MASK);
}

static int set_16kib_bfsize(int mtu)
{
	int ret = 0;

	if (unlikely(mtu >= BUF_SIZE_8KiB))
		ret = BUF_SIZE_16KiB;
	return ret;
}

static void dwmac4_set_vlan_tag(struct dma_desc *p, uint16_t tag, uint16_t inner_tag,
				uint32_t inner_type)
{
	p->des0 = 0;
	p->des1 = 0;
	p->des2 = 0;
	p->des3 = 0;

	/* Inner VLAN */
	if (inner_type) {
		uint32_t des = inner_tag << TDES2_IVT_SHIFT;

		des &= TDES2_IVT_MASK;
		p->des2 = rte_cpu_to_le_32(des);

		des = inner_type << TDES3_IVTIR_SHIFT;
		des &= TDES3_IVTIR_MASK;
		p->des3 = rte_cpu_to_le_32(des | TDES3_IVLTV);
	}

	/* Outer VLAN */
	p->des3 |= rte_cpu_to_le_32(tag & TDES3_VLAN_TAG);
	p->des3 |= rte_cpu_to_le_32(TDES3_VLTV);

	p->des3 |= rte_cpu_to_le_32(TDES3_CONTEXT_TYPE);
}

static void dwmac4_set_vlan(struct dma_desc *p, uint32_t type)
{
	type <<= TDES2_VLAN_TAG_SHIFT;
	p->des2 |= rte_cpu_to_le_32(type & TDES2_VLAN_TAG_MASK);
}

static void dwmac4_get_rx_header_len(struct dma_desc *p, unsigned int *len)
{
	*len = rte_le_to_cpu_32(p->des2) & RDES2_HL;
}

static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr, bool buf2_valid)
{
	p->des2 = rte_cpu_to_le_32(lower_32_bits(addr));
	p->des3 = rte_cpu_to_le_32(upper_32_bits(addr));

	if (buf2_valid)
		p->des3 |= rte_cpu_to_le_32(RDES3_BUFFER2_VALID_ADDR);
	else
		p->des3 &= rte_cpu_to_le_32(~RDES3_BUFFER2_VALID_ADDR);
}

static void dwmac4_set_tbs(struct dma_edesc *p, uint32_t sec, uint32_t nsec)
{
	p->des4 = rte_cpu_to_le_32((sec & TDES4_LT) | TDES4_LTV);
	p->des5 = rte_cpu_to_le_32(nsec & TDES5_LT);
	p->des6 = 0;
	p->des7 = 0;
}

const struct stmmac_desc_ops dwmac4_desc_ops = {
	.tx_status = dwmac4_wrback_get_tx_status,
	.rx_status = dwmac4_wrback_get_rx_status,
	.get_tx_len = dwmac4_rd_get_tx_len,
	.get_tx_owner = dwmac4_get_tx_owner,
	.set_tx_owner = dwmac4_set_tx_owner,
	.set_rx_owner = dwmac4_set_rx_owner,
	.get_tx_ls = dwmac4_get_tx_ls,
	.get_rx_frame_len = dwmac4_wrback_get_rx_frame_len,
	.enable_tx_timestamp = dwmac4_rd_enable_tx_timestamp,
	.get_tx_timestamp_status = dwmac4_wrback_get_tx_timestamp_status,
	.get_rx_timestamp_status = dwmac4_wrback_get_rx_timestamp_status,
	.get_timestamp = dwmac4_get_timestamp,
	.set_tx_ic = dwmac4_rd_set_tx_ic,
	.prepare_tx_desc = dwmac4_rd_prepare_tx_desc,
	.prepare_tso_tx_desc = dwmac4_rd_prepare_tso_tx_desc,
	.release_tx_desc = dwmac4_release_tx_desc,
	.init_rx_desc = dwmac4_rd_init_rx_desc,
	.init_tx_desc = dwmac4_rd_init_tx_desc,
	.display_ring = dwmac4_display_ring,
	.set_mss = dwmac4_set_mss_ctxt,
	.get_addr = dwmac4_get_addr,
	.set_addr = dwmac4_set_addr,
	.clear = dwmac4_clear,
	.set_sarc = dwmac4_set_sarc,
	.set_vlan_tag = dwmac4_set_vlan_tag,
	.set_vlan = dwmac4_set_vlan,
	.get_rx_header_len = dwmac4_get_rx_header_len,
	.set_sec_addr = dwmac4_set_sec_addr,
	.set_tbs = dwmac4_set_tbs,
};

const struct stmmac_mode_ops dwmac4_ring_mode_ops = {
	.set_16kib_bfsize = set_16kib_bfsize,
};
