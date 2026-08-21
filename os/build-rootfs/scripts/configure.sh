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

# sudoers dropped in from rootfs/ must be 0440 and valid
chmod 0440 /etc/sudoers.d/kiosk
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
