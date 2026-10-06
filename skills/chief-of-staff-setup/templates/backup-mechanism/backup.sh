#!/bin/bash
# Pack the memory root's committed history into <backup-folder>/chief-of-staff.bundle.
# Uncommitted edits are never included. Skips the write when the bundle is already current.
set -euo pipefail

usage() {
  echo "usage: $0 [--notify] <memory-root> <backup-folder>" >&2
  exit 2
}

notify=0
if [ "${1:-}" = "--notify" ]; then
  notify=1
  shift
fi
[ $# -eq 2 ] || usage

err=""
work=""
on_exit() {
  rc=$?
  [ -n "$work" ] && rm -rf "$work"
  if [ "$rc" -ne 0 ] && [ "$notify" -eq 1 ]; then
    # Pass the message as an argument so quotes in it cannot break the AppleScript.
    osascript -e 'on run argv' \
      -e 'display notification (item 1 of argv) with title "Chief-of-Staff backup failed"' \
      -e 'end run' "${err:-exit code $rc}" >/dev/null 2>&1 || true
  fi
}
trap on_exit EXIT

fail() {
  err="$1"
  echo "$err" >&2
  exit 1
}

root=$(cd "$1" 2>/dev/null && pwd) || fail "memory root not found: $1"
dest=$(cd "$2" 2>/dev/null && pwd) || fail "backup folder not found: $2"
git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "not a git repository: $root"

bundle="$dest/chief-of-staff.bundle"

# Build and verify locally first, so the synced folder only ever sees a finished file.
work=$(mktemp -d "${TMPDIR:-/tmp}/chief-of-staff-backup.XXXXXX")
new="$work/chief-of-staff.bundle"
out=$(git -C "$root" bundle create -q "$new" --all 2>&1) || fail "git bundle create failed: $out"
out=$(git -C "$root" bundle verify -q "$new" 2>&1) || fail "git bundle verify failed: $out"

# Same refs pointing at the same commits means the existing bundle is current.
if [ -f "$bundle" ] &&
  old_heads=$(git bundle list-heads "$bundle" 2>/dev/null) &&
  [ "$old_heads" = "$(git bundle list-heads "$new")" ]; then
  exit 0
fi

tmp="$dest/.chief-of-staff.bundle.tmp.$$"
cp "$new" "$tmp" || { rm -f "$tmp"; fail "could not write to $dest"; }
mv -f "$tmp" "$bundle" || { rm -f "$tmp"; fail "could not replace $bundle"; }
