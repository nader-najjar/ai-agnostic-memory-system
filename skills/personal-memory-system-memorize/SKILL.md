---
name: personal-memory-system-memorize
description: Select the oldest queued conversation whose recorded source file exists.
---
# Personal Memory System Memorize

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the queue using the `Queue` section of `<memory-folder>/operations/shared/shared-concepts.md`. If the queue is empty, report that no conversations are queued, release the lock, and stop.
4. Check the recorded file paths in queue order and select the first entry whose source file exists. That selection is your `<selected-item>`. If no queued source file exists, report that no queued source files are currently available, release the lock, and stop.
5. Report the selected entry’s label and file path.
6. Release the acquired lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` before finishing or stopping.
