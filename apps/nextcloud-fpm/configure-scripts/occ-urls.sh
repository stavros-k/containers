#!/bin/sh
occ_urls() {
  echo "## Configuring URLs..."
  echo ''

  echo '### Configuring Overwrite URLs...'
  occ config:system:set overwrite.cli.url --value="${NX_OVERWRITE_CLI_URL:?"NX_OVERWRITE_CLI_URL is unset"}"
  occ config:system:set overwritehost --value="${NX_OVERWRITE_HOST:?"NX_OVERWRITE_HOST is unset"}"
  occ config:system:set overwriteprotocol --value="${NX_OVERWRITE_PROTOCOL:?"NX_OVERWRITE_PROTOCOL is unset"}"

  echo '### Configuring Trusted Domains...'
  [ "${NX_TRUSTED_DOMAINS:?"NX_TRUSTED_DOMAINS is unset"}" ]

  # If Collabora is enabled, add Collabora URL to trusted domains
  if [ "${NX_COLLABORA:-"false"}" = "true" ]; then
    [ "${NX_COLLABORA_URL:?"NX_COLLABORA_URL is unset"}" ]
    NX_COLLABORA_DOMAIN=$(extract_domain "$NX_COLLABORA_URL")
    if [ "${NX_COLLABORA_DOMAIN}" != "${NX_OVERWRITE_HOST}" ]; then
      NX_TRUSTED_DOMAINS="${NX_TRUSTED_DOMAINS} ${NX_COLLABORA_DOMAIN}"
    fi
  fi

  # If OnlyOffice is enabled, add OnlyOffice URL to trusted domains
  if [ "${NX_ONLYOFFICE:-"false"}" = "true" ]; then
    [ "${NX_ONLYOFFICE_URL:?"NX_ONLYOFFICE_URL is unset"}" ]
    NX_ONLYOFFICE_DOMAIN=$(extract_domain "$NX_ONLYOFFICE_URL")
    if [ "${NX_ONLYOFFICE_DOMAIN}" != "${NX_OVERWRITE_HOST}" ]; then
      NX_TRUSTED_DOMAINS="${NX_TRUSTED_DOMAINS} ${NX_ONLYOFFICE_DOMAIN}"
    fi
  fi

  set_list 'trusted_domains' "${NX_TRUSTED_DOMAINS}" 'system'

  echo '### Configuring Trusted Proxies...'
  set_list 'trusted_proxies' "${NX_TRUSTED_PROXIES:?"NX_TRUSTED_PROXIES is unsed"}" 'system'
}
