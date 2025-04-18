#!/bin/sh
occ_imaginary_install() {
  echo '## Configuring Imaginary...'
  echo ''

  occ config:system:set preview_imaginary_url --value="${NX_IMAGINARY_URL:?"NX_IMAGINARY_URL is unset"}"
}

occ_imaginary_remove() {
  echo '## Removing Imaginary Configuration...'
  echo ''

  occ config:system:delete preview_imaginary_url
}
