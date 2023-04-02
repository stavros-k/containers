#!/bin/bash
occ_expire_retention() {
  echo '## Configuring Expiring and Retention Days...'
  occ config:system:set activity_expire_days --value="${NEXT_ACTIVITY_EXPIRE_DAYS:-90}"
  occ config:system:set trashbin_retention_obligation --value="${NEXT_TRASH_RETENTION:-auto}"
  occ config:system:set versions_retention_obligation --value="${NEXT_VERSIONS_RETENTION:-auto}"
}