# Remote Code

- What It Is: a git repository hosted on a remote, by its hosting URL or a local clone of it, at a commit that exists on its `origin` remote, with no uncommitted changes. Local code with no remote is not this type.
- Capture: these files:

  | File | Holds |
  |---|---|
  | `reference.md` | a Markdown reference in exactly the form below, holding nothing else |
  | `repository.bundle` | the commit and its whole history, so the code outlives the remote: from a temporary clone in the system temp directory, `git clone <clone_url> <dir> && git -C <dir> checkout <commit> && git -C <dir> bundle create <capture folder>/repository.bundle HEAD` |

  ```markdown
  # <repository> at <first 12 characters of the commit>

  clone_url: <the origin remote's clone URL, exactly as git shows it>
  commit: <the full 40-character commit SHA>
  browse_url: <a web URL pinned to that commit, or none>
  ```

  The guardian reads the code from a temporary clone of the bundle in the system temp directory, left for the system to clean up: `git clone <capture folder>/repository.bundle <dir>`, whose `HEAD` must be the commit. It reads every file `git ls-files` lists at that commit, except those under Ignore, and the full `git log` up to the commit.
- Original Location: the hosting URL or local clone path given.
- Identity: the host and repository path of the `origin` remote, such as `github.com/<owner>/<repo>`.
- Version: the full commit SHA.
- Ignore: binary files and dependency lockfiles.
- Author: each commit's author name and email. A commit whose author matches an `owner` identity is the owner's.
- Anchor: `<file path>:<line>` at the commit, or `commit:<SHA>` for a commit message.
- Updated At: the commit's time.
- Dir: `code`.
