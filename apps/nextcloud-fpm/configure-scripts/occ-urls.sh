#!/bin/bash
occ_urls(){
  echo '## Configuring Overwrite URLs...'
  occ config:system:set overwrite.cli.url --value="${NEXT_OVERWRITE_CLI_URL:?"NEXT_OVERWRITE_CLI_URL is unset"}"
  occ config:system:set overwritehost --value="${NEXT_OVERWRITE_HOST:?"NEXT_OVERWRITE_HOST is unset"}"
  occ config:system:set overwriteprotocol --value="${NEXT_OVERWRITE_PROTOCOL:?"NEXT_OVERWRITE_PROTOCOL is unset"}"

  echo '## Configuring Trusted Domains...'
  set_list 'trusted_domains' "${NEXT_TRUSTED_DOMAINS:?"NEXT_TRUSTED_DOMAINS is unsed"}" 'system'

  echo '## Configuring Trusted Proxies...'
  set_list 'trusted_proxies' "${NEXT_TRUSTED_PROXIES:?"NEXT_TRUSTED_PROXIES is unsed"}" 'system'
}
