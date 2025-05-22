#!/bin/sh
echo "disable and stop ModemManager"
systemctl disable ModemManager
systemctl stop ModemManager
systemctl daemon-reload
