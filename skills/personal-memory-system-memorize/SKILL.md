---
name: personal-memory-system-memorize
description: Select the oldest queued conversation and locate its current source file.
---
# Personal Memory System Memorize

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the queue using the `Queue` section of `<memory-folder>/operations/shared/shared-concepts.md`. If the queue is empty, report that no conversations are queued, release the lock, and stop.
4. Select the oldest queue entry as `<selected-item>`.
5. Locate the item's file:
    1. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`. Use the `Conversation Label` section of that file to identify the source type identifier for `<selected-item>`, and load its definition using the `Source Type Definitions` section.
    2. Search the selected source’s configured `paths` for files matching its definition’s **Source Items** criteria. Construct each candidate’s label using the `Conversation Label` section of `<memory-folder>/operations/shared/shared-concepts.md`, and stop searching when it matches `<selected-item>`’s label. If no source item matches, report an error with the selected label, release the lock, and stop with the queue unchanged.
6. Report the selected entry’s label and the matching source file’s absolute path.
7. Release the acquired lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` before finishing or stopping.
