#! /bin/sh
# Turn off the LED to indicate no AP activity

echo "none" > /sys/class/leds/activity/trigger
