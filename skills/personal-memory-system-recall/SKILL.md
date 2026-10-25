---
name: personal-memory-system-recall
description: Load remembered context about requested topics into the current chat, read-only.
---
# Personal Memory System Recall

This skill is read-only. Do not create, edit, or delete files in the memory folder.

1. The input is the topics to recall, with an optional memory folder path. Default to `~/Desktop/personal-memory-system` when no path is given. Expand the path to an absolute path; this is `<memory-folder>` in this skill. If `<memory-folder>` is missing, or if no topics are given, stop and report what is missing.
2. Read and follow `<memory-folder>/always.md`.
3. Read the `Memory Pages` section of `<memory-folder>/operations/shared/shared-concepts.md` to locate and interpret memory pages.
4. For each requested topic, search memory page titles, aliases, and body text case-insensitively. Search again using aliases found and obvious alternative names or spellings. Collect matching pages.
5. For each matching page, also collect its parent chain and its facets, including nested facets, using the relationships defined in `Memory Pages`.
6. Read every collected page in full.
7. Use the pages as working context for the current chat. Treat dated information as what was known then, not automatically as current fact. When an answer depends on what is true now, verify against a current authoritative source; if verification is unavailable, state that the remembered information may be outdated.
8. Briefly report the topics loaded and any topics without a match. The context is now loaded; do not repeat all of it unless the owner asks.
