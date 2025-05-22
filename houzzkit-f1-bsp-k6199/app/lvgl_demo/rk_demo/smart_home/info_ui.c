#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h>

#include <lvgl/lvgl.h>

#include "main.h"
#include "smart_home_ui.h"
#include "ui_resource.h"

#define UI_PAD      5

static lv_obj_t *bg;

static lv_img_dsc_t *bg_snapshot;

static lv_obj_t *area_date;
static lv_obj_t *area_weather;
static lv_obj_t *area_scene;

void menu_info_scroll_cb(lv_event_t * event)
{
    lv_area_t area;

    lv_obj_get_content_coords(area_date, &area);
    lv_img_set_offset_x(area_date, -area.x1);
    lv_img_set_offset_y(area_date, -area.y1);

    lv_obj_get_content_coords(area_weather, &area);
    lv_img_set_offset_x(area_weather, -area.x1);
    lv_img_set_offset_y(area_weather, -area.y1);

    lv_obj_get_content_coords(area_scene, &area);
    lv_img_set_offset_x(area_scene, -area.x1);
    lv_img_set_offset_y(area_scene, -area.y1);
}

lv_obj_t *menu_info_init(lv_obj_t *parent)
{
    lv_obj_t *obj;
    lv_obj_t *label;
    lv_area_t area;
    lv_coord_t pw;

    bg = lv_obj_create(parent);
    lv_obj_remove_style_all(bg);
    lv_obj_set_size(bg, lv_pct(90), lv_pct(90));
    lv_obj_center(bg);
    lv_obj_add_event_cb(bg, menu_info_scroll_cb, LV_EVENT_SCROLL, NULL);
    lv_obj_refr_size(bg);
    lv_obj_refr_pos(bg);
    lv_obj_get_content_coords(bg, &area);
    pw = area.x2 - area.x1;

    bg_snapshot = get_bg_snapshot();

    area_date = lv_img_create(bg);
    lv_obj_set_style_radius(area_date, 20, LV_PART_MAIN);
    lv_obj_set_style_clip_corner(area_date, 1, LV_PART_MAIN);
    lv_obj_set_size(area_date, (pw - UI_PAD) / 2, (pw - UI_PAD) / 2);
    lv_obj_set_align(area_date, LV_ALIGN_TOP_LEFT);
    lv_obj_refr_size(area_date);
    lv_obj_refr_pos(area_date);
    lv_obj_get_content_coords(area_date, &area);
    lv_img_set_src(area_date, bg_snapshot);
    lv_img_set_offset_x(area_date, -area.x1);
    lv_img_set_offset_y(area_date, -area.y1);

    obj = lv_label_create(area_date);
    lv_label_set_text(obj, "10:32");
    lv_obj_add_style(obj, &style_txt_l, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
    lv_obj_align(obj, LV_ALIGN_CENTER, 0, -10);

    label = lv_label_create(area_date);
    lv_label_set_text(label, "7月13日 周四");
    lv_obj_add_style(label, &style_txt_m, LV_PART_MAIN);
    lv_obj_set_style_text_color(label, lv_color_white(), LV_PART_MAIN);
    lv_obj_align_to(label, obj, LV_ALIGN_OUT_BOTTOM_MID, 0, 0);

    area_weather = lv_img_create(bg);
    lv_obj_set_style_radius(area_weather, 20, LV_PART_MAIN);
    lv_obj_set_style_clip_corner(area_weather, 1, LV_PART_MAIN);
    lv_obj_set_size(area_weather, (pw - UI_PAD) / 2, (pw - UI_PAD) / 2);
    lv_obj_set_align(area_weather, LV_ALIGN_TOP_RIGHT);
    lv_obj_refr_size(area_weather);
    lv_obj_refr_pos(area_weather);
    lv_obj_get_content_coords(area_weather, &area);
    lv_img_set_src(area_weather, bg_snapshot);
    lv_img_set_offset_x(area_weather, -area.x1);
    lv_img_set_offset_y(area_weather, -area.y1);

    obj = lv_label_create(area_weather);
    lv_label_set_text(obj, "32℃");
    lv_obj_add_style(obj, &style_txt_l, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
    lv_obj_align(obj, LV_ALIGN_CENTER, 0, -10);

    label = lv_label_create(area_weather);
    lv_label_set_text(label, "福州   晴");
    lv_obj_add_style(label, &style_txt_m, LV_PART_MAIN);
    lv_obj_set_style_text_color(label, lv_color_white(), LV_PART_MAIN);
    lv_obj_align_to(label, obj, LV_ALIGN_OUT_BOTTOM_LEFT, 0, 0);

    area_scene = lv_img_create(bg);
    lv_obj_set_style_radius(area_scene, 20, LV_PART_MAIN);
    lv_obj_set_style_clip_corner(area_scene, 1, LV_PART_MAIN);
    lv_obj_set_size(area_scene, pw, (pw - UI_PAD) / 2);
    lv_obj_clear_flag(area_scene, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_align_to(area_scene, area_date, LV_ALIGN_OUT_BOTTOM_LEFT, 0, UI_PAD);
    lv_obj_refr_size(area_scene);
    lv_obj_refr_pos(area_scene);
    lv_obj_get_content_coords(area_scene, &area);
    lv_img_set_src(area_scene, bg_snapshot);
    lv_img_set_offset_x(area_scene, -area.x1);
    lv_img_set_offset_y(area_scene, -area.y1);

    obj = lv_btn_create(area_scene);
    lv_obj_align(obj, LV_ALIGN_CENTER, -pw / 5, 0);
    lv_obj_set_size(obj, pw / 5, pw / 5);
    lv_obj_set_style_radius(obj, pw / 10, LV_PART_MAIN);

    obj = lv_label_create(obj);
    lv_label_set_text(obj, "回家");
    lv_obj_add_style(obj, &style_txt_s, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
    lv_obj_center(obj);

    obj = lv_btn_create(area_scene);
    lv_obj_align(obj, LV_ALIGN_CENTER, pw / 5, 0);
    lv_obj_set_size(obj, pw / 5, pw / 5);
    lv_obj_set_style_radius(obj, pw / 10, LV_PART_MAIN);

    obj = lv_label_create(obj);
    lv_label_set_text(obj, "外出");
    lv_obj_add_style(obj, &style_txt_s, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
    lv_obj_center(obj);

    return bg;
}

void menu_info_deinit(void)
{
    lv_obj_del(bg);
    bg = NULL;
}

