# Operational Readiness: Shared Scripts, System Health, and Feed Management

Build on [automatic ingestion and failure recovery](upgrade-plan.md). The end goal is **setup once, then use recall**: routine discovery and ingestion require no manual attention, daily health notifications provide reassurance, and exceptional problems produce actionable requests. This applies to configured, supported feeds and owner-authorized automation.

High-quality memory and uninterrupted execution cannot be guaranteed absolutely. The readiness standard is verified coverage and progress, safe recovery, source-backed memory, and no silent degradation where monitoring can detect it. A desktop application is not required.

## 1. Shared Scripts — Main Engineering Work

Put deterministic mechanics in shared scripts used by skills and scheduled jobs. Skills guide interaction; models retain discovery judgment and memory synthesis.

- Inventory current configuration, state formats, and repeated operations before extracting helpers. Keep existing authoritative data; do not create parallel configuration or status stores.
- Define small operations for listing feeds, reading status, validating configuration, and registering, editing, or disabling feeds.
- Centralize repeated correctness-sensitive mechanics: committed-state reads, input validation, identity/deduplication, lock ownership, queue transitions, cooldown checks, atomic publication, and recovery checks.
- Preserve the ingestion plan’s guarantees: coherent Git snapshots, stable operation IDs, recoverable cross-repository completion, no age-only lock takeover, and no silent inclusion or deletion of unrelated edits.
- Return structured results, meaningful exit codes, and actionable errors. Keep presentation separate so skills, schedulers, and a future UI or MCP server can reuse the same operations.
- Make retries safe and reject ambiguous or invalid transitions explicitly. Validate before changing state; preserve history when disabling resources.
- Migrate existing callers incrementally so manual and scheduled execution use the same implementation. Avoid a general framework before concrete operations require one.

These scripts are the main engineering foundation: correctness should come from executable rules rather than each model repeatedly interpreting procedural instructions. Build correctness-sensitive helpers during ingestion hardening; this phase consolidates and extends them rather than deferring or duplicating those guarantees. Scripts enforce mechanics; they do not grant authority to ingest or write memory.

Verify malformed inputs, duplicate requests, concurrent writers, interruptions around commits, dirty working trees, lock ownership, and safe retries. Reuse the ingestion hardening tests rather than maintaining separate implementations of the same guarantees.

## 2. System Health and Troubleshooting

Expand the read-only state view into an independently scheduled health monitor and safe recovery capability, also available interactively. Inspection remains read-only; repairs are explicit operations with recorded outcomes.

### Evidence and Diagnosis

- Show configured feeds, scopes, enablement, schedules, and selected models alongside observed execution and the time of observation. Unknown or unavailable evidence must not be reported as healthy.
- Check the complete path: source access and discovery, eligible-item queuing, ingestion completion, and availability to recall. A successful scheduled invocation alone does not prove success.
- Report per-feed last successful scans/ingestions, pending counts, oldest waiting item, blocked reasons, and recent failures. Account for intentional pauses, empty feeds, scheduling cadence, and the five-hour ingestion cooldown.
- Detect missed runs, stalled progress, growing or overdue backlogs, inaccessible sources, repeated failures, and unresolved locks. Define explicit freshness and backlog thresholds rather than relying on model intuition.
- Read coherent committed state and link findings to configuration, queue items, and result evidence. Label separately observed live worker information; lock age alone does not prove liveness or abandonment.

### Safe Recovery and Escalation

- Reuse the existing recovery operations to reconcile interrupted completion and retry known transient failures within bounded retry/backoff rules. Obey the same locks, cooldown, operation identities, and guardian-only memory-writing boundary.
- Record each diagnosis, attempted repair, and verified result. Recheck the underlying condition before declaring recovery; avoid repeated repair loops and duplicate notifications.
- Never steal a lock based only on age, discard ambiguous changes, bypass permissions, or silently change the owner's feed scope or policies.
- Escalate expired authorization, ambiguous state, exhausted retries, or other conditions needing human judgment with the affected scope, evidence, and specific action required. Urgent actionable failures can notify before the daily report.

### Daily Scheduled Notification

Deliver an actual daily notification through the supported scheduler/notification integration, not merely a report file or an assistant response hidden in a scheduled chat. Verify delivery during setup and make its timing/timezone explicit.

Include:

- **Health:** healthy, degraded, or blocked; identify unknown or unverified checks explicitly.
- **Freshness and coverage:** last successful activity and whether all enabled feeds are covered.
- **Backlog:** pending count and oldest waiting item, interpreted against expected cadence and cooldown.
- **Recovery:** problems detected and automatically resolved.
- **Action needed:** only matters requiring the owner.

Healthy requires evidence of expected progress or legitimately idle operation. Distinguish report generation from notification delivery where delivery evidence is available.

Monitor the monitor: retain its last successful check and report/delivery evidence. A stopped monitor cannot report its own absence; use an independent scheduler/watchdog check where supported, and expose that coverage limit otherwise. A missing daily notification is a user-visible warning, not an automatic recovery mechanism.

### Memory Quality

Operational success does not prove accurate or useful synthesis. Preserve source references and traceability, evaluate representative discovery coverage and ingestion/recall quality, and surface known quality limitations separately from execution health. Do not label memory high-quality solely because jobs and commits succeeded.

## 3. Feed-Management Skill

Guide users through registration and maintenance, delegating changes to the shared scripts.

- List supported feed types and their required fields.
- Collect a stable feed identity, display name, source location/account, discovery scope, and applicable preferences. Reference credentials through supported mechanisms rather than storing secrets in feed configuration.
- Validate configuration and source access; detect duplicates and surface overlapping scopes before saving.
- Create configuration and initial operational state coherently. Support editing and disabling feeds without losing history or silently orphaning queued work.
- Treat registration and scheduling as separate operations. Make Scout and auto-ingestion enablement explicit and honor those settings in scheduled jobs.
- Reuse available scheduling integrations; clearly report when a feed is registered but scheduling is not configured or could not be verified.

A **source type** defines how to interpret and ingest an item. A **feed type** must also define how to discover items, identify them, and detect updates. Do not assume every ingestible source type already supports an automatically discoverable feed.

## Delivery Order and Readiness Criteria

1. Implement and verify ingestion hardening, including its shared mechanical helpers.
2. Consolidate script contracts; deliver read-only state inspection and validated feed management.
3. Add end-to-end health checks, bounded recovery, daily notifications, and urgent escalation.
4. Integrate these into setup: register feeds, establish authorization and automation settings, verify scheduling and notification delivery, and exercise a representative source-to-recall flow.

Before declaring readiness, test healthy idle operation, normal progress, cooldown-limited backlog, missed schedules, expired access, interrupted operations, failed recovery, and notification failure. Verify intentional pauses remain paused, ambiguous conditions escalate, and the monitor's own failure is detectable to the extent the execution environment supports. Reuse ingestion hardening tests for its existing guarantees.

Keep package guidance and installed skills consistent. Routine users should need only setup and recall, with daily reassurance and rare actionable exceptions; manual state inspection and feed management remain available when wanted.

Desktop UI, MCP exposure, and a new cross-tool execution service are later options. Skills and scheduled jobs can use the same scripts now, and future interfaces can reuse them.
