#!/usr/bin/env bash
# Services and boot target.
set -euxo pipefail

# the display manager, ssh, automatic bootc updates, and the unattended
# Splashtop deploy (a no-op unless the installer wrote a deploy code)
systemctl enable \
  sddm \
  sshd \
  bootc-fetch-apply-updates.timer \
  splashtop-deploy.service

# boot to the graphical target; SDDM autologins the kiosk user into Plasma (X11)
systemctl set-default graphical.target
