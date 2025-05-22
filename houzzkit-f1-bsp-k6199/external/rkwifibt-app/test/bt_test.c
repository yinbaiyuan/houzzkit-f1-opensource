#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <alsa/asoundlib.h>
#include <pthread.h>

#include <RkBtBase.h>
#include <RkBtSink.h>
#include <RkBtSource.h>
#include <RkBle.h>
#include <RkBtSpp.h>
#include <RkBleClient.h>

//vendor code for broadcom
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <sys/ioctl.h>
enum{
	A2DP_SOURCE,
	A2DP_SINK
};

enum{
	ACL_NORMAL_PRIORITY,
	ACL_HIGH_PRIORITY
};
int vendor_set_high_priority(char *ba, uint8_t priority, uint8_t direction);
//vendor code for broadcom end


#include "bt_test.h"
#include "utility.h"

/* AD SERVICE_UUID */
#define AD_SERVICE_UUID16	"1111"
#define AD_SERVICE_UUID32	"00002222"
#define AD_SERVICE_UUID128	"00002222-0000-1000-8000-00805f9b34fb"

/* GAP/GATT Service UUID */
#define BLE_UUID_SERVICE	"00001111-0000-1000-8000-00805F9B34FB"
#define BLE_UUID_WIFI_CHAR	"00002222-0000-1000-8000-00805F9B34FB"
#define BLE_UUID_SEND		"dfd4416e-1810-47f7-8248-eb8be3dc47f9"
#define BLE_UUID_RECV		"9884d812-1810-4a24-94d3-b2c11a851fac"
#define SERVICE_UUID		"00001910-0000-1000-8000-00805f9b34fb"

#define BLE_UUID_SERVICE1	"00001234-0000-1000-8000-00805F9B34FB"
#define BLE_UUID_WIFI_CHAR1	"00001235-0000-1000-8000-00805F9B34FB"
#define BLE_UUID_SEND1		"00001236-1810-47f7-8248-eb8be3dc47f9"
#define BLE_UUID_RECV1		"00001237-1810-4a24-94d3-b2c11a851fac"
#define SERVICE_UUID1		"00001238-0000-1000-8000-00805f9b34fb"

static void bt_test_ble_recv_data_callback(const char *uuid, char *data, int *len, RK_BLE_GATT_STATE state);

/* Must be initialized before using */
static RkBtContent bt_content;

/* BT base api */
static volatile bool gonff = false;
//!!!Never write or call delayed or blocked code or functions inside this function.
//!!!Never write or call delayed or blocked code or functions inside this function.
//!!!Never write or call delayed or blocked code or functions inside this function.
static void bt_test_state_cb(RkBtRemoteDev *rdev, RK_BT_STATE state)
{
	switch (state) {
	//BASE STATE
	case RK_BT_STATE_TURNING_ON:
		printf("++ RK_BT_STATE_TURNING_ON\n");
		break;
	case RK_BT_STATE_INIT_ON:
		printf("++ RK_BT_STATE_INIT_ON\n");
		bt_content.init = true;
		break;
	case RK_BT_STATE_INIT_OFF:
		printf("++ RK_BT_STATE_INIT_OFF\n");
		bt_content.init = false;
		break;

	//SCAN STATE
	case RK_BT_STATE_SCAN_NEW_REMOTE_DEV:
		if (rdev->paired)
			printf("+ PAIRED_DEV: [%s|%d]:%s:%s\n", rdev->remote_address, rdev->rssi,
					rdev->remote_address_type, rdev->remote_alias);
		else
			printf("+ SCAN_NEW_DEV: [%s|%d]:%s:%s\n", rdev->remote_address, rdev->connected,
					rdev->remote_address_type, rdev->remote_alias);
		break;
	case RK_BT_STATE_SCAN_CHG_REMOTE_DEV:
		printf("+ SCAN_CHG_DEV: [%s|%d]:%s:%s|%s\n", rdev->remote_address, rdev->rssi,
				rdev->remote_address_type, rdev->remote_alias, rdev->change_name);
		if (!strcmp(rdev->change_name, "UUIDs")) {
			for (int index = 0; index < 36; index++) {
				if (!strcmp(rdev->remote_uuids[index], "NULL"))
					break;
				printf("\tUUIDs: %s\n", rdev->remote_uuids[index]);
			}
		} else if (!strcmp(rdev->change_name, "Icon")) {
			printf("\tIcon: %s\n", rdev->icon);
		} else if (!strcmp(rdev->change_name, "Class")) {
			printf("\tClass: 0x%x\n", rdev->cod);
		} else if (!strcmp(rdev->change_name, "Modalias")) {
			printf("\tModalias: %s\n", rdev->modalias);
		}
		break;
	case RK_BT_STATE_SCAN_DEL_REMOTE_DEV:
		printf("+ SCAN_DEL_DEV: [%s]:%s:%s\n", rdev->remote_address,
				rdev->remote_address_type, rdev->remote_alias);
		break;

	//LINK STATE
	case RK_BT_STATE_CONNECTED:
	case RK_BT_STATE_DISCONN:
		printf("+ %s [%s|%d]:%s:%s\n", rdev->connected ? "STATE_CONNECT" : "STATE_DISCONN",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_PAIRED:
	case RK_BT_STATE_PAIR_NONE:
		printf("+ %s [%s|%d]:%s:%s\n", rdev->paired ? "STATE_PAIRED" : "STATE_PAIR_NONE",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_BONDED:
	case RK_BT_STATE_BOND_NONE:
		printf("+ %s [%s|%d]:%s:%s\n", rdev->bonded ? "STATE_BONDED" : "STATE_BOND_NONE",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_BOND_FAILED:
	case RK_BT_STATE_PAIR_FAILED:
	case RK_BT_STATE_DISCONN_FAILED:
	case RK_BT_STATE_CONNECT_FAILED:
	case RK_BT_STATE_DEL_DEV_FAILED:
		printf("+ STATE_FAILED [%s|%d]:%s:%s reason: %s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias,
				rdev->change_name);
		break;

	//MEDIA A2DP SOURCE
	case RK_BT_STATE_SRC_ADD:
	case RK_BT_STATE_SRC_DEL:
		printf("+ STATE SRC MEDIA %s [%s|%d]:%s:%s\n",
				(state == RK_BT_STATE_SRC_ADD) ? "ADD" : "DEL",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		printf("+ codec: %s, freq: %s, chn: %s\n",
					rdev->media.codec == 0 ? "SBC" : "UNKNOW",
					rdev->media.sbc.frequency == 1 ? "48K" : "44.1K",
					rdev->media.sbc.channel_mode == 1 ? "JOINT_STEREO" : "STEREO");
		break;

	//MEDIA AVDTP TRANSPORT
	case RK_BT_STATE_TRANSPORT_VOLUME:
		printf("+ STATE AVDTP TRASNPORT VOLUME[%d] [%s|%d]:%s:%s\n",
				rdev->media.volume,
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_TRANSPORT_IDLE:
		printf("+ STATE AVDTP TRASNPORT IDLE [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		//low priority
		vendor_set_high_priority(rdev->remote_address, ACL_NORMAL_PRIORITY,
								 bt_content.profile & PROFILE_A2DP_SINK_HF ? A2DP_SINK : A2DP_SOURCE);
		break;
	case RK_BT_STATE_TRANSPORT_PENDING:
		printf("+ STATE AVDTP TRASNPORT PENDING [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_TRANSPORT_ACTIVE:
		printf("+ STATE AVDTP TRASNPORT ACTIVE [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		//high priority
		vendor_set_high_priority(rdev->remote_address, ACL_HIGH_PRIORITY,
								 bt_content.profile & PROFILE_A2DP_SINK_HF ? A2DP_SINK : A2DP_SOURCE);
		break;
	case RK_BT_STATE_TRANSPORT_SUSPENDING:
		printf("+ STATE AVDTP TRASNPORT SUSPEND [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;

	//MEDIA A2DP SINK
	case RK_BT_STATE_SINK_ADD:
	case RK_BT_STATE_SINK_DEL:
		printf("+ STATE SINK MEDIA %s [%s|%d]:%s:%s\n",
				(state == RK_BT_STATE_SINK_ADD) ? "ADD" : "DEL",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		printf("+ codec: %s, freq: %s, chn: %s\n",
					rdev->media.codec == 0 ? "SBC" : "UNKNOW",
					rdev->media.sbc.frequency == 1 ? "48K" : "44.1K",
					rdev->media.sbc.channel_mode == 1 ? "JOINT_STEREO" : "STEREO");
		break;
	case RK_BT_STATE_SINK_PLAY:
		printf("+ STATE SINK PLAYER PLAYING [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_SINK_STOP:
		printf("+ STATE SINK PLAYER STOP [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	case RK_BT_STATE_SINK_PAUSE:
		printf("+ STATE SINK PLAYER PAUSE [%s|%d]:%s:%s\n",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;

	//ADV
	case RK_BT_STATE_ADAPTER_BLE_ADV_START:
		bt_content.ble_content.ble_advertised = true;
		printf("RK_BT_STATE_ADAPTER_BLE_ADV_START successful\n");
		break;
	case RK_BT_STATE_ADAPTER_BLE_ADV_STOP:
		bt_content.ble_content.ble_advertised = false;
		printf("RK_BT_STATE_ADAPTER_BLE_ADV_STOP successful\n");
		break;

	//ADAPTER STATE
	case RK_BT_STATE_ADAPTER_NO_DISCOVERYABLED:
		bt_content.discoverable = false;
		printf("RK_BT_STATE_ADAPTER_NO_DISCOVERYABLED successful\n");
		break;
	case RK_BT_STATE_ADAPTER_DISCOVERYABLED:
		bt_content.discoverable = true;
		printf("RK_BT_STATE_ADAPTER_DISCOVERYABLED successful\n");
		break;
	case RK_BT_STATE_ADAPTER_NO_PAIRABLED:
		bt_content.pairable = false;
		printf("RK_BT_STATE_ADAPTER_NO_PAIRABLED successful\n");
		break;
	case RK_BT_STATE_ADAPTER_PAIRABLED:
		bt_content.pairable = true;
		printf("RK_BT_STATE_ADAPTER_PAIRABLED successful\n");
		break;
	case RK_BT_STATE_ADAPTER_NO_SCANNING:
		bt_content.scanning = false;
		printf("RK_BT_STATE_ADAPTER_NO_SCANNING successful\n");
		break;
	case RK_BT_STATE_ADAPTER_SCANNING:
		bt_content.scanning = true;
		printf("RK_BT_STATE_ADAPTER_SCANNING successful\n");
		break;
	case RK_BT_STATE_ADAPTER_POWER_ON:
		bt_content.power = true;
		printf("RK_BT_STATE_ADAPTER_POWER_ON successful\n");
		break;
	case RK_BT_STATE_ADAPTER_POWER_OFF:
		bt_content.power = false;
		printf("RK_BT_STATE_ADAPTER_POWER_OFF successful\n");
		break;
	case RK_BT_STATE_COMMAND_RESP_ERR:
		printf("RK_BT_STATE CMD ERR!!!\n");
		break;
	case RK_BT_STATE_DEL_DEV_OK:
		if (rdev != NULL)
			printf("+ RK_BT_STATE_DEL_DEV_OK: %s:%s:%s\n",
				rdev->remote_address,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;
	default:
		if (rdev != NULL)
			printf("+ DEFAULT STATE %d: %s:%s:%s RSSI: %d [CBP: %d:%d:%d]\n", state,
				rdev->remote_address,
				rdev->remote_address_type,
				rdev->remote_alias,
				rdev->rssi,
				rdev->connected,
				rdev->paired,
				rdev->bonded);
		break;
	}
}

void bt_test_version(char *data)
{
	printf("RK BT VERSION: %s\n", rk_bt_version());
}


#if 0//EXADV
	int printCharBuf(unsigned char *msgBuf, int len)
	{
		int i;
		for(i=0; i<len; i++){
			printf("%02x ",msgBuf[i]);
		}
		printf("\n");
		return 0;
	}

	int len, ble_name_len, remain_len;
	/* user custom adv data */
	bt_content.ble_content.advDataType = BLE_ADVDATA_TYPE_USER;
	/*example1: rk demo*/
	//标识设备 LE 物理连接的功能
	bt_content.ble_content.advData[1] = 0x02;
	bt_content.ble_content.advData[2] = 0x01;
	bt_content.ble_content.advData[3] = 0x02;

	//service uuid(SERVICE_UUID)
	bt_content.ble_content.advData[4] = 0x03;
	bt_content.ble_content.advData[5] = 0x03;
	bt_content.ble_content.advData[6] = 0x10;
	bt_content.ble_content.advData[7] = 0x19;

	//ble name
	printf("ble_name_len: %s(%ld)\n", bt_content.ble_content.ble_name, strlen(bt_content.ble_content.ble_name));
	ble_name_len = strlen(bt_content.ble_content.ble_name);
	remain_len = 31 - (bt_content.ble_content.advData[1] + 1)
					- (bt_content.ble_content.advData[4] + 1);
	len = ble_name_len > remain_len ? remain_len : ble_name_len;
	bt_content.ble_content.advData[8] = len + 1;
	bt_content.ble_content.advData[9] = 0x09;
	memcpy(&bt_content.ble_content.advData[10], bt_content.ble_content.ble_name, len);

	bt_content.ble_content.advData[0] = bt_content.ble_content.advData[1] + 1
										+ bt_content.ble_content.advData[4] + 1
										+ bt_content.ble_content.advData[8] + 1;
	bt_content.ble_content.advDataLen = bt_content.ble_content.advData[0] + 1;

	//==========================rsp======================
	bt_content.ble_content.respData[1] = 0x16;  //长度
	bt_content.ble_content.respData[2] = 0xFF;  //字段类型

	/*厂商编码*/
	bt_content.ble_content.respData[3] = 0x46;
	bt_content.ble_content.respData[4] = 0x00;

	bt_content.ble_content.respData[5] = 0x02;  //项目代号长度

	/*项目代号*/
	bt_content.ble_content.respData[6] = 0x1c;
	bt_content.ble_content.respData[7] = 0x02;

	bt_content.ble_content.respData[8] = 0x04;  //版本号长度
	bt_content.ble_content.respData[9] = 'T';   //版本号类型
	/*版本号*/
	bt_content.ble_content.respData[10] = 0x01;
	bt_content.ble_content.respData[11] = 0x00;
	bt_content.ble_content.respData[12] = 0x00;

	bt_content.ble_content.respData[13] = 0x08;	// SN长度
	/*SN号*/
	bt_content.ble_content.respData[14] = 0x54;
	bt_content.ble_content.respData[15] = 0x00;
	bt_content.ble_content.respData[16] = 0x00;
	bt_content.ble_content.respData[17] = 0x00;
	bt_content.ble_content.respData[18] = 0x00;
	bt_content.ble_content.respData[19] = 0x00;
	bt_content.ble_content.respData[20] = 0x00;
	bt_content.ble_content.respData[21] = 0x36;

	bt_content.ble_content.respData[22] = 0x01;	//绑定信息长度
	bt_content.ble_content.respData[23] = 0x00;	//绑定信息

	bt_content.ble_content.respData[0] = bt_content.ble_content.respData[1] + 1;  //长度
	bt_content.ble_content.respDataLen = bt_content.ble_content.respData[0] + 1;

	/* example2: tuya demo */
	#if 0
	unsigned char tuyaAdv[] = {0x1c, 0x02, 0x01, 0x06, 0x03, 0x02, 0x01, 0xa2, 0x14, 0x16, 0x01, 0xa2, 0x00, 0x61, 0x7a, 0x71, 0x6f, 0x76, 0x61, 0x38, 0x6d, 0x78, 0x6e, 0x74, 0x7a, 0x78, 0x70, 0x70, 0x77};
	unsigned char tuyaRsp[] = {0x1e, 0x03, 0x09, 0x54, 0x59, 0x19, 0xff, 0xd0, 0x07, 0x01, 0x03, 0x03, 0x00, 0x0c, 0x00, 0x07, 0xda, 0x71, 0xde, 0xb0, 0xa4, 0x1e, 0x82, 0xbb, 0xd7, 0x9d, 0xdf, 0x07, 0x00, 0x34, 0x14};
	printf("sizeof(adv)=%d, sizeof(rsp)=%d\n", sizeof(tuyaAdv), sizeof(tuyaRsp));
	memcpy(&bt_content.ble_content.advData[0], tuyaAdv, sizeof(tuyaAdv));
	bt_content.ble_content.advDataLen = bt_content.ble_content.advData[0] + 1;
	printf("tuyaAdv:");
	printCharBuf(tuyaAdv,sizeof(tuyaAdv));
	printf("ble_content.Adv:");
	printCharBuf(&bt_content.ble_content.advData[0], bt_content.ble_content.advDataLen);
	memcpy(&bt_content.ble_content.respData[0], tuyaRsp, sizeof(tuyaRsp));
	bt_content.ble_content.respDataLen = bt_content.ble_content.respData[0] + 1;
	printf("tuyaRsp:");
	printCharBuf(tuyaRsp,sizeof(tuyaRsp));
	printf("ble_content.rsp:");
	printCharBuf(&bt_content.ble_content.respData[0], bt_content.ble_content.respDataLen);
	/* tuya example end */
	#endif

#endif
void bt_test_source_play(char *data)
{
	char rsp[64], aplay[128];
	exec_command("hcitool con | grep ACL | awk '{print $3}'", rsp, 64);
	if (rsp[0]) {
		rsp[17] = 0;
		sprintf(aplay, "aplay -D bluealsa:DEV=%s,PROFILE=a2dp /data/test.wav", rsp);
		exec_command_system(aplay);
	}
}

static bool bt_test_audio_server_cb(void)
{
	char rsp[64];

	printf("%s bt_content.profile: 0x%x:0x%x:0x%x\n", __func__, bt_content.profile,
			(bt_content.profile & PROFILE_A2DP_SINK_HF),
			(bt_content.profile & PROFILE_A2DP_SOURCE_AG));

	if (bt_content.bluealsa == true) {
		//use bluealsa
		//exec_command("pactl list modules | grep bluetooth | grep policy", rsp, 64);
		exec_command("pactl list modules | grep bluetooth", rsp, 64);
		if (rsp[0]) {
			exec_command_system("pactl unload-module module-bluetooth-policy");
			exec_command_system("pactl unload-module module-bluetooth-discover");
		}

		exec_command_system("killall bluealsa bluealsa-aplay");

		if ((bt_content.profile & PROFILE_A2DP_SINK_HF) == PROFILE_A2DP_SINK_HF) {
			exec_command_system("bluealsa -S --profile=a2dp-sink --profile=hfp-hf &");
			//Sound Card: default
			exec_command_system("bluealsa-aplay -S --profile-a2dp 00:00:00:00:00:00 &");
		} else if ((bt_content.profile & PROFILE_A2DP_SOURCE_AG) == PROFILE_A2DP_SOURCE_AG) {
			exec_command_system("bluealsa -S --profile=a2dp-source --profile=hfp-ag --a2dp-volume &");
		}
	}

	return true;
}

static bool bt_test_vendor_cb(bool enable)
{
	int times = 100;

	if (enable) {
		//vendor
		//broadcom
		if (get_ps_pid("brcm_patchram_plus1"))
			kill_task("brcm_patchram_plus1");

		//realtek
		if (get_ps_pid("rtk_hciattach"))
			kill_task("rtk_hciattach");

		//The hci0 start to init ...
		if (!access("/usr/bin/wifibt-init.sh", F_OK))
			exec_command_system("/usr/bin/wifibt-init.sh start_bt");
		else if (!access("/usr/bin/bt_init.sh", F_OK))
			exec_command_system("/usr/bin/bt_init.sh");

		//wait hci0 appear
		while (times-- > 0 && access("/sys/class/bluetooth/hci0", F_OK)) {
			usleep(100 * 1000);
		}

		if (access("/sys/class/bluetooth/hci0", F_OK) != 0) {
			printf("The hci0 init failure!\n");
			return false;
		}

		/* ensure bluetoothd running */
		/*
		 * DEBUG: vim /etc/init.d/S40bluetooth, modify BLUETOOTHD_ARGS="-n -d"
		 */
		if (access("/etc/init.d/S40bluetooth", F_OK) == 0)
			exec_command_system("/etc/init.d/S40bluetooth restart");
		else if (access("/etc/init.d/S40bluetoothd", F_OK) == 0)
			exec_command_system("/etc/init.d/S40bluetoothd restart");

		//or
		//exec_command_system("/usr/libexec/bluetoothd -n -P battery");
		//or debug
		//exec_command_system("/usr/libexec/bluetoothd -n -P battery -d");
		//exec_command_system("hcidump xxx or btmon xxx");

		//check bluetoothd
		times = 100;
		while (times-- > 0 && !(get_ps_pid("bluetoothd"))) {
			usleep(100 * 1000);
		}

		if (!get_ps_pid("bluetoothd")) {
			printf("The bluetoothd boot failure!\n");
			return false;
		}
	} else {
		//CLEAN
		exec_command_system("hciconfig hci0 down");
		exec_command_system("/etc/init.d/S40bluetooth stop");

		//vendor deinit
		if (get_ps_pid("brcm_patchram_plus1"))
			kill_task("killall brcm_patchram_plus1");
		if (get_ps_pid("rtk_hciattach"))
			kill_task("killall rtk_hciattach");

		//audio server deinit
		if (get_ps_pid("bluealsa"))
			kill_task("bluealsa");
		if (get_ps_pid("bluealsa-alay"))
			kill_task("bluealsa-alay");
	}

	return true;
}

/* bt init */
void *bt_test_init(void *arg)
{
	RkBleGattService *gatt;
	//"indicate"
	static char *chr_props[] = { "read", "write", "notify", "write-without-response", "encrypt-read", NULL };

	printf("%s \n", __func__);

	memset(&bt_content, 0, sizeof(RkBtContent));

	//BREDR CLASS BT NAME
	bt_content.bt_name = "SCO_AUDIO";

	//BLE NAME
	bt_content.ble_content.ble_name = "RBLE";

	//IO CAPABILITY
	bt_content.io_capability = IO_CAPABILITY_DISPLAYYESNO;

	/*
	 * Only one can be enabled
	 * a2dp sink and hfp-hf
	 * a2dp source and hfp-ag
	 */
	bt_content.profile = PROFILE_A2DP_SINK_HF;
	bt_content.bluealsa = true;

	// enable ble
	bt_content.profile |= PROFILE_BLE;
	if (bt_content.profile & PROFILE_BLE) {
		/* GATT SERVICE/CHARACTERISTIC */
		//SERVICE_UUID
		gatt = &(bt_content.ble_content.gatt_instance[0]);
		gatt->server_uuid.uuid = SERVICE_UUID;
		gatt->chr_uuid[0].uuid = BLE_UUID_SEND;
		gatt->chr_uuid[0].chr_props = chr_props;

		gatt->chr_uuid[1].uuid = BLE_UUID_RECV;
		gatt->chr_uuid[1].chr_props = chr_props;
		gatt->chr_cnt = 2;

		//SERVICE_UUID1
		gatt = &(bt_content.ble_content.gatt_instance[1]);
		gatt->server_uuid.uuid = SERVICE_UUID1;
		gatt->chr_uuid[0].uuid = BLE_UUID_SEND1;
		gatt->chr_uuid[0].chr_props = chr_props;
		gatt->chr_uuid[1].uuid = BLE_UUID_RECV1;
		gatt->chr_uuid[1].chr_props = chr_props;
		gatt->chr_cnt = 2;

		bt_content.ble_content.srv_cnt = 2;

		/* Fill adv data */
		/* Appearance */
		bt_content.ble_content.Appearance = 0x0080;

		/* manufacturer data */
		bt_content.ble_content.manufacturer_id = 0x0059;
		for (int i = 0; i < 16; i++)
			bt_content.ble_content.manufacturer_data[i] = i;

		/* Service UUID */
		bt_content.ble_content.adv_server_uuid.uuid = AD_SERVICE_UUID16;

		//callback
		bt_content.ble_content.cb_ble_recv_fun = bt_test_ble_recv_data_callback;
	}

	rk_bt_register_state_callback(bt_test_state_cb);
	rk_bt_register_vendor_callback(bt_test_vendor_cb);
	rk_bt_register_audio_server_callback(bt_test_audio_server_cb);

	//default state
	bt_content.init = false;

	rk_bt_init(&bt_content);

	return NULL;
}

void bt_test_bluetooth_onoff_init(char *data)
{
	int test_cnt = 5000, cnt = 0;

	if (data)
		test_cnt = atoi(data);
	printf("%s test times: %d(%d)\n", __func__, test_cnt, data ? atoi(data) : 0);

	while (cnt < test_cnt) {
		printf("BT TEST INIT START\n");
		bt_test_init(NULL);
		while (bt_content.init == false) {
			sleep(1);
			printf("BT TURNING ON ...\n");
		}

		//scan test
		rk_bt_start_discovery(SCAN_TYPE_AUTO);
		while (bt_content.scanning == false) {
			sleep(1);
			printf("BT SCAN ON ...\n");
		}
		sleep(10);
		rk_bt_cancel_discovery();
		while (bt_content.scanning == true) {
			sleep(1);
			printf("BT SCAN OFF ...\n");
		}

		//ble adv tests
		rk_ble_adv_start();
		while (bt_content.ble_content.ble_advertised == false) {
			sleep(1);
			printf("BT ADV ON ...\n");
		}
		sleep(3);
		rk_ble_adv_stop();
		while (bt_content.ble_content.ble_advertised == true) {
			sleep(1);
			printf("BT ADV OFF ...\n");
		}

		rk_bt_deinit();
		while (bt_content.init == true) {
			sleep(1);
			printf("BT TURNING OFF ...\n");
		}
		printf("BT INIT/ADV/SCAN CNTs: [====== %d ======] \n", ++cnt);
	}
}

void bt_test_bluetooth_init(char *data)
{
	bt_test_init(NULL);

	return;
}

void bt_test_bluetooth_deinit(char *data)
{
	rk_bt_deinit();

	return;
}

void bt_test_get_adapter_info(char *data)
{
	rk_bt_adapter_info(data);
}

void bt_test_connect_by_addr(char *data)
{
	rk_bt_connect_by_addr(data);
}

void bt_test_disconnect_by_addr(char *data)
{
	rk_bt_disconnect_by_addr(data);
}

void bt_test_pair_by_addr(char *data)
{
	rk_bt_pair_by_addr(data);
}

void bt_test_unpair_by_addr(char *data)
{
	rk_bt_unpair_by_addr(data);
}

void bt_test_start_discovery(char *data)
{
	RK_BT_SCAN_TYPE type;

	if (data == NULL) {
		rk_bt_start_discovery(SCAN_TYPE_AUTO);
		return;
	}

	if (!strcmp(data, "bredr"))
		type = SCAN_TYPE_BREDR;
	else if (!strcmp(data, "le"))
		type = SCAN_TYPE_LE;
	else
		type = SCAN_TYPE_AUTO;

	rk_bt_start_discovery(type);
}

void bt_test_cancel_discovery(char *data)
{
	if (bt_content.scanning == true)
	rk_bt_cancel_discovery();
}

void bt_test_set_discoverable(char *data)
{
	bool enable;

	if (data == NULL)
		return;

	if (!strcmp(data, "on"))
		enable = 1;
	else if (!strcmp(data, "off"))
		enable = 0;
	else
		return;

	rk_bt_set_discoverable(enable);
}

void bt_test_set_pairable(char *data)
{
	bool enable;

	if (data == NULL)
		return;

	if (!strcmp(data, "on"))
		enable = 1;
	else if (!strcmp(data, "off"))
		enable = 0;
	else
		return;

	rk_bt_set_pairable(enable);
}

void bt_test_set_power(char *data)
{
	bool enable;

	if (data == NULL)
		return;

	if (!strcmp(data, "on"))
		enable = 1;
	else if (!strcmp(data, "off"))
		enable = 0;
	else
		return;

	rk_bt_set_power(enable);
}

void bt_test_get_all_devices(char *data)
{
	int i, count;
	struct remote_dev *rdev = NULL;

	//Get all devices
	if (bt_get_devices(&rdev, &count) < 0) {
		printf("Can't get scan list!");
		return;
	}

	printf("rdev: %p\n", rdev);
	for (i = 0; i < count; i++) {
		if (rdev[i].connected)
			printf("Connected Device %s (%s:%s)\n",
					rdev[i].remote_address,
					rdev[i].remote_address_type,
					rdev[i].remote_alias);
		else
			printf("%s Device %s (%s:%s)\n",
				rdev[i].paired ? "Paired" : "Scaned",
				rdev[i].remote_address,
				rdev[i].remote_address_type,
				rdev[i].remote_alias);
	}
}

void bt_test_read_remote_device_info(char *data)
{
	struct remote_dev rdev;
	char *t_addr = data;

	if (bt_get_dev_info(&rdev, t_addr) < 0)
		return;

	printf("Device info: addr:%s:%s, name: %s, class:(0x%x:0x%x), RSSI: %d\n",
			rdev.remote_address,
			rdev.remote_address_type,
			rdev.remote_alias,
			rdev.cod,
			rdev.appearance,
			rdev.rssi);

	for (int index = 0; index < 10; index++) {
		if (!strcmp(rdev.remote_uuids[index], "NULL"))
			break;
		printf("	UUIDs: %s\n", rdev.remote_uuids[index]);
	}
}

/******************************************/
/*               A2DP SINK                */
/******************************************/
void bt_test_sink_media_control(char *data)
{
	rk_bt_sink_media_control(data);
}

void bt_test_a2dp_test_volume(char *data)
{
	if (data) {
		printf("===== A2DP Set Volume: %d =====\n", atoi(data));
		rk_bt_sink_set_volume(atoi(data));
	}
}

void bt_test_enable_a2dp_source(char *data)
{
	rk_bt_set_profile(PROFILE_A2DP_SOURCE_AG);
}

void bt_test_enable_a2dp_sink(char *data)
{
	rk_bt_set_profile(PROFILE_A2DP_SINK_HF);
}

/******************************************/
/*                  BLE                   */
/******************************************/

static void bt_test_ble_recv_data_callback(const char *uuid, char *data, int *len, RK_BLE_GATT_STATE state)
{
	switch (state) {
	//SERVER ROLE
	case RK_BLE_GATT_SERVER_READ_BY_REMOTE:
		//The remote dev reads characteristic and put data to *data.
		printf("+++ ble server is read by remote uuid: %s\n", uuid);
		*len = strlen("hello rockchip");
		memcpy(data, "hello rockchip", strlen("hello rockchip"));
		break;
	case RK_BLE_GATT_SERVER_WRITE_BY_REMOTE:
		//The remote dev writes data to characteristic so print there.
		printf("+++ ble server is writeen by remote uuid: %s\n", uuid);
		for (int i = 0 ; i < *len; i++) {
			printf("%02x ", data[i]);
		}
		printf("\n");
		break;
	case RK_BLE_GATT_SERVER_ENABLE_NOTIFY_BY_REMOTE:
	case RK_BLE_GATT_SERVER_DISABLE_NOTIFY_BY_REMOTE:
		//The remote dev enable notify for characteristic
		printf("+++ ble server notify is %s by remote uuid: %s\n",
				(state == RK_BLE_GATT_SERVER_ENABLE_NOTIFY_BY_REMOTE) ? "enable" : "disabled",
				uuid);
		break;
	case RK_BLE_GATT_MTU:
		//
		printf("+++ ble server MTU: %d ===\n", *(uint16_t *)data);
		break;
	case RK_BLE_GATT_SERVER_INDICATE_RESP_BY_REMOTE:
		//The service sends notify to remote dev and recv indicate from remote dev.
		printf("+++ ble server receive remote indicate resp uuid: %s\n", uuid);
		break;

	//CLIENT ROLE
	case RK_BLE_GATT_CLIENT_READ_BY_LOCAL:
		printf("+++ ble client recv remote data uuid: %s===\n", uuid);
		for (int i = 0 ; i < *len; i++) {
			printf("%02x ", data[i]);
		}
		printf("\n");
		break;
	case RK_BLE_GATT_CLIENT_WRITE_RESP_BY_LOCAL:
		break;
	case RK_BLE_GATT_CLIENT_NOTIFYD:
		break;
	case RK_BLE_GATT_CLIENT_INDICATED:
		break;
	default:
		break;
	}
}

void bt_test_ble_start(char *data)
{
	rk_ble_adv_start();
}

void bt_test_ble_set_adv_interval(char *data)
{
	//default 100ms, test: 20ms(32 * 0.625) ~ 100ms(160 * 0.625)
	rk_ble_set_adv_interval(32, 160);
}

void bt_test_ble_write(char *data)
{
	rk_ble_send_notify(BLE_UUID_SEND, data, strlen(data));
}

void bt_test_ble_get_status(char *data)
{

}

void bt_test_ble_stop(char *data) {
	rk_ble_adv_stop();
}

/******************************************/
/*               BLE CLIENT               */
/******************************************/
void bt_test_ble_client_get_service_info(char *data)
{
	int i, j, k;
	RK_BLE_CLIENT_SERVICE_INFO info;

	if (!rk_ble_client_get_service_info(data, &info)) {
		printf("+++++ get device(%s) service info +++++\n", data);
		for(i = 0; i < info.service_cnt; i++) {
			printf("service[%d]:\n", i);
			printf("	describe: %s\n", info.service[i].describe);
			printf("	path: %s\n", info.service[i].path);
			printf("	uuid: %s\n", info.service[i].uuid);

			for(j = 0; j < info.service[i].chrc_cnt; j++) {
				printf("	characteristic[%d]:\n", j);
				printf("		describe: %s\n", info.service[i].chrc[j].describe);
				printf("		path: %s\n", info.service[i].chrc[j].path);
				printf("		uuid: %s\n", info.service[i].chrc[j].uuid);
				printf("		props: 0x%x\n", info.service[i].chrc[j].props);
				printf("		ext_props: 0x%x\n", info.service[i].chrc[j].ext_props);
				printf("		perm: 0x%x\n", info.service[i].chrc[j].perm);
				printf("		notifying: %d\n", info.service[i].chrc[j].notifying);

				for(k = 0; k < info.service[i].chrc[j].desc_cnt; k++) {
					printf("		descriptor[%d]:\n", k);

					printf("			describe: %s\n", info.service[i].chrc[j].desc[k].describe);
					printf("			path: %s\n", info.service[i].chrc[j].desc[k].path);
					printf("			uuid: %s\n", info.service[i].chrc[j].desc[k].uuid);
				}
			}
		}
	}
}

void bt_test_ble_client_read(char *data)
{
	rk_ble_client_read(data);
}

void bt_test_ble_client_write(char *data)
{
	int i = 0, write_len = BT_ATT_DEFAULT_LE_MTU;
	char *write_buf;

	write_len -= BT_ATT_HEADER_LEN;
	if(write_len > BT_ATT_MAX_VALUE_LEN)
		write_len = BT_ATT_MAX_VALUE_LEN;

	write_buf = (char *)malloc(write_len);
	for (i = 0; i < (write_len - 1); i++)
		write_buf[i] = '0' + i % 10;
	write_buf[write_len - 1] = '\0';

	rk_ble_client_write(data, write_buf, strlen(write_buf));
	free(write_buf);
}

void bt_test_ble_client_is_notify(char *data)
{
	bool notifying;

	notifying = rk_ble_client_is_notifying(data);
	printf("%s notifying %s\n", data, notifying ? "yes" : "no");
}

void bt_test_ble_client_notify_on(char *data)
{
	rk_ble_client_notify(data, true);
}

void bt_test_ble_client_notify_off(char *data)
{
	rk_ble_client_notify(data, false);
}

/******************************************/
/*                  SPP                   */
/******************************************/
void _btspp_status_callback(RK_BT_SPP_STATE type)
{
	switch(type) {
	case RK_BT_SPP_STATE_IDLE:
		printf("+++++++ RK_BT_SPP_STATE_IDLE +++++\n");
		break;
	case RK_BT_SPP_STATE_CONNECT:
		printf("+++++++ RK_BT_SPP_EVENT_CONNECT +++++\n");
		break;
	case RK_BT_SPP_STATE_DISCONNECT:
		printf("+++++++ RK_BT_SPP_EVENT_DISCONNECT +++++\n");
		break;
	default:
		printf("+++++++ BT SPP NOT SUPPORT TYPE! +++++\n");
		break;
	}
}

void _btspp_recv_callback(char *data, int len)
{
	if (len) {
		printf("+++++++ RK BT SPP RECV DATA: +++++\n");
		printf("\tRECVED(%d):%s\n", len, data);
	}
}

void bt_test_spp_open(char *data)
{
	rk_bt_spp_open(data);
	rk_bt_spp_register_status_cb(_btspp_status_callback);
	rk_bt_spp_register_recv_cb(_btspp_recv_callback);
}

void bt_test_spp_write(char *data)
{
	unsigned int ret = 0;
	//char buff[100] = {"This is a message from rockchip board!"};

	ret = rk_bt_spp_write(data, strlen(data));
	if (ret < 0) {
		printf("%s failed\n", __func__);
	}
}

void bt_test_spp_connect(char *data)
{
	rk_bt_spp_connect(data);
}

void bt_test_spp_disconnect(char *data)
{
	rk_bt_spp_disconnect(data);
}

void bt_test_spp_listen(char *data)
{
	rk_bt_spp_listen();
}

void bt_test_spp_close(char *data)
{
	rk_bt_spp_close();
}

void bt_test_spp_status(char *data)
{
	RK_BT_SPP_STATE status;

	rk_bt_spp_get_state(&status);
	switch(status) {
	case RK_BT_SPP_STATE_IDLE:
		printf("+++++++ RK_BT_SPP_STATE_IDLE +++++\n");
		break;
	case RK_BT_SPP_STATE_CONNECT:
		printf("+++++++ RK_BT_SPP_STATE_CONNECT +++++\n");
		break;
	case RK_BT_SPP_STATE_DISCONNECT:
		printf("+++++++ RK_BT_SPP_STATE_DISCONNECT +++++\n");
		break;
	default:
		printf("+++++++ BTSPP NO STATUS SUPPORT! +++++\n");
		break;
	}
}

/**
 * VENDOR CODE
 */
static int write_flush_timeout(int fd, uint16_t handle,
		unsigned int timeout_ms)
{
	uint16_t timeout = (timeout_ms * 1000) / 625;  // timeout units of 0.625ms
	unsigned char hci_write_flush_cmd[] = {
		0x01,               // HCI command packet
		0x28, 0x0C,         // HCI_Write_Automatic_Flush_Timeout
		0x04,               // Length
		0x00, 0x00,         // Handle
		0x00, 0x00,         // Timeout
	};

	hci_write_flush_cmd[4] = (uint8_t)handle;
	hci_write_flush_cmd[5] = (uint8_t)(handle >> 8);
	hci_write_flush_cmd[6] = (uint8_t)timeout;
	hci_write_flush_cmd[7] = (uint8_t)(timeout >> 8);

	int ret = write(fd, hci_write_flush_cmd, sizeof(hci_write_flush_cmd));
	if (ret < 0) {
		printf("write(): %s (%d)]", strerror(errno), errno);
		return -1;
	} else if (ret != sizeof(hci_write_flush_cmd)) {
		printf("write(): unexpected length %d", ret);
		return -1;
	}
	return 0;
}

static int vendor_high_priority(int fd, uint16_t handle,uint8_t priority, uint8_t direction)
{
	unsigned char hci_high_priority_cmd[] = {
		0x01,               // HCI command packet
		0x1a, 0xfd,         // Write_A2DP_Connection
		0x04,               // Length
		0x00, 0x00,         // Handle
		0x00, 0x00          // Priority, Direction 
	};

	hci_high_priority_cmd[4] = (uint8_t)handle;
	hci_high_priority_cmd[5] = (uint8_t)(handle >> 8);
	hci_high_priority_cmd[6] = (uint8_t)priority;
	hci_high_priority_cmd[7] = (uint8_t)direction; 

	int ret = write(fd, hci_high_priority_cmd, sizeof(hci_high_priority_cmd));
	if (ret < 0) {
		printf("write(): %s (%d)]", strerror(errno), errno);
		return -1;
	} else if (ret != sizeof(hci_high_priority_cmd)) {
		printf("write(): unexpected length %d", ret);
		return -1;
	}
	return 0;
}


static int get_hci_sock(void)
{
	int sock = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
	struct sockaddr_hci addr;
	int opt;

	if (sock < 0) {
		printf("Can't create raw HCI socket!");
		return -1;
	}

	opt = 1;
	if (setsockopt(sock, SOL_HCI, HCI_DATA_DIR, &opt, sizeof(opt)) < 0) {
		printf("Error setting data direction\n");
		return -1;
	}

	/* Bind socket to the HCI device */
	memset(&addr, 0, sizeof(addr));
	addr.hci_family = AF_BLUETOOTH;
	addr.hci_dev = 0;  // hci0
	if (bind(sock, (struct sockaddr *) &addr, sizeof(addr)) < 0) {
		printf("Can't attach to device hci0. %s(%d)\n",
				strerror(errno),
				errno);
		return -1;
	}
	return sock;
}


static int get_acl_handle(int fd, char *bdaddr) {
	int i;
	int ret = -1;
	struct hci_conn_list_req *conn_list;
	struct hci_conn_info *conn_info;
	int max_conn = 10;
	char addr[18];

	conn_list = malloc(max_conn * (
		sizeof(struct hci_conn_list_req) + sizeof(struct hci_conn_info)));
	if (!conn_list) {
		printf("Out of memory in %s\n", __FUNCTION__);
		return -1;
	}

	conn_list->dev_id = 0;  /* hardcoded to HCI device 0 */
	conn_list->conn_num = max_conn;

	if (ioctl(fd, HCIGETCONNLIST, (void *)conn_list)) {
		printf("Failed to get connection list\n");
		goto out;
	}
	printf("XXX %d\n", conn_list->conn_num);

	for (i=0; i < conn_list->conn_num; i++) {
		conn_info = &conn_list->conn_info[i];
		memset(addr, 0, 18);
		sprintf(addr, "%02x:%02x:%02x:%02x:%02x:%02x",
				conn_info->bdaddr.b[5],
				conn_info->bdaddr.b[4],
				conn_info->bdaddr.b[3],
				conn_info->bdaddr.b[2],
				conn_info->bdaddr.b[1],
				conn_info->bdaddr.b[0]);
		printf("XXX %d %s:%s\n", conn_info->type, bdaddr, addr);
		if (conn_info->type == ACL_LINK &&
				!strcasecmp(addr, bdaddr)) {
			ret = conn_info->handle;
			goto out;
		}
	}

	ret = 0;

out:
	free(conn_list);
	return ret;
}


/* Request that the ACL link to a given Bluetooth connection be high priority,
 * for improved coexistance support
 */
int vendor_set_high_priority(char *ba, uint8_t priority, uint8_t direction)
{
	int ret;
	int fd = get_hci_sock();
	int acl_handle;

	if (fd < 0)
		return fd;

	acl_handle = get_acl_handle(fd, ba);
	if (acl_handle <= 0) {
		ret = acl_handle;
		goto out;
	}

	ret = vendor_high_priority(fd, acl_handle, priority, direction);
	if (ret < 0)
		goto out;
	ret = write_flush_timeout(fd, acl_handle, 200);

out:
	close(fd);

	return ret;
}
