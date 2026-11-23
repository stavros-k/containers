#!/usr/bin/env bash
# Install the Zed editor. It's not in Fedora's repos and has no trusted COPR, so
# we fetch Zed's official release tarball. Run at build time via a bind mount
# (see Containerfile); unpack() is in build/lib/install.sh.
set -euxo pipefail
# shellcheck source=../lib/install.sh
source /tmp/lib/install.sh

# renovate: datasource=github-releases depName=zed-industries/zed
version=1.29.3

cd "$(mktemp -d)"
curl -fsSL -o zed.tar.gz "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-x86_64.tar.gz"

# The tarball holds a self-contained zed.app/ bundle (bin/, libexec/, share/).
# The bundled binary resolves the app dir from its own path, so a symlink on
# PATH is enough.
unpack zed.tar.gz /usr/local/lib/zed.app --strip
test -x /usr/local/lib/zed.app/bin/zed
ln -sfr /usr/local/lib/zed.app/bin/zed /usr/local/bin/zed

# Desktop entry and icons, unchanged from the bundle: its Exec=zed and Icon=zed
# resolve through PATH and the icon theme, both of which search /usr/local.
install -Dm0644 /usr/local/lib/zed.app/share/applications/dev.zed.Zed.desktop \
  /usr/local/share/applications/dev.zed.Zed.desktop
install -d /usr/local/share/icons
cp -r /usr/local/lib/zed.app/share/icons/hicolor /usr/local/share/icons/
