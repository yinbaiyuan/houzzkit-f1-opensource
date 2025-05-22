#ifndef __BT_BASE_H__
#define __BT_BASE_H__

#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Compatibility patch for glib < 2.68. */
//#if !GLIB_CHECK_VERSION(2, 68, 0)
//# define g_memdup2 g_memdup
//#endif

//old gcc
#define g_memdup2 g_memdup

#define MAX_NAME_LENGTH			248
#define MAX_UUID_STR_LENGTH		36
#define MAX_UUID_INDEX			36
#define MAX_MTPOINT_STR_LENGTH	64
#define MAX_MTPOINT_MAX			36

//pre-defile (CONST)
#define MAX_GATT_SERVICE			8
#define MAX_GATT_CHARACTERISTIC		8

#define MXA_ADV_DATA_LEN			32
#define DEVICE_ADDR_LEN				6

#define BT_ATT_DEFAULT_LE_MTU		23
#define BT_ATT_MAX_LE_MTU			517
#define BT_ATT_MAX_VALUE_LEN		512
#define BT_ATT_HEADER_LEN			3

#define RK_BT_TRANSPORT_UNKNOWN		0
#define RK_BT_TRANSPORT_BR_EDR		1
#define RK_BT_TRANSPORT_LE			2

//UUID						 0000110A-0000-1000-8000-00805F9B34FB
#define BT_UUID_A2DP_SOURCE "0000110A-0000-1000-8000-00805F9B34FB"
#define BT_UUID_A2DP_SINK   "0000110B-0000-1000-8000-00805F9B34FB"
#define BT_UUID_HSP_HS      "00001108-0000-1000-8000-00805F9B34FB"
#define BT_UUID_HSP_AG      "00001112-0000-1000-8000-00805F9B34FB"
#define BT_UUID_HFP_HF      "0000111E-0000-1000-8000-00805F9B34FB"
#define BT_UUID_HFP_AG      "0000111F-0000-1000-8000-00805F9B34FB"

typedef struct {
	char *uuid;
	char **chr_props;
	bool notify;
	bool indicate;
} BLE_UUID_TYPE;

enum {
	BLE_ADVDATA_TYPE_USER = 0, //deprecated!!!
	BLE_ADVDATA_TYPE_SYSTEM
};

/* BT state */
typedef enum {
	/* adapter state */
	RK_BT_STATE_NONE,
	RK_BT_STATE_INIT_OFF,
	RK_BT_STATE_INIT_ON,
	RK_BT_STATE_TURNING_ON,
	RK_BT_STATE_TURNING_OFF,

	/* adapter SCAN state */
	RK_BT_STATE_SCAN_STARTED,
	RK_BT_STATE_SCAN_START_FAILED,
	RK_BT_STATE_SCAN_NEW_REMOTE_DEV,
	RK_BT_STATE_SCAN_DEL_REMOTE_DEV,
	RK_BT_STATE_SCAN_CHG_REMOTE_DEV,
	RK_BT_STATE_SCAN_STOPPED = 10,

	/* device state */
	RK_BT_STATE_DISCONN_FAILED,
	RK_BT_STATE_DISCONN,
	RK_BT_STATE_CONNECT_FAILED,
	RK_BT_STATE_CONNECTED,
	RK_BT_STATE_BOND_NONE,
	RK_BT_STATE_BOND_FAILED,
	RK_BT_STATE_BONDED,
	RK_BT_STATE_PAIR_NONE,
	RK_BT_STATE_PAIR_FAILED,
	RK_BT_STATE_PAIRED = 20,
	RK_BT_STATE_DEL_DEV_OK,
	RK_BT_STATE_DEL_DEV_FAILED,

	/* adapter state */
	RK_BT_STATE_ADAPTER_POWER_ON,
	RK_BT_STATE_ADAPTER_POWER_OFF,
	RK_BT_STATE_ADAPTER_DISCOVERYABLED,
	RK_BT_STATE_ADAPTER_NO_DISCOVERYABLED,
	RK_BT_STATE_ADAPTER_PAIRABLED,
	RK_BT_STATE_ADAPTER_NO_PAIRABLED,
	RK_BT_STATE_ADAPTER_SCANNING,
	RK_BT_STATE_ADAPTER_NO_SCANNING,
	RK_BT_STATE_ADAPTER_NAME_CHANGE,
	RK_BT_STATE_ADAPTER_BLE_ADV_START,
	RK_BT_STATE_ADAPTER_BLE_ADV_STOP,
	RK_BT_STATE_ADAPTER_BLE_ADV_ERR,

	/* common cmd resp */
	RK_BT_STATE_COMMAND_RESP_ERR,
	RK_BT_STATE_COMMAND_RESP_OK,

	/* a2dp transport */
	RK_BT_STATE_TRANSPORT_IDLE,			/** Not acquired and suspended */
	RK_BT_STATE_TRANSPORT_PENDING,		/** Playing but not acquired */
	RK_BT_STATE_TRANSPORT_REQUESTING,	/** Acquire in progress */
	RK_BT_STATE_TRANSPORT_ACTIVE,		/** Acquired and playing */
	RK_BT_STATE_TRANSPORT_SUSPENDING,	/** Release in progress */
	RK_BT_STATE_TRANSPORT_VOLUME,		/** volume */

	//avrcp
	RK_BT_STATE_SINK_PLAY,
	RK_BT_STATE_SINK_PAUSE,
	RK_BT_STATE_SINK_STOP,

	/* a2dp event */
	RK_BT_STATE_SINK_ADD,
	RK_BT_STATE_SINK_DEL,
	RK_BT_STATE_SRC_ADD,
	RK_BT_STATE_SRC_DEL,

	/* profile state */
} RK_BT_STATE;

/* input event */
typedef enum {
	/** local client role - operate by local */
	RK_BLE_GATT_CLIENT_READ_BY_LOCAL,
	RK_BLE_GATT_CLIENT_WRITE_RESP_BY_LOCAL,
	RK_BLE_GATT_CLIENT_NOTIFYD,
	RK_BLE_GATT_CLIENT_INDICATED,

	RK_BLE_GATT_MTU,

	/** local server role - operate by remote */
	RK_BLE_GATT_SERVER_READ_BY_REMOTE,
	RK_BLE_GATT_SERVER_WRITE_BY_REMOTE,
	RK_BLE_GATT_SERVER_INDICATE_RESP_BY_REMOTE,
	RK_BLE_GATT_SERVER_ENABLE_NOTIFY_BY_REMOTE,
	RK_BLE_GATT_SERVER_DISABLE_NOTIFY_BY_REMOTE,
} RK_BLE_GATT_STATE;

typedef enum {
	SCAN_TYPE_AUTO,		/**< BREDR AND LE */
	SCAN_TYPE_BREDR,	/**< BREDR */
	SCAN_TYPE_LE,		/**< LE */
} RK_BT_SCAN_TYPE;

typedef enum {
	RK_BT_DEV_PLATFORM_UNKNOWN = 0,	/**< unknown platform */
	RK_BT_DEV_PLATFORM_IOS,			/**< Apple iOS */
} RK_BT_DEV_PLATFORM_TYPE;

/* bt control cmd */
enum BtControl {
	BT_PLAY,
	BT_PAUSE_PLAY,
	BT_RESUME_PLAY,
	BT_VOLUME_UP,
	BT_VOLUME_DOWN,
	BT_AVRCP_FWD,
	BT_AVRCP_BWD,
	BT_AVRCP_STOP,
};

typedef struct {
	BLE_UUID_TYPE server_uuid;
	BLE_UUID_TYPE chr_uuid[MAX_GATT_CHARACTERISTIC];
	/** characteristic cnt */
	uint8_t chr_cnt;
} RkBleGattService;

typedef struct {
	/** ble controller name */
	const char *ble_name;

	/** standard ble advtertise data */
	/**
	 * SERVICE UUID
	 * GAP and GATT service UUIDs should not be included in a Service UUIDs AD type,
	 * for either a complete or incomplete list.
	 *
	 * The Service UUID data type is used to include a list of Service or Service Class UUIDs. \n
	 * 16/32/128-bit Bluetooth Service UUIDs.
	 *
	 * 16-bit and 32-bit UUIDs shall only be used if they are assigned by the Bluetooth SIG.\n
	 * The Bluetooth SIG may assign 16-bit and 32-bit UUIDs to member companies or organizations.
	 *
	 * #define BT_AD_UUID16_SOME		0x02 \n
	 * #define BT_AD_UUID16_ALL			0x03 \n
	 * #define BT_AD_UUID32_SOME		0x04 \n
	 * #define BT_AD_UUID32_ALL			0x05 \n
	 * #define BT_AD_UUID128_SOME		0x06 \n
	 * #define BT_AD_UUID128_ALL		0x07 \n
	 */
	BLE_UUID_TYPE adv_server_uuid;

	/**
	 * The TX Power Level data type indicates
	 * the transmitted power level of the packet containing the data type. \n
	 * The TX Power Level should be the radiated power level. \n
	 * 
	 * If the power level is included in a TX Power Level
	 * AD Structure (see [Vol 3] Part C, Section 11) created by the Host,
	 * then **the Host should set the value to be as accurate as possible. \n
	 *
	 * #define BT_AD_TX_POWER			0x0a
	 */
	uint8_t tx_power;

	/**
	 * The Appearance data type defines the external appearance of the device. \n
	 * #define BT_AD_GAP_APPEARANCE		0x19
	 */
	uint16_t Appearance;

	/**
	 * The first 2 octets contain the Company Identifier Code
	 * followed by additional manufacturer specific data \n
	 * #define BT_AD_MANUFACTURER_DATA		0xff
	 */
	uint16_t manufacturer_id;
	uint8_t manufacturer_data[25];

	/** ble is advtertised ? */
	bool ble_advertised;

	/** ble att mtu */
	uint16_t att_mtu;

	/** ble service/char */
	RkBleGattService gatt_instance[MAX_GATT_SERVICE];
	/** service cnt */
	uint8_t srv_cnt;

	/* recevice data */
	void (*cb_ble_recv_fun)(const char *uuid, char *data, int *len, RK_BLE_GATT_STATE event);
} RkBleContent;

/**
 * A2dp Media
 */
typedef enum {
	TRANSPORT_STATE_IDLE,			/* Not acquired and suspended */
	TRANSPORT_STATE_PENDING,		/* Playing but not acquired */
	TRANSPORT_STATE_REQUESTING,		/* Acquire in progress */
	TRANSPORT_STATE_ACTIVE,			/* Acquired and playing */
	TRANSPORT_STATE_SUSPENDING,		/* Release in progress */
} Rk_transport_state_t;

/**
 * Channel_Mode
 * #define SBC_CHANNEL_MODE_MONO			(1 << 3)
 * #define SBC_CHANNEL_MODE_DUAL_CHANNEL	(1 << 2)
 * #define SBC_CHANNEL_MODE_STEREO			(1 << 1)
 * #define SBC_CHANNEL_MODE_JOINT_STEREO	(1 << 0)
 *
 * Frequency
 * #define SBC_SAMPLING_FREQ_16000			(1 << 3)
 * #define SBC_SAMPLING_FREQ_32000			(1 << 2)
 * #define SBC_SAMPLING_FREQ_44100			(1 << 1)
 * #define SBC_SAMPLING_FREQ_48000			(1 << 0)
 *
 * Block_length
 * #define SBC_BLOCK_LENGTH_4				(1 << 3)
 * #define SBC_BLOCK_LENGTH_8				(1 << 2)
 * #define SBC_BLOCK_LENGTH_12				(1 << 1)
 * #define SBC_BLOCK_LENGTH_16				(1 << 0)
 * 
 * Subbands
 * #define SBC_SUBBANDS_4					(1 << 1)
 * #define SBC_SUBBANDS_8					(1 << 0)
 *
 * Allocation_Method
 * #define SBC_ALLOCATION_SNR				(1 << 1)
 * #define SBC_ALLOCATION_LOUDNESS			(1 << 0)
 * 
 * Bitpool
 * #define SBC_MIN_BITPOOL					2
 * #define SBC_MAX_BITPOOL					250
 */
typedef struct {
	uint8_t channel_mode:4;
	uint8_t frequency:4;
	uint8_t allocation_method:2;
	uint8_t subbands:2;
	uint8_t block_length:4;
	uint8_t min_bitpool;
	uint8_t max_bitpool;
} __attribute__ ((packed)) Rk_a2dp_sbc_t;

typedef struct {
	/** 
	 * Available sep
	 * '/org/bluez/hci0/dev_F0_13_C3_50_FF_26/sep1'
	 */
	char endpoint[MAX_MTPOINT_STR_LENGTH + 1];
	char remote_uuids[MAX_UUID_STR_LENGTH + 1];

	/** 
	 * CODEC
	 * #define A2DP_CODEC_SBC			0x00
	 * #define A2DP_CODEC_MPEG12 		0x01
	 * #define A2DP_CODEC_MPEG24 		0x02
	 * #define A2DP_CODEC_ATRAC			0x04
	 * #define A2DP_CODEC_VENDOR 		0xFF
	 */
	uint8_t codec;

	//Config
	Rk_a2dp_sbc_t sbc;

	RK_BT_STATE state;

	//transport volume
	uint16_t volume;

	/** /org/bluez/hci0/dev_F0_13_C3_50_FF_26/sep1/fd0 */
	//char transport[MAX_MTPOINT_STR_LENGTH + 1];
} RkBtMedia;

typedef struct {
	/** adapter name for BREDR */
	const char *bt_name;
	/** adapter address for BREDR */
	const char *bt_addr;

#define IO_CAPABILITY_DISPLAYONLY		0x00
#define IO_CAPABILITY_DISPLAYYESNO		0x01
#define IO_CAPABILITY_KEYBOARDONLY		0x02
#define IO_CAPABILITY_NOINPUTNOOUTPUT	0x03
#define IO_CAPABILITY_KEYBOARDDISPLAY	0x04
	/** io capability for adapter*/
	uint8_t io_capability;

	/** STORE DIR */
	const char *bt_dir_name;

	/** bt adapter state */
	bool init;
	bool power;
	bool pairable;
	bool discoverable;
	bool scanning;

	/**
	 * audio server
	 * Only one can be enabled
	 */
	bool bluealsa;
	//bool pulseaudio;

	/** profile */
#define PROFILE_A2DP_SINK_HF			(1 << 0)
#define PROFILE_A2DP_SOURCE_AG			(1 << 1)
#define PROFILE_SPP						(1 << 2)
#define PROFILE_BLE						(1 << 3)
	uint8_t profile;

	/** ble context */
	RkBleContent ble_content;
} RkBtContent;

/**
 * @brief Indicates a remote Bluetooth device
 */
typedef struct remote_dev {
	/**
	 * Example: 00:0C:3E:3A:4B:69, \n
	 * On the UI level any number shall have the MSB -> LSB (from left to right) ‘natural’ ordering.
	 */
	char remote_address[18];

	/** "random" or "public" */
	char remote_address_type[7];

	/**
	 * The Bluetooth Device Name can be up to 248 bytes (see [Vol 2] Part C, Section 4.3.5) \n
	 * It shall be encoded according to UTF-8 \n
	 * the UI level may be restricted to as few as 62 characters
	 */
	char remote_name[MAX_NAME_LENGTH + 1];
	char remote_alias[MAX_NAME_LENGTH + 1];

	/**
	 * Class of Device \n
	 * is a parameter received during the device discovery procedure  \n
	 * on the BR/EDR physical transport, indicating the type of device. \n
	 * The terms for the defined Bluetooth Device Classes and Bluetooth Service Types are defined in [3] \n
	 * [3] Assigned Numbers Specification: https://www.bluetooth.com/specifications/assigned-numbers \n
	 */
	uint32_t cod;

	/**
	 * Generic Access Profile  \n
	 * The Appearance characteristic contains a 16-bit number \n
	 * It is a characteristic of the GAP service located on the device’s GATT Server. \n
	 * See Section 12.2(APPEARANCE CHARACTERISTIC). \n
	 * Assigned Numbers Specification: https://www.bluetooth.com/specifications/assigned-numbers \n
	 * 2.6 Appearance Values
	 */
	uint16_t appearance;

	/** class_to_icon \n
	 * gap_appearance_to_icon
	 */
	char icon[64];

	char modalias[64 + 1];

	/** The ATT MTU */
	uint16_t att_mtu;
	//for notify/indicate
	uint32_t gatt_notify_fd;

	/* AdvertisingFlags */
	uint8_t flags;

	int16_t rssi;
	int8_t tx_power;

	//EIR UUID
	char remote_uuids[MAX_UUID_INDEX][MAX_UUID_STR_LENGTH + 1];

	RkBtMedia media;

	bool exist;

	//change event/reason
	char change_name[64];

	//remote dev path: /org/bluez/hci0/dev_F8_7D_76_F2_12_F3
	char dev_path[37 + 1];

	//base state
	bool connected;
	bool paired;
	bool bonded;
	//bool trusted;
	bool blocked;
	bool auto_connect;

	bool disable_auto_connect;
	bool general_connect;

	//avrcp
	RK_BT_STATE player_state;
	int player_position;
	

	/** len == "/org/bluez/hci0/dev_70_5D_1F_65_EE_E0" + 1 \n
	 * device path: "/org/bluez/hci0/dev_70_5D_1F_65_EE_E0"
	 */
	char obj_path[38];

	void *data;
} RkBtRemoteDev;

typedef bool (*RK_BT_VENDOR_CALLBACK)(bool enable);
typedef bool (*RK_BT_AUDIO_SERVER_CALLBACK)(void);

typedef void (*RK_BT_STATE_CALLBACK)(RkBtRemoteDev *rdev, RK_BT_STATE state);
typedef void (*RK_BLE_GATT_CALLBACK)(const char *bd_addr, unsigned int mtu);

void rk_bt_register_vendor_callback(RK_BT_VENDOR_CALLBACK cb);
void rk_bt_register_audio_server_callback(RK_BT_AUDIO_SERVER_CALLBACK cb);

void rk_bt_set_profile(uint8_t profile);


/**
 * @ingroup  rk_bt_basic
 * @brief  RK_BT_STATE_CALLBACK
 *
 * @par Description
        RK_BT_STATE_CALLBACK
 *
 * @attention  !!!Never write or call delayed or blocked code or functions inside this function.
 * @attention  !!!Never write or call delayed or blocked code or functions inside this function.
 * @attention  !!!Never write or call delayed or blocked code or functions inside this function.
 
 * @param cb void (*RK_BT_STATE_CALLBACK)(RkBtRemoteDev *rdev, RK_BT_STATE state);
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
void rk_bt_register_state_callback(RK_BT_STATE_CALLBACK cb);

/**
 * @ingroup  rk_bt_basic
 * @brief  rk_bt_version
 *
 * @par Description
        rk_bt_version
 *
 * @attention
 * @param NULL
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
char *rk_bt_version(void);

/**
 * @ingroup  rk_bt_basic
 * @brief  rk_bt_set_discoverable
 *
 * @par Description
        rk_bt_set_discoverable
 *
 * @attention
 * @param  enable 
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
void rk_bt_set_discoverable(bool enable);

/**
 * @ingroup  rk_bt_basic
 * @brief  rk_bt_set_power
 *
 * @par Description
        rk_bt_set_power
 *
 * @attention
 * @param  enable 
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
void rk_bt_set_power(bool enable);

/**
 * @ingroup  rk_bt_basic
 * @brief  rk_bt_set_pairable
 *
 * @par Description
        rk_bt_set_pairable
 *
 * @attention
 * @param  enable 
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */

void rk_bt_set_pairable(bool enable);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt avrcp cmd for sink
 *
 * @par Description
        bt avrcp cmd for sink
 *
 * @attention  Wait for RK_BT_STATE_SINK_* from the RK_BT_STATE_CALLBACK callback
 * @param  cmd "play" "pause" "next" "previous"
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_sink_media_control(char *cmd);


/**
 * @ingroup  rk_bt_basic
 * @brief  get all remote dev
 *
 * @par Description
        bt get all remote dev
 *
 * @attention
 * @param  scan_list [OUT]  device list
 * @param  len [OUT]  device nums
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int bt_get_devices(struct remote_dev **scan_list, int *len);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt_get_dev_info
 *
 * @par Description
        get info abot the specified remote dev
 *
 * @attention
 * @param  pdev [OUT] Information is stored here
 * @param  t_addr [IN] Address of the remote device
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int bt_get_dev_info(struct remote_dev *pdev, char *t_addr);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt connect remote dev
 *
 * @par Description
        bt connect remote dev
 *
 * @attention  Wait for RK_BT_STATE_CONNECT* from the RK_BT_STATE_CALLBACK callback
 * @param  address remote dev addr
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_connect_by_addr(char *address);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt discon remote dev
 *
 * @par Description
        bt discon remote dev
 *
 * @attention  Wait for RK_BT_STATE_DISCONN* from the RK_BT_STATE_CALLBACK callback
 * @param  address remote dev addr
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_disconnect_by_addr(char *address);

//TODO void rk_bt_adapter_info(char *data);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt initialize
 *
 * @par Description
        bt adapter init
 *
 * @attention  Must wait for RK_BT_STATE_INIT_ON of the RK_BT_STATE_CALLBACK callback
 * @param  p_bt_content [IN]  Type  [RkBtContent *]
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_init(RkBtContent *p_bt_content);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt de-initialize
 *
 * @par Description
        bt adapter init
 *
 * @attention  Wait for RK_BT_STATE_INIT_OFF from the RK_BT_STATE_CALLBACK callback
 * @param  NULL
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_deinit(void);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt scan
 *
 * @par Description
        bt scan
 *
 * @attention Wait for RK_BT_STATE_SCAN_STARTED from the RK_BT_STATE_CALLBACK callback
 * @param  scan_type RK_BT_SCAN_TYPE
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_start_discovery(RK_BT_SCAN_TYPE scan_type);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt scan stop
 *
 * @par Description
        bt scan stop
 *
 * @attention  Wait for RK_BT_STATE_SCAN_STOPPED from the RK_BT_STATE_CALLBACK callback
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_cancel_discovery(void);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt pair remote ble dev
 *
 * @par Description
        bt pair remote ble dev
 *
 * @attention  Wait for RK_BT_STATE_CONNECT* from the RK_BT_STATE_CALLBACK callback
 * @param  addr remote dev addr
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_pair_by_addr(char *addr);

/**
 * @ingroup  rk_bt_basic
 * @brief  bt unpair remote ble dev
 *
 * @par Description
        bt unpair remote ble dev
 *
 * @attention
 * @param addr  remote dev addr
 *
 * @retval 0 Excute successfully, see attention.
 * @retval -1 Error code
 * @see  NULL
 */
int rk_bt_unpair_by_addr(char *addr);

//RK_BT_DEV_PLATFORM_TYPE rk_bt_get_dev_platform(char *addr);
//for bsa, bluez don't support
//0: TRANSPORT_UNKNOWN, 1: TRANSPORT_BR_EDR, 2: TRANSPORT_LE

#ifdef __cplusplus
}
#endif

#endif /* __BT_BASE_H__ */
