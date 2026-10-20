# Persistent AI Understanding Across Conversations

This describes the planned end state, not a claim that every capability is available today. Implementation is covered by the [ingestion plan](upgrade-plan.md) and [operational readiness plan](operations-interface-plan.md).

## The Goal: Continue Working Without Starting Over

Your AI’s understanding should persist beyond any individual conversation.

You usually know what you are working on. The expensive part is teaching a new AI session everything it needs to help: the background, decisions, constraints, rejected approaches, and current state of the work. If rebuilding that context takes longer than doing the task yourself, using AI has failed to save you time.

This system makes accumulated context durable and available to future sessions. Closing a chat should not mean losing the understanding developed through that work. The next session should be able to restore the relevant context and continue with a short statement of what you want to do next.

Recall is the mechanism for restoring that context. Asking questions about the past is a useful secondary capability; the primary purpose is making AI a continuing collaborator across otherwise separate sessions.

## Set Up Once, Then Continue Your Work

Choose where Scout should look, authorize access, and separately approve which source types and scopes may be ingested automatically. Setup checks that discovery, ingestion, recall, and notifications work together.

In a new session, use recall to load the relevant project or topic, then get on with the work. You should not need to reconstruct old conversations, paste repeated briefings, run Scout, manually ingest routine updates, or check whether yesterday's jobs ran.

This preserves relevant knowledge through an explicit memory system; it does not imply that every AI tool automatically loads it or that a previous session's entire internal state is retained.

## Understanding Worth Carrying Forward

Memory should preserve what a future collaborator needs to act well:

- What you are trying to accomplish and why.
- Decisions and the reasoning behind them.
- Constraints, preferences, and standards that affect the work.
- Approaches already explored or rejected, and why.
- Progress, unresolved questions, and the next intended steps.

Later changes should remain understandable without losing the history that explains them. Source references let the AI verify context, distinguish current decisions from superseded ones, and acknowledge gaps or conflicting evidence. Time-sensitive facts still need verification before action.

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

You close a conversation and later start another. Instead of spending the opening exchanges teaching the AI your project again, you restore its relevant context, explain the next task, and continue. Prior reasoning informs the work, and decisions already settled do not need to be repeatedly rediscovered.

Automatic upkeep maintains that continuity; health monitoring makes it dependable and exposes gaps. Success is measured by less repeated explanation, fewer repeated mistakes, and useful work completed with less effort than doing it yourself—not by the number of sources ingested or questions answered about the past.

Your normal interaction is **continuing your work with an AI that has access to the understanding already built**, while the memory system operates in the background.
