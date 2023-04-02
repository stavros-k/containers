#!/bin/bash

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

echo 'Applying migrations/repairs/optimizations...'
occ maintenance:repair
occ db:add-missing-indices
occ db:add-missing-columns
occ db:add-missing-primary-keys
yes | occ db:convert-filecache-bigint
occ maintenance:mimetype:update-js
occ maintenance:mimetype:update-db
