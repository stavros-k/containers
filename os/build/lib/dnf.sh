# shellcheck shell=bash
# dnf helpers for the build scripts. Sourced, not run (see Containerfile for
# where it's mounted).

# Remove what a dnf run leaves behind. Call it at the end of every build step
# that runs dnf: each RUN is its own layer, and deleting files in a later step
# only hides them, they still ship in the layer that made them. The empty dirs
# dnf and the packages leave in /var are handled later by build/configure/var.sh.
dnf_clean() {
  dnf clean all
  # Build logs don't belong in the image: content under /var is applied only on
  # first boot and never again on update, so it just goes stale (bootc lint,
  # check var-log). Pure noise, so nothing has to recreate them.
  rm -f /var/log/dnf5.log*
  # dnf's repo state (countme markers) and lock: build-time only, recreated by
  # dnf whenever it runs again
  rm -rf /var/lib/dnf/repos /var/lib/dnf/system-repo.lock
  # dnf's runtime lock dir; /run isn't committed anyway, but lint flags it
  rm -rf /run/dnf
}
