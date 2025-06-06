# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append = " \
	file://0001-basic-Allow-unknown-filesystems.patch \
"

# Avoid installing hwdb
EXTRA_OEMAKE:append = " dist_udevhwdb_DATA="

do_configure:append () {
	sed -i -e "s/enable systemd-networkd.service/disable systemd-networkd.service/g" ${S}/presets/90-systemd.preset	
}
