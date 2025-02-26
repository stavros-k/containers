#!/bin/bash
curr_dir="$1"
VERSION=$(grep "FROM jenkins/jenkins:" "$curr_dir"/Dockerfile | cut -d ':' -f2 | cut -d '@' -f1)

echo "$VERSION"
