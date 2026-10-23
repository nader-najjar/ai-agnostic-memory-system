---
name: personal-memory-system-setup
description: Begin personal memory setup by asking which supported AI tools' conversations the owner wants remembered.
---
# Personal Memory System Setup

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

## Initialize Queue

1. Create the initial queue file using the [Queue](shared-concepts.md#queue) definition, with the current UTC timestamp and an empty `items` array.

## Initialize Git

1. Initialize the new memory folder as a Git repository.
2. Create `.gitignore`, and add `.lock/` and `/.tmp/` to it.
3. Stage `config.json`, `.gitignore`, `always.md`, and `operations/` and commit them as the initial state.
4. Confirm that the commit succeeded and report the result to the owner. If initialization or the commit fails, stop and report the error.

## Schedule Backup

1. If `backup_file` is `null`, skip this section. Otherwise ask: “How often should the backup run? Recommended: every hour.” Wait for the owner's answer and confirm the interval.
2. Fill in [scripts/backup.plist](scripts/backup.plist) with the job label, absolute paths, and approved interval; install it in `~/Library/LaunchAgents/` and load it with `launchctl`.
3. Trigger the job once through the scheduler and wait for it to finish. Confirm a successful exit and verify the destination bundle with `git -C "<memory-folder>" bundle verify "<backup_file>"`. Report the backup path, schedule, and job identifier. If registration or the first run fails, report the failure instead of claiming the backup is working.

## Schedule Discovery and Memorize

1. Ask: “When should discovery and memorization run? Recommended: discovery every 3 hours at minute :00, and memorization every 2 hours at minute :15, in your local timezone.” Wait for the owner's answer and confirm both schedules and the timezone.
2. Follow the current AI tool's recipe in [schedulers/](schedulers/), supplying the absolute `<memory-folder>` path and the approved schedules and timezone for these jobs; obtain model and reasoning choices as the recipe directs:
   - **Personal Memory Discover:** `$personal-memory-system-discover "<memory-folder>"`
   - **Personal Memory Memorize:** `$personal-memory-system-memorize "<memory-folder>"`
   If no recipe exists for the current tool, report scheduling as unsupported.
3. Confirm that both schedules were created and report their times and identifiers. If scheduling is unavailable or either job fails to register, report which jobs have and have not been scheduled.
