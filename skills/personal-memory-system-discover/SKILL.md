---
name: personal-memory-system-discover
description: Find configured conversations and queue their labels.
---
# Personal Memory System Discover

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`.
4. For each configured source, read its definition by following the process in the `Source Type Definitions` section of `<memory-folder>/operations/shared/shared-concepts.md`.
5. For each entry in the configuration’s `sources` array, use the source definition loaded for that entry in step 4:
   1. Search every directory in the entry’s `paths` array for files matching that definition’s **Source Items** criteria.
   2. For each source item, construct its conversation label using the `Conversation Label` section of `<memory-folder>/operations/shared/shared-concepts.md`. Retain each distinct label for the next step.
6. Read the queue using the `Queue` section of `<memory-folder>/operations/shared/shared-concepts.md`. For each label retained in step 5, append a new entry only if the label is not already queued.
7. Report the labels added, one per line, or report that the queue was unchanged.
8. Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` before finishing or stopping.
