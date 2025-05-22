#!/bin/bash
#
# Copyright (c) 2022 FriendlyElec Computer Tech. Co., Ltd.
# (http://www.friendlyelec.com)
#

# wait up to 3 seconds for the r8125 device ready
seconds="3"

function get_r8125_devs() {
	local ifname

	for d in /sys/class/net/*; do
		[ -e $d/device/uevent ] || continue
		if grep "^DRIVER=r8125" $d/device/uevent >/dev/null; then
			ifname=$(basename $d)
			while true; do
				[ -d /proc/net/r8125/${ifname} ] && break
				[ "${seconds}" -le 0 ] && break
				seconds="$(( seconds - 1 ))"
				sleep 1
			done

			printf "${ifname} "
		fi
	done
}

function get_device_irq() {
	local device="$1"

	local line=$(grep -m 1 "${device}\$" /proc/interrupts)
	echo ${line} | sed 's/:.*//'
}

function set_interface_core() {
	local core_mask="$1"
	local interface="$2"
	local device="$3"

	[ -z "${device}" ] && device="$interface"

	local irq=$(get_device_irq "$device")
	[ -z "$irq" ] && return 0

	echo -n "${core_mask}" > /proc/irq/${irq}/smp_affinity
}

function set_interface_rps() {
	local rps="$1"
	local interface="$2"
	local queue="$3"

	local node=/sys/class/net/${interface}/queues/rx-${queue}/rps_cpus
	[ -f "$node" ] || return 0

	echo "${rps}" > ${node}
}

function setup_net_smp4() {
	local ETH

	ETH=$1; [ -z "${ETH}" ] && return
	set_interface_core 2 "${ETH}-0"
	set_interface_core 4 "${ETH}-16"
	set_interface_core 4 "${ETH}-18"
	set_interface_rps "b" ${ETH} 0

	ETH=$2; [ -z "${ETH}" ] && return
	set_interface_core 4 "${ETH}-0"
	set_interface_core 2 "${ETH}-16"
	set_interface_core 2 "${ETH}-18"
	set_interface_rps "d" ${ETH} 0
}

function setup_net_smp8() {
	local ETH

	ETH=$1; [ -z "${ETH}" ] && return
	set_interface_core 2 "${ETH}-0"
	set_interface_core 4 "${ETH}-16"
	set_interface_core 4 "${ETH}-18"
	set_interface_rps "fe" ${ETH} 0

	ETH=$2; [ -z "${ETH}" ] && return
	set_interface_core 4 "${ETH}-0"
	set_interface_core 2 "${ETH}-16"
	set_interface_core 2 "${ETH}-18"
	set_interface_rps "fe" ${ETH} 0
}

function show_irq_affinity() {
	local irq=$(get_device_irq "$1")
	[ -z "$irq" ] && return 0

	local aff=$(cat /proc/irq/${irq}/smp_affinity)
	echo "/proc/irq/${irq}/smp_affinity  ${aff}"
}

function show_rps_cpus() {
	local sysp="/sys/class/net/$1/queues/rx-$2/rps_cpus"

	[ -f "$sysp" ] || return 0

	echo -n "$sysp  "
	cat $sysp
}

function print_net_smp() {
	[ -z "$1" ] && return 0

	for n in $(seq 0 7); do
		show_rps_cpus $1 $n
	done

	show_irq_affinity "${1}-0"
	show_irq_affinity "${1}-1"
	show_irq_affinity "${1}-2"
	show_irq_affinity "${1}-3"
	show_irq_affinity "${1}-16"
	show_irq_affinity "${1}-18"
}

# ---------------------------------------------------------

if [ "${1,,}" = "up" ]; then
	r8125_dev=$(get_r8125_devs)
	if [ $(nproc) -eq 8 ]; then
		setup_net_smp8 ${r8125_dev}
	else
		setup_net_smp4 ${r8125_dev}
	fi
fi
