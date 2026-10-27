# Kiro Crew Local Source Setup

1. Confirm the source folder (usually `~/.kiro/crew/sessions`), and memory folder with the owner. Resolve absolute paths and verify the source exists and does not overlap the destination.
2. Create `<memory-folder>/.source-dump/kiro-crew-local/`.
3. Schedule the following command every 60 seconds with the OS scheduler, substituting the approved paths. On macOS, create a LaunchAgent with the installed rsync executable and arguments in `ProgramArguments`, and `StartInterval` set to `60`.

```sh
rsync -rt --exclude='*/' --include='dashboard_chat-*.jsonl' --exclude='*' -- '<source-folder>/' '<memory-folder>/.source-dump/kiro-crew-local/'
```

4. Trigger the job and verify a successful exit, copied filenames, and preserved modification times. Report the job ID and interval. Use `<memory-folder>/.source-dump/kiro-crew-local/` as the discovery location.
