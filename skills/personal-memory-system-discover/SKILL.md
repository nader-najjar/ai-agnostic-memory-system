---
name: personal-memory-system-discover
description: Capture configured conversations and queue their snapshots.
---
# Personal Memory System Discover

`<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`.

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Follow `Acquire Lock` in `<shared-concepts>`, requiring an empty queue. If it returns `false`, stop.
3. Set `<cutoff>` to the current UTC time minus two hours.
4. Read the memory configuration using the `Memory Configuration` section of `<shared-concepts>`.
5. For each configured source, read its definition by following the process in the `Source Type Definitions` section of `<shared-concepts>`.
6. For each entry in the configuration’s `sources` array, use the source definition loaded for that entry in step 5:
    1. Search every directory in the entry’s `paths` array for files matching that definition’s **Source Items** criteria whose file modification time is after `discovered_through` and at or before `<cutoff>`. Filter by modification time before reading file contents.
    2. Capture each source item to a unique temporary file in `<memory-folder>/operations/queue-snapshots/` using its source definition’s **Capture** section.
    3. Determine the capture’s filename using the `Capture` section of `<shared-concepts>`. Rename the temporary file to that filename and retain its path relative to `<memory-folder>` for the next step.
7. For each relative path retained in step 6, append `{"path": "<relative-path>"}` to the queue’s `items` array. Set `discovered_through` to `<cutoff>`, even if no snapshots were added, and save the queue.
8. Follow the `Commit Changes` section of `<shared-concepts>`.
9. Release the lock using the `Release Lock` section of `<shared-concepts>`.
