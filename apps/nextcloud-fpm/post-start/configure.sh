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
  list_name="$1"
  space_delimited_values="$2"
  app="${3:-"system"}"

  if [ -n "${space_delimited_values}" ]; then
    echo "Re-setting $list_name"
    occ config:system:delete $list_name
    IDX=1
    for value in ${space_delimited_values} ; do
        value=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        occ config:$app:set $list_name $IDX --value="$value"
        IDX=$(($IDX+1))
    done
  fi
}

echo 'Disabling WebUI Updater...'
occ config:system:set upgrade.disable-web --type=bool --value=true

echo 'Setting Default Phone Region...'
occ config:system:set default_phone_region --value=${NEXT_DEFAULT_PHONE_REGION:-GR}

echo 'Setting "Shared" folder to "Shared"'
occ config:system:set share_folder --value="Shared"

echo 'Setting Max Chunk Size for Files'
occ config:app:set files max_chunk_size --value="${NEXTCLOUD_CHUNKSIZE:-10485760}"

echo 'Setting Overwrite URLs...'
occ config:system:set overwrite.cli.url --value="${NEXT_OVERWRITE_CLI_URL:?"NEXT_OVERWRITE_CLI_URL is unset"}"
occ config:system:set overwritehost --value="${NEXT_OVERWRITE_HOST:?"NEXT_OVERWRITE_HOST is unset"}"
occ config:system:set overwriteprotocol --value="${NEXT_OVERWRITE_PROTOCOL:?"NEXT_OVERWRITE_PROTOCOL is unset"}"

echo 'Setting Trusted Domains'
set_list 'trusted_domains' "${NEXT_TRUSTED_DOMAINS:?"NEXT_TRUSTED_DOMAINS is unsed"}"

echo 'Setting Trusted Proxies'
set_list 'trusted_proxies' "${NEXT_TRUSTED_PROXIES:?"NEXT_TRUSTED_PROXIES is unsed"}"

echo 'Installing Apps...'
install_app notify_push
install_app previewgenerator

echo 'Applying migrations/repairs/optimizations...'
occ maintenance:repair
occ db:add-missing-indices
occ db:add-missing-columns
occ db:add-missing-primary-keys
yes | occ db:convert-filecache-bigint
occ maintenance:mimetype:update-js
occ maintenance:mimetype:update-db
occ maintenance:update:htaccess
