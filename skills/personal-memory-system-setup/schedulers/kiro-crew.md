# Kiro Crew Scheduling

Create separate scheduled jobs, each with a fresh session.

## Inputs

- `memory_folder`: absolute path to the personal memory folder.
- `jobs`: for each job, its name, complete prompt, schedule, IANA timezone, model, and reasoning effort.

Ask the owner for any missing model choices, offering Kiro Crew's configured model as the default.

## Procedure

1. **Resolve the schedules.** Convert each approved schedule to a five-field cron expression.
2. **Create the jobs.** Run the following shell command for each supplied job, replacing the placeholders with its inputs. Quote each value as a single literal shell argument, preserving the prompt's `$` skill invocation and any quoted paths.

   ```sh
   kirocrew cron add '<name>' '<prompt>' --cron '<cron-expression>' --timezone '<timezone>' --model '<model>' --silent --hide-in-chat --no-persistent-session --no-minimal-context --timeout-secs 3600
   ```

   Use the CLI rather than the `cron_add` tool so the job is not owned by the setup chat. `--no-persistent-session` starts each run with fresh context; `--no-minimal-context` keeps skills available. `--silent` suppresses automatic result delivery and failure alerts, and `--hide-in-chat` keeps scheduled jobs out of the chat list. Each run has a one-hour timeout.
3. **Verify registration.** Record each returned job ID and run `kirocrew cron list` to confirm all supplied jobs and their schedules. If a creation command fails, report its error and which jobs were successfully created.
4. **Set reasoning effort.** Ask the owner to set each created job’s approved reasoning effort manually in Kiro Crew. List the job names and chosen effort levels, and wait for confirmation.
5. **Report.** Give each job's ID and schedule with timezone. Jobs can be managed in the dashboard's Schedule page or removed with `kirocrew cron remove <job-id>`. Registration does not prove execution works: inspect the first run for skill availability and required filesystem access before reporting it as verified working.
