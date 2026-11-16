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

# Image-owned config, reasserted over local drift on every boot. The canonical
# copies live in a read-only factory tree that mirrors absolute paths:
#   enforce/system/etc/foo -> /etc/foo
#   enforce/user/.config/foo -> /var/home/kiosk/.config/foo
# To enforce another file, drop it in the tree; this generates a tmpfiles.d
# entry for every file in it. L+ removes whatever is at the path (a local edit,
# a file a tool swapped in for the link) and puts back a symlink into the tree.
# systemd-tmpfiles-setup.service applies it in sysinit, before sshd and the
# display manager, so nothing reads a drifted copy, and in-place edits fail
# outright since the target is on read-only /usr. Parent dirs in /etc are
# created root-owned by tmpfiles; dirs in the home get explicit `d` lines so
# they're kiosk-owned. Note that a user file enforced this way is read-only to
# the kiosk user's apps, so only enforce config they should not write.
#
# sudo checks the mode of the link's target, and git only carries the exec bit,
# so 0440 has to be set on the factory copy here.
factory=/usr/share/kiosk/enforce
home=/var/home/kiosk
chmod 0440 "$factory/system/etc/sudoers.d/kiosk"

# list paths under $1 of find type $2, relative with a leading /; tmpfiles.d
# fields are whitespace-separated, so refuse names that would split
tree() {
  [ -d "$1" ] || return 0
  (cd "$1" && find . -mindepth 1 -type "$2" | sort) | while IFS= read -r p; do
    case $p in *[[:space:]]*) echo "configure.sh: whitespace in $1${p#.}" >&2; return 1 ;; esac
    printf '%s\n' "${p#.}"
  done
}
{
  echo "# Generated at build time by configure.sh from $factory; edits are lost."
  tree "$factory/system" f | while read -r p; do printf 'L+ %s - - - - %s\n' "$p" "$factory/system$p"; done
  tree "$factory/user" d | while read -r p; do printf 'd %s 0755 kiosk kiosk - -\n' "$home$p"; done
  tree "$factory/user" f | while read -r p; do printf 'L+ %s - - - - %s\n' "$home$p" "$factory/user$p"; done
} >/usr/lib/tmpfiles.d/kiosk-enforce.conf
cat /usr/lib/tmpfiles.d/kiosk-enforce.conf

# Apply the /etc part now too, so the built image already carries the links and
# visudo checks sudoers through the link, the way sudo will read it. (/var is
# left to first boot; bootc doesn't ship image /var content to running hosts.)
systemd-tmpfiles --create --prefix=/etc /usr/lib/tmpfiles.d/kiosk-enforce.conf
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
