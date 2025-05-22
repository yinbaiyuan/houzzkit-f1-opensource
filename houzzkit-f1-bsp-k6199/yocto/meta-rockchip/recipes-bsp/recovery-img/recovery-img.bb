# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

DEPENDS:append = " linux-rockchip rk-binary-native dtc-native"

DESCRIPTION = "make recovery img"

LICENSE = "LICENSE.rockchip"
LIC_FILES_CHKSUM = "file://${RKBASE}/licenses/LICENSE.rockchip;md5=d63890e209bf038f44e708bbb13e4ed9"

#PATCHPATH = "${CURDIR}/recovery-img/"

inherit local-git linux-rockchip-vars deploy

PROVIDES = "virtual/recovery"

#SRCREV_recovery_img = "${@bb.utils.contains('KERNEL_RELEASE', 'NULL', \
#		'${FIREFLY_SDK_VERSION}', \
#		'${KERNEL_RELEASE}', \
#		d)}"

#SRCREV_rkbin = "${@bb.utils.contains('RKBIN_RELEASE', 'NULL', \
#		'${FIREFLY_SDK_VERSION}', \
#		'${RKBIN_RELEASE}', \
#		d)}"

SRCREV_recovery_img = "${FIREFLY_SDK_VERSION}"
SRCREV_rkbin = "${FIREFLY_SDK_VERSION}"

SRC_URI = " \
	git://gitlab.com/firefly-linux/device/rockchip.git;protocol=https;branch=${FIREFLY_SDK_BRANCH};nobranch=1;name=recovery_img; \
	git://gitlab.com/firefly-linux/rkbin.git;protocol=https;branch=${FIREFLY_SDK_BRANCH};name=rkbin;destsuffix=git/rkbin; \
"

SRCREV_FORMAT = "recovery_img_rkbin"

RK_TARGET_PRODUCT = "rk3566_rk3568"

RK_RECOVERY_FIT_ITS = "boot4recovery.its"
RECOVERY_IMG = "recovery.img"
RK_KERNEL_IMG = "arch/arm64/boot/Image"

S = "${WORKDIR}/git"
COMMON_DIR = "${S}/common"

RK_CFG_RECOVERY = ""

do_install:prepend() {
	cd ${COMMON_DIR}

	if [ -z ${RK_KERNEL_ZIMG} ]; then
		KERNEL_IMAGE=${LINUX_BUILD_DIR}/${RK_KERNEL_IMG}
	else
		KERNEL_IMAGE=${LINUX_BUILD_DIR}/${RK_KERNEL_ZIMG}
	fi

	KERNEL_DTB=${LINUX_BUILD_DIR}/resource.img

	if [ -z ${RAMDISK_CFG} ]
	then
		if [ -n "${RK_RECOVERY_RAMDISK}" ]; then
			if [ -f "${S}/rockimg/${RK_RECOVERY_RAMDISK}" ]; then
				ROOTFS_IMAGE=${S}/rockimg/${RK_RECOVERY_RAMDISK}
			elif [ -f "${S}/common/images/${RK_RECOVERY_RAMDISK}" ]; then
				ROOTFS_IMAGE=${S}/common/images/${RK_RECOVERY_RAMDISK}
			else
				ROOTFS_IMAGE=${S}/rockimg/${RK_RECOVERY_RAMDISK}
			fi
			TARGET_IMAGE=${B}/recovery.img
			echo "use prebuilt $RK_RECOVERY_RAMDISK for CPIO image"
		else
			echo "config for building $RAMDISK_IMG doesn't exist, skip!"
			exit 0
		fi
	fi

	# build kernel
	#if [ -f $KERNEL_IMAGE ]
	#then
	#	echo "found kernel image"
	#else
	#	echo "kernel image doesn't exist, now build kernel image"
	#	$TOP_DIR/build.sh kernel
	#	if [ $? -eq 0 ]; then
	#		echo "build kernel done"
	#	else
	#		exit 1
	#	fi
	#fi


	# build ramdisk
	if [ "${RAMDISK_TYPE}" = "ROMFS" ]
	then
		# Do compress for tinyrootfs
		cat ${ROOTFS_IMAGE} | gzip -n -f -9 > ${ROOTFS_IMAGE}.gz
		cat ${KERNEL_IMAGE} | gzip -n -f -9 > ${KERNEL_IMAGE}.gz
		ROOTFS_IMAGE=${ROOTFS_IMAGE}.gz
		KERNEL_IMAGE=${KERNEL_IMAGE}.gz
	fi

	echo -n "pack ${RAMDISK_IMG}..."
	if [ -f "${S}/${RK_TARGET_PRODUCT}/${RK_RECOVERY_FIT_ITS}" ];then
		fdt=0
		kernel=0
		ramdisk=0
		resource=0
		OUTPUT_TARGET_IMAGE="${TARGET_IMAGE}"
		src_its_file="${S}/${RK_TARGET_PRODUCT}/${RK_RECOVERY_FIT_ITS}"
		ramdisk_file_path="${ROOTFS_IMAGE}"
		kernel_image="${KERNEL_IMAGE}"
		target_its_file="${B}/.tmp_its"

		if [ -z ${kernel_image} ]; then
			if [ -z ${RK_KERNEL_ZIMG} ]; then
				kernel_image=${LINUX_BUILD_DIR}/${RK_KERNEL_IMG}
			else
				kernel_image=${LINUX_BUILD_DIR}/${RK_KERNEL_ZIMG}
			fi
		fi

		if [ ! -f ${src_its_file} ]; then
			echo "Not Fount ${src_its_file} ..."
			exit -1
		fi

		RK_KERNEL_DTS="$(echo "${KERNEL_DEVICETREE}" | sed 's/rockchip\///')"

		if [ "${TARGET_ARCH}" = "arm" ]; then
			kernel_dtb_file="${LINUX_BUILD_DIR}/arch/arm/boot/dts/${RK_KERNEL_DTS}"
		else
			kernel_dtb_file="${LINUX_BUILD_DIR}/arch/arm64/boot/dts/rockchip/${RK_KERNEL_DTS}"
		fi

		rm -f ${target_its_file}
		mkdir -p "`dirname ${target_its_file}`"

		while read line
		do
			############################# generate fdt path
			if [ ${fdt} -eq 1 ];then
				echo "data = /incbin/(\"${kernel_dtb_file}\");" >> ${target_its_file}
				fdt=0
				continue
			fi
			if echo ${line} | grep -w "^fdt" |grep -v ";"; then
				fdt=1
				echo "${line}" >> ${target_its_file}
				continue
			fi

			############################# generate kernel image path
			if [ ${kernel} -eq 1 ];then
				echo "data = /incbin/(\"${kernel_image}\");" >> ${target_its_file}
				kernel=0
				continue
			fi
			if echo ${line} | grep -w "^kernel" |grep -v ";"; then
				kernel=1
				echo "${line}" >> ${target_its_file}
				continue
			fi

			############################# generate ramdisk path
			if [ -f ${ramdisk_file_path} ]; then
				if [ ${ramdisk} -eq 1 ];then
					echo "data = /incbin/(\"${ramdisk_file_path}\");" >> ${target_its_file}
					ramdisk=0
					continue
				fi
				if echo ${line} | grep -w "^ramdisk" |grep -v ";"; then
					ramdisk=1
					echo "${line}" >> ${target_its_file}
					continue
				fi
			fi

			############################# generate resource path
			if [ ${resource} -eq 1 ];then
				echo "data = /incbin/(\"${KERNEL_DTB}\");" >> ${target_its_file}
				resource=0
				continue
			fi
			if echo ${line} | grep -w "^resource" |grep -v ";"; then
				resource=1
				echo "${line}" >> ${target_its_file}
				continue
			fi

			if [ "${RK_RAMDISK_SECURITY_BOOTUP}" = "true" ];then
				if echo ${line} | grep -wq "uboot-ignore"; then
					echo "Enable Security boot, Skip uboot-ignore ..."
					continue
				fi
			fi

			echo "${line}" >> ${target_its_file}
		done < ${src_its_file}

		../rkbin/tools/mkimage -f ${target_its_file}  -E -p 0x800 ${OUTPUT_TARGET_IMAGE}
		rm -f ${target_its_file}
	else
		${STAGING_KERNEL_DIR}/scripts/mkbootimg --kernel ${KERNEL_IMAGE} --ramdisk ${ROOTFS_IMAGE} --second ${KERNEL_DTB} -o ${TARGET_IMAGE}
	fi
	echo "done."
}
	
do_install:append () {
	install -d ${D}
        install -m 0755 ${S}/*.img ${D}/
}

do_deploy () {
	cd ${D}
	install -d ${DEPLOYDIR}
	install "${D}/recovery.img" "${DEPLOYDIR}"
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

FILES:${PN} = "recovery.img"

addtask deploy after do_install before do_fixup_wks
addtask fixup_wks after do_deploy
