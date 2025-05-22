#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h>

#include <lvgl/lvgl.h>

#include "main.h"
#include "ui_resource.h"
#include "smart_home_ui.h"

static lv_obj_t *bg;

static lv_img_dsc_t *bg_snapshot;

static lv_obj_t *area_aircond_0;
static lv_obj_t *area_aircond_1;
static lv_obj_t *area_light;

static lv_obj_t *light_menu(lv_obj_t *parent,
                            lv_img_dsc_t *img)
{
    char *light_name[] =
    {
        "卧室1",
        "卧室2",
        "客厅1",
        "客厅2",
        "客卧1",
        "客卧2",
        "餐厅",
    };
    int light_state[] =
    {
        LV_STATE_CHECKED,
        LV_STATE_DEFAULT,
        LV_STATE_CHECKED,
        LV_STATE_CHECKED,
        LV_STATE_DEFAULT,
        LV_STATE_DEFAULT,
        LV_STATE_DEFAULT
    };
    lv_obj_t *obj;
    lv_obj_t *cont;
    lv_obj_t *depart;
    lv_obj_t *light_bg;
    lv_obj_t *light;
    lv_area_t area;

    light_bg = lv_img_create(parent);
    lv_obj_set_style_clip_corner(light_bg, 1, LV_PART_MAIN);
    lv_obj_set_style_radius(light_bg, 20, LV_PART_MAIN);
    lv_obj_set_size(light_bg, lv_pct(100), 150);
    lv_obj_align(light_bg, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_refr_size(light_bg);
    lv_obj_refr_pos(light_bg);
    lv_obj_get_content_coords(light_bg, &area);
    lv_img_set_src(light_bg, bg_snapshot);
    lv_img_set_offset_x(light_bg, -area.x1);
    lv_img_set_offset_y(light_bg, -area.y1);
    lv_obj_clear_flag(light_bg, LV_OBJ_FLAG_SCROLLABLE);

    light = lv_obj_create(light_bg);
    lv_obj_remove_style_all(light);
    lv_obj_set_size(light, lv_pct(100), lv_pct(100));
    lv_obj_set_style_pad_all(light, 10, LV_PART_MAIN);
    lv_obj_center(light);

    obj = lv_label_create(light);
    lv_obj_set_size(obj, lv_pct(100), lv_pct(30));
    lv_obj_align(obj, LV_ALIGN_TOP_LEFT, 0, 0);
    lv_label_set_text(obj, "灯光");
    lv_obj_add_style(obj, &style_txt_m, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);

    depart = lv_obj_create(light);
    lv_obj_remove_style_all(depart);
    lv_obj_set_size(depart, lv_pct(90), lv_pct(50));
    lv_obj_align(depart, LV_ALIGN_BOTTOM_MID, 0, -10);
    lv_obj_set_flex_flow(depart, LV_FLEX_FLOW_ROW);
    lv_obj_set_style_pad_column(depart, 10, 0);

    for (int i = 0; i < sizeof(light_name) / sizeof(light_name[0]); i++)
    {
        cont = lv_obj_create(depart);
        lv_obj_remove_style_all(cont);
        lv_obj_set_size(cont, LV_SIZE_CONTENT, lv_pct(100));

        obj = lv_label_create(cont);
        lv_label_set_text(obj, light_name[i]);
        lv_obj_add_style(obj, &style_txt_m, LV_PART_MAIN);
        lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
        lv_obj_align(obj, LV_ALIGN_TOP_MID, 0, 0);

        obj = lv_switch_create(cont);
        lv_obj_add_state(obj, light_state[i]);
        lv_obj_align(obj, LV_ALIGN_BOTTOM_MID, 0, 0);
    }

    return light_bg;
}

static lv_obj_t *aircond_menu(lv_obj_t *parent,
                              char *name,
                              lv_img_dsc_t *img)
{
    char *btn_name[] =
    {
        "开启/关闭",
        "制冷模式",
        "制热模式",
        "风力：3"
    };
    lv_align_t align[] =
    {
        LV_ALIGN_TOP_LEFT,
        LV_ALIGN_TOP_RIGHT,
        LV_ALIGN_BOTTOM_LEFT,
        LV_ALIGN_BOTTOM_RIGHT,
    };
    lv_obj_t *area_aircond_bg;
    lv_obj_t *area_aircond;
    lv_obj_t *area_temp;
    lv_obj_t *area_btn;
    lv_obj_t *area_set;
    lv_obj_t *obj;
    lv_obj_t *temp;
    lv_area_t area;
    lv_coord_t pw;

    lv_obj_get_content_coords(parent, &area);
    pw = (area.x2 - area.x1);

    area_aircond_bg = lv_img_create(parent);
    lv_obj_set_style_radius(area_aircond_bg, 20, LV_PART_MAIN);
    lv_obj_set_style_clip_corner(area_aircond_bg, 1, LV_PART_MAIN);
    lv_obj_set_size(area_aircond_bg, pw, pw);
    lv_obj_refr_size(area_aircond_bg);
    lv_obj_refr_pos(area_aircond_bg);
    lv_obj_get_content_coords(area_aircond_bg, &area);
    lv_img_set_src(area_aircond_bg, bg_snapshot);
    lv_img_set_offset_x(area_aircond_bg, -area.x1);
    lv_img_set_offset_y(area_aircond_bg, -area.y1);
    lv_obj_clear_flag(area_aircond_bg, LV_OBJ_FLAG_SCROLLABLE);

    area_aircond = lv_obj_create(area_aircond_bg);
    lv_obj_remove_style_all(area_aircond);
    lv_obj_set_size(area_aircond, lv_pct(100), lv_pct(100));
    lv_obj_set_style_pad_all(area_aircond, 10, LV_PART_MAIN);
    lv_obj_center(area_aircond);

    obj = lv_label_create(area_aircond);
    lv_obj_align(obj, LV_ALIGN_TOP_LEFT, 0, 0);
    lv_label_set_text(obj, name);
    lv_obj_add_style(obj, &style_txt_m, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);

    area_temp = lv_obj_create(area_aircond);
    lv_obj_remove_style_all(area_temp);
    lv_obj_set_size(area_temp, lv_pct(100), lv_pct(50));
    lv_obj_align(area_temp, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_clear_flag(area_temp, LV_OBJ_FLAG_SCROLLABLE);

    area_btn = lv_obj_create(area_aircond);
    lv_obj_remove_style_all(area_btn);
    lv_obj_set_size(area_btn, lv_pct(50), lv_pct(50));
    lv_obj_align(area_btn, LV_ALIGN_BOTTOM_LEFT, 0, 0);
    lv_obj_clear_flag(area_btn, LV_OBJ_FLAG_SCROLLABLE);

    area_set = lv_obj_create(area_aircond);
    lv_obj_remove_style_all(area_set);
    lv_obj_set_size(area_set, lv_pct(50), lv_pct(50));
    lv_obj_align(area_set, LV_ALIGN_BOTTOM_RIGHT, 0, 0);
    lv_obj_clear_flag(area_set, LV_OBJ_FLAG_SCROLLABLE);

    temp = lv_label_create(area_temp);
    lv_obj_align(temp, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_label_set_text(temp, "24℃");
    lv_obj_add_style(temp, &style_txt_l, LV_PART_MAIN);
    lv_obj_set_style_text_color(temp, lv_color_white(), LV_PART_MAIN);
    lv_obj_refr_size(temp);
    lv_obj_refr_pos(temp);

    obj = lv_label_create(area_temp);
    lv_label_set_text(obj, "当前室温");
    lv_obj_add_style(obj, &style_txt_s, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
    lv_obj_refr_size(obj);
    lv_obj_refr_pos(obj);
    lv_obj_align_to(obj, temp, LV_ALIGN_OUT_LEFT_TOP, 0, 0);

    for (int i = 0; i < 4; i++)
    {
        obj = lv_btn_create(area_btn);
        lv_obj_align(obj, align[i], 0, 0);
        lv_obj_set_size(obj, lv_pct(45), lv_pct(45));
        lv_obj_set_style_radius(obj, lv_pct(50), LV_PART_MAIN);

        obj = lv_label_create(obj);
        lv_label_set_text(obj, btn_name[i]);
        lv_obj_add_style(obj, &style_txt_s, LV_PART_MAIN);
        lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
        lv_obj_center(obj);
    }

    temp = lv_roller_create(area_set);
    lv_roller_set_options(temp, "16\n17\n18\n19\n20\n21\n22\n23\n"
                          "24\n25\n26\n27\n28\n29\n30\n31\n32",
                          LV_ROLLER_MODE_NORMAL);
    lv_roller_set_visible_row_count(temp, 3);
    lv_roller_set_selected(temp, 8, LV_ANIM_OFF);
    lv_obj_align(temp, LV_ALIGN_CENTER, 0, 0);

    obj = lv_label_create(area_set);
    lv_label_set_text(obj, "设置温度");
    lv_obj_add_style(obj, &style_txt_s, LV_PART_MAIN);
    lv_obj_set_style_text_color(obj, lv_color_white(), LV_PART_MAIN);
    lv_obj_align_to(obj, temp, LV_ALIGN_OUT_BOTTOM_MID, 0, 0);

    return area_aircond_bg;
}

void menu_control_scroll_cb(lv_event_t * event)
{
    lv_area_t area;

    lv_obj_get_content_coords(area_light, &area);
    lv_img_set_offset_x(area_light, -area.x1);
    lv_img_set_offset_y(area_light, -area.y1);

    lv_obj_get_content_coords(area_aircond_0, &area);
    lv_img_set_offset_x(area_aircond_0, -area.x1);
    lv_img_set_offset_y(area_aircond_0, -area.y1);

    lv_obj_get_content_coords(area_aircond_1, &area);
    lv_img_set_offset_x(area_aircond_1, -area.x1);
    lv_img_set_offset_y(area_aircond_1, -area.y1);
}

lv_obj_t *menu_control_init(lv_obj_t *parent)
{
    bg = lv_obj_create(parent);
    lv_obj_remove_style_all(bg);
    lv_obj_set_size(bg, lv_pct(90), lv_pct(90));
    lv_obj_center(bg);
    lv_obj_set_flex_flow(bg, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_row(bg, 30, 0);
    lv_obj_add_event_cb(bg, menu_control_scroll_cb, LV_EVENT_SCROLL, NULL);
    lv_obj_refr_size(bg);
    lv_obj_refr_pos(bg);

    bg_snapshot = get_bg_snapshot();

    area_light = light_menu(bg, bg_snapshot);
    area_aircond_0 = aircond_menu(bg, "客厅空调", bg_snapshot);
    area_aircond_1 = aircond_menu(bg, "卧室空调", bg_snapshot);

    return bg;
}

void menu_control_deinit(void)
{
    lv_obj_del(bg);
    bg = NULL;
}

