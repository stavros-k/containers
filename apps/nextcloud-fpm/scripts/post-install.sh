#!/bin/bash
echo 'Applying PHP-FPM Tuning...'
echo 'You can change default values with the following variables'
echo "PHP_MAX_CHILDREN      (Default: 20) Current: ${PHP_MAX_CHILDREN:-20}"
echo "PHP_START_SERVERS     (Default: 5)  Current: ${PHP_START_SERVERS:-5}"
echo "PHP_MIN_SPARE_SERVERS (Default: 5)  Current: ${PHP_MIN_SPARE_SERVERS:-5}"
echo "PHP_MAX_SPARE_SERVERS (Default: 15) Current: ${PHP_MAX_SPARE_SERVERS:-15}"
echo ''
echo 'Visit https://spot13.com/pmcalculator to see what values you should set'

tune_file="/usr/local/etc/php-fpm.d/99-tune.conf"

{
  echo '[www]'
  echo "pm.max_children = ${PHP_MAX_CHILDREN:-20}"
  echo "pm.start_servers = ${PHP_START_SERVERS:-5}"
  echo "pm.min_spare_servers = ${PHP_MIN_SPARE_SERVERS:-5}"
  echo "pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-15}"
} > "$tune_file"

echo "Tune file ($tune_file):"
echo ''

cat $tune_file

chmod 755 $tune_file

echo '--------------------'

for script in /entrypoint.d/post-start/*.sh; do
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "## Running $script..."
    echo ''
    "$script" || exit 1
    echo ''
    echo "## Done running $script."
  else
    echo "WARN: Skipping $script, it is not executable."
  fi
done

echo '--------------------'

echo 'Starting Nextcloud PHP-FPM'

exec "$@"
