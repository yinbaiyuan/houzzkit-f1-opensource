#!/bin/bash

vendor_id=VENDOR_CUSTOM_ID_20
switch_dir=/sys/class/leds/firefly\:rs232_485_switch\:user/brightness
status_str=$1

read_vendor_storage () {
	local value
	value=$(vendor_storage -r $vendor_id 2>&1 | sed -n 's/ 0000-000f: \([0-f]\{2\}\).*/0x\1/p; s/.*read error.*/-1/p')
	value=$(printf '%d' $value)
	echo $value
}

write_vendor_storage () {
	local value=$1

	if [[ ! $value || $value -ge 255 ]]; then
		value=ff
	else
		value=$(printf '%-.2x' $value)
	fi
	vendor_storage -w $vendor_id -t hex -i $value &>/dev/null
	echo $?
}

if [ ! -w $switch_dir ]; then
	echo "$switch_dir does not exist or cannot be written"
	exit 1
fi

if [ ! $status_str ]; then
	ret=$(read_vendor_storage)
	if [ $ret -eq -1 ]; then
		write_vendor_storage $(cat $switch_dir)
	else
		echo $ret > $switch_dir
	fi

elif [ $status_str = "off" ]; then
	ret=$(write_vendor_storage 0)
	if [ $ret -ne 0 ]; then
		echo "Error writing to disk, return $ret"
		exit $ret
	fi

	echo 0 > $switch_dir
elif [ $status_str = "on" ]; then
	ret=$(write_vendor_storage 255)
	if [ $ret -ne 0 ]; then
		echo "Error writing to disk, return $ret"
		exit $ret
	fi

	echo 255 > $switch_dir
elif [ $status_str = "status" ]; then
	ret=$(cat $switch_dir)
	if [ $ret -eq 0 ]; then
		echo The current status is off
	else
		echo The current status is on
	fi

	if [ $ret -ne $(read_vendor_storage) ]; then
		ret=$(write_vendor_storage $ret)
	fi
else
	echo "uart-switch: invalid option -- '$status_str'"
	echo "Usage: uart-switch [on|off|status| ]"
fi

exit 0
