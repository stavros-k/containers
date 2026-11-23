#!/usr/bin/env bash
# Configure the kiosk image: the one user, enforced config, services, boot
# target. Run at build time via a bind mount (see Containerfile) AFTER
# rootfs/ has been COPY'd in (it applies the copied kiosk-enforce tmpfiles.d)
# and AFTER packages.sh has installed the desktop (it enables sddm).
set -euxo pipefail

# the one user. Defined once in rootfs/usr/lib/sysusers.d/kiosk.conf and applied
# here so the built image carries the passwd/group entries; systemd-sysusers
# reapplies that same file on every boot. No home dir is created either way —
# /var/home is not carried by the image, tmpfiles.d makes it at boot.
systemd-sysusers /usr/lib/sysusers.d/kiosk.conf

# Image-owned config, reasserted over local drift on every boot: the factory
# tree /usr/share/factory mirrors absolute paths, and
# tmpfiles.d/kiosk-enforce.conf copies each file back over /etc at boot (see
# there for how and why). Apply it now too, so the built image already carries
# the files; lint.sh then checks the conf against the factory tree and runs
# visudo on the sudoers file it wrote.
systemd-tmpfiles --create --remove /usr/lib/tmpfiles.d/kiosk-enforce.conf

# enable the display manager, ssh, automatic bootc updates, and the unattended
# Splashtop deploy (a no-op in images built without the code)
systemctl enable sddm sshd \
  bootc-fetch-apply-updates.timer \
  splashtop-deploy.service

# boot to the graphical target; SDDM autologins the kiosk user into Plasma (X11)
systemctl set-default graphical.target

# timezone. Set the image default by symlinking /etc/localtime the way
# timedatectl would; it stays changeable at runtime (timedatectl set-timezone).
# Relative target so the link resolves against the deployment root, not the host.
ln -sf ../usr/share/zoneinfo/Europe/Athens /etc/localtime
