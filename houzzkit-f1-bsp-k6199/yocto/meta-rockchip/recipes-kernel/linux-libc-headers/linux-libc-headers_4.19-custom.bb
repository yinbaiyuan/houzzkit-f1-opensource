# Copyright (C) 2020, Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux-libc-headers/linux-libc-headers.inc

inherit auto-patch

inherit local-git

SRCREV = "${FIREFLY_SDK_VERSION}"
SRC_URI = " \
	git://gitlab.com/firefly-linux/kernel.git;protocol=https;branch=${FIREFLY_SDK_BRANCH}; \
"

S = "${WORKDIR}/git"

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
