---
name: personal-memory-system-troubleshoot
description: Recover abandoned personal memory runs so scheduled processing can retry.
---
# Personal Memory System Troubleshoot

1. The input is the path to the personal memory folder, referred to here as `<memory-folder>`. If missing, stop. Follow `Scratch` in `<memory-folder>/operations/shared/shared-concepts.md`.
2. Check whether `<memory-folder>/.lock` exists and follow the corresponding case below.

## Lock exists

1. Inspect the lock directory’s modification time to determine its age. If it is less than one hour old, leave the files unchanged and stop.
2. Read `.lock/owner.json` using `Lock Owner` in `<memory-folder>/operations/shared/shared-concepts.md`. Save its token and the directory's identity. Check the recorded session through that tool's supported status lookup. If the record is missing or invalid, lookup is unavailable or inconclusive, or any work in the session is active, leave files and lock unchanged and stop. Absence from a run list is not proof of termination; never stop an active run. Require positive evidence that the session has stopped and no writer or recovery is active.
3. Keep the lock in place and recheck its identity and unchanged owner record. Discard uncommitted work and return to the last commit:
   ```sh
   git -C "<memory-folder>" reset --hard HEAD && git -C "<memory-folder>" clean -fd
   ```
4. Confirm Git is clean, then follow `Release Lock` in `<memory-folder>/operations/shared/shared-concepts.md`, using the abandoned owner's token verified above.

## No lock exists

1. Check Git status, including untracked files. If Git is clean, stop.
2. Confirm no writer or recovery is active. Acquire a recovery lock with `mkdir "<memory-folder>/.lock"`. If this fails, stop. Do not use `Acquire Lock`: its cleanliness check rejects the dirty state being recovered.
3. Discard uncommitted work and return to the last commit:
   ```sh
   git -C "<memory-folder>" reset --hard HEAD && git -C "<memory-folder>" clean -fd
   ```
4. Remove the recovery lock with `rmdir "<memory-folder>/.lock"`.
