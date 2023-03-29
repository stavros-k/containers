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

  echo "INFO: Getting value for key $variable..."

  if [ ! -d $conf_dir ]; then
    echo "FATAL: Config directory [$conf_dir] not found, exiting..." && exit 1
  fi

  for file in "$conf_dir"/*.php; do
    value=$(php -r "require('$file'); echo \$CONFIG['$variable'] ?? '';")

    if [ -n "$value" ]; then
      echo "INFO: Found value for [$variable] in [$file]"
      config_values["$variable"]="$value"
      break
    fi
  done

  if [ -z "$value" ]; then
    if [ "$required" = "true" ]; then
      echo "FATAL: Required value for key [$variable] not found, exiting..." && exit 1
    else
      echo "INFO: Optional value for key [$variable] not found, skipping..."
    fi
  fi
}

fetch_values () {
  echo 'INFO: Gathering values needed for autoconfig from config files...'
  #                variable        required
  set_single_value 'dbtype'         'true' || exit 1
  set_single_value 'dbname'         'true' || exit 1
  set_single_value 'dbuser'         'true' || exit 1
  set_single_value 'dbhost'         'true' || exit 1
  set_single_value 'dbpassword'     'true' || exit 1
  set_single_value 'datadirectory'  'true' || exit 1
  set_single_value 'adminlogin'     'false' || exit 1
  set_single_value 'adminpass'      'false' || exit 1

  echo 'INFO: Values gathered.'
}

# There are some differences between the config.php and autoconfig.php
# autoconfig.php - config.php:
# directory   - datadirectory
# dbpass      - dbpassword
create_autoconfig () {
  echo 'INFO: Generating autoconfig.php ...'
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
    echo "  \"dbpass\"          => \"${config_values['dbpassword']}\","
    echo "  \"dbhost\"          => \"${config_values['dbhost']}\","

    if [ -n "${config_values['adminlogin']}" ] && [ -n "${config_values['adminpass']}" ]; then

    echo "  \"adminlogin\"      => \"${config_values['adminlogin']}\","
    echo "  \"adminpass\"       => \"${config_values['adminpass']}\","

    fi

    echo "];"

  } > "$auto_conf_path"
  echo "INFO: Autoconfig generated at $auto_conf_path"
}

create_config_from_vars () {
  env | grep NEXTCLOUD_CONFIG_FILE_ | while read -r line; do
    # Get the variable name (part before =)
    variable_name=$(echo "$line" | cut -d '=' -f 1 )
    # Get the file name (part after NEXTCLOUD_CONFIG_FILE_)
    file_name=$(echo "$variable_name" | sed 's/NEXTCLOUD_CONFIG_FILE_//g' | tr '[:upper:]' '[:lower:]')

    echo "INFO: Printing contents of [$variable_name] to [$file_name]..."

    conf_path="/var/www/html/config/$file_name.config.php"
    mkdir -p "$(dirname "$conf_path")"
    if [ -f "$conf_path" ]; then
      echo "INFO: File [$conf_path] already exists, creating backup..."
      cp "$conf_path" "$conf_path.bak"
    fi
    # Expand the "$variable_name" variable to get the value of that variable
    eval "echo \"\$$variable_name\"" > "$conf_path"
  done
}

is_installed () {
  local conf_file='/var/www/html/config/config.php'

  installed=$(php -r "require('$conf_file'); echo \$CONFIG['installed'] ?? 'false';")

  if [ "$installed" = "true" ] || [ "$installed" = "1" ]; then
    return 0
  fi
  return 1
}

echo 'INFO: Checking if Nextcloud is installed...'
if is_installed; then
  echo 'INFO: Nextcloud is already installed'
  echo 'INFO: Skipping autoconfig generation...'
else
  echo 'INFO: Nextcloud is not installed...'
  create_config_from_vars || exit 1
  fetch_values || exit 1
  create_autoconfig || exit 1
fi
