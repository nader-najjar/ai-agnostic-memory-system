---
name: chief-of-staff-setup
description: Manually invoked. Create a new, empty Chief-of-Staff memory at ~/Desktop/chief-of-staff from this skill's templates, set the owner's identities, make it a git repository, and optionally schedule its backup and a daily scout.
---

# Chief-of-Staff Setup

Chief-of-Staff is a personal, tool-agnostic memory for AI agents: a folder of plain Markdown in a local git repository. Any AI tool can read it, and only an isolated guardian agent writes to it, through the `chief-of-staff-ingest` skill. `chief-of-staff-recall` loads what it knows about named concepts, and `chief-of-staff-scout` suggests what in recent chats it should hold.

- `raw/` is a permanent library of immutable source captures. Building it is the expensive part, so each source type's capture rule in `source-types/` saves everything up front.
- `wiki/` holds pages the guardian builds from `raw/`, one per concept, with every claim cited to a capture. Pages and the four lists are derived, so they can be rebuilt from `raw/` at any time.
- `SCHEMA.md` defines every format, and `source-types/` holds one file per source type. `GUARDIAN.md` is the only write policy.
- Every successful ingest ends in its own git commit. A failed one writes nothing.

Use this skill only when the owner explicitly invokes it.

## Steps

1. **Check the target.** The memory root is `~/Desktop/chief-of-staff`, expanded to an absolute path. If it already exists, stop with: `A Chief-of-Staff memory already exists at <path>.` Never overwrite or merge into it.

2. **Ask for the owner's identities.** Ask the owner for every name the sources use for them: alias, every email, GitHub username and full name. Use exactly what they give.

3. **Create the memory root.** Copy everything in this skill's `templates/` folder into the root, keeping its folders. Write `<root>/.gitignore` containing the single line `.DS_Store`. In `<root>/SCHEMA.md`, replace the placeholder list on the `owner:` line with the owner's identities, in the same `[a, b, c]` form. Change nothing else.

4. **Make it a git repository.** Run in the root:

   ```bash
   git init -b main
   git add .
   git commit -m "chore: Initial Chief-of-Staff memory"
   ```

   Then confirm `git status --porcelain` prints nothing.

5. **Offer the backup.** Ask the owner whether to schedule the hourly backup, and for the backup folder: a folder inside a cloud client's synced folder, such as OneDrive or iCloud Drive. If they agree, run:

   ```bash
   <root>/backup-mechanism/install.sh <root> <backup-folder>
   ```

   `<root>/backup-mechanism/BACKUP.md` explains how the backup works and how to remove it.

6. **Offer the scout schedule.** Ask the owner whether to run `chief-of-staff-scout` daily. If they agree, create a scheduled job in their AI tool that runs it, passes it the tool's chat folders and transcript file pattern, and delivers its report to the owner. A schedule can skip a run while the computer is off or asleep, so make sure a missed day still runs once the computer is back, for example by checking often and running at most once a day. Tell the owner the job's name and how to pause or remove it in that tool. If the tool cannot schedule jobs, tell the owner and report the scout as not scheduled.

7. **Report.** Give the owner the root path, the initial commit, the backup and scout schedule status, and these notes:
   - The guardian needs the tools the files under `source-types/` name.
   - To change a rule, the owner edits `SCHEMA.md`, `GUARDIAN.md` or a file under `source-types/` and commits it. The guardian never edits them.
   - To undo an ingest, run `git revert <commit>` in the root.
