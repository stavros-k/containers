#!/bin/bash
curr_dir="$1"

VERSION=$(grep "ENV NOTIFY_PUSH_VERSION" "$curr_dir"/Dockerfile | cut -d ' ' -f3)

echo "$VERSION"
