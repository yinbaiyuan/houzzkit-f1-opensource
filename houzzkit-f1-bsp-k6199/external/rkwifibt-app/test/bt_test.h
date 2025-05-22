#ifndef __BT_TEST_H__
#define __BT_TEST_H__

#ifdef __cplusplus
extern "C" {
#endif

/******************************************/
/*        BT base server init             */
/******************************************/
void bt_test_bluetooth_init(char *data);
void bt_test_bluetooth_deinit(char *data);
void bt_test_bluetooth_onoff_init(char *data);
void bt_test_version(char *data);

void bt_test_set_power(char *data);
void bt_test_set_discoverable(char *data);
void bt_test_set_pairable(char *data);
void bt_test_get_all_devices(char *data);
void bt_test_sink_media_control(char *data);
void bt_test_a2dp_test_volume(char *data);

void bt_test_connect_by_addr(char *data);
void bt_test_disconnect_by_addr(char *data);
void bt_test_pair_by_addr(char *data);
void bt_test_unpair_by_addr(char *data);
void bt_test_start_discovery(char *data);
void bt_test_cancel_discovery(char *data);
void bt_test_read_remote_device_info(char *data);
void bt_test_sink_media_control(char *data);


void bt_test_enable_a2dp_source(char *data);
void bt_test_enable_a2dp_sink(char *data);
void bt_test_source_play(char *data);

/******************************************/
/*               BLE Test                 */
/******************************************/
void bt_test_ble_start(char *data);
void bt_test_ble_write(char *data);
void bt_test_ble_set_address(char *data);
void bt_test_ble_set_adv_interval(char *data);
void bt_test_ble_get_status(char *data);
void bt_test_ble_stop(char *data);
void bt_test_ble_disconnect(char *data);
void bt_test_ble_visibility00(char *data);
void bt_test_ble_visibility11(char *data);

/******************************************/
/*            BLE CLient Test             */
/******************************************/
void bt_test_ble_client_open(char *data);
void bt_test_ble_client_close(char *data);
void bt_test_ble_client_connect(char *data);
void bt_test_ble_client_disconnect(char *data);
void bt_test_ble_client_get_status(char *data);
void bt_test_ble_client_get_service_info(char *data);
void bt_test_ble_client_read(char *data);
void bt_test_ble_client_write(char *data);
void bt_test_ble_client_is_notify(char *data);
void bt_test_ble_client_notify_on(char *data);
void bt_test_ble_client_notify_off(char *data);
void bt_test_ble_client_indicate_on(char *data);
void bt_test_ble_client_indicate_off(char *data);
void bt_test_ble_client_get_eir_data(char *data);

/******************************************/
/*             A2DP SINK Test             */
/******************************************/
void bt_test_sink_open(char *data);
void bt_test_sink_visibility00(char *data);
void bt_test_sink_visibility01(char *data);
void bt_test_sink_visibility10(char *data);
void bt_test_sink_visibility11(char *data);
void bt_test_sink_music_play(char *data);
void bt_test_sink_music_pause(char *data);
void bt_test_sink_music_next(char *data);
void bt_test_sink_music_previous(char *data);
void bt_test_sink_music_stop(char *data);
void bt_test_sink_disconnect(char *data);
void bt_test_sink_close(char *data);
void bt_test_sink_status(char *data);
void bt_test_sink_connect_by_addr(char *data);
void bt_test_sink_disconnect_by_addr(char *data);
void bt_test_sink_get_play_status(char *data);
void bt_test_sink_get_poschange(char *data);

/******************************************/
/*          A2DP SOURCE Test              */
/******************************************/
void bt_test_source_auto_start(char *data);
void bt_test_source_auto_stop(char *data);
void bt_test_source_connect_status(char *data);
void bt_test_source_open(char *data);
void bt_test_source_close(char *data);
void bt_test_source_connect_by_addr(char *data);
void bt_test_source_disconnect_by_addr(char *data);
void bt_test_source_remove_by_addr(char *data);
void bt_test_source_disconnect(char *data);

/******************************************/
/*              SPP Test                  */
/******************************************/
void bt_test_spp_open(char *data);
void bt_test_spp_write(char *data);
void bt_test_spp_close(char *data);
void bt_test_spp_status(char *data);
void bt_test_spp_connect(char *data);
void bt_test_spp_disconnect(char *data);
void bt_test_spp_listen(char *data);
void bt_test_start_discovery_spp(char *data);

#ifdef __cplusplus
}
#endif

#endif /* __BT_TEST_H__ */
