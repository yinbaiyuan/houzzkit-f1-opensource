/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include <sys/queue.h>
#include <stdio.h>
#include <errno.h>
#include <stdint.h>
#include <stdarg.h>

#include <rte_string_fns.h>
#include <rte_common.h>
#include <rte_interrupts.h>
#include <rte_byteorder.h>
#include <rte_log.h>
#include <rte_debug.h>
#include <rte_pci.h>
#include <rte_bus_pci.h>
#include <rte_ether.h>
#include <ethdev_driver.h>
#include <ethdev_pci.h>
#include <rte_memory.h>
#include <rte_eal.h>
#include <rte_malloc.h>
#include <rte_dev.h>

#include "r8168_base.h"
#include "r8168_ethdev.h"
#include "r8168_hw.h"
#include "r8168_logs.h"
#include "base/rtl8168g.h"
#include "base/rtl8168h.h"
#include "base/rtl8168ep.h"
#include "base/rtl8168fp.h"

extern uint32_t		r8168_gbd_addr_b_p[5];
extern uint32_t		r8168_gbd_addr_r_p[5];
extern uint32_t		r8168_gbd_addr_t_p[5];
extern uint32_t		r8168_gbd_addr_x_p[5];

extern void			*r8168_gbd_addr_b_v[5];
extern void			*r8168_gbd_addr_t_v[5];
extern void			*r8168_gbd_addr_r_v[5];
extern void			*r8168_gbd_addr_x_v[5];
extern uint64_t r8168_base_hw_addr;

#define dcbf(p) { asm volatile("dc cvac, %0" : : "r"(p) : "memory"); }
#define dccivac(p) { asm volatile("dc civac, %0" : : "r"(p) : "memory"); }

/* Bit Mask to indicate what bits required for building TX context */
#define RTL_TX_OFFLOAD_MASK (                   \
                PKT_TX_IPV6 |                   \
                PKT_TX_IPV4 |                   \
                PKT_TX_VLAN_PKT |               \
                PKT_TX_IP_CKSUM |               \
                PKT_TX_L4_MASK |                \
                PKT_TX_TCP_SEG)

//struct TxDesc in kernel r8168
struct rtl_tx_desc {
        u32 opts1;
        u32 opts2;
        u64 addr;
};

//struct RxDesc in kernel r8168
struct rtl_rx_desc {
        u32 opts1;
        u32 opts2;
        u64 addr;
};

//Structure associated with each descriptor of the TX ring of a TX queue.
struct rtl_tx_entry {
        struct rte_mbuf *mbuf;
};

//Structure associated with each descriptor of the RX ring of a RX queue.
struct rtl_rx_entry {
        struct rte_mbuf *mbuf;
};

//Structure associated with each TX queue.
struct rtl_tx_queue {
        struct rtl_tx_desc      *hw_ring;
        struct rtl_tx_entry     *sw_ring;
        struct rtl_hw           *hw;
        uint64_t                hw_ring_phys_addr;
        uint16_t                nb_tx_desc;
        uint16_t                tx_tail;
        uint16_t                tx_head;
        uint16_t                queue_id;
        uint16_t                port_id;
        uint16_t                tx_free_thresh;
        uint16_t                tx_free;
        uint16_t                tx_en;
};

//Structure associated with each RX queue.
struct rtl_rx_queue {
        struct rte_mempool      *mb_pool;
        struct rtl_rx_desc      *hw_ring;
        struct rtl_rx_entry     *sw_ring;
        struct rtl_hw           *hw;
        uint64_t                hw_ring_phys_addr;
        uint16_t                nb_rx_desc;
        uint16_t                rx_tail;
        uint16_t                nb_rx_hold;
        uint16_t                queue_id;
        uint16_t                port_id;
        uint16_t                rx_free_thresh;
        uint16_t                rx_en;
        uint64_t                offloads;
};

enum _DescStatusBit {
        DescOwn     = (1UL << 31), /* Descriptor is owned by NIC */
        RingEnd     = (1UL << 30), /* End of descriptor ring */
        FirstFrag   = (1UL << 29), /* First segment of a packet */
        LastFrag    = (1UL << 28), /* Final segment of a packet */

        /* Tx private */
        /*------ offset 0 of tx descriptor ------*/
        LargeSend   = (1UL << 27), /* TCP Large Send Offload (TSO) */
        GiantSendv4 = (1UL << 26), /* TCP Giant Send Offload V4 (GSOv4) */
        GiantSendv6 = (1UL << 25), /* TCP Giant Send Offload V6 (GSOv6) */
        LargeSend_DP = (1UL << 16), /* TCP Large Send Offload (TSO) */
        MSSShift    = 16,        /* MSS value position */
        MSSMask     = 0x7FFU,    /* MSS value 11 bits */
        TxIPCS      = (1UL << 18), /* Calculate IP checksum */
        TxUDPCS     = (1UL << 17), /* Calculate UDP/IP checksum */
        TxTCPCS     = (1UL << 16), /* Calculate TCP/IP checksum */
        TxVlanTag   = (1UL << 17), /* Add VLAN tag */

        /*@@@@@@ offset 4 of tx descriptor => bits for RTL8168C/CP only     begin @@@@@@*/
        TxUDPCS_C   = (1UL << 31), /* Calculate UDP/IP checksum */
        TxTCPCS_C   = (1UL << 30), /* Calculate TCP/IP checksum */
        TxIPCS_C    = (1UL << 29), /* Calculate IP checksum */
        TxIPV6F_C   = (1UL << 28), /* Indicate it is an IPv6 packet */
        /*@@@@@@ offset 4 of tx descriptor => bits for RTL8168C/CP only     end @@@@@@*/


        /* Rx private */
        /*------ offset 0 of rx descriptor ------*/
        PID1        = (1UL << 18), /* Protocol ID bit 1/2 */
        PID0        = (1UL << 17), /* Protocol ID bit 2/2 */

#define RxProtoUDP  (PID1)
#define RxProtoTCP  (PID0)
#define RxProtoIP   (PID1 | PID0)
#define RxProtoMask RxProtoIP

        RxIPF       = (1UL << 16), /* IP checksum failed */
        RxUDPF      = (1UL << 15), /* UDP/IP checksum failed */
        RxTCPF      = (1UL << 14), /* TCP/IP checksum failed */
        RxVlanTag   = (1UL << 16), /* VLAN tag available */

        /*@@@@@@ offset 0 of rx descriptor => bits for RTL8168C/CP only     begin @@@@@@*/
        RxUDPT      = (1UL << 18),
        RxTCPT      = (1UL << 17),
        /*@@@@@@ offset 0 of rx descriptor => bits for RTL8168C/CP only     end @@@@@@*/

        /*@@@@@@ offset 4 of rx descriptor => bits for RTL8168C/CP only     begin @@@@@@*/
        RxV6F       = (1UL << 31),
        RxV4F       = (1UL << 30),
        /*@@@@@@ offset 4 of rx descriptor => bits for RTL8168C/CP only     end @@@@@@*/
};

#define GTTCPHO_SHIFT                   18
#define GTTCPHO_MAX                     0x70U
#define GTPKTSIZE_MAX                   0x3ffffU
#define TCPHO_SHIFT                     18
#define TCPHO_MAX                       0x3ffU
#define LSOPKTSIZE_MAX                  0xffffU
#define MSS_MAX                         0x07ffu /* MSS value */

//---------------------------------Rx----------------------------------
static void
rtl_rx_queue_release_mbufs(struct rtl_rx_queue *rxq)
{
        int i;

        PMD_INIT_FUNC_TRACE();

        if (rxq != NULL) {
                if (rxq->sw_ring != NULL) {
                        for (i = 0; i < rxq->nb_rx_desc; i++) {
                                if (rxq->sw_ring[i].mbuf != NULL) {
                                        rte_pktmbuf_free_seg(rxq->sw_ring[i].mbuf);
                                        rxq->sw_ring[i].mbuf = NULL;
                                }
                        }
                }
        }
}

void
rtl_rx_queue_release(void *rx_queue)
{
        PMD_INIT_FUNC_TRACE();

        if (rx_queue != NULL) {
                struct rtl_rx_queue * rxq = (struct rtl_rx_queue *)rx_queue;
                rtl_rx_queue_release_mbufs(rxq);
                rte_free(rxq->sw_ring);
                rte_free(rxq);
        }
}

void
rtl_rxq_info_get(struct rte_eth_dev *dev, uint16_t queue_id,
                 struct rte_eth_rxq_info *qinfo)
{
        struct rtl_rx_queue *rxq;

        rxq = dev->data->rx_queues[queue_id];

        qinfo->mp = rxq->mb_pool;
        //qinfo->scattered_rx = dev->data->scattered_rx;
        qinfo->nb_desc = rxq->nb_rx_desc;

        qinfo->conf.rx_free_thresh = rxq->rx_free_thresh;
        //qinfo->conf.rx_drop_en = rxq->drop_en;
        qinfo->conf.offloads = rxq->offloads;
}

static void
rtl_reset_rx_queue(struct rtl_rx_queue *rxq)
{
        static const struct rtl_rx_desc zero_rxd = {0};
        uint16_t i;

        for (i = 0; i < rxq->nb_rx_desc; i++) {
                rxq->hw_ring[i] = zero_rxd;
        }

        rxq->hw_ring[rxq->nb_rx_desc - 1].opts1 = rte_cpu_to_le_32(RingEnd);
        rxq->rx_tail = 0;
        rxq->rx_en = 0;
}

uint64_t
rtl_get_rx_port_offloads(struct rte_eth_dev *dev __rte_unused)
{
        uint64_t offloads;

        offloads = DEV_RX_OFFLOAD_IPV4_CKSUM  |
                   DEV_RX_OFFLOAD_UDP_CKSUM   |
                   DEV_RX_OFFLOAD_TCP_CKSUM   |
                   DEV_RX_OFFLOAD_KEEP_CRC    |
                   //DEV_RX_OFFLOAD_JUMBO_FRAME |
                   //DEV_RX_OFFLOAD_SCATTER |
                   //DEV_RX_OFFLOAD_RSS_HASH |
                   DEV_RX_OFFLOAD_VLAN_STRIP;


        return offloads;
}

int
rtl_rx_queue_setup(struct rte_eth_dev *dev, uint16_t queue_idx,
                   uint16_t nb_rx_desc, unsigned int socket_id,
                   const struct rte_eth_rxconf *rx_conf,
                   struct rte_mempool *mb_pool)
{
        struct rtl_rx_queue *rxq;
        const struct rte_memzone *mz;

        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        u32 size;

        PMD_INIT_FUNC_TRACE();
        if (nb_rx_desc > R8168_MAX_RX_DESC || nb_rx_desc < R8168_MIN_RX_DESC) {
                printf("r8168:rx desc error %d\n", nb_rx_desc);
                return -EINVAL;
        }

        /*
         * if this queue existed already, free the associated memory. The
         * queue cannot be reused in case we need to allocate memory on
         * different socket than was previously used.
         */

        if (dev->data->rx_queues[queue_idx] != NULL) {
                rtl_rx_queue_release(dev->data->rx_queues[queue_idx]);
                dev->data->rx_queues[queue_idx] = NULL;
        }

        /* First allocate the rx queue data structure */
        rxq = rte_zmalloc_socket("r8168 RX queue",
                                 sizeof(struct rtl_rx_queue),
                                 RTE_CACHE_LINE_SIZE,
                                 socket_id);

        if (rxq == NULL)
                return -ENOMEM;

        /*
         * Allocate RX ring hardware descriptors. A memzone large enough to
         * handle the maximum ring size is allocated in order to allow for
         * resizing in later calls to the queue setup function.
         */
        size = sizeof(struct rtl_rx_desc) * nb_rx_desc;//R8168_MAX_RX_DESC;
        mz = rte_eth_dma_zone_reserve(dev, "rx_ring", queue_idx, size,
                                      R8168_RING_ALIGN, socket_id);
        if (mz == NULL) {
                rtl_rx_queue_release(rxq);
                return -ENOMEM;
        }
        printf("rx buf size: %d[%ld:%d]\n", size, sizeof(struct rtl_rx_desc), nb_rx_desc);

        /* setup queue */
        rxq->mb_pool = mb_pool;
        rxq->nb_rx_desc = nb_rx_desc;
        rxq->port_id = dev->data->port_id;
        rxq->queue_id = queue_idx;
        rxq->rx_free_thresh = rx_conf->rx_free_thresh;

        rxq->hw = hw;
        rxq->hw_ring = mz->addr;
        rxq->hw_ring_phys_addr = mz->iova;
        rxq->offloads = dev->data->dev_conf.rxmode.offloads;

        //rxq->hw_ring = gbd_addr_r_v;
        //rxq->hw_ring_phys_addr = gbd_addr_r_p;
        //printf("rk rtl_rx_queue_setup: nb_rx_desc %d", rxq->nb_rx_desc);

        int index;
        index = abs((uint64_t)hw->mmio_addr - r8168_base_hw_addr) / 0x5000;
        printf("index: %d, mmio_addr: 0x%lx, r8168_base_hw_addr: 0x%lx\n", index, hw->mmio_addr, r8168_base_hw_addr);
        rxq->hw_ring_phys_addr = r8168_gbd_addr_r_p[index];
        rxq->hw_ring = (struct rtl_rx_desc *)r8168_gbd_addr_r_v[index];
        printf("hw rx ring size: %d:%ld[0x%lx:%p]\n",
                                                size,
                                                sizeof(struct rtl_rx_desc),
                                                rxq->hw_ring_phys_addr,
                                                rxq->hw_ring);

        /* allocate memory for the software ring */
        rxq->sw_ring = rte_zmalloc_socket("r8168 sw rx ring",
                                          nb_rx_desc * sizeof(struct rtl_rx_entry),
                                          RTE_CACHE_LINE_SIZE,
                                          socket_id);
        if (rxq->sw_ring == NULL) {
                //PMD_INIT_LOG(ERR,
                //	"Port %d: Cannot allocate software ring for queue %d",
                //	rxq->port_id, rxq->queue_id);
                rte_free(rxq);
                return -ENOMEM;
        }

        rtl_reset_rx_queue(rxq);

        dev->data->rx_queues[queue_idx] = rxq;

        return 0;

}

static int
rtl_alloc_rx_queue_mbufs(struct rtl_rx_queue *rxq)
{
        struct rtl_rx_entry *rxe = rxq->sw_ring;
        uint64_t dma_addr;
        unsigned i;
        struct rtl_hw *hw = rxq->hw;
        struct rtl_rx_desc *rxd = &rxq->hw_ring[0];

        /* Initialize software ring entries. */
        for (i = 0; i < rxq->nb_rx_desc; i++) {
                struct rte_mbuf *mbuf = rte_mbuf_raw_alloc(rxq->mb_pool);

                if (mbuf == NULL) {
                        //PMD_INIT_LOG(ERR, "RX mbuf alloc failed "
                        //	     "queue_id=%hu", rxq->queue_id);
                        return -ENOMEM;
                }

                dma_addr = rte_cpu_to_le_64(rte_mbuf_data_iova_default(mbuf));

                rxd = &rxq->hw_ring[i];
                rxd->addr = dma_addr;
                rxd->opts2 = 0;
                rte_wmb();
                rxd->opts1 = rte_cpu_to_le_32(DescOwn | hw->rx_buf_sz);
                rxe[i].mbuf = mbuf;
        }

        //mark as last desc
        rxd->opts1 |= rte_cpu_to_le_32(RingEnd);

        return 0;
}

static int
rtl8168_hw_set_features(struct rtl_hw *hw, uint64_t offloads)
{
        u16 cp_cmd;

        cp_cmd = RTL_R16(hw, CPlusCmd);

        if (offloads & DEV_RX_OFFLOAD_CHECKSUM)
                cp_cmd |= RxChkSum;
        else
                cp_cmd &= ~RxChkSum;

        if (offloads & DEV_RX_OFFLOAD_VLAN_STRIP)
                cp_cmd |= RxVlan;
        else
                cp_cmd &= ~RxVlan;

        RTL_W16(hw, CPlusCmd, cp_cmd);

        return 0;
}

//rx_mode left to promiscuous_enable/disable
//mc_filter left to allmulticast_enable/disable and mc_addr_*
static void
rtl8168_hw_set_rx_packet_filter(struct rtl_hw *hw)
{
        int rx_mode;

        hw->hw_ops.hw_init_rxcfg(hw);

        rx_mode = AcceptBroadcast | AcceptMyPhys;
        RTL_W32(hw, RxConfig, rx_mode | (RTL_R32(hw, RxConfig)));
        //need to set default mc_filter to 0xffffffff?
}

int
rtl_rx_init(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        struct rtl_rx_queue *rxq;
        int ret;
        u32 csi_tmp;
        u32 rx_buf_sz;


        rxq = dev->data->rx_queues[0];

        if (rxq->mb_pool == NULL) {
                //LOG: rx queue not properly setup
                printf("r8168 rx queue pool not setup!\n");
                return -ENOMEM;
        }

        RTL_W32(hw, RxDescAddrLow, ((u64) rxq->hw_ring_phys_addr & DMA_BIT_MASK(32)));
        RTL_W32(hw, RxDescAddrHigh, ((u64) rxq->hw_ring_phys_addr >> 32));

        rx_buf_sz = rte_pktmbuf_data_room_size(rxq->mb_pool) - RTE_PKTMBUF_HEADROOM;
        rx_buf_sz = RTE_MIN(rx_buf_sz, dev->data->mtu + R8168_ETH_OVERHEAD);
        hw->rx_buf_sz = rx_buf_sz;

        ret = rtl_alloc_rx_queue_mbufs(rxq);
        if (ret) {
                printf("r8168 rx mbuf alloc failed!\n");
                return ret;
        }

        rtl8168_enable_cfg9346_write(hw);

        //rx ftr mcu enable
        switch (hw->mcfg) {
        case CFG_METHOD_16 ... CFG_METHOD_35:
                csi_tmp = rtl8168_eri_read(hw, 0xDC, 1, ERIAR_ExGMAC);
                csi_tmp &= ~BIT_0;
                rtl8168_eri_write(hw, 0xDC, 1, csi_tmp, ERIAR_ExGMAC);
                csi_tmp |= BIT_0;
                rtl8168_eri_write(hw, 0xDC, 1, csi_tmp, ERIAR_ExGMAC);
                break;
        }

        //RSS disable
        rtl8168_eri_write(hw, 0xC0, 2, 0x0000, ERIAR_ExGMAC); //queue num = 1
        rtl8168_eri_write(hw, 0xB8, 4, 0x00000000, ERIAR_ExGMAC);

        //Rx accept type and csum vlan offload
        rtl8168_hw_set_features(hw, rxq->offloads);

        //RMS
        RTL_W16(hw, RxMaxSize, rx_buf_sz);

        rtl8168_disable_rxdvgate(hw);

        /* Set Rx packet filter */
        rtl8168_hw_set_rx_packet_filter(hw);

        rtl8168_disable_cfg9346_write(hw);

        RTL_W8(hw, ChipCmd, RTL_R8(hw, ChipCmd) | CmdRxEnb);
        rxq->rx_en = 1;

        return 0;
}

static inline void rtl8168_mark_to_asic(struct rtl_rx_desc* rxd, u16 size)
{
        u32 eor = rte_le_to_cpu_32(rxd->opts1) & RingEnd;
        rxd->opts1 = rte_cpu_to_le_32(DescOwn | eor | size);
}

static inline uint64_t
rtl_rx_desc_error_to_pkt_flags(struct rtl_rx_queue *rxq,
                               uint32_t opts1,
                               uint32_t opts2)
{
        uint64_t pkt_flags = 0;

        if (!(rxq->offloads & DEV_RX_OFFLOAD_CHECKSUM))
                goto exit;

        /* rx csum offload for RTL8168C/8111C and RTL8168CP/8111CP */
        if (((opts2 & RxV4F) && !(opts1 & RxIPF)) || (opts2 & RxV6F)) {
                pkt_flags |= PKT_RX_IP_CKSUM_GOOD;
                if (((opts1 & RxTCPT) && !(opts1 & RxTCPF)) ||
                    ((opts1 & RxUDPT) && !(opts1 & RxUDPF)))
                        pkt_flags |= PKT_RX_L4_CKSUM_GOOD;
        }

exit:
        return pkt_flags;
}

uint16_t
rtl_recv_pkts(void *rx_queue, struct rte_mbuf **rx_pkts, uint16_t nb_pkts)
{
        struct rtl_rx_queue *rxq = (struct rtl_rx_queue *)rx_queue;
        struct rte_eth_dev *dev = &rte_eth_devices[rxq->port_id];
        struct rtl_hw *hw = rxq->hw;
        uint16_t nb_rx = 0;
        uint16_t nb_hold = 0;
        const uint16_t nb_rx_desc = rxq->nb_rx_desc;
        uint16_t tail = rxq->rx_tail;
        uint32_t opts1;
        uint32_t opts2;
        uint16_t pkt_len;
        struct rtl_rx_desc *rxd;
        struct rtl_rx_entry *rxe;
        struct rtl_rx_entry *sw_ring = rxq->sw_ring;
        struct rtl_rx_desc *hw_ring = rxq->hw_ring;
        struct rte_mbuf *new_mb;
        struct rte_mbuf *rmb;
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_sw_stats *stats = &adapter->sw_stats;
        uint64_t dma_addr;

        if (rxq->rx_en == 0) {
                RTL_W8(hw, ChipCmd, RTL_R8(hw, ChipCmd) | CmdRxEnb);
                rxq->rx_en = 1;
        }

        while (nb_rx < nb_pkts) {

                rxd = &hw_ring[tail];

                opts1 = rte_le_to_cpu_32(rxd->opts1);

                if (opts1 & DescOwn)
                        break;

                rte_rmb();

                if (unlikely(opts1 & RxRES)) {
                        stats->rx_errors++;
                        rtl8168_mark_to_asic(rxd, hw->rx_buf_sz);
                        nb_hold++;
                        tail = (tail + 1) % nb_rx_desc;
                } else {
                        //TODO offloads: KEEP_CRC case (kernel NETIF_F_RXFCS)
                        pkt_len = opts1 & 0x00003fff;
                        if (!(rxq->offloads & DEV_RX_OFFLOAD_KEEP_CRC))
                                pkt_len -= 4;
                        //fragmented frame
                        //if ((opts1 & (FirstFrag | LastFrag)) != (FirstFrag | LastFrag))
                        //	stats++;
                        //	mark to asic
                        //	continue;

                        opts2 = rte_le_to_cpu_32(rxd->opts2);

                        new_mb = rte_mbuf_raw_alloc(rxq->mb_pool);
                        if (new_mb == NULL) {
                                //PMD_RX_LOG(DEBUG,
                                //   "RX mbuf alloc failed port_id=%u "
                                //   "queue_id=%u", (unsigned int)rxq->port_id,
                                //   (unsigned int)rxq->queue_id);
                                //dev->data->rx_mbuf_alloc_failed++;
                                //adapter->sw_stats.rx_nombuf++;
                                goto err_stop;
                        }

                        //unlikely
                        if (1) {
                                uint8_t *data;
                                u32 i;
                                data = rte_pktmbuf_mtod(new_mb, uint8_t *);
                                for (i = 0; i < new_mb->buf_len; i += 64) {
                                        dccivac(data + i);
                                }
                        }

                        nb_hold++;
                        rxe = &sw_ring[tail];

                        rmb = rxe->mbuf;

                        //refill the rx desc
                        rxe->mbuf = new_mb;
                        dma_addr = rte_cpu_to_le_64(rte_mbuf_data_iova_default(new_mb));

                        /* setup RX descriptor */
                        rxd->addr = dma_addr;
                        rxd->opts2 = 0;
                        rte_wmb();
                        rtl8168_mark_to_asic(rxd, hw->rx_buf_sz);

                        //pkt_len = (uint16_t)rte_le_to_cpu_16(pkt_len);
                        rmb->data_off = RTE_PKTMBUF_HEADROOM;
                        rte_prefetch1((char *)rmb->buf_addr + rmb->data_off);
                        rmb->nb_segs = 1;
                        rmb->next = NULL;
                        rmb->pkt_len = pkt_len;
                        rmb->data_len = pkt_len;
                        rmb->ol_flags = rtl_rx_desc_error_to_pkt_flags(rxq, opts1, opts2);

                        rmb->port = rxq->port_id;

                        if (opts2 & RxVlanTag)
                                rmb->vlan_tci = rte_bswap16(opts2 & 0xffff);

                        tail = (tail + 1) % nb_rx_desc;

                        /* Prefetch next mbufs */
                        rte_prefetch0(sw_ring[tail].mbuf);

                        if ((tail & 0x3) == 0) {
                                rte_prefetch0(&sw_ring[tail]);
                                rte_prefetch0(&hw_ring[tail]);
                        }

                        /*
                         * Store the mbuf address into the next entry of the array
                         * of returned packets.
                         */
                        rx_pkts[nb_rx++] = rmb;

                        stats->rx_bytes += pkt_len;
                        stats->rx_packets++;
                }
        }

err_stop:

        rxq->rx_tail = tail;

        /*
         * If the number of free RX descriptors is greater than the RX free
         * threshold of the queue, advance the Receive Descriptor Tail (RDT)
         * register.
         * Update the RDT with the value of the last processed RX descriptor
         * minus 1, to guarantee that the RDT register is never equal to the
         * RDH register, which creates a "full" ring situation from the
         * hardware point of view...
         */
        nb_hold = (uint16_t)(nb_hold + rxq->nb_rx_hold);
        if (nb_hold > rxq->rx_free_thresh) {
                //PMD_RX_LOG(DEBUG, "port_id=%u queue_id=%u rx_tail=%u "
                //	"nb_hold=%u nb_rx=%u",
                //	(unsigned int)rxq->port_id, (unsigned int)rxq->queue_id,
                //	(unsigned int)tail, (unsigned int)nb_hold,
                //	(unsigned int)nb_rx);
                //tail = (uint16_t)((tail == 0) ?
                //	(nb_rx_desc - 1) : (tail - 1));

                //hw_atl_reg_rx_dma_desc_tail_ptr_set(hw, tail, rxq->queue_id);

                rte_wmb();

                RTL_W16(hw, IntrStatus, (RxOK | RxErr | RxDescUnavail)); //clear RDU

                nb_hold = 0;
        }

        rxq->nb_rx_hold = nb_hold;

        return nb_rx;
}



//---------------------------------Tx----------------------------------
static void
rtl_tx_queue_release_mbufs(struct rtl_tx_queue *txq)
{
        int i;

        PMD_INIT_FUNC_TRACE();

        if (txq != NULL) {
                if (txq->sw_ring != NULL) {
                        for (i = 0; i < txq->nb_tx_desc; i++) {
                                if (txq->sw_ring[i].mbuf != NULL) {
                                        rte_pktmbuf_free_seg(txq->sw_ring[i].mbuf);
                                        txq->sw_ring[i].mbuf = NULL;
                                }
                        }
                }
        }
}

void
rtl_tx_queue_release(void *tx_queue)
{
        PMD_INIT_FUNC_TRACE();

        if (tx_queue != NULL) {
                struct rtl_tx_queue * txq = (struct rtl_tx_queue *)tx_queue;
                rtl_tx_queue_release_mbufs(txq);
                rte_free(txq->sw_ring);
                rte_free(txq);
        }
}

void
rtl_txq_info_get(struct rte_eth_dev *dev, uint16_t queue_id,
                 struct rte_eth_txq_info *qinfo)
{
        struct rtl_tx_queue *txq;

        txq = dev->data->tx_queues[queue_id];

        qinfo->nb_desc = txq->nb_tx_desc;

        //qinfo->conf.tx_thresh.pthresh = txq->pthresh;
        //qinfo->conf.tx_thresh.hthresh = txq->hthresh;
        //qinfo->conf.tx_thresh.wthresh = txq->wthresh;
        //qinfo->conf.offloads = txq->offloads;
}

static void
rtl_reset_tx_queue(struct rtl_tx_queue *txq)
{
        static const struct rtl_tx_desc zero_txd = {0};
        uint16_t i;

        for (i = 0; i < txq->nb_tx_desc; i++) {
                txq->hw_ring[i] = zero_txd;
        }

        txq->hw_ring[txq->nb_tx_desc - 1].opts1 = rte_cpu_to_le_32(RingEnd);

        txq->tx_tail = 0;
        txq->tx_head = 0;
        //txq->tx_free = txq->nb_tx_desc - 1;
        txq->tx_free = txq->nb_tx_desc;
        txq->tx_en = 0;
}

uint64_t
rtl_get_tx_port_offloads(struct rte_eth_dev *dev __rte_unused)
{
        uint64_t tx_offload_capa;

        tx_offload_capa =
                DEV_TX_OFFLOAD_VLAN_INSERT |
                DEV_TX_OFFLOAD_IPV4_CKSUM  |
                DEV_TX_OFFLOAD_UDP_CKSUM   |
                DEV_TX_OFFLOAD_TCP_CKSUM   |
                DEV_TX_OFFLOAD_TCP_TSO     |
                DEV_TX_OFFLOAD_MULTI_SEGS;

        return tx_offload_capa;
}

int
rtl_tx_queue_setup(struct rte_eth_dev *dev, uint16_t queue_idx,
                   uint16_t nb_tx_desc, unsigned int socket_id,
                   const struct rte_eth_txconf *tx_conf)
{
        struct rtl_tx_queue *txq;
        const struct rte_memzone *mz;

        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        u32 size;

        PMD_INIT_FUNC_TRACE();

        /* make sure a valid number of descriptors have been requested */
        //if (nb_tx_desc < AQ_HW_MIN_TX_RING_SIZE ||
        //	nb_tx_desc > AQ_HW_MAX_TX_RING_SIZE) {
        //	PMD_INIT_LOG(ERR, "Number of Tx descriptors must be "
        //		"less than or equal to %d, "
        //		"greater than or equal to %d", AQ_HW_MAX_TX_RING_SIZE,
        //		AQ_HW_MIN_TX_RING_SIZE);
        //	return -EINVAL;
        //}

        if (nb_tx_desc < R8168_MIN_TX_DESC || nb_tx_desc > R8168_MAX_TX_DESC) {
                printf("r8168: Number of Tx descriptors must be "
                       "less than or equal to %d "
                       "greater than or equal to %d\n", R8168_MAX_TX_DESC,
                       R8168_MIN_TX_DESC);
                return -EINVAL;
        }

        /*
         * if this queue existed already, free the associated memory. The
         * queue cannot be reused in case we need to allocate memory on
         * different socket than was previously used.
         */
        if (dev->data->tx_queues[0] != NULL) {
                rtl_tx_queue_release(dev->data->tx_queues[0]);
                dev->data->tx_queues[0] = NULL;
        }

        txq = rte_zmalloc_socket("r8168 TX queue",
                                 sizeof(struct rtl_tx_queue),
                                 RTE_CACHE_LINE_SIZE,
                                 socket_id);

        if (txq == NULL)
                return -ENOMEM;

        /*
         * Allocate TX ring hardware descriptors. A memzone large enough to
         * handle the maximum ring size is allocated in order to allow for
         * resizing in later calls to the queue setup function.
         */
        size = sizeof(struct rtl_tx_desc) * nb_tx_desc;//R8168_MAX_TX_DESC;
        mz = rte_eth_dma_zone_reserve(dev, "tx_ring", queue_idx, size,
                                      R8168_RING_ALIGN, socket_id);
        if (mz == NULL) {
                rtl_tx_queue_release(txq);
                return -ENOMEM;
        }

        /* setup queue */
        txq->nb_tx_desc = nb_tx_desc;
        txq->port_id = dev->data->port_id;
        txq->queue_id = 0; //queue_idx is ignored
        txq->tx_free_thresh = tx_conf->tx_free_thresh;

        txq->hw = hw;
        txq->hw_ring = mz->addr;
        txq->hw_ring_phys_addr = mz->iova;

        //txq->hw_ring = gbd_addr_t_v;
        //txq->hw_ring_phys_addr = gbd_addr_t_p;
        //PMD_DRV_LOG(DEBUG, "iova: %ld, addr: %p, queue_idx: %d, nb_tx_desc: %d", mz->iova, mz->addr, queue_idx, nb_tx_desc);

        int index;
        index = abs((uint64_t)hw->mmio_addr - r8168_base_hw_addr) / 0x5000;
        printf("index: %d, mmio_addr: 0x%lx, r8168_base_hw_addr: 0x%lx\n", index, hw->mmio_addr, r8168_base_hw_addr);
        txq->hw_ring_phys_addr = r8168_gbd_addr_t_p[index];
        txq->hw_ring = (struct rtl_tx_desc *)r8168_gbd_addr_t_v[index];
        printf("hw tx ring size: %d:%ld[0x%lx:%p]\n",
                                                size,
                                                sizeof(struct rtl_tx_desc),
                                                txq->hw_ring_phys_addr,
                                                txq->hw_ring);


        txq->sw_ring = rte_zmalloc_socket("r8168 sw tx ring",
                                          nb_tx_desc * sizeof(struct rtl_tx_entry),
                                          RTE_CACHE_LINE_SIZE,
                                          socket_id);
        if (txq->sw_ring == NULL) {
                //PMD_INIT_LOG(ERR,
                //	"Port %d: Cannot allocate software ring for queue %d",
                //	txq->port_id, txq->queue_id);
                rte_free(txq);
                return -ENOMEM;
        }

        rtl_reset_tx_queue(txq);

        //dev->data->tx_queues[queue_idx] = txq;
        dev->data->tx_queues[0] = txq;
        return 0;
}

int
rtl_tx_init(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        struct rtl_tx_queue *txq;

        txq = dev->data->tx_queues[0];

        RTL_W32(hw, TxDescStartAddrLow, ((u64) txq->hw_ring_phys_addr & DMA_BIT_MASK(32)));
        RTL_W32(hw, TxDescStartAddrHigh, ((u64) txq->hw_ring_phys_addr >> 32));

        rtl8168_enable_cfg9346_write(hw);

        //set MTPS: MaxTxPktSize
        if (hw->mtu > ETH_DATA_LEN)
                RTL_W8(hw, MTPS, 0x27);
        else
                RTL_W8(hw, MTPS, Reserved1_data);

        //set TDFNR: TxDescFetchNumbeR
        switch (hw->mcfg) {
        case CFG_METHOD_9:
        case CFG_METHOD_10:
        case CFG_METHOD_14 ... CFG_METHOD_20:
                RTL_W8(hw, TDFNR, 0x8);
                break;
        default:
                RTL_W8(hw, TDFNR, 0x4);
                break;
        }

        rtl8168_disable_cfg9346_write(hw);


        RTL_W8(hw, ChipCmd, RTL_R8(hw, ChipCmd) | CmdTxEnb);
        txq->tx_en = 1;

        return 0;
}

static inline uint32_t
rtl_tx_vlan_tag(struct rte_mbuf *tx_pkt, uint64_t ol_flags)
{
        return (ol_flags & PKT_TX_VLAN_PKT) ?
               (TxVlanTag | rte_bswap16(tx_pkt->vlan_tci)) :
               0;
}

static inline int
rtl_tso_setup(struct rte_mbuf *tx_pkt, uint64_t ol_flags, u32 *opts)
{
        /* check if TCP segmentation required for this packet */
        if (ol_flags & PKT_TX_TCP_SEG) {
                uint32_t mss = tx_pkt->tso_segsz;
                uint64_t l4_offset = tx_pkt->l2_len + tx_pkt->l3_len;

                if (l4_offset <= GTTCPHO_MAX) {
                        /* implies IP cksum in IPv4 */
                        if (ol_flags & PKT_TX_IP_CKSUM) {
                                opts[0] |= GiantSendv4;
                                opts[0] |= l4_offset << GTTCPHO_SHIFT;
                                opts[1] |= RTE_MIN(mss, MSS_MAX) << 18;
                        } else {
                                opts[0] |= GiantSendv6;
                                opts[0] |= l4_offset << GTTCPHO_SHIFT;
                                opts[1] |= RTE_MIN(mss, MSS_MAX) << 18;
                        }

                        return 1;
                }
        }

        return 0;
}

static inline int
rtl_setup_csum_offload(struct rtl_hw *hw __rte_unused,
                       struct rte_mbuf *tx_pkt,
                       uint64_t ol_flags,
                       uint32_t *opts)
{
        uint32_t csum_cmd = 0;

        if (ol_flags & PKT_TX_IP_CKSUM)
                csum_cmd |= TxIPCS_C;

        switch (ol_flags & PKT_TX_L4_MASK) {
        case PKT_TX_UDP_CKSUM:
                csum_cmd |= TxUDPCS_C;
                break;
        case PKT_TX_TCP_CKSUM:
                csum_cmd |= TxTCPCS_C;
                break;
        }

        if (csum_cmd != 0) {
                if (ol_flags & PKT_TX_IPV6) {
                        uint64_t l4_offset = tx_pkt->l2_len + tx_pkt->l3_len;
                        csum_cmd |= TxIPV6F_C;
                        csum_cmd |= l4_offset << TCPHO_SHIFT;
                } else
                        csum_cmd |= TxIPCS_C;

                opts[1] |= csum_cmd;
        }

        return 0;
}

static inline void
rtl_xmit_pkt(struct rtl_hw *hw, struct rtl_tx_queue *txq,
             struct rte_mbuf *tx_pkt)
{
        uint64_t buf_dma_addr;
        struct rte_mbuf *m_seg;

        struct rtl_tx_desc *txd = NULL;
        struct rtl_tx_entry *txe = NULL;

        uint16_t desc_count = 0;
        const uint16_t nb_tx_desc = txq->nb_tx_desc;
        int tail = 0;
        u32 len;
        //u32 pay_len;
        u32 opts[2] = {0};
        int large_send;
        struct rte_eth_dev *dev = &rte_eth_devices[txq->port_id];
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_sw_stats *stats = &adapter->sw_stats;
        uint64_t ol_flags;
        uint64_t tx_ol_flags;
        //PMD_DRV_LOG(DEBUG, "");
        //printf("=== rtl_xmit_pkt ===\n");

        //like cur_tx
        tail = txq->tx_tail;

        /* If hardware offload required */
        ol_flags = tx_pkt->ol_flags;
        tx_ol_flags = ol_flags & RTL_TX_OFFLOAD_MASK;

        opts[0] = DescOwn;
        opts[1] = rtl_tx_vlan_tag(tx_pkt, tx_ol_flags);

        large_send = rtl_tso_setup(tx_pkt, tx_ol_flags, opts);

        if (large_send == 0)
                rtl_setup_csum_offload(hw, tx_pkt, tx_ol_flags, opts);

        for (m_seg = tx_pkt; m_seg; m_seg = m_seg->next) {
                u32 opts1 = opts[0];
                u32 opts2 = opts[1];

                len = m_seg->data_len;

                if (len == 0)
                        break;

                txd = &txq->hw_ring[tail];

                buf_dma_addr = rte_mbuf_data_iova(m_seg);
                txd->addr = rte_cpu_to_le_64(buf_dma_addr);

                if (1) {
                        uint8_t *data;
                        u32 i;
                        data = rte_pktmbuf_mtod(m_seg, uint8_t *);
                        for (i = 0; i < len; i += 64) {
                                dcbf(data + i);
                        }
                }

                opts1 |= len;
                if (m_seg == tx_pkt)
                        opts1 |= FirstFrag;
                if (!m_seg->next)
                        opts1 |= LastFrag;
                if (tail == nb_tx_desc - 1)
                        opts1 |= RingEnd;

                /* Store mbuf for freeing later */
                txe = &txq->sw_ring[tail];

                if (txe->mbuf)
                        rte_pktmbuf_free_seg(txe->mbuf);

                txe->mbuf = m_seg;

                txd->opts2 = rte_cpu_to_le_32(opts2);
                rte_wmb();
                txd->opts1 = rte_cpu_to_le_32(opts1);

                tail = (tail + 1) % nb_tx_desc;

                desc_count++;

                stats->tx_bytes += len;
        }

        txq->tx_tail = tail;
        txq->tx_free -= desc_count;

        stats->tx_packets++;

        //adapter->sw_stats.q_opackets[txq->queue_id]++;
        //adapter->sw_stats.q_obytes[txq->queue_id] += pay_len;
}

static void
rtl_tx_clean(struct rtl_hw *hw __rte_unused, struct rtl_tx_queue *txq)
{
        if (txq != NULL) {
                struct rtl_tx_entry *sw_ring = txq->sw_ring;
                struct rtl_tx_entry *txe;
                struct rtl_tx_desc *txd;
                const uint16_t nb_tx_desc = txq->nb_tx_desc;
                const int tx_tail = txq->tx_tail;
                int head = txq->tx_head;
                uint16_t desc_freed = 0;
                u32 status;

                while (1) {
                        txd = &txq->hw_ring[head];

                        status = rte_le_to_cpu_32(txd->opts1);

                        if (status & DescOwn)
                                break;

                        txe = &sw_ring[head];
                        if (txe->mbuf) {
                                rte_pktmbuf_free_seg(txe->mbuf);
                                txe->mbuf = NULL;
                        }

                        head = (head + 1) % nb_tx_desc;
                        desc_freed++;

                        if (head == tx_tail)
                                break;
                }

                txq->tx_free += desc_freed;
                txq->tx_head = head;
        }
}

int
rtl_tx_done_cleanup(void *tx_queue, uint32_t free_cnt)
{
        struct rtl_tx_queue *txq = tx_queue;

        if (txq != NULL) {
                //struct rtl_hw *hw = txq->hw;
                const int tx_tail = txq->tx_tail;
                struct rtl_tx_entry *sw_ring = txq->sw_ring;
                struct rtl_tx_entry *txe;
                struct rtl_tx_desc *txd;
                const uint16_t nb_tx_desc = txq->nb_tx_desc;
                int head = txq->tx_head;
                uint16_t desc_freed = 0;
                int count = 0;
                u32 status;

                while (1) {
                        txd = &txq->hw_ring[head];

                        status = rte_le_to_cpu_32(txd->opts1);

                        if (status & DescOwn)
                                break;

                        txe = &sw_ring[head];
                        if (txe->mbuf) {
                                rte_pktmbuf_free_seg(txe->mbuf);
                                txe->mbuf = NULL;
                        }

                        head = (head + 1) % nb_tx_desc;
                        desc_freed++;

                        if (status & LastFrag) {
                                count++;
                                if ((uint32_t)count == free_cnt)
                                        break;
                        }

                        if (head == tx_tail)
                                break;
                }

                txq->tx_free += desc_freed;
                txq->tx_head = head;

                return count;
        }

        return -ENODEV;
}

uint16_t
rtl_xmit_pkts(void *tx_queue, struct rte_mbuf **tx_pkts, uint16_t nb_pkts)
{
        struct rtl_tx_queue *txq = tx_queue;
        struct rtl_hw *hw = txq->hw;

        struct rte_mbuf *tx_pkt;
        uint16_t nb_tx;

        if (txq->tx_en == 0) {
                RTL_W8(hw, ChipCmd, RTL_R8(hw, ChipCmd) | CmdTxEnb);
                txq->tx_en = 1;
        }

        //PMD_TX_LOG(DEBUG,
        //	"port %d txq %d pkts: %d tx_free=%d tx_tail=%d tx_head=%d",
        //	txq->port_id, txq->queue_id, nb_pkts, txq->tx_free,
        //	txq->tx_tail, txq->tx_head);

        //printf("r8168 xmit pkts: tx_free %d, nb_pkts: %d, tx_tail %d\n", txq->tx_free, nb_pkts, txq->tx_tail);

        for (nb_tx = 0; nb_tx < nb_pkts; nb_tx++) {

                tx_pkt = *tx_pkts++;

                //if (txq->tx_free < txq->tx_free_thresh)
                //        rtl_tx_clean(hw, txq);

                if (txq->tx_free < tx_pkt->nb_segs)
                        break;

                if ((tx_pkt->nb_segs == 0) ||
                    (tx_pkt->pkt_len == 0) ||
                    ((tx_pkt->nb_segs > 1) && (tx_pkt->next == NULL)))
                        break;

                rtl_xmit_pkt(hw, txq, tx_pkt);
        }

        //RTL_W16(hw, IntrStatus, (TxOK | TxErr | TxDescUnavail));
        rte_wmb();

        if (nb_tx > 0)
                RTL_W8(hw, TxPoll, NPQ);

        //printf("r8168 xmit burst %d pkts, tail = %d, head = %d\n",
        //	nb_tx, txq->tx_tail, txq->tx_head);
        //PMD_TX_LOG(DEBUG, "rtl_xmit_pkts %d transmitted", nb_tx);

        rtl_tx_clean(hw, txq);

        return nb_tx;

}

/*
static void
rtl_dump_rx_queue(struct rtl_rx_queue *rxq)
{
        uint16_t tail = rxq->rx_tail;
        u32 status;
        struct rtl_rx_desc *rxd;
        int i;

        printf("--------r8168 debug dump port %d, rx queue from tail %d:------\n", rxq->port_id, tail);
        for (i = 0; i < rxq->nb_rx_desc; i++) {

                rxd = &rxq->hw_ring[tail];
                status = rte_le_to_cpu_32(rxd->opts1);
                printf("index = %d, status = %x\n", tail, status);
                tail = (tail + 1) % rxq->nb_rx_desc;
        }
}
*/

int
rtl_stop_queues(struct rte_eth_dev *dev)
{
        struct rtl_tx_queue *txq;
        struct rtl_rx_queue *rxq;

        PMD_INIT_FUNC_TRACE();
        //rtl_dump_rx_queue(dev->data->rx_queues[0]);

        txq = dev->data->tx_queues[0];

        rtl_tx_queue_release_mbufs(txq);
        rtl_reset_tx_queue(txq);

        rxq = dev->data->rx_queues[0];

        rtl_rx_queue_release_mbufs(rxq);
        rtl_reset_rx_queue(rxq);

        return 0;
}

void
rtl_free_queues(struct rte_eth_dev *dev)
{
        PMD_INIT_FUNC_TRACE();

        rtl8168_eth_dma_zone_free(dev, "rx_ring", 0);
        rtl_rx_queue_release(dev->data->rx_queues[0]);
        dev->data->rx_queues[0] = 0;
        dev->data->nb_rx_queues = 0;

        rtl8168_eth_dma_zone_free(dev, "tx_ring", 0);
        rtl_tx_queue_release(dev->data->tx_queues[0]);
        dev->data->tx_queues[0] = 0;
        dev->data->nb_tx_queues = 0;
}
