#!/bin/sh

set -e

case "$1" in
  upgrade)
    if dpkg --compare-versions "$2" lt "551-1~"; then
      update-alternatives --quiet --remove pager /bin/less
    fi
  ;;
  install|abort-upgrade)
  ;;
  *)
    echo "preinst called with unknown argument \`$1'" >&2
    exit 0
  ;;
esac



exit 0
