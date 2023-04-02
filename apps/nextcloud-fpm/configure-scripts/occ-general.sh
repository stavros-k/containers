#!/bin/bash
occ_general() {
  echo '## Disabling WebUI Updater...'
  occ config:system:set upgrade.disable-web --type=bool --value=true

  echo '## Configuring Default Phone Region...'
  occ config:system:set default_phone_region --value=${NEXT_DEFAULT_PHONE_REGION:-GR}

  echo '## Configuring "Shared" folder...'
  occ config:system:set share_folder --value="${NEXT_SHARED_FOLDER_NAME:-Shared}"

  echo '## Configuring Max Chunk Size for Files...'
  occ config:app:set files max_chunk_size --value="${NEXT_MAX_CHUNKSIZE:-10485760}"
}
