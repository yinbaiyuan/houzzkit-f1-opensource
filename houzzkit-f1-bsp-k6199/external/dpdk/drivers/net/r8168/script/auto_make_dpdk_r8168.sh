#!/bin/bash

DPDK_DIR=/root/dpdk/dpdk-stable/
NET_DRIVER_DIR=$DPDK_DIR/drivers/net
SOURCE_DIR=/root/dpdk/dpdk-stable/r8168/

echo $DPDK_DIR
echo $NET_DRIVER_DIR
echo $SOURCE_DIR

cp -rf "$SOURCE_DIR" "$NET_DRIVER_DIR"

cd "$DPDK_DIR"
meson build
ninja -C build
cd ..

