#!/bin/sh

# Run all executable scripts in the /entrypoint.d/ directory.
# Scripts are executed in alphabetical order.
for script in /entrypoint.d/*.sh; do
  echo "Checking $script if it is executable..."
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "Running $script..."
    "$script"
    echo "Done running $script."
  else
    echo "Skipping $script because it is not executable."
  fi
done

# Run the command passed to the entrypoint.
exec "$@"
