#include <lvgl/lvgl.h>

#include "main.h"

lv_obj_t *ui_return_btn_create(lv_obj_t *parent, lv_event_cb_t cb, const char *text)
{
    lv_obj_t *obj;
    lv_obj_t *img;
    lv_obj_t *label;

    obj = lv_obj_create(parent);
    lv_obj_remove_style_all(obj);
#ifdef LARGE
    lv_obj_set_size(obj, 80, 128);
#else
    lv_obj_set_size(obj, 50, 50);
#endif
    lv_obj_set_pos(obj, 0, 0);
    lv_obj_add_flag(obj, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(obj, cb, LV_EVENT_CLICKED, NULL);

    img = lv_img_create(obj);
    lv_img_set_src(img, IMG_RETURN_BTN);
    lv_obj_add_flag(img, LV_OBJ_FLAG_CLICKABLE | LV_OBJ_FLAG_EVENT_BUBBLE);
    lv_obj_set_align(img, LV_ALIGN_RIGHT_MID);

    if (text)
    {
        label = lv_label_create(parent);
        lv_label_set_text(label, text);
        lv_obj_add_style(label, &style_txt_m, LV_PART_MAIN);
        lv_obj_align_to(label, obj,
                        LV_ALIGN_OUT_RIGHT_MID, 5, 0);
    }

    return obj;
}

