#!/bin/bash
curr_dir="$1"

VERSION=$(grep "ENV NOTIFY_PUSH_VERSION" "$curr_dir"/Dockerfile | cut -d '=' -f2)

echo "$VERSION"
