#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <pthread.h>
#include <sys/prctl.h>
#include <sys/time.h>
#include <stdbool.h>
#include <stdlib.h>

#include "Rk_wifi.h"
#include "Rk_softap.h"

struct wifi_info {
	int ssid_len;
	char ssid[512];
	int psk_len;
	char psk[512];
};

#if 0
static void printf_system_time()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);

	printf("--- time: %ld ms ---\n", tv.tv_sec * 1000 + tv.tv_usec/1000 + tv.tv_usec%1000);
}
#endif

static void printf_connect_info(RK_WIFI_INFO_Connection_s *info)
{
	if(!info)
		return;

	printf("	id: %d\n", info->id);
	printf("	bssid: %s\n", info->bssid);
	printf("	ssid: %s\n", info->ssid);
	printf("	freq: %d\n", info->freq);
	printf("	mode: %s\n", info->mode);
	printf("	wpa_state: %s\n", info->wpa_state);
	printf("	ip_address: %s\n", info->ip_address);
	printf("	mac_address: %s\n", info->mac_address);
}

/*****************************************************************
 *                     wifi config                               *
 *****************************************************************/
static volatile bool rkwifi_gonff = false;
static RK_WIFI_RUNNING_State_e wifi_state = 0;
static int rk_wifi_state_callback(RK_WIFI_RUNNING_State_e state, RK_WIFI_INFO_Connection_s *info)
{
	printf("%s state: %d\n", __func__, state);
	printf_connect_info(info);

	wifi_state = state;
	if (state == RK_WIFI_State_CONNECTED) {
		printf("RK_WIFI_State_CONNECTED\n");
	} else if (state == RK_WIFI_State_CONNECTFAILED) {
		printf("RK_WIFI_State_CONNECTFAILED\n");
	} else if (state == RK_WIFI_State_CONNECTFAILED_WRONG_KEY) {
		printf("RK_WIFI_State_CONNECTFAILED_WRONG_KEY\n");
	} else if (state == RK_WIFI_State_OPEN) {
		rkwifi_gonff = true;
		printf("RK_WIFI_State_OPEN\n");
	} else if (state == RK_WIFI_State_OFF) {
		rkwifi_gonff = false;
		printf("RK_WIFI_State_OFF\n");
	} else if (state == RK_WIFI_State_DISCONNECTED) {
		printf("RK_WIFI_State_DISCONNECTED\n");
	} else if (state == RK_WIFI_State_SCAN_RESULTS) {
		char *scan_r;
		printf("RK_WIFI_State_SCAN_RESULTS\n");
		scan_r = RK_wifi_scan_r();
		//printf("%s\n", scan_r);
		free(scan_r);
	}

	return 0;
}

/*****************************************************************
 *                     softap wifi config test                   *
 *****************************************************************/
static int rk_wifi_softap_state_callback(RK_SOFTAP_STATE state, const char* data)
{
	switch (state) {
	case RK_SOFTAP_STATE_CONNECTTING:
		printf("RK_SOFTAP_STATE_CONNECTTING\n");
		break;
	case RK_SOFTAP_STATE_DISCONNECT:
		printf("RK_SOFTAP_STATE_DISCONNECT\n");
		break;
	case RK_SOFTAP_STATE_FAIL:
		printf("RK_SOFTAP_STATE_FAIL\n");
		break;
	case RK_SOFTAP_STATE_SUCCESS:
		printf("RK_SOFTAP_STATE_SUCCESS\n");
		break;
	default:
		break;
	}

	return 0;
}

void rk_wifi_softap_start(char *data)
{
	printf("%s enter\n", __func__);
	RK_softap_register_callback(rk_wifi_softap_state_callback);
	if (0 != RK_softap_start("Rockchip-SoftAp", RK_SOFTAP_TCP_SERVER)) {
		return;
	}
}

void rk_wifi_softap_stop(char *data)
{
	RK_softap_stop();
}

void _rk_wifi_open(void *data)
{
	RK_wifi_register_callback(rk_wifi_state_callback);

	if (RK_wifi_enable(1, "/data/wpa_supplicant.conf") < 0)
		printf("RK_wifi_enable 1 fail!\n");
}

void rk_wifi_close(char *data)
{
	if (RK_wifi_enable(0, NULL) < 0)
		printf("RK_wifi_enable 0 fail!\n");
}

void rk_wifi_openoff_test(char *data)
{
	int test_cnt = 5000, cnt = 0;

	if (data)
		test_cnt = atoi(data);
	printf("%s test times: %d(%d)\n", __func__, test_cnt, data ? atoi(data) : 0);

	while (cnt < test_cnt) {
		//open
		RK_wifi_register_callback(rk_wifi_state_callback);
		if (RK_wifi_enable(1, "/data/wpa_supplicant.conf") < 0)
			printf("RK_wifi_enable 1 fail!\n");

		while (rkwifi_gonff == false) {
			sleep(1);
			printf("%s: TURNING ON ...\n", __func__);
		}

		//scan
		RK_wifi_scan();
		sleep(1);

		//close
		if (RK_wifi_enable(0, NULL) < 0)
			printf("RK_wifi_enable 0 fail!\n");

		while (rkwifi_gonff == true) {
			sleep(1);
			printf("%s: TURNING OFF ...\n", __func__);
		}
		printf("%s: CNT: [======%d======] \n", __func__, ++cnt);
	}
}

void rk_wifi_open(char *data)
{
	printf("%s: ", __func__);

	RK_wifi_register_callback(rk_wifi_state_callback);
	if (RK_wifi_enable(1, "/data/wpa_supplicant.conf") < 0)
		printf("RK_wifi_enable 1 fail!\n");
}

void rk_wifi_version(char *data)
{
	printf("rk wifi version: %s\n", RK_wifi_version());
}

//9 input fish1:rk12345678
void rk_wifi_connect(char *data)
{
	char *ssid = NULL, *psk = NULL;

	if (data == NULL) {
		printf("%s: invalid input\n", __func__);
		return;
	}

	ssid = strtok(data, ":");
	if(ssid)
		psk = strtok(NULL, ":");

	//RK_wifi_set_bssid("04:42:1a:b4:e7:78");
	if (RK_wifi_connect(ssid, psk) < 0)
		printf("RK_wifi_connect1 fail!\n");
}

void rk_wifi_scan(char *data)
{
	if (RK_wifi_scan() < 0)
		printf("RK_wifi_scan fail!\n");
}

void rk_wifi_getSavedInfo(char *data)
{
	RK_WIFI_SAVED_INFO_s *wsi;
	int ap_cnt = 0;

	RK_wifi_getSavedInfo(&wsi, &ap_cnt);
	if (ap_cnt <= 0) {
		printf("not found saved ap!\n");
		return;
	}

	for (int i = 0; i < ap_cnt; i++) {
		printf("id: %d, name: %s, bssid: %s, state: %s\n",
					wsi[i].id,
					wsi[i].ssid,
					wsi[i].bssid,
					wsi[i].state);
	}

	if (wsi != NULL)
		free(wsi);
}

void rk_wifi_getConnectionInfo(char *data)
{
	RK_WIFI_INFO_Connection_s info;

	if(!RK_wifi_running_getConnectionInfo(&info))
		printf_connect_info(&info);
}

void rk_wifi_connect_with_ssid(char *data)
{
	if(data == NULL) {
		printf("%s: ssid is null\n", __func__);
		return;
	}

	if (RK_wifi_connect_with_ssid(data) < 0)
		printf("RK_wifi_connect_with_ssid fail!\n");
}

void rk_wifi_cancel(void *data)
{
	if (RK_wifi_cancel() < 0)
		printf("RK_wifi_cancel fail!\n");
}

void rk_wifi_forget_with_ssid(char *data)
{
	if(data == NULL) {
		printf("%s: ssid is null\n", __func__);
		return;
	}

	if (RK_wifi_forget_with_ssid(data) < 0) {
		printf("rk_wifi_forget_with_ssid fail!\n");
	}
}

void rk_wifi_disconnect(char *data)
{
	RK_wifi_disconnect_network();
}
