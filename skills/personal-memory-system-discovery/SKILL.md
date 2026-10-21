---
name: personal-memory-system-discovery
description: Find configured conversations and report their source type, UID, and path.
---
# Personal Memory System Discovery

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`.
4. For each configured source, read its definition by following the process in the `Source Type Definitions` section of `<memory-folder>/operations/shared/shared-concepts.md`.
5. For each source configured, execute this step. Find matching files under the configured path and extract each conversation UID as defined by its source type. Decompress files for reading when needed; do not modify source files.
6. Report each conversation’s source type, UID, and file path.
7. Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` when finished.
