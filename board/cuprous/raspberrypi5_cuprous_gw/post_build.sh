#!/bin/sh

set -e

mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
ln -s /usr/lib/systemd/system/serial-getty@.service $TARGET_DIR/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service 2> /dev/null || true
