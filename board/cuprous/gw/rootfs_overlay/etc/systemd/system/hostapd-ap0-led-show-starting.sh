#! /bin/sh

echo "timer" > /sys/class/leds/activity/trigger
echo 100 > /sys/class/leds/activity/delay_on
echo 100 > /sys/class/leds/activity/delay_off

