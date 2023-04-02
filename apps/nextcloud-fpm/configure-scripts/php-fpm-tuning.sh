#!/bin/bash
tune_fpm (){
  echo '## Applying PHP-FPM Tuning...'
  echo 'You can change default values with the following variables'
  echo "PHP_MAX_CHILDREN      (Default: 20) Current: ${PHP_MAX_CHILDREN:-20}"
  echo "PHP_START_SERVERS     (Default: 5)  Current: ${PHP_START_SERVERS:-5}"
  echo "PHP_MIN_SPARE_SERVERS (Default: 5)  Current: ${PHP_MIN_SPARE_SERVERS:-5}"
  echo "PHP_MAX_SPARE_SERVERS (Default: 15) Current: ${PHP_MAX_SPARE_SERVERS:-15}"
  echo ''
  echo 'Visit https://spot13.com/pmcalculator to see what values you should set'

  tune_file="/usr/local/etc/php-fpm.d/zz-tune.conf"

  {
    echo '[www]'
    echo "pm.max_children = ${PHP_MAX_CHILDREN:-20}"
    echo "pm.start_servers = ${PHP_START_SERVERS:-5}"
    echo "pm.min_spare_servers = ${PHP_MIN_SPARE_SERVERS:-5}"
    echo "pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-15}"
  } > "$tune_file"

  if [ -f "$tune_file" ] && [ -s "$tune_file" ]; then
    echo 'Tune file created!'
  else
    echo 'Tune file failed to create.'
}
