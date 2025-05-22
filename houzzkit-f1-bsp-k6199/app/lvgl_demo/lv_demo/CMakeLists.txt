cmake_minimum_required(VERSION 3.8)

project(lv_demo)

option(LINK_LVGL_DEMOS "Link lvgl_demos" OFF)

include_directories(
	${PROJECT_SOURCE_DIR}/./
	)

if (LV_USE_DEMO_WIDGETS)
	add_definitions(-DLV_USE_DEMO_WIDGETS=1)
	set(LINK_LVGL_DEMOS ON)
elseif (LV_USE_DEMO_KEYPAD_AND_ENCODER)
	add_definitions(-DLV_USE_DEMO_KEYPAD_AND_ENCODER=1)
	set(LINK_LVGL_DEMOS ON)
elseif (LV_USE_DEMO_BENCHMARK)
	add_definitions(-DLV_USE_DEMO_BENCHMARK=1)
	set(LINK_LVGL_DEMOS ON)
elseif (LV_USE_DEMO_STRESS)
	add_definitions(-DLV_USE_DEMO_STRESS=1)
	set(LINK_LVGL_DEMOS ON)
elseif (LV_USE_DEMO_MUSIC)
	add_definitions(-DLV_USE_DEMO_MUSIC=1)
	set(LINK_LVGL_DEMOS ON)
endif()

aux_source_directory(. SRCS)

add_executable(${PROJECT_NAME} ${SRCS})

target_link_libraries(${PROJECT_NAME}
	lvgl pthread m lv_drivers freetype
)

if (LINK_LVGL_DEMOS)
	target_link_libraries(${PROJECT_NAME} lvgl_demos)
endif()
if (LV_DRV_USE_SDL_GPU)
	target_link_libraries(${PROJECT_NAME} SDL2)
endif()
if (LV_DRV_USE_DRM)
	target_link_libraries(${PROJECT_NAME} drm)
endif()

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(PROGRAMS S00-lv_demo DESTINATION /etc/init.d)

