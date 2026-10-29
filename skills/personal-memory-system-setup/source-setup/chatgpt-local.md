# ChatGPT Local Source Setup

This setup creates an AI cron job to periodically pull chats from the ChatGPT/Codex local internal source folder into the memory system's staging area. The AI cron job can use any AI tool located on this computer.

1. Confirm the absolute source folders where the ChatGPT local chats are stored (usually `~/.codex/sessions` and `~/.codex/archived_sessions`). Call them `<source-folders>`
2. Record onboarding time as `<onboarding-start>` in UTC.

Use the desired AI tool's scheduler to create the AI cron job, following its [recipe](../schedulers/):

- Job name: `Personal Memory Source Staging - ChatGPT & Codex (local)`
- Prompt: below, with the placeholders filled in (`<memory-folder>`, `<source-folders>`, and `<onboarding-start>`)
- Schedule: every two hours
- Timezone: user timezone
- Model: Suggested: GPT-6 Luna
- Reasoning effort: Max

## Job prompt

> Follow `Acquire Lock` in `<memory-folder>/operations/shared/shared-concepts.md`. If it returns `false`, stop.
>
> Record the current UTC time as `AI_CRON_START_TIME`.
>
> Check the files in `<memory-folder>/source-staging/chatgpt-local/`. Find the latest file's modification time, and let that be `EARLIER_COPY_TIME`. If there are no files in this directory, let `EARLIER_COPY_TIME` be `<onboarding-start>`.
>
> Inside all of `<source-folders>` find all `rollout-*.jsonl` and `rollout-*.jsonl.zst` files, including such files under any amount of subdirectories (full recursive search). Note the ones that have a file modification time >= `EARLIER_COPY_TIME`. Gather these qualifying files.
>
> Remove from the list of qualifying files any files whose `session_meta` record has a `payload.source` object containing `subagent` or `internal`, or a `payload.thread_source` of `guardian_review`, `subagent`, `memory_consolidation`, `automation`, or `onboarding_checklist`.
>
> For each final qualifying file, copy it to `<memory-folder>/source-staging/chatgpt-local/`, ensuring the following:
>   * The file is uncompressed and in `.jsonl` format (for a `.jsonl.zst` source item, use lossless Zstandard decompression)
>   * The file name, in the destination folder, is set to `<sessionID>.jsonl`, where `<sessionID>` is the `payload.id` of the `session_meta` record
>   * The file modification time, in the destination folder, is set to `AI_CRON_START_TIME`
>   * If a file with the same name already exists at the destination, overwrite that old file with the new qualifying file, ensuring the file modification time is now `AI_CRON_START_TIME`
>
> Follow the `Commit Changes` section of `<memory-folder>/operations/shared/shared-concepts.md`.
> Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md`.
