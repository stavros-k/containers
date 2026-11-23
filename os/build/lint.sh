#!/usr/bin/env bash
# Checks on the finished image. Run as the last build step (see Containerfile),
# after everything else has been installed and configured, so it sees exactly
# what ships. Changes nothing. Any image built on top of this one ends with the
# same step, mounting this script and its own factory tree.
#
# Expects the building repo's factory tree (rootfs/usr/share/factory)
# bind-mounted at /tmp/factory. That's the repo's copy, not the image's
# /usr/share/factory, which also holds Fedora's own files.
set -euxo pipefail

# Enforced config (see tmpfiles.d/kiosk-enforce.conf): each image's
# *-enforce.conf is hand-written, and both ways it can fall out of step with
# the factory tree are silent (systemd-tmpfiles skips a C line with a missing
# source and still exits 0), so check both:
#   - every file in this repo's factory tree has a C line in some *-enforce.conf
#   - every C line's source exists under /usr/share/factory
confs=(/usr/lib/tmpfiles.d/*-enforce.conf)
while IFS= read -r f; do
  grep -q "^C ${f#.} " "${confs[@]}" || { echo "lint.sh: ${f#.} is in rootfs/usr/share/factory but has no C line in /usr/lib/tmpfiles.d/*-enforce.conf" >&2; exit 1; }
done < <(cd /tmp/factory && find . -type f)
while IFS=: read -r conf path; do
  [ -f "/usr/share/factory$path" ] || { echo "lint.sh: $conf copies /usr/share/factory$path, which doesn't exist" >&2; exit 1; }
done < <(awk '$1 == "C" { print FILENAME ":" $2 }' "${confs[@]}")

# sudo ignores a sudoers.d file it can't parse; checking the copy the enforce
# step wrote is checking exactly what boot will write
visudo -c

# bootc's own checks on the composed image
bootc container lint
