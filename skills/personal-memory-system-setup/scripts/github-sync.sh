#!/bin/bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0

memory=$(cd "${1:?Usage: github-sync.sh <memory-repository>}" && pwd)
cd "$memory/.tmp/github-publish"
test -d .git

rm -rf memory always.md remote-recall.md
git -C "$memory" archive main -- memory always.md remote-recall.md | tar -x
git add --all -- memory always.md remote-recall.md
if ! git diff --cached --quiet; then
    git commit -m "Update published memory"
fi
git push origin main:main
