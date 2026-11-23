#!/usr/bin/env bash
# /var hygiene. bootc lays down the image's /var only on first install, never
# on an update, so whatever the build leaves there goes stale on every kiosk.
# The last build step runs `bootc container lint --fatal-warnings`, which fails
# on any of it. Run after every step that writes to /var, this deals with what
# the build legitimately leaves:
#   1. caches rebuilt at runtime: deleted (explicit list, each with a reason)
#   2. files that must exist: moved to /usr/share/factory/var and copied back
#      at boot by a tmpfiles C line, which skips a file that's already there
#      (explicit list, each with a reason)
#   3. empty dirs a package owns: turned into tmpfiles d lines, with the mode
#      and owner the package gave them. Automatic, like Fedora's own
#      rpm-ostree-autovar.conf in the base image.
# Anything else (a file not listed here, a dir no package owns or one that
# still holds something) is left in place, so lint fails the build and someone
# has to decide which of the lists it belongs in.
set -euxo pipefail

conf=/usr/lib/tmpfiles.d/kiosk-var.conf

# 1. caches, rebuilt by their owners when missing
rm -f /var/cache/ldconfig/aux-cache # ldconfig's cache (glibc)
rm -rf /var/cache/swcatalog/cache   # AppStream's compiled catalog
rm -f /var/cache/ibus/bus/registry  # ibus-daemon's component cache
rm -f /var/lib/xkb/README.compiled  # README in the X server's keymap cache dir

# 2. files to keep
keep=(
  # authselect's hash of the PAM/nsswitch config it generated, written when a
  # package's scriptlet ran `authselect select`; `authselect check` compares
  # /etc against it
  /var/lib/authselect/checksum
)

# paths some tmpfiles.d line already handles (exact matches)
covered="$(systemd-tmpfiles --cat-config | awk '!/^#/ && NF >= 2 { print $2 }' | sort -u)"

lines=()
for f in "${keep[@]}"; do
  read -r mode user group < <(stat -c '%a %U %G' "$f")
  install -D -m "$mode" -o "$user" -g "$group" "$f" "/usr/share/factory$f"
  rm "$f"
  lines+=("C $f $mode $user $group -")
done

# 3. empty package-owned dirs, deepest first so a parent is empty once its
# children are gone
while IFS= read -r d; do
  grep -qxF "$d" <<<"$covered" && continue
  [ -z "$(ls -A "$d")" ] || continue
  rpm -qf "$d" >/dev/null 2>&1 || continue
  read -r mode user group < <(stat -c '%a %U %G' "$d")
  lines+=("d $d $mode $user $group -")
  rmdir "$d"
done < <(find /var -mindepth 1 -depth -type d)

{
  echo "# Generated at build time by os/build/configure/var.sh (see there)."
  printf '%s\n' "${lines[@]}" | sort -k2
} >"$conf"
