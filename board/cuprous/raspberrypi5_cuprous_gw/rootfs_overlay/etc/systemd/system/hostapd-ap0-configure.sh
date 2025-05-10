#! /bin/sh
# Configure hostapd with an SSID and passphase in relation to our WiFi's mac address.

# Indicate we're doing something
/etc/systemd/system/hostapd-ap0-led-show-starting.sh

# Assign our SSID and password based on our MAC address
MAC_ID=$(cat /sys/class/net/wlan0/address | tr -d ':' | tail -c5)
sed -i -e "s/^ssid=.*/ssid=Cuprous-${MAC_ID}/" /etc/hostapd/hostapd-ap0.conf
sed -i -e "s/^wpa_passphrase=.*/wpa_passphrase=${MAC_ID}${MAC_ID}/" /etc/hostapd/hostapd-ap0.conf

# We configure ap0 to have the same channel as wlan0 if it is active, or back
# to a sensible default if not.
CHANNEL=$(cat /sys/class/net/wlan0/carrier)
if [ $? -eq 1 ]; then
    CHANNEL=$(/sbin/iw wlan0 info | grep "channel" | grep -Eo '[0-9]+' | head -1)
else
    CHANNEL=1
fi
sed -i -e "s/^channel=.*/channel=${CHANNEL}/" /etc/hostapd/hostapd-ap0.conf

# We also configure the ap0 interface here as hostapd will remove it on a restart. Thus,
# it cannot be a udev rule. Why hostapd decides that it an external responsibility to
# create it, but not to delete it is mysterious.
/usr/sbin/iw dev wlan0 interface add ap0 type __ap 2> /dev/null || true
/usr/sbin/ifconfig ap0 up


