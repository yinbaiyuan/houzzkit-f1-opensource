# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

inherit python3-dir

DEPENDS:append = " openssl-native lz4-native ${PYTHON_PN}-native coreutils-native e2fsprogs-native"

LINUX_VERSION_EXTENSION ?= "-rockchip-${LINUX_KERNEL_TYPE}"

PATCHPATH = "${THISDIR}/${BPN}_${LINUX_VERSION}"
inherit auto-patch

KCONFIG_MODE ?= "--alldefconfig"

# Make sure we use /usr/bin/env ${PYTHON_PN} for scripts
do_patch:append() {
	for s in `grep -rIl python ${S}/scripts`; do
		sed -i -e '1s|^#!.*python[23]*|#!/usr/bin/env ${PYTHON_PN}|' $s
	done

	cp ${STAGING_KERNEL_DIR}/ramdisk.img ${B}/

	#Copy some files needed by the firefly kernel
	if [ -f "${STAGING_KERNEL_DIR}/drivers/spi/spi-wk2xxx_64bit" ];then
		install -d ${B}/drivers/spi/
		install ${STAGING_KERNEL_DIR}/drivers/spi/spi-wk2xxx_64bit ${B}/drivers/spi/
	fi

	if [ -f "${STAGING_KERNEL_DIR}/drivers/spi/spi-wk2xxx_32bit" ];then
		install -d ${B}/drivers/spi/
		install ${STAGING_KERNEL_DIR}/drivers/spi/spi-wk2xxx_32bit ${B}/drivers/spi/
	fi

	if [ -f "${STAGING_KERNEL_DIR}/drivers/char/virtd" ];then
		install -d ${B}/drivers/char/
		install ${STAGING_KERNEL_DIR}/drivers/char/virtd ${B}/drivers/char/
	fi

	if [ -f "${STAGING_KERNEL_DIR}/drivers/mmc/core/mmc_blk_data" ];then
		install -d ${B}/drivers/mmc/core/
		install ${STAGING_KERNEL_DIR}/drivers/mmc/core/mmc_blk_data ${B}/drivers/mmc/core/
	fi

	if [ -d "${STAGING_KERNEL_DIR}/drivers/net/wireless/rockchip_wlan/rtl8821cu" ];then
		install -d ${B}/drivers/net/wireless/rockchip_wlan/
		cp -rf ${STAGING_KERNEL_DIR}/drivers/net/wireless/rockchip_wlan/rtl8821cu ${B}/drivers/net/wireless/rockchip_wlan/
	fi

	if [ -d "${STAGING_KERNEL_DIR}/drivers/net/wireless/rtl8852be" ];then
		install -d ${B}/drivers/net/wireless/
		cp -rf ${STAGING_KERNEL_DIR}/drivers/net/wireless/rtl8852be ${B}/drivers/net/wireless/
	fi

	if [ -d "${STAGING_KERNEL_DIR}/drivers/net/wireless/rockchip_wlan/rtl8822ce" ];then
		install -d ${B}/drivers/net/wireless/rockchip_wlan/
		cp -rf ${STAGING_KERNEL_DIR}/drivers/net/wireless/rockchip_wlan/rtl8822ce ${B}/drivers/net/wireless/rockchip_wlan/
	fi

	# use asm-generic types.h instead of arm64 types.h to fix compile problem
	if [ -f "${STAGING_KERNEL_DIR}/include/uapi/asm-generic/types.h" ];then
		install -d ${B}/arch/arm64/include/generated/uapi/asm/
		cp -rf ${STAGING_KERNEL_DIR}/include/uapi/asm-generic/types.h ${B}/arch/arm64/include/generated/uapi/asm/
	fi

	if [ -f "${STAGING_KERNEL_DIR}/*.bmp" ];then
		cp -rf ${STAGING_KERNEL_DIR}/"*.bmp" ${B}/
	fi

	# #Copy the header files needed by mail
	# install -d ${B}/drivers/gpu/arm/mali400/mali/
	# cp -rf ${STAGING_KERNEL_DIR}/drivers/gpu/arm/mali400/mali/include ${B}/drivers/gpu/arm/mali400/mali/
}

do_compile:prepend() {
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${STAGING_LIBDIR_NATIVE}
}

do_compile_kernelmodules:prepend() {
        export PKG_CONFIG_DIR="${STAGING_DIR_NATIVE}${libdir_native}/pkgconfig"
        export PKG_CONFIG_PATH="$PKG_CONFIG_DIR:${STAGING_DATADIR_NATIVE}/pkgconfig"
        export PKG_CONFIG_LIBDIR="$PKG_CONFIG_DIR"
        export PKG_CONFIG_SYSROOT_DIR=""
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${STAGING_LIBDIR_NATIVE}
}

do_compile:prepend() {
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${STAGING_LIBDIR_NATIVE}
}

do_compile_kernelmodules:prepend() {
	export PKG_CONFIG_DIR="${STAGING_DIR_NATIVE}${libdir_native}/pkgconfig"
	export PKG_CONFIG_PATH="$PKG_CONFIG_DIR:${STAGING_DATADIR_NATIVE}/pkgconfig"
	export PKG_CONFIG_LIBDIR="$PKG_CONFIG_DIR"
	export PKG_CONFIG_SYSROOT_DIR=""
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${STAGING_LIBDIR_NATIVE}
}

# Hack for rockchip style images
KERNEL_IMAGETYPES:append = \
	"${@' boot.img zboot.img' if d.getVar('ROCKCHIP_KERNEL_IMAGES') == '1' else ''}"
python () {
    if not d.getVar('KERNEL_DEVICETREE'):
        raise bb.parse.SkipPackage('KERNEL_DEVICETREE is not specified!')

    if d.getVar('ROCKCHIP_KERNEL_IMAGES'):
        # Use rockchip stype target, which is '<dts(w/o suffix)>.img'
        d.setVar('KERNEL_IMAGETYPE_FOR_MAKE', ' ' + d.getVar('KERNEL_DEVICETREE').replace('rockchip/', '').replace('.dtb', '.img'));
}

do_kernel_metadata:prepend() {
	# Force regenerating defconfig
	rm -f ${WORKDIR}/defconfig

	# Support defconfig fragments
	cd "${S}/arch/${ARCH}/configs"
#	if [ ! -f "${KBUILD_DEFCONFIG}" ]; then
#		DEFCONFIGS="rockchip_linux_defconfig ${RK_SOC_FAMILY}_linux.config"
#		[ "$KBUILD_DEFCONFIGS" ] || KBUILD_DEFCONFIGS="$DEFCONFIGS"
#
#		echo "Merging $KBUILD_DEFCONFIGS into $KBUILD_DEFCONFIG..."
#		cat ${KBUILD_DEFCONFIGS:-$CONFIGS} > ${KBUILD_DEFCONFIG} || true
#	fi

	if [ -n "${KBUILD_DEFCONFIGS}" ]; then
		echo "Merging ${KBUILD_DEFCONFIGS} into ${KBUILD_DEFCONFIG}..."
		cat ${KBUILD_DEFCONFIGS} > ${KBUILD_DEFCONFIG} || true
	fi
	cd -
}

# Link rockchip style images
do_install:prepend() {
	for image in $(ls "${B}/" | grep ".img$"); do
		ln -rsf ${B}/${image} ${B}/arch/${ARCH}/boot/
	done

	if [ "${ROCKCHIP_KERNEL_COMPRESSED}" = "1" ]; then
### extboot
		if [ -n "${FF_EXTBOOT}" ]; then
			RK_KERNEL_IMG="${B}/arch/arm64/boot/Image"
			echo "KERNEL_DEVICETREE is ${KERNEL_DEVICETREE}"
			RK_KERNEL_DTS="$(echo "${KERNEL_DEVICETREE}" | sed 's/rockchip\///')"
			RK_KERNEL_DTS="$(echo "${RK_KERNEL_DTS}" | sed 's/\.dtb//')"

			EXTBOOT_IMG="${B}/extboot.img"
			EXTBOOT_DIR="${B}/extboot"

			rm -rf ${EXTBOOT_DIR} && mkdir -p ${EXTBOOT_DIR}/extlinux

			KERNEL_VERSION=$(cat ${B}/include/config/kernel.release)
			echo "label rk-kernel.dtb linux-$KERNEL_VERSION" > ${EXTBOOT_DIR}/extlinux/extlinux.conf

			cp ${RK_KERNEL_IMG} ${EXTBOOT_DIR}/Image-${KERNEL_VERSION}
			echo "\tkernel /Image-${KERNEL_VERSION}" >> ${EXTBOOT_DIR}/extlinux/extlinux.conf

			# need to set $RK_PRODUCT_MODEL path
			if [ -f ${RK_PRODUCT_MODEL_PATH}/.${RK_PRODUCT_MODEL} ];then
				dtblist=$(cat ${RK_PRODUCT_MODEL_PATH}/.${RK_PRODUCT_MODEL})
				for i in ${dtblist}
				do
					if [ "${ARCH}" = "arm64" ];then
						make ARCH=${ARCH} rockchip/${i}.dtb
						cp ${B}/arch/${ARCH}/boot/dts/rockchip/${i}.dtb ${EXTBOOT_DIR}
					else
						make ARCH=${ARCH} ${i}.dtb
						cp ${B}/arch/${ARCH}/boot/dts/${i}.dtb ${EXTBOOT_DIR}
					fi
				done
			fi

			if [ "${ARCH}" = "arm64" ];then
				cp ${B}/arch/${ARCH}/boot/dts/rockchip/${RK_KERNEL_DTS}.dtb ${EXTBOOT_DIR}
			else
				cp ${B}/arch/${ARCH}/boot/dts/${RK_KERNEL_DTS}.dtb ${EXTBOOT_DIR}
			fi

			ln -sf ${RK_KERNEL_DTS}.dtb ${EXTBOOT_DIR}/rk-kernel.dtb

			echo "\tfdt /rk-kernel.dtb" >> ${EXTBOOT_DIR}/extlinux/extlinux.conf

			if [ -f "${B}/ramdisk.img" ]; then
				cp ${B}/ramdisk.img ${EXTBOOT_DIR}/initrd-${KERNEL_VERSION}
				echo "\tinitrd /initrd-${KERNEL_VERSION}" >> ${EXTBOOT_DIR}/extlinux/extlinux.conf
			fi

			cp ${B}/.config ${EXTBOOT_DIR}/config-${KERNEL_VERSION}
			cp ${B}/System.map ${EXTBOOT_DIR}/System.map-${KERNEL_VERSION}
			cp ${B}/*.bmp ${EXTBOOT_DIR}/ || true

			make ARCH=${ARCH} INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=${EXTBOOT_DIR} modules_install

			if [ -n "${FF_EXTBOOT_SIZE}" ];then
				EXTBOOT_IMG_SIZE=${FF_EXTBOOT_SIZE}
			else
				EXTBOOT_IMG_SIZE=128M
			fi

			rm -rf ${EXTBOOT_IMG} && ${RECIPE_SYSROOT_NATIVE}/usr/bin/truncate -s ${EXTBOOT_IMG_SIZE} ${EXTBOOT_IMG}

			${FAKEROOTCMD} ${RECIPE_SYSROOT_NATIVE}/sbin/mkfs.ext4 -Fq -L "boot" -d ${EXTBOOT_DIR} ${EXTBOOT_IMG}

			ln -rsf ${EXTBOOT_IMG} ${B}/arch/${ARCH}/boot/boot.img

### extboot end
		elif [ -r "${B}/zboot.img" ]; then
			ln -rsf ${B}/zboot.img ${B}/arch/${ARCH}/boot/boot.img
		fi
	fi
}
