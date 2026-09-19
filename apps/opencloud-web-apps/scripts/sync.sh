#!/bin/sh
# Replaces the OpenCloud Web apps directory with the apps listed in $APPS.
set -eu

dst=/var/lib/opencloud/web/assets/apps

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
