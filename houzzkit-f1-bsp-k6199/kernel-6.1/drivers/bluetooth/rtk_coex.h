/*
*
*  Realtek Bluetooth USB driver
*
*
*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*
*/
#include <net/bluetooth/hci_core.h>
#include <linux/list.h>

/***********************************
** Realtek - For coexistence **
***********************************/
#define BTRTL_HCIUSB    0
#define BTRTL_HCIUART   1

#define BTRTL_HCI_IF    BTRTL_HCIUSB

#define TRUE                1
#define FALSE               0

#define CONNECT_PORT        30001
#define CONNECT_PORT_WIFI   30000

#define invite_req          "INVITE_REQ"
#define invite_rsp          "INVITE_RSP"
#define attend_req          "ATTEND_REQ"
#define attend_ack          "ATTEND_ACK"
#define wifi_leave          "WIFI_LEAVE"
#define leave_ack           "LEAVE_ACK"
#define bt_leave            "BT_LEAVE"

#define HCI_OP_PERIODIC_INQ								0x0403
#define HCI_EV_LE_META			                        0x3e
#define HCI_EV_LE_CONN_COMPLETE		                    0x01
#define HCI_EV_LE_CONN_UPDATE_COMPLETE	                0x03
#define HCI_EV_LE_ENHANCED_CONN_COMPLETE    0x0a

#define HCI_EV_LE_CIS_EST                 0x19
#define HCI_EV_LE_CREATE_BIG_CPL          0x1b
#define HCI_EV_LE_TERM_BIG_CPL            0x1c
#define HCI_EV_LE_BIG_SYNC_EST            0x1d
#define HCI_EV_LE_BIG_SYNC_LOST           0x1e
#define HCI_EV_LE_REMOVE_ISO_DATA_PATH    0x23

//vendor cmd to fw
#define HCI_VENDOR_ENABLE_PROFILE_REPORT_COMMAND        0xfc18
#define HCI_VENDOR_SET_PROFILE_REPORT_LEGACY_COMMAND    0xfc19
#define HCI_VENDOR_SET_PROFILE_REPORT_COMMAND		0xfc1B
#define HCI_VENDOR_MAILBOX_CMD                          0xfc8f
#define HCI_VENDOR_SET_BITPOOL				0xfc51

//subcmd to fw
#define HCI_VENDOR_SUB_CMD_WIFI_CHANNEL_AND_BANDWIDTH_CMD   0x11
#define HCI_VENDOR_SUB_CMD_WIFI_FORCE_TX_POWER_CMD          0x17
#define HCI_VENDOR_SUB_CMD_BT_ENABLE_IGNORE_WLAN_ACT_CMD    0x1B
#define HCI_VENDOR_SUB_CMD_BT_REPORT_CONN_SCO_INQ_INFO      0x23
#define HCI_VENDOR_SUB_CMD_BT_AUTO_REPORT_STATUS_INFO       0x27
#define HCI_VENDOR_SUB_CMD_BT_AUTO_REPORT_ENABLE            0x28
#define HCI_VENDOR_SUB_CMD_BT_SET_TXRETRY_REPORT_PARAM      0x29
#define HCI_VENDOR_SUB_CMD_BT_SET_PTATABLE                  0x2A
#define HCI_VENDOR_SUB_CMD_SET_BT_PSD_MODE                  0x31
#define HCI_VENDOR_SUB_CMD_SET_BT_LNA_CONSTRAINT            0x32
#define HCI_VENDOR_SUB_CMD_GET_AFH_MAP_L                    0x40
#define HCI_VENDOR_SUB_CMD_GET_AFH_MAP_M                    0x41
#define HCI_VENDOR_SUB_CMD_GET_AFH_MAP_H                    0x42
#define HCI_VENDOR_SUB_CMD_RD_REG_REQ                       0x43
#define HCI_VENDOR_SUB_CMD_WR_REG_REQ                       0x44

#define HCI_EV_VENDOR_SPECIFIC      0xff

//sub event from fw start
#define HCI_VENDOR_PTA_REPORT_EVENT         0x24
#define HCI_VENDOR_PTA_AUTO_REPORT_EVENT    0x25

//vendor cmd to wifi driver
#define HCI_GRP_VENDOR_SPECIFIC             (0x3f << 10)
#define HCI_OP_HCI_EXTENSION_VERSION_NOTIFY (0x0100 | HCI_GRP_VENDOR_SPECIFIC)
#define HCI_OP_BT_OPERATION_NOTIFY          (0x0102 | HCI_GRP_VENDOR_SPECIFIC)
#define HCI_OP_HCI_BT_INFO_NOTIFY           (0x0106 | HCI_GRP_VENDOR_SPECIFIC)
#define HCI_OP_HCI_BT_COEX_NOTIFY           (0x0107 | HCI_GRP_VENDOR_SPECIFIC)
#define HCI_OP_HCI_BT_PATCH_VER_NOTIFY      (0x0108 | HCI_GRP_VENDOR_SPECIFIC)
#define HCI_OP_HCI_BT_AFH_MAP_NOTIFY        (0x0109 | HCI_GRP_VENDOR_SPECIFIC)
#define HCI_OP_HCI_BT_REGISTER_VALUE_NOTIFY (0x010a | HCI_GRP_VENDOR_SPECIFIC)

//bt info reason to wifi
#define HOST_RESPONSE                   0	//Host response when receive the BT Info Control Event
#define POLLING_RESPONSE                1	//The BT Info response for polling by BT firmware.
#define AUTO_REPORT                     2	//BT auto report by BT firmware.
#define STACK_REPORT_WHILE_DEVICE_D2    3	//Stack report when BT firmware is under power save state(ex:D2)

// vendor event from wifi
#define RTK_HS_EXTENSION_EVENT_WIFI_SCAN            0x01
#define RTK_HS_EXTENSION_EVENT_RADIO_STATUS_NOTIFY  0x02
#define RTK_HS_EXTENSION_EVENT_HCI_BT_INFO_CONTROL  0x03
#define RTK_HS_EXTENSION_EVENT_HCI_BT_COEX_CONTROL  0x04

//op code from wifi
#define BT_PATCH_VERSION_QUERY      0x00
#define IGNORE_WLAN_ACTIVE_CONTROL  0x01
#define LNA_CONSTRAIN_CONTROL       0x02
#define BT_POWER_DECREASE_CONTROL   0x03
#define BT_PSD_MODE_CONTROL         0x04
#define WIFI_BW_CHNL_NOTIFY         0x05
#define QUERY_BT_AFH_MAP            0x06
#define BT_REGISTER_ACCESS          0x07

//bt operation to notify
#define BT_OPCODE_NONE                  0
#define BT_OPCODE_INQUIRY_START         1
#define BT_OPCODE_INQUIRY_END           2
#define BT_OPCODE_PAGE_START            3
#define BT_OPCODE_PAGE_SUCCESS_END      4
#define BT_OPCODE_PAGE_UNSUCCESS_END    5
#define BT_OPCODE_PAIR_START            6
#define BT_OPCODE_PAIR_END              7
#define BT_OPCODE_ENABLE_BT             8
#define BT_OPCODE_DISABLE_BT            9

#define HCI_EXTENSION_VERSION           0x0004
#define HCI_CMD_PREAMBLE_SIZE           3
#define PAN_PACKET_COUNT                5

#define STREAM_TO_UINT16(u16, p) {u16 = ((uint16_t)(*(p)) + (((uint16_t)(*((p) + 1))) << 8)); (p) += 2;}
#define UINT16_TO_STREAM(p, u16) {*(p)++ = (uint8_t)(u16); *(p)++ = (uint8_t)((u16) >> 8);}

#define PSM_SDP     0x0001
#define PSM_RFCOMM  0x0003
#define PSM_PAN     0x000F
#define PSM_HID     0x0011
#define PSM_HID_INT 0x0013
#define PSM_AVCTP   0x0017
#define PSM_AVDTP   0x0019
#define PSM_FTP     0x1001
#define PSM_BIP     0x1003
#define PSM_OPP     0x1005
//--add more if needed--//

enum {
	profile_sco = 0,
	profile_hid = 1,
	profile_a2dp = 2,
	profile_pan = 3,
	profile_hid_interval = 4,
	profile_hogp = 5,
	profile_voice = 6,
	profile_sink = 7,
	profile_lea_src = 8,
	profile_opprx = 9,
	profile_lea_snk = 10,
	profile_a2dpsink = 11,
	profile_max = 12
};

#define A2DP_SIGNAL	0x01
#define A2DP_MEDIA	0x02
//profile info data
typedef struct {
	struct list_head list;
	uint16_t handle;
	uint16_t psm;
	uint16_t dcid;
	uint16_t scid;
	uint8_t profile_index;
	uint8_t flags;
} rtk_prof_info, *prtk_prof_info;

//profile info for each connection
typedef struct rtl_hci_conn {
	struct list_head list;
	u16 big_handle;
	u16 handle;
	u8 direction;
	u8 remove_path;
	struct delayed_work a2dp_count_work;
	struct delayed_work pan_count_work;
	struct delayed_work hogp_count_work;
	uint32_t a2dp_packet_count;
	uint32_t pan_packet_count;
	uint32_t hogp_packet_count;
	uint32_t voice_packet_count;
	uint8_t type;		// 0:l2cap, 1:sco/esco, 2:le
	uint16_t profile_bitmap;
	uint16_t profile_status;
	int8_t profile_refcount[profile_max];
} rtk_conn_prof, *prtk_conn_prof;

#ifdef RTB_SOFTWARE_MAILBOX

struct rtl_btinfo {
	u8 cmd;
	u8 len;
	u8 data[6];
};
#define RTL_BTINFO_LEN	(sizeof(struct rtl_btinfo))
/* typedef struct {
 * 	uint8_t cmd_index;
 * 	uint8_t cmd_length;
 * 	uint8_t link_status;
 * 	uint8_t retry_cnt;
 * 	uint8_t rssi;
 * 	uint8_t mailbox_info;
 * 	uint16_t acl_throughput;
 * } hci_linkstatus_report; */

typedef struct {
	uint8_t type;
	uint32_t offset;
	uint32_t value;
} hci_mailbox_register;

struct rtl_btinfo_ctl {
	uint8_t polling_enable;
	uint8_t polling_time;
	uint8_t autoreport_enable;
};
#endif /* RTB_SOFTWARE_MAILBOX */

#define HCI_PT_CMD		0x01
#define HCI_PT_EVT		0x02
#define HCI_PT_L2SIG_RX		0x03
#define HCI_PT_L2SIG_TX		0x04
#define HCI_PT_L2DATA_RX	0x05
#define HCI_PT_L2DATA_TX	0x06

struct rtl_hci_hdr {
	struct list_head list;
	u8  type;
	u16 len;
};

#define MAX_LEN_OF_HCI_EV	32
#define NUM_RTL_HCI_EV		32
struct rtl_hci_ev {
	struct list_head list;
	u8 type;
	u16 len;

	/* private */
	__u8 data[MAX_LEN_OF_HCI_EV];
};

#define L2_MAX_SUBSEC_LEN	128
#define L2_MAX_PKTS	16
struct rtl_l2_buff {
	struct list_head list;
	u8 type;
	u16 len;

	/* private */
	__u8 data[L2_MAX_SUBSEC_LEN];
	__u16 out;
};

struct rtl_coex_struct {
	struct list_head conn_hash;	//hash for connections
	struct list_head profile_list;	//hash for profile info
	struct hci_dev *hdev;
#ifdef RTB_SOFTWARE_MAILBOX
	struct socket *udpsock;
	struct sockaddr_in addr;
	struct sockaddr_in wifi_addr;
	struct timer_list polling_timer;
#endif
#ifdef RTB_SOFTWARE_MAILBOX
	struct workqueue_struct *sock_wq;
	struct delayed_work sock_work;
#endif
	struct workqueue_struct *fw_wq;
	struct delayed_work fw_work;
	struct delayed_work cmd_work;
#ifdef RTB_SOFTWARE_MAILBOX
	struct sock *sk;
#endif
	struct urb *urb;
	spinlock_t spin_lock_sock;
	struct mutex profile_mutex;
	struct mutex conn_mutex;
	uint16_t profile_bitmap;
	uint16_t profile_status;
	int8_t profile_refcount[profile_max];
	uint8_t ispairing;
	uint8_t isinquirying;
	uint8_t ispaging;
#ifdef RTB_SOFTWARE_MAILBOX
	uint8_t wifi_state;
	uint8_t autoreport;
	uint8_t polling_enable;
	uint8_t polling_interval;
	uint8_t piconet_id;
	uint8_t mode;
	uint8_t afh_map[10];
#endif
	uint16_t hci_reversion;
	uint16_t lmp_subversion;
#ifdef RTB_SOFTWARE_MAILBOX
	uint8_t wifi_on;
	uint8_t sock_open;
#endif

	unsigned long cmd_last_tx;

	spinlock_t rxlock;
	__u8 pkt_type;
	__u16 expect;
	__u8 *tbuff;
	__u16 elen;
	__u8 back_buff[HCI_MAX_EVENT_SIZE];

	struct list_head ev_free_list;
	struct list_head l2_free_list;
	struct list_head hci_pkt_list;

	/* buff addr and size */
	spinlock_t buff_lock;
	unsigned long pages_addr;
	unsigned long buff_size;

#define RTL_COEX_RUNNING	1
#define RTL_COEX_PKT_COUNTING	2
#define RTL_COEX_CONN_REMOVING	3
	unsigned long flags;

};

#ifdef __LITTLE_ENDIAN
struct sbc_frame_hdr {
	uint8_t syncword:8;		/* Sync word */
	uint8_t subbands:1;		/* Subbands */
	uint8_t allocation_method:1;	/* Allocation method */
	uint8_t channel_mode:2;		/* Channel mode */
	uint8_t blocks:2;		/* Blocks */
	uint8_t sampling_frequency:2;	/* Sampling frequency */
	uint8_t bitpool:8;		/* Bitpool */
	uint8_t crc_check:8;		/* CRC check */
} __attribute__ ((packed));

/* NOTE: The code is copied from pa.
 * only the bit field in 8-bit is affected by endian, not the 16-bit or 32-bit.
 * why?
 */
struct rtp_header {
	unsigned cc:4;
	unsigned x:1;
	unsigned p:1;
	unsigned v:2;

	unsigned pt:7;
	unsigned m:1;

	uint16_t sequence_number;
	uint32_t timestamp;
	uint32_t ssrc;
	uint32_t csrc[0];
} __attribute__ ((packed));

#else
/* big endian */
struct sbc_frame_hdr {
	uint8_t syncword:8;		/* Sync word */
	uint8_t sampling_frequency:2;	/* Sampling frequency */
	uint8_t blocks:2;		/* Blocks */
	uint8_t channel_mode:2;		/* Channel mode */
	uint8_t allocation_method:1;	/* Allocation method */
	uint8_t subbands:1;		/* Subbands */
	uint8_t bitpool:8;		/* Bitpool */
	uint8_t crc_check:8;		/* CRC check */
} __attribute__ ((packed));

struct rtp_header {
	unsigned v:2;
	unsigned p:1;
	unsigned x:1;
	unsigned cc:4;

	unsigned m:1;
	unsigned pt:7;

	uint16_t sequence_number;
	uint32_t timestamp;
	uint32_t ssrc;
	uint32_t csrc[0];
} __attribute__ ((packed));
#endif /* __LITTLE_ENDIAN */

void rtk_btcoex_parse_event(uint8_t *buffer, int count);
void rtk_btcoex_parse_cmd(uint8_t *buffer, int count);
void rtk_btcoex_parse_l2cap_data_tx(uint8_t *buffer, int count);
void rtk_btcoex_parse_l2cap_data_rx(uint8_t *buffer, int count);

void rtk_btcoex_open(struct hci_dev *hdev);
void rtk_btcoex_close(void);
void rtk_btcoex_probe(struct hci_dev *hdev);
void rtk_btcoex_init(void);
void rtk_btcoex_exit(void);
