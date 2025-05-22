#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "bt.h"
#include "Rk_wifi.h"
#include "wifibt.h"

#define wifibt_log(fmt, ...)    printf("[WIFIBT] "fmt, ##__VA_ARGS__)

static int fd[2];
static sem_t sem;
static int wifi_result = 0;
static volatile bool rkwifi_gonff = false;
static RK_WIFI_RUNNING_State_e wifi_state = 0;

int wifi_scanning_done(void)
{
    if (wifi_result)
    {
        wifi_result = 0;
        return 1;
    }

    return 0;
}

int wifi_connected(void)
{
    return wifi_state == RK_WIFI_State_CONNECTED ||
           wifi_state == RK_WIFI_State_DHCP_OK;
}

static void printf_connect_info(RK_WIFI_INFO_Connection_s *info)
{
    if (!info)
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

static int rk_wifi_state_callback(RK_WIFI_RUNNING_State_e state, RK_WIFI_INFO_Connection_s *info)
{
    printf("%s state: %d\n", __func__, state);

    if (state != RK_WIFI_State_SCAN_RESULTS)
        wifi_state = state;

    switch (state)
    {
    case RK_WIFI_State_IDLE:
        break;
    case RK_WIFI_State_CONNECTING:
        break;
    case RK_WIFI_State_CONNECTFAILED:
        printf("RK_WIFI_State_CONNECTFAILED\n");
        break;
    case RK_WIFI_State_CONNECTFAILED_WRONG_KEY:
        printf("RK_WIFI_State_CONNECTFAILED_WRONG_KEY\n");
        break;
    case RK_WIFI_State_CONNECTED:
        printf("RK_WIFI_State_CONNECTED\n");
        //printf_connect_info(info);
        //RK_wifi_get_connected_ap_rssi();
        break;
    case RK_WIFI_State_DISCONNECTED:
        printf("RK_WIFI_State_DISCONNECTED\n");
        break;
    case RK_WIFI_State_OPEN:
        rkwifi_gonff = true;
        printf("RK_WIFI_State_OPEN\n");
        break;
    case RK_WIFI_State_OFF:
        rkwifi_gonff = false;
        printf("RK_WIFI_State_OFF\n");
        break;
    case RK_WIFI_State_SCAN_RESULTS:
        printf("RK_WIFI_State_SCAN_RESULTS\n");
        wifi_result = 1;
        break;
    case RK_WIFI_State_DHCP_OK:
        printf("RK_WIFI_State_DHCP_OK\n");
        break;
    }

    return 0;
}

int wifibt_send_wait(void *buf, int len)
{
    struct wifibt_cmdarg *cmdarg = (struct wifibt_cmdarg *)buf;

    cmdarg->wait = true;
    int ret = write(fd[1], buf, len);
    if (ret <= 0)
        return ret;
    sem_wait(&sem);

    return ret;
}

int wifibt_send(void *buf, int len)
{
    struct wifibt_cmdarg *cmdarg = (struct wifibt_cmdarg *)buf;

    cmdarg->wait = false;

    return write(fd[1], buf, len);
}

static void *wifibt_server(void *arg)
{
    struct wifibt_cmdarg *cmdarg;
    intptr_t intval;
    char buf[1024];
    char **key;
    int len;

    while (access("/tmp/.lv_warmup", F_OK) == 0)
    {
        sleep(1);
    }

    if (RK_wifi_enable(1) < 0)
        wifibt_log("RK_wifi_enable 1 fail!\n");

    RK_wifi_register_callback(rk_wifi_state_callback);

    bt_ble_init();

    while (1)
    {
        int num = read(fd[0], buf, sizeof(buf));
        cmdarg = (struct wifibt_cmdarg *)buf;
        switch (cmdarg->cmd)
        {
        case WIFI_ENABLE:
            wifibt_log("WIFI_ENABLE\n");
            RK_wifi_enable(1);
            break;
        case WIFI_DISABLE:
            wifibt_log("WIFI_DISABLE\n");
            RK_wifi_enable(0);
            break;
        case WIFI_SCAN:
            wifibt_log("WIFI_SCAN\n");
            RK_wifi_scan();
            break;
        case WIFI_CONNECT:
            wifibt_log("WIFI_CONNECT\n");
            key = cmdarg->val;
            RK_wifi_connect(key[0], key[1]);
            break;
        case WIFI_DISCONNECT:
            wifibt_log("WIFI_DISCONNECT\n");
            RK_wifi_disconnect_network();
            break;
        case BT_ENABLE:
            wifibt_log("BT_ENABLE\n");
            bt_ble_init();
            break;
        case BT_DISABLE:
            wifibt_log("BT_DISABLE\n");
            bt_ble_deinit();
            break;
        case BT_SINK_ENABLE:
            wifibt_log("BT_SINK_ENABLE\n");
            bt_sink_enable();
            break;
        case BT_SINK_DISABLE:
            wifibt_log("BT_SINK_DISABLE\n");
            rk_bt_sink_pause();
            rk_bt_sink_disconnect();
            bt_sink_disable();
            break;
        case BT_SINK_PLAY:
            wifibt_log("BT_SINK_PLAY\n");
            rk_bt_sink_play();
            break;
        case BT_SINK_PAUSE:
            wifibt_log("BT_SINK_PAUSE\n");
            rk_bt_sink_pause();
            break;
        case BT_SINK_PREV:
            wifibt_log("BT_SINK_PREV\n");
            rk_bt_sink_prev();
            break;
        case BT_SINK_NEXT:
            wifibt_log("BT_SINK_NEXT\n");
            rk_bt_sink_next();
            break;
        case BT_SINK_VOL_UP:
            wifibt_log("BT_SINK_VOL_UP\n");
            rk_bt_sink_volume_up();
            break;
        case BT_SINK_VOL_DOWN:
            wifibt_log("BT_SINK_VOL_DOWN\n");
            rk_bt_sink_volume_down();
            break;
        case BT_SINK_VOL:
            intval = (intptr_t)cmdarg->val;
            wifibt_log("BT_SINK_VOL %d\n", intval);
            rk_bt_sink_set_volume(intval);
            break;
        case BT_SINK_MUTE:
            wifibt_log("BT_SINK_MUTE\n");
            rk_bt_sink_set_volume(0);
            break;
        case BT_INFO:
            bt_sink_info((struct bt_info *)cmdarg->val);
            break;
        case BT_SINK_TRACK_CLEAR:
            bt_sink_track_clear();
            break;
        case BT_SINK_POS_CLEAR:
            bt_sink_pos_clear();
            break;
        default:
            wifibt_log("Unknow cmd %d\n", cmdarg->cmd);
            break;
        }
        if (cmdarg->wait)
            sem_post(&sem);
    }
}

int run_wifibt_server(void)
{
    pthread_t tid;
    int ret;

    sem_init(&sem, 0, 1);

    ret = pipe(fd);
    if (ret != 0)
    {
        wifibt_log("wifibt server init failed\n");
        return ret;
    }

    ret = pthread_create(&tid, NULL, wifibt_server, NULL);
    if (ret < 0)
    {
        close(fd[0]);
        close(fd[1]);
        wifibt_log("wifibt server start failed\n");
    }

    return ret;
}

