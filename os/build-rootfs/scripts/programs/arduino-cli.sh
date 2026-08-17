#!/usr/bin/env bash
# Install arduino-cli. It's not in Fedora's repos and has no trusted COPR, so we
# fetch Arduino's official release binary (over HTTPS) and drop it in
# /usr/local/bin (a real dir on fedora-bootc, so it persists in the image).
# Run at build time via a bind mount (see Containerfile.fedora).
set -euxo pipefail

# renovate: datasource=github-releases depName=arduino/arduino-cli
version=1.5.1
base="https://github.com/arduino/arduino-cli/releases/download/v${version}"
tarball="arduino-cli_${version}_Linux_64bit.tar.gz"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

curl -fsSL -o "$tarball" "${base}/${tarball}"

# --no-same-owner: ignore the uid/gid baked into Arduino's tarball and extract
# as root, so the binary is root-owned like everything else under /usr
tar -xzf "$tarball" --no-same-owner -C /usr/local/bin arduino-cli
chmod 0755 /usr/local/bin/arduino-cli

# no `arduino-cli version` check here: run as root at build time it tries to
# create /root/.arduino15 and errors out.
