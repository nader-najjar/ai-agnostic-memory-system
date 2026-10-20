# Next Step: Shared Operations, State Visibility, and Feed Management

Implement after [automatic ingestion and failure recovery](upgrade-plan.md). Make everyday operation easier and less error-prone without requiring a desktop application.

## 1. Shared Scripts — Main Engineering Work

Put deterministic mechanics in shared scripts used by skills and scheduled jobs. Skills guide interaction; models retain discovery judgment and memory synthesis.

- Inventory current configuration, state formats, and repeated operations before extracting helpers. Keep existing authoritative data; do not create parallel configuration or status stores.
- Define small operations for listing feeds, reading status, validating configuration, and registering, editing, or disabling feeds.
- Centralize repeated correctness-sensitive mechanics: committed-state reads, input validation, identity/deduplication, lock ownership, queue transitions, cooldown checks, atomic publication, and recovery checks.
- Preserve the ingestion plan’s guarantees: coherent Git snapshots, stable operation IDs, recoverable cross-repository completion, no age-only lock takeover, and no silent inclusion or deletion of unrelated edits.
- Return structured results, meaningful exit codes, and actionable errors. Keep presentation separate so skills, schedulers, and a future UI or MCP server can reuse the same operations.
- Make retries safe and reject ambiguous or invalid transitions explicitly. Validate before changing state; preserve history when disabling resources.
- Migrate existing callers incrementally so manual and scheduled execution use the same implementation. Avoid a general framework before concrete operations require one.

This is the largest part of the work: correctness should come from executable rules rather than each model repeatedly interpreting procedural instructions. Scripts enforce mechanics; they do not grant authority to ingest or write memory.

Verify malformed inputs, duplicate requests, concurrent writers, interruptions around commits, dirty working trees, lock ownership, and safe retries. Reuse the ingestion hardening tests rather than maintaining separate implementations of the same guarantees.

## 2. Show-State Skill

Provide a read-only overview through the shared scripts, with optional detail for an individual feed, run, or queue item.

- Show configured feeds, source locations/scopes, enabled settings, schedules, and selected models where available.
- Show last successful scans and ingestions, pending items, blocked items with reasons, and recent failures.
- Distinguish configured automation from observed execution. Report unknown or unavailable scheduler/worker status honestly; do not infer liveness from a lock file or recent timestamp alone.
- Read committed operational state consistently. Label any separately observed live execution information and when it was observed.
- Link to underlying configuration, queue entries, and result evidence so the summary is inspectable.

## 3. Feed-Management Skill

Guide users through registration and maintenance, delegating changes to the shared scripts.

- List supported feed types and their required fields.
- Collect a stable feed identity, display name, source location/account, discovery scope, and applicable preferences. Reference credentials through supported mechanisms rather than storing secrets in feed configuration.
- Validate configuration and source access; detect duplicates and surface overlapping scopes before saving.
- Create configuration and initial operational state coherently. Support editing and disabling feeds without losing history or silently orphaning queued work.
- Treat registration and scheduling as separate operations. Make Scout and auto-ingestion enablement explicit and honor those settings in scheduled jobs.
- Reuse available scheduling integrations; clearly report when a feed is registered but scheduling is not configured or could not be verified.

A **source type** defines how to interpret and ingest an item. A **feed type** must also define how to discover items, identify them, and detect updates. Do not assume every ingestible source type already supports an automatically discoverable feed.

## Delivery Order and Scope

1. Inspect existing mechanics and establish shared script contracts on top of ingestion hardening.
2. Deliver read-only state operations and the show-state skill.
3. Deliver validated feed mutations and the feed-management skill; migrate relevant scheduled callers.

Keep documentation and installed skill copies consistent. The result should let a user understand current operation and manage feeds without manually editing internal state.

Desktop UI, MCP exposure, and a new cross-tool execution service are later options. These scripts provide a reusable foundation without requiring those additions now.
