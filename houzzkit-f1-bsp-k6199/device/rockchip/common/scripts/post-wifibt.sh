#!/bin/bash -e

POST_ROOTFS_ONLY=1

source "${POST_HELPER:-$(dirname "$(realpath "$0")")/../post-hooks/post-helper}"

echo "Building Wifi/BT module and firmwares..."

"$SCRIPTS_DIR/mk-wifibt.sh" "$TARGET_DIR"
