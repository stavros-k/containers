#!/bin/bash
curr_dir="$1"

# Track the upstream Tika release this image is built on
VERSION=$(grep -m1 '^FROM apache/tika:' "$curr_dir"/Dockerfile | sed -E 's|^FROM apache/tika:([0-9.]+)-full@.*|\1|')

echo "$VERSION"
