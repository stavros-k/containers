#!/bin/bash

occ config:system:set default_phone_region --value=${NEXT_DEFAULT_PHONE_REGION:-GR}
occ config:system:set overwrite.cli.url --value=${NEXT_OVERWRITE_CLI_URL:?"NEXT_OVERWRITE_CLI_URL is unset"}
occ config:system:set overwritehost --value=${NEXT_OVERWRITE_HOST:?"NEXT_OVERWRITE_HOST is unset"}
occ config:system:set overwriteprotocol --value=${NEXT_OVERWRITE_PROTOCOL:?"NEXT_OVERWRITE_PROTOCOL is unset"}
