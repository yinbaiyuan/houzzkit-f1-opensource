# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "make misc img"

LICENSE = "LICENSE.rockchip"
LIC_FILES_CHKSUM = "file://${RKBASE}/licenses/LICENSE.rockchip;md5=d63890e209bf038f44e708bbb13e4ed9"

inherit local-git deploy

PROVIDES = "virtual/misc"

#SRCREV = "${@bb.utils.contains('KERNEL_RELEASE', 'NULL', \
#		'${FIREFLY_SDK_VERSION}', \
#		'${KERNEL_RELEASE}', \
#		d)}"

SRCREV = "${FIREFLY_SDK_VERSION}"

SRC_URI = "git://gitlab.com/firefly-linux/device/rockchip.git;protocol=https;branch=${FIREFLY_SDK_BRANCH};nobranch=1;"

S = "${WORKDIR}/git"

do_install:append () {
	if [ -f "${S}/rockimg/${RK_MISC}" ];then
		cp -f ${S}/rockimg/${RK_MISC} ${S}/misc.img
	elif [ -f "${S}/common/images/${RK_MISC}" ];then
		cp -f ${S}/common/images/${RK_MISC} ${S}/misc.img
	fi
	install -d ${D}
	install -m 0755 ${S}/misc.img ${D}/
}

do_deploy () {
	cd ${D}
	install -d ${DEPLOYDIR}
	install "${D}/misc.img" "${DEPLOYDIR}"
}

do_fixup_wks:append () {
    echo "Fixing up WKS"
    [ -f "${WKS_FULL_PATH}" ] || return

    IMAGES=$(grep -o "[^=]*\.img" "${WKS_FULL_PATH}")

    for image in ${IMAGES};do
            if [ ! -f "${DEPLOY_DIR_IMAGE}/${image}" ];then
                    echo "${image} not provided, ignoring it."
                    sed -i "/file=${image}/d" "${WKS_FULL_PATH}"
            fi
    done
}

FILES:${PN} = "misc.img"

addtask deploy after do_install before do_fixup_wks
addtask fixup_wks after do_deploy
