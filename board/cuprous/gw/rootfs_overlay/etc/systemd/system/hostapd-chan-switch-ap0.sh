#!/bin/sh

case "$2" in
  CONNECTED)
    echo "WPA supplicant: connection established - assigning the same channel for the AP";
    # Use the current frequency in our config if the wlan0 is connected
    CURRENT_CHANNEL=$(/sbin/iwlist wlan0 channel | grep "Current Frequency" | grep -Eo '[0-9]+')
    if [ $? -eq 0 ]; then
      CURRENT_CHANNEL=$(echo "$CURRENT_CHANNEL" | tail -1)
      sed -i -e "s/^channel=.*/channel=${CURRENT_CHANNEL}/" /etc/hostapd/hostapd-ap0.conf
      /bin/systemctl try-restart hostapd@ap0.service
    fi
    ;;
  DISCONNECTED)
    echo "WPA supplicant: connection lost";
    ;;
esac
