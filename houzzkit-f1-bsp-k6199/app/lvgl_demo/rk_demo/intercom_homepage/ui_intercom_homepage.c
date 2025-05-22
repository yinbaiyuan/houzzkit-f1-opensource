#include <time.h>
#include <lvgl/lvgl.h>

#include "main.h"
#include "ui_resource.h"

#include "ui_intercom_homepage.h"

static lv_obj_t *btn_return;

static lv_obj_t *main = NULL;

static lv_obj_t *ui_box_area;
static lv_obj_t *ui_box_main;
static lv_obj_t *ui_box[10];

void intercom_call_ui_init();
void monitor_ui_init();
static void page_switch(lv_event_t *e);

static struct btn_desc button[] =
{
    {
        .obj  = &ui_box[0],
        .text = "视频监控",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
        .user_data = (void *)monitor_ui_init,
    },
    {
        .obj  = &ui_box[1],
        .text = "对讲呼叫",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
        .user_data = (void *)intercom_call_ui_init,
    },
    {
        .obj  = &ui_box[2],
        .text = "安防报警",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[3],
        .text = "信息",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[4],
        .text = "家电控制",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[5],
        .text = "留影留言",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[6],
        .text = "电梯召唤",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[7],
        .text = "呼叫管理员",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[8],
        .text = "图片管理",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
    {
        .obj  = &ui_box[9],
        .text = "家人留言",
        .w    = 1,
        .h    = 1,
        .draw = common_draw,
        .cb   = page_switch,
    },
};

static lv_coord_t col_dsc[] = {200, 200, LV_GRID_TEMPLATE_LAST};
static lv_coord_t row_dsc[] = {200, 200, 200, 200, 200, 200, 200, 200, 200, 200, LV_GRID_TEMPLATE_LAST};

struct btn_matrix_desc btn_desc = {
    .col_dsc = col_dsc,
    .row_dsc = row_dsc,
    .pad = 5,
    .gap = 20,
    .desc = button,
    .btn_cnt = sizeof(button) / sizeof(button[0]),
};

static void page_switch(lv_event_t *e)
{
    void (*func)(void) = lv_event_get_user_data(e);

    if (func)
    {
        func();
        lv_obj_del(main);
        main = NULL;
    }
}

static void btn_return_cb(lv_event_t *e)
{
    lv_event_code_t code = lv_event_get_code(e);
    lv_obj_t *obj = lv_event_get_target(e);
    if (code == LV_EVENT_CLICKED)
    {
        home_ui_init();
        lv_obj_del(main);
        main = NULL;
    }
}

void intercom_homepage_ui_init()
{
    if (main)
        return;

    main = lv_obj_create(lv_scr_act());
    lv_obj_remove_style_all(main);
    lv_obj_set_style_pad_all(main, 10, LV_PART_MAIN);
    lv_obj_set_size(main, lv_pct(100), lv_pct(100));
    lv_obj_refr_size(main);

    btn_return = ui_return_btn_create(main, btn_return_cb, "楼宇对讲");

    ui_box_area = lv_obj_create(main);
    lv_obj_remove_style_all(ui_box_area);
    lv_obj_set_size(ui_box_area, lv_pct(100), lv_pct(90));
    lv_obj_align(ui_box_area, LV_ALIGN_BOTTOM_MID, 0, 0);

    ui_box_main = ui_btnmatrix_create(ui_box_area, &btn_desc);
    lv_obj_center(ui_box_main);
}

