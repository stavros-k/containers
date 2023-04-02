#!/bin/bash
occ_logging(){
  echo '## Configuring Logging...'
  occ config:system:set loglevel --value="${NEXT_LOG_LEVEL:-2}"
  occ config:system:set logfile --value="${NEXT_LOG_FILE:-"/var/www/html/data/nextcloud.log"}"
  occ config:system:set logfile_audit --value="${NEXT_LOG_AUDIT_FILE:-"/var/www/html/data/audit.log"}"
  occ config:system:set logdateformat --value="${NEXT_LOG_DATE_FORMAT:-"d/m/Y H:i:s"}"
  occ config:system:set logtimezone --value="${NEXT_LOG_TIMEZONE:-$TZ}"
}
