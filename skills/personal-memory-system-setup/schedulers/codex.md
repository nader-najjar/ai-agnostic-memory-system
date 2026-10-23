# Codex Scheduling

Create standalone local jobs in the Codex desktop app. Each run starts a fresh chat.

## Inputs

- `memory_folder`: absolute path to the personal memory folder.
- `jobs`: for each job, its name, complete prompt, schedule, timezone, model, and reasoning effort.

Ask the owner for missing model or reasoning choices, showing the current configured choices as defaults. Confirm that each selected combination is available.

## Procedure

1. **Register the project.** Create `<memory_folder>/.tmp/personal-memory-codex-crons` with `mkdir -p`. Use `list_projects` to find the local project for that exact folder. If it is not registered, ask the owner to add that folder as a local project in the app. Wait for confirmation, then list projects again and obtain its project ID. Use this project for all supplied jobs.
2. **Configure access.** Read `$CODEX_HOME/config.toml`, or `~/.codex/config.toml` when `CODEX_HOME` is unset. If needed, ask permission to set `sandbox_mode = "workspace-write"` and merge `<memory_folder>` and `<memory_folder>/.git` into `sandbox_workspace_write.writable_roots`. Show the exact proposed changes and explain that they apply to new Codex sessions generally. Preserve other settings and existing paths; check that the resulting TOML parses. If permission is declined, stop and report which jobs remain unscheduled.
3. **Resolve the schedules.** Convert each approved schedule to an RRULE. The native scheduler uses local time; confirm its timezone matches the supplied timezone before creating jobs. If it does not match, ask the owner to resolve the timezone choice. Do not silently shift the requested times.
4. **Create the jobs.** Inspect `$CODEX_HOME/automations/*/automation.toml` (default `~/.codex/automations/`) for matching jobs so a resumed setup does not create duplicates. Use `automation_update` to create missing jobs or update the matching jobs, with the following fields. Preserve unrelated settings when updating.

   | Field | Value |
   | --- | --- |
   | `kind` | `cron` |
   | `name` | Supplied job name |
   | `prompt` | Supplied complete prompt |
   | `rrule` | Resolved schedule |
   | `projectId` | Registered project ID |
   | `executionEnvironment` | `local` |
   | `model` | Supplied model |
   | `reasoningEffort` | Supplied reasoning effort |
   | `status` | `ACTIVE` |
   | `notificationPolicy` | `failed_runs_only` |

5. **Enable archiving.** Ask the owner to enable `Archive successful runs` for each job in Scheduled; the automation tool does not expose this setting. Wait for confirmation.
6. **Verify registration.** Read each saved job using `automation_update` in view mode and its `automation.toml`. Confirm the project, local execution, prompt, schedule, model, reasoning effort, notification policy, and `auto_archive = true`. Confirm `kind = "cron"`, which creates independent runs rather than continuing the setup chat. Report any mismatch instead of claiming setup is complete.
7. **Report.** Give each job's identifier and schedule with timezone, and explain that it can be paused or removed in Scheduled. Registration does not prove execution works: inspect the first run for skill availability and the required filesystem access before reporting it as verified working.

Local tasks require the app to be running and the computer awake.
