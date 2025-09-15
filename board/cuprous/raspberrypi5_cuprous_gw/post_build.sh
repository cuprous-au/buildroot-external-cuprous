#!/bin/sh

set -e

mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
ln -s /usr/lib/systemd/system/serial-getty@.service $TARGET_DIR/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service 2> /dev/null || true

mkdir -p $TARGET_DIR/etc/systemd/system/first-boot-complete.target.wants
ln -s /etc/systemd/system/resizefs.service $TARGET_DIR/etc/systemd/system/first-boot-complete.target.wants/resizefs.service 2> /dev/null || true

rm -f $TARGET_DIR/etc/machine-id

VERSION="$(cd ../buildroot-external-cuprous; git describe)"
( \
	echo "NAME=Cuprux"; \
	echo "VERSION=$VERSION"; \
	echo "ID=cuprux"; \
	echo "ID_LIKE=buildroot linux"; \
	echo "VERSION_ID=$VERSION"; \
	echo "PRETTY_NAME=\"Cuprux $VERSION\""; \
	echo "HOME_URL=\"https://github.com/cuprous-au/buildroot-external-cuprous\"" \
) >  $TARGET_DIR/etc/os-release


