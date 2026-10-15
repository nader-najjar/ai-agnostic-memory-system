---
name: chief-of-staff-operations-setup
description: Manually invoked. Create the Chief-of-Staff operations repository at ~/Desktop/chief-of-staff-operations, where agents that work on the memory without writing it, such as chief-of-staff-scout, keep their state, make it a git repository, and optionally schedule its backup and a daily scout.
---

# Chief-of-Staff Operations Setup

The Chief-of-Staff memory at `~/Desktop/chief-of-staff` is written only by its guardian. Agents that operate on it without writing it, such as `chief-of-staff-scout`, keep their own state, such as cursors and an inbox, in a separate local git repository, the operations repository, so that state has history and a backup without touching the memory. Each agent owns one folder in it, named after the agent, such as `scout/`, writes only there, and commits only that folder.

Use this skill only when the owner explicitly invokes it.

## Owner Input

When a step says **Ask**, send exactly the question given and end your turn. When the interface has a native question card, such as `ask_question` in Kiro Crew, put every question that does not depend on an earlier answer on one card, as many as it allows; ask a question that depends on an earlier answer only once that answer arrives. Wait for the owner's reply. Until it arrives, don't continue, assume a default or run any later step. If the reply doesn't answer the question, say what is missing and ask the same question again. Use only what the owner gives. Never fill an answer in from the machine, git config, other memories or earlier chats.

## Steps

Follow these steps, and apply every rule in Special Cases below wherever its case arises.

1. **Check the targets.** The memory root is `~/Desktop/chief-of-staff` and the operations root is `~/Desktop/chief-of-staff-operations`, both expanded to absolute paths. If the memory root has no `SCHEMA.md` starting with `schema_version: 2`, stop with: `No Chief-of-Staff memory at <path>. Run chief-of-staff-setup first.` If the operations root already exists, stop with: `A Chief-of-Staff operations repository already exists at <path>.` Never overwrite or merge into it.

2. **Find the feeds.** Each file in this skill's `templates/feeds/` defines one kind of feed. Each one names the source `Type` its items are; leave out a feed whose type is not in the memory's `source-types/`. With `<home>` as the owner's absolute home folder, and any other placeholder resolved as the feed's `Where` defines it, note for each remaining feed whether its `Where` matches any file on this machine. Read only; write nothing.

3. **Ask which feeds to add.** Skip this step when step 2 left no feed. Otherwise ask: `Which feeds should the scout watch? Reply with their names, "all", or "none".` followed by one line per feed from step 2: its name without `.md`, its title, and `has data` or `no data yet`. The reply must name only listed feeds, or be `all` or `none`; otherwise say which names are unknown and ask again. The selected feeds are the ones the later steps add.

4. **Ask about the backup.** Ask: `Schedule an hourly cloud backup of the operations repository, into a folder a cloud client such as OneDrive or iCloud Drive syncs, so it survives losing this computer? (yes / no)`. On `no`, there is no backup. On `yes`, ask: `Which cloud-synced folder should hold the backup? It must be inside a folder OneDrive, iCloud Drive or another cloud client syncs, not a plain local folder. The memory's backup folder works, since each repository gets its own bundle and job.` Expand `~` to an absolute path. If the folder does not exist, is inside the operations root, or is not inside a cloud client's synced folder, say so and ask again.

5. **Ask about the scout schedule.** Skip this step when no feed was selected. Otherwise ask: `Schedule a daily scout of these feeds: <the selected feed names, without .md, comma-separated>? (yes / no)`.

6. **Confirm.** Show the owner the operations root, the backup folder or `no backup`, the selected feeds or `no feeds`, and whether the scout will be scheduled. Ask: `Create the operations repository with these settings? (yes / no)`. On `no`, stop with: `Setup cancelled; nothing was written.` Write nothing before this step.

7. **Create the operations root.** Create the folder. Copy the `templates/backup-mechanism/` folder of the `chief-of-staff-setup` skill, installed beside this skill, into it as `backup-mechanism/`. Write `<root>/.gitignore` containing the two lines `.DS_Store` and `.lock`, so no agent's lock is ever committed.

8. **Make it a git repository.** Run in the operations root:

   ```bash
   git init -b main
   git add .
   git commit -m "chore: Initial Chief-of-Staff operations repository"
   ```

   Then confirm `git status --porcelain` prints nothing.

9. **Install the backup.** Only when step 4 got `yes`, run:

   ```bash
   <root>/backup-mechanism/install.sh <root> <backup-folder>
   ```

   If it fails, report its error and the backup as not scheduled. `<root>/backup-mechanism/BACKUP.md` explains how the backup works and how to remove it.

10. **Add the feeds.** Skip this step when no feed was selected. Copy each selected feed file into `<root>/scout/feeds/`, replacing `<home>` with the owner's home folder. Commit them with `git -C <root> add scout/feeds && git -C <root> commit -m "scout: Add the feeds"`.

11. **Schedule the scout.** Only when step 5 got `yes`, create one job per feed added in step 10, as Scout Schedule below says for this AI tool, where `<feed>` is the feed file's name without `.md`. Each job runs every hour, so each feed is scouted once a day, on the first hour the computer is awake. Tell the owner each job's name and how to pause or remove it in that tool.

12. **Report.** Give the owner the operations root path, the initial commit, and the backup, feed and scout schedule status. Name the feeds left out, and tell the owner that a feed can be added later by copying its file from this skill's `templates/feeds/` into `<root>/scout/feeds/`, replacing `<home>`, committing it, and scheduling it as Scout Schedule says.

## Scout Schedule

Only the AI tools below are supported. In any other tool, tell the owner the scout schedule is not supported there yet, and report the scout as not scheduled.

### Kiro Crew

Create each job by running this command in the shell, exactly as written, with `<feed>` and `<timezone>` filled in and nothing added:

```bash
kirocrew cron add "Chief-of-Staff scout: <feed>" "$(printf '%s\n%s' '$chief-of-staff-scout <feed> scheduled' 'Unless the scheduled check stopped the run, call send_message with your reply line as its only argument.')" --cron "0 * * * *" --timezone <timezone> --silent --hide-in-chat --no-persistent-session --no-minimal-context --timeout-secs 3600
```

`<timezone>` is the machine's IANA timezone: the part of `readlink /etc/localtime` after `zoneinfo/`, such as `America/New_York`. The command prints the new job's id; when it exits non-zero, report its error and the scout as not scheduled.

Use the shell command, not the `cron_add` tool: a job `cron_add` creates is owned by the chat that created it, so only that chat can change it, while a job the shell command creates has no owning chat. `--silent` keeps a run that the scheduled check stops from notifying the owner, since Kiro Crew otherwise delivers every run, even one with no reply. `--no-minimal-context` is needed because a minimal-context run loads no skill.

### Codex in the ChatGPT desktop app

Use the app's native standalone scheduler, with one dedicated project for all selected feeds. Each run starts a fresh chat associated with that project; successful run chats are archived automatically. Follow these steps in order; resume at the waiting step after each owner reply.

1. **Prepare the folder.** Create `~/Desktop/chief-of-staff-operations/tmp/scheduled-runs`, expanded to an absolute path. Add `/tmp/` to the operations repository's `.gitignore`, preserve its other entries, and commit only that file.

2. **Set the sidebar grouping.** Use the app's sidebar-preferences tool to group chats by Projects.

3. **Ask the owner to create the project.** Ask: `Add <absolute scheduling-folder path> as a local project in the app, named Chief-of-Staff scheduled runs. In Recents, open its menu and uncheck Show > Projects. Have you done both? (yes / no)`. Wait for the reply, then list registered projects and obtain the project ID for the exact scheduling folder. The owner adds the project in the UI; creating the folder does not register it. Unchecking Show > Projects hides all project chats from Recents.

4. **Configure access.** Edit `$CODEX_HOME/config.toml`, or `~/.codex/config.toml` when `CODEX_HOME` is unset. Set the top-level `sandbox_mode` to `"workspace-write"`. Merge these two paths into `sandbox_workspace_write.writable_roots`, replacing `<home>` with the owner's absolute home folder:

   ```toml
   [sandbox_workspace_write]
   writable_roots = [
     "<home>/Desktop/chief-of-staff-operations",
     "<home>/Desktop/chief-of-staff-operations/.git"
   ]
   ```

   Preserve the other array entries, table settings and approval settings; do not append a duplicate table or key. The explicit `.git` entry permits Scout's commits. Do not add the memory, Desktop or home folder as a writable root. Check that the edited TOML parses. Tell the owner: `These writable-folder settings apply to new Codex sessions generally, including scheduled runs; they are not limited to these jobs.` Verify both paths appear as writable in the new Scout run before claiming access works.

5. **Create the jobs.** Use the native automation tool to create one standalone cron job per selected feed, named `Chief-of-Staff scout: <feed>`. Set `Start run in new chat`, target the registered project ID, select local execution, and schedule hourly checks at minute zero in the machine's local timezone. Use the owner's configured available model and reasoning effort. The whole saved prompt is `$chief-of-staff-scout <feed> scheduled`. Keep the normal result-notification policy. Have the owner enable `Archive successful runs` in the created job's settings; the native automation tool does not expose this checkbox. Confirm each saved job has `Start run in new chat` selected and `Archive successful runs` on, with the correct project, prompt, cadence and execution mode.

6. **Report.** Give each job's ID, schedule status, and how to pause or remove it in Scheduled. Explain that successful run chats are under Settings > Archived chats, grouped by the scheduling project. The project heading's three-dot menu can delete all archived chats in that project. Report silent skipped-check delivery as unverified. Report any setup failures.

## Special Cases

- **A feed with no data yet.** It can still be added in step 3; it is scouted once its tool writes chats.
