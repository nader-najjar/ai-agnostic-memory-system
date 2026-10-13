---
name: chief-of-staff-setup
description: Manually invoked. Create a new, empty Chief-of-Staff memory at ~/Desktop/chief-of-staff from this skill's templates, set the owner's identities, make it a git repository, and optionally schedule its backup.
---

# Chief-of-Staff Setup

Chief-of-Staff is a personal, tool-agnostic memory for AI agents: a folder of plain Markdown in a local git repository. Any AI tool can read it, and only an isolated guardian agent writes to it, through the `chief-of-staff-ingest` skill. `chief-of-staff-recall` loads what it knows about named concepts. Agents that work on the memory without writing it, such as `chief-of-staff-scout`, keep their own state in a separate repository that `chief-of-staff-operations-setup` creates.

- `raw/` is a permanent library of immutable source captures. Building it is the expensive part, so each source type's capture rule in `source-types/` saves everything up front.
- `wiki/` holds pages the guardian builds from `raw/`, one per concept, with every claim cited to a capture. Pages and the four lists are derived, so they can be rebuilt from `raw/` at any time.
- `SCHEMA.md` defines every format, and `source-types/` holds one file per source type. `GUARDIAN.md` is the only write policy.
- Every successful ingest ends in its own git commit. A failed one writes nothing.

Use this skill only when the owner explicitly invokes it.

## Owner Input

When a step says **Ask**, send exactly the question given and end your turn. When the interface has a native question card, such as `ask_question` in Kiro Crew, put every question that does not depend on an earlier answer on one card, as many as it allows; ask a question that depends on an earlier answer only once that answer arrives. Wait for the owner's reply. Until it arrives, don't continue, assume a default or run any later step. If the reply doesn't answer the question, say what is missing and ask the same question again. Use only what the owner gives. Never fill an answer in from the machine, git config, other memories or earlier chats.

## Steps

1. **Check the target.** The memory root is `~/Desktop/chief-of-staff`, expanded to an absolute path. If it already exists, stop with: `A Chief-of-Staff memory already exists at <path>.` Never overwrite or merge into it.

2. **Ask for the owner's identities.** Ask: `List every name your sources use for you: your alias, each email, your GitHub username and your full name. Write "none" for any you don't have.` The reply must give a value or `none` for each of the four; more than one email is fine. Use exactly what the owner gives.

3. **Ask about the backup.** Ask: `Schedule an hourly cloud backup of the memory, into a folder a cloud client such as OneDrive or iCloud Drive syncs, so it survives losing this computer? (yes / no)`. On `no`, there is no backup. On `yes`, ask: `Which cloud-synced folder should hold the backup? It must be inside a folder OneDrive, iCloud Drive or another cloud client syncs, not a plain local folder.` Expand `~` to an absolute path. If the folder does not exist, is inside the memory root, or is not inside a cloud client's synced folder, say so and ask again.

4. **Confirm.** Show the owner the memory root, the identities as they will appear on the `owner:` line, and the backup folder or `no backup`. Ask: `Create the memory with these settings? (yes / no)`. On `no`, stop with: `Setup cancelled; nothing was written.` Write nothing before this step.

5. **Create the memory root.** Copy everything in this skill's `templates/` folder into the root, keeping its folders. Write `<root>/.gitignore` containing the single line `.DS_Store`. In `<root>/SCHEMA.md`, replace the placeholder list on the `owner:` line with the owner's identities, in the same `[a, b, c]` form, leaving out every `none`. Change nothing else.

6. **Make it a git repository.** Run in the root:

   ```bash
   git init -b main
   git add .
   git commit -m "chore: Initial Chief-of-Staff memory"
   ```

   Then confirm `git status --porcelain` prints nothing.

7. **Install the backup.** Only when step 3 got `yes`, run:

   ```bash
   <root>/backup-mechanism/install.sh <root> <backup-folder>
   ```

   If it fails, report its error and the backup as not scheduled; the memory stays as created. `<root>/backup-mechanism/BACKUP.md` explains how the backup works and how to remove it.

8. **Report.** Give the owner the root path, the initial commit, the backup status, and these notes:
   - The guardian needs the tools the files under `source-types/` name.
   - To change a rule, the owner edits `SCHEMA.md`, `GUARDIAN.md` or a file under `source-types/` and commits it. The guardian never edits them.
   - To undo an ingest, run `git revert <commit>` in the root.
   - To run `chief-of-staff-scout`, by hand or daily, run `chief-of-staff-operations-setup` first.
