# Backup

The repository being backed up, either the Chief-of-Staff memory root or the operations repository, is the only source of truth for its contents, and it is a local git repository. A backup script packs the repository's committed history into a single git bundle file inside a folder that a cloud storage client syncs. Uncommitted edits are never backed up. That cloud copy is a backup only: nothing reads from it or writes to it except the backup script.

The setup works with any cloud client that syncs a local folder, such as OneDrive or iCloud Drive. The only storage-specific value is the backup folder: a folder inside the client's synced folder on this machine.

## 1. Cloud storage

1. Sign in to the cloud client.
2. Find the client's synced folder on this machine.
3. Choose a backup folder inside it, such as `chief-of-staff-backup`.

## 2. Backup script

`backup-mechanism/backup.sh` takes the repository and the backup folder as arguments:

```bash
backup-mechanism/backup.sh [--notify] <repository> <backup-folder>
```

It bundles every committed branch and tag with `git bundle create --all` into a local temporary folder and checks it with `git bundle verify`. The bundle is named `<name>.bundle`, where `<name>` is the repository's folder name. Each repository gets its own bundle, so several repositories can use one backup folder. If the bundle already holds the same refs at the same commits, it exits without writing, so the cloud client uploads nothing. Otherwise it copies the new bundle into the backup folder under a temporary name and moves it over the old one. A failed run exits non-zero and leaves the previous bundle in place. With `--notify`, a failure also shows a macOS notification. It makes no commits and no network calls, and writes only inside the backup folder.

There is one bundle, not timestamped copies: each bundle holds the full committed history. If local history is ever damaged, the cloud client's own file version history holds earlier bundles.

To check a bundle, clone it and compare it with the repository:

```bash
git clone <backup-folder>/<name>.bundle <scratch-folder>/check
git -C <scratch-folder>/check rev-parse HEAD
git -C <repository> rev-parse HEAD
```

Both commands must print the same commit.

## 3. Schedule

`backup-mechanism/install.sh` sets up a macOS launchd job that runs `backup.sh --notify` hourly and once at login:

```bash
backup-mechanism/install.sh <repository> <backup-folder>
```

It writes `~/Library/LaunchAgents/com.<name>.backup.plist`, reloads the job, waits for the first run, and exits non-zero if that run fails. Each repository gets its own job, so installing one never replaces another's. Running it again for the same repository replaces its job, so use it after moving either folder. The job does not depend on any AI tool running.

Output and errors go to `~/Library/Logs/<name>-backup.log`. The log stays outside the repository because it describes one machine's job, not the repository, and would otherwise be committed with it.

To check the job:

```bash
launchctl print gui/$(id -u)/com.<name>.backup | grep -E 'state|last exit code'
```

To remove it, which leaves the bundle and the log in place:

```bash
backup-mechanism/uninstall.sh <repository>
```
