#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <memory-repository> <destination.bundle>" >&2
    exit 2
fi

repository=$1
destination_dir=$(cd "$(dirname "$2")" && pwd -P)
destination="$destination_dir/$(basename "$2")"

if [ -d "$destination" ]; then
    echo "Backup destination must be a file: $destination" >&2
    exit 2
fi

temporary=$(mktemp "$destination.tmp.XXXXXX")
trap 'rm -f "$temporary"' EXIT
trap 'exit 1' HUP INT TERM

git -C "$repository" bundle create "$temporary" --all
git -C "$repository" bundle verify "$temporary"
mv -f "$temporary" "$destination"
