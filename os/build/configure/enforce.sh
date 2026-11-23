#!/usr/bin/env bash
# Image-owned config, reasserted over local drift on every boot.
#
# The canonical copies live in the read-only factory tree /usr/share/factory
# (rootfs/usr/share/factory in the repo), which mirrors absolute paths:
# systemd's own convention, so a tmpfiles C line with no source argument copies
# from /usr/share/factory/<path>. This script writes a pair of lines for every
# file in the repo's tree into /usr/lib/tmpfiles.d/kiosk-enforce.conf, applied
# by systemd-tmpfiles-setup.service (--create --remove) in sysinit, before sshd
# and the display manager read them. Together they always win, on every boot:
#   r  deletes whatever is at the path (the file, edited or not, a symlink, an
#      empty dir). tmpfiles runs every remove before any create, so
#   C  always finds the path empty and copies the factory file there.
# (C on its own skips a path that exists, hence the r.) The results are
# ordinary files: a live hotfix (vi, sed -i, chmod) works and lasts until the
# next boot, then the image's version is back. Anything meant to outlast a
# reboot goes through a rollout.
#
# Generated rather than hand-written, so adding a file to the tree is all it
# takes. The list comes from the repo's tree (bind-mounted at /tmp/factory), not
# the image's /usr/share/factory, which also holds Fedora's own files (pam.d,
# issue, …) that must stay untouched.
set -euxo pipefail

conf=/usr/lib/tmpfiles.d/kiosk-enforce.conf

# Mode per path; tmpfiles' C sets it rather than taking the factory copy's
# (git only carries the exec bit).
mode_for() {
  case "$1" in
    # root-only, like Fedora's own sshd_config and sshd_config.d files
    /etc/ssh/sshd_config.d/*) echo 0600 ;;
    # sudo refuses a sudoers file that's group/world-writable; 0440 is the norm
    /etc/sudoers.d/*) echo 0440 ;;
    *) echo 0644 ;;
  esac
}

{
  echo "# Generated at build time by os/build/configure/enforce.sh (see there)."
  echo "# Apply by hand with: systemd-tmpfiles --create --remove $conf"
  echo "# (without --remove the r lines are skipped and nothing is restored)."
  (cd /tmp/factory && find . -type f | sort) | while IFS= read -r f; do
    path=${f#.}
    printf '\nr %s - - - - -\n' "$path"
    printf 'C %s %s root root -\n' "$path" "$(mode_for "$path")"
  done
} >"$conf"

# Apply it now too, so the built image already carries the files and visudo
# checks the exact sudoers file that boot will write.
systemd-tmpfiles --create --remove "$conf"
visudo -c
