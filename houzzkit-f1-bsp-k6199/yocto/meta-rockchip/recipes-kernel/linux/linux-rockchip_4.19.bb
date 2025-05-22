# Copyright (C) 2020, Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

require recipes-kernel/linux/linux-yocto.inc
require linux-rockchip.inc

inherit local-git

PATCHPATH = "${CURDIR}/linux-rockchip_4.19"
inherit auto-patch

SRCREV = "${FIREFLY_SDK_VERSION}"
SRC_URI = " \
	git://gitlab.com/firefly-linux/kernel.git;protocol=https;branch=${FIREFLY_SDK_BRANCH}; \
	file://${THISDIR}/files/cgroups.cfg \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

KERNEL_VERSION_SANITY_SKIP = "1"
LINUX_VERSION ?= "4.19"

SRC_URI:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'ext4', \
		   'file://${THISDIR}/files/ext4.cfg', \
		   '', \
		   d)}"
