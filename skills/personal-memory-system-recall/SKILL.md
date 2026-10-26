---
name: personal-memory-system-recall
description: Load remembered context about requested topics into the current chat, read-only.
---
# Personal Memory System Recall

Local memory: `<local-path>`
GitHub memory: `<repository-url-or-none>`

This skill is read-only. Do not change the memory folder or repository.

1. The input is the topics to recall. Use the configured locations above: if both are set, ask “Local or GitHub?” and wait for the answer; if only one is set, use it; if neither is set, ask the owner to run setup and stop. Unfilled placeholders and `none` are unset. The selected root is `<memory-location>`. For GitHub, use the current tool's authenticated GitHub integration to read the default branch at one commit throughout recall. If the location is inaccessible or no topics are given, stop and report what is missing.
2. Read and follow `<memory-location>/always.md`.
3. Perform the Health Check below, then continue recall using the available memory.
4. Memory pages live under `<memory-location>/memory/`. Their YAML front matter contains `title`, optional `aliases`, and optional `parent` (a path relative to `memory/`). A page with a parent is a facet of that page; other relationships are links in its body.
5. For each requested topic, search memory page titles, aliases, and body text case-insensitively. If GitHub search is unavailable or may omit unindexed content, list and read the memory files directly. Search again using aliases found and obvious alternative names or spellings. Collect matching pages.
6. For each matching page, also collect its parent chain and its facets, including nested facets, using the `parent` relationships.
7. Read every collected page in full.
8. Use the pages as working context for the current chat. Treat dated information as what was known then, not automatically as current fact. When an answer depends on what is true now, verify against a current authoritative source; if verification is unavailable, state that the remembered information may be outdated.
9. Briefly report the topics loaded and any topics without a match. The context is now loaded; do not repeat all of it unless the owner asks.

## Health Check

Do not acquire a lock or make repairs. In either case, if a problem is found, end the final recall response with `Personal memory system health:` followed by a brief description, its effect, and a suggested next step.

### 1. Access to the worker machine's local memory folder

Perform these checks against the configured `Local memory` folder, using its `operations/shared/shared-concepts.md` to interpret configuration and state:

- **Black box:** Use recent source activity and Git history to check that eligible conversations from every configured source are being successfully memorized and pending work is progressing without falling unreasonably behind, allowing for inactivity windows, schedules, quiet periods, and backfill.
- **White box:** Check queue/backfill progress, `.lock` age, Git status, and the configured backup's presence and freshness. Account for active writers; use committed state for files they may be changing. Inspect scheduler/run records only when needed to investigate a suspected problem.
- **GitHub publishing:** If `GitHub memory` is configured, compare the three published paths with their committed local versions, allowing for the configured sync interval. The publishing checkout has separate history, so do not compare its commit IDs with the memory repository’s commit IDs. Investigate the scheduled job only if publishing is falling behind.

If the checks pass, end the final recall response with `Personal memory system health: OK`. Otherwise, explain which checks could not be completed.

### 2. No access to the worker machine's local memory folder

Skip health checks. End with `Personal memory system health: checks require access to the worker machine.`
