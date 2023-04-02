#!/bin/bash
occ_notify_push(){
  echo '## Configuring Notify Push...'
  install_app notify_push

  echo '## Configuring Notify Push Base Endpoint...'
  occ config:app:set notify_push base_endpoint --value="${NEXT_NOTIFY_PUSH_ENDPOINT:?"NEXT_NOTIFY_PUSH_ENDPOINT is unset"}"
}
