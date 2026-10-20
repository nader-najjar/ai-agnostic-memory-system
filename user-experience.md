# The Intended User Experience

This describes the planned end state, not a claim that every capability is available today. Implementation is covered by the [ingestion plan](upgrade-plan.md) and [operational readiness plan](operations-interface-plan.md).

## Set Up Once, Then Use Recall

Choose where Scout should look, authorize access, and separately approve which source types and scopes may be ingested automatically. Setup checks that discovery, ingestion, recall, and notifications work together.

After that, use recall when you need context. You should not need to run Scout, manually ingest routine updates, inspect queues, or check whether yesterday's jobs ran.

The goal is durable, useful memory that stays current in the background, with clear evidence when something needs attention.

## Memory That Helps You Continue Your Work

Ask questions such as:

- What did I decide about this project, and why?
- What constraints should I preserve when continuing this work?
- What changed since the earlier approach?
- What is still unresolved?

Memory should retain decisions, reasoning, constraints, and useful context, with references back to their sources. Later changes should be understandable without losing the history that explains them. When evidence is incomplete, conflicting, or outdated, recall should make that clear rather than present an unsupported answer confidently.

You can inspect the underlying memory and source evidence. Your knowledge remains in readable files with version history, rather than being available only through a particular chat or interface.

## Automatic Upkeep

The system checks enabled feeds for new or updated material, identifies what is worth remembering, and ingests eligible items within the configured processing limits.

Scout can follow references to surface useful material beyond the original feed. You separately decide what may enter memory automatically using the [ingestion policy](upgrade-plan.md#source-types-and-policy--single-source-of-truth). For example, you can approve your Codex chats while leaving referenced repositories and pages for consideration. You can later approve those sources too; being discovered alone never grants permission.

Processing happens on a schedule, so new material may wait before it becomes available to recall. The system makes that delay visible and distinguishes expected waiting from stalled work. Retries should not produce duplicate ingestion, and ordinary interruptions should recover without your involvement.

## Reassurance Without Daily Administration

Receive a daily health notification showing:

- Whether the system is healthy, degraded, or blocked.
- Whether enabled sources are being checked and memory is staying current.
- What is waiting and whether that wait is expected.
- Problems automatically resolved.
- Anything that requires your action.

An idle system can be healthy: no new material should not look like a failure. Conversely, a job merely starting or finishing is not enough to claim everything works.

For a serious actionable problem, receive a notification sooner. The message should explain what is affected and what you need to do—for example, renew access to a source. You should not have to interpret internal logs or diagnose queue mechanics.

## Control When You Want It

You can ask to see current feeds, automation settings, recent activity, pending work, and problems. You can add supported feeds interactively, adjust discovery scope, change automatic-ingestion approvals, or pause Scout and automatic ingestion separately. These controls use the same source types throughout the system.

Disabling a feed should preserve its history and make the disposition of pending work clear. You can inspect, skip, or retry items through supported controls without editing internal state by hand. Manual ingestion remains available when you deliberately want to add something outside the automatic flow.

These capabilities can be provided through skills; a desktop application is optional.

## What You Should Still Expect to Handle

Routine operation should require no attention. Exceptions can still require you to restore access, resolve ambiguous information, or decide how to handle an unsupported source.

The system cannot promise perfect judgment, instant updates, or uninterrupted service. It should preserve evidence, expose known gaps, recover safely where possible, and avoid silently pretending stale or incomplete memory is current. A successful ingestion is evidence of completed processing, not proof of perfect synthesis.

Monitoring also depends on its execution and notification environment. Setup should verify what can be monitored independently; a missing daily report should be treated as a reason to check the system, not reassurance that nothing happened.

## What Success Looks Like

You start a new conversation, ask for the context you need, and continue working without reconstructing your history. New material becomes useful memory automatically. Daily reports provide reassurance, and rare exceptions arrive with a specific next action.

Your normal interaction is **using your memory**, not maintaining it.
