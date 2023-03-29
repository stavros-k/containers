#!/bin/bash

# Check if config.php "installed" == true
# If not, generate the autoconfig.php file,
# by looking into the other config files fetching the config values needed

# Create a map for values
declare -A config_values

set_single_value () {
  local variable="$1"
  local required="$2"

  local conf_dir='/var/www/html/config'

  echo "INFO: Fetching value for $variable..."

  if [ ! -d $conf_dir ]; then
    echo "FATAL: Config directory $conf_dir not found, exiting..." && exit 1
  fi

  for file in "$conf_dir"/*.php; do
    value=$(php -r "require('$file'); echo \$CONFIG['$variable'];")

    if [ -n "$value" ]; then
      echo "INFO: Found value for $variable in $file"
      config_values["$variable"]="$value"
      break
    fi
  done

  if [ -z "$value" ]; then
    if [ "$required" = "true" ]; then
      echo "FATAL: Required value $variable not found, exiting..." && exit 1
    else
      echo "INFO: Optional value $variable not found, skipping..."
    fi
  fi
}

fetch_values () {
  echo 'INFO: Fetching values from config files...'

  set_single_value 'datadirectory'  'true' || exit 1
  set_single_value 'dbpassword'     'true' || exit 1
  set_single_value 'dbtype'         'true' || exit 1
  set_single_value 'dbname'         'true' || exit 1
  set_single_value 'dbuser'         'true' || exit 1
  set_single_value 'adminlogin'     'false' || exit 1
  set_single_value 'adminpass'      'false' || exit 1

  echo 'INFO: Values fetched.'
}

create_config () {
  echo 'INFO: Generating autoconfig...'
  local auto_conf_path='/var/www/html/config/autoconfig.php'
  mkdir -p "$(dirname "$auto_conf_path")"
  {
    echo '<?php'
    # shellcheck disable=SC2016
    echo '$AUTOCONFIG = ['
    echo "  \"directory\"       => \"${config_values['datadirectory']}\","
    echo "  \"dbtype\"          => \"${config_values['dbtype']}\","
    echo "  \"dbname\"          => \"${config_values['dbname']}\","
    echo "  \"dbuser\"          => \"${config_values['dbuser']}\","
    echo "  \"dbpass\"          => \"${config_values['dbpass']}\","

    if [ -n "${config_values['adminlogin']}" ] && [ -n "${config_values['adminpass']}" ]; then

    echo "  \"adminlogin\"      => \"${config_values['adminlogin']}\","
    echo "  \"adminpass\"       => \"${config_values['adminpass']}\","

    fi
  } > "$auto_conf_path"
  echo "INFO: Autoconfig generated in $auto_conf_path"
}

is_installed () {
  local conf_file='/var/www/html/config/config.php'

  installed=$(php -r "require('$conf_file'); echo \$CONFIG['key'] ?? 'false';")

  [ "$installed" = "true" ] && return 0 || return 1
}

echo 'INFO: Checking if Nextcloud is installed...'
if is_installed; then
  echo 'INFO: Nextcloud is already installed, skipping autoconfig...'
else
  echo 'INFO: Nextcloud is not installed...'
  fetch_values || exit 1
  create_config || exit 1
fi
