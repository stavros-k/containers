curr_dir=$(pwd)

VERSION=$(cat $curr_dir/Dockerfile | grep "ENV NOTIFY_PUSH_VERSION" | cut -d ' ' -f3)

echo "$VERSION"
