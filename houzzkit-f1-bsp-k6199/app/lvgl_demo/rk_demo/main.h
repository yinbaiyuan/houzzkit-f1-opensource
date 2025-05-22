#ifndef __MAIN_H__
#define __MAIN_H__

#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>

#include <lvgl/lvgl.h>

#include "home_ui.h"
#include "lv_port_file.h"
#include "lv_port_indev.h"
#include "ui_btnmatrix.h"
#include "ui_common.h"
#include "ui_resource.h"

#define LARGE
#define ROCKIT_EN   1
#define WIFIBT_EN   1
#define BT_EN       1

extern lv_ft_info_t ttf_main_s;
extern lv_ft_info_t ttf_main_m;
extern lv_ft_info_t ttf_main_l;

extern lv_style_t style_txt_s;
extern lv_style_t style_txt_m;
extern lv_style_t style_txt_l;

int app_disp_rotation(void);

#endif

