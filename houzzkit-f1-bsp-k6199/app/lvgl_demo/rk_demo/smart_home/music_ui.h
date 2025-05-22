#ifndef __MUSIC_UI_H__
#define __MUSIC_UI_H__

lv_obj_t *menu_music_init(lv_obj_t *parent);
void menu_music_deinit(void);
void menu_music_scroll_cb(lv_event_t * event);

#endif

