#include <lvgl/lvgl.h>

#include "control_ui.h"
#include "home_ui.h"
#include "info_ui.h"
#include "main.h"
#include "music_ui.h"
#include "ui_resource.h"

enum
{
    SUBMENU_MIN = 0,
    SUBMENU_INFO = SUBMENU_MIN,
    SUBMENU_CONTROL,
#if BT_EN
    SUBMENU_MUSIC,
#endif
    SUBMENU_MAX,
    SUBMENU_DEFAULT = SUBMENU_INFO,
};

struct submenu_s
{
    char *name;
    void (*init)(lv_obj_t *parent);
    void (*scroll_cb)(lv_event_t *event);
    void (*deinit)(void);
    lv_obj_t *menu;
};

static lv_obj_t *main = NULL;
static lv_obj_t *bg_pic;
static lv_obj_t *btn_return;
static lv_obj_t *area_submenu;

static lv_obj_t *sub_menu[SUBMENU_MAX];
static struct submenu_s submenu_desc[SUBMENU_MAX];

#define SUBMENU_COMMON_DEFINE(enum_t, name) \
static void submenu_##name(lv_obj_t * parent)  \
{   \
    if (!submenu_desc[enum_t].menu)\
        submenu_desc[enum_t].menu = menu_##name##_init(parent);\
}   \
static void submenu_##name##_destroy(void)  \
{   \
    if (submenu_desc[enum_t].menu)\
        menu_##name##_deinit();\
}   \
static void submenu_##name##_scroll(lv_event_t *event)  \
{   \
    if (submenu_desc[enum_t].menu)\
        menu_##name##_scroll_cb(event);\
}

SUBMENU_COMMON_DEFINE(SUBMENU_INFO, info)
SUBMENU_COMMON_DEFINE(SUBMENU_CONTROL, control)
#if BT_EN
SUBMENU_COMMON_DEFINE(SUBMENU_MUSIC, music)
#endif

static struct submenu_s submenu_desc[SUBMENU_MAX] =
{
    {"首页",   submenu_info,    submenu_info_scroll,    submenu_info_destroy,    NULL},
    {"控制",   submenu_control, submenu_control_scroll, submenu_control_destroy, NULL},
#if BT_EN
    {"播放器", submenu_music,   submenu_music_scroll,   submenu_music_destroy,   NULL}
#endif
};

static void btn_return_cb(lv_event_t *e)
{
    switch (e->code)
    {
    case LV_EVENT_CLICKED:
        home_ui_init();
        for (int i = SUBMENU_MIN; i < SUBMENU_MAX; i++)
        {
            if (submenu_desc[i].deinit)
                submenu_desc[i].deinit();
            submenu_desc[i].menu = NULL;
        }
        lv_obj_del(main);
        main = NULL;
        break;
    default:
        break;
    }
}

static void scroll_cb(lv_event_t * event)
{
    for (int i = SUBMENU_MIN; i < SUBMENU_MAX; i++)
    {
        if (submenu_desc[i].scroll_cb)
            submenu_desc[i].scroll_cb(event);
    }
}

void smart_home_ui_init(void)
{
    lv_obj_t *obj;

    if (main)
    {
        lv_obj_clear_flag(main, LV_OBJ_FLAG_HIDDEN);
        return;
    }

    main = lv_obj_create(lv_scr_act());
    lv_obj_remove_style_all(main);
    lv_obj_set_style_pad_all(main, 10, LV_PART_MAIN);
    lv_obj_set_size(main, lv_pct(100), lv_pct(100));
    lv_obj_refr_size(main);

    btn_return = ui_return_btn_create(main, btn_return_cb, "智能家居");

    area_submenu = lv_tileview_create(main);
    lv_obj_remove_style_all(area_submenu);
    lv_obj_set_size(area_submenu, lv_pct(100), lv_pct(90));
    lv_obj_set_pos(area_submenu, 0, lv_pct(10));
    lv_obj_add_event_cb(area_submenu, scroll_cb, LV_EVENT_SCROLL, NULL);
    for (int i = SUBMENU_MIN; i < SUBMENU_MAX; i++)
    {
        obj = lv_tileview_add_tile(area_submenu, i, 0, LV_DIR_LEFT | LV_DIR_RIGHT);
        lv_obj_set_style_pad_all(obj, 0, LV_PART_MAIN);
        submenu_desc[i].init(obj);
    }
}

