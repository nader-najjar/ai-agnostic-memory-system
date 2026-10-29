---
name: personal-memory-system-offboard-source
description: Stop collecting a selected conversation source in an existing personal memory system while retaining its captures and memories.
---
# Personal Memory System Offboard Source

Inputs: an existing `<memory-folder>` path and, optionally, a source to remove.
`<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`.

## Confirm the Scope

1. Resolve the memory folder to an absolute path. Read its `config.json` and the `Memory Configuration`, `Source Type Definitions`, and `Scratch` sections of `<shared-concepts>`. Ask the owner to select or confirm one source identifier and all its configured locations.
2. Explain that offboarding stops future collection, not forgetting: existing captures, memories, staged files, Library exports, and Git history remain. Already saved queue and backfill snapshots remain scheduled for normal memorization, so memories can still change after offboarding. Ask the owner to approve this scope before proceeding. If they want pending ingestion stopped or stored data removed, resolve that as a separate request rather than silently changing this default.

## Stop Source Jobs

1. Locate the installed `personal-memory-system-setup` skill and read the selected source's recipe in `source-setup/`. Use its job types and the actual scheduler definitions to identify export, download, or local sync jobs for the approved source and destinations. Match task contents, paths, Library folder references, and dot room IDs where applicable; a job name alone is not enough.
2. Disable only jobs dedicated to this source and memory folder. Keep an exporter or sync job used by another memory folder or consumer running; stop this memory folder's dedicated downstream job instead. If a job's scope or other consumers are unclear, ask before changing it. Do not stop shared discovery, memorization, troubleshooting, backup, or GitHub publishing jobs.
3. For jobs owned by another tool or dot, give the owner a handoff prompt identifying the exact job, approved scope, and instruction to disable it and report its resulting state without deleting data. Do not hold the memory lock during scheduler work or while waiting for a handoff.
4. Verify that each dedicated job is disabled and no run remains active; disabling a schedule alone does not stop an in-flight run. Wait for active runs to finish, or obtain approval for cancellation. If any required job cannot be identified, stopped, or verified, report the stopped jobs and what remains; do not claim completion or remove the source configuration yet.

## Remove from Discovery

1. Follow `Acquire Lock` in `<shared-concepts>`; if it returns `false`, stop and report that source jobs have been stopped but configuration still needs updating. Reread `config.json` under the lock. If the selected entry's locations have changed since approval, release the lock and reconfirm the scope before proceeding. If the entry is already absent, release the lock and report that no configuration change was needed.
2. Remove only the selected source entry from `sources`, preserving every other source and setting. Keep its installed source definition and all stored data. Leave the queue, backfill worklist, snapshots, and discovery watermark unchanged so pending ingestion can continue normally.
3. Follow `Commit Changes`, then `Release Lock` in `<shared-concepts>`. Release the lock on failure too, and report the failure rather than claiming completion.
4. Report the removed source and locations, verified stopped job IDs, any shared jobs intentionally left running, and any incomplete steps. Remind the owner that saved queue and backfill snapshots can still be memorized and that existing captures and memories were retained.
