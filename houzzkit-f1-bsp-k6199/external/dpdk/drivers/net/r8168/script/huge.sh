#!/bin/bash

modprobe uio
insmod /home/xing/dpdk/dpdk-19.11-r8168/x86_64-native-linux-gcc/kmod/igb_uio.ko

#ifconfig enp3s0 down
./usertools/dpdk-devbind.py -b igb_uio 03:00.0
#ifconfig enp4s0 down
#./usertools/dpdk-devbind.py -b igb_uio 04:00.0

sudo sh -c "echo 300 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages"
#sudo mkdir /mnt/huge
sudo mount -t hugetlbfs nodev /mnt/huge

