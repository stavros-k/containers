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

  echo "Fetching value for $variable..."

  if [ ! -d $conf_dir ]; then
    echo "Config directory $conf_dir not found, exiting..." && exit 1
  fi

  for file in "$conf_dir"/*.php; do
    value=$(php -r "require('$file'); echo \$CONFIG['$variable'];")

    if [ -n "$value" ]; then
      echo "Found value for $variable in $file"
      config_values["$variable"]="$value"
      break
    fi
  done

  if [ -z "$value" ]; then
    if [ "$required" = "true" ]; then
      echo "Required value $variable not found, exiting..." && exit 1
    else
      echo "Optional value $variable not found, skipping..."
    fi
  fi
}

fetch_values () {
  echo 'Fetching values from config files...'

  set_single_value 'datadirectory'  'true' || exit 1
  set_single_value 'dbpassword'     'true' || exit 1
  set_single_value 'dbtype'         'true' || exit 1
  set_single_value 'dbname'         'true' || exit 1
  set_single_value 'dbuser'         'true' || exit 1
  set_single_value 'adminlogin'     'false' || exit 1
  set_single_value 'adminpass'      'false' || exit 1

  echo 'Values fetched.'
}

create_config () {
  echo 'Generating autoconfig...'
  local auto_conf_path='/var/www/html/config/autoconfig.php'
  mkdir -p "$(dirname "$auto_conf_path")"
  {
    echo '<?php'
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
  echo "Autoconfig generated in $auto_conf_path"
}

is_installed () {
  local conf_file='/var/www/html/config/config.php'

  if [ -f "$conf_file" ]; then
    if grep -q -E 'installed.*=>.*true' "$conf_file"; then
      return 0
    fi
  fi

  return 1
}

echo 'Checking if Nextcloud is installed...'
if is_installed; then
  echo "Nextcloud is already installed, skipping autoconfig...\n"
else
  echo "Nextcloud is not installed...\n"
  fetch_values || exit 1
  create_config || exit 1
fi
