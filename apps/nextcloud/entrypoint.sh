#!/bin/sh

# Run all executable scripts in the /entrypoint.d/ directory.
# Scripts are executed in alphabetical order.

echo 'This container is expecting all configuration to be done via configuration files.'
echo 'Place your configuration files in /var/www/html/config. Those files will not be edited'
echo 'by this container, so you can safely mount them as a Secret/ConfigMap.'
echo 'The file /var/www/html/config/config.php WILL be edited by Nextcloud, as it stores there values'
echo 'like the instance id, the version of Nextcloud installed, and other generated values.'
echo 'It must be persisted and writable by the web server.'

echo ''
echo '#################################'
echo '### Running pre-start scripts ###'
echo '#################################'
echo ''

for script in /entrypoint.d/pre-start/*.sh; do
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "## Running $script..."
    echo ''
    "$script" || exit 1
    echo "## Done running $script."
    echo ''
  else
    echo "WARN: kipping $script, it is not executable."
  fi
done

echo ''
echo '###################################'
echo '### Running original entrypoint ###'
echo '###################################'
echo ''

# Also pass the command passed to the entrypoint
# As it's needed for some checks
/entrypoint.d/00-original-entrypoint.sh "$@"

echo ''
echo '##################################'
echo '### Running post-start scripts ###'
echo '##################################'
echo ''

for script in /entrypoint.d/post-start/*.sh; do
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "## Running $script..."
    echo ''
    "$script" || exit 1
    echo "## Done running $script."
    echo ''
  else
    echo "WARN: Skipping $script, it is not executable."
  fi
done

# Run the command passed to the entrypoint.
exec "$@"
