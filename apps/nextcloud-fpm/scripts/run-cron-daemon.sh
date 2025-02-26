#!/bin/sh
set -e

while [ ! -f "/var/www/html/lib/versioncheck.php" ]; do
  echo 'Waiting Nextcloud to be installed...'
  echo 'Sleeping for 2m...'
  sleep 2m
done

cron_file=${CRON_TAB_FILE:-/crontasks}

/usr/local/bin/supercronic ${cron_file}
