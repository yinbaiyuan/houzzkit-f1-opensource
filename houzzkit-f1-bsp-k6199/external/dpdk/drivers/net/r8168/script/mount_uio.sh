#!/bin/bash

DPDK_DIR=./dpdk-20.08
NET_DRIVER_DIR=$DPDK_DIR/drivers/net
SOURCE_DIR=~/rtk_linux_code/DPDK/r8168

echo $DPDK_DIR
echo $NET_DRIVER_DIR
echo $SOURCE_DIR

#mount uio
modprobe uio
insmod "$DPDK_DIR/build/kernel/linux/igb_uio/igb_uio.ko"
ifconfig enp1s0 down
"$DPDK_DIR/usertools/dpdk-devbind.py" -b igb_uio 01:00.0
ifconfig enp2s0 down
"$DPDK_DIR/usertools/dpdk-devbind.py" -b igb_uio 02:00.0

"$DPDK_DIR/usertools/dpdk-devbind.py" --status

#mount huge pages:
mkdir /mnt/huge
mount -t hugetlbfs nodev /mnt/huge
sudo sh -c "echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"

#Check /proc/meminfo to find system hugepage size:
grep "Hugepagesize:" /proc/meminfo

