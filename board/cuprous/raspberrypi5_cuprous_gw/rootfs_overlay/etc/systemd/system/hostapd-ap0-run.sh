#!/bin/sh
# Configure hostapd with an SSID and passphase in relation to our WiFi's mac address.
# Starts/restarts hostapd if the wlan channel changes.

assign_wlan_channel() {
    if [ -e "/var/run/wpa_supplicant" ]; then
        WLAN_CHANNEL=$(/sbin/iw wlan0 info | grep "channel" | grep -Eo '[0-9]+' | head -1)
    else
        WLAN_CHANNEL=1
    fi
}

while /bin/true; do
    if [[ -z "$HOSTAPD_PID" ]]; then
        AP_CHANNEL=$(cat /etc/hostapd/hostapd-ap0.conf | grep -e "^channel=" | grep -Eo '[0-9]+')
        COMPARE_CHANNELS=false
    else
        COMPARE_CHANNELS=true
    fi

    assign_wlan_channel

    if ! $COMPARE_CHANNELS || [ $AP_CHANNEL -ne $WLAN_CHANNEL ]; then
        if [[ -z "$HOSTAPD_PID" ]]; then
            echo "Starting hostapd on channel: $WLAN_CHANNEL."
            /etc/systemd/system/hostapd-ap0-led-show-starting.sh
        else
            echo "New WLAN channel detected: $WLAN_CHANNEL. Stopping hostapd and restarting in 10 seconds."
            /etc/systemd/system/hostapd-ap0-led-show-starting.sh
            kill $HOSTAPD_PID
            sleep 10

            assign_wlan_channel
        fi

        # Assign our SSID and password based on our MAC address
        MAC_ID=$(cat /sys/class/net/wlan0/address | tr -d ':' | tail -c5)
        sed -i -e "s/^ssid=.*/ssid=Cuprous-${MAC_ID}/" /etc/hostapd/hostapd-ap0.conf
        sed -i -e "s/^wpa_passphrase=.*/wpa_passphrase=${MAC_ID}${MAC_ID}/" /etc/hostapd/hostapd-ap0.conf

        # We configure ap0 to have the same channel as wlan0 if it is active, or back
        # to a sensible default if not.
        sed -i -e "s/^channel=.*/channel=${WLAN_CHANNEL}/" /etc/hostapd/hostapd-ap0.conf

        # Configure the hardware mode to 2.4GHz or 5Ghz according to the range of the channel
        if [ $WLAN_CHANNEL -ge 14 ]; then
            HW_MODE=a
        else
            HW_MODE=g
        fi
        sed -i -e "s/^hw_mode=.*/hw_mode=${HW_MODE}/" /etc/hostapd/hostapd-ap0.conf

        # We also configure the ap0 interface here as hostapd will remove it on a restart. Thus,
        # it cannot be a udev rule. Why hostapd decides that it an external responsibility to
        # create it, but not to delete it is mysterious.
        /usr/sbin/iw dev wlan0 interface add ap0 type __ap 2> /dev/null || true
        /usr/sbin/ifconfig ap0 up

        # Finally, start hostapd as a sub process

        /usr/sbin/hostapd /etc/hostapd/hostapd-ap0.conf &
        HOSTAPD_PID=$!

        # Indicate we're up
        /etc/systemd/system/hostapd-ap0-led-show-on.sh

        AP_CHANNEL=$WLAN_CHANNEL
    fi

    sleep 1
done
