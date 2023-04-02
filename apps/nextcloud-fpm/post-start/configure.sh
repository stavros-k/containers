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

echo '## Disabling WebUI Updater...'
occ config:system:set upgrade.disable-web --type=bool --value=true

echo '## Configuring Default Phone Region...'
occ config:system:set default_phone_region --value=${NEXT_DEFAULT_PHONE_REGION:-GR}

echo '## Configuring "Shared" folder...'
occ config:system:set share_folder --value="${NEXT_SHARED_FOLDER_NAME:-Shared}"

echo '## Configuring Max Chunk Size for Files...'
occ config:app:set files max_chunk_size --value="${NEXT_MAX_CHUNKSIZE:-10485760}"

echo '## Configuring Expiring and Retention Days...'
occ config:system:set activity_expire_days --value="${NEXT_ACTIVITY_EXPIRE_DAYS:-90}"
occ config:system:set trashbin_retention_obligation --value="${NEXT_TRASH_RETENTION:-auto}"
occ config:system:set versions_retention_obligation --value="${NEXT_VERSIONS_RETENTION:-auto}"

echo '## Configuring Logging...'
occ config:system:set loglevel --value="${NEXT_LOG_LEVEL:-2}"
# Move the log files to a different dir?
occ config:system:set logfile --value="${NEXT_LOG_FILE:-"/var/www/html/logs/nextcloud.log"}"
occ config:system:set logfile_audit --value="${NEXT_LOG_AUDIT_FILE:-"/var/www/html/logs/audit.log"}"
occ config:system:set logdateformat --value="${NEXT_LOG_DATE_FORMAT:-"d/m/Y H:i:s"}"
occ config:system:set logtimezone --value="${NEXT_LOG_TIMEZONE:-$TZ}"

echo '## Configuring Overwrite URLs...'
occ config:system:set overwrite.cli.url --value="${NEXT_OVERWRITE_CLI_URL:?"NEXT_OVERWRITE_CLI_URL is unset"}"
occ config:system:set overwritehost --value="${NEXT_OVERWRITE_HOST:?"NEXT_OVERWRITE_HOST is unset"}"
occ config:system:set overwriteprotocol --value="${NEXT_OVERWRITE_PROTOCOL:?"NEXT_OVERWRITE_PROTOCOL is unset"}"

echo '## Configuring Trusted Domains...'
set_list 'trusted_domains' "${NEXT_TRUSTED_DOMAINS:?"NEXT_TRUSTED_DOMAINS is unsed"}" 'system'

echo '## Configuring Trusted Proxies...'
set_list 'trusted_proxies' "${NEXT_TRUSTED_PROXIES:?"NEXT_TRUSTED_PROXIES is unsed"}" 'system'

echo '## Installing Apps...'
install_app notify_push
install_app previewgenerator

echo '## Configuring Notify Push Base Endpoint...'
occ config:app:set notify_push base_endpoint --value="${NEXT_NOTIFY_PUSH_ENDPOINT:?"NEXT_NOTIFY_PUSH_ENDPOINT is unset"}"

echo '## Configuring Imaginary URL...'
occ config:system:set preview_imaginary_url --value="${NEXT_IMAGINARY_URL:?"NEXT_IMAGINARY_URL is unset"}"

echo '## Configuring Preview Providers...'
# Adds Imaginary always
set_list 'enabledPreviewProviders' "Imaginary ${NEXT_PREVIEW_PROVIDERS:?"NEXT_PREVIEW_PROVIDERS is unsed"}" 'system' 'OC\Preview\'

echo '## Configuring Preview Generation Configuration...'
occ config:system:set enable_previews --value=true
occ config:system:set preview_max_x --value="${NEXT_PREVIEW_MAX_X:-2048}"
occ config:system:set preview_max_y --value="${NEXT_PREVIEW_MAX_Y:-2048}"
occ config:system:set preview_max_memory --value="${NEXT_PREVIEW_MAX_MEMORY:-1024}"
occ config:system:set preview_max_filesize_image --value="${NEXT_PREVIEW_MAX_FILESIZE_IMAGE:-50}"
occ config:app:set previewgenerator squareSizes --value="${NEXT_PREVIEW_SQUARE_SIZES:-32 256}"
occ config:app:set previewgenerator widthSizes  --value="${NEXT_PREVIEW_WIDTH_SIZES:-256 384}"
occ config:app:set previewgenerator heightSizes --value="${NEXT_PREVIEW_HEIGHT_SIZES:-256}"
occ config:system:set jpeg_quality --value="${NEXT_JPEG_QUALITY:-60}"
occ config:app:set preview jpeg_quality --value="${NEXT_JPEG_QUALITY:-60}"

echo '## Applying migrations/repairs/optimizations...'
occ maintenance:repair
occ db:add-missing-indices
occ db:add-missing-columns
occ db:add-missing-primary-keys
yes | occ db:convert-filecache-bigint
occ maintenance:mimetype:update-js
occ maintenance:mimetype:update-db
occ maintenance:update:htaccess
