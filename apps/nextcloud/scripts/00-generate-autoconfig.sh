#!/bin/bash
set -ex;

# Check if config.php "installed" == true
# If not, generate the autoconfig.php file,
# by looking into the other config files fetching the config values needed

get_single_value () {
  local variable="$1"
  local required="$2"

  local conf_dir='/var/www/html/config'

  echo "Fetching value for $variable..." >&2
  if [ ! -d $conf_dir ]; then
    echo "Config directory $conf_dir not found, exiting..." >&2
    exit 1
  fi

  for file in "$conf_dir"/*.php; do
    value=$(php -r "require('$file'); echo \$CONFIG['$variable'];")
    if [ -n "$value" ]; then
      echo "Found value for $variable in $file" >&2
      break
    fi
  done

  if [ -z "$value" ]; then
    if [ "$required" = "true" ]; then
      echo "Required value $variable not found, exiting..." >&2
      exit 1
    else
      echo "Optional value $variable not found, skipping..." >&2
      return 0
    fi
  fi

  # All above echo's print to stderr, so the stdout is clean
  echo "$value"
}

fetch_values () {
  echo 'Fetching values from config files...'

  auto_data_dir=$(get_single_value 'datadirectory' 'true')
  auto_db_pass=$(get_single_value 'dbpassword' 'true')
  auto_db_type=$(get_single_value 'dbtype' 'true')
  auto_db_name=$(get_single_value 'dbname' 'true')
  auto_db_user=$(get_single_value 'dbuser' 'true')
  auto_admin_user=$(get_single_value 'adminlogin' 'false')
  auto_admin_pass=$(get_single_value 'adminpass' 'false')

  echo 'Values fetched.'
}

create_config () {
  echo 'Generating autoconfig...'
  local auto_conf_path='/var/www/html/config/autoconfig.php'
  mkdir -p "$(dirname "$auto_conf_path")"
  {
    echo '<?php'
    echo '$AUTOCONFIG = ['
    echo "  \"directory\"       => \"$auto_data_dir\","
    echo "  \"dbtype\"          => \"$auto_db_type\","
    echo "  \"dbname\"          => \"$auto_db_name\","
    echo "  \"dbuser\"          => \"$auto_db_user\","
    echo "  \"dbpass\"          => \"$auto_db_pass\","

    if [ -n "$auto_admin_user" ] && [ -n "$auto_admin_pass" ]; then

    echo "  \"adminlogin\"      => \"$auto_admin_user\","
    echo "  \"adminpass\"       => \"$auto_admin_pass\","

    fi
  } > "$auto_conf_path"
  echo "Autoconfig generated in $auto_conf_path"
}

is_installed () {
  echo 'Checking if Nextcloud is installed...'
  local conf_file='/var/html/config/config.php'
  if [ -f "$conf_file" ]; then
    if grep -q -E 'installed.*=>.*true' "$conf_file"; then
      return 0
    fi
  fi

  return 1
}

if is_installed; then
  echo 'Nextcloud is already installed, skipping autoconfig...'
else
  echo 'Nextcloud is not installed...'
  fetch_values
  create_config
fi

exit 0
