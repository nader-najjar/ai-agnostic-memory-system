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

1. For each selected tool, read its usual source location from its definition and ask: “May I read conversations from `<location>`, or should I use another location?” Show the resolved path. Use the usual location or an alternative approved by the owner.
2. Wait for the owner's answer and confirm the selected paths.
3. Check each selected location using its source definition’s **Source Items** section. Inspect filenames only. For each location, tell the owner whether matching items were found.

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

## Initialize Git

1. Initialize the new memory folder as a Git repository.
2. Create `.gitignore`, and add `.lock/` to it.
3. Stage `config.json`, `.gitignore`, and `operations/` and commit them as the initial state.
4. Confirm that the commit succeeded and report the result to the owner. If initialization or the commit fails, stop and report the error.
