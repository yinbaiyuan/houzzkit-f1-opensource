#!/bin/bash

DPDK_DIR=./dpdk-20.08
NET_DRIVER_DIR=$DPDK_DIR/drivers/net
SOURCE_DIR=~/rtk_linux_code/DPDK/r8168
PKTGEN_DIR=./pktgen-dpdk

echo $DPDK_DIR
echo $NET_DRIVER_DIR
echo $SOURCE_DIR
echo $PKTGEN_DIR

#run pktgen
"$PKTGEN_DIR/Builddir/app/pktgen" -l 0-2 --  -P -T -m "1.0, 2.1"

