# Automatic Ingestion and Failure Recovery

## Architecture

Use three independently scheduled roles. No scheduled subagent support or model switching is required.

- **Scout:** discovers and judges sources; maintains its existing inbox.
- **Auto-ingest manager:** copies eligible items into its own queue and reconciles completion.
- **Guardian worker:** starts in a fresh standalone session, claims one queued item, and ingests it. Only guardians write memory.

Automatically queue only native items belonging to the configured feed—for example, Codex chats. Referenced sources remain in Scout’s inbox for manual review, whether or not they have supported types. Respect owner-skipped entries.

The manager reads Scout’s committed output without modifying it. Scout’s existing capture check removes ingested entries on its next scan.

## Guardian Execution Modes

Adjust the ingest skill to support:

- **Manual invocation:** spawn a fresh isolated guardian subagent, as today.
- **Dedicated scheduled invocation:** the fresh scheduled session itself acts as guardian; no subagent.

Require an actually fresh standalone session, not merely a `scheduled` flag or a recurring turn in an existing conversation.

Both modes follow the same guardian rules, memory lock, commit verification, and recovery protocol. Pass the original source reference and necessary operational metadata, never Scout’s rationale or a manager-written source summary.

## Persistent Auto-Ingest State

Store in the operations repository:

- **Todo:** pending items and retryable failures.
- **Completed:** verified successful items, retained for deduplication.
- **Blocked:** items requiring intervention, with reasons.
- **Execution metadata:** claimed item, owning run, and last automatic start.

Identify updates by **source type + source identity + latest-mention timestamp** copied from Scout. Deduplicate against all queue sections; newer updates remain eligible. Retain a stable operation ID across retries.

Normal deduplication uses queue history. Recovery checks committed ingestion evidence when completion is uncertain.

## Scheduling and Models

| Role | OpenAI recommendation | Anthropic role counterpart |
|---|---|---|
| Scout | Luna Max | Haiku |
| Auto-ingest manager | Luna Max | Haiku |
| Guardian worker | Sol Max | Sonnet |

Put recommendations in scheduling/setup guidance; keep core skills model-independent. These are role counterparts, not capability equivalence; “Max” is not a Claude setting.

The guardian worker processes at most one item per run and starts at most **one automatic ingestion every five hours**. Check the cooldown under lock and persist the start before ingestion. Failed attempts consume the cooldown; an empty queue does not.

Never overlap guardians. Manual ingestion bypasses the cooldown but obeys the memory lock. Scheduling frequency alone is not the cooldown guarantee. The limit controls frequency, not tokens per ingestion.

## Atomicity and Recovery

**Committed Git state is authoritative.** Readers use coherent committed snapshots, ignoring unfinished working-tree edits.

Commit together:

- Scout’s inbox and cursor.
- Related queue, claim, and cooldown transitions.
- Guardian memory changes and the ingestion operation ID.

Memory and queue are separate repositories. Completion therefore has two recoverable steps:

1. Guardian commits the ingestion result with its operation ID.
2. Manager verifies that commit and marks the item Completed.

If interrupted between them, acknowledge the existing result without repeating ingestion. The guardian worker must also check for an already committed result before retrying a pending operation.

Retain unfinished items. Resolve partial uncommitted changes before another writer proceeds; never silently include or discard another run’s work. Retry recoverable failures; block ambiguous cases for intervention.

## Locking

Use atomic lock-directory creation within the skills. No separate long-running OS-lock supervisor.

Protect shared resources independently:

- Scout feed state.
- Auto-ingest state, shared by manager and guardian worker.
- Memory, shared by all manual and automatic guardians.

Record unique ownership and owning run/agent identities. Only the owner releases its lock, after the protected work stops and its result is checked. Never take over solely because a lock is old.

Clear an abandoned lock only after confirming its worker has stopped; otherwise block for intervention. The memory lock must remain held throughout guardian execution.

Independent components may run concurrently. Define a consistent acquisition order wherever multiple locks are needed. Git’s commit lock does not protect the entire read–modify–commit operation.

## Implementation and Verification

- Add the auto-ingest skill, queue state, and independent manager/guardian schedules.
- Extend ingest authorization and execution modes for owner-authorized scheduled ingestion.
- Harden Scout, auto-ingest, and guardian with these locking, committed-state, and recovery rules.
- Preserve Scout’s discovery behavior and inbox format; no new source type is needed.
- Use deterministic helpers for mechanical transitions; models handle judgment and synthesis.
- Update package guidance and installed copies consistently.

Before enabling, verify fresh scheduled-session isolation, required permissions, concurrent starts, manual/automatic overlap, interruptions around commits, duplicate retries, newer updates, dirty-state recovery, lock ownership, and cooldown enforcement.

Unreadable-source handling and model screening accuracy remain policy/judgment limitations, separate from mechanical failure recovery.