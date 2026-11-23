#!/usr/bin/env bash
# Install arduino-cli. It's not in Fedora's repos and has no trusted COPR, so we
# fetch Arduino's official release binary. Run at build time via a bind mount
# (see Containerfile); unpack() is in build/lib/install.sh.
set -euxo pipefail
# shellcheck source=../lib/install.sh
source /tmp/lib/install.sh

# renovate: datasource=github-releases depName=arduino/arduino-cli
version=1.6.0

cd "$(mktemp -d)"
curl -fsSL -o arduino-cli.tar.gz "https://github.com/arduino/arduino-cli/releases/download/v${version}/arduino-cli_${version}_Linux_64bit.tar.gz"

# The tarball holds the binary and its LICENSE.txt, no top-level dir.
unpack arduino-cli.tar.gz /usr/local/lib/arduino-cli
test -x /usr/local/lib/arduino-cli/arduino-cli
ln -sfr /usr/local/lib/arduino-cli/arduino-cli /usr/local/bin/arduino-cli

# no `arduino-cli version` check here: run as root at build time it tries to
# create /root/.arduino15 and errors out.
