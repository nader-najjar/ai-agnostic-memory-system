---
name: personal-memory-system-troubleshoot
description: Recover abandoned personal memory runs so scheduled processing can retry.
---
# Personal Memory System Troubleshoot

1. The input is the path to the personal memory folder, referred to here as `<memory-folder>`. If missing, stop.
2. Inspect `<memory-folder>/.lock`. If no lock exists or it is less than two hours old, leave the files unchanged and stop.
3. Identify the run that owns the stale lock using scheduler and run records. Confirm it has stopped, or stop it and confirm termination. Confirm no other writer or recovery is active. If any of this cannot be confirmed, record the blockage in this run's result and stop without changing files.
4. Keep the lock in place and recheck that it is the same stale lock. Discard uncommitted work and return to the last commit:
   ```sh
   git -C "<memory-folder>" reset --hard HEAD && git -C "<memory-folder>" clean -fd
   ```
5. Confirm Git is clean, then release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md`. If cleanup fails, retain the lock and record the error in this run's result. Never commit an interrupted run's partial work. Let the next scheduled processing run retry.
