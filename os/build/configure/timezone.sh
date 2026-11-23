#!/usr/bin/env bash
# Image default timezone, set by symlinking /etc/localtime the way timedatectl
# would; it stays changeable at runtime (timedatectl set-timezone). Relative
# target so the link resolves against the deployment root, not the host.
set -euxo pipefail

ln -sf ../usr/share/zoneinfo/Europe/Athens /etc/localtime
