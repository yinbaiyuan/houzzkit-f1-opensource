#!/bin/bash -e

message() {
	echo -e "\e[36m$@\e[0m"
}

fatal() {
	echo -e "\e[31m$@\e[0m"
	exit 1
}

# Get partition size limit, 0 means unlimited or not exists.
partition_size_kb() {
	PART_SIZE="$(rk_partition_size "$1")"
	echo $(( ${PART_SIZE:-0} / 2))
}

link_image() {
	SRC="$1"
	DST="$2"
	message "Linking $DST from $SRC..."
	ln -rsf "$SRC" "$DST"
}

pack_extra_partitions() {
	for idx in $(seq 1 "$(rk_extra_part_num)"); do
		# Skip built-in partitions
		if rk_extra_part_builtin $idx; then
			continue
		fi

		PART_NAME="$(rk_extra_part_name $idx)"
		FS_TYPE="$(rk_extra_part_fstype $idx)"
		SIZE="$(rk_extra_part_size $idx)"
		FAKEROOT_SCRIPT="$(rk_extra_part_fakeroot_script $idx)"
		OUTDIR="$(rk_extra_part_outdir $idx)"
		DST="$(rk_extra_part_img $idx)"

		if [ -z "$(rk_extra_part_src $idx)" ]; then
			echo "Ignoring $PART_NAME for no sources"
			continue
		fi

		rk_extra_part_prepare $idx

		if [ "$SIZE" = max ]; then
			SIZE="$(partition_size_kb "$PART_NAME")K"
			if [ "$SIZE" = 0K ]; then
				fatal "Unable to detect max size of $PART_NAME"
			fi

			echo "Using maxium size: $SIZE"
		fi

		sed -i '/mk-image.sh/d' "$FAKEROOT_SCRIPT"
		echo "\"$SCRIPTS_DIR/mk-image.sh\" \
			\"$OUTDIR\" \"$DST\" \"$FS_TYPE\" \
			\"$SIZE\" \"$PART_NAME\"" >> "$FAKEROOT_SCRIPT"

		message "Packing $DST from $FAKEROOT_SCRIPT"
		cd "$OUTDIR"
		fakeroot -- "$FAKEROOT_SCRIPT"
		message "Done packing $DST"
	done
}

build_firmware()
{
	if ! which fakeroot &>/dev/null; then
		echo "fakeroot not found! (sudo apt-get install fakeroot)"
		exit 1
	fi

	mkdir -p "$RK_FIRMWARE_DIR" "$RK_SECURITY_FIRMWARE_DIR"
	if [ "$RK_SECURITY" ]; then
		FIRMWARE_DIR="$RK_SECURITY_FIRMWARE_DIR"
	else
		FIRMWARE_DIR="$RK_FIRMWARE_DIR"
	fi

	rm -rf "$RK_ROCKDEV_DIR"
	ln -rsf "$FIRMWARE_DIR" "$RK_ROCKDEV_DIR"

	"$SCRIPTS_DIR/check-grow-align.sh"
	link_image "$CHIP_DIR/$RK_PARAMETER" "$RK_FIRMWARE_DIR/parameter.txt"

	if [ "$RK_MISC_IMG" ]; then
		link_image "$RK_IMAGE_DIR/$RK_MISC_IMG" \
			"$RK_FIRMWARE_DIR/misc.img"
	fi

	pack_extra_partitions

	if [ "$RK_SECURITY" ]; then
		# Link non-security images
		for f in $(ls "$RK_FIRMWARE_DIR/"); do
			if [ -r "$FIRMWARE_DIR/$f" ]; then
				continue
			fi

			link_image "$RK_FIRMWARE_DIR/$f" "$FIRMWARE_DIR/$f"
		done
	fi

	echo "Packed files:"
	for f in "$FIRMWARE_DIR"/*; do
		NAME=$(basename "$f")

		echo -n "$NAME"
		if [ -L "$f" ]; then
			echo -n "($(readlink -f "$f"))"
		fi

		FILE_SIZE=$(ls -lLh $f | xargs | cut -d' ' -f 5)
		echo ": $FILE_SIZE"

		echo "$NAME" | grep -q ".img$" || continue

		# Assert the image's size smaller then the limit
		PART_SIZE_KB="$(partition_size_kb "${NAME%.img}")"
		[ ! "$PART_SIZE_KB" -eq 0 ] || continue

		FILE_SIZE_KB="$(( $(stat -Lc "%s" "$f") / 1024 ))"
		if [ "$PART_SIZE_KB" -lt "$FILE_SIZE_KB" ]; then
			fatal "error: $NAME's size exceed parameter's limit!"
		fi
	done

	message "Images in $FIRMWARE_DIR are ready!"

	finish_build
}

# Hooks

usage_hook()
{
	echo -e "firmware                          \tpack and check firmwares"
}

clean_hook()
{
	rm -rf "$RK_FIRMWARE_DIR" "$RK_SECURITY_FIRMWARE_DIR" "$RK_ROCKDEV_DIR"
}

POST_BUILD_CMDS="firmware"
post_build_hook()
{
	echo "=========================================="
	echo "          Start packing firmwares"
	echo "=========================================="

	build_firmware
}

source "${BUILD_HELPER:-$(dirname "$(realpath "$0")")/../build-hooks/build-helper}"

post_build_hook $@
