#!/bin/bash -e

source "${POST_HELPER:-$(dirname "$(realpath "$0")")/../post-hooks/post-helper}"

install_overlay()
{
	OVERLAY="$1"

	[ -d "$OVERLAY" ] || return 0

	if [ -x "$OVERLAY/install.sh" ]; then
		echo "Handling overlay: $OVERLAY..."
		"$OVERLAY/install.sh" "$TARGET_DIR" "$POST_OS"
	else
		echo "Installing overlay: $OVERLAY to $TARGET_DIR..."
		rsync -av --chmod=u=rwX,go=rX "$OVERLAY/" "$TARGET_DIR/"
	fi
}

cd "$SDK_DIR"

install_overlay "$COMMON_DIR/overlays/overlay-$POST_OS"

# No extra overlays for non-rootfs
[ "$POST_ROOTFS" ] || exit 0

for overlay in $RK_ROOTFS_OVERLAY_DIRS; do
	install_overlay "$overlay"
done

# Handle extra fonts
if [ -z "$RK_EXTRA_FONTS_DISABLED" ]; then
	if [ "$RK_EXTRA_FONTS_DEFAULT" -a "$POST_OS" != yocto ]; then
		echo -e "\e[33mNo extra fonts for $POST_OS by default\e[0m"
	else
		install_overlay "$COMMON_DIR/overlays/overlay-fonts"
	fi
fi

# Handle prebuilt tools
if [ "$RK_ROOTFS_PREBUILT_TOOLS" ]; then
	install_overlay "$COMMON_DIR/overlays/overlay-tools"
fi
