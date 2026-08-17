#!/usr/bin/env bash
# Configure the kiosk image: the one user, sudo, services, boot target. Run at
# build time via a bind mount (see Containerfile.fedora) AFTER rootfs/ has been
# COPY'd in (it touches the copied sudoers file) and AFTER packages.sh has
# installed the desktop (it enables sddm).
set -euxo pipefail

# the one user. -M because /var/home is not carried by the image
useradd -u 1000 -M -d /var/home/kiosk -G wheel kiosk

# sudoers dropped in from rootfs/ must be 0440 and valid
chmod 0440 /etc/sudoers.d/kiosk
visudo -c

# enable the display manager, ssh, and automatic bootc updates
systemctl enable sddm sshd bootc-fetch-apply-updates.timer

# boot to the graphical target; SDDM autologins the kiosk user into Plasma (X11)
systemctl set-default graphical.target

# timezone. Set the image default by symlinking /etc/localtime the way
# timedatectl would; it stays changeable at runtime (timedatectl set-timezone).
# Relative target so the link resolves against the deployment root, not the host.
ln -sf ../usr/share/zoneinfo/Europe/Athens /etc/localtime

# System-wide KDE defaults. Merged in with kwriteconfig6 rather than COPY'd so
# Fedora's other defaults in kdeglobals are preserved.
#
# Ghostty is the default terminal (Konsole is gone).
kwriteconfig6 --file /etc/xdg/kdeglobals --group General --key TerminalApplication ghostty

# Dark theme. startplasma reads this key at login and, when it differs from the
# theme recorded in the user's ~/.config/kdedefaults, writes the package's
# defaults (colours, icons, decorations) there. Seeding the home directory at
# build time isn't an option: /var/home is not carried by the image.
kwriteconfig6 --file /etc/xdg/kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezedark.desktop

# final sanity check on the composed image
bootc container lint
