/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#include <sys/queue.h>
#include <stdio.h>
#include <errno.h>
#include <stdint.h>
#include <stdarg.h>
#include <unistd.h>

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
#include "r8168_dash.h"
#include "r8168_hw.h"
#include "r8168_phy.h"
#include "r8168_logs.h"
#include "base/rtl8168g.h"
#include "base/rtl8168h.h"
#include "base/rtl8168ep.h"
#include "base/rtl8168fp.h"

static int rtl_dev_start(struct rte_eth_dev *dev);
static void rtl_dev_stop(struct rte_eth_dev *dev);
static int rtl_dev_reset(struct rte_eth_dev *dev);
static int rtl_dev_set_link_up(struct rte_eth_dev *dev);
static int rtl_dev_set_link_down(struct rte_eth_dev *dev);
static void rtl_dev_close(struct rte_eth_dev *dev);
static int rtl_dev_configure(struct rte_eth_dev *dev __rte_unused);

static int rtl_fw_version_get(struct rte_eth_dev *dev, char *fw_version, size_t fw_size);
static int rtl_dev_infos_get(struct rte_eth_dev *dev, struct rte_eth_dev_info *dev_info);
static int rtl_dev_mtu_set(struct rte_eth_dev *dev, uint16_t mtu);

static int rtl_promiscuous_enable(struct rte_eth_dev *dev);
static int rtl_promiscuous_disable(struct rte_eth_dev *dev);
static int rtl_allmulticast_enable(struct rte_eth_dev *dev);
static int rtl_allmulticast_disable(struct rte_eth_dev *dev);

static int rtl_dev_link_update(struct rte_eth_dev *dev, int wait __rte_unused);
static int rtl_dev_stats_get(struct rte_eth_dev *dev, struct rte_eth_stats *rte_stats);
static int rtl_dev_stats_reset(struct rte_eth_dev *dev);
/*
 * The set of PCI devices this driver supports
 */
static const struct rte_pci_id pci_id_r8168_map[] = {
        { RTE_PCI_DEVICE(R8168_REALTEK_VENDOR_ID, R8168_DEV_ID) },
        { .vendor_id = 0, /* sentinel */ },
};


static const struct rte_eth_desc_lim rx_desc_lim = {
        .nb_max = R8168_MAX_RX_DESC,
        .nb_min = R8168_MIN_RX_DESC,
        .nb_align = R8168_DESC_ALIGN,
};

static const struct rte_eth_desc_lim tx_desc_lim = {
        .nb_max = R8168_MAX_TX_DESC,
        .nb_min = R8168_MIN_TX_DESC,
        .nb_align = R8168_DESC_ALIGN,
        .nb_seg_max = R8168_MAX_TX_SEG,
        .nb_mtu_seg_max = R8168_MAX_TX_SEG,
};

static const struct eth_dev_ops rtl_eth_dev_ops = {
        .dev_configure	      = rtl_dev_configure,
        .dev_start	      = rtl_dev_start,
        .fw_version_get       = rtl_fw_version_get,
        .dev_infos_get        = rtl_dev_infos_get,
        .dev_stop	      = rtl_dev_stop,
        .dev_set_link_up      = rtl_dev_set_link_up,
        .dev_set_link_down    = rtl_dev_set_link_down,
        .dev_close	      = rtl_dev_close,
        .dev_reset	      = rtl_dev_reset,

        .promiscuous_enable   = rtl_promiscuous_enable,
        .promiscuous_disable  = rtl_promiscuous_disable,
        .allmulticast_enable  = rtl_allmulticast_enable,
        .allmulticast_disable = rtl_allmulticast_disable,

        .link_update	      = rtl_dev_link_update,
        .stats_get            = rtl_dev_stats_get,
        .stats_reset          = rtl_dev_stats_reset,

        .mtu_set              = rtl_dev_mtu_set,

        .rx_queue_setup       = rtl_rx_queue_setup,
        .rx_queue_release     = rtl_rx_queue_release,
        .rxq_info_get         = rtl_rxq_info_get,

        .tx_queue_setup       = rtl_tx_queue_setup,
        .tx_queue_release     = rtl_tx_queue_release,
        .tx_done_cleanup      = rtl_tx_done_cleanup,
        .txq_info_get         = rtl_txq_info_get,
};

#define R8168_LINK_CHECK_WAIT 4000 //1s
#define R8168_LINK_CHECK_TIMEOUT 50 //10s
#define R8168_LINK_CHECK_INTERVAL 200 //ms


static int
rtl_dev_configure(struct rte_eth_dev *dev __rte_unused)
{
        return 0;
}

static int
rtl_fw_version_get(struct rte_eth_dev *dev, char *fw_version, size_t fw_size)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        int ret;

        ret = snprintf(fw_version, fw_size, "0x%08x", hw->hw_ram_code_ver);

        ret += 1; /* add the size of '\0' */
        if (fw_size < (u32)ret)
                return ret;
        else
                return 0;
}

static int
rtl_dev_infos_get(struct rte_eth_dev *dev, struct rte_eth_dev_info *dev_info)
{

        dev_info->min_rx_bufsize = 1024;
        dev_info->max_rx_pktlen  = RTE_ETHER_MAX_VLAN_FRAME_LEN; //1522
        dev_info->max_mac_addrs = 1;

        dev_info->max_rx_queues = 1; //rss to do
        dev_info->max_tx_queues = 1;

        dev_info->default_rxconf = (struct rte_eth_rxconf) {
                .rx_free_thresh = R8168_RX_FREE_THRESH,
        };

        dev_info->default_txconf = (struct rte_eth_txconf) {
                .tx_free_thresh = R8168_TX_FREE_THRESH,
        };

        dev_info->rx_desc_lim = rx_desc_lim;
        dev_info->tx_desc_lim = tx_desc_lim;

        dev_info->speed_capa = ETH_LINK_SPEED_10M_HD | ETH_LINK_SPEED_10M |
                               ETH_LINK_SPEED_100M_HD | ETH_LINK_SPEED_100M |
                               ETH_LINK_SPEED_1G;

        dev_info->min_mtu = RTE_ETHER_MIN_MTU;
        dev_info->max_mtu = dev_info->max_rx_pktlen - R8168_ETH_OVERHEAD;
        //dev_info->rx_queue_offload_capa = rtl_get_rx_queue_offloads(dev);
        dev_info->rx_offload_capa = (rtl_get_rx_port_offloads(dev) |
                                     dev_info->rx_queue_offload_capa);
        //dev_info->tx_queue_offload_capa = rtl_get_tx_queue_offloads(dev);
        dev_info->tx_offload_capa = rtl_get_tx_port_offloads(dev);

        return 0;
}

static int
rtl_dev_stats_reset(struct rte_eth_dev *dev)
{

        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        rtl8168_clear_tally_stats(hw);

        memset(&adapter->sw_stats, 0, sizeof(adapter->sw_stats));

        return 0;
}

static void
rtl_sw_stats_get(struct rte_eth_dev *dev, struct rte_eth_stats *rte_stats)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_sw_stats *sw_stats = &adapter->sw_stats;

        //rte_stats->ipackets = sw_stats->rx_packets;
        //rte_stats->opackets = sw_stats->tx_packets;
        rte_stats->ibytes = sw_stats->rx_bytes;
        rte_stats->obytes = sw_stats->tx_bytes;
}

static int
rtl_dev_stats_get(struct rte_eth_dev *dev, struct rte_eth_stats *rte_stats)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        if (rte_stats == NULL)
                return -EINVAL;

        //debug
        //rtl_dump_pci_reg(hw);

        rtl8168_get_tally_stats(hw, rte_stats);
        rtl_sw_stats_get(dev, rte_stats);

        return 0;

}

/* return 0 means link status changed, -1 means not changed */
static int
rtl_dev_link_update(struct rte_eth_dev *dev, int wait __rte_unused)
{
        struct rte_eth_link link, old;
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        u8 status;
        u32 speed;

        link.link_status = ETH_LINK_DOWN;
        link.link_speed = 0;
        link.link_duplex = ETH_LINK_FULL_DUPLEX;
        link.link_autoneg = ETH_LINK_AUTONEG;

        memset(&old, 0, sizeof(old));

        /* load old link status */
        rte_eth_linkstatus_get(dev, &old);

        /* read current link status */
        status = RTL_R8(hw, PHYstatus);

        if (status & LinkStatus) {
                link.link_status = ETH_LINK_UP;
                link.link_duplex = ETH_LINK_FULL_DUPLEX;

                if (status & _1000bpsF)
                        speed = 1000;
                else if (status & _100bps)
                        speed = 100;
                else
                        speed = 10;

                link.link_speed = speed;
        }

        if (link.link_status == old.link_status)
                return -1;

        rte_eth_linkstatus_set(dev, &link);

        if (RTL_R8(hw, PHYstatus) & FullDup)
                RTL_W32(hw, TxConfig, (RTL_R32(hw, TxConfig) | (BIT_24 | BIT_25)) & ~BIT_19);
        else
                RTL_W32(hw, TxConfig, (RTL_R32(hw, TxConfig) | BIT_25) & ~(BIT_19 | BIT_24));

        return 0;
}

static int
rtl_dev_set_link_up(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        rtl8168_powerup_pll(hw);

        return 0;
}

static int
rtl_dev_set_link_down(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        rtl8168_powerdown_pll(hw);

        return 0;
}

static int
rtl_dev_mtu_set(struct rte_eth_dev *dev, uint16_t mtu)
{
        struct rte_eth_dev_info dev_info;
        int ret;
        uint32_t frame_size = mtu + R8168_ETH_OVERHEAD;

        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        ret = rtl_dev_infos_get(dev, &dev_info);
        if (ret != 0)
                return ret;

        if (mtu < RTE_ETHER_MIN_MTU || frame_size > dev_info.max_rx_pktlen)
                return -EINVAL;

        hw->mtu = mtu;
        //hw->rx_buf_sz = (mtu > ETH_DATA_LEN) ? mtu + ETH_HLEN + 8 + 1 : RX_BUF_SIZE;

        //need reinit rx ring?

        RTL_W16(hw, RxMaxSize, frame_size);

        return 0;
}

static int
rtl_promiscuous_enable(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        int rx_mode = AcceptBroadcast | AcceptMulticast | AcceptMyPhys | AcceptAllPhys;

        RTL_W32(hw, RxConfig, rx_mode | (RTL_R32(hw, RxConfig)));
        RTL_W32(hw, MAR0 + 0, 0xffffffff);
        RTL_W32(hw, MAR0 + 4, 0xffffffff);

        return 0;
}

static int
rtl_promiscuous_disable(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        int rx_mode = ~AcceptAllPhys;

        RTL_W32(hw, RxConfig, rx_mode & (RTL_R32(hw, RxConfig)));

        if (dev->data->all_multicast == 1) {
                RTL_W32(hw, MAR0 + 0, 0xffffffff);
                RTL_W32(hw, MAR0 + 4, 0xffffffff);
        }

        return 0;
}

static int
rtl_allmulticast_enable(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        RTL_W32(hw, MAR0 + 0, 0xffffffff);
        RTL_W32(hw, MAR0 + 4, 0xffffffff);

        return 0;
}

static int
rtl_allmulticast_disable(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        if (dev->data->promiscuous == 1)
                return 0; /* must remain in all_multicast mode */

        RTL_W32(hw, MAR0 + 0, 0);
        RTL_W32(hw, MAR0 + 4, 0);

        return 0;
}

//static void dump_pci_dev(struct rte_pci_device *dev) {
//
//	int i;
//	printf("xing dump pci resources:\n");
//	for (i = 0; i != sizeof(dev->mem_resource) /
//		sizeof(dev->mem_resource[0]); i++) {
//		printf("resource %d, physaddr %x, vaddr %x;",
//			i, dev->mem_resource[i].phys_addr, dev->mem_resource[i].addr);
//	}
//}

static void
rtl8168_disable_intr(struct rtl_hw *hw)
{
        PMD_INIT_FUNC_TRACE();
        RTL_W16(hw, IntrMask, 0x0000);
        RTL_W16(hw, IntrStatus, RTL_R16(hw, IntrStatus));
}

static void
rtl8168_enable_intr(struct rtl_hw *hw)
{
        PMD_INIT_FUNC_TRACE();
        RTL_W16(hw, IntrMask, LinkChg);
}

static void
rtl8168_hw_init(struct rtl_hw *hw)
{
        u32 data;
        u32 csi_tmp;

        rtl8168_disable_aspm_clkreq_internal(hw);

        rtl8168_disable_ups(hw);

        rtl8168_disable_dma_agg(hw);

        switch (hw->mcfg) {
        case CFG_METHOD_9:
        case CFG_METHOD_10:
                RTL_W8(hw, DBG_reg, RTL_R8(hw, DBG_reg) | BIT_1 | BIT_7);
                break;
        }
        //omit dbg off for cfg8,cfg9

        switch (hw->mcfg) {
        case CFG_METHOD_14 ... CFG_METHOD_19:
                RTL_W8(hw, 0xF2, (RTL_R8(hw, 0xF2) & ~(BIT_2 | BIT_1 | BIT_0)));
                break;
        }

        //omit aspm enable IO 0x6E and ERI 0x1AE

        switch (hw->mcfg) {
        case CFG_METHOD_10:
        case CFG_METHOD_14:
        case CFG_METHOD_15:
                RTL_W8(hw, 0xF3, RTL_R8(hw, 0xF3) | BIT_2);
                break;
        }

        hw->hw_ops.hw_mac_mcu_config(hw);

        /*disable ocp phy power saving*/
        switch (hw->mcfg) {
        case CFG_METHOD_25 ... CFG_METHOD_35:
                rtl8168_disable_ocp_phy_power_saving(hw);
                break;
        }

        //Set PCIE uncorrectable error status mask pcie 0x108
        csi_tmp = rtl8168_csi_read(hw, 0x108);
        csi_tmp |= BIT_20;
        rtl8168_csi_write(hw, 0x108, csi_tmp);

        //mcu pme setting
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_24:
                data = rtl8168_eri_read(hw, 0x1AB, 1, ERIAR_ExGMAC);
                data |= ( BIT_2 | BIT_3 | BIT_4 | BIT_5 | BIT_6 | BIT_7 );
                rtl8168_eri_write(hw, 0x1AB, 1, data, ERIAR_ExGMAC);
                break;
        }

        //to check
        //rtl8168_set_pci_pme(hw, 0);

        //omit enable magic

}

static void
rtl8168_hw_ephy_config(struct rtl_hw *hw)
{
        hw->hw_ops.hw_ephy_config(hw);
}

static void
rtl8168_enable_exit_l1_mask(struct rtl_hw *hw)
{
        u32 csi_tmp;

        switch (hw->mcfg) {
        case CFG_METHOD_16:
        case CFG_METHOD_17:
        case CFG_METHOD_18:
        case CFG_METHOD_19:
                csi_tmp = rtl8168_eri_read(hw, 0xD4, 4, ERIAR_ExGMAC);
                csi_tmp |= (BIT_8 | BIT_9 | BIT_10 | BIT_11 | BIT_12);
                rtl8168_eri_write(hw, 0xD4, 4, csi_tmp, ERIAR_ExGMAC);
                break;
        case CFG_METHOD_20:
                csi_tmp = rtl8168_eri_read(hw, 0xD4, 4, ERIAR_ExGMAC);
                csi_tmp |= (BIT_10 | BIT_11);
                rtl8168_eri_write(hw, 0xD4, 4, csi_tmp, ERIAR_ExGMAC);
                break;
        case CFG_METHOD_21 ... CFG_METHOD_35:
                csi_tmp = rtl8168_eri_read(hw, 0xD4, 4, ERIAR_ExGMAC);
                csi_tmp |= (BIT_7 | BIT_8 | BIT_9 | BIT_10 | BIT_11 | BIT_12);
                rtl8168_eri_write(hw, 0xD4, 4, csi_tmp, ERIAR_ExGMAC);
                break;
        }
}

static void
rtl8168_hw_config(struct rtl_hw *hw)
{
        u32 csi_tmp;
        //set RxConfig to default
        RTL_W32(hw, RxConfig, (RX_DMA_BURST << RxCfgDMAShift));

        rtl8168_nic_reset(hw);

        rtl8168_enable_cfg9346_write(hw);

        //disable aspm clkreq internal
        switch (hw->mcfg) {
        case CFG_METHOD_14 ... CFG_METHOD_35:
                RTL_W8(hw, 0xF1, RTL_R8(hw, 0xF1) & ~BIT_7);
                RTL_W8(hw, Config2, RTL_R8(hw, Config2) & ~BIT_7);
                RTL_W8(hw, Config5, RTL_R8(hw, Config5) & ~BIT_0);
                break;
        }

        //clear io_rdy_l23
        switch (hw->mcfg) {
        case CFG_METHOD_20 ... CFG_METHOD_35:
                RTL_W8(hw, Config3, RTL_R8(hw, Config3) & ~BIT_1);
                break;
        }

        //keep magic packet only
        switch (hw->mcfg) {
        case CFG_METHOD_16 ... CFG_METHOD_35:
                csi_tmp = rtl8168_eri_read(hw, 0xDE, 1, ERIAR_ExGMAC);
                csi_tmp &= BIT_0;
                rtl8168_eri_write(hw, 0xDE, 1, csi_tmp, ERIAR_ExGMAC);
                break;
        }

        //omit magic wol setting

        //TODO interrupt mitigation
        //hw->cp_cmd |= INTT_1;
        //RTL_W16(hw, IntrMitigate, 0x5f51);

        //set TxConfig to default
        RTL_W32(hw, TxConfig, (TX_DMA_BURST_unlimited << TxDMAShift) |
                (InterFrameGap << TxInterFrameGapShift));

        hw->hw_ops.hw_config(hw);

        //other hw parameters
        //10M IFG?
        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_28:
                rtl8168_eri_write(hw, 0x2F8, 2, 0x1D8F, ERIAR_ExGMAC);
                break;
        }

        //omit (hw->bios_setting & BIT_28) processing

        rtl8168_enable_exit_l1_mask(hw);

        switch (hw->mcfg) {
        case CFG_METHOD_25:
                rtl8168_mac_ocp_write(hw, 0xD3C0, 0x0B00);
                rtl8168_mac_ocp_write(hw, 0xD3C2, 0x0000);
                break;
        case CFG_METHOD_29:
        case CFG_METHOD_30:
        case CFG_METHOD_35:
                rtl8168_mac_ocp_write(hw, 0xE098, 0x0AA2);
                break;
        case CFG_METHOD_31:
        case CFG_METHOD_32:
        case CFG_METHOD_33:
        case CFG_METHOD_34:
                rtl8168_mac_ocp_write(hw, 0xE098, 0xC302);
                break;
        }


        //omit LTR workaround: OCP 0xD3C0 or 0xE098
        //omit aspm offset99, offset180

        //moved to rx init
        //rtl8168_hw_set_features(hw, adapter->features);

        //ALDPS??
        switch (hw->mcfg) {
        case CFG_METHOD_16 ... CFG_METHOD_35: {
                int timeout;
                for (timeout = 0; timeout < 10; timeout++) {
                        if ((rtl8168_eri_read(hw, 0x1AE, 2, ERIAR_ExGMAC) & BIT_13)==0)
                                break;
                        mdelay(1);
                }
        }
        }

        //moved to rx init
        //RTL_W16(hw, RxMaxSize, hw->rx_buf_sz);
        //rtl8168_disable_rxdvgate(hw);
        ///* Set Rx packet filter */
        //rtl8168_hw_set_rx_packet_filter(hw);

        //omit re-enable aspm

        //force internal clkreq disable
        //RTL_W8(hw, Config2, RTL_R8(hw, Config2) & ~BIT_7);

        rtl8168_disable_cfg9346_write(hw);

        udelay(10);
}

void rtl_dump_pci_reg(struct rtl_hw *hw)
{
        int i;
        printf("dump pci regs:\n");
        for (i = 0; i < 64; i++) {
                if(i % 4 == 0)
                        printf("0x%08x:\t", 4*i);
                printf("%08x ", rtl8168_csi_read(hw, 4*i));
                if(i % 4 == 3)
                        printf("\n");
        }
}

void rtl_dump_mac_reg(struct rtl_hw *hw)
{
        int i;
        printf("mac io regs:\n");
        for (i = 0; i < 256; i++) {
                if(i % 16 == 0)
                        printf("0x%02x:\t", i);
                printf("%02x ", RTL_R8(hw, i));
                if(i % 16 == 15)
                        printf("\n");
        }

        printf("phy std-mii regs:\n");
        for (i = 0; i < 16; i++) {
                if(i % 8 == 0)
                        printf("0x%02x:\t", i);
                printf("%04x ",rtl8168_mdio_read(hw, i));
                if(i % 8 == 7)
                        printf("\n");
        }

}

static void
rtl_hw_initialize(struct rtl_hw *hw)
{

        rtl8168_init_software_variable(hw);

        rtl8168_exit_oob(hw);

        rtl8168_hw_init(hw);

        rtl8168_nic_reset(hw);

        //kernel r8168 has net_carrier_off function, we dont enable rxdv here
        //rtl8168_disable_rxdvgate(hw);
}

static void
rtl_dev_interrupt_handler(void *param)
{
        struct rte_eth_dev *dev = (struct rte_eth_dev *)param;
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        uint16_t intr;

        intr = RTL_R16(hw, IntrStatus);

        /* clear all cause mask */
        rtl8168_disable_intr(hw);

        if (intr & LinkChg)
                rtl_dev_link_update(dev, 0);
        else
                printf("r8168: interrupt unhandled.\n");

        rtl8168_enable_intr(hw);
}

#include <sys/mman.h>
#include <fcntl.h>

#define STMMAC_UIO_MAX_DEVICE_FILE_NAME_LENGTH	30
#define STMMAC_UIO_MAX_ATTR_FILE_NAME	100
#define STMMAC_UIO_DEVICE_SYS_ATTR_PATH	"/sys/class/uio"
#define STMMAC_UIO_DEVICE_SYS_MAP_ATTR	"maps/map"
#define STMMAC_UIO_DEVICE_FILE_NAME	"/dev/uio"
#define STMMAC_UIO_REG_MAP_ID		0
#define STMMAC_UIO_RX_BD_MAP_ID	1
#define STMMAC_UIO_TX_BD_MAP_ID	2
#define STMMAC_UIO_RX_BD1_MAP_ID	3
#define STMMAC_UIO_TX_BD1_MAP_ID	4

//The intel using /dev/uio0/1/2/3 and rtl8111h r8168_uio_cnt start from number 4.
static int r8168_uio_cnt = 0;
uint64_t r8168_base_hw_addr = 0;
static int rconfig_stmmac_uio(uint64_t hw_addr);
uint32_t		r8168_gbd_addr_b_p[5];
uint32_t		r8168_gbd_addr_r_p[5];
uint32_t		r8168_gbd_addr_t_p[5];
uint32_t		r8168_gbd_addr_x_p[5];

void			*r8168_gbd_addr_b_v[5];
void			*r8168_gbd_addr_t_v[5];
void			*r8168_gbd_addr_r_v[5];
void			*r8168_gbd_addr_x_v[5];

unsigned int		r8168_gbd_b_size[5];
unsigned int		r8168_gbd_r_size[5];
unsigned int		r8168_gbd_t_size[5];
unsigned int		r8168_gbd_x_size[5];

struct uio_job {
	uint32_t fec_id;
	int uio_fd;
	void *bd_start_addr;
	void *register_base_addr;
	int map_size;
	uint64_t map_addr;
	int uio_minor_number;
};
static struct uio_job guio_job;

/*
 * @brief Reads first line from a file.
 * Composes file name as: root/subdir/filename
 *
 * @param [in]  root     Root path
 * @param [in]  subdir   Subdirectory name
 * @param [in]  filename File name
 * @param [out] line     The first line read from file.
 *
 * @retval 0 for success
 * @retval other value for error
 */
static int
file_read_first_line(const char root[], const char subdir[],
			const char filename[], char *line)
{
	char absolute_file_name[STMMAC_UIO_MAX_ATTR_FILE_NAME];
	int fd = 0, ret = 0;

	/*compose the file name: root/subdir/filename */
	memset(absolute_file_name, 0, sizeof(absolute_file_name));
	snprintf(absolute_file_name, STMMAC_UIO_MAX_ATTR_FILE_NAME,
		"%s/%s/%s", root, subdir, filename);

	fd = open(absolute_file_name, O_RDONLY);
	if (fd <= 0)
		printf("Error opening file %s\n", absolute_file_name);

	/* read UIO device name from first line in file */
	ret = read(fd, line, STMMAC_UIO_MAX_DEVICE_FILE_NAME_LENGTH);
	if (ret <= 0) {
		printf("Error reading file %s\n", absolute_file_name);
		return ret;
	}
	close(fd);

	/* NULL-ify string */
	line[ret] = '\0';

	return 0;
}

/*
 * @brief Maps rx-tx bd range assigned for a bd ring.
 *
 * @param [in] uio_device_fd    UIO device file descriptor
 * @param [in] uio_device_id    UIO device id
 * @param [in] uio_map_id       UIO allows maximum 5 different mapping for
				each device. Maps start with id 0.
 * @param [out] map_size        Map size.
 * @param [out] map_addr	Map physical address
 *
 * @retval  NULL if failed to map registers
 * @retval  Virtual address for mapped register address range
 */
static void *
guio_map_mem(int uio_device_fd, int uio_device_id,
		int uio_map_id, int *map_size, uint64_t *map_addr)
{
	void *mapped_address = NULL;
	unsigned int uio_map_size = 0;
	unsigned int uio_map_p_addr = 0;
	char uio_sys_root[100];
	char uio_sys_map_subdir[100];
	char uio_map_size_str[30 + 1];
	char uio_map_p_addr_str[32];
	int ret = 0;

	/* compose the file name: root/subdir/filename */
	memset(uio_sys_root, 0, sizeof(uio_sys_root));
	memset(uio_sys_map_subdir, 0, sizeof(uio_sys_map_subdir));
	memset(uio_map_size_str, 0, sizeof(uio_map_size_str));
	memset(uio_map_p_addr_str, 0, sizeof(uio_map_p_addr_str));

	/* Compose string: /sys/class/uio/uioX */
	snprintf(uio_sys_root, sizeof(uio_sys_root), "%s/%s%d",
			"/sys/class/uio", "uio", uio_device_id);
	/* Compose string: maps/mapY */
	snprintf(uio_sys_map_subdir, sizeof(uio_sys_map_subdir), "%s%d",
			"maps/map", uio_map_id);

	printf("US_UIO: uio_map_mem uio_sys_root: %s, uio_sys_map_subdir: %s, uio_map_size_str: %s\n",
			uio_sys_root, uio_sys_map_subdir, uio_map_size_str);

	/* Read first (and only) line from file
	 * /sys/class/uio/uioX/maps/mapY/size
	 */
	ret = file_read_first_line(uio_sys_root, uio_sys_map_subdir,
				"size", uio_map_size_str);
	if (ret < 0) {
		printf("file_read_first_line() failed\n");
		return NULL;
	}
	ret = file_read_first_line(uio_sys_root, uio_sys_map_subdir,
				"addr", uio_map_p_addr_str);
	if (ret < 0) {
		printf("file_read_first_line() failed\n");
		return NULL;
	}

	/* Read mapping size and physical address expressed in hexa(base 16) */
	uio_map_size = strtol(uio_map_size_str, NULL, 16);
	uio_map_p_addr = strtol(uio_map_p_addr_str, NULL, 16);
	printf("kernel size: 0x%x, addr: 0x%x\n", uio_map_size, uio_map_p_addr);

	/* Map the BD memory in user space */
	mapped_address = mmap(NULL, uio_map_size,
			PROT_READ | PROT_WRITE,
			MAP_SHARED, uio_device_fd, (uio_map_id * 4096));

	if (mapped_address == MAP_FAILED) {
		printf("Failed to map! errno = %d uio job fd = %d,"
			"uio device id = %d, uio map id = %d\n", errno,
			uio_device_fd, uio_device_id, uio_map_id);
		return NULL;
	}

	/* Save the map size to use it later on for munmap-ing */
	*map_size = uio_map_size;
	*map_addr = uio_map_p_addr;

	printf("UIO dev[%d] mapped region [id =%d] size 0x%x map_addr_p: 0x%lx, at %p\n",
		uio_device_id, uio_map_id, uio_map_size, *map_addr, mapped_address);

	printf("UIO dev[%d] mapped region [id =%d] size 0x%x at phy 0x%lx\n",
		uio_device_id, uio_map_id, uio_map_size, rte_mem_virt2phy(mapped_address));

	return mapped_address;
}

static int
rconfig_pcie_uio(uint64_t hw_addr)
{
	char uio_device_file_name[32];
	uint64_t addr;
	int index;

	printf("rconfig_pcie_uio\n");

	if (r8168_base_hw_addr == 0) {
		r8168_base_hw_addr = hw_addr;
		addr = hw_addr;
	} else {
		addr = hw_addr;
	}

	/*
	 * BAR2, addr: f0204000
	 * BAR2, addr: f2204000
	 * BAR2, addr: f4204000
	 */
	index = abs(addr - r8168_base_hw_addr) / 0x5000;
	printf("index: %d, hw_addr: 0x%lx, r8168_base_hw_addr: 0x%lx\n", index, addr, r8168_base_hw_addr);
	if ((index < 0) && (index > 3))
		return -1;

	snprintf(uio_device_file_name, sizeof(uio_device_file_name), "/dev/uio%d",
			r8168_uio_cnt);

	/* Open device file */
	guio_job.uio_fd = open(uio_device_file_name, O_RDWR);
	if (guio_job.uio_fd < 0) {
		printf("Unable to open STMMAC_UIO file\n");
		return -1;
	}

	r8168_gbd_addr_b_v[index] = guio_map_mem(guio_job.uio_fd,
		r8168_uio_cnt, 0,
		&guio_job.map_size, &guio_job.map_addr);
	if (r8168_gbd_addr_b_v[index] == NULL)
		return -ENOMEM;
	r8168_gbd_addr_b_p[index] = (uint32_t)guio_job.map_addr;
	r8168_gbd_b_size[index] = guio_job.map_size;

	r8168_gbd_addr_r_v[index] = guio_map_mem(guio_job.uio_fd,
		r8168_uio_cnt, 2,
		&guio_job.map_size, &guio_job.map_addr);
	if (r8168_gbd_addr_r_v[index] == NULL)
		return -ENOMEM;
	r8168_gbd_addr_r_p[index] = (uint32_t)guio_job.map_addr;
	r8168_gbd_r_size[index] = guio_job.map_size;

	r8168_gbd_addr_t_v[index] = guio_map_mem(guio_job.uio_fd,
		r8168_uio_cnt, 3,
		&guio_job.map_size, &guio_job.map_addr);
	if (r8168_gbd_addr_t_v[index] == NULL)
		return -ENOMEM;
	r8168_gbd_addr_t_p[index] = (uint32_t)guio_job.map_addr;
	r8168_gbd_t_size[index] = guio_job.map_size;

	r8168_gbd_addr_x_v[index] = guio_map_mem(guio_job.uio_fd,
		r8168_uio_cnt, 4,
		&guio_job.map_size, &guio_job.map_addr);
	if (r8168_gbd_addr_x_v[index] == NULL)
		return -ENOMEM;
	r8168_gbd_addr_x_p[index] = (uint32_t)guio_job.map_addr;
	r8168_gbd_x_size[index] = guio_job.map_size;

	r8168_uio_cnt++;

	return 0;
}

static int
rtl_dev_init(struct rte_eth_dev *dev)
{

        struct rte_pci_device *pci_dev = RTE_ETH_DEV_TO_PCI(dev);
        struct rte_intr_handle *intr_handle = pci_dev->intr_handle;
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        struct rte_ether_addr *perm_addr =
                (struct rte_ether_addr *)hw->mac_addr;

        printf("r8168: driver version 1.001 %s %s init\n", __DATE__, __TIME__);

        dev->dev_ops = &rtl_eth_dev_ops;
        dev->tx_pkt_burst = &rtl_xmit_pkts;
        dev->rx_pkt_burst = &rtl_recv_pkts;

        /* for secondary processes, we don't initialize any further as primary
         * has already done this work. Only check we don't need a different
         * RX function
         */
        if (rte_eal_process_type() != RTE_PROC_PRIMARY) {
                printf("r8168:No TX queues configured yet. Using default TX function.");

                return 0;
        }

        rte_eth_copy_pci_info(dev, pci_dev);

        hw->mmio_addr= (u8 *)pci_dev->mem_resource[2].addr; //rtl8168 uses BAR2

        rconfig_pcie_uio(hw->mmio_addr);

        int index;
        index = (uint64_t)abs(hw->mmio_addr - r8168_base_hw_addr) / 0x5000;
        //hw->mmio_addr= r8168_gbd_addr_b_v[index]; //rtl8168 uses BAR2

        printf("virt_addr %p:%p\n", pci_dev->mem_resource[2].addr, r8168_gbd_addr_b_v[index]);
        printf("phys_addr %p:%p\n", pci_dev->mem_resource[2].phys_addr, r8168_gbd_addr_b_p[index]);

        rtl8168_get_mac_version(hw);

        rtl8168_set_hw_ops(hw);

        //adapter->hw_cfg...

        //dont know why r8169 driver sets RxConfig at this moment
        //hw->hw_ops.hw_init_rxcfg(hw);

        rtl8168_disable_intr(hw);

        rtl_hw_initialize(hw);

        /* Read the permanent MAC address out of ROM*/
        rtl8168_get_mac_address(hw, perm_addr);

        if (!rte_is_valid_assigned_ether_addr(perm_addr)) {
                rte_eth_random_addr(&perm_addr->addr_bytes[0]);

                printf("r8168:Assign randomly generated MAC address "
                       "%02x:%02x:%02x:%02x:%02x:%02x",
                       perm_addr->addr_bytes[0],
                       perm_addr->addr_bytes[1],
                       perm_addr->addr_bytes[2],
                       perm_addr->addr_bytes[3],
                       perm_addr->addr_bytes[4],
                       perm_addr->addr_bytes[5]);
        }

        /* Allocate memory for storing MAC addresses */
        dev->data->mac_addrs = rte_zmalloc("r8168", RTE_ETHER_ADDR_LEN, 0);

        if (dev->data->mac_addrs == NULL) {
                //PMD_INIT_LOG(ERR, "MAC Malloc failed");
                return -ENOMEM;
        }
        /* Copy the permanent MAC address */
        rte_ether_addr_copy(perm_addr, &dev->data->mac_addrs[0]);

        rtl8168_rar_set(hw, &perm_addr->addr_bytes[0]);

        //TODO: intr


        rte_intr_callback_register(intr_handle,
                                   rtl_dev_interrupt_handler, dev);

        /* enable uio/vfio intr/eventfd mapping */
        rte_intr_enable(intr_handle);

        return 0;

}


static void
rtl_dev_close(struct rte_eth_dev *dev)
{
        struct rte_pci_device *pci_dev = RTE_ETH_DEV_TO_PCI(dev);
        struct rte_intr_handle *intr_handle = pci_dev->intr_handle;
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        int retries = 0;
        int ret;

        if (HW_DASH_SUPPORT_DASH(hw))
                rtl8168_driver_stop(hw);

        rtl_dev_stop(dev);

        rtl_free_queues(dev);

        /* reprogram the RAR[0] in case user changed it. */
        rtl8168_rar_set(hw, hw->mac_addr);

        dev->dev_ops = NULL;
        dev->rx_pkt_burst = NULL;
        dev->tx_pkt_burst = NULL;

        /* disable uio intr before callback unregister */
        rte_intr_disable(intr_handle);

        do {
                ret = rte_intr_callback_unregister(intr_handle,
                                                   rtl_dev_interrupt_handler, dev);
                if (ret >= 0 || ret == -ENOENT) {
                        break;
                } else if (ret != -EAGAIN) {
                        printf("r8168:intr callback unregister failed: %d",
                               ret);
                }
                rte_delay_ms(100);
        } while (retries++ < (10 + 90));
}

static int rtl_dev_uninit(struct rte_eth_dev *dev)
{

        if (rte_eal_process_type() != RTE_PROC_PRIMARY)
                return -EPERM;

        rtl_dev_close(dev);

        return 0;
}


static int rtl8168_tally_init(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        const struct rte_memzone *mz;

        mz = rte_eth_dma_zone_reserve(dev, "tally_counters", 0, sizeof(struct rtl8168_counters),
                                      64, rte_socket_id());
        if (mz == NULL)
                return -ENOMEM;

        hw->tally_vaddr = mz->addr;
        hw->tally_paddr = mz->iova;
        printf("tally %p:0x%lx\n", hw->tally_vaddr, hw->tally_paddr);

        int index;
        index = (uint64_t)abs(hw->mmio_addr - r8168_base_hw_addr) / 0x5000;
        hw->tally_vaddr = r8168_gbd_addr_x_v[index]; //gbd_addr_x_v;
        hw->tally_paddr = r8168_gbd_addr_x_p[index]; //gbd_addr_x_p;
        printf("tally vp: %p:0x%lx\n", hw->tally_vaddr, hw->tally_paddr);

        //fill tally addrs
        RTL_W32(hw, CounterAddrHigh, (u64)hw->tally_paddr >> 32);
        RTL_W32(hw, CounterAddrLow, (u64)hw->tally_paddr & (DMA_BIT_MASK(32)));

        /* Reset the hw statistics */
        rtl8168_clear_tally_stats(hw);

        return 0;
}

#if RTE_VERSION >= RTE_VERSION_NUM(20, 8, 0, 0)
static void rtl8168_tally_free(struct rte_eth_dev *dev)
#else
static void rtl8168_tally_free(struct rte_eth_dev *dev __rte_unused)
#endif
{
        rtl8168_eth_dma_zone_free(dev, "tally_counters", 0);
}

static int
_rtl_setup_link(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;

        rtl8168_set_speed(hw);
        //msleep(R8168_LINK_CHECK_WAIT);
        return 0;

}


static int
rtl_setup_link(struct rte_eth_dev *dev)
{
#ifdef RTE_EXEC_ENV_FREEBSD
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        struct rte_eth_link link;
        //int linkok = 0;
        int count;
#endif

        _rtl_setup_link(dev);

#ifdef RTE_EXEC_ENV_FREEBSD
        for (count = 0; count < R8168_LINK_CHECK_TIMEOUT; count ++) {

                if (!(RTL_R8(hw, PHYstatus) & LinkStatus)) {
                        msleep(R8168_LINK_CHECK_INTERVAL);
                        continue;
                }

                rtl_dev_link_update(dev, 0);

                rte_eth_linkstatus_get(dev, &link);
                printf("xing get link: linkup %x, speed %x, duplex %x, autoneg %x\n",
                       link.link_status, link.link_speed, link.link_duplex, link.link_autoneg);

                return 0;
        }
#endif

        return 0;
}

static void
set_offset79(struct rte_pci_device *pdev, u8 setting)
{
        //Set PCI configuration space offset 0x79 to setting

        u8 device_control;

        //if (hwoptimize & HW_PATCH_SOC_LAN)
        //        return;

        PCI_READ_CONFIG_BYTE(pdev, &device_control, 0x79);
        device_control &= ~0x70;
        device_control |= setting;
        PCI_WRITE_CONFIG_BYTE(pdev, &device_control, 0x79);
}

/*
 * Configure device link speed and setup link.
 * It returns 0 on success.
 */
static int
rtl_dev_start(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        struct rte_pci_device *pci_dev = RTE_ETH_DEV_TO_PCI(dev);
        struct rte_intr_handle *intr_handle = pci_dev->intr_handle;
        int err;

        printf("r8168:start dev!\n");

        /* disable uio/vfio intr/eventfd mapping */
        rte_intr_disable(intr_handle);

        rtl8168_powerup_pll(hw);

        rtl8168_hw_ephy_config(hw);

        rtl8168_hw_phy_config(hw);

        rtl8168_hw_config(hw);

        switch (hw->mcfg) {
        case CFG_METHOD_21 ... CFG_METHOD_35:
                set_offset79(pci_dev, 0x50);
        }

        rtl_tx_init(dev);

        /* This can fail when allocating mbufs for descriptor rings */
        err = rtl_rx_init(dev);
        if (err) {
                //PMD_INIT_LOG(ERR, "Unable to initialize RX hardware");
                printf("xing fail to init rx!\n");
                goto error;
        }

        /* This can fail when allocating mem for tally counters */
        err = rtl8168_tally_init(dev);
        if (err) {
                goto error;
        }

        ///* enable uio/vfio intr/eventfd mapping */
        rte_intr_enable(intr_handle);

        ///* resume enabled intr since hw reset */
        rtl8168_enable_intr(hw);

        rtl_setup_link(dev);

        //RTL_W8(hw, ChipCmd, CmdTxEnb | CmdRxEnb);
        rtl8168_mdio_write(hw, 0x1F, 0x0000);

        //printf("xing dump regs after nway:\n");
        //rtl_dump_mac_reg(hw);

        hw->adapter_stopped = 0;

        return 0;

error:
        rtl_stop_queues(dev);
        return -EIO;
}

/*
 * Stop device: disable rx and tx functions to allow for reconfiguring.
 */
static void
rtl_dev_stop(struct rte_eth_dev *dev)
{
        struct rtl_adapter *adapter = RTL_DEV_PRIVATE(dev);
        struct rtl_hw *hw = &adapter->hw;
        struct rte_eth_link link;

        if (hw->adapter_stopped)
                return;

        printf("r8168:stop dev!\n");

        hw->adapter_stopped = 1;

        rtl8168_disable_intr(hw);

        rtl8168_nic_reset(hw);

        rtl8168_powerdown_pll(hw);

        rtl_stop_queues(dev);

        rtl8168_tally_free(dev);

        /* clear the recorded link status */
        memset(&link, 0, sizeof(link));
        rte_eth_linkstatus_set(dev, &link);

        ///* Clean datapath event and queue/vec mapping */
        //rte_intr_efd_disable(intr_handle);
        //if (intr_handle->intr_vec != NULL) {
        //	rte_free(intr_handle->intr_vec);
        //	intr_handle->intr_vec = NULL;
        //}
}

static int
rtl_dev_reset(struct rte_eth_dev *dev)
{
        int ret;

        ret = rtl_dev_uninit(dev);
        if (ret)
                return ret;

        ret = rtl_dev_init(dev);

        return ret;
}

static int rtl_pci_probe(struct rte_pci_driver *pci_drv __rte_unused,
                         struct rte_pci_device *pci_dev)
{
        return rte_eth_dev_pci_generic_probe(pci_dev,
                                             sizeof(struct rtl_adapter), rtl_dev_init);

}


static int rtl_pci_remove(struct rte_pci_device *pci_dev)
{
        return rte_eth_dev_pci_generic_remove(pci_dev, rtl_dev_uninit);
}

static struct rte_pci_driver rte_r8168_pmd = {
        .id_table = pci_id_r8168_map,
        .drv_flags = RTE_PCI_DRV_NEED_MAPPING | RTE_PCI_DRV_INTR_LSC,
        .probe = rtl_pci_probe,
        .remove = rtl_pci_remove,
};

RTE_PMD_REGISTER_PCI(net_r8168, rte_r8168_pmd);
RTE_PMD_REGISTER_PCI_TABLE(net_r8168, pci_id_r8168_map);
RTE_PMD_REGISTER_KMOD_DEP(net_r8168, "* igb_uio | uio_pci_generic");

#if RTE_VERSION >= RTE_VERSION_NUM(20, 8, 0, 0)
RTE_LOG_REGISTER(r8168_logtype_init, pmd.net.r8168.init, NOTICE);
RTE_LOG_REGISTER(r8168_logtype_driver, pmd.net.r8168.driver, NOTICE);

#ifdef RTE_LIBRTE_R8168_DEBUG_RX
RTE_LOG_REGISTER(r8168_logtype_rx, pmd.net.r8168.rx, DEBUG);
#endif
#ifdef RTE_LIBRTE_R8168_DEBUG_TX
RTE_LOG_REGISTER(r8168_logtype_tx, pmd.net.r8168.tx, DEBUG);
#endif
#ifdef RTE_LIBRTE_R8168_DEBUG_TX_FREE
RTE_LOG_REGISTER(r8168_logtype_tx_free, pmd.net.r8168.tx_free, DEBUG);
#endif

#else //RTE_VERSION >= RTE_VERSION_NUM(20, 8, 0, 0)

int r8168_logtype_init;
int r8168_logtype_driver;

#ifdef RTE_LIBRTE_R8168_DEBUG_RX
int r8168_logtype_rx;
#endif
#ifdef RTE_LIBRTE_R8168_DEBUG_TX
int r8168_logtype_tx;
#endif
#ifdef RTE_LIBRTE_R8168_DEBUG_TX_FREE
int r8168_logtype_tx_free;
#endif

RTE_INIT(r8168_init_log)
{
        r8168_logtype_init = rte_log_register("pmd.net.r8168.init");
        if (r8168_logtype_init >= 0)
                rte_log_set_level(r8168_logtype_init, RTE_LOG_NOTICE);
        r8168_logtype_driver = rte_log_register("pmd.net.r8168.driver");
        if (r8168_logtype_driver >= 0)
                rte_log_set_level(r8168_logtype_driver, RTE_LOG_NOTICE);
#ifdef RTE_LIBRTE_R8168_DEBUG_RX
        r8168_logtype_rx = rte_log_register("pmd.net.r8168.rx");
        if (r8168_logtype_rx >= 0)
                rte_log_set_level(r8168_logtype_rx, RTE_LOG_DEBUG);
#endif

#ifdef RTE_LIBRTE_R8168_DEBUG_TX
        r8168_logtype_tx = rte_log_register("pmd.net.r8168.tx");
        if (r8168_logtype_tx >= 0)
                rte_log_set_level(r8168_logtype_tx, RTE_LOG_DEBUG);
#endif

#ifdef RTE_LIBRTE_R8168_DEBUG_TX_FREE
        r8168_logtype_tx_free = rte_log_register("pmd.net.r8168.tx_free");
        if (r8168_logtype_tx_free >= 0)
                rte_log_set_level(r8168_logtype_tx_free, RTE_LOG_DEBUG);
#endif
}

#endif //RTE_VERSION >= RTE_VERSION_NUM(20, 8, 0, 0)
