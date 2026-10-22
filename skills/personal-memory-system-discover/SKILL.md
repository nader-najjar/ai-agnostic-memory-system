---
name: personal-memory-system-discover
description: Find configured conversations and queue their labels.
---
# Personal Memory System Discover

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Record the current UTC time as `<run-start>`. Read the queue using the `Queue` section of `<memory-folder>/operations/shared/shared-concepts.md` and retain its `discovered_through` timestamp.
4. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`.
5. For each configured source, read its definition by following the process in the `Source Type Definitions` section of `<memory-folder>/operations/shared/shared-concepts.md`.
6. For each entry in the configuration’s `sources` array, use the source definition loaded for that entry in step 5:
    1. Search every directory in the entry’s `paths` array for files matching that definition’s **Source Items** criteria whose file modification time is at or after `discovered_through` and before `<run-start>`. Filter by modification time before reading file contents.
    2. For each source item, construct its conversation label using the `Conversation Label` section of `<memory-folder>/operations/shared/shared-concepts.md`. Retain each distinct label for the next step.
7. If any configured path cannot be searched or any candidate cannot be read, report the error, release the lock, and stop with the queue unchanged.
8. Build the next queue state in a unique temporary file in the queue file’s directory, starting from the queue read in step 3. Append each label retained in step 6 only if it is not already queued. Set `discovered_through` to `<run-start>`, even if no labels were added. Once complete, atomically rename the temporary file over `queue.json`.
9. Follow the `Commit Changes` section of `<memory-folder>/operations/shared/shared-concepts.md`.
10. Report the labels added, one per line, or report that no new labels were queued, and report the updated discovery timestamp.
11. Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` before finishing or stopping.
