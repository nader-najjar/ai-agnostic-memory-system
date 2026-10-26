---
name: personal-memory-system-discover
description: Capture configured conversations and queue their snapshots.
---
# Personal Memory System Discover

`<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`.

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Follow `Acquire Lock` in `<shared-concepts>`. If it returns `false`, stop.
3. Read the queue using the `Queue` section of `<shared-concepts>`. If its `items` array is nonempty, release the lock and stop.
4. Set `<cutoff>` to the current UTC time minus two hours.
5. Read the memory configuration using the `Memory Configuration` section of `<shared-concepts>`.
6. For each configured source, read its definition by following the process in the `Source Type Definitions` section of `<shared-concepts>`.
7. For each entry in the configuration’s `sources` array, use the source definition loaded for that entry in step 6:
    1. Follow the definition’s **Discovery** section using the entry’s `locations`. Use its **Source Modification Time** section to select items whose modification time is after `discovered_through` and at or before `<cutoff>`. Filter before reading content and retain each selected item’s modification time for its snapshot filename.
    2. Capture each source item to a unique temporary file in `<memory-folder>/operations/queue-snapshots/` using its source definition’s **Capture** section.
    3. Determine the capture’s filename using the `Capture` section of `<shared-concepts>`. Rename the temporary file to that filename and retain its path relative to `<memory-folder>` for the next step.
8. For each relative path retained in step 7, append `{"path": "<relative-path>"}` to the queue’s `items` array. Set `discovered_through` to `<cutoff>`, even if no snapshots were added.
9. If the queue’s `items` array has fewer than two entries, read the backfill worklist using the `Backfill` section of `<shared-concepts>`. While the queue has fewer than two entries and the backfill worklist is nonempty, take the first entry from the backfill worklist’s `items` array, remove it, and append it to the queue’s `items` array.
10. Follow the `Commit Changes` section of `<shared-concepts>`.
11. Release the lock using the `Release Lock` section of `<shared-concepts>`.
