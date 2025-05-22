#include "home_ui.h"
#include "ui_intercom_homepage.h"
#include "main.h"
#include <time.h>

#include "rkadk_common.h"
#include "rkadk_media_comm.h"
#include "rkadk_log.h"
#include "rkadk_param.h"
#include "rkadk_player.h"

static RKADK_PLAYER_CFG_S stPlayCfg;
static RKADK_MW_PTR pPlayer = NULL;

static lv_obj_t *main = NULL;
static lv_obj_t *btn_return;

static lv_obj_t *ui_checkbox_audio;
static lv_obj_t *ui_checkbox_video;
static lv_obj_t *ui_monitor_name;
static lv_obj_t *ui_rtsp_label;
static lv_obj_t *ui_rtsp_addr;

static lv_obj_t *ui_control_box;
static lv_obj_t *ui_control;
static lv_obj_t *ui_name;
static lv_obj_t *ui_pause;
static lv_obj_t *ui_continue;
static lv_obj_t *ui_webcam;
static lv_obj_t *ui_forward;
static lv_obj_t *ui_backward;
static lv_obj_t *kb;

static lv_obj_t *player_box = NULL;
static lv_obj_t *icon_box = NULL;

extern lv_style_t style_txt_s;
extern lv_style_t style_txt_m;

static lv_style_t style_txt;
static lv_style_t style_list;

static int network_enable;
static int video_stop;
static int video_pause;
static int thread_start;
static pthread_t video_thread;
static RKADK_BOOL bVideoEnable = true;
static RKADK_BOOL bAudioEnable = false;

static char rtsp_address[128];

static void rtsp_play_start_callback(lv_event_t *event);
static void rtsp_play_pause_callback(lv_event_t *event);
static void ui_name_draw(lv_obj_t *parent, struct btn_desc *desc);
static void ui_control_draw(lv_obj_t *parent, struct btn_desc *desc);

static struct btn_desc vm_btn[] =
{
    {
        .obj  = &ui_webcam,
        .img  = IMG_INTERCOM_WEBCAM,
        .area = {2, 0, 3, 1},
        .draw = common_draw,
        .cb   = rtsp_play_start_callback,
    },
    {
        .obj  = &ui_backward,
        .img  = IMG_INTERCOM_BACKWARD,
        .area = {0, 2, 1, 3},
        .draw = common_draw,
    },
    {
        .obj  = &ui_name,
        .area = {1, 1, 4, 4},
        .draw = ui_name_draw,
    },
    {
        .obj  = &ui_forward,
        .img  = IMG_INTERCOM_ARROWUP,
        .area = {4, 2, 5, 3},
        .draw = common_draw,
    },
    {
        .obj  = &ui_control,
        .area = {2, 4, 3, 5},
        .draw = ui_control_draw,
        .cb   = rtsp_play_pause_callback,
    }
};

static lv_coord_t col_dsc[] = {80, 10, 80, 10, 80, LV_GRID_TEMPLATE_LAST};
static lv_coord_t row_dsc[] = {80, 10, 80, 10, 80, LV_GRID_TEMPLATE_LAST};

static struct btn_matrix_desc btn_desc = {
    .col_dsc = col_dsc,
    .row_dsc = row_dsc,
    .pad = 5,
    .gap = 20,
    .desc = vm_btn,
    .btn_cnt = sizeof(vm_btn) / sizeof(vm_btn[0]),
};

static void ui_name_draw(lv_obj_t *parent, struct btn_desc *desc)
{
    ui_monitor_name = lv_label_create(parent);
    lv_label_set_text(ui_monitor_name, "主机1");
    lv_obj_add_style(ui_monitor_name, &style_txt_m, LV_PART_MAIN);
    lv_obj_add_flag(ui_monitor_name, LV_OBJ_FLAG_IGNORE_LAYOUT);
    lv_obj_center(ui_monitor_name);
}

static void ui_control_draw(lv_obj_t *parent, struct btn_desc *desc)
{
    ui_pause = lv_img_create(ui_control);
    lv_img_set_src(ui_pause, IMG_INTERCOM_PAUSE);
    lv_obj_add_flag(ui_pause, LV_OBJ_FLAG_HIDDEN | LV_OBJ_FLAG_IGNORE_LAYOUT);
    lv_obj_center(ui_pause);

    ui_continue = lv_img_create(ui_control);
    lv_img_set_src(ui_continue, IMG_INTERCOM_CONTUINE);
    lv_obj_add_flag(ui_continue, LV_OBJ_FLAG_IGNORE_LAYOUT);
    lv_obj_center(ui_continue);
}

static void rkadk_deinit(void)
{
    RKADK_PLAYER_Stop(pPlayer);
    RKADK_PLAYER_Destroy(pPlayer);
    pPlayer = NULL;
    RKADK_MPI_SYS_Exit();
}

static void btn_return_cb(lv_event_t *e)
{
    lv_event_code_t code = lv_event_get_code(e);
    lv_obj_t *obj = lv_event_get_target(e);
    if (code == LV_EVENT_CLICKED)
    {
        intercom_homepage_ui_init();
        if (thread_start)
        {
            RKADK_PLAYER_Stop(pPlayer);
            pthread_join(video_thread, NULL);
        }
        if (kb)
        {
            lv_obj_del(kb);
            kb = NULL;
        }
        lv_obj_del(main);
        main = NULL;
        rkadk_deinit();
        rk_demo_bg_show();
    }
}

static int is_network_enable(void)
{
    int ret = system("ping 114.114.114.114 -c 1 -W 1 > /dev/null");
    return !ret;
}

static void style_init(void)
{
    lv_style_init(&style_txt);
    lv_style_set_text_font(&style_txt, ttf_main_s.font);
    lv_style_set_text_color(&style_txt, lv_color_make(0xff, 0x23, 0x23));

    lv_style_init(&style_list);
    lv_style_set_text_font(&style_list, ttf_main_m.font);
    lv_style_set_text_color(&style_list, lv_color_black());
}

static void param_init(RKADK_PLAYER_FRAME_INFO_S *pstFrmInfo)
{
    RKADK_CHECK_POINTER_N(pstFrmInfo);

    memset(pstFrmInfo, 0, sizeof(RKADK_PLAYER_FRAME_INFO_S));
    pstFrmInfo->u32DispWidth = 720;
    pstFrmInfo->u32DispHeight = 512; //1280*0.4=512
    pstFrmInfo->u32ImgWidth = pstFrmInfo->u32DispWidth;
    pstFrmInfo->u32ImgHeight = pstFrmInfo->u32DispHeight;
    pstFrmInfo->u32VoFormat = VO_FORMAT_NV12;
    pstFrmInfo->u32EnIntfType = DISPLAY_TYPE_LCD;
    pstFrmInfo->u32VoLay = 1;
    pstFrmInfo->enIntfSync = RKADK_VO_OUTPUT_DEFAULT;
    pstFrmInfo->enVoSpliceMode = SPLICE_MODE_BYPASS;
    pstFrmInfo->u32BorderColor = 0x0000FA;
    pstFrmInfo->bMirror = RKADK_FALSE;
    pstFrmInfo->bFlip = RKADK_FALSE;
    pstFrmInfo->u32Rotation = 1;
    pstFrmInfo->stSyncInfo.bIdv = RKADK_TRUE;
    pstFrmInfo->stSyncInfo.bIhs = RKADK_TRUE;
    pstFrmInfo->stSyncInfo.bIvs = RKADK_TRUE;
    pstFrmInfo->stSyncInfo.bSynm = RKADK_TRUE;
    pstFrmInfo->stSyncInfo.bIop = RKADK_TRUE;
    pstFrmInfo->stSyncInfo.u16FrameRate = 30;
    pstFrmInfo->stSyncInfo.u16PixClock = 65000;
    pstFrmInfo->stSyncInfo.u16Hact = 1200;
    pstFrmInfo->stSyncInfo.u16Hbb = 24;
    pstFrmInfo->stSyncInfo.u16Hfb = 240;
    pstFrmInfo->stSyncInfo.u16Hpw = 136;
    pstFrmInfo->stSyncInfo.u16Hmid = 0;
    pstFrmInfo->stSyncInfo.u16Vact = 1200;
    pstFrmInfo->stSyncInfo.u16Vbb = 200;
    pstFrmInfo->stSyncInfo.u16Vfb = 194;
    pstFrmInfo->stSyncInfo.u16Vpw = 6;

    return;
}

static RKADK_VOID PlayerEventFnTest(RKADK_MW_PTR pPlayer,
                                    RKADK_PLAYER_EVENT_E enEvent,
                                    RKADK_VOID *pData) {
  switch (enEvent) {
  case RKADK_PLAYER_EVENT_STATE_CHANGED:
    printf("+++++ RKADK_PLAYER_EVENT_STATE_CHANGED +++++\n");
    break;
  case RKADK_PLAYER_EVENT_EOF:
    printf("+++++ RKADK_PLAYER_EVENT_EOF +++++\n");
    lv_obj_add_flag(ui_pause, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(ui_continue, LV_OBJ_FLAG_HIDDEN);
    video_stop = 1;
    break;
  case RKADK_PLAYER_EVENT_SOF:
    printf("+++++ RKADK_PLAYER_EVENT_SOF +++++\n");
    break;
  case RKADK_PLAYER_EVENT_SEEK_END:
    printf("+++++ RKADK_PLAYER_EVENT_SEEK_END +++++\n");
    break;
  case RKADK_PLAYER_EVENT_ERROR:
    printf("+++++ RKADK_PLAYER_EVENT_ERROR +++++\n");
    lv_obj_add_flag(ui_pause, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(ui_continue, LV_OBJ_FLAG_HIDDEN);
    video_stop = 1;
    break;
  case RKADK_PLAYER_EVENT_PREPARED:
    printf("+++++ RKADK_PLAYER_EVENT_PREPARED +++++\n");
    break;
  case RKADK_PLAYER_EVENT_PLAY:
    printf("+++++ RKADK_PLAYER_EVENT_PLAY +++++\n");
    lv_obj_add_flag(ui_continue, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(ui_pause, LV_OBJ_FLAG_HIDDEN);
    break;
  case RKADK_PLAYER_EVENT_PAUSED:
    printf("+++++ RKADK_PLAYER_EVENT_PAUSED +++++\n");
    lv_obj_add_flag(ui_pause, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(ui_continue, LV_OBJ_FLAG_HIDDEN);
    break;
  case RKADK_PLAYER_EVENT_STOPPED:
    printf("+++++ RKADK_PLAYER_EVENT_STOPPED +++++\n");
    lv_obj_add_flag(ui_pause, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(ui_continue, LV_OBJ_FLAG_HIDDEN);
    video_stop = 1;
    break;
  default:
    printf("+++++ Unknown event(%d) +++++\n", enEvent);
    break;
  }
}

static void rkadk_init(void)
{
    setenv("rt_vo_disable_vop", "0", 1);
    RKADK_MPI_SYS_Init();
    RKADK_PARAM_Init(NULL, NULL);
    memset(&stPlayCfg, 0, sizeof(RKADK_PLAYER_CFG_S));
    param_init(&stPlayCfg.stFrmInfo);
    stPlayCfg.bEnableAudio = false;
    stPlayCfg.bEnableVideo = false;
    if (bAudioEnable)
        stPlayCfg.bEnableAudio = true;
    if (bVideoEnable)
        stPlayCfg.bEnableVideo = true;
    stPlayCfg.stFrmInfo.u32FrmInfoX = 0;
    stPlayCfg.stFrmInfo.u32FrmInfoY = 128;
    stPlayCfg.stRtspCfg.u32IoTimeout = 3 * 1000 * 1000;

    stPlayCfg.pfnPlayerCallback = PlayerEventFnTest;

    stPlayCfg.stRtspCfg.transport = "udp";

    if (RKADK_PLAYER_Create(&pPlayer, &stPlayCfg))
    {
        printf("rkadk: RKADK_PLAYER_Create failed\n");
        return;
    }
}

static void* rtsp_play()
{
    if (pPlayer != NULL)
    {
        printf("video_name_callback: stop and deinit pPlayer\n");
        RKADK_PLAYER_Stop(pPlayer);
        rkadk_deinit();
    }
    if (pPlayer == NULL)
    {
        printf("video_name_callback: rkadk_init pPlayer\n");
        rkadk_init();
    }
    strcpy(rtsp_address, lv_textarea_get_text(ui_rtsp_addr));
    int ret = RKADK_PLAYER_SetDataSource(pPlayer, rtsp_address);
    if (ret)
    {
        printf("rkadk: SetDataSource failed, ret = %d\n", ret);
        return NULL;
    }
    printf("RKADK_PLAYER_SetDataSource\n");
    ret = RKADK_PLAYER_Prepare(pPlayer);
    if (ret)
    {
        printf("rkadk: Prepare failed, ret = %d\n", ret);
        return NULL;
    }
    printf("RKADK_PLAYER_Prepare\n");
    ret = RKADK_PLAYER_Play(pPlayer);
    while (!video_stop){
        usleep(1000 * 100);
    }

    thread_start = 0;

    return NULL;
}

static void rtsp_play_start_callback(lv_event_t *event){
    printf("rtsp_play_start_callback into\n");

    network_enable = is_network_enable();
    if (network_enable){
        if (thread_start)
        {
            RKADK_PLAYER_Stop(pPlayer);
            pthread_join(video_thread, NULL);
        }
        video_stop = 0;
        thread_start = 1;
        pthread_create(&video_thread, NULL, rtsp_play, NULL);
    } else {
        printf("network disable\n");
    }
}

static void rtsp_play_pause_callback(lv_event_t *event)
{
    printf("rtsp_play_pause_callback into\n");
    if (!thread_start)
    {
        rtsp_play_start_callback(event);
        return;
    }

    if (!video_pause){
        RKADK_PLAYER_Pause(pPlayer);
    } else {
        RKADK_PLAYER_Play(pPlayer);
    }
    video_pause = !video_pause;
}

static void kb_cb(lv_event_t *e)
{
    lv_obj_t *obj = lv_event_get_target(e);

    lv_obj_del(kb);
    kb = NULL;
}

static void rtsp_address_get(lv_event_t *e)
{
    video_pause = 0;

    if (kb)
        return;

    kb = lv_keyboard_create(lv_layer_sys());
    lv_obj_set_size(kb, lv_pct(100), lv_pct(30));
    lv_obj_set_align(kb, LV_ALIGN_BOTTOM_MID);
    lv_textarea_set_password_mode(ui_rtsp_addr, false);
    lv_keyboard_set_textarea(kb, ui_rtsp_addr);
    lv_obj_add_event_cb(kb, kb_cb, LV_EVENT_CANCEL, NULL);
    lv_obj_add_event_cb(kb, kb_cb, LV_EVENT_READY, NULL);
}

static void ui_checkbox_cb(lv_event_t *e)
{
    lv_obj_t *obj = lv_event_get_target(e);
    RKADK_BOOL *flag = lv_event_get_user_data(e);
    *flag = lv_obj_has_state(obj, LV_STATE_CHECKED);

    printf("bVideoEnable=%d, bAudioEnable=%d\n", bVideoEnable, bAudioEnable);
}

static void obj_event_handler(lv_event_t *e)
{
    lv_event_code_t code = lv_event_get_code(e);
    lv_obj_t *obj = lv_event_get_target(e);
    char tmp_buf[32];
    if (code == LV_EVENT_VALUE_CHANGED){
        lv_dropdown_get_selected_str(obj, tmp_buf, sizeof(tmp_buf));
        if (strcmp(tmp_buf, "视频")==0){
            bVideoEnable = true;
            bAudioEnable = false;
        }
        if (strcmp(tmp_buf, "音视频")==0){
            bVideoEnable = true;
            bAudioEnable = true;
        }
        if (strcmp(tmp_buf, "音频")==0){
            bVideoEnable = false;
            bAudioEnable = true;
        }
    }
}

void monitor_ui_init()
{
    lv_obj_t *obj;

    video_pause = 0;
    network_enable = 0;
    thread_start = 0;

    rk_demo_bg_hide();

    if (main)
        return;

    style_init();

    main = lv_obj_create(lv_scr_act());
    lv_obj_remove_style_all(main);
    lv_obj_set_style_pad_all(main, 0, LV_PART_MAIN);
    lv_obj_set_size(main, lv_pct(100), lv_pct(100));
    lv_obj_refr_size(main);

    icon_box = lv_obj_create(main);
    lv_obj_clear_flag(icon_box, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_pad_all(icon_box, 0, LV_PART_MAIN);
    lv_obj_set_width(icon_box, lv_pct(100));
    lv_obj_set_height(icon_box, lv_pct(10));
    lv_obj_align(icon_box, LV_ALIGN_TOP_LEFT, 0, 0);

    btn_return = ui_return_btn_create(icon_box, btn_return_cb, "视频监控");

    player_box = lv_obj_create(main);
    lv_obj_set_width(player_box, lv_pct(100));
    lv_obj_set_height(player_box, lv_pct(50));
    lv_obj_set_flex_flow(player_box, LV_FLEX_FLOW_COLUMN);
    lv_obj_align(player_box, LV_ALIGN_BOTTOM_MID, 0, 0);

    ui_rtsp_label = lv_label_create(player_box);
    lv_label_set_text(ui_rtsp_label, "RTSP地址:");
    lv_obj_add_style(ui_rtsp_label, &style_txt_s, LV_PART_MAIN);
    lv_obj_refr_size(ui_rtsp_label);
    lv_obj_refr_pos(ui_rtsp_label);

    ui_rtsp_addr = lv_textarea_create(player_box);
    lv_obj_set_width(ui_rtsp_addr, lv_pct(100));
    lv_textarea_set_text(ui_rtsp_addr, "rtsp://192.168.1.120:8554/");
    lv_textarea_set_password_mode(ui_rtsp_addr, false);
    lv_textarea_set_one_line(ui_rtsp_addr, true);
    lv_obj_add_style(ui_rtsp_addr, &style_txt_m, LV_PART_MAIN);
    lv_obj_add_flag(ui_rtsp_addr, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(ui_rtsp_addr, rtsp_address_get, LV_EVENT_CLICKED, NULL);

    ui_checkbox_video = lv_checkbox_create(player_box);
    lv_checkbox_set_text(ui_checkbox_video, "视频");
    lv_obj_add_style(ui_checkbox_video, &style_txt_m, LV_PART_MAIN);
    if (bVideoEnable)
        lv_obj_add_state(ui_checkbox_video, LV_STATE_CHECKED);
    lv_obj_add_event_cb(ui_checkbox_video, ui_checkbox_cb, LV_EVENT_VALUE_CHANGED, &bVideoEnable);

    ui_checkbox_audio = lv_checkbox_create(player_box);
    lv_checkbox_set_text(ui_checkbox_audio, "音频");
    lv_obj_add_style(ui_checkbox_audio, &style_txt_m, LV_PART_MAIN);
    if (bAudioEnable)
        lv_obj_add_state(ui_checkbox_audio, LV_STATE_CHECKED);
    lv_obj_add_event_cb(ui_checkbox_audio, ui_checkbox_cb, LV_EVENT_VALUE_CHANGED, &bAudioEnable);

    ui_control_box = ui_btnmatrix_create(player_box, &btn_desc);
    lv_obj_add_flag(ui_control_box, LV_OBJ_FLAG_IGNORE_LAYOUT);
    lv_obj_center(ui_control_box);

    lv_obj_set_style_bg_color(ui_control,  lv_color_white(), LV_PART_MAIN);
    lv_obj_set_style_bg_color(ui_name,     lv_color_white(), LV_PART_MAIN);
    lv_obj_set_style_bg_color(ui_webcam,   lv_color_white(), LV_PART_MAIN);
    lv_obj_set_style_bg_color(ui_forward,  lv_color_white(), LV_PART_MAIN);
    lv_obj_set_style_bg_color(ui_backward, lv_color_white(), LV_PART_MAIN);
    lv_obj_set_style_radius(ui_control,  200, LV_PART_MAIN);
    lv_obj_set_style_radius(ui_name,     200, LV_PART_MAIN);
    lv_obj_set_style_radius(ui_webcam,   200, LV_PART_MAIN);
    lv_obj_set_style_radius(ui_forward,  200, LV_PART_MAIN);
    lv_obj_set_style_radius(ui_backward, 200, LV_PART_MAIN);
}

