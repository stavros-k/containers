#!/bin/sh
occ_expire_retention() {
  echo '## Configuring Expiring and Retention Days...'
  echo ''

  occ config:system:set activity_expire_days --value="${NX_ACTIVITY_EXPIRE_DAYS:-365}" --type=integer
  occ config:system:set trashbin_retention_obligation --value="${NX_TRASH_RETENTION:-auto}"
  occ config:system:set versions_retention_obligation --value="${NX_VERSIONS_RETENTION:-auto}"
}
