#! /bin/sh
# Fail if wei do not have a mac address for wlan0

MAC_ID=$(cat /sys/class/net/wlan0/address)
if [[ -z "$MAC_ID" ]] || [ $MAC_ID = "00:00:00:00:00:00" ]
then
    exit 1
fi

