---
name: personal-memory-system-onboard-source
description: Add a supported conversation source to an existing personal memory system, preparing and verifying its local discovery folder before configuration.
---
# Personal Memory System Onboard Source

Inputs: an existing `<memory-folder>` path and, optionally, a source to add.
`<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`.

## Prepare the Source

1. Resolve the memory folder to an absolute path. Read its `config.json` and the `Memory Configuration` and `Source Type Definitions` sections of `<shared-concepts>`.
2. Locate the installed `personal-memory-system-setup` skill. Read the **Identifier** and **Display Name** of each definition in its `source-types/` directory. Offer supported sources not already configured, or confirm the supplied source is one of them. Ask the owner to approve the source and conversation scope before proceeding.
3. Follow its matching recipe in that setup skill’s `source-setup/` directory, including the recipe's approvals, cross-tool handoffs, scheduling, and verification. Use its source-specific `.source-dump/` discovery folder. Do not hold the memory lock during this work or while waiting for the owner.
4. Read the selected source definition in full. Verify that the recipe's resulting absolute local folder exists and is readable by the memory worker, and that staged conversations match its **Source Items**, including subfolder and exclusion rules. If preparation or verification is incomplete, report what remains and do not configure the source yet.

## Configure and Backfill

1. Follow `Acquire Lock` in `<shared-concepts>`; if it returns `false`, stop. Reread `config.json` under the lock. If this identifier is now configured, release the lock and report that instead of adding a duplicate.
2. Add one source entry with the selected `identifier` and `locations: [{"type": "folder", "path": "<verified-absolute-staging-folder>"}]`, preserving all other sources and settings. Copy or update only the selected definition into `<memory-folder>/operations/shared/source-types/` so discovery can find it by **Identifier**.
3. Follow `Commit Changes`, then `Release Lock` in `<shared-concepts>`. Release the lock on failure too, and report the failure rather than claiming completion.
4. Report the configured source, verified discovery path, and the recipe's job IDs, schedules, and any history gaps.
5. Recommend backfilling all available history, including history not yet staged. Run `$personal-memory-system-backfill` with the configured source and `<memory-folder>` to agree on the historical scope with the owner and retrieve it; leave the discovery watermark unchanged.
