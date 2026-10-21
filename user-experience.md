# Persistent AI Understanding Across Conversations

This describes the planned end state, not a claim that every capability is available today. The [authoritative implementation checklist](upgrade-plan.md) separates the initial chat-first scope from stretch goals.

## The Goal: Continue Working Without Starting Over

Your AI’s understanding should persist beyond any individual conversation.

You usually know what you are working on. The expensive part is teaching a new AI session everything it needs to help: the background, decisions, constraints, rejected approaches, and current state of the work. If rebuilding that context takes longer than doing the task yourself, using AI has failed to save you time.

This system makes accumulated context durable and available to future sessions. Closing a chat should not mean losing the understanding developed through that work. The next session should be able to restore the relevant context and continue with a short statement of what you want to do next.

Recall is the mechanism for restoring that context. Asking questions about the past is a useful secondary capability; the primary purpose is making AI a continuing collaborator across otherwise separate sessions.

## A Chief of Staff You Can Rely On

The intended role is a competent chief of staff: someone who learns how you work, carries context forward, remembers standing procedures, and helps you act without making you manage every detail of the assistance itself.

You should be able to delegate with ordinary shorthand. The system should retrieve relevant established expectations, apply them in the right context, and ask only about genuinely missing or changed information. Teaching it something should create lasting value rather than another instruction you will have to repeat next week.

## Concrete Frustrations This Should Remove

| Situation | The usual frustration | The intended experience |
|---|---|---|
| A recurring weekly update | Every new chat needs the manager's format, section order, tone, and rules explained again. | Teach the SOP once. Later, say “Give me my weekly update,” and the AI restores and applies that established format without requiring “in my manager's expected format.” It uses available evidence for this week's facts and asks for missing facts rather than inventing them. |
| Continuing a project in a new chat | You spend the first exchanges reconstructing goals, terminology, decisions, and progress. | Restore the relevant project context and describe the next task. The AI understands where the work stands. |
| Revisiting a difficult decision | The AI proposes an approach you already rejected, forcing you to repeat the reasoning. | It retrieves the decision and rationale, and revisits it when new evidence warrants doing so. |
| Applying your working standards | You repeatedly correct the same naming, writing, review, or implementation choices. | Relevant standing standards carry across sessions and are applied without repeated coaching. |
| Returning after months away | You remember the conclusion but have forgotten the detailed reasoning and intermediate steps. | Recover the supporting sources, alternatives, corrections, and sequence of decisions before continuing. |
| Creating a handoff or retrospective | You manually search old chats and reconstruct how the work evolved. | Produce a source-backed artifact from the retained history, distinguishing evidence from interpretation and exposing gaps. |

The SOP example is a central acceptance case: the first captured teaching should be enough until the procedure changes. Preserve the authoritative procedure and its revisions; do not repeatedly summarize away details that determine correct execution. The initial implementation still requires relevant recall in a fresh session. Automatic context loading in every AI tool is not assumed.

## More Than Human Memory: A Reconstructable Record

Beyond saving repeated explanations, the system can preserve detail people naturally forget. The ambition is a precise breadcrumb trail with branching relationships: which source introduced an idea, what alternatives followed, why one was chosen, what later changed, and which work or artifacts depended on it. A connected history is more useful than a final summary alone.

That record should let you return to the weeds of old work, inspect the original wording, follow a decision back to its evidence, or create a new explanation, handoff, or retrospective from it.

Exact one-to-one reconstruction requires retaining the original captured material and stable references alongside synthesized memory. Summaries alone cannot provide it. Completeness is bounded by authorized sources actually captured and retained; missing, deleted, or inaccessible material must be identified, never filled in with invented history. This is the desired traceability experience, not a claim that the current system already preserves every detail or implements an exhaustive graph.

## Initial Experience: Continue Your Work Across Chats

Choose supported AI chat sources, authorize access, and approve the scope of automatic ingestion. Setup verifies discovery, ingestion, and recall together. The first implementation uses skills and scheduled AI sessions; additional infrastructure is deferred.

In a new session, use recall to load the relevant project or topic, then get on with the work. You should not need to reconstruct old conversations, paste repeated briefings, run Scout, manually ingest routine updates, or manually transfer context between chats. During the initial rollout, operation still needs observation; proactive health monitoring is a stretch goal.

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

Scout can follow references to surface useful material beyond the original feed. You separately decide what may enter memory automatically using the [ingestion policy](upgrade-plan.md#1-establish-one-policy-and-source-type-model). For example, you can approve your Codex chats while leaving referenced repositories and pages for consideration. Automatic non-chat ingestion is deferred until a concrete continuity need justifies it. Existing non-chat support can remain available for explicit manual use. Being discovered alone never grants permission.

Processing happens on a schedule, so new material may wait before it becomes available to recall. Pending work remains recorded; a dedicated view for distinguishing expected waiting from stalled work is a later improvement. Retries should not produce duplicate ingestion, and ordinary interruptions should recover without your involvement.

## Later Goal: Reassurance Without Daily Administration

Health monitoring and notifications are stretch goals. Once implemented, receive a daily health notification showing:

- Whether the system is healthy, degraded, or blocked.
- Whether enabled sources are being checked and memory is staying current.
- What is waiting and whether that wait is expected.
- Problems automatically resolved.
- Anything that requires your action.

An idle system can be healthy: no new material should not look like a failure. Conversely, a job merely starting or finishing is not enough to claim everything works.

For a serious actionable problem, receive a notification sooner. The message should explain what is affected and what you need to do—for example, renew access to a source. You should not have to interpret internal logs or diagnose queue mechanics.

## Later Goal: Convenient Operational Controls

Dedicated state inspection and interactive feed-management skills are stretch goals. They should let you ask to see current feeds, automation settings, recent activity, pending work, and problems. You can add supported feeds interactively, adjust discovery scope, change automatic-ingestion approvals, or pause Scout and automatic ingestion separately. These controls use the same source types throughout the system.

Disabling a feed should preserve its history and make the disposition of pending work clear. You can inspect, skip, or retry items through supported controls without editing internal state by hand. Manual ingestion remains available when you deliberately want to add something outside the automatic flow.

These capabilities can be provided through skills; a desktop application is optional.

## What You Should Still Expect to Handle

Routine operation should require no attention. Exceptions can still require you to restore access, resolve ambiguous information, or decide how to handle an unsupported source.

The system cannot promise perfect judgment, instant updates, or uninterrupted service. It should preserve evidence, expose known gaps, recover safely where possible, and avoid silently pretending stale or incomplete memory is current. A successful ingestion is evidence of completed processing, not proof of perfect synthesis.

Once added, monitoring also depends on its execution and notification environment. Setup should verify what can be monitored independently; a missing daily report should be treated as a reason to check the system, not reassurance that nothing happened.

## What Success Looks Like

You close a conversation and later start another. Instead of spending the opening exchanges teaching the AI your project again, you restore its relevant context, explain the next task, and continue. Prior reasoning informs the work, and decisions already settled do not need to be repeatedly rediscovered.

Automatic upkeep maintains that continuity. Later health monitoring should make problems easier to detect and resolve. Success is measured by less repeated explanation, fewer repeated mistakes, and useful work completed with less effort than doing it yourself—not by the number of sources ingested or questions answered about the past.

Your normal interaction is **continuing your work with an AI that has access to the understanding already built**, while the memory system operates in the background.
