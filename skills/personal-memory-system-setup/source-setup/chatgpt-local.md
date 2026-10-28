# ChatGPT Local Source Setup

1. Confirm the source roots (usually `~/.codex/sessions` and `~/.codex/archived_sessions`), and memory folder with the owner. Tell the owner the initial copy includes all available matching history; date filtering is not supported yet. Resolve absolute paths and verify the sources exist and do not overlap the destinations.
2. Create `<memory-folder>/.source-dump/chatgpt-local/sessions/` and `archived_sessions/`.
3. Schedule the following commands every 60 seconds with the OS scheduler, substituting the approved paths. On macOS, create one LaunchAgent per command with the installed rsync executable and arguments in `ProgramArguments`, and `StartInterval` set to `60`.

```sh
rsync -rt --include='*/' --include='rollout-*.jsonl' --include='rollout-*.jsonl.zst' --exclude='*' -- '<sessions-root>/' '<memory-folder>/.source-dump/chatgpt-local/sessions/'
rsync -rt --include='*/' --include='rollout-*.jsonl' --include='rollout-*.jsonl.zst' --exclude='*' -- '<archived-root>/' '<memory-folder>/.source-dump/chatgpt-local/archived_sessions/'
```

4. Trigger both jobs and verify successful exits, copied filenames, and preserved modification times. Report the job IDs and interval. Use `<memory-folder>/.source-dump/chatgpt-local/` as the discovery location.

If a macOS scheduled job fails with `Operation not permitted` accessing Desktop, ask the owner to check **System Settings → Privacy & Security → Files & Folders** for the exact rsync executable used by that job. If it is absent, explain that **Full Disk Access** grants broader file access; the owner may choose to manually add that executable there (for example, `/usr/bin/rsync`, only if that is the job’s executable). After the owner approves and makes the change, retry the affected job through the scheduler and repeat the verification above.
