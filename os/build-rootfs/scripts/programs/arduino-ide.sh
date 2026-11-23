#!/usr/bin/env bash
# Install Arduino IDE 2 (the graphical IDE; arduino-cli.sh installs the separate
# command-line tool). It's not in Fedora's repos and has no trusted COPR, so we
# fetch Arduino's official Linux zip (over HTTPS) and unpack it under
# /usr/local (a real dir on fedora-bootc, so it persists in the image). Run at
# build time via a bind mount (see Containerfile.fedora).
set -euxo pipefail

# renovate: datasource=github-releases depName=arduino/arduino-ide
version=2.3.11
zip="arduino-ide_${version}_Linux_64bit.zip"
url="https://github.com/arduino/arduino-ide/releases/download/${version}/${zip}"
# The zip ships no icon or desktop entry (only the AppImage does), so take the
# app icon from the source tree at the same tag.
icon_url="https://raw.githubusercontent.com/arduino/arduino-ide/${version}/electron-app/resources/icons/512x512.png"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

curl -fsSL -o "$zip" "$url"
curl -fsSL -o icon.png "$icon_url"

# The zip holds a single arduino-ide_<version>_Linux_64bit/ dir (an Electron
# app); unpack it under a version-independent name. unzip keeps the exec bits
# (arduino-ide, the bundled arduino-cli, clangd, …) and, unlike tar, never
# restores the archive's owners, so everything is root-owned like /usr.
unzip -q "$zip"
dir="/usr/local/lib/arduino-ide"
rm -rf "$dir"
mkdir -p /usr/local/lib
mv "arduino-ide_${version}_Linux_64bit" "$dir"
test -x "$dir/arduino-ide"

# No setuid on chrome-sandbox: Fedora allows unprivileged user namespaces, and
# Electron uses that sandbox when it's available, so the helper is never needed.

ln -sf ../lib/arduino-ide/arduino-ide /usr/local/bin/arduino-ide

install -Dm0644 icon.png /usr/local/share/icons/hicolor/512x512/apps/arduino-ide.png
install -d /usr/local/share/applications
cat > /usr/local/share/applications/arduino-ide.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Arduino IDE
Comment=Write, compile and upload Arduino sketches
Exec=/usr/local/bin/arduino-ide %U
Icon=/usr/local/share/icons/hicolor/512x512/apps/arduino-ide.png
Terminal=false
Categories=Development;IDE;Electronics;
StartupWMClass=Arduino IDE
EOF
