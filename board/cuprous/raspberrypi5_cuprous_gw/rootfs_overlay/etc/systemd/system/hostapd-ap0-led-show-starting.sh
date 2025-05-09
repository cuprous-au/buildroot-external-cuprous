#! /bin/sh

echo "timer" > /sys/class/leds/AP/trigger
echo 100 > /sys/class/leds/AP/delay_on
echo 100 > /sys/class/leds/AP/delay_off

