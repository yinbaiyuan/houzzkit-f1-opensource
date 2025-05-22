#ifndef __CONTROL_UI_H__
#define __CONTROL_UI_H__

lv_obj_t *menu_control_init(lv_obj_t *parent);
void menu_control_deinit(void);
void menu_control_scroll_cb(lv_event_t * event);

#endif

