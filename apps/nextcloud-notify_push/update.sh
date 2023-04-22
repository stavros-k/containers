#!/bin/bash
curr_dir="$1"

notify_push_version="$(
	git ls-remote --tags https://github.com/nextcloud/notify_push.git \
		| cut -d/ -f3 \
		| grep -vE -- '-rc|-b' \
		| tr -d '^{}' \
		| sed -E 's/^v//' \
		| sort -V \
		| tail -1
)"

curr_version="$(cat "$curr_dir/Dockerfile" | grep "ENV NOTIFY_PUSH_VERSION" | cut -d ' ' -f3)"

if [ "$notify_push_version" = "$curr_version" ]; then
	echo 'Already up-to-date'
	exit 0
fi

echo "Updating notify_push version: $notify_push_version"

sed -re 's/^ENV NOTIFY_PUSH_VERSION .*$/ENV NOTIFY_PUSH_VERSION '"$notify_push_version"'/;' -i "$curr_dir/Dockerfile"

echo 'Updated Dockerfile:'
echo ''
cat "$curr_dir/Dockerfile"
