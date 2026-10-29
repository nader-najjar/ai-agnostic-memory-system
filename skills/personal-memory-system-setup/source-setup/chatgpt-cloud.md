# ChatGPT Cloud Source Setup

This setup creates an AI cron job to periodically pull chats from the ChatGPT/Codex cloud reading MCP into the memory system's staging area. The AI cron job **must** use a ChatGPT-based product (obviously).

1. Record onboarding time as `<onboarding-start>` in UTC.

Follow [Codex scheduling](../schedulers/codex.md) to create:

- Job name: `Personal Memory Source Staging - ChatGPT & Codex (cloud)`
- Prompt: below, with the placeholders filled in (`<memory-folder>` and `<onboarding-start>`)
- Schedule: every two hours
- Timezone: user timezone
- Model: Suggested: GPT-6 Luna
- Reasoning effort: Max

## Job prompt

> Follow `Acquire Lock` in `<memory-folder>/operations/shared/shared-concepts.md`. If it returns `false`, stop.
>
> Record the current UTC time as `AI_CRON_START_TIME`.
>
> Check the files in `<memory-folder>/source-staging/chatgpt-cloud/`. Find the latest file's modification time, and let that be `EARLIER_COPY_TIME`. If there are no files in this directory, let `EARLIER_COPY_TIME` be `<onboarding-start>`.
>
> Use your MCP tool (`list_threads`) to list active/pinned threads (chats). Note the ones that have an `updatedAt` time >= `EARLIER_COPY_TIME`. Gather these qualifying threads. Do the exact same (`list_archived_threads`) for archived threads (chats), under both archive zones (`source: chatgpt`, and separately, `hostId: durable`). Add these qualifying archived threads to the running list of qualifying threads.
>
> Remove from the list of qualifying threads any items that express local, private/incognito/temporary, and internal/automation/subagent/onboarding work, using metadata, not titles, to identify this. Also remove any threads that do not have `kind` as either `codex` or `chatgpt`.
>
> For each qualifying thread, download its corresponding full chat as a `.jsonl` file using `read_thread`:
>   * Paginate as needed
>   * Use `includeOutputs: true`
>   * Use maximum supported limits, follow all cursors, and recover truncation where possible
>   * Ensure to retain the mtadata containing UID, source `updatedAt`, and others, followed by the complete returned pages
>   * Redact secrets
>   * Use `<memory-folder>/.tmp/scratch` if needed to hold your scratch copies
>
> For each downloaded full chat item, copy it to `<memory-folder>/source-staging/chatgpt-cloud/`, ensuring the following:
>   * The file name, in the destination folder, is set to `<kind>-<ID>.jsonl`, where `<ID>` is the `id` of the qualifying thread and `<kind>` is the kind from the qualifying thread
>   * The file modification time, in the destination folder, is set to `AI_CRON_START_TIME`
>   * If a file with the same name already exists at the destination, overwrite that old file with the new qualifying file, ensuring the file modification time is now `AI_CRON_START_TIME`
>
> Follow the `Commit Changes` section of `<memory-folder>/operations/shared/shared-concepts.md`.
> Release the lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md`.
