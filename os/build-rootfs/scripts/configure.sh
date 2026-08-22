#!/usr/bin/env bash
# Configure the kiosk image: the one user, sudo, services, boot target. Run at
# build time via a bind mount (see Containerfile.fedora) AFTER rootfs/ has been
# COPY'd in (it touches the copied sudoers file) and AFTER packages.sh has
# installed the desktop (it enables sddm).
set -euxo pipefail

# the one user. Defined once in rootfs/usr/lib/sysusers.d/kiosk.conf and applied
# here so the built image carries the passwd/group entries; systemd-sysusers
# reapplies that same file on every boot. No home dir is created either way —
# /var/home is not carried by the image, tmpfiles.d makes it at boot.
systemd-sysusers /usr/lib/sysusers.d/kiosk.conf

# sudoers and the SSH auth policy live in the enforce factory tree, so
# kiosk-enforce-system stamps them back over local drift on every boot. They're
# installed into /etc here as well so they're already in effect on the very
# first boot: sshd.service and kiosk-enforce-system.service both start around
# multi-user.target with no ordering between them, and visudo needs the /etc
# copy to check it.
#
# enforce.sh replays the *source* file's mode onto the destination, and git only
# carries the exec bit — so 0440 has to be set on the factory copy here, or a
# checked-out 0644 would be stamped over sudoers on every boot.
factory=/usr/share/kiosk/enforce/system
chmod 0440 "$factory/etc/sudoers.d/kiosk"
install -D -m 0440 "$factory/etc/sudoers.d/kiosk" /etc/sudoers.d/kiosk
install -D -m 0644 "$factory/etc/ssh/sshd_config.d/30-kiosk-auth.conf" /etc/ssh/sshd_config.d/30-kiosk-auth.conf
visudo -c

# the enforce helper (run by the kiosk-enforce-*.service units) must be executable
chmod 0755 /usr/lib/kiosk/enforce.sh

# enable the display manager, ssh, automatic bootc updates, and the two enforce
# units that stamp image-owned config back over any local drift on each boot
systemctl enable sddm sshd \
  bootc-fetch-apply-updates.timer \
  kiosk-enforce-system.service \
  kiosk-enforce-user.service

# boot to the graphical target; SDDM autologins the kiosk user into Plasma (X11)
systemctl set-default graphical.target

# timezone. Set the image default by symlinking /etc/localtime the way
# timedatectl would; it stays changeable at runtime (timedatectl set-timezone).
# Relative target so the link resolves against the deployment root, not the host.
ln -sf ../usr/share/zoneinfo/Europe/Athens /etc/localtime

# final sanity check on the composed image
bootc container lint
