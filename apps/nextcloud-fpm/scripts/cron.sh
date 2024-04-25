#!/bin/bash
trap "echo 'SIGTERM received, exiting'; exit" SIGTERM

uid="$(id -u)"
gid="$(id -g)"

if [ "$uid" = '0' ]; then
  user='www-data'
  group='www-data'
else
  user="$uid"
  group="$gid"
fi

echo "Running as ${user}:${group}"

run_cron() {
  if [ "$(id -u)" = 0 ]; then
    su -p "$user" -s /bin/bash -c 'php /var/www/html/cron.php'
  else
    /bin/bash -c 'php /var/www/html/cron.php'
  fi
}

while [ ! -f "/var/www/html/lib/versioncheck.php" ];
do
  echo 'Waiting Nextcloud to be installed...'
  echo 'Sleeping for 3m...'
  sleep 3m
done

while true;
do
  run_cron || echo "run_cron failed"
  if [ ${PREVIEW_GEN:-"false"} = "true" ]; then
    occ preview:pre-generate || echo "preview:pre-generate failed"
  fi
  echo "Sleeping for 5 min"
  sleep 5m
done
