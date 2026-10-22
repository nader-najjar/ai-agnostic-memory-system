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

## Save Configuration

1. Create `<memory-folder>/config.json` using the [Memory Configuration](shared-concepts.md#memory-configuration) definition. Add each source the owner approved into the array. Tell the owner where it was saved and show it inline.

## Install Shared Concepts

1. Create `<memory-folder>/operations/shared/` with `mkdir -p`, then copy [shared-concepts.md](shared-concepts.md) into it.
2. Copy [source-types/](source-types/) into `<memory-folder>/operations/shared/source-types/`.

## Install Always

1. Explain that `always.md` holds standing instructions for agents, so the owner does not need to repeat their preferences and working rules in every chat. Recommend maintaining one accessible document, such as a local Markdown file or a Notion page, as the source of truth for those instructions, with local exceptions under `Personal Adjustments`.
2. Ask for the URL or local file path to that document and any personal adjustments to include. The owner may create a document now or leave the document location and adjustments for later. Wait for their answer.
3. Copy [always.md](always.md) to `<memory-folder>/always.md`. Replace `<agent-instructions-location>` with the supplied URL or local file path, expanding local paths to absolute paths. Remove the link sentence if the owner skipped it. Add any supplied adjustments under `Personal Adjustments`. Show the resulting file to the owner; they maintain it going forward.

## Initialize Queue

1. Create the initial queue file using the [Queue](shared-concepts.md#queue) definition, with the current UTC timestamp and an empty `items` array.

## Initialize Git

1. Initialize the new memory folder as a Git repository.
2. Create `.gitignore`, and add `.lock/` to it.
3. Stage `config.json`, `.gitignore`, `always.md`, and `operations/` and commit them as the initial state.
4. Confirm that the commit succeeded and report the result to the owner. If initialization or the commit fails, stop and report the error.
