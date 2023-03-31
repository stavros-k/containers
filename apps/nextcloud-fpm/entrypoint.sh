#!/bin/sh

# Run all executable scripts in the /entrypoint.d/ directory.
# Scripts are executed in alphabetical order.

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
    echo ''
    echo "## Done running $script."
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
/entrypoint.d/00-original-entrypoint.sh "php-fpm"

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
    echo ''
    echo "## Done running $script."
  else
    echo "WARN: Skipping $script, it is not executable."
  fi
done

# Run the command passed to the entrypoint.
exec "$@"
