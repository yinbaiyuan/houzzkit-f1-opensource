#!/bin/bash

# Copyright (C) Guangzhou FriendlyARM Computer Tech. Co., Ltd.
# (http://www.friendlyarm.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, you can access it online at
# http://www.gnu.org/licenses/gpl-2.0.html.

trap 'onCtrlC' INT
function onCtrlC () {
    echo 'Ctrl+C is captured'
    killall gst-launch-1.0
    exit 0
}

# ----------------------------------------------------------
# base setup

file="/home/pi/Videos/demo.mp4"
adev="1"
vsnk="waylandsink"

#----------------------------------------------------------
usage()
{
	echo "Usage: $0 [ARGS]"
	echo
	echo "Options:"
	echo "  -h                 show this help message and exit"
	echo "  -f <media file>    *"
	echo "  -J, --jack"
	echo "  --fps              show fps"
	echo "  -H, --hdmi"
	echo
	exit 1
}

parse_args()
{
	TEMP=`getopt -o "f:JHxh" --long "jack,hdmi,fps" -n "$SELF" -- "$@"`
	if [ $? != 0 ] ; then exit 1; fi
	eval set -- "$TEMP"

	init_adev
	local showfps=0
	while true; do
		case "$1" in
			-f ) file=$(readlink -f $2); shift 2;;
			-J|--jack) adev=$CARD_RT5651; shift 1;;
			-H|--hdmi) adev=$CARD_HDMI; shift 1;;
			-x ) vsnk="rkximagesink"; shift 1;;
			--fps) showfps=1; shift 1;;
			-h ) usage; exit 1 ;;
			-- ) shift; break ;;
			*  ) echo "invalid option $1"; usage; return 1 ;;
		esac
	done
	if [ $showfps -eq 1 ]; then
		vsnk="fpsdisplaysink video-sink=$vsnk"
	fi
}

init_adev()
{
	if grep rt5651 /proc/asound/card0/id >/dev/null 2>&1; then
		CARD_RT5651="0"; CARD_HDMI="1"
	else
		CARD_RT5651="1"; CARD_HDMI="0"
	fi
}

#----------------------------------------------------------
SELF=$0
parse_args $@

if [ -f ${file} ]; then
	echo "Playing ${file} [card${adev}] ..."
else
	echo "Error: ${file}: No such file"
	exit -1
fi



#----------------------------------------------------------

GSTC="gst-launch-1.0 uridecodebin uri=file://${file} name=decoder \
decoder. ! queue ! ${vsnk} \
decoder. ! queue ! audioconvert ! pipewiresink"


echo "# The following command will be executed:"
echo "# ---------------------------"
if echo "$vsnk" | grep -q "waylandsink"; then
    true ${display:="wayland-0"}
	export WAYLAND_DISPLAY=$display
	echo "export WAYLAND_DISPLAY=$display"
else
    true ${display:=":0.0"}
	export DISPLAY=$display
	echo "export DISPLAY=$display"
fi

if [ "$(id -un)" = "pi" ]; then
	echo "eval \"${GSTC}\""
	echo "# ---------------------------"
	eval "${GSTC}" &
else
	echo "su pi -c \"${GSTC}\""
	echo "# ---------------------------"
	su pi -c "${GSTC}" &
fi

while true
do
    sleep 10
done
