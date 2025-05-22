/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#ifndef _R8168_BASE_H_
#define _R8168_BASE_H_

#include <stdint.h>
#include <stddef.h>
#include <inttypes.h>
#include <string.h>
#include <rte_common.h>
#include <rte_cycles.h>
#include <rte_log.h>
#include <rte_debug.h>
#include <rte_byteorder.h>
#include <rte_io.h>
#include <rte_ether.h>
#include <rte_version.h>

typedef uint8_t         u8;
typedef int8_t          s8;
typedef uint16_t        u16;
typedef int16_t         s16;
typedef uint32_t        u32;
typedef int32_t         s32;
typedef uint64_t        u64;

#define TRUE 1
#define FALSE 0

enum mcfg {
        CFG_METHOD_1=0,
        CFG_METHOD_2,
        CFG_METHOD_3,
        CFG_METHOD_4,
        CFG_METHOD_5,
        CFG_METHOD_6,
        CFG_METHOD_7,
        CFG_METHOD_8,
        CFG_METHOD_9,
        CFG_METHOD_10,
        CFG_METHOD_11,
        CFG_METHOD_12,
        CFG_METHOD_13,
        CFG_METHOD_14,
        CFG_METHOD_15,
        CFG_METHOD_16,
        CFG_METHOD_17,
        CFG_METHOD_18,
        CFG_METHOD_19,
        CFG_METHOD_20,
        CFG_METHOD_21,
        CFG_METHOD_22,
        CFG_METHOD_23,
        CFG_METHOD_24,
        CFG_METHOD_25,
        CFG_METHOD_26,
        CFG_METHOD_27,
        CFG_METHOD_28,
        CFG_METHOD_29,
        CFG_METHOD_30,
        CFG_METHOD_31,
        CFG_METHOD_32,
        CFG_METHOD_33,
        CFG_METHOD_34,
        CFG_METHOD_35,
        CFG_METHOD_MAX,
        CFG_METHOD_DEFAULT = 0xFF
};

enum bits {
        BIT_0 = (1UL << 0),
        BIT_1 = (1UL << 1),
        BIT_2 = (1UL << 2),
        BIT_3 = (1UL << 3),
        BIT_4 = (1UL << 4),
        BIT_5 = (1UL << 5),
        BIT_6 = (1UL << 6),
        BIT_7 = (1UL << 7),
        BIT_8 = (1UL << 8),
        BIT_9 = (1UL << 9),
        BIT_10 = (1UL << 10),
        BIT_11 = (1UL << 11),
        BIT_12 = (1UL << 12),
        BIT_13 = (1UL << 13),
        BIT_14 = (1UL << 14),
        BIT_15 = (1UL << 15),
        BIT_16 = (1UL << 16),
        BIT_17 = (1UL << 17),
        BIT_18 = (1UL << 18),
        BIT_19 = (1UL << 19),
        BIT_20 = (1UL << 20),
        BIT_21 = (1UL << 21),
        BIT_22 = (1UL << 22),
        BIT_23 = (1UL << 23),
        BIT_24 = (1UL << 24),
        BIT_25 = (1UL << 25),
        BIT_26 = (1UL << 26),
        BIT_27 = (1UL << 27),
        BIT_28 = (1UL << 28),
        BIT_29 = (1UL << 29),
        BIT_30 = (1UL << 30),
        BIT_31 = (1UL << 31)
};

enum effuse {
        EFUSE_NOT_SUPPORT = 0,
        EFUSE_SUPPORT_V1,
        EFUSE_SUPPORT_V2,
        EFUSE_SUPPORT_V3,
};



enum rtl8168_registers {
        MAC0            = 0x00,     /* Ethernet hardware address. */
        MAC4            = 0x04,
        MAR0            = 0x08,     /* Multicast filter. */
        CounterAddrLow      = 0x10,
        CounterAddrHigh     = 0x14,
        CustomLED       = 0x18,
        TxDescStartAddrLow  = 0x20,
        TxDescStartAddrHigh = 0x24,
        TxHDescStartAddrLow = 0x28,
        TxHDescStartAddrHigh    = 0x2c,
        FLASH           = 0x30,
        ERSR            = 0x36,
        ChipCmd         = 0x37,
        TxPoll          = 0x38,
        IntrMask        = 0x3C,
        IntrStatus      = 0x3E,
        TxConfig        = 0x40,
        RxConfig        = 0x44,
        TCTR            = 0x48,
        Cfg9346         = 0x50,
        Config0         = 0x51,
        Config1         = 0x52,
        Config2         = 0x53,
        Config3         = 0x54,
        Config4         = 0x55,
        Config5         = 0x56,
        TDFNR           = 0x57,
        TimeInt0        = 0x58,
        TimeInt1        = 0x5C,
        PHYAR           = 0x60,
        CSIDR           = 0x64,
        CSIAR           = 0x68,
        PHYstatus       = 0x6C,
        MACDBG          = 0x6D,
        GPIO            = 0x6E,
        PMCH            = 0x6F,
        ERIDR           = 0x70,
        ERIAR           = 0x74,
        EPHY_RXER_NUM   = 0x7C,
        EPHYAR          = 0x80,
        TimeInt2        = 0x8C,
        OCPDR           = 0xB0,
        MACOCP          = 0xB0,
        OCPAR           = 0xB4,
        SecMAC0         = 0xB4,
        SecMAC4         = 0xB8,
        PHYOCP          = 0xB8,
        DBG_reg         = 0xD1,
        TwiCmdReg       = 0xD2,
        MCUCmd_reg      = 0xD3,
        RxMaxSize       = 0xDA,
        EFUSEAR         = 0xDC,
        CPlusCmd        = 0xE0,
        IntrMitigate    = 0xE2,
        RxDescAddrLow   = 0xE4,
        RxDescAddrHigh  = 0xE8,
        MTPS            = 0xEC,
        FuncEvent       = 0xF0,
        PPSW            = 0xF2,
        FuncEventMask   = 0xF4,
        TimeInt3        = 0xF4,
        FuncPresetState = 0xF8,
        CMAC_IBCR0      = 0xF8,
        CMAC_IBCR2      = 0xF9,
        CMAC_IBIMR0     = 0xFA,
        CMAC_IBISR0     = 0xFB,
        FuncForceEvent  = 0xFC,
};

enum rtl8168_register_content {
        /* InterruptStatusBits */
        SYSErr      = 0x8000,
        PCSTimeout  = 0x4000,
        SWInt       = 0x0100,
        TxDescUnavail   = 0x0080,
        RxFIFOOver  = 0x0040,
        LinkChg     = 0x0020,
        RxDescUnavail   = 0x0010,
        TxErr       = 0x0008,
        TxOK        = 0x0004,
        RxErr       = 0x0002,
        RxOK        = 0x0001,

        /* RxStatusDesc */
        RxRWT = (1UL << 22),
        RxRES = (1UL << 21),
        RxRUNT = (1UL << 20),
        RxCRC = (1UL << 19),

        /* ChipCmdBits */
        StopReq  = 0x80,
        CmdReset = 0x10,
        CmdRxEnb = 0x08,
        CmdTxEnb = 0x04,
        RxBufEmpty = 0x01,

        /* Cfg9346Bits */
        Cfg9346_Lock = 0x00,
        Cfg9346_Unlock = 0xC0,
        Cfg9346_EEDO = (1UL << 0),
        Cfg9346_EEDI = (1UL << 1),
        Cfg9346_EESK = (1UL << 2),
        Cfg9346_EECS = (1UL << 3),
        Cfg9346_EEM0 = (1UL << 6),
        Cfg9346_EEM1 = (1UL << 7),

        /* rx_mode_bits */
        AcceptErr = 0x20,
        AcceptRunt = 0x10,
        AcceptBroadcast = 0x08,
        AcceptMulticast = 0x04,
        AcceptMyPhys = 0x02,
        AcceptAllPhys = 0x01,

        /* Transmit Priority Polling*/
        HPQ = 0x80,
        NPQ = 0x40,
        FSWInt = 0x01,

        /* RxConfigBits */
        Reserved2_shift = 13,
        RxCfgDMAShift = 8,
        RxCfg_128_int_en = (1UL << 15),
        RxCfg_fet_multi_en = (1UL << 14),
        RxCfg_half_refetch = (1UL << 13),
        RxCfg_9356SEL = (1UL << 6),

        /* TxConfigBits */
        TxInterFrameGapShift = 24,
        TxDMAShift = 8, /* DMA burst value (0-7) is shift this many bits */
        TxMACLoopBack = (1UL << 17),  /* MAC loopback */

        /* Config1 register */
        LEDS1       = (1UL << 7),
        LEDS0       = (1UL << 6),
        Speed_down  = (1UL << 4),
        MEMMAP      = (1UL << 3),
        IOMAP       = (1UL << 2),
        VPD         = (1UL << 1),
        PMEnable    = (1UL << 0), /* Power Management Enable */

        /* Config2 register */
        PMSTS_En    = (1UL << 5),

        /* Config3 register */
        Isolate_en  = (1UL << 12), /* Isolate enable */
        MagicPacket = (1UL << 5), /* Wake up when receives a Magic Packet */
        LinkUp      = (1UL << 4), /* This bit is reserved in RTL8168B.*/
        /* Wake up when the cable connection is re-established */
        ECRCEN      = (1UL << 3), /* This bit is reserved in RTL8168B*/
        Jumbo_En0   = (1UL << 2), /* This bit is reserved in RTL8168B*/
        RDY_TO_L23  = (1UL << 1), /* This bit is reserved in RTL8168B*/
        Beacon_en   = (1UL << 0), /* This bit is reserved in RTL8168B*/

        /* Config4 register */
        Jumbo_En1   = (1UL << 1), /* This bit is reserved in RTL8168B*/

        /* Config5 register */
        BWF     = (1UL << 6), /* Accept Broadcast wakeup frame */
        MWF     = (1UL << 5), /* Accept Multicast wakeup frame */
        UWF     = (1UL << 4), /* Accept Unicast wakeup frame */
        LanWake     = (1UL << 1), /* LanWake enable/disable */
        PMEStatus   = (1UL << 0), /* PME status can be reset by PCI RST# */

        /* CPlusCmd */
        EnableBist  = (1UL << 15),
        Macdbgo_oe  = (1UL << 14),
        Normal_mode = (1UL << 13),
        Force_halfdup   = (1UL << 12),
        Force_rxflow_en = (1UL << 11),
        Force_txflow_en = (1UL << 10),
        Cxpl_dbg_sel    = (1UL << 9),//This bit is reserved in RTL8168B
        ASF     = (1UL << 8),//This bit is reserved in RTL8168C
        PktCntrDisable  = (1UL << 7),
        RxVlan      = (1UL << 6),
        RxChkSum    = (1UL << 5),
        Macdbgo_sel = 0x001C,
        INTT_0      = 0x0000,
        INTT_1      = 0x0001,
        INTT_2      = 0x0002,
        INTT_3      = 0x0003,

        /* rtl8168_PHYstatus */
        PowerSaveStatus = 0x80,
        TxFlowCtrl = 0x40,
        RxFlowCtrl = 0x20,
        _1000bpsF = 0x10,
        _100bps = 0x08,
        _10bps = 0x04,
        LinkStatus = 0x02,
        FullDup = 0x01,

        /* DBG_reg */
        Fix_Nak_1 = (1UL << 4),
        Fix_Nak_2 = (1UL << 3),
        DBGPIN_E2 = (1UL << 0),

        /* ResetCounterCommand */
        CounterReset = 0x1,
        /* DumpCounterCommand */
        CounterDump = 0x8,

        /* PHY access */
        PHYAR_Flag = 0x80000000,
        PHYAR_Write = 0x80000000,
        PHYAR_Read = 0x00000000,
        PHYAR_Reg_Mask = 0x1f,
        PHYAR_Reg_shift = 16,
        PHYAR_Data_Mask = 0xffff,

        /* EPHY access */
        EPHYAR_Flag = 0x80000000,
        EPHYAR_Write = 0x80000000,
        EPHYAR_Read = 0x00000000,
        EPHYAR_Reg_Mask = 0x3f,
        EPHYAR_Reg_shift = 16,
        EPHYAR_Data_Mask = 0xffff,

        /* CSI access */
        CSIAR_Flag = 0x80000000,
        CSIAR_Write = 0x80000000,
        CSIAR_Read = 0x00000000,
        CSIAR_ByteEn = 0x0f,
        CSIAR_ByteEn_shift = 12,
        CSIAR_Addr_Mask = 0x0fff,

        /* ERI access */
        ERIAR_Flag = 0x80000000,
        ERIAR_Write = 0x80000000,
        ERIAR_Read = 0x00000000,
        ERIAR_Addr_Align = 4, /* ERI access register address must be 4 byte alignment */
        ERIAR_ExGMAC = 0,
        ERIAR_MSIX = 1,
        ERIAR_ASF = 2,
        ERIAR_OOB = 2,
        ERIAR_Type_shift = 16,
        ERIAR_ByteEn = 0x0f,
        ERIAR_ByteEn_shift = 12,

        /* OCP GPHY access */
        OCPDR_Write = 0x80000000,
        OCPDR_Read = 0x00000000,
        OCPDR_Reg_Mask = 0xFF,
        OCPDR_Data_Mask = 0xFFFF,
        OCPDR_GPHY_Reg_shift = 16,
        OCPAR_Flag = 0x80000000,
        OCPAR_GPHY_Write = 0x8000F060,
        OCPAR_GPHY_Read = 0x0000F060,
        OCPR_Write = 0x80000000,
        OCPR_Read = 0x00000000,
        OCPR_Addr_Reg_shift = 16,
        OCPR_Flag = 0x80000000,
        OCP_STD_PHY_BASE_PAGE = 0x0A40,

        /* MCU Command */
        Now_is_oob = (1UL << 7),
        Txfifo_empty = (1UL << 5),
        Rxfifo_empty = (1UL << 4),

        /* E-FUSE access */
        EFUSE_WRITE = 0x80000000,
        EFUSE_WRITE_OK  = 0x00000000,
        EFUSE_READ  = 0x00000000,
        EFUSE_READ_OK   = 0x80000000,
        EFUSE_WRITE_V3 = 0x40000000,
        EFUSE_WRITE_OK_V3  = 0x00000000,
        EFUSE_READ_V3  = 0x80000000,
        EFUSE_READ_OK_V3   = 0x00000000,
        EFUSE_Reg_Mask  = 0x03FF,
        EFUSE_Reg_Shift = 8,
        EFUSE_Check_Cnt = 300,
        EFUSE_READ_FAIL = 0xFF,
        EFUSE_Data_Mask = 0x000000FF,

        /* GPIO */
        GPIO_en = (1UL << 0),

};

struct rtl8168_counters {
        u64 tx_packets;
        u64 rx_packets;
        u64 tx_errors;
        u32 rx_errors;
        u16 rx_missed;
        u16 align_errors;
        u32 tx_one_collision;
        u32 tx_multi_collision;
        u64 rx_unicast;
        u64 rx_broadcast;
        u32 rx_multicast;
        u16 tx_aborted;
        u16 tx_underun;
};

#define R8168_REALTEK_VENDOR_ID 0x10EC

#define R8168_DEV_ID 0x8168

#define R8168_MAX_TX_DESC 4096
#define R8168_MAX_RX_DESC 4096
#define R8168_MIN_TX_DESC 64
#define R8168_MIN_RX_DESC 64

#define R8168_RING_ALIGN 256

#define R8168_MAX_TX_SEG 64
#define R8168_DESC_ALIGN 64

#define R8168_RX_FREE_THRESH 64
#define R8168_TX_FREE_THRESH 64

#define VLAN_TAG_SIZE	4
#define MAC_ADDR_LEN	RTE_ETHER_ADDR_LEN

#define RX_BUF_SIZE 0x05F3  /* 0x05F3 = 1522bye + 1 */
#define ETH_HLEN	14
#define ETH_DATA_LEN	1500

/*
 * The overhead from MTU to max frame size.
 * Considering VLAN so a tag needs to be counted.
 */
#define R8168_ETH_OVERHEAD (RTE_ETHER_HDR_LEN + RTE_ETHER_CRC_LEN + \
				VLAN_TAG_SIZE)

#define SPEED_10	10
#define SPEED_100	100
#define SPEED_1000	1000
#define SPEED_2500	2500

#define DUPLEX_HALF	1
#define DUPLEX_FULL	2

#define AUTONEG_ENABLE	1
#define AUTONEG_DISABLE	0

#define ADVERTISE_10_HALF		0x0001
#define ADVERTISE_10_FULL		0x0002
#define ADVERTISE_100_HALF		0x0004
#define ADVERTISE_100_FULL		0x0008
#define ADVERTISE_1000_HALF		0x0010 /* Not used, just FYI */
#define ADVERTISE_1000_FULL		0x0020


#define Reserved2_data  7
#define RX_DMA_BURST    7   /* Maximum PCI burst, '6' is 1024 */
#define TX_DMA_BURST_unlimited  7
#define TX_DMA_BURST_1024   6
#define TX_DMA_BURST_512    5
#define TX_DMA_BURST_256    4
#define TX_DMA_BURST_128    3
#define TX_DMA_BURST_64     2
#define TX_DMA_BURST_32     1
#define TX_DMA_BURST_16     0
#define Reserved1_data  0x3F
#define RxPacketMaxSize 0x3FE8  /* 16K - 1 - ETH_HLEN - VLAN - CRC... */
#define Jumbo_Frame_1k  ETH_DATA_LEN
#define Jumbo_Frame_2k  (2*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_3k  (3*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_4k  (4*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_5k  (5*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_6k  (6*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_7k  (7*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_8k  (8*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define Jumbo_Frame_9k  (9*1024 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
#define InterFrameGap   0x03    /* 3 means InterFrameGap = the shortest one */
#define RxEarly_off_V1 (0x07 << 11)
#define RxEarly_off_V2 (1UL << 11)
#define Rx_Single_fetch_V2 (1UL << 14)

#define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))

//Ram Code Version
#define NIC_RAMCODE_VERSION_CFG_METHOD_14 (0x0057)
#define NIC_RAMCODE_VERSION_CFG_METHOD_16 (0x0055)
#define NIC_RAMCODE_VERSION_CFG_METHOD_18 (0x0052)
#define NIC_RAMCODE_VERSION_CFG_METHOD_20 (0x0044)
#define NIC_RAMCODE_VERSION_CFG_METHOD_21 (0x0042)
#define NIC_RAMCODE_VERSION_CFG_METHOD_24 (0x0001)
#define NIC_RAMCODE_VERSION_CFG_METHOD_23 (0x0015)
#define NIC_RAMCODE_VERSION_CFG_METHOD_26 (0x0012)
#define NIC_RAMCODE_VERSION_CFG_METHOD_28 (0x0019)
#define NIC_RAMCODE_VERSION_CFG_METHOD_29 (0x0055)
#define NIC_RAMCODE_VERSION_CFG_METHOD_31 (0x0003)
#define NIC_RAMCODE_VERSION_CFG_METHOD_35 (0x0015)

#define RTL_PCI_REG_ADDR(hw, reg) \
        ((u8 *)(hw)->mmio_addr + (reg))

#define RTL_R32(hw, reg) \
        rtl_read32(RTL_PCI_REG_ADDR((hw), (reg)))

#define RTL_R16(hw, reg) \
        rtl_read16(RTL_PCI_REG_ADDR((hw), (reg)))

#define RTL_R8(hw, reg) \
        rte_read8(RTL_PCI_REG_ADDR((hw), (reg)))

#define RTL_W32(hw, reg, val) \
        rte_write32((rte_cpu_to_le_32(val)), RTL_PCI_REG_ADDR((hw), (reg)))

#define RTL_W16(hw, reg, val) \
        rte_write16((rte_cpu_to_le_16(val)), RTL_PCI_REG_ADDR((hw), (reg)))

#define RTL_W8(hw, reg, val) \
        rte_write8((val), RTL_PCI_REG_ADDR((hw), (reg)))

static inline u32 rtl_read32(volatile void *addr)
{
        return rte_le_to_cpu_32(rte_read32(addr));
}

static inline u32 rtl_read16(volatile void *addr)
{
        return rte_le_to_cpu_16(rte_read16(addr));
}

/*
static inline int rtl_pci_read(struct rtl_hw *hw, uint8_t size,
                               size_t addr, void *val, uint8_t size)
{
        if (rte_pci_read_config(hw->pci_dev, val, size, addr) <= 0) {
                //PMD_DRV_LOG(ERR, sc, "Can't read from PCI config space");
                return ENXIO;
        }

        return 0;
}

static inline int rtl_pci_write(struct rtl_hw *hw, uint8_t size, size_t addr, const void * val)
{
        if (!size || !val || size > 4)
                return 0;

        if (rte_pci_write_config(hw->pci_dev, val,
                                 size, addr) <= 0) {
                //PMD_DRV_LOG(ERR, sc, "Can't write to PCI config space");
                return ENXIO;
        }

        return 0;
}
*/

#define mdelay rte_delay_ms
#define udelay rte_delay_us
#define msleep rte_delay_ms
#define usleep rte_delay_us

#if RTE_VERSION >= RTE_VERSION_NUM(20, 8, 0, 0)
#define rtl8168_eth_dma_zone_free(eth_dev, name, queue_id) \
    rte_eth_dma_zone_free(eth_dev, name, queue_id)
#else
#define rtl8168_eth_dma_zone_free(eth_dev, name, queue_id)
#endif

struct rtl_hw;

struct rtl_hw_ops {
        //void (*hw_init)(struct rtl_hw *hw);
        void (*hw_config)(struct rtl_hw *hw);
        void (*hw_init_rxcfg)(struct rtl_hw *hw);
        void (*hw_ephy_config)(struct rtl_hw *hw);
        void (*hw_phy_config)(struct rtl_hw *hw);
        void (*hw_mac_mcu_config)(struct rtl_hw *hw);
        void (*hw_phy_mcu_config)(struct rtl_hw *hw);

};

struct rtl_hw {
        u8 *mmio_addr;
        struct rtl_hw_ops hw_ops;
        struct rtl8168_counters *tally_vaddr;
        uint64_t tally_paddr;
        u32 mcfg;
        u32 mtu;
        u32 rx_buf_sz;
        u8 mac_addr[MAC_ADDR_LEN];
        u8 adapter_stopped;
        u16 cur_page;

        u16 sw_ram_code_ver;
        u16 hw_ram_code_ver;

        u16 phy_reg_anlpar;
        u8 efuse_ver;
        u8 HwSuppGigaForceMode;

        u8  autoneg;
        u8  duplex;
        u32 speed;
        u32 advertising;

        u8 HwSuppPhyOcpVer;
        u8 HwIcVerUnknown;
        u8 HwSuppCheckPhyDisableModeVer;
        u8 HwHasWrRamCodeToMicroP;

        int phy_auto_nego_reg;
        int phy_1000_ctrl_reg;

        //Dash?
        u8 HwPkgDet;
        u8 HwSuppSerDesPhyVer;

        //Dash+++++++++++++++++
        u8 HwSuppDashVer;
        u8 DASH;
};

struct rtl_sw_stats {
        u64     tx_packets;
        u64     tx_bytes;
        u64     tx_errors;
        u64     rx_packets;
        u64     rx_bytes;
        u64     rx_errors;
};

struct rtl_adapter {
        struct rtl_hw           hw;
        struct rtl_sw_stats     sw_stats;
};

#define RTL_DEV_PRIVATE(eth_dev) \
        ((struct rtl_adapter *)((eth_dev)->data->dev_private))


#endif
