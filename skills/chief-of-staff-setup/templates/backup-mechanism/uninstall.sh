#!/bin/bash
# Stop the launchd backup job and remove its plist. Leaves the bundle and the log in place.
set -euo pipefail

label="com.chief-of-staff.backup"
plist="$HOME/Library/LaunchAgents/$label.plist"

launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
rm -f "$plist"
echo "removed $label"
