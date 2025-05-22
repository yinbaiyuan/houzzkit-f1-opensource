#!/bin/bash

# toggle hdmi to enable frame buffer device

drm_base=/sys/class/drm
hdmi_status=$drm_base/card0-HDMI-A-1/status

if ! grep "^connected" $drm_base/card0-*/status >/dev/null; then
	if [ -f $hdmi_status ]; then
		echo on > $hdmi_status

		for n in $(seq 10); do
			[ -c /dev/fb0 ] && break
			sleep 1
		done

		echo detect > $hdmi_status
	fi
fi

echo "DRM setup:  Completed" > /dev/kmsg

