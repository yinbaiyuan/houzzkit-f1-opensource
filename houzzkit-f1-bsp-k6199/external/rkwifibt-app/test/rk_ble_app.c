#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <linux/prctl.h>
#include <sys/signalfd.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <sys/prctl.h>
#include <pthread.h>

#include <Rk_wifi.h>
#include "rk_ble_app.h"
#include "utility.h"

/* Immediate wifi Service UUID */
#define AD_SERVICE_UUID16	"2222"
#define BLE_UUID_SERVICE	"00008888-0000-1000-8000-00805F9B34FB"
#define BLE_UUID_WIFI_CHAR	"00009999-0000-1000-8000-00805F9B34FB"
#define BLE_UUID_PROXIMITY	"7B931104-1810-4CBC-94DA-875C8067F845"

#define UUID_MAX_LEN 36

typedef enum {
	RK_BLE_WIFI_State_IDLE = 0,
	RK_BLE_WIFI_State_CONNECTTING,
	RK_BLE_WIFI_State_SUCCESS,
	RK_BLE_WIFI_State_FAIL,
	RK_BLE_WIFI_State_WRONGKEY_FAIL,
	RK_BLE_WIFI_State_DISCONNECT
} RK_BLE_WIFI_State_e;

const char *MSG_BLE_WIFI_LIST_FORMAT = "{\"cmd\":\"wifilists\", \"ret\":%s}";

static char rk_wifi_list_buf[20 * 1024];
static int scanr_len = 0, scanr_len_use = 0;

static pthread_t wificonfig_tid = 0;
static pthread_t wificonfig_scan_tid = 0;

static char wifi_ssid[256];
static char wifi_password[256];

//static unsigned int ble_mtu = 0;
static RkBtContent bt_content;

typedef int (*RK_blewifi_state_callback)(RK_BLE_WIFI_State_e state);

#define RK_BLE_DATA_CMD_LEN      12
#define RK_BLE_DATA_SSID_LEN     32
#define RK_BLE_DATA_PSK_LEN      32

/* 消息开头必须为0x01，结尾必须为0x04 */
typedef struct {
	unsigned char start;               // 段， 01Byte， 固定为 0x01
	char cmd[RK_BLE_DATA_CMD_LEN];     // 段， 12Byte， 值为："wifisetup"、"wifilists"
	char ssid[RK_BLE_DATA_SSID_LEN];   // 段， 32Byte， 需要连接的 WiFi ssid， 长度不足 32 的部分填充 0
	char psk[RK_BLE_DATA_PSK_LEN];     // 段， 32Byte， 需要连接的 wifi password， 长度不足 32 的部分填充 0
	//unsigned char end;               // 段， 01Byte， 固定位 0x04
} RockChipBleData;

static bool confirm_done = 0;

static int rk_blewifi_state_callback(RK_WIFI_RUNNING_State_e state, RK_WIFI_INFO_Connection_s *info)
{
	printf("[RK] %s state: %d\n", __func__, state);
	switch(state) {
	case RK_WIFI_State_CONNECTED:
		rk_ble_send_notify(BLE_UUID_WIFI_CHAR, "wifi ok", 7);
		break;
	case RK_WIFI_State_CONNECTFAILED:
	case RK_WIFI_State_CONNECTFAILED_WRONG_KEY:
		rk_ble_send_notify(BLE_UUID_WIFI_CHAR, "wifi fail", 9);
		break;
	default:
		break;
	}

	return 0;
}

void *rk_config_wifi_thread(void *arg)
{
	printf("[RK] rk_config_wifi_thread\n");

	prctl(PR_SET_NAME,"rk_config_wifi_thread");

	RK_wifi_connect(wifi_ssid, wifi_password);

	return NULL;
}

void *rk_ble_send_data(void *arg)
{
	int len, send_max_len = 120;
	char *data;
	char *wifilist;

	prctl(PR_SET_NAME,"rk_ble_send_data");

scan_retry:
	printf("[RK] RK_wifi_scan ...\n");
	RK_wifi_scan();
	usleep(800000);

	//get scan list
	wifilist = RK_wifi_scan_r();

	//scan list is null
	if (wifilist == NULL)
		goto scan_retry;

	//scan list too few
	if (wifilist && (strlen(wifilist) < 3)) {
		free(wifilist);
		goto scan_retry;
	}

	//copy to static buff
	memset(rk_wifi_list_buf, 0, sizeof(rk_wifi_list_buf));
	snprintf(rk_wifi_list_buf, sizeof(rk_wifi_list_buf), MSG_BLE_WIFI_LIST_FORMAT, wifilist);
	scanr_len = strlen(rk_wifi_list_buf);
	scanr_len_use = 0;
	printf("[RK] wifi scan_r: %s, len: %d\n", rk_wifi_list_buf, scanr_len);

	//free
	free(wifilist);

	//max att mtu
	send_max_len = bt_content.ble_content.att_mtu;

	while (scanr_len) {
		printf("[RK] %s: wifi use: %d, remain len: %d\n", __func__, scanr_len_use, scanr_len);
		len = (scanr_len > send_max_len) ? send_max_len : scanr_len;
		data = rk_wifi_list_buf + scanr_len_use;

		//send data
		confirm_done = false;
		rk_ble_send_notify(BLE_UUID_WIFI_CHAR, data, len);

		//waiting write resp
		while (!confirm_done) {
			usleep(10 * 1000);
		}
		printf("[RK] received confirm\n");

		//resize
		scanr_len -= len;
		scanr_len_use += len;
	}

	return NULL;
}

static void ble_wifi_recv_data_cb(const char *uuid, char *data, int *len)
{
	if (!strcmp(uuid, BLE_UUID_WIFI_CHAR)) {
		if (strncmp(data, "wifi_scan", 9) == 0) {
			pthread_create(&wificonfig_scan_tid, NULL, rk_ble_send_data, NULL);
		} else if (strncmp(data, "wifi_setup", 10) == 0) {
			char cmd[12];
			memset(cmd, 0, 12);
			memset(wifi_ssid, 0, 256);
			memset(wifi_password, 0, 256);
			sscanf(data, "%s %s %s", cmd, wifi_ssid, wifi_password);
			printf("cmd: %s, ssid: %s, psk: %s\n", cmd, wifi_ssid, wifi_password);
			pthread_create(&wificonfig_tid, NULL, rk_config_wifi_thread, NULL);
		}
	}
}

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
		//wifi config handle
		ble_wifi_recv_data_cb(uuid, data, len);
		break;
	case RK_BLE_GATT_SERVER_ENABLE_NOTIFY_BY_REMOTE:
	case RK_BLE_GATT_SERVER_DISABLE_NOTIFY_BY_REMOTE:
		//The remote dev enable notify for characteristic
		printf("+++ ble server notify is %s by remote uuid: %s\n",
				(state == RK_BLE_GATT_SERVER_ENABLE_NOTIFY_BY_REMOTE) ? "enable" : "disabled", uuid);
		break;
	case RK_BLE_GATT_MTU:
		bt_content.ble_content.att_mtu = *(uint16_t *)data;
		printf("+++ ble server MTU: %d ===\n", *(uint16_t *)data);
		break;
	case RK_BLE_GATT_SERVER_INDICATE_RESP_BY_REMOTE:
		//The service sends notify to remote dev and recv indicate from remote dev.
		printf("+++ ble server receive remote indicate resp uuid: %s\n", uuid);

		//set confirm flag
		confirm_done = true;
		break;
	default:
		break;
	}
}

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

	//LINK STATE
	case RK_BT_STATE_CONNECTED:
	case RK_BT_STATE_DISCONN:
		printf("+ %s [%s|%d]:%s:%s\n", rdev->connected ? "STATE_CONNECT" : "STATE_DISCONN",
				rdev->remote_address,
				rdev->rssi,
				rdev->remote_address_type,
				rdev->remote_alias);
		break;

	//ADV
	case RK_BT_STATE_ADAPTER_BLE_ADV_START:
		printf("RK_BT_STATE_ADAPTER_BLE_ADV_START successful\n");
		break;
	case RK_BT_STATE_ADAPTER_BLE_ADV_STOP:
		printf("RK_BT_STATE_ADAPTER_BLE_ADV_STOP successful\n");
		break;

	//ADAPTER STATE
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
	case RK_BT_STATE_SCAN_CHG_REMOTE_DEV:
		printf("+ %s: [%s|%d]:%s:%s|%s\n", rdev->connected ? "CONN_CHG_DEV" : "SCAN_CHG_DEV",
				rdev->remote_address, rdev->rssi,
				rdev->remote_address_type, 
				rdev->remote_alias, rdev->change_name);

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

static bool ble_test_vendor_cb(bool enable)
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

void rk_ble_wifi_init(char *data)
{
	RkBleGattService *gs;
	static char *chr_props[] = { "read", "write", "indicate", "write-without-response", NULL };

	printf(" %s \n", __func__);

	memset(&bt_content, 0, sizeof(RkBtContent));

	//BREDR CLASS BT NAME
	bt_content.bt_name = "Rockchip_bt";

	//BLE NAME
	bt_content.ble_content.ble_name = "RBLE";

	//IO CAPABILITY
	bt_content.io_capability = IO_CAPABILITY_DISPLAYYESNO;

	//enable ble
	bt_content.profile = PROFILE_BLE;
	if (bt_content.profile & PROFILE_BLE) {
		/* GATT SERVICE/CHARACTERISTIC */
		//SERVICE_UUID
		gs = &(bt_content.ble_content.gatt_instance[0]);
		gs->server_uuid.uuid = BLE_UUID_SERVICE;
		gs->chr_uuid[0].uuid = BLE_UUID_WIFI_CHAR;
		gs->chr_uuid[0].chr_props = chr_props;
		gs->chr_cnt = 1;

		bt_content.ble_content.srv_cnt = 1;

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
	rk_bt_register_vendor_callback(ble_test_vendor_cb);

	//default state
	bt_content.init = false;

	rk_bt_init(&bt_content);

	//wait init ok
	while (!bt_content.init)
		sleep(1);

	//rk_bt_set_power(1);

	//enable adv
	printf("Start BLE ADV ....\n");
	rk_ble_adv_start();

	//enble wifi
	RK_wifi_register_callback(rk_blewifi_state_callback);
	RK_wifi_enable(1, "/data/wpa_supplicant.conf");

	printf(" %s end \n", __func__);
	return;
}

void rk_ble_wifi_deinit(char *data)
{
	printf(" %s \n", __func__);

	//disable wifi
	RK_wifi_enable(0, NULL);

	//disable adv
	rk_ble_adv_stop();

	//sleep(1);
	//deinit bt
	rk_bt_deinit();

	//wait deinit end
	while (bt_content.init)
		sleep(1);

	printf(" %s end\n", __func__);
}

void rk_ble_wifi_init_onoff_test(char *data)
{
	int test_cnt = 5000, cnt = 0;

	if (data)
		test_cnt = atoi(data);
	printf("%s test times: %d(%d)\n", __func__, test_cnt, data ? atoi(data) : 0);

	while (cnt < test_cnt) {
		rk_ble_wifi_init(NULL);
		rk_ble_wifi_deinit(NULL);
		printf("BLE WiFi ON/OFF LOOPTEST CNT: [====== %d ======]\n", ++cnt);
	}
}

