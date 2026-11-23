#!/usr/bin/env bash
# Install Arduino IDE 2 (the graphical IDE; arduino-cli.sh installs the separate
# command-line tool). It's not in Fedora's repos and has no trusted COPR, so we
# fetch Arduino's official Linux zip. Run at build time via a bind mount (see
# Containerfile); unpack() is in build/lib/install.sh.
set -euxo pipefail
# shellcheck source=../lib/install.sh
source /tmp/lib/install.sh

# renovate: datasource=github-releases depName=arduino/arduino-ide
version=2.3.11

cd "$(mktemp -d)"
curl -fsSL -o arduino-ide.zip "https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_Linux_64bit.zip"
# The zip ships no icon or desktop entry (only the AppImage does), so take the
# app icon from the source tree at the same tag.
curl -fsSL -o icon.png "https://raw.githubusercontent.com/arduino/arduino-ide/${version}/electron-app/resources/icons/512x512.png"

# The zip holds a single arduino-ide_<version>_Linux_64bit/ dir (an Electron
# app with its bundled arduino-cli, clangd, …).
unpack arduino-ide.zip /usr/local/lib/arduino-ide --strip
test -x /usr/local/lib/arduino-ide/arduino-ide
ln -sfr /usr/local/lib/arduino-ide/arduino-ide /usr/local/bin/arduino-ide

# No setuid on chrome-sandbox: Fedora allows unprivileged user namespaces, and
# Electron uses that sandbox when it's available, so the helper is never needed.

install -Dm0644 icon.png /usr/local/share/icons/hicolor/512x512/apps/arduino-ide.png
install -d /usr/local/share/applications
cat >/usr/local/share/applications/arduino-ide.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Arduino IDE
Comment=Write, compile and upload Arduino sketches
Exec=arduino-ide %U
Icon=arduino-ide
Terminal=false
Categories=Development;IDE;Electronics;
StartupWMClass=Arduino IDE
EOF
