#!/bin/bash -e

KERNELS=$(ls | grep kernel- || true)

update_kernel()
{
	# Fallback to current kernel
	RK_KERNEL_VERSION=${RK_KERNEL_VERSION:-$(kernel_version)}

	# Fallback to 5.10 kernel
	RK_KERNEL_VERSION=${RK_KERNEL_VERSION:-5.10}

	# Update .config
	KERNEL_CONFIG="RK_KERNEL_VERSION=\"$RK_KERNEL_VERSION\""
	if ! grep -q "^$KERNEL_CONFIG$" "$RK_CONFIG"; then
		sed -i "s/^RK_KERNEL_VERSION=.*/$KERNEL_CONFIG/" "$RK_CONFIG"
		"$SCRIPTS_DIR/mk-config.sh" olddefconfig &>/dev/null
	fi

	[ "$(kernel_version)" != "$RK_KERNEL_VERSION" ] || return 0

	# Update kernel
	KERNEL_DIR=kernel-$RK_KERNEL_VERSION
	echo "switching to $KERNEL_DIR"
	if [ ! -d "$KERNEL_DIR" ]; then
		echo "$KERNEL_DIR not exist!"
		exit 1
	fi

	rm -rf kernel
	ln -rsf $KERNEL_DIR kernel
}

do_build()
{
	if [ "$DRY_RUN" ]; then
		echo -e "\e[35mCommands of building $1:\e[0m"
	else
		echo "=========================================="
		echo "          Start building $1"
		echo "=========================================="
	fi

	check_config RK_KERNEL_DTS_NAME RK_KERNEL_CFG RK_BOOT_IMG || return 0

	run_command $KMAKE $RK_KERNEL_CFG $RK_KERNEL_CFG_FRAGMENTS

	if [ -z "$DRY_RUN" ]; then
		"$SCRIPTS_DIR/check-kernel.sh"
	fi

	case "$1" in
		kernel-config)
			KERNEL_CONFIG_DIR="kernel/arch/$RK_KERNEL_ARCH/configs"
			run_command $KMAKE menuconfig
			run_command $KMAKE savedefconfig
			run_command mv kernel/defconfig \
				"$KERNEL_CONFIG_DIR/$RK_KERNEL_CFG"
			;;
		kernel*)
			run_command $KMAKE "$RK_KERNEL_DTS_NAME.img"

			# The FIT image for initrd would be packed in rootfs stage
			if [ -n "$RK_BOOT_FIT_ITS" ]; then
				if [ -z "$RK_ROOTFS_INITRD" ]; then
					run_command \
						"$SCRIPTS_DIR/mk-fitimage.sh" \
						"kernel/$RK_BOOT_IMG" \
						"$RK_BOOT_FIT_ITS" \
						"$RK_KERNEL_IMG" \
						"kernel/$RK_RAMDISK_IMG"
				fi
			fi
			;;
		modules) run_command $KMAKE modules ;;
		extboot)
			EXTBOOT_IMG=kernel/extboot.img
			EXTBOOT_DIR=kernel/extboot
			rm -rf ${EXTBOOT_DIR} && mkdir -p ${EXTBOOT_DIR}/extlinux

			run_command $KMAKE "$RK_KERNEL_DTS_NAME.img"
			run_command $KMAKE INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=extboot modules_install

			KERNEL_VERSION=$(cat kernel/include/config/kernel.release)
			echo "label rk-kernel.dtb linux-$KERNEL_VERSION" > $EXTBOOT_DIR/extlinux/extlinux.conf

			cp $RK_KERNEL_IMG $EXTBOOT_DIR/Image-$KERNEL_VERSION
			echo -e "\tkernel /Image-$KERNEL_VERSION" >> $EXTBOOT_DIR/extlinux/extlinux.conf

			cp $RK_KERNEL_DTB $EXTBOOT_DIR
			ln -sf ${RK_KERNEL_DTS_NAME}.dtb $EXTBOOT_DIR/rk-kernel.dtb

			echo -e "\tfdt /rk-kernel.dtb" >> $EXTBOOT_DIR/extlinux/extlinux.conf

			if [[ -e kernel/ramdisk.img ]]; then
			    cp kernel/ramdisk.img $EXTBOOT_DIR/initrd-$KERNEL_VERSION
			    echo -e "\tinitrd /initrd-$KERNEL_VERSION" >> $EXTBOOT_DIR/extlinux/extlinux.conf
			fi

			cp kernel/.config $EXTBOOT_DIR/config-$KERNEL_VERSION
			cp kernel/System.map $EXTBOOT_DIR/System.map-$KERNEL_VERSION
			cp kernel/logo.bmp kernel/logo_kernel.bmp $EXTBOOT_DIR/ || true

			if [ -n "$FF_EXTBOOT_SIZE" ];then
				EXTBOOT_IMG_SIZE=$FF_EXTBOOT_SIZE
			else
				EXTBOOT_IMG_SIZE=128M
			fi

			rm -rf $EXTBOOT_IMG && truncate -s $EXTBOOT_IMG_SIZE $EXTBOOT_IMG
			fakeroot device/rockchip/common/mkfs.ext4 -Fq -L "boot" -d $EXTBOOT_DIR $EXTBOOT_IMG
			;;
	esac
}

# Hooks

usage_hook()
{
	for k in $KERNELS; do
		echo -e "$k[:cmds]               \tbuild kernel ${k#kernel-}"
	done

	echo -e "kernel[:cmds]                    \tbuild kernel"
	echo -e "extboot                          \tbuild extboot"
	echo -e "modules[:cmds]                   \tbuild kernel modules"
	echo -e "linux-headers[:cmds]             \tbuild linux-headers"
	echo -e "kernel-config[:cmds]             \tmodify kernel defconfig"
}

clean_hook()
{
	[ ! -d kernel ] || make -C kernel distclean
}

INIT_CMDS="default $KERNELS"
init_hook()
{
	load_config RK_KERNEL_CFG
	check_config RK_KERNEL_CFG &>/dev/null || return 0

	# Priority: cmdline > custom env > .config > current kernel/ symlink
	if echo $1 | grep -q "^kernel-"; then
		export RK_KERNEL_VERSION=${1#kernel-}
		echo "Using kernel version($RK_KERNEL_VERSION) from cmdline"
	elif [ "$RK_KERNEL_VERSION" ]; then
		export RK_KERNEL_VERSION=${RK_KERNEL_VERSION//\"/}
		echo "Using kernel version($RK_KERNEL_VERSION) from environment"
	else
		load_config RK_KERNEL_VERSION
	fi

	update_kernel
}

PRE_BUILD_CMDS="kernel-config kernel-make kmake"
pre_build_hook()
{
	check_config RK_KERNEL_CFG || return 0

	echo "Toolchain for kernel:"
	echo "${RK_KERNEL_TOOLCHAIN:-gcc}"
	echo

	case "$1" in
		kernel-make | kmake)
			shift
			[ "$1" != cmds ] || shift

			if [ ! -r kernel/.config ]; then
				run_command $KMAKE $RK_KERNEL_CFG \
					$RK_KERNEL_CFG_FRAGMENTS
			fi
			run_command $KMAKE $@
			;;
		kernel-config)
			do_build $@
			;;
	esac

	if [ -z "$DRY_RUN" ]; then
		finish_build $@
	fi
}

pre_build_hook_dry()
{
	DRY_RUN=1 pre_build_hook $@
}

BUILD_CMDS="$KERNELS kernel modules extboot"
build_hook()
{
	check_config RK_KERNEL_DTS_NAME RK_KERNEL_CFG RK_BOOT_IMG || return 0

	echo "Toolchain for kernel:"
	echo "${RK_KERNEL_TOOLCHAIN:-gcc}"
	echo

	if echo $1 | grep -q "^kernel-"; then
		if [ "$RK_KERNEL_VERSION" != "${1#kernel-}" ]; then
			echo -ne "\e[35m"
			echo "Kernel version overrided: " \
				"$RK_KERNEL_VERSION -> ${1#kernel-}"
			echo -ne "\e[0m"
		fi
	fi

	do_build $@

	if [ "$DRY_RUN" ]; then
		return 0
	fi

	if echo $1 | grep -q "^kernel"; then
		ln -rsf "kernel/$RK_BOOT_IMG" "$RK_FIRMWARE_DIR/boot.img"
		local board_array=("rk3568-firefly-aioj" "rk3568-firefly-roc-pc" "rk3568-firefly-itx-3568q" "rk3566-firefly-aiojd4" "rk3566-firefly-roc-pc")
		local board_count=5

		for item in "${board_array[@]}"
		do
			if [[ "$RK_KERNEL_DTS_NAME" == "$item"* ]]; then
				break
			fi
			board_count=$[ $board_count - 1 ]
		done

		if [ $board_count -eq 0 ]; then
			"$SCRIPTS_DIR/check-power-domain.sh"
		fi
	fi

	if [[ $1 == "extboot" ]]; then
		ln -rsf kernel/extboot.img $RK_FIRMWARE_DIR/boot.img
	fi

	finish_build build_$1
}

build_hook_dry()
{
	DRY_RUN=1 build_hook $@
}

POST_BUILD_CMDS="linux-headers"
post_build_hook()
{
	check_config RK_KERNEL_DTS_NAME RK_KERNEL_CFG RK_BOOT_IMG || return 0

	[ "$1" = "linux-headers" ] || return 0
	shift

	[ "$1" != cmds ] || shift
	OUTPUT_FILE="${2:-"$RK_OUTDIR"}/linux-headers.tar"
	mkdir -p "$(dirname "OUTPUT_DIR")"

	HEADER_FILES_SCRIPT=$(mktemp)

	if [ "$DRY_RUN" ]; then
		echo -e "\e[35mCommands of building linux-headers:\e[0m"
	else
		echo "Saving linux-headers to $OUTPUT_FILE"
	fi

	run_command $KMAKE $RK_KERNEL_CFG $RK_KERNEL_CFG_FRAGMENTS
	run_command $KMAKE modules_prepare

	cat << EOF > "$HEADER_FILES_SCRIPT"
{
	# Based on kernel/scripts/package/builddeb
	find . arch/$RK_KERNEL_ARCH -maxdepth 1 -name Makefile\*
	find include -type f -o -type l
	find arch/$RK_KERNEL_ARCH -name module.lds -o -name Kbuild.platforms -o -name Platform
	find \$(find arch/$RK_KERNEL_ARCH -name include -o -name scripts -type d) -type f
	find arch/$RK_KERNEL_ARCH/include Module.symvers -type f
	echo .config
} | tar --no-recursion --ignore-failed-read -T - \
	-cf "$OUTPUT_FILE"
EOF

	run_command cd "$SDK_DIR/kernel"

	cat "$HEADER_FILES_SCRIPT"

	if [ -z "$DRY_RUN" ]; then
		. "$HEADER_FILES_SCRIPT"
	fi

	case "$RK_KERNEL_KBUILD_ARCH" in
		host) run_command tar -uf "$OUTPUT_FILE" scripts tools ;;
		*)
			run_command cd "$RK_KBUILD_DIR/$RK_KERNEL_KBUILD_ARCH"
			run_command cd "linux-kbuild-$RK_KERNEL_VERSION_REAL"
			run_command tar -uf "$OUTPUT_FILE" .
			;;
	esac

	run_command cd "$SDK_DIR"

	rm -f "$HEADER_FILES_SCRIPT"
}

post_build_hook_dry()
{
	DRY_RUN=1 post_build_hook $@
}

source "${BUILD_HELPER:-$(dirname "$(realpath "$0")")/../build-hooks/build-helper}"

case "${1:-kernel}" in
	kernel-config | kernel-make | kmake) pre_build_hook $@ ;;
	kernel* | modules)
		init_hook $@
		build_hook ${@:-kernel}
		;;
	extboot)
		init_hook kernel
		build_hook extboot
		;;
	linux-headers) post_build_hook $@ ;;
	*) usage ;;
esac
