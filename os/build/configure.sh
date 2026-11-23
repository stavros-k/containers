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
# tree /usr/share/kiosk/enforce/system mirrors absolute paths, and
# tmpfiles.d/kiosk-enforce.conf copies each file back over /etc at boot (see
# there for how and why).
#
# Apply it now too, so the built image already carries the files and visudo
# checks the exact sudoers file that boot will write. The conf is hand-written,
# and both ways it can fall out of step with the factory tree are silent
# (systemd-tmpfiles skips a C line with a missing source and still exits 0),
# so check both here: every factory file has a C line, every C line's source
# exists.
conf=/usr/lib/tmpfiles.d/kiosk-enforce.conf
factory=/usr/share/kiosk/enforce/system
systemd-tmpfiles --create --remove "$conf"
while IFS= read -r f; do
  grep -q "^C ${f#.} " "$conf" || { echo "configure.sh: ${f#.} is in $factory but not in $conf" >&2; exit 1; }
done < <(cd "$factory" && find . -type f)
while IFS= read -r src; do
  [ -f "$src" ] || { echo "configure.sh: $conf copies $src, which doesn't exist" >&2; exit 1; }
done < <(awk '$1 == "C" { print $7 }' "$conf")
visudo -c

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

# final sanity check on the composed image
bootc container lint
