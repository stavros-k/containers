#!/bin/sh
set -e

cron_file=${CRON_TAB_FILE:-/crontasks}

/usr/local/bin/supercronic ${cron_file}
