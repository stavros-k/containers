#!/usr/bin/env bash
# Install all packages for the kiosk image. This script and the third-party
# repo files under etc/yum.repos.d/ are bind-mounted at build time (see
# Containerfile.fedora), never copied, so they leave no trace in the final
# image and need no cleanup.
set -euxo pipefail

# Read repos from the base system dir AND the bind-mounted one, so the extra
# .repo files are picked up in place. dnf auto-imports each repo's declared
# gpgkey under `-y`, so there's no separate key-import step.
reposdir=(
  /etc/yum.repos.d                   # base system repos
  /run/build-rootfs/etc/yum.repos.d  # bind-mounted third-party repos
)

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
  mesa-dri-drivers      # GPU drivers

  ghostty               # terminal (from the bind-mounted COPR repo scottames/ghostty)
  code                  # VS Code (from the bind-mounted Microsoft repo)
)

dnf -y --setopt=reposdir="$(IFS=,; echo "${reposdir[*]}")" install "${pkgs[@]}"

dnf clean all
