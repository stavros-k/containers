curr_dir=$(pwd)

VERSION=$(cat $curr_dir/Dockerfile | grep "FROM nextcloud:" | cut -d ':' -f2 | cut -d '@' -f1)

echo "$VERSION"
