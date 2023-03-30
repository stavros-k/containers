#!/bin/bash

if [ ! -n "$METRICS_PORT" ]; then
  echo 'NOTICE: METRICS_PORT not set, skipping metrics'
fi

/var/www/html/custom_apps/notify_push/bin/x86_64/notify_push \
  --port ${NOTIFY_PUSH_PORT:-7867} \
  --glob-config
  /var/www/html/config/config.php

# Maybe build a custom image?
# https://github.com/nextcloud/docker/pull/1466/files
