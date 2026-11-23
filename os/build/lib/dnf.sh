# shellcheck shell=bash
# dnf helpers for the build scripts. Sourced, not run (see Containerfile for
# where it's mounted).

# Remove what a dnf run leaves behind. Call it at the end of every build step
# that runs dnf: each RUN is its own layer, and deleting files in a later step
# only hides them, they still ship in the layer that made them.
#
# Deliberately NOT clearing /var/cache or /var/lib/dnf. `dnf clean all` already
# reclaims ~143 MB; emptying what's left saves under 3 MB compressed on a 2.5 GB
# image, and only silences bootc lint's var-tmpfiles warning at the price of a
# hand-maintained tmpfiles.d list putting the package-owned dirs back. That list
# has to be re-checked every time the package set changes, so the warning is the
# better trade: the dirs are empty and their packages are happy to own them.
dnf_clean() {
  dnf clean all
  # Build logs don't belong in the image: content under /var is applied only on
  # first boot and never again on update, so it just goes stale (bootc lint,
  # check var-log). Pure noise, so nothing has to recreate them.
  rm -f /var/log/dnf5.log*
  # dnf's runtime lock dir; /run isn't committed anyway, but lint flags it
  rm -rf /run/dnf
}
