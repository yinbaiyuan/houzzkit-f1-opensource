#!/bin/bash

trap 'onCtrlC' INT
function onCtrlC () {
	echo 'Ctrl+C is captured'
	killall gst-launch-1.0
	exit 0
}

device_id=$(v4l2-ctl --list-devices | grep -A1 hdmirx | grep -v hdmirx | awk -F ' ' '{print $NF}')
v4l2-ctl -d $device_id --set-dv-bt-timings query 2>&1 > /dev/null
width=$(v4l2-ctl -d $device_id --get-dv-timings | grep "Active width" |awk -F ' ' '{print $NF}')
heigh=$(v4l2-ctl -d $device_id --get-dv-timings | grep "Active heigh" |awk -F ' ' '{print $NF}')
format=$(v4l2-ctl -d $device_id -V -D | grep "Pixel Format" | cut -d ':' -f 2 | cut -d "'" -f 2)
status=$(cat /sys/class/hdmirx/hdmirx/status)

if [ "$status" = "disconnected" ]; then
	echo "Please connect a device to the HDMI-IN port."
	exit 1
fi

echo "HDMI-In info:"
echo "-------------------------"
echo "    device: $device_id"
echo "     width: $width"
echo "     heigh: $heigh"
echo "    format: $format"
echo ""

rt5616_card=$(aplay -l | grep "rt5616" | cut -d ':' -f 1 | cut -d ' ' -f 2)
hdmi0_card=$(aplay -l | grep "hdmi0" | cut -d ':' -f 1 | cut -d ' ' -f 2)
hdmi1_card=$(aplay -l | grep "hdmi1" | cut -d ':' -f 1 | cut -d ' ' -f 2)
hdmiin_card=$(arecord -l | grep "hdmiin" | cut -d ":" -f 1 | cut -d ' ' -f 2)

[ -e /usr/lib/aarch64-linux-gnu/libGLdispatch.so.0 ] && \
        export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libGLdispatch.so.0:$LD_PRELOAD

case $format in
NV12)
	if [ -e /run/user/1000/wayland-0.lock ];then
		echo "# wayland"
		sink=glimagesink
	else
		echo "# x11"
		sink=xvimagesink
	fi
	echo "  ${sink}"
	DISPLAY=:0.0 gst-launch-1.0 v4l2src device=${device_id} ! video/x-raw,format=${format},width=${width},height=${heigh},framerate=60/1 \
		! queue ! ${sink} 2>&1 > /dev/null &
	;;
BGR3)
	sink=glimagesink
	DISPLAY=:0.0 gst-launch-1.0 v4l2src device=${device_id} ! video/x-raw,format=BGR,width=${width},height=${heigh},framerate=60/1 \
		! queue ! ${sink} 2>&1 > /dev/null &
	;;
*)
	sink=glimagesink
	echo "Warning: the pixel format is not NV12 or BGR3, possible poor performance."
	DISPLAY=:0.0 gst-launch-1.0 v4l2src device=${device_id} ! video/x-raw,format=${format},width=${width},height=${heigh},framerate=15/1 \
		! videoconvert ! video/x-raw,width=${width},height=${heigh},format=NV12,framerate=15/1 ! queue ! ${sink} 2>&1 > /dev/null &
	;;
esac

gst-launch-1.0 alsasrc device=hw:${hdmiin_card},0 ! audioconvert ! audioresample ! queue \
	! tee name=t ! queue ! alsasink device="hw:${hdmi0_card},0" \
	t. ! queue ! alsasink device="hw:${rt5616_card},0" &

while true
do
	sleep 10
done
