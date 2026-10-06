#!/bin/bash
# Install (or reinstall) a launchd job that runs backup.sh --notify hourly and at login.
set -euo pipefail

label="com.chief-of-staff.backup"
plist="$HOME/Library/LaunchAgents/$label.plist"
log="$HOME/Library/Logs/chief-of-staff-backup.log"
domain="gui/$(id -u)"

if [ $# -ne 2 ]; then
  echo "usage: $0 <memory-root> <backup-folder>" >&2
  exit 2
fi

here=$(cd "$(dirname "$0")" && pwd)
script="$here/backup.sh"
root=$(cd "$1" 2>/dev/null && pwd) || { echo "memory root not found: $1" >&2; exit 1; }
dest=$(cd "$2" 2>/dev/null && pwd) || { echo "backup folder not found: $2" >&2; exit 1; }
[ -f "$script" ] || { echo "backup.sh not found next to install.sh" >&2; exit 1; }
git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repository: $root" >&2; exit 1; }
case "$dest/" in
  "$root/"*) echo "backup folder must be outside the memory root: $dest" >&2; exit 1 ;;
esac
gitdir=$(dirname "$(command -v git)")

xml() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<<"$1"; }

mkdir -p "$(dirname "$plist")" "$(dirname "$log")"
cat >"$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$(xml "$script")</string>
    <string>--notify</string>
    <string>$(xml "$root")</string>
    <string>$(xml "$dest")</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>$(xml "$gitdir"):/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>
  <key>StartInterval</key>
  <integer>3600</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$(xml "$log")</string>
  <key>StandardErrorPath</key>
  <string>$(xml "$log")</string>
</dict>
</plist>
EOF
plutil -lint -s "$plist"

# bootout fails harmlessly when the job is not loaded yet.
launchctl bootout "$domain/$label" 2>/dev/null || true
for _ in $(seq 1 10); do
  launchctl print "$domain/$label" >/dev/null 2>&1 || break
  sleep 1
done
launchctl bootstrap "$domain" "$plist"

# RunAtLoad starts the first run; wait for it to finish and read its exit code.
running=1
for _ in $(seq 1 300); do
  info=$(launchctl print "$domain/$label" 2>/dev/null || true)
  if ! grep -q 'state = running' <<<"$info" && grep -q 'last exit code = ' <<<"$info"; then
    running=0
    break
  fi
  sleep 1
done

if [ "$running" = "1" ]; then
  echo "installed $label: runs hourly and at login"
  echo "first run still in progress; check $log for its result"
  exit 0
fi
code=$(sed -n 's/.*last exit code = \([0-9-]*\).*/\1/p' <<<"$info" | head -1)

if [ "$code" = "0" ] && [ -f "$dest/chief-of-staff.bundle" ]; then
  echo "installed $label: runs hourly and at login"
  echo "bundle: $dest/chief-of-staff.bundle"
  echo "log:    $log"
else
  echo "installed $label, but the first run failed (exit code ${code:-unknown})" >&2
  echo "last log lines:" >&2
  tail -n 5 "$log" >&2 2>/dev/null || true
  exit 1
fi
