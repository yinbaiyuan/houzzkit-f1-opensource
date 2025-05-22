#!/bin/bash

model=$(tr -d '\0' </sys/firmware/devicetree/base/model | tr 'a-z' 'A-Z')

if [[ $model =~ "AIO-3568J" || $model =~ "ITX-3568Q" ]]; then
	count=3
	while [[ $count != 0 ]]; do
		count=$(expr $count - 1)
		if /usr/bin/quectel-simdet -d 0 -f /tmp/quectel-simdet_log; then
			break
		fi
	done
	sleep 1
fi
