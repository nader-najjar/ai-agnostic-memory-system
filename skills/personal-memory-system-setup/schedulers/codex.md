# Codex Scheduling

Create standalone local jobs in ChatGPT/Codex.

## Inputs

- `memory_folder`: absolute path to the personal memory folder
- Job name
- Prompt
- Schedule
- Timezone
- Model
- Reasoning effort

## Procedure

1. **Register the automation project.** Explain to the user that automations will clutter their chat list unless they are isolated to a dedicated project. Use `list_projects` to find a dedicated project named `Personal Memory ChatGPT Automations` with no root folders. If missing, ask the owner to create it without a folder, wait for confirmation, and list projects again. Use its project ID for the supplied local jobs.
2. **Configure local access.** Read `$CODEX_HOME/config.toml`, or `~/.codex/config.toml` when `CODEX_HOME` is unset. If needed, ask permission to set `sandbox_mode = "workspace-write"` and merge `<memory_folder>` and `<memory_folder>/.git` into `sandbox_workspace_write.writable_roots`. Show the exact proposed changes and explain that they apply to new Codex sessions generally. If permission is declined, stop and report which jobs remain unscheduled.
3. **Resolve the schedules.** Use the owner’s known timezone. Use an RRULE and the desktop scheduler’s timezone.
4. **Create the job.** Use `automation_update` with these fields. Rows marked UI are app settings, not additional API arguments.

   | Field | Value |
   | --- | --- |
   | `mode` | `create` |
   | `kind` | `cron` |
   | `name` | Supplied job name |
   | `prompt` | Supplied complete prompt |
   | `rrule` | Resolved RRULE |
   | `projectId` | Registered project ID |
   | `executionEnvironment` | `local` |
   | `model` | model |
   | `reasoningEffort` | effort |
   | `status` | `ACTIVE` |
   | `notificationPolicy` | `failed_runs_only` |
   | Run on this computer | On; set by default by the MCP used |
   | Start each run in new chat | On; set by default with `kind: cron` |
   | Archive successful runs | Owner enables in UI |

5. **Set UI-only options.** Ask the owner to apply the UI settings specified in the table. Wait for confirmation.
