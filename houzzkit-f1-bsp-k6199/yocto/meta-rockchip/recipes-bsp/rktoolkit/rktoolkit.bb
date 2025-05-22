# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "rktoolkit"

LICENSE = "LICENSE.rockchip"
LIC_FILES_CHKSUM = "file://${RKBASE}/licenses/LICENSE.rockchip;md5=d63890e209bf038f44e708bbb13e4ed9"

DEPENDS:append = " libmad"

inherit local-git

#SRCREV = "${@bb.utils.contains('KERNEL_RELEASE', 'NULL', \
#		'${FIREFLY_SDK_VERSION}', \
#		'${KERNEL_RELEASE}', \
#		d)}"

SRCREV = "${FIREFLY_SDK_VERSION}"

SRC_URI = " \
	git://gitlab.com/firefly-linux/external/rktoolkit.git;protocol=https;nobranch=1;branch=${FIREFLY_SDK_BRANCH}; \
"

S = "${WORKDIR}/git"

CFLAGS:append = " -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os -g0 -D_FORTIFY_SOURCE=1"
LDFLAGS:append = " -Wl,--hash-style=gnu"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}/${bindir}
	install -m 755 ${S}/io ${D}/${bindir}/io
	install -m 755 ${S}/update ${D}/${bindir}/recovery
	install -m 755 ${S}/vendor_storage ${D}/${bindir}/vendor_storage

}
