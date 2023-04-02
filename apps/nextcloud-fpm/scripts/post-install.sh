#!/bin/bash

# Installs the passed application if not already installed
install_app() {
  app_name="${1:?"app_name is unset"}"

  echo "Installing $app_name..."

  if occ app:list | grep -wq "$app_name"; then
    echo "App "$app_name" is already installed! Skipping..."
    return 0
  fi

  if ! occ app:install "$app_name"; then
    echo "Failed to install $app_name..."
    exit 1
  fi

  echo "App $app_name installed successfuly!"
}

remove_app() {
  app_name="${1:?"app_name is unset"}"

  echo "Removing $app_name..."

  if ! occ app:list | grep -wq "$app_name"; then
    echo "App "$app_name" is not installed! Skipping..."
    return 0
  fi

  if ! occ app:remove "$app_name"; then
    echo "Failed to remove $app_name..."
    exit 1
  fi

  echo "App $app_name removed successfuly!"
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

### Source all configure-scripts. ###
for script in "/configure-scripts/*.sh"; do
  source "$script"
done

### Start Configuring ###
echo '++++++++++++++++++++++++++++++++++++++++++++++++++'

# Tune PHP-FPM
if [ ${NEXT_TUNE_FPM:-"true"} == "true" ]; then
  echo '## PHP-FPM tuning is enabled.'
  tune_fpm_install
else
  echo '## PHP-FPM tuning is disabled.'
  tune_fpm_remove
fi

# Configure General Settings
occ_general
# Configure Logging
occ_logging
# Configure URLs (Trusted Domains, Trusted Proxies, Overwrites, etc)
occ_urls
# Configure Expiration/Retention Days
occ_expire_retention

if [ ${NEXT_NOTIFY_PUSH:-"true"} == "true" ]; then
  echo '## Notify Push is enabled.'
  occ_notify_push_install
else
  echo '## Notify Push is disabled.'
  occ_notify_push_remove
fi

# If Imaginary is enabled, previews are forced enabled
if [ ${NEXT_IMAGINARY:-"true"} == "true" ]; then
  NEXT_PREVIEWS="true"
  echo '## Imaginary is enabled.'
  occ_imaginary_install
else
  echo '## Imaginary is disabled.'
  occ_imaginary_remove
fi

# If Imaginary is disabled but previews are enabled, configure only previews
if [ ${NEXT_PREVIEWS:-"true" == "true"} ] ; then
  echo '## Preview Generator is enabled.'
  occ_preview_generator_install
else
  echo '## Preview Generator is disabled.'
  occ_preview_generator_remove
fi

echo '++++++++++++++++++++++++++++++++++++++++++++++++++'
### End Configuring ###

echo '--------------------------------------------------'
# Run maintenance/repairs/migrations
if [ ${NEXT_RUN_MAINTENANCE:-"true"} == "true" ]; then
  echo '## Maintenance is enabled. Running...'
  occ_maintenance
else
  echo '## Maintenance is disabled. Skipping...'
fi
echo '--------------------------------------------------'

echo 'Starting Nextcloud PHP-FPM'

exec "$@"
