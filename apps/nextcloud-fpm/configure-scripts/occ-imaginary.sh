#!/bin/bash
occ_imaginary(){
  echo '## Configuring Imaginary URL...'
  occ config:system:set preview_imaginary_url --value="${NEXT_IMAGINARY_URL:?"NEXT_IMAGINARY_URL is unset"}"
}
