#!/bin/sh

# Run all executable scripts in the /entrypoint.d/ directory.
# Scripts are executed in alphabetical order.
echo "#################################"
echo "### Running pre-start scripts ###"
echo "#################################\n"

for script in /entrypoint.d/pre-start/*.sh; do
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "## Running $script...\n"
    "$script" || exit 1
    echo "## Done running $script.\n"
  else
    echo "WARN: kipping $script, it is not executable."
  fi
done

echo "###################################"
echo "### Running original entrypoint ###"
echo "###################################\n"

# Also pass the command passed to the entrypoint
# As it's needed for some checks
/entrypoint.d/00-original-entrypoint.sh $@

echo "##################################"
echo "### Running post-start scripts ###"
echo "##################################\n"
for script in /entrypoint.d/post-start/*.sh; do
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "## Running $script...\n"
    "$script" || exit 1
    echo "## Done running $script.\n"
  else
    echo "WARN: Skipping $script, it is not executable."
  fi
done

# Run the command passed to the entrypoint.
exec "$@"
