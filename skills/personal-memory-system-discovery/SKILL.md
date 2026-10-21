---
name: personal-memory-system-discovery
description: Find configured conversations and report their conversation labels.
---
# Personal Memory System Discovery

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`.
4. For each configured source, read its definition by following the process in the `Source Type Definitions` section of `<memory-folder>/operations/shared/shared-concepts.md`.
5. For each entry in the configuration’s `sources` array, use the source definition loaded for that entry in step 4:
   1. Search every directory in the entry’s `paths` array for files matching that definition’s **Source Items** criteria.
   2. For each source item, extract its conversation UID according to that same definition’s **UID** section.
6. Report each distinct conversation label once, one per line, using the `Conversation Label` section of `<memory-folder>/operations/shared/shared-concepts.md`.
7. Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` when finished.
