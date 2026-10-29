---
name: personal-memory-system-troubleshoot
description: Recover abandoned personal memory runs so scheduled processing can retry.
---
# Personal Memory System Troubleshoot

1. The input is the path to the personal memory folder, referred to here as `<memory-folder>`. If missing, stop. Follow `Scratch` in `<memory-folder>/operations/shared/shared-concepts.md`.
2. Check whether `<memory-folder>/.lock` exists and follow the corresponding case below.

## Lock exists

1. Inspect the lock directory’s modification time to determine its age. If it is less than one hour old, leave the files unchanged and stop.
2. Identify the run that owns the stale lock using scheduler and run records. Confirm it has stopped, or stop it and confirm termination. Confirm no other writer or recovery is active.
3. Keep the lock in place and recheck that it is the same stale lock. Discard uncommitted work and return to the last commit:
   ```sh
   git -C "<memory-folder>" reset --hard HEAD && git -C "<memory-folder>" clean -fd
   ```
4. Confirm Git is clean, then release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md`.

## No lock exists

1. Check Git status, including untracked files. If Git is clean, stop.
2. Confirm no writer or recovery is active. Acquire a recovery lock with `mkdir "<memory-folder>/.lock"`. If this fails, stop. Do not use `Acquire Lock`: its cleanliness check rejects the dirty state being recovered.
3. Discard uncommitted work and return to the last commit:
   ```sh
   git -C "<memory-folder>" reset --hard HEAD && git -C "<memory-folder>" clean -fd
   ```
4. Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md`.
