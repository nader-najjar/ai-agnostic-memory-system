---
name: personal-memory-system-setup
description: Begin personal memory setup by asking which supported AI tools' conversations the owner wants remembered.
---
# Personal Memory System Setup

## Ensure Skills Are Installed

1. Check that every personal-memory-system skill from the same source as this setup skill is installed and available to the current AI tool. Install or update any missing or outdated skills before continuing.

## Choose Sources

1. Read every Markdown file directly in [source-types/](source-types/). Each file defines one available source type. Read its **Identifier** and **Display Name** sections to build the choices.
2. Ask: “Which AI tools' conversations do you want this system to automatically learn from?” Show the available tools and allow one or more selections. Use an interactive question tool if it supports multiple selections; otherwise ask in chat.
3. Wait for the owner's answer and confirm the selected tools.

## Approve Source Locations

1. For each selected tool, read its default source locations from its definition and ask: “May I read conversations from these locations, or should I use different locations?” Show each resolved path. Use the defaults or alternatives approved by the owner.
2. Wait for the owner's answer and confirm the selected paths.
3. Check each selected location for files matching its source definition’s **Source Items** criteria. For each location, tell the owner whether matching files were found.

## Create the Memory Folder

1. Ask: “Where would you like this system to store your personal memory? Default: `~/Desktop/personal-memory-system`.”
2. Wait for the owner's answer and confirm the storage location.
3. Resolve the approved storage path and create the folder with `mkdir` without `-p`. Fail and stop if anything already exists at that path, including an empty folder, file, or symlink. Never reuse or overwrite it.
4. This folder name, going forward in this skill, is `<memory-folder>`.
5. Create `captures/`, `memory/`, and `operations/queue-snapshots/` under `<memory-folder>`. Add an empty `.gitkeep` file in each so Git preserves the folders during backup and recovery.

## Choose Backup Folder

1. Ask: “Would you like to back up your memory to a cloud-synced folder, such as iCloud Drive, OneDrive, or Dropbox, so it can survive losing this computer? If yes, which folder should hold the backup? You may skip backup.”
2. Wait for the owner's answer. If they choose backup, expand the folder to an absolute path and confirm it exists, is outside `<memory-folder>`, and is synced by their cloud client. Ask the owner to confirm cloud syncing if it cannot be determined locally.
3. If they chose backup, determine the backup file using the [Memory Configuration](shared-concepts.md#memory-configuration) definition and show its path. If that file already exists, ask for a different folder to avoid overwriting an existing backup.

## Save Configuration

1. Create `<memory-folder>/config.json` using the [Memory Configuration](shared-concepts.md#memory-configuration) definition. Add each source the owner approved into the array and set `backup_file` from their backup choice. Tell the owner where it was saved and show it inline.

## Install Shared Concepts

1. Create `<memory-folder>/operations/shared/` with `mkdir -p`, then copy [shared-concepts.md](shared-concepts.md) into it.
2. Copy [source-types/](source-types/) into `<memory-folder>/operations/shared/source-types/`.

## Install Backup

1. If the owner chose backup, copy [scripts/backup.sh](scripts/backup.sh) to `<memory-folder>/operations/backup.sh` and make it executable.

## Install Always

1. Explain that `always.md` holds standing instructions for agents, so the owner does not need to repeat their preferences and working rules in every chat. Recommend maintaining one accessible document, such as a local Markdown file or a Notion page, as the source of truth for those instructions, with local exceptions under `Personal Adjustments`.
2. Ask for the URL or local file path to that document and any personal adjustments to include. The owner may create a document now or leave the document location and adjustments for later. Wait for their answer.
3. Copy [always.md](always.md) to `<memory-folder>/always.md`. Replace `<agent-instructions-location>` with the supplied URL or local file path, expanding local paths to absolute paths. Remove the link sentence if the owner skipped it. Add any supplied adjustments under `Personal Adjustments`. Show the resulting file to the owner; they maintain it going forward.

## Initialize Queue and Backfill

1. Create the initial queue file using the [Queue](shared-concepts.md#queue) definition, with `discovered_through` set to the current UTC time minus two hours and an empty `items` array.
2. Create the backfill worklist using the [Backfill](shared-concepts.md#backfill) definition, with an empty `items` array.

## Initialize Git

1. Initialize the new memory folder as a Git repository.
2. Create `.gitignore`, and add `.lock/` and `/.tmp/` to it.
3. Run `git add .` from `<memory-folder>` and commit the initial state.
4. Confirm that the commit succeeded and report the result to the owner. If initialization or the commit fails, stop and report the error.

## Backfill Existing Conversations

1. Check each configured source's matching files and modification times. Summarize the conversation count and available date range for each source. Recommend backfilling all available history.
2. Ask whether the owner wants to backfill the recommended sources and date range, choose different ones, or skip backfill. Wait for their answer.
3. If they choose backfill, run `$personal-memory-system-backfill` with `<memory-folder>`, the selected sources, and date range. Explain that the snapshots will be memorized in the background as normal discovery leaves room.

## Schedule Backup

1. If `backup_file` is `null`, skip this section. Otherwise ask: “How often should the backup run? Recommended: every hour.” Wait for the owner's answer and confirm the interval.
2. Fill in [scripts/backup.plist](scripts/backup.plist) with the job label, absolute paths, and approved interval; install it in `~/Library/LaunchAgents/` and load it with `launchctl`.
3. Trigger the job once through the scheduler and wait for it to finish. Confirm a successful exit and verify the destination bundle with `git -C "<memory-folder>" bundle verify "<backup_file>"`. Report the backup path, schedule, and job identifier. If registration or the first run fails, report the failure instead of claiming the backup is working.

## Schedule Discovery, Memorize, and Troubleshoot

Suggested starting models and reasoning effort for the scheduled jobs:

| Job | OpenAI | Claude |
| --- | --- | --- |
| Discover | GPT-6 Luna · Max | Haiku 5.5 · Max |
| Memorize | GPT-6.1 Sol · High | Sonnet 5.5 · High |
| Troubleshoot | GPT-6.1 Sol · Medium | Sonnet 5.5 · Medium |

On a standard $20/month plan, consider lighter models or lower reasoning effort to conserve usage, especially for discovery and troubleshooting; prioritize memorization quality. Empirically, Luna and Haiku use barely any usage even with lots of chats.

1. Ask: “When should discovery, memorization, and troubleshooting run? Recommended: troubleshooting hourly at minute :00, discovery hourly at minute :10, and memorization every hour at minutes :20 and :45, in your local timezone.” Explain that this gives discovery 10 minutes before memorization starts, and each memorization run 25 minutes before the next discovery or memorization run. Wait for the owner's answer and confirm all three schedules and the timezone. Explain that troubleshooting may stop a run holding the lock for over two hours and discard its uncommitted changes so processing can retry.
2. Show the model recommendations above for the current AI tool. Ask which model and reasoning effort to use for each of discovery, memorization, and troubleshooting. Wait for the owner's answer and confirm all three choices.
3. Follow the current AI tool's recipe in [schedulers/](schedulers/), supplying the absolute `<memory-folder>` path and the approved schedules, timezone, models, and reasoning effort for these jobs:
   - **Personal Memory Discover:** `$personal-memory-system-discover "<memory-folder>"`
   - **Personal Memory Memorize:** `$personal-memory-system-memorize "<memory-folder>"`
   - **Personal Memory Troubleshoot:** `$personal-memory-system-troubleshoot "<memory-folder>"`
   If no recipe exists for the current tool, report scheduling as unsupported.
4. Confirm that all three schedules were created and report their times and identifiers. If scheduling is unavailable or any job fails to register, report which jobs have and have not been scheduled.

## Explain How to Use Your Memory

Give the owner this short guide, using their actual memory folder and configured tools:

- Start a new chat with `$personal-memory-system-recall <topics>` when you want remembered context. Include the memory folder path if it differs from the default.
- Teach through ordinary conversations: explain your preferences, decisions, reasons, and corrections. Conversations from the configured sources are processed on the schedules set up above; new information may take time to become available to recall.
- To remember something from a document, website, or other source, ask the chat to read it and discuss what matters. The material must appear in the conversation or its tool results; sharing a link alone does not capture its contents.
- Keep standing instructions in the resource linked from `always.md`, with personal exceptions in that file. You maintain these instructions; memorization does not update them.
- Use recall to start fresh chats as needed. If something important is missing or wrong, explain it in a configured chat so a later processing run can incorporate the correction.
