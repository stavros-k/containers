#!/bin/bash
curr_dir="$1"
VERSION=$(cat $curr_dir/Dockerfile | grep "FROM python:" | cut -d ':' -f2 | cut -d '@' -f1)

echo "$VERSION"
