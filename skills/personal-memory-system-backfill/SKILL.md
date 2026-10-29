---
name: personal-memory-system-backfill
description: Retrieve approved history from configured conversation sources and queue snapshots for background memorization.
---
# Personal Memory System Backfill

Inputs:
  1. `<memory-folder>` path
  2. Source type to onboard

Definitions:
  1. `<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`

1. Locate and read the full personal-memory-system source repository, including every skill and supporting file, to understand how the system works before acting. If unavailable, obtain a readable copy or location from the owner first. This means the source repository, not runtime memory data or Git internals.
2. Work interactively with the owner to confirm `<memory-folder>` and the history scope to backfill. Read the memory configuration, selected source definition, selected source setup recipe, and `Scratch` in `<shared-concepts>`. Use judgment to agree on the retrieval approach and explain any limitations; do not broaden the approved scope.
3. Read the source's setup recipe in depth. This recipe explains how its new data is incrementally fetched under normal, day-to-day operations. The backfill process will clearly require a similar, but modified, approach. Use your judgement and work with the user to download all the backfill items, following these rules:
    1. Do not disrupt any operational flow of the existing system. This includes using or changing the harness of the source recipe's day-to-day operation.
    2. Do not place files anywhere except under `<memory-folder>/.tmp/scratch/`
    3. Do not hold the memory lock in this step
    4. For each file downloaded, set its filesystem last modified time not to the current time, but rather to the time the item was truly last updated. This last updated time's semantics should be specified in the source setup recipe.
    5. For each file downloaded, set its filename using the exact same naming semantics the source setup recipe uses during day-to-day operations
4. Follow `Acquire Lock` in `<shared-concepts>`; if it returns `false`, stop. Reread the configuration, queue, and backfill worklist under the lock and confirm the selected source remains configured.
5. Capture the temporary files as backfill snapshots:
    1. For each temporary source item, determine the capture's filename using the `Capture Naming` section of `<shared-concepts>` and move it to `<memory-folder>/operations/queue-snapshots/` with that name. The UID is the temporary file's filename, and the `source-modified-time` is the temporary file's modification time.
    2. Find the latest processed capture for the same source type and UID in `<memory-folder>/captures/`, ordered by source modification time in its filename. Call this `<latest-capture>` If either of these conditions hold, delete the snapshot file:
        - `<latest-capture>` exists and the snapshot's modification time <= `<latest-capture>` source modification time.
        - The snapshot path already appears in either the queue or backfill worklist.
    3. Append `{"path": "<relative-path>"}` to the backfill worklist.
5. Save the backfill worklist, follow `Commit Changes`, then `Release Lock` in `<shared-concepts>`. Release the lock on failure too. Report what was queued and any gaps or failures; regenerate temporary staging if needed for retry.
