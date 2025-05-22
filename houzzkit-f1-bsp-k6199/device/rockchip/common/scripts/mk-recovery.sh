#!/bin/bash -e

usage_hook()
{
	echo -e "recovery                          \tbuild recovery"
}

clean_hook()
{
	check_config RK_RECOVERY_CFG || return 0
	rm -rf buildroot/output/$RK_RECOVERY_CFG
	rm -rf "$RK_OUTDIR/recovery"
}

BUILD_CMDS="recovery"
build_hook()
{
	[ -z "$RK_AB_UPDATE" ] || return 0

	check_config RK_RECOVERY_CFG || return 0

	DST_DIR="$RK_OUTDIR/recovery"

	if [ -n "$RK_RECOVERY_RAMDISK" -a -f "$RK_IMAGE_DIR/$RK_RECOVERY_RAMDISK" ]; then
		RECOVERY_RAMDISK="$RK_IMAGE_DIR/$RK_RECOVERY_RAMDISK"
		RECOVERY_BUILDTYPE="prebuilt"
	else
		RECOVERY_RAMDISK="$DST_DIR/rootfs.cpio.gz"
		RECOVERY_BUILDTYPE="buildroot"
	fi

	echo "=========================================="
	echo "          Start building recovery($RECOVERY_BUILDTYPE)"
	echo "=========================================="

	if [ "${RECOVERY_BUILDTYPE}" = "buildroot" ]; then
		/usr/bin/time -f "you take %E to build recovery(buildroot)" \
			"$SCRIPTS_DIR/mk-buildroot.sh" $RK_RECOVERY_CFG "$DST_DIR"
    else
        mkdir -p "$DST_DIR"
	fi

	/usr/bin/time -f "you take %E to pack recovery image" \
		"$SCRIPTS_DIR/mk-ramdisk.sh" "$RECOVERY_RAMDISK" \
		"$DST_DIR/recovery.img" "$RK_RECOVERY_FIT_ITS"
	ln -rsf "$DST_DIR/recovery.img" "$RK_FIRMWARE_DIR"

	finish_build build_recovery
}

source "${BUILD_HELPER:-$(dirname "$(realpath "$0")")/../build-hooks/build-helper}"

build_hook $@
