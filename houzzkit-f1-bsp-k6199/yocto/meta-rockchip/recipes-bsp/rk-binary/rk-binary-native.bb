# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

inherit local-git deploy native

DESCRIPTION = "Rockchip binary tools"

LICENSE = "LICENSE.rockchip"
LIC_FILES_CHKSUM = "file://${RKBASE}/licenses/LICENSE.rockchip;md5=d63890e209bf038f44e708bbb13e4ed9"
SRC_URI = " \
	git://gitlab.com/firefly-linux/rkbin.git;protocol=https;branch=${FIREFLY_SDK_BRANCH};name=rkbin \
	git://gitlab.com/firefly-linux/tools.git;protocol=https;branch=${FIREFLY_SDK_BRANCH};name=tools;destsuffix=git/extra \
"

SRCREV_rkbin = "${FIREFLY_SDK_VERSION}"
SRCREV_tools = "${FIREFLY_SDK_VERSION}"
SRCREV_FORMAT ?= "rkbin_tools"

S = "${WORKDIR}/git"

INSANE_SKIP:${PN} = "already-stripped"
STRIP = "echo"

# The pre-built tools have different link loader, don't change them.
UNINATIVE_LOADER := ""

do_install () {
	install -d ${D}/${bindir}

	cd ${S}/tools

	install -m 0755 boot_merger ${D}/${bindir}
	install -m 0755 trust_merger ${D}/${bindir}
	install -m 0755 firmwareMerger ${D}/${bindir}

	install -m 0755 kernelimage ${D}/${bindir}
	install -m 0755 loaderimage ${D}/${bindir}

	install -m 0755 mkkrnlimg ${D}/${bindir}
	install -m 0755 resource_tool ${D}/${bindir}

	install -m 0755 upgrade_tool ${D}/${bindir}

	cd ${S}/extra/linux/Linux_Pack_Firmware/rockdev

	install -m 0755 afptool ${D}/${bindir}
	install -m 0755 rkImageMaker ${D}/${bindir}
}
