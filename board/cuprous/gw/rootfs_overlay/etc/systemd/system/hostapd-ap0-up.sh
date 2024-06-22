#! /bin/sh
# Turn on the LED to indicate AP activity

echo "heartbeat" > /sys/class/leds/activity/trigger
