# ChatGPT Dot Source Setup

This recipe has two dot jobs: export its room to Library every four hours, and copy exports to the owner’s computer hourly when available. Your main memory tool need not be dot. Ask the owner to open dot and paste the prepared prompts with approved values substituted. If already in dot, proceed there.

Confirm a dedicated Library folder for this source (default: `Memory Exports/Dot`) and the absolute memory folder with the owner. Use the owner’s known timezone from context wherever scheduling requires it.

## Initial History

Ask: “How much dot conversation history should we initialize: all available history, since a date, or from now?” Wait for the owner's answer. Substitute `all`, a confirmed ISO 8601 UTC timestamp, or `from now` for `<initial-history-start>` in the prompt below. Each dot resolves `from now` once during setup and saves its fixed timestamp in its scheduled prompt. This selects individual messages by their timestamps, not whole conversations. For a new initialization scope, use a fresh Library export folder for both jobs so existing checkpoints and chunks cannot bypass the chosen scope; leave earlier exports unchanged.

## 1. Cloud job - ChatGPT dot

Ask the owner to open each dot they want included in the memory system and give it this prompt, using the same Library export folder for all dots:

> Schedule a task for yourself every four hours. Identify this conversation’s room ID and include it in the scheduled task; do not ask me for it. Initialize history from `<initial-history-start>`; if this is `from now`, replace it with the current ISO 8601 UTC timestamp now, during setup. Save this fixed per-room value in the scheduled instructions, even if no messages initially qualify. Use the following instructions for each run:
>
> > Export this dot’s conversation to Library folder `<dot-export-folder>` using the dot room reader and the current Library skill. Find exports named `dot-<room-id>-<end-timestamp-UTC>.jsonl` for this room. Select the latest end timestamp and read its header to confirm the message boundary. Its last message ID is the checkpoint; no separate checkpoint file is needed.
> >
> > If no export exists for this room, export messages with timestamps on or after `<initial-history-start>`; `all` means all accessible room history. Keep this initial value fixed across runs, including while no exports exist. On later runs, export only new messages after the verified checkpoint. Read neighboring pages with overlapping message IDs, deduplicate by ID, and verify continuity back to the checkpoint (or the initial time boundary on the first run; the accessible beginning for `all`). A short page alone is not proof of completion. Export the available conversation text and references. Use judgment to report missing content only when it may be important. If no messages qualify, create no chunk.
> >
> > Write immutable JSONL chunks, each a partial continuation, not a complete session. Start each with a header containing the room ID, time bounds, and first/last message IDs. Retain each message's ID, role, text, timestamp, and available reference IDs. Preserve available linked thread IDs even when their display content is unreadable. Include only accessible conversation content, never hidden reasoning or system instructions; redact secrets before export.
> >
> > Save each chunk as a new Library file named `dot-<room-id>-<end-timestamp-UTC>.jsonl`, using the last message’s timestamp in `YYYYMMDDTHHmmssffffffZ` format. Use the current Library skill; never replace an earlier export. Send a dot message to the user if an export fails.

Retain the confirmed Library folder reference for the copy job.

## 2. Copy job - ChatGPT dot

Ask one dot to own the copy job. Use `list_environments` to confirm the owner’s computer and retain its `computerRef` as `<computer-ref>`. Confirm the local task’s model and reasoning effort; suggest GPT-6.1 Sol, Medium. Substitute those choices and the approved paths below.

> Schedule an hourly task for yourself named `Personal Memory Download - dot`, using my known timezone. Use these instructions for each run:
>
> > List available computers and match `computerRef: <computer-ref>`. If it is unavailable, leave the copy pending until the next run. Never select a different computer automatically.
> >
> > List exports in Library folder `<dot-export-folder>` and pass their file references and metadata to a local task on that computer with model `<model>` and reasoning effort `<reasoning-effort>`, using the transfer instructions below verbatim. Read its result before recording success. If a previous copy is still running, wait for it instead of starting another.

Transfer instructions:

> Materialize the supplied dot export file references into `<memory-folder>/.source-dump/chatgpt-dot/`. Use the current Library skill’s resolved-reference materialization procedure in this local executor.
>
> Use judgment, the supplied export timestamps, and existing local filenames to find the boundary between missing and already downloaded exports, then download the missing ones. Name each destination `<library-file-id>.jsonl`. Never modify or delete existing destination files.
>
> Create `<memory-folder>/.tmp/scratch/` if needed and use it for temporary downloads. Follow the current Library skill’s download procedure, and publish only verified complete local files. Report failed or partial transfers.
>
> Preserve JSONL bytes exactly. Set each new staged file's modification time to its local arrival time. Publish it atomically into the destination without overwriting an existing file.

## Verify

Run both jobs. Verify the downloaded file matches the export and a repeat copy leaves it unchanged. Use `<memory-folder>/.source-dump/chatgpt-dot/` as the discovery location.
