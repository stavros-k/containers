#!/usr/bin/env bash
# The one kiosk user. Defined once in rootfs/usr/lib/sysusers.d/kiosk.conf and
# applied here so the built image carries the passwd/group entries;
# systemd-sysusers reapplies that same file on every boot. No home dir is
# created either way: /var/home is not carried by the image, tmpfiles.d makes
# it at boot.
set -euxo pipefail

systemd-sysusers /usr/lib/sysusers.d/kiosk.conf
