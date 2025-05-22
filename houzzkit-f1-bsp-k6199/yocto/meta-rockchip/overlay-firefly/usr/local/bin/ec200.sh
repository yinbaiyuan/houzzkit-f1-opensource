#!/bin/sh
case "$1" in
  init)
    echo "Init EC200..."
    systemctl disable ModemManager
    systemctl stop ModemManager
    systemctl daemon-reload
    /bin/echo AT+QCFG='usbnet',1 > /dev/ttyUSB2
    /bin/echo AT+QNETDEVCTL=3,1,1 > /dev/ttyUSB2
    ;;
  deinit)
    echo "Deinit EC200..."
    /bin/echo AT+QNETDEVCTL=0,1,1 > /dev/ttyUSB2
    ;;
  *)
    exit 1
    ;;
esac

exit 0
