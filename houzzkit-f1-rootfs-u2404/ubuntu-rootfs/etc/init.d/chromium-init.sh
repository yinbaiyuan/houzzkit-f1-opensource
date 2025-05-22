#!/bin/sh
### BEGIN INIT INFO
# Provides:          chromium browser initial script
# Required-Start:
# Required-Stop:
# Should-Start:      mountvirtfs
# Should-stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Custom initial script for chromium browser
### END INIT INFO

print_rkmpp_dec() {
	case "$(cat /proc/device-tree/compatible)" in
	*rk3588*)
		echo "type=dec"
		echo "codecs=VP8:VP9:H.264:H.265"
		echo "max-width=7680"
		echo "max-height=4320"
		;;
	*rk3568*)
		echo "type=dec"
		echo "codecs=VP8:VP9:H.264:H.265"
		echo "max-width=3840"
		echo "max-height=2160"
		;;
	*)
		echo "dec" ;;
	esac
}

print_rkmpp_enc() {
	echo "enc"
}

# Create dummy video node for V4L2 VDA/VEA with rkmpp plugin
print_rkmpp_dec > /dev/video-dec0
chown root:video /dev/video-dec0
chmod 0660 /dev/video-dec0

print_rkmpp_enc > /dev/video-enc0
chown root:video /dev/video-enc0
chmod 0660 /dev/video-enc0

exit 0
