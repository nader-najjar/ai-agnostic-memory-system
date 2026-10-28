# Kiro Crew Local Source Setup

1. Confirm the source folder (usually `~/.kiro/crew/sessions`), and memory folder with the owner. Tell the owner the initial copy includes all available matching history; date filtering is not supported yet. Resolve absolute paths and verify the source exists and does not overlap the destination.
2. Create `<memory-folder>/.source-dump/kiro-crew-local/`.
3. Schedule the following command every 60 seconds with the OS scheduler, substituting the approved paths. On macOS, create a LaunchAgent with the installed rsync executable and arguments in `ProgramArguments`, and `StartInterval` set to `60`.

```sh
rsync -rt --exclude='*/' --include='dashboard_chat-*.jsonl' --exclude='*' -- '<source-folder>/' '<memory-folder>/.source-dump/kiro-crew-local/'
```

4. Trigger the job and verify a successful exit, copied filenames, and preserved modification times. Report the job ID and interval. Use `<memory-folder>/.source-dump/kiro-crew-local/` as the discovery location.

If a macOS scheduled job fails with `Operation not permitted` accessing Desktop, ask the owner to check **System Settings → Privacy & Security → Files & Folders** for the exact rsync executable used by that job. If it is absent, explain that **Full Disk Access** grants broader file access; the owner may choose to manually add that executable there (for example, `/usr/bin/rsync`, only if that is the job’s executable). After the owner approves and makes the change, retry the affected job through the scheduler and repeat the verification above.
