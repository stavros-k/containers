#!/usr/bin/env bash
# Install all packages for the kiosk image. This script and the third-party
# repo files under etc/yum.repos.d/ are bind-mounted at build time (see
# Containerfile.fedora), never copied, so they leave no trace in the final
# image and need no cleanup.
set -euxo pipefail

# No reposdir override here: the extra .repo files are bind-mounted straight
# into /etc/yum.repos.d, so dnf picks them up via its own defaults and keeps
# finding the base repos wherever the distro puts them. (Pointing reposdir at
# an explicit list used to work, but Fedora 46 moved the base repos to
# /usr/share/dnf5/repos.d and the override silently hid every one of them —
# every package then failed as "No match for argument".) dnf auto-imports each
# repo's declared gpgkey under `-y`, so there's no separate key-import step.

pkgs=(
  sddm                  # display manager
  plasma-desktop        # Plasma shell + settings (pulls plasma-workspace, kwin)
  plasma-workspace-x11  # the Plasma (X11) session + startplasma-x11
  plasma-nm             # network/Wi-Fi applet + settings (KDE NetworkManager UI)
  xorg-x11-server-Xorg  # the X server
  dolphin               # file manager
  chromium              # browser
  openssh-server        # remote access
  NetworkManager-wifi   # Wi-Fi backend for NetworkManager (pulls wpa_supplicant)
  mesa-dri-drivers      # GPU drivers (OpenGL)
  mesa-vulkan-drivers   # Vulkan drivers — Zed renders via Vulkan, won't start without one
  unclutter-xfixes      # hides the mouse cursor on inactivity/touch (X11)

  ghostty               # terminal (from the bind-mounted COPR repo scottames/ghostty)
  # Zed (the editor) is installed from its pinned upstream tarball by
  # programs/zed.sh, not from a repo — see Containerfile.fedora.
)

dnf -y install "${pkgs[@]}"

dnf clean all

# bootc wants /var and /run effectively empty in the image: anything left there
# is applied only on first boot and never again on update, so it silently goes
# stale (`bootc container lint`, checks var-tmpfiles/var-log/nonempty-run-tmp).
# Everything removed here is regenerable cache or per-machine state. The dirs
# that packages still expect to find are recreated on every boot instead, by
# rootfs/usr/lib/tmpfiles.d/kiosk-var.conf.
rm -rf \
  /var/cache/* \
  /var/lib/dnf/* \
  /var/log/dnf5.log* \
  /var/lib/xkb/README.compiled \
  /var/lib/authselect/checksum \
  /run/*
