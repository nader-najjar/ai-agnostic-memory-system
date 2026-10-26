---
name: personal-memory-system-recall
description: Load remembered context about requested topics into the current chat, read-only.
---
# Personal Memory System Recall

This skill is read-only. Do not create, edit, or delete files in the memory folder.

1. The input is the topics to recall, with an optional memory folder path. Default to `~/Desktop/personal-memory-system` when no path is given. Expand the path to an absolute path; this is `<memory-folder>` in this skill. If `<memory-folder>` is missing, or if no topics are given, stop and report what is missing.
2. Read and follow `<memory-folder>/always.md`.
3. Perform the Health Check below, then continue recall using the available memory.
4. Read the `Memory Pages` section of `<memory-folder>/operations/shared/shared-concepts.md` to locate and interpret memory pages.
5. For each requested topic, search memory page titles, aliases, and body text case-insensitively. Search again using aliases found and obvious alternative names or spellings. Collect matching pages.
6. For each matching page, also collect its parent chain and its facets, including nested facets, using the relationships defined in `Memory Pages`.
7. Read every collected page in full.
8. Use the pages as working context for the current chat. Treat dated information as what was known then, not automatically as current fact. When an answer depends on what is true now, verify against a current authoritative source; if verification is unavailable, state that the remembered information may be outdated.
9. Briefly report the topics loaded and any topics without a match. The context is now loaded; do not repeat all of it unless the owner asks.

## Health Check

Use `<memory-folder>/operations/shared/shared-concepts.md` to interpret the configuration and state.

**Black box:** Use recent source activity and Git history to check that eligible conversations from every configured source are being successfully memorized and pending work is progressing without falling unreasonably behind, allowing for inactivity windows, schedules, quiet periods, and backfill.

**White box:** Check queue/backfill progress, `.lock` age, Git status, and the configured backup's presence and freshness. Account for active writers; use committed state for files they may be changing. Inspect scheduler/run records only when needed to investigate a suspected problem.

Do not acquire a lock or make repairs. End the final recall response with `Personal memory system health: OK` if the checks passed. If a problem was found, replace `OK` with a brief description, its effect, and a suggested next step. If health could not be verified, say so and explain what could not be checked.
