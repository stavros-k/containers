#!/usr/bin/env bash
# Reassert image-owned files over any local drift. The canonical copies live in a
# read-only factory tree under /usr; this stamps each onto its real path,
# overwriting whatever is there. Run on every boot before login by the
# kiosk-enforce-*.service units — and since bootc applies updates by rebooting,
# that also covers "after every update".
#
# Usage: enforce.sh <factory-dir> <dest-root> <owner:group>
#   <factory-dir> mirrors absolute paths: <factory-dir>/etc/foo -> <dest-root>/etc/foo
set -euo pipefail

factory=$1
dest_root=${2%/}
owner=$3

# nothing to enforce yet (e.g. the user tree before any file is seeded)
[ -d "$factory" ] || exit 0

# Pre-order walk: find emits a directory before its contents, so a parent is
# created with the right ownership before any file lands inside it.
find "$factory" -mindepth 1 \( -type d -o -type f \) -print0 |
  while IFS= read -r -d '' src; do
    dest="${dest_root}${src#"$factory"}"
    mode=$(stat -c '%a' "$src")
    if [ -d "$src" ]; then
      install -d -m "$mode" -o "${owner%%:*}" -g "${owner##*:}" "$dest"
    else
      install -D -m "$mode" -o "${owner%%:*}" -g "${owner##*:}" "$src" "$dest"
    fi
    # relabel to the SELinux context the destination path should carry
    command -v restorecon >/dev/null 2>&1 && restorecon -F "$dest" || true
  done
