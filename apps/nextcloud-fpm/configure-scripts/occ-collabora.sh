#!/bin/sh
occ_collabora_install() {
  echo '## Configuring Collabora...'
  echo ''

  install_app richdocuments

  # https://github.com/nextcloud/richdocuments/blob/cbc8aded31e2847708860489a827e2e1f7557c14/lib/AppConfig.php#L16-L22
  occ config:app:set richdocuments wopi_url --value="${NX_INTERNAL_COLLABORA_URL:?"NX_INTERNAL_COLLABORA_URL is unset"}"
  occ config:app:set richdocuments public_wopi_url --value="${NX_COLLABORA_URL:?"NX_COLLABORA_URL is unset"}"
  occ config:app:set richdocuments wopi_allowlist --value="${NX_COLLABORA_ALLOWLIST:?"NX_COLLABORA_ALLOWLIST is unset"}"
}

occ_collabora_remove() {
  echo '## Removing Collabora Configuration...'
  echo ''

  remove_app richdocuments

  occ config:app:delete richdocuments wopi_url
  occ config:app:delete richdocuments public_wopi_url
  occ config:app:delete richdocuments wopi_allowlist
}
