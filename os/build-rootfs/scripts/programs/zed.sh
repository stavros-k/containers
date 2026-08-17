#!/usr/bin/env bash
# Install the Zed editor. It's not in Fedora's repos and has no trusted COPR, so
# we fetch Zed's official release tarball (over HTTPS) and unpack it under
# /usr/local (a real dir on fedora-bootc, so it persists in the image). Run at
# build time via a bind mount (see Containerfile.fedora).
set -euxo pipefail

# renovate: datasource=github-releases depName=zed-industries/zed
version=1.15.0
tarball="zed-linux-x86_64.tar.gz"
url="https://github.com/zed-industries/zed/releases/download/v${version}/${tarball}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

curl -fsSL -o "$tarball" "$url"

# The tarball contains a self-contained zed.app/ bundle (bin/, libexec/, share/).
# --no-same-owner: extract as root rather than honouring the tarball's uid/gid,
# so everything is root-owned like the rest of /usr.
rm -rf /usr/local/lib/zed.app
mkdir -p /usr/local/lib
tar -xzf "$tarball" --no-same-owner -C /usr/local/lib
test -x /usr/local/lib/zed.app/bin/zed

# launcher on PATH; the bundled binary resolves the app dir from its own path,
# so a symlink is enough
ln -sf ../lib/zed.app/bin/zed /usr/local/bin/zed

# desktop entry so Zed shows up in the launcher, with absolute Exec/Icon since it
# lives outside the standard prefixes
install -d /usr/local/share/applications
sed -e 's|^Exec=zed|Exec=/usr/local/bin/zed|' \
    -e 's|^Icon=zed|Icon=/usr/local/lib/zed.app/share/icons/hicolor/512x512/apps/zed.png|' \
    /usr/local/lib/zed.app/share/applications/dev.zed.Zed.desktop \
    > /usr/local/share/applications/dev.zed.Zed.desktop
