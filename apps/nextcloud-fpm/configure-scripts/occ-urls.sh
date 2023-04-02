#!/bin/bash
occ_urls(){
  echo '## Configuring Overwrite URLs...'
  occ config:system:set overwrite.cli.url --value="${NX_OVERWRITE_CLI_URL:?"NX_OVERWRITE_CLI_URL is unset"}"
  occ config:system:set overwritehost --value="${NX_OVERWRITE_HOST:?"NX_OVERWRITE_HOST is unset"}"
  occ config:system:set overwriteprotocol --value="${NX_OVERWRITE_PROTOCOL:?"NX_OVERWRITE_PROTOCOL is unset"}"

  echo '## Configuring Trusted Domains...'
  set_list 'trusted_domains' "${NX_TRUSTED_DOMAINS:?"NX_TRUSTED_DOMAINS is unsed"}" 'system'

  echo '## Configuring Trusted Proxies...'
  set_list 'trusted_proxies' "${NX_TRUSTED_PROXIES:?"NX_TRUSTED_PROXIES is unsed"}" 'system'
}
