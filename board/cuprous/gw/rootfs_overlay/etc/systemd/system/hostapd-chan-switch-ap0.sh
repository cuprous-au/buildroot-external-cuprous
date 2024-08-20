#!/bin/sh

case "$2" in
  CONNECTED)
    echo "WPA supplicant: connection established - restarting hostapd";
    /bin/systemctl try-restart hostapd@ap0.service
    ;;
  DISCONNECTED)
    echo "WPA supplicant: connection lost - restarting hostapd";
    /bin/systemctl try-restart hostapd@ap0.service
    ;;
esac
