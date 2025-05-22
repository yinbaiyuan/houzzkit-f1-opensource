#ifndef __RK_WIFI_H__
#define __RK_WIFI_H__

#ifdef __cplusplus
extern "C" {
#endif

#define RK_WIFI_VERSION "V1.1"

#define RK_WIFI_SAVED_INFO_MAX 10
#define SSID_MAX_LEN 32
#define BSSID_BUF_LEN 20
#define STATE_BUF_LEN 20

#define SSID_BUF_LEN SSID_MAX_LEN * 4 + 1

typedef enum {
	RK_WIFI_State_IDLE = 0,
	RK_WIFI_State_CONNECTING,
	RK_WIFI_State_CONNECTFAILED,
	RK_WIFI_State_CONNECTFAILED_WRONG_KEY,
	RK_WIFI_State_CONNECTED,
	RK_WIFI_State_DISCONNECTED,
	RK_WIFI_State_OPEN,
	RK_WIFI_State_OFF,
	RK_WIFI_State_SCAN_RESULTS,
	RK_WIFI_State_DHCP_OK,
} RK_WIFI_RUNNING_State_e;

typedef enum {
	NONE = 0,
	WPA,
	WEP,
	WPA3
} RK_WIFI_CONNECTION_Encryp_e;

typedef struct {
	int id;
	char bssid[BSSID_BUF_LEN];
	char ssid[SSID_MAX_LEN * 4 + 1];
	int freq;
	char mode[20];
	char wpa_state[20];
	char ip_address[20];
	char mac_address[20];
	int reason;
} RK_WIFI_INFO_Connection_s;

typedef struct {
	int id;
	char bssid[BSSID_BUF_LEN];
	char ssid[SSID_MAX_LEN * 4 + 1];
	char state[STATE_BUF_LEN];
} RK_WIFI_SAVED_INFO_s;

/**
 * @brief  callback function definition of wifi event.
 */
typedef int(*RK_wifi_state_callback)(RK_WIFI_RUNNING_State_e state, RK_WIFI_INFO_Connection_s *info);

/**
 * @brief  register user callback interface.
 */
int RK_wifi_register_callback(RK_wifi_state_callback cb);

/**
 * @brief  register user callback interface.
 */
int RK_wifi_running_getConnectionInfo(RK_WIFI_INFO_Connection_s* pInfo);

/**
 * @brief  Open wifi
 */
int RK_wifi_enable(int enable, const char *conf_dir);

/**
 * @brief  Start sta basic scanning in all channels
 */
int RK_wifi_scan(void);

/**
 * @brief  Get station scan result.
 */
char *RK_wifi_scan_r(void);

/**
 * @brief  sta start connect with WPA2 OR OPEN
 * @attention 
    This function is non-blocking\n
    If the station is already connected to a network, disconnect the existing connection and then connect to the new network. \n
    If the wrong SSID or key is passed in, the -1 will be returned, but sta cannot connect the ap.\n
    SSID only supports ASCII characters.
    When SSID is OPEN, the <psk> parameter is not required.
 */
int RK_wifi_connect(char* ssid, const char* psk);

/**
 * @brief  sta start connect with WEP
 * @attention 
    This function is non-blocking\n
    If the station is already connected to a network, disconnect the existing connection and then connect to the new network. \n
    If the wrong SSID or key is passed in, the -1 will be returned, but sta cannot connect the ap.\n
    SSID only supports ASCII characters.
    WEP supports 64 bit and 128 bit encryption. for 64 bit encryption, the encryption key is 10 hexadecimal characters or 5 ASCII characters; for 128 bit encryption, the encryption key is 26 hexadecimal characters or 13 ASCII characters。
 */
int RK_wifi_connect_wep(char* ssid, const char* psk);

/**
 * @brief  sta start connect with WPA3(SAE)
 * @attention 
    This function is non-blocking\n
    If the station is already connected to a network, disconnect the existing connection and then connect to the new network. \n
    If the wrong SSID or key is passed in, the -1 will be returned, but sta cannot connect the ap.\n
    SSID only supports ASCII characters.
 */
int RK_wifi_connect_wpa3(char* ssid, const char* psk);

/**
 * @brief  Start sta basic scanning in all channels
 */
int RK_wifi_disconnect_network(void);

/**
 * @brief  Get original macaddr of wlan0
 */
int RK_wifi_get_mac(char *wifi_mac);

/**
 * @brief  Start sta basic scanning in all channels
 */
int RK_wifi_forget_with_ssid(char *ssid);

/**
 * @brief  Get status of sta
 */
int RK_wifi_running_getState(RK_WIFI_RUNNING_State_e* pState);

/**
 * @brief  Start all sta saved info.
 */
int RK_wifi_getSavedInfo(RK_WIFI_SAVED_INFO_s **pInfo, int *ap_cnt);

/**
 * @brief  Start sta connect with saved ssid previously
 */
int RK_wifi_connect_with_ssid(char* ssid);

/**
 * @brief  Cancel the current "Connecting" but not connected state.
 */
int RK_wifi_cancel(void);

/**
 * @brief  Remove all sta info
 */
int RK_wifi_reset(void);

/**
 * @brief  scan for softap config "ONLY"
 */
char *RK_wifi_scan_for_softap(void);

/**
 * @brief  Get wifi so version
 */
char *RK_wifi_version(void);

/**
 * @brief  Set bssid
 */
void RK_wifi_set_bssid(char *bssid);

#ifdef __cplusplus
}
#endif

#endif
