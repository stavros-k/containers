#!/bin/sh

# Note that this assumes:
# - Key is top-level key in config.php
# - Value is always a string
update_db_config() {
  key="$1"
  value="$2"
  filepath="$3"

  # We Base64 encode and decode the value to safely handle special characters
  php <<EOF
  <?php
    \$key = '$key';
    \$value = '$value';
    \$filepath = '$filepath';

    \$encoded_value = base64_decode('$(printf "%s" "$value" | base64)');

    include(\$filepath);
    \$CONFIG[\$key] = (string)\$encoded_value;
    file_put_contents(\$filepath, "<?php\n\\\$CONFIG = ".var_export(\$CONFIG, true).";\n");
EOF
}

occ_database() {
  echo '## Configuring Database...'

  config_file="{$NX_CONFIG_FILE_PATH:-/var/www/html/config/config.php}"

  if [ ! -f "$config_file" ]; then
    echo "Config file $config_file does not exist. Something is wrong."
    exit 1
  fi

  update_db_config 'dbtype' 'pgsql' "${config_file}"
  update_db_config 'dbhost' "${NX_POSTGRES_HOST:?"NX_POSTGRES_HOST is unset"}" "${config_file}"
  update_db_config 'dbname' "${NX_POSTGRES_NAME:?"NX_POSTGRES_NAME is unset"}" "${config_file}"
  update_db_config 'dbuser' "${NX_POSTGRES_USER:?"NX_POSTGRES_USER is unset"}" "${config_file}"
  update_db_config 'dbpassword' "${NX_POSTGRES_PASSWORD:?"NX_POSTGRES_PASSWORD is unset"}" "${config_file}"
  update_db_config 'dbport' "${NX_POSTGRES_PORT:-5432}" "${config_file}"

  # - https://github.com/nextcloud/server/issues/44924
  # Due to a bug in Nextcloud, you cannot use `occ` to update the db config if you are not connected to the database.

  # occ config:system:set dbtype --value="pgsql"
  # occ config:system:set dbhost --value="${NX_POSTGRES_HOST:?"NX_POSTGRES_HOST is unset"}"
  # occ config:system:set dbname --value="${NX_POSTGRES_NAME:?"NX_POSTGRES_NAME is unset"}"
  # occ config:system:set dbuser --value="${NX_POSTGRES_USER:?"NX_POSTGRES_USER is unset"}"
  # occ config:system:set dbpassword --value="${NX_POSTGRES_PASSWORD:?"NX_POSTGRES_PASSWORD is unset"}"
  # occ config:system:set dbport --value="${NX_POSTGRES_PORT:-5432}"
}
