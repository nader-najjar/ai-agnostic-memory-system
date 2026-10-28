# ChatGPT Dot Source Setup

This recipe has two jobs: dot exports its room to Library; a local ChatGPT/Codex worker downloads those exports. Your main memory tool need not be either one. Ask the owner to open the required tool and paste the prepared prompt with approved values substituted. If already in that tool, proceed there.

Confirm a dedicated Library folder for this source (default: `Memory Exports/Dot`) and the absolute memory folder with the owner. Use the owner’s known timezone from context wherever scheduling requires it.

## Initial History

Ask: “How much dot conversation history should we initialize: all available history, since a date, or from now?” Wait for the owner's answer. Substitute `all`, a confirmed ISO 8601 UTC timestamp, or `from now` for `<initial-history-start>` in the prompt below. Each dot resolves `from now` once during setup and saves its fixed timestamp in its scheduled prompt. This selects individual messages by their timestamps, not whole conversations. For a new initialization scope, use a fresh Library export folder for both jobs so existing checkpoints and chunks cannot bypass the chosen scope; leave earlier exports unchanged.

## 1. Cloud job - ChatGPT dot

Ask the owner to open each dot they want included in the memory system and give it this prompt, using the same Library export folder for all dots:

> Schedule a task for yourself every four hours. Identify this conversation’s room ID and include it in the scheduled task; do not ask me for it. Initialize history from `<initial-history-start>`; if this is `from now`, replace it with the current ISO 8601 UTC timestamp now, during setup. Save this fixed per-room value in the scheduled instructions, even if no messages initially qualify. Use the following instructions for each run:
>
> > Export this dot’s conversation to Library folder `<dot-export-folder>` using the dot room reader and the current Library skill. Find exports named `dot-<room-id>-<end-timestamp-UTC>.jsonl` for this room. Select the latest end timestamp and read its header to confirm the message boundary. Its last message ID is the checkpoint; no separate checkpoint file is needed.
> >
> > If no export exists for this room, export messages with timestamps on or after `<initial-history-start>`; `all` means all accessible room history. Keep this initial value fixed across runs, including while no exports exist. On later runs, export only new messages after the verified checkpoint. Read neighboring pages with overlapping message IDs, deduplicate by ID, and verify continuity back to the checkpoint (or the initial time boundary on the first run; the accessible beginning for `all`). A short page alone is not proof of completion. If a read is partial or the boundary is missing, continue reading or report the gap; never advance past an unverified boundary. If no messages qualify, create no chunk.
> >
> > Write immutable JSONL chunks, each a partial continuation, not a complete session. Start each with a header containing the room ID, time bounds, and first/last message IDs. Retain each message's ID, role, text, and timestamp. Include only accessible conversation content, never hidden reasoning or system instructions; redact secrets before export.
> >
> > Save each chunk as a new Library file named `dot-<room-id>-<end-timestamp-UTC>.jsonl`, using the last message’s timestamp in `YYYYMMDDTHHmmssffffffZ` format. Use the current Library skill; never replace an earlier export. Send a dot message to the user if an export fails.

Retain the confirmed Library folder reference for the local job.

## 2. Local job - Library-capable ChatGPT/Codex

Ask the owner to open a local ChatGPT/Codex chat with Library access. Give that chat the [scheduling instructions](../schedulers/codex.md), the absolute memory folder, and the task prompt below, with these job details:

- Name: `Personal Memory Download - dot`
- Execution: local (**Run on this computer** on)
- Schedule: hourly, using the owner’s known timezone
- Suggested model: GPT-6 Luna; reasoning effort: Max

Ask it to follow the scheduling instructions to create this job. If already in the required chat, proceed there.

> Materialize dot exports from Library folder `<dot-export-folder>` into `<memory-folder>/.source-dump/chatgpt-dot/`. Use the current Library skill in this local executor.
>
> Use judgment, Library timestamps, and existing local filenames to find the boundary between missing and already downloaded exports, then download the missing ones. Name each destination `<library-file-id>.jsonl`. Never modify or delete existing destination files.
>
> Create `<memory-folder>/.tmp/scratch/` if needed and use it for temporary downloads. Follow the current Library skill’s download procedure, and publish only verified complete local files. Report failed or partial transfers.
>
> Preserve JSONL bytes exactly. Set each new staged file's modification time to its local arrival time. Publish it atomically into the destination without overwriting an existing file.

## Verify

Run the cloud job, then the local job. Confirm only messages within the selected initial timestamp window were exported. If none qualify, confirm no chunks were created for this room. Otherwise confirm a saved chunk's room header and message boundaries, matching Library/local bytes, and stable ID-based filename. Run the local job again and confirm existing files remain unchanged. Report both job IDs and schedules, any history gaps, and use `<memory-folder>/.source-dump/chatgpt-dot/` as the discovery location.
