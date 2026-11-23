# shellcheck shell=bash
# Helpers for build/programs/*.sh, which install pinned upstream releases that
# aren't in any repo. Sourced, not run (see Containerfile for where it's
# mounted).
#
# Everything goes under /usr/local: a real dir on fedora-bootc, so it persists
# in the image. Apps live in /usr/local/lib/<name>, with a symlink on PATH in
# /usr/local/bin.

# unpack ARCHIVE DEST [--strip]: unpack a .tar.gz or .zip to DEST, replacing
# whatever is there (a rebuilt layer never carries the old version's files).
# --strip: the archive holds a single top-level dir, and DEST becomes that dir.
#
# Everything ends up root-owned like the rest of /usr: tar gets
# --no-same-owner so it ignores the uid/gid baked into the archive, and unzip
# never restores owners. Both keep the archive's exec bits.
unpack() {
  local archive=$1 dest=$2 strip=${3:-} stage src
  stage="$(mktemp -d)"
  case "$archive" in
    *.tar.gz | *.tgz) tar -xzf "$archive" --no-same-owner -C "$stage" ;;
    *.zip) unzip -q "$archive" -d "$stage" ;;
    *) echo "unpack: don't know how to unpack $archive" >&2; return 1 ;;
  esac
  src=$stage
  if [ "$strip" = --strip ]; then
    local entries=("$stage"/*)
    if [ ${#entries[@]} -ne 1 ] || [ ! -d "${entries[0]}" ]; then
      echo "unpack: --strip needs exactly one top-level dir in $archive" >&2
      return 1
    fi
    src=${entries[0]}
  fi
  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"
  mv "$src" "$dest"
  # mktemp -d makes the stage 0700; the app dir must be readable by everyone
  chmod 0755 "$dest"
}
