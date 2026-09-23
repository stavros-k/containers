#!/usr/bin/env bash
# Install Splashtop Streamer (remote access). It's not in any repo, so we fetch
# Splashtop's official version-pinned tarball (over HTTPS) and install the RPM
# inside it. Run at build time via a bind mount (see
# Containerfile.fedora).
#
# The RPM assumes a writable /opt: it keeps its state (config/ with the deploy
# code, log/, dump/, .keyring/) inside /opt/splashtop-streamer, which is
# read-only on a booted bootc system. Those four are swapped for symlinks into
# /var/lib/splashtop-streamer, created at boot by tmpfiles.d/splashtop-streamer.conf,
# so the program updates with the image and the state survives it. Watching a
# live install + deploy + session showed nothing else is written under /opt.
#
# Kept current by Renovate: Splashtop has no release feed, so the custom
# datasource (see .github/renovate.json5) reads the version off Splashtop's
# download article. Staying current matters more than usual here, since the
# streamer's own self-update is off (SRStreamer.service.d/10-no-self-update.conf)
# and an outdated streamer risks losing compatibility with Splashtop's service.
set -euxo pipefail

# renovate: datasource=custom.splashtop-streamer depName=splashtop-streamer versioning=loose
version=3.8.2.0
tarball="STB_CSRS_CentOS_v${version}_x86_64.tar.gz"
url="https://download.splashtop.com/linux/${tarball}"
rpm="Splashtop_Streamer_CentOS_x86_64.rpm"

app=/opt/splashtop-streamer
state=/var/lib/splashtop-streamer

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

curl -fsSL -o "$tarball" "$url"
tar -xzf "$tarball" --no-same-owner "$rpm"

# The service user, declared for systemd-sysusers with a fixed id (same reasoning
# as sysusers.d/kiosk.conf) and created BEFORE the RPM, so its %pre finds it and
# skips its own `useradd`. Fixed so the ownership baked into /opt always matches
# the user sysusers recreates at boot. Written here rather than in rootfs/
# because rootfs/ is COPY'd after this step and the user must exist now.
install -D -m 0644 /dev/stdin /usr/lib/sysusers.d/splashtop-streamer.conf <<'EOF'
# Splashtop Streamer service user; see build-rootfs/scripts/programs/splashtop-streamer.sh
u splashtop-streamer 850 "Splashtop Remote Streamer" /opt/splashtop-streamer /sbin/nologin
EOF
systemd-sysusers /usr/lib/sysusers.d/splashtop-streamer.conf

# The RPM's %pre tries to pull its optional deps itself (`systemd-run yum
# install ...`), which can't work in a build and on Fedora fails outright on the
# names that don't exist here. These are the ones that do and that it dlopens:
# tray icon (ayatana appindicator), its embedded web UI (webkit2gtk4.1), and
# the X input/display tools it shells out to.
dnf -y install \
  "./$rpm" \
  libayatana-appindicator-gtk3 \
  webkit2gtk4.1 \
  xinput \
  xrandr

# Move state out of /opt. The shipped openssl configs are static, so they stay
# in the image and config/ssl links back to them (see the tmpfiles.d file).
mv "$app/config/ssl" "$app/ssl"
for d in config log dump .keyring; do
  rm -rf "${app:?}/$d"
  ln -s "$state/$d" "$app/$d"
done

# %post already enables it; explicit so the image doesn't depend on that
systemctl enable SRStreamer.service

dnf clean all
rm -f /var/log/dnf5.log*
# dnf's runtime lock dir; /run isn't committed anyway, but lint flags it
rm -rf /run/dnf
