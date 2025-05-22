/*
 * Copyright (c) 2023 Rockchip, Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <lvgl/lvgl.h>
#include <lvgl/lv_conf.h>

#include "main.h"
#include "hal_sdl.h"
#include "hal_drm.h"
#include "home_ui.h"
#include "ui_resource.h"

#include "rk_defines.h"
#include "rk_mpi_sys.h"

#include "wifibt.h"

lv_ft_info_t ttf_main_s;
lv_ft_info_t ttf_main_m;
lv_ft_info_t ttf_main_l;

lv_style_t style_txt_s;
lv_style_t style_txt_m;
lv_style_t style_txt_l;

static int g_indev_rotation = 0;
static int g_disp_rotation = LV_DISP_ROT_NONE;

static int quit = 0;

extern void rk_demo_init(void);

static void sigterm_handler(int sig)
{
    fprintf(stderr, "signal %d\n", sig);
    quit = 1;
}

int app_disp_rotation(void)
{
    return g_disp_rotation;
}

#if USE_SDL_GPU
static void sdl_mouse_init(void)
{
    static lv_indev_drv_t indev_drv_1;
    lv_indev_t *mouse_indev;

    lv_indev_drv_init(&indev_drv_1);
    indev_drv_1.type = LV_INDEV_TYPE_POINTER;

    indev_drv_1.read_cb = sdl_mouse_read;
    mouse_indev = lv_indev_drv_register(&indev_drv_1);
}
#endif

static void lvgl_init(void)
{
    lv_init();

#if USE_SDL_GPU
    hal_sdl_init(0, 0, g_disp_rotation);
    sdl_mouse_init();
#else
    hal_drm_init(0, 0, g_disp_rotation);
    lv_port_indev_init(g_indev_rotation);
#endif
    lv_port_fs_init();
}

static void font_init(void)
{
    lv_freetype_init(64, 1, 0);

#ifdef LARGE
    ttf_main_s.weight = 26;
    ttf_main_m.weight = 36;
    ttf_main_l.weight = 140;
#else
    ttf_main_s.weight = 22;
    ttf_main_m.weight = 32;
    ttf_main_l.weight = 96;
#endif

    ttf_main_s.name = MAIN_FONT;
    ttf_main_s.style = FT_FONT_STYLE_NORMAL;
    lv_ft_font_init(&ttf_main_s);

    ttf_main_m.name = MAIN_FONT;
    ttf_main_m.style = FT_FONT_STYLE_NORMAL;
    lv_ft_font_init(&ttf_main_m);

    ttf_main_l.name = MAIN_FONT;
    ttf_main_l.style = FT_FONT_STYLE_NORMAL;
    lv_ft_font_init(&ttf_main_l);
}

static void style_init(void)
{
    lv_style_init(&style_txt_s);
    lv_style_set_text_font(&style_txt_s, ttf_main_s.font);
    lv_style_set_text_color(&style_txt_s, lv_color_black());

    lv_style_init(&style_txt_m);
    lv_style_set_text_font(&style_txt_m, ttf_main_m.font);
    lv_style_set_text_color(&style_txt_m, lv_color_black());

    lv_style_init(&style_txt_l);
    lv_style_set_text_font(&style_txt_l, ttf_main_l.font);
    lv_style_set_text_color(&style_txt_l, lv_color_black());
}

void app_init(void)
{
    font_init();
    style_init();
}

int main(int argc, char **argv)
{
#define FPS     0
#if FPS
    float maxfps = 0.0, minfps = 1000.0;
    float fps;
    float fps0 = 0, fps1 = 0;
    uint32_t st, et;
    uint32_t st0 = 0, et0;
#endif
    signal(SIGINT, sigterm_handler);

#if ROCKIT_EN
    RK_MPI_SYS_Init();
#endif
#if WIFIBT_EN
    run_wifibt_server();
#endif

    lvgl_init();

    app_init();

    rk_demo_init();

    while (!quit)
    {
#if FPS
        st = clock_ms();
#endif
        lv_task_handler();
#if FPS
        et = clock_ms();
        fps = 1000 / (et - st);
        if (fps != 0.0 && fps < minfps)
        {
            minfps = fps;
            printf("Update minfps %f\n", minfps);
        }
        if (fps < 60 && fps > maxfps)
        {
            maxfps = fps;
            printf("Update maxfps %f\n", maxfps);
        }
        if (fps > 0.0 && fps < 60)
        {
            fps0 = (fps0 + fps) / 2;
            fps1 = (fps0 + fps1) / 2;
        }
        et0 = clock_ms();
        if ((et0 - st0) > 1000)
        {
            printf("avg:%f\n", fps1);
            st0 = et0;
        }
#endif
        usleep(100);
    }

#if ROCKIT_EN
    RK_MPI_SYS_Exit();
#endif

    return 0;
}
