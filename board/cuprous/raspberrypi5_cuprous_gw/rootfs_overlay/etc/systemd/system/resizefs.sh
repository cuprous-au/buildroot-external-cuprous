#! /bin/sh
# Resize the user partition to the max capacity
/sbin/fdisk  /dev/mmcblk0 <<EOF
d
2
n
p
2


n
w
EOF
/sbin/resize2fs /dev/mmcblk0p2
/bin/echo "User partition resized"
