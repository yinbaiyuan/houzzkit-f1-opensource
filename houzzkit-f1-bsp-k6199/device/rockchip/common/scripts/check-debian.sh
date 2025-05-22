#!/bin/bash -e

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname "$(realpath "$0")")}"

if [ ! -e "/usr/share/live/build/data/debian-cd/$RK_DEBIAN_VERSION" ]; then
	echo -e "\e[35m"
	echo "Your live-build doesn't support $RK_DEBIAN_VERSION"
	echo "Please replace it:"
	echo "sudo apt-get remove live-build"
	echo "git clone https://salsa.debian.org/live-team/live-build.git --depth 1 -b debian/1%20230131"
	echo "cd live-build"
	echo "rm -rf manpages/po/"
	echo "sudo make install -j8"
	echo -e "\e[0m"
	exit 1
fi

# The debian SDK's e2fsprogs doesn't support new features like
# metadata_csum_seed and orphan_file
if grep -wq metadata_csum_seed /etc/mke2fs.conf; then
	echo -e "\e[35m"
	echo "Your mke2fs is too new: $(mke2fs -V 2>&1 | head -n 1)"
	echo "Please downgrade it:"
	"$SCRIPTS_DIR/install-e2fsprogs.sh"
	echo -e "\e[0m"
	exit 1
fi
