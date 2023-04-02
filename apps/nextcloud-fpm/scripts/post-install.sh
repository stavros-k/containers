#!/bin/bash

# Installs the passed application if not already installed
install_app() {
  app_name="$1"

  if occ app:list | grep -wq "$app_name"; then
    echo "App "$app_name" is already installed! Skipping..."
    return 0
  fi

  echo "Installing $app_name..."
  if ! occ app:install "$app_name"; then
    echo "Failed to install $app_name..."
    exit 1
  fi

  echo "App $app_name installed successfuly!"
}

# Sets a space separated values into the specified list, by default for system settings
# Pass a 3rd argument for a different app
set_list() {
  list_name="${1:?"list_name is unset"}"
  space_delimited_values="${2:?"space_delimited_values is unset"}"
  app="${3:-"system"}"
  prefix="${4:-""}"

  if [ -n "${space_delimited_values}" ]; then
    echo "Re-setting $list_name"

    if [ "${app}" != 'system' ]; then
      occ config:app:delete $app $list_name
    else
      occ config:system:delete $list_name
    fi

    IDX=0
    for value in ${space_delimited_values} ; do
        value=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        if [ -n "${prefix}" ]; then
          value="$prefix$value"
        fi

        if [ "${app}" != 'system' ]; then
          occ config:app:set $app $list_name $IDX --value="$value"
        else
          occ config:system:set $list_name $IDX --value="$value"
        fi

        IDX=$(($IDX+1))
    done
  fi
}

# Source all configure-scripts.
for script in "/configure-scripts/*.sh"; do
  source "$script"
done

# Tune PHP-FPM
tune_fpm
# Configure General Settings
occ_general
# Configure Logging
occ_logging
# Configure URLs (Trusted Domains, Trusted Proxies, Overwrites, etc)
occ_urls
# Configure Expiration/Retention Days
occ_expire_retention

if [ ${NEXT_NOTIFY_PUSH:-"true"} == "true" ]; then
  # Configure Notify Push
  occ_notify_push
else
  echo '## Notify Push is disabled. Skipping...'
fi

# If Imaginary is enabled, previews are forced enabled
if [ ${NEXT_IMAGINARY:-"true"} == "true" ]; then
  NEXT_PREVIEWS="true"
  # Configure Imaginary
  occ_imaginary
else
  echo '## Imaginary is disabled. Skipping...'
fi

# If Imaginary is disabled but previews are enabled, configure only previews
if [ ${NEXT_PREVIEWS:-"true" == "true"} ] ; then
  # Configure Preview Generator
  occ_preview_generator
else
  echo '## Preview Generator is disabled. Skipping...'
fi

# Run maintenance/repairs/migrations
occ_maintenance

echo 'Starting Nextcloud PHP-FPM'

exec "$@"
