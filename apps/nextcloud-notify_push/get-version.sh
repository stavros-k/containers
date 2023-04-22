#!/bin/bash
curr_dir="$1"

VERSION=$(cat $curr_dir/Dockerfile | grep "ENV NOTIFY_PUSH_VERSION" | cut -d ' ' -f3)

echo "$VERSION"
