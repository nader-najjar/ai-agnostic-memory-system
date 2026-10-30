# ChatGPT Dot Source Setup

This recipe has two jobs: dot exports its room to ChatGPT Library every four hours and indexes the files in a private Page, and a local AI cron job reads that Page hourly. The AI cron job **must** use a ChatGPT-based product (obviously).

1. Record onboarding time as `<onboarding-start>` in UTC.
2. Confirm a dedicated Library folder (default: `Memory Exports/Dot`) as `<dot-export-folder>`
3. Confirm a dedicated index Library Page for each dot as `<dot-export-index>-<dot-name>`

## 1. Dot Job

For each dot, create the customized prompt by replacing the `<onboarding-start>`, `<dot-export-folder>`, and `<dot-export-index>-<dot-name>` placeholders in the prompt below with the obtained values. Ask the owner to open each dot they want included and give it this value-replaced prompt.

### Job Prompt

> Schedule a task for yourself every two hours. Identify this conversation’s room ID and replace the room ID placeholder in the scheduled task with it. Here is the prompt for the scheduled task:
>
> > Check the files in `<dot-export-index>-<dot-name>`. Find the latest export's time, and let that be `EARLIER_EXPORT_TIME`. If there are no such exports, let `EARLIER_EXPORT_TIME` be `<onboarding-start>`.
> >
> > Record the current UTC time as `AI_CRON_START_TIME`.
> >
> > Prepare a `.jsonl` export of this dot's conversation containing all conversation content from `EARLIER_EXPORT_TIME` to `AI_CRON_START_TIME` using the dot room reader. Name the export file `<room-id>-<AI_CRON_START_TIME>.jsonl`. The export is best-effort - do not use a small issue as an excuse to abort. Start each file with a JSON header containing the room ID and the export interval’s start and end times in UTC. Retain each message's ID, role, text, timestamp, and available reference IDs. Preserve available linked thread IDs even when their display content is unreadable. Redact secrets before export. If the export ends up being > 1 MB, split it into 2 (or more as needed) files, using judgement to follow these instructions but modified to handle more than one export.
> >
> > Place this export in the Library folder `<dot-export-folder>` using the Library skill/mcp.
> >
> > Index the new export in the ChatGPT Library page `<dot-export-index>-<dot-name>`, as a single entry with the export's file name and exact returned `library-file:` reference.

## 2. Local job - ChatGPT/Codex

Follow [Codex scheduling](../schedulers/codex.md) to create:

- Job name: `Personal Memory Source Staging - ChatGPT Dot`
- Prompt: below, with the placeholders filled in (`<onboarding-start>`, `<memory-folder>` and `<ALL_DOT_INDICES>` [using all of `<dot-export-index>-<dot-name>`])
- Schedule: every two hours
- Timezone: user timezone
- Model: Suggested: GPT-6 Luna
- Reasoning effort: Max

### Job Prompt

> Follow `Acquire Lock` in `<memory-folder>/operations/shared/shared-concepts.md`. If it returns `false`, stop.
>
> Record the current UTC time as `AI_CRON_START_TIME`.
>
> Read the `chatgpt-dot` source entry’s `staged_through` in `<memory-folder>/config.json`. If non-null, subtract 1 day in UTC and use that as `EARLIER_COPY_TIME`; otherwise use `<onboarding-start>`.
>
> Let `<dot-indices-list>` be [`<ALL_DOT_INDICES>`]. Each ChatGPT Library Page in `<dot-indices-list>` has entries of the form `<dot-room-id>-<export-end-time-utc>.jsonl`. For each of the Library Pages in `<dot-indices-list>`, gather all entries that have an `<export-end-time-utc>` after `EARLIER_COPY_TIME`. These gathered entries are the qualifying entries.
>
> For each qualifying entry, download the corresponding `jsonl` file using its name and its `library-file:` reference, both of which are in the index's entry. Use the `read_page_reference` tool to do so. Follow `Scratch` in `<memory-folder>/operations/shared/shared-concepts.md` for temporary copies.
>
> For each downloaded file, copy it to `<memory-folder>/source-staging/chatgpt-dot/`, ensuring the following:
>   * The file name, in the destination folder, is set to the exact name it had in the index entry (`<dot-room-id>-<export-end-time-utc>.jsonl`)
>   * The file modification time, in the destination folder, is set to `AI_CRON_START_TIME`
>   * If a file with the same name already exists at the destination, delete the downloaded file from scratch, and move on, leaving the pre-existing destination file as-is
>
> After the entire batch succeeds, set this source entry’s `staged_through` to `AI_CRON_START_TIME` in `config.json`.
>
> Follow the `Commit Changes` section of `<memory-folder>/operations/shared/shared-concepts.md`.
> Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md`.
