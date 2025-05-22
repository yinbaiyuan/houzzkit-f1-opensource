#!/bin/bash -e

usage_hook()
{
	echo -e "rtos                             \tbuild and pack RTOS"
}

BUILD_CMDS="rtos"
build_hook()
{
	check_config RK_RTOS RK_RTTHREAD_TARGET || return 0

	echo "=========================================="
	echo "          Start building RTOS($RK_RTTHREAD_TARGET)"
	echo "=========================================="

	cd "$SDK_DIR/rtos/bsp/rockchip/$RK_RTTHREAD_TARGET"
	./build.sh 0
	./mkimage.sh
	ln -rsf Image/amp.img "$RK_FIRMWARE_DIR/"

	finish_build build_rtos $@
}

source "${BUILD_HELPER:-$(dirname "$(realpath "$0")")/../build-hooks/build-helper}"

build_hook $@
