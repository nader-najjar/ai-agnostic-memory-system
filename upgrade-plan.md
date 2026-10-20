# Persistent AI Context — Authoritative Implementation Checklist

This consolidates the implementation plans. The [user experience](user-experience.md) remains the companion description of the intended outcome. Unchecked items are planned work, not claims of current capability. Verify the implementation before checking items off.

## End Goal

Restore relevant context in a new conversation and continue working without repeated briefing. The [user-experience document](user-experience.md) defines that goal; this checklist defines the work and verification needed to reach it.

## Current Scope: Chat-First and LLM-Only

Start with automatic ingestion of approved AI chat sources. Chats carry the reasoning, corrections, decisions, and unfinished work whose loss creates repeated briefing. Keep canonical source types to support different chat tools, but defer new non-chat integrations until a demonstrated continuity gap justifies them. Preserve references to external material without automatically ingesting it; existing non-chat support can remain available for explicit manual use. Scout may still surface useful external sources independently.

Implement through skills and independently scheduled AI sessions using existing file, Git, and scheduling tools. Do not introduce a shared script layer, custom execution service, or desktop app in this phase. Define shared procedures once and reference them across skills. Ordinary tool commands for atomic directory creation and Git operations remain necessary; “LLM-only” means agents execute the protocol rather than a new scripted engine.

The protocol aims for safe operation, but model adherence must be evaluated in practice. Do not equate written instructions with mechanically enforced guarantees. Observe the initial system before deciding which stretch goals are justified.

## 1. Establish One Policy and Source-Type Model

- [ ] Inspect current skills, source types, feed configuration, and operational state; reuse authoritative definitions and preserve existing data.
- [ ] Define each source type once with a stable identifier and interpretation/ingestion rules. Feeds, policies, and queue items reference it rather than redefining it.
- [ ] Keep Scout discovery policy separate: locations, update detection, reference depth, and relevance judgment. Preserve recursive discovery and the existing inbox format.
- [ ] Store automatic-ingestion approval once, by owner-approved source type and scope. Discovery, technical support, and access alone do not authorize ingestion. Respect owner skips; leave unapproved or unsupported discoveries visible for consideration.
- [ ] Define one shared eligibility procedure that the manager references before queueing and the guardian references before admission. No duplicated policy rules or required code function in this phase.
- [ ] Serialize policy changes with admission, record the policy revision used, and prevent admission when approval was revoked beforehand. Revocation does not retroactively cancel an already admitted operation. Retain ineligible pending items with a reason, without executing them.
- [ ] Allow later approvals to reconsider existing discoveries through normal deduplication. Use approved AI chats as the initial automatic scope. The policy model remains extensible, but automatic ingestion of referenced non-chat material is deferred.

## 2. Implement Independent Roles and Guardian Modes

- [ ] Keep Scout isolated: it discovers and judges, writes its own inbox, and never ingests or writes memory.
- [ ] Add the auto-ingest manager: read Scout's committed output, queue eligible items, and reconcile completion without modifying Scout's inbox. Scout's existing capture check removes ingested entries on a subsequent scan.
- [ ] Add an independently scheduled guardian worker that claims at most one item per run. Only guardians write memory.
- [ ] Extend ingest authorization for owner-authorized scheduled execution. Preserve manual ingestion through a fresh isolated guardian subagent; a dedicated scheduled session itself acts as guardian without spawning a subagent.
- [ ] Verify scheduled guardians actually start in fresh standalone contexts, not recurring turns in an existing conversation. Do not depend on scheduled subagent support or model switching.
- [ ] Apply the same guardian rules, memory lock, verification, and recovery in both modes. Pass original source references and necessary operation metadata, never Scout rationale or manager-written source summaries.

## 3. Persist Queue and Scheduling State

- [ ] Store Todo (pending/retryable), Completed (verified history), Blocked (intervention with reasons), and execution metadata in the operations repository.
- [ ] Identify source updates by source type + source identity + latest-mention timestamp from Scout. Deduplicate across all queue sections, allow newer updates, and retain a stable operation ID across retries.
- [ ] Use queue history for normal deduplication and committed ingestion evidence for uncertain completion/recovery.
- [ ] Record claimed item, owner/run identity, and last automatic ingestion start.
- [ ] Enforce at least five hours between automatic starts: check under lock and persist the start before ingestion. Failures consume the cooldown; an empty queue does not. Frequency limits are not token-per-ingestion limits.
- [ ] Never overlap guardians. Manual ingestion bypasses the cooldown, not the memory lock. Schedule cadence alone is insufficient to enforce either rule.
- [ ] Put model recommendations in setup/scheduling guidance, keeping core skills model-independent: Luna Max for Scout/manager and Sol Max for guardian; Haiku/Sonnet are role counterparts, not equivalent capabilities or Claude “Max” settings. Verify available models when configuring.

## 4. Harden Locking, Publication, and Recovery

- [ ] Use atomic lock-directory creation through existing tools, without a separate long-running OS-lock supervisor. Protect Scout feed state, shared auto-ingest state, and memory independently; coordinate policy changes with admission.
- [ ] Record unique ownership and worker identities. Only the owner releases a lock after protected work stops and its result is checked. Hold the memory lock throughout guardian execution.
- [ ] Never take over solely because a lock is old. Clear abandonment only after confirming the owner stopped; otherwise block for intervention.
- [ ] Define a consistent acquisition order for multiple locks and coordinate shared-repository writes so independent resource locks cannot mix Git staging/commits. Git's internal lock does not protect the complete read–modify–commit operation.
- [ ] Treat committed Git snapshots as authoritative; readers ignore unfinished working-tree edits.
- [ ] Publish related changes together: Scout inbox + cursor; queue/claim/cooldown transitions; guardian memory result + operation ID.
- [ ] Handle cross-repository completion in two recoverable steps: guardian commits memory with operation ID, then manager verifies that result and marks Completed.
- [ ] If interrupted between those steps, acknowledge the existing result without repeating ingestion. The worker also checks for committed completion before retrying a pending operation.
- [ ] Preserve unfinished work; never silently include or discard unrelated changes. Resolve partial uncommitted state before another writer proceeds, retry recoverable failures, and block ambiguous cases with evidence and an actionable reason.

## 5. Verify Before Enabling

Use controlled scenarios and inspect resulting state; a successful agent response alone is not verification.

- [ ] Verify fresh scheduled context, required permissions, shared procedure references, and consistency between package guidance and installed skills.
- [ ] Exercise concurrent starts, manual/automatic overlap, lock ownership, confirmed abandonment, and ambiguous owner status.
- [ ] Interrupt before and after each publication boundary, including between memory completion and queue acknowledgment; verify recovery without duplication or lost work.
- [ ] Exercise duplicate retries, newer source updates, dirty working trees, and cooldown behavior for success, failure, and empty queues.
- [ ] Exercise approved/unapproved scopes and types, recursive discoveries, unknown type identifiers, owner skips, later approval, and revocation between queueing and admission.
- [ ] Confirm Scout remains independently useful and unchanged in discovery behavior. Unreadable-source policy and judgment accuracy remain separate from mechanical recovery.

## 6. Enable and Evaluate Continuity

- [ ] Configure the approved initial feed scope and independent schedules through setup; verify actual runs and committed results before treating automation as working.
- [ ] Follow representative material from discovery through queue and ingestion into recall. Check decisions, reasoning, constraints, superseded information, and source references—not just successful commits.
- [ ] In a fresh conversation, restore project context and continue a real task with a short instruction. Assess repeated briefing avoided and mistakes prevented.
- [ ] Observe multiple scheduled cycles and expected idle periods. Record failures, backlog, model adherence, and manual interventions; use this evidence to decide what to harden next.
- [ ] State remaining limitations honestly: processing delays, incomplete source coverage, model judgment, and lack of proactive monitoring until the corresponding stretch goals are delivered. Keep user controls and manual ingestion available through existing skills.

## Stretch Goals — Add When Experience Justifies Them

These preserve the later operational vision without making it a prerequisite for the LLM-only implementation.

### Shared Scripts

- [ ] Extract repeated or failure-prone mechanics into small tested operations: validation, eligibility, committed reads, locks, queue transitions, cooldown, publication, and recovery. Preserve the single policy/type model above.
- [ ] Return structured results, meaningful errors, and safe retry behavior; migrate manual and scheduled callers incrementally. Avoid a parallel state store or speculative framework.
- [ ] Test malformed input, concurrency, interruption, ownership, and recovery. Scripts enforce mechanics; they do not grant ingestion authority.

### State View, Health Monitor, and Troubleshooter

- [ ] Provide read-only inspection of discovery settings, ingestion approvals, enabled feeds, schedules/models, last successes, pending count/oldest item, blocked reasons, and evidence links. Distinguish configured, observed, live, and unknown state.
- [ ] Check end-to-end progress through recall availability; detect missed schedules, inaccessible sources, stalled/growing backlog, repeated failures, and unresolved locks using explicit thresholds.
- [ ] Account for intentional pauses, empty feeds, cooldown, and pending approval. A legitimate idle state is healthy; unapproved discoveries are not failed execution.
- [ ] Add bounded recovery and backoff using the same protocol, record attempts/results, recheck conditions, and avoid repair loops or duplicate alerts. Never bypass permissions, steal old locks, discard ambiguous changes, or expand policy silently.
- [ ] Escalate expired authorization, ambiguous state, and exhausted recovery with affected scope, evidence, and specific user action. Keep inspection separate from authorized repairs.
- [ ] Deliver an actual daily notification with health, freshness/coverage, backlog, resolved problems, and required action; notify urgent actionable failures sooner. Verify timing/timezone and delivery, distinguishing report generation from receipt where observable.
- [ ] Retain monitor execution/report evidence and use independent missed-run detection where supported. A stopped monitor cannot report its own absence; disclose that limit. A missing daily report is a warning, not automatic recovery.
- [ ] Evaluate source coverage and synthesis/recall quality separately from job success; successful ingestion does not prove accurate understanding.

### Interactive Feed and Policy Management

- [ ] Guide users through existing source types and supported discovery mechanisms; collect feed identity, location/account, scope, and preferences. Keep credentials in supported credential mechanisms.
- [ ] Validate access/configuration, detect duplicates and overlapping scopes, and create coherent initial state. Discovery mechanisms reference source types rather than introduce a second taxonomy; not every ingestible type supports automatic discovery.
- [ ] Separate feed registration, ingestion approval, and schedule enablement. Support editing, separate Scout/ingest pause controls, inspection, skip/retry, and disabling without losing history or orphaning queued work.
- [ ] Integrate management and health features into setup and verify delivery failures, missed schedules, paused operation, and representative source-to-recall continuity.

### Additional Source Integrations

- [ ] Expand beyond chats only when a concrete failure to restore working context warrants it. Reuse existing policy, queue, recovery, and recall mechanisms; pay integration effort once per type, with configuration rather than bespoke work for each instance. Treat historical backfill cost separately.

### Optional Interfaces and Execution

- [ ] Consider a desktop UI, MCP interface, or cross-tool execution adapters only when needed. Reuse established operations rather than duplicating them; none is required to retain context across conversations.

The mature experience is setup once, continued work through recall, daily reassurance, and rare actionable exceptions. The immediate experiment is whether the LLM-only protocol delivers useful continuity reliably enough to earn that trust.
