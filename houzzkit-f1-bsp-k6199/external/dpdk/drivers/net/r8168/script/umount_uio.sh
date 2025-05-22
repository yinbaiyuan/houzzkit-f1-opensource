#!/bin/bash

DPDK_DIR=./dpdk-20.08
NET_DRIVER_DIR=$DPDK_DIR/drivers/net
SOURCE_DIR=~/rtk_linux_code/DPDK/r8168

echo $DPDK_DIR
echo $NET_DRIVER_DIR
echo $SOURCE_DIR

#unmount uio
"$DPDK_DIR/usertools/dpdk-devbind.py" -u 01:00.0
"$DPDK_DIR/usertools/dpdk-devbind.py" -u 02:00.0
rmmod "$DPDK_DIR/build/kernel/linux/igb_uio/igb_uio.ko"

