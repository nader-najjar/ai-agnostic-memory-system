# Codex Scheduling

Create standalone jobs in ChatGPT/Codex with the supplied execution location. Configure each run to start in a new chat.

## Inputs

- `memory_folder`: absolute path to the personal memory folder; required only for local jobs.
- `jobs`: for each job, its name, complete prompt, schedule, timezone, execution location (`local` or `cloud`), and suggested model and reasoning effort.

Ask the owner to choose model and reasoning effort, showing the supplied recommendations or current choices as defaults. Confirm that each selected combination is available.

## Procedure

1. **Register the local project.** Skip for cloud jobs. Create `<memory_folder>/.tmp/personal-memory-codex-crons` with `mkdir -p`. Use `list_projects` to find the local project for that exact folder. If it is not registered, ask the owner to add that folder as a local project in the app. Wait for confirmation, then list projects again and obtain its project ID. Use this project for the supplied local jobs.
2. **Configure local access.** Skip for cloud jobs. Read `$CODEX_HOME/config.toml`, or `~/.codex/config.toml` when `CODEX_HOME` is unset. If needed, ask permission to set `sandbox_mode = "workspace-write"` and merge `<memory_folder>` and `<memory_folder>/.git` into `sandbox_workspace_write.writable_roots`. Show the exact proposed changes and explain that they apply to new Codex sessions generally. Preserve other settings and existing paths; check that the resulting TOML parses. If permission is declined, stop and report which jobs remain unscheduled.
3. **Resolve the schedules.** Use the owner’s known timezone. Local jobs use an RRULE and the desktop scheduler’s timezone; cloud jobs use an iCal VEVENT and `default_timezone`. Resolve a timezone mismatch before creating the job.
4. **Create the jobs.** Use `automation_update` for local jobs and `automations.create` for cloud jobs, with these fields. Rows marked UI are app settings, not additional API arguments.

   | Field | Local | Cloud |
   | --- | --- | --- |
   | Run on this computer | On; set by default by the MCP used | Off; set by default by the MCP used |
   | Start each run in new chat | `kind: cron` | Owner enables in UI |
   | Archive successful runs | Owner enables in UI | — |
   | `mode` | `create` | Omit |
   | `kind` | `cron` | Omit |
   | `name` / `title` | `name`: supplied job name | `title`: supplied job name |
   | `prompt` | Supplied complete prompt | Supplied complete prompt |
   | `rrule` / `schedule` | `rrule`: resolved RRULE | `schedule`: resolved VEVENT |
   | `default_timezone` | Omit | Owner’s IANA timezone |
   | `timing_mode` | Omit | `exact_schedule` for an explicit time or cadence; otherwise `flexible_schedule` |
   | `projectId` | Registered project ID | Omit |
   | `executionEnvironment` | `local` | Omit |
   | Model | `model`: owner’s choice | Owner selects in UI; omit API field |
   | Effort | `reasoningEffort`: owner’s choice | Owner selects in UI; omit API field |
   | `status` | `ACTIVE` | Omit |
   | `notificationPolicy` | `failed_runs_only` | Omit |

5. **Set UI-only options.** Ask the owner to apply the UI settings specified in the table for the job’s execution location. Wait for confirmation.
6. **Verify registration.** Read local jobs with `automation_update` in view mode and their `automation.toml`; read cloud jobs with `automations.peek` using the returned job ID. Confirm the applicable settings above and local `auto_archive = true`; use the owner’s confirmation for UI-only settings not returned by the tool. Report any mismatch instead of claiming setup is complete.
7. **Report.** Give each job's identifier and schedule with timezone, and explain that it can be paused or removed in Scheduled. Registration does not prove execution works: inspect the first run for the tools, skills, and access required by its prompt before reporting it as verified working.

Local tasks require the app to be running and the computer awake.
