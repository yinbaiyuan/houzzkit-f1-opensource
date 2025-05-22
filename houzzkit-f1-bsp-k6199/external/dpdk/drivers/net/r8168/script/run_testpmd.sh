#!/bin/bash

DPDK_DIR=./dpdk-20.08
NET_DRIVER_DIR=$DPDK_DIR/drivers/net
SOURCE_DIR=~/rtk_linux_code/DPDK/r8168

echo $DPDK_DIR
echo $NET_DRIVER_DIR
echo $SOURCE_DIR

#run testpmd
"$DPDK_DIR/build/app/dpdk-testpmd" -- -i
