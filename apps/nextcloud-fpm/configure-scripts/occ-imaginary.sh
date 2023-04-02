#!/bin/bash
occ_imaginary_install() {
  echo '## Configuring Imaginary URL...'
  occ config:system:set preview_imaginary_url --value="${NEXT_IMAGINARY_URL:?"NEXT_IMAGINARY_URL is unset"}"
}

occ_imaginary_remove() {
  echo '## Removing Imaginary URL...'
  occ config:system:delete preview_imaginary_url
}
