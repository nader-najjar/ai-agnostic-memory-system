# Backup

The memory root is the only source of truth for Chief-of-Staff memory, and it is a local git repository. A backup script packs the repository's committed history into a single git bundle file inside a folder that a cloud storage client syncs. Uncommitted edits are never backed up. That cloud copy is a backup only: nothing reads from it or writes to it except the backup script.

The setup works with any cloud client that syncs a local folder, such as OneDrive or iCloud Drive. The only storage-specific value is the backup folder: a folder inside the client's synced folder on this machine.

## 1. Cloud storage

1. Sign in to the cloud client.
2. Find the client's synced folder on this machine.
3. Choose a backup folder inside it, such as `chief-of-staff-backup`.

## 2. Backup script

`backup-mechanism/backup.sh` takes the memory root and the backup folder as arguments:

```bash
backup-mechanism/backup.sh [--notify] <memory-root> <backup-folder>
```

It bundles every committed branch and tag with `git bundle create --all` into a local temporary folder and checks it with `git bundle verify`. If `chief-of-staff.bundle` already holds the same refs at the same commits, it exits without writing, so the cloud client uploads nothing. Otherwise it copies the new bundle into the backup folder under a temporary name and moves it over `chief-of-staff.bundle`. A failed run exits non-zero and leaves the previous bundle in place. With `--notify`, a failure also shows a macOS notification. It makes no commits and no network calls, and writes only inside the backup folder.

There is one bundle, not timestamped copies: each bundle holds the full committed history. If local history is ever damaged, the cloud client's own file version history holds earlier bundles.

To check a bundle, clone it and compare it with the memory root:

```bash
git clone <backup-folder>/chief-of-staff.bundle <scratch-folder>/check
git -C <scratch-folder>/check rev-parse HEAD
git -C <memory-root> rev-parse HEAD
```

Both commands must print the same commit.

## 3. Schedule

`backup-mechanism/install.sh` sets up a macOS launchd job that runs `backup.sh --notify` hourly and once at login:

```bash
backup-mechanism/install.sh <memory-root> <backup-folder>
```

It writes `~/Library/LaunchAgents/com.chief-of-staff.backup.plist`, reloads the job, waits for the first run, and exits non-zero if that run fails. Running it again replaces the job, so use it after moving either folder. The job does not depend on any AI tool running.

Output and errors go to `~/Library/Logs/chief-of-staff-backup.log`. The log stays outside the memory root because it describes one machine's job, not the memory, and would otherwise be committed with every ingest.

To check the job:

```bash
launchctl print gui/$(id -u)/com.chief-of-staff.backup | grep -E 'state|last exit code'
```

To remove it, which leaves the bundle and the log in place:

```bash
backup-mechanism/uninstall.sh
```
