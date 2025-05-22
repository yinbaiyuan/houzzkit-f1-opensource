#!/bin/bash

DPDK_DIR=./dpdk-20.08
#DPDK_DIR=./dpdk
NET_DRIVER_DIR=$DPDK_DIR/drivers/net
SOURCE_DIR=~/rtk_linux_code/DPDK/r8168
PKTGEN_DIR=./pktgen-dpdk
PKTGEN_BUILD_DIR=Builddir

echo $DPDK_DIR
echo $NET_DRIVER_DIR
echo $SOURCE_DIR

cp -rf "$SOURCE_DIR" "$NET_DRIVER_DIR"

cd "$DPDK_DIR"
meson build
ninja -C build
sudo ninja -C build install
sudo ldconfig  # make sure ld.so is pointing new DPDK libraries
export PKG_CONFIG_PATH=/usr/local/lib/x86_64-linux-gnu/pkgconfig
cd ..
cd "$PKTGEN_DIR"

#meson setup --wipe $PKTGEN_BUILD_DIR
rm -rf $PKTGEN_BUILD_DIR
make
#meson -Dbuildtype=debug -Denable_lua=false -Denable_gui=false $PKTGEN_BUILD_DIR
ninja -C $PKTGEN_BUILD_DIR
cd ..

