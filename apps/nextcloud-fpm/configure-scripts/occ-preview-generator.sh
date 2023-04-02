occ_preview_generator() {
  echo '## Configuring Preview Generator...'
  install_app previewgenerator

  echo '## Configuring Preview Providers...'
  # Adds Imaginary always
  set_list 'enabledPreviewProviders' "Imaginary ${NEXT_PREVIEW_PROVIDERS:?"NEXT_PREVIEW_PROVIDERS is unset"}" 'system' 'OC\Preview\'

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
}
