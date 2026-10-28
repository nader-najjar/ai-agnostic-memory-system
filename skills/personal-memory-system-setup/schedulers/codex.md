# Codex Scheduling

Create standalone local jobs in ChatGPT/Codex. Configure each run to start in a new chat.

## Inputs

- `memory_folder`: absolute path to the personal memory folder.
- `jobs`: for each job, its name, complete prompt, schedule, timezone, and suggested model and reasoning effort.

Ask the owner to choose model and reasoning effort, showing the supplied recommendations or current choices as defaults. Confirm that each selected combination is available.

## Procedure

1. **Register the local project.** Create `<memory_folder>/.tmp/personal-memory-codex-crons` with `mkdir -p`. Use `list_projects` to find the local project for that exact folder. If it is not registered, ask the owner to add that folder as a local project in the app. Wait for confirmation, then list projects again and obtain its project ID. Use this project for the supplied local jobs.
2. **Configure local access.** Read `$CODEX_HOME/config.toml`, or `~/.codex/config.toml` when `CODEX_HOME` is unset. If needed, ask permission to set `sandbox_mode = "workspace-write"` and merge `<memory_folder>` and `<memory_folder>/.git` into `sandbox_workspace_write.writable_roots`. Show the exact proposed changes and explain that they apply to new Codex sessions generally. Preserve other settings and existing paths; check that the resulting TOML parses. If permission is declined, stop and report which jobs remain unscheduled.
3. **Resolve the schedules.** Use the owner’s known timezone. Use an RRULE and the desktop scheduler’s timezone. Resolve a timezone mismatch before creating the job.
4. **Create the jobs.** Use `automation_update` with these fields. Rows marked UI are app settings, not additional API arguments.

   | Field | Value |
   | --- | --- |
   | Run on this computer | On; set by default by the MCP used |
   | Start each run in new chat | `kind: cron` |
   | Archive successful runs | Owner enables in UI |
   | `mode` | `create` |
   | `kind` | `cron` |
   | `name` | Supplied job name |
   | `prompt` | Supplied complete prompt |
   | `rrule` | Resolved RRULE |
   | `projectId` | Registered project ID |
   | `executionEnvironment` | `local` |
   | Model | `model`: owner’s choice |
   | Effort | `reasoningEffort`: owner’s choice |
   | `status` | `ACTIVE` |
   | `notificationPolicy` | `failed_runs_only` |

5. **Set UI-only options.** Ask the owner to apply the UI settings specified in the table. Wait for confirmation.
6. **Verify registration.** Read jobs with `automation_update` in view mode and their `automation.toml`. Confirm the settings above and `auto_archive = true`; use the owner’s confirmation for UI-only settings not returned by the tool. Report any mismatch instead of claiming setup is complete.
7. **Report.** Give each job's identifier and schedule with timezone, and explain that it can be paused or removed in Scheduled. Registration does not prove execution works: inspect the first run for the tools, skills, and access required by its prompt before reporting it as verified working.

Local tasks require the app to be running and the computer awake.
