create_config_from_vars () {
  env | grep NEXTCLOUD_CONFIG_FILE_ | while read -r line; do
    # Get the variable name (part before =)
    variable_name=$(echo "$line" | cut -d '=' -f 1 )
    # Get the file name (part after NEXTCLOUD_CONFIG_FILE_)
    file_name=$(echo "$variable_name" | sed 's/NEXTCLOUD_CONFIG_FILE_//g' | tr '[:upper:]' '[:lower:]')

    echo "INFO: Printing contents of [$variable_name] to [$file_name]..."

    conf_path="/var/www/html/config/$file_name.config.php"
    mkdir -p "$(dirname "$conf_path")"
    if [ -f "$conf_path" ]; then
      echo "INFO: File [$conf_path] already exists, creating backup..."
      cp "$conf_path" "$conf_path.$timestamp.bak"
    fi
    # Expand the "$variable_name" variable to get the value of that variable
    eval "echo \"\$$variable_name\"" > "$conf_path"
  done
}

timestamp=$(date +%d-%m-%Y_%H-%M-%S)
create_config_from_vars
