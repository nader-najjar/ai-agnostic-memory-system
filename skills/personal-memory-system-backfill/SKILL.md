---
name: personal-memory-system-backfill
description: Save snapshots of configured conversations from a requested date range for background memorization.
---
# Personal Memory System Backfill

`<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`.

1. Obtain the memory folder path, configured sources to backfill, and date range from the owner. Resolve the range to UTC start and end timestamps, using the owner's timezone for dates and including each requested day in full. This skill selects conversations by source modification time and captures their current contents.
2. Follow `Acquire Lock` in `<shared-concepts>`. If it returns `false`, stop.
3. Read the memory configuration and selected source definitions using the `Memory Configuration` and `Source Type Definitions` sections of `<shared-concepts>`.
4. Read the queue and backfill worklist using the `Queue` and `Backfill` sections of `<shared-concepts>`.
5. Set `<time-range>` to the requested start timestamp through the earlier of the requested end timestamp and the queue’s `discovered_through` timestamp, inclusive.
6. Follow each selected source’s **Discovery** section using its configured `locations`. Use its **Source Modification Time** section to select items whose modification time falls within `<time-range>`. Filter before reading content and retain each selected item’s modification time for its snapshot filename. Process matching items oldest modification time first:
    1. Capture each source item to a unique temporary file in `<memory-folder>/operations/queue-snapshots/` using its source definition's **Capture** section. Determine the capture's filename using the `Capture` section of `<shared-concepts>` and its path relative to `<memory-folder>`.
    2. Find the latest processed capture for the same source type and UID in `<memory-folder>/captures/`, ordered by source modification time in its filename. Delete the temporary file and skip this source item if either condition holds:
        - The latest processed capture exists and the selected item’s modification time <= that capture’s source modification time.
        - The snapshot path already appears in either the queue or backfill worklist.
    3. Rename the temporary file to the determined filename and append `{"path": "<relative-path>"}` to the backfill worklist.
7. Save the backfill worklist.
8. Follow the `Commit Changes` section of `<shared-concepts>`.
9. Release the lock using the `Release Lock` section of `<shared-concepts>`.
