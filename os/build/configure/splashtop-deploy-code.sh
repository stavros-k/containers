#!/usr/bin/env bash
# Optional Splashtop deploy code, from the SPLASHTOP_DEPLOY_CODE build arg (see
# Containerfile). Without it no file is shipped and splashtop-deploy.service
# skips itself (deploy by hand: `splashtop-streamer deploy <code>`).
set -euo pipefail # no -x: the trace would print the code into the build log

if [ -n "${SPLASHTOP_DEPLOY_CODE:-}" ]; then
  printf '%s\n' "$SPLASHTOP_DEPLOY_CODE" |
    install -D -m 0600 /dev/stdin /usr/lib/kiosk/splashtop-deploy-code
fi
