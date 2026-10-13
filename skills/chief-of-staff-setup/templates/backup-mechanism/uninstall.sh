#!/bin/bash
# Stop the launchd backup job for a repository and remove its plist. Leaves the bundle and the log in place.
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 <repository>" >&2
  exit 2
fi

root=$(cd "$1" 2>/dev/null && pwd) || root="$1"
name=$(basename "$root")
label="com.$name.backup"
plist="$HOME/Library/LaunchAgents/$label.plist"

launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
rm -f "$plist"
echo "removed $label"
