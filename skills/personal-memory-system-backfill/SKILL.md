---
name: personal-memory-system-backfill
description: Retrieve approved history from configured conversation sources and queue snapshots for background memorization.
---
# Personal Memory System Backfill

`<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`.

1. Locate and read the full personal-memory-system source repository, including every skill and supporting file, to understand how the system works before acting. If unavailable, obtain a readable copy or location from the owner first. This means the source repository, not runtime memory data or Git internals.
2. Work interactively with the owner to confirm `<memory-folder>`, the configured sources, and the history scope to backfill. Read the memory configuration and selected source definitions in `<shared-concepts>`. Use judgment to agree on the retrieval approach and explain any limitations; do not broaden the approved scope.
3. Follow the source recipes' retrieval methods and formats, not their scheduling harness, to prepare and verify the selected history in request-specific temporary staging under `<memory-folder>/.tmp/scratch/`. Work interactively with the owner throughout retrieval. Do not interrupt ongoing work or change regular jobs, staging/checkpoint locations, or the discovery watermark. Do not hold the memory lock during retrieval or owner interaction.
4. Before modifying snapshots or the backfill worklist, follow `Acquire Lock` in `<shared-concepts>`; if it returns `false`, stop. Reread the configuration, queue, and backfill worklist under the lock and confirm the selected sources remain configured. Process only the approved, verified source items, retaining their actual filesystem modification times for capture filenames, without backdating or filtering them by the discovery watermark:
    1. Capture each source item to a unique temporary file in `<memory-folder>/operations/queue-snapshots/` using its source definition's **Capture** section. Determine the capture's filename using the `Capture` section of `<shared-concepts>` and its path relative to `<memory-folder>`.
    2. Find the latest processed capture for the same source type and UID in `<memory-folder>/captures/`, ordered by source modification time in its filename. Delete the temporary file and skip this source item if either condition holds:
        - The latest processed capture exists and the selected item’s modification time <= that capture’s source modification time.
        - The snapshot path already appears in either the queue or backfill worklist.
    3. Rename the temporary file to the determined filename and append `{"path": "<relative-path>"}` to the backfill worklist.
5. Save the backfill worklist, follow `Commit Changes`, then `Release Lock` in `<shared-concepts>`. Release the lock on failure too. Report what was queued and any gaps or failures; retain temporary staging if needed for retry.
