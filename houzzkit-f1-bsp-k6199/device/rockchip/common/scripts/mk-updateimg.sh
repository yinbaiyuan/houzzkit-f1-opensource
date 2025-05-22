#!/bin/bash -e

RK_PACK_TOOL_DIR="$SDK_DIR/tools/linux/Linux_Pack_Firmware/rockdev"

gen_package_file()
{
	TYPE="${1:-update}"

	if [ ! -r parameter.txt ]; then
		echo -e "\e[31mparameter.txt is missing\e[0m" >&2
		exit 1
	fi

	echo -e "# NAME\tPATH"
	echo -e "package-file\tpackage-file"
	echo -e "parameter\tparameter.txt"

	[ ! -r MiniLoaderAll.bin ] || echo -e "bootloader\tMiniLoaderAll.bin"

	for part in $(rk_partition_parse_names parameter.txt); do
		if echo $part | grep -q "_b$"; then
			# Not packing *_b partition for ota|sdcard
			case $TYPE in
				ota|sdcard) continue ;;
			esac
		fi

		case $part in
			backup) echo -e "backup\tRESERVED"; continue ;;
			system|system_[ab]) IMAGE=rootfs.img ;;
			*_a) IMAGE="${part%_a}.img" ;;
			*_b) IMAGE="${part%_b}.img" ;;
			*) IMAGE="$part.img" ;;
		esac

		[ ! -r "$IMAGE" ] || echo -e "$part\t$IMAGE"
	done
}

align()
{
	X=$1
	A=$2
	OUT=$(($((${X} + ${A} -1 ))&$((~$((${A}-1))))))
	printf 0x%x ${OUT}
}

resize_rootfs_partition()
{
	if grep -q "rootfs:grow" parameter.txt;then
		:
	else
		echo "Resize rootfs partition"
		FILE_P=$(readlink -f rootfs.img)
		FS_INFO=$(dumpe2fs -h ${FILE_P})
		BLOCK_COUNT=$(echo "${FS_INFO}" | grep "^Block count" | cut -d ":" -f 2 | tr -d "[:blank:]")
		INODE_COUNT=$(echo "${FS_INFO}" | grep "^Inode count" | cut -d ":" -f 2 | tr -d "[:blank:]")
		BLOCK_SIZE=$(echo "${FS_INFO}" | grep "^Block size" | cut -d ":" -f 2 | tr -d "[:blank:]")
		INODE_SIZE=$(echo "${FS_INFO}" | grep "^Inode size" | cut -d ":" -f 2 | tr -d "[:blank:]")
		BLOCK_SIZE_IN_S=$((${BLOCK_SIZE}>>9))
		INODE_SIZE_IN_S=$((${INODE_SIZE}>>9))
		SKIP_BLOCK=70
		EXTRA_SIZE=$(expr 50 \* 1024 \* 2 ) #50M

		FSIZE=$(expr ${BLOCK_COUNT} \* ${BLOCK_SIZE_IN_S} + ${INODE_COUNT} \* ${INODE_SIZE_IN_S} + ${EXTRA_SIZE} + ${SKIP_BLOCK})
		PSIZE=$(align $((${FSIZE})) 512)
		PARA_FILE=$(readlink -f parameter.txt)

		ORIGIN=$(grep -Eo "0x[0-9a-fA-F]*@0x[0-9a-fA-F]*\(rootfs" $PARA_FILE)
		NEWSTR=$(echo $ORIGIN | sed "s/.*@/${PSIZE}@/g")
		OFFSET=$(echo $NEWSTR | grep -Eo "@0x[0-9a-fA-F]*" | cut -f 2 -d "@")
		NEXT_START=$(printf 0x%x $(($PSIZE + $OFFSET)))
		sed -i.orig "s/$ORIGIN/$NEWSTR/g" $PARA_FILE
		sed -i "/^CMDLINE.*/s/-@0x[0-9a-fA-F]*/-@$NEXT_START/g" $PARA_FILE
	fi
}

generate_ffimage(){


	local day=$(date +%y%m%d)
	local os_all="buildroot debian ubuntu UnionTech UniKylin centos"

	local model=$(basename $RK_DEFCONFIG _defconfig)
	local os_mk=$(echo $model | egrep -io ${os_all// /|} || true)
	# Cut model name from the RK_DEFCONFIG name
	[[ -n "$os_mk" ]] && model=$(echo $model | cut -d '_' -f 3)
	IMGNAME=${model^^}

	# Set the string before first "_" in the rootfs file name as the system name
	# OSName_xxxx_vx.x.x.img"
	local rootfs=$(basename $(realpath $IMAGE_DIR/rootfs.img))
	#remove suffix, get string before first "-" or "_"
	local os_name=$(echo ${rootfs%.*} | sed 's/[-_].*//')
	if [[ ${os_name^^} == "ROOTFS" ]] || [[ ${os_name^^} == "SYSTEM" ]]; then
		os_name=${os_mk}
	fi

	[[ -z "$os_name" ]] && os_name="Linux"

	#Uper first letter
	IMGNAME+=_$(echo ${os_name,,} | sed 's/./\u&/')

	local os_mode=$(echo $rootfs | egrep -io "gnome|xfce|minimal|server" || true)
	[[ -n "$os_mode" ]] && IMGNAME+=-$(echo ${os_mode,,} | sed 's/./\u&/')

	os_version=$(echo $rootfs | sed -n 's/.*[-_]\([vV][0-9.a-zA-Z]*\(\-[0-9]\{1,\}\)\{,1\}\)[-_\.].*/\1/p')
	if [[ -z "$os_version" ]]; then
		#get date string in rootfs as rootfs version
		os_version=$(echo $rootfs | sed -n 's/.*[-_]\(20[0-9]\{2,\}[-_.0-9]*\)[-_.].*/\1/p')
	fi
	if [[ -n "$os_version" ]]; then
		os_version=${os_version,,}
		#delete . - _ v
		os_version=${os_version/v/r}
		os_version=$(echo $os_version | sed 's/[-_\.]//g')
		IMGNAME+=-${os_version}
	fi

	local sdk_version=""
	local manifest=$(realpath ${SDK_DIR}/.repo/manifest.xml)
	if [[ -f $manifest ]]; then
		manifest=$(basename $(realpath ${SDK_DIR}/.repo/manifest.xml) .xml)
		sdk_version=$(echo $manifest | sed -n 's/.*[-_]\([vV][0-9.a-zA-Z]*\).*/\1/p')
		IMGNAME+=_${sdk_version}
	fi

	if [ -n "$1" ];then
		IMGNAME+=_${1}
	fi

	IMGNAME+=_${day}.img

	echo -e "File name is \e[36m $IMGNAME\e[0m"
	if [ "$rename" == "0" ];then
		:
	else
		read -t 10 -e -p "Rename the file? [N|y]" ANS || :
		ANS=${ANS:-n}

		case $ANS in
				Y|y|yes|YES|Yes) rename=1;;
				N|n|no|NO|No) rename=0;;
				*) rename=0;;
		esac
	fi

	if [[ ${rename} == "1" ]]; then
		read -e -p "Enter new file name: " -i $IMGNAME newname
		IMGNAME=$newname
	fi

	echo "====== Copying Firmware ======"
	cp $IMAGE_DIR/update.img $OUT_DIR/$IMGNAME

	RK_PRODUCT_MODEL=$model
	if [ -z "$RK_PRODUCT_MODEL" ] ; then
		echo -e "\e[31m WARNNING: RK_PRODUCT_MODEL is empty, set to RK_KERNEL_DTS_NAME !!!\e[0m"
		RK_PRODUCT_MODEL=${RK_KERNEL_DTS_NAME}
	fi

	if command -v ffgenswv.bin > /dev/null ; then
		[ -z "$RK_DRM_VERSION" ] && RK_DRM_VERSION=1
		[[ "${RK_CHIP^^}" == RK356* ]]  && RK_DRM_VERSION=100
		[[ "${RK_CHIP^^}" == RK3588 ]]  && RK_DRM_VERSION=100
		ffgenswv.bin -b ${RK_CHIP^^} \
					-m ${RK_PRODUCT_MODEL^^} \
					-V ${RK_DRM_VERSION} \
					-u $OUT_DIR/$IMGNAME \
					-o $OUT_DIR/ffimage.swv
	fi
}

build_updateimg()
{
	check_config RK_UPDATE || return 0

	TARGET="${1:-$RK_FIRMWARE_DIR/update.img}"
	TYPE="${2:-update}"
	PKG_FILE="${3:-$RK_PACKAGE_FILE}"
	OUT_DIR="$RK_OUTDIR/$TYPE"
	IMAGE_DIR="$OUT_DIR/Image"

	echo "=========================================="
	echo "          Start packing $2 update image"
	echo "=========================================="

	rm -rf "$TARGET" "$OUT_DIR"
	mkdir -p "$IMAGE_DIR"
	cd "$IMAGE_DIR"

	# Prepare images
	ln -rsf "$RK_ROCKDEV_DIR"/* .
	rm -f update.img
	if [ "$TYPE" = sdcard ]; then
		ln -rsf "$RK_IMAGE_DIR/sdupdate-ab-misc.img" misc.img
		ln -rsf "$RK_DATA_DIR/parameter-sdupdate.txt" \
			parameter.txt

		# Not packing rootfs partition for sdcard
		rm -f rootfs.img
	fi

	# Prepare package-file
	if [ "$PKG_FILE" ]; then
		PKG_FILE="$CHIP_DIR/$PKG_FILE"
		if [ ! -r "$PKG_FILE" ]; then
			echo "$PKG_FILE not exists!"
			exit 1
		fi
		ln -rsf "$PKG_FILE" package-file
	else
		echo "Generating package-file for $TYPE :"
		gen_package_file $TYPE > package-file
		cat package-file
	fi

	echo "Packing $TARGET for $TYPE..."

	if [ ! -r MiniLoaderAll.bin ]; then
		echo -e "\e[31mMiniLoaderAll.bin is missing\e[0m"
		exit 1
	fi

	resize_rootfs_partition

	TAG=RK$(hexdump -s 21 -n 4 -e '4 "%c"' MiniLoaderAll.bin | rev)
	"$RK_PACK_TOOL_DIR/afptool" -pack ./ update.raw.img
	"$RK_PACK_TOOL_DIR/rkImageMaker" -$TAG MiniLoaderAll.bin \
		update.raw.img update.img -os_type:androidos

	ln -rsf "$IMAGE_DIR/package-file" "$OUT_DIR"
	ln -rsf "$IMAGE_DIR/update.img" "$OUT_DIR"
	ln -rsf "$IMAGE_DIR/update.img" "$TARGET"

	PARA_FILE=$(readlink parameter.txt)
	if [[ -e $PARA_FILE.orig ]];then
		mv $PARA_FILE.orig $PARA_FILE
	fi

	generate_ffimage

	finish_build build_updateimg $@
}

build_ota_updateimg()
{
	check_config RK_AB_UPDATE || return 0

	echo "Make A/B update image for OTA"

	build_updateimg "$RK_FIRMWARE_DIR/update_ota.img" ota \
		$RK_OTA_PACKAGE_FILE

	finish_build
}

build_sdcard_updateimg()
{
	check_config RK_AB_UPDATE RK_AB_UPDATE_SDCARD || return 0

	echo "Make A/B update image for SDcard"

	build_updateimg "$RK_FIRMWARE_DIR/update_sdcard.img" sdcard

	finish_build
}

build_ab_updateimg()
{
	check_config RK_AB_UPDATE || return 0

	build_ota_updateimg
	build_sdcard_updateimg

	echo "Make A/B update image"

	build_updateimg "$RK_FIRMWARE_DIR/update_ab.img" ab

	finish_build
}

# Hooks

usage_hook()
{
	echo -e "updateimg                         \tbuild update image"
	echo -e "otapackage                        \tbuild A/B OTA update image"
	echo -e "sdpackage                         \tbuild A/B SDcard update image"
}

clean_hook()
{
	rm -rf "$RK_OUTDIR/update"
	rm -rf "$RK_OUTDIR/ota"
	rm -rf "$RK_OUTDIR/sdcard"
	rm -rf "$RK_OUTDIR/ab"
	rm -rf "$RK_FIRMWARE_DIR/*update.img"
}

POST_BUILD_CMDS="updateimg otapackage sdpackage"
post_build_hook()
{
	case "$1" in
		updateimg)
			if [ "$RK_AB_UPDATE" ]; then
				build_ab_updateimg
			else
				build_updateimg
			fi
			;;
		otapackage) build_ota_updateimg ;;
		sdpackage) build_sdcard_updateimg ;;
		*) usage ;;
	esac
}

source "${BUILD_HELPER:-$(dirname "$(realpath "$0")")/../build-hooks/build-helper}"

post_build_hook ${@:-updateimg}
