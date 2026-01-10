#!/bin/sh
occ_general() {
  echo "## Configuring General Settings..."
  echo ''

  echo '### Disabling WebUI Updater...'
  occ config:system:set upgrade.disable-web --type=bool --value=true

  echo '### Configuring Default Phone Region...'
  occ config:system:set default_phone_region --value="${NX_DEFAULT_PHONE_REGION:-GR}"

  echo '### Configuring "Shared" folder...'
  occ config:system:set share_folder --value="${NX_SHARED_FOLDER_NAME:-Shared}"

  echo '### Configuring Max Chunk Size for Files...'
  occ config:app:set files max_chunk_size --value="${NX_MAX_CHUNKSIZE:-10485760}"

  echo '### Configuring Maintenance Window Start...'
  occ config:system:set maintenance_window_start --type=integer --value="${NX_MAINTENANCE_WINDOW_START:-100}"

  echo '## Configuring the cache dir...'
  export XDG_CACHE_HOME=/var/www/html/.cache
}
