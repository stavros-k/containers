#!/bin/sh
# Replaces the OpenCloud Web apps directory ($APPS_DIR) with the apps listed in $APPS.
set -eu

dst=${APPS_DIR:-/var/lib/opencloud/web/assets/apps}

# It gets replaced as a whole, so refuse anything that holds more than apps
for path in "$dst"/*; do
	if [ -e "$path" ] && [ ! -f "$path/manifest.json" ]; then
		echo "$dst is not an apps directory, found $path"
		exit 1
	fi
done

rm -rf "$dst.new"
mkdir -p "$dst.new"
# shellcheck disable=SC2086 # Word splitting is intended
for app in $APPS; do
	if [ ! -d "/apps/$app" ]; then
		echo "Skipping unknown app $app"
		continue
	fi
	cp -R "/apps/$app" "$dst.new/"
	echo "Installed $app"
done
rm -rf "$dst"
mv "$dst.new" "$dst"
