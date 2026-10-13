# Claude Code Local Chat

- What It Is: a Claude Code session's transcript, the file `~/.claude/projects/<project folder>/<session id>.jsonl`, confirmed as the intended session by a distinctive recent owner message. Not the files in that session's `<session id>/` folder, which hold its subagents' transcripts and saved tool output.
- Capture: a byte-for-byte copy of the file.
- Original Location: the file's absolute path.
- Identity: the `sessionId`, the file's name without `.jsonl`.
- Version: the file's SHA-256.
- Ignore: every record whose `type` is not `user` or `assistant`, such as `attachment`, `system`, `mode`, `ai-title`, `file-history-snapshot` and `queue-operation`; records with `isSidechain` true; `user` records with `isMeta` or `isCompactSummary` true, and `tool_result` parts; `user` text that Claude Code generated: `<system-reminder>`, `<task-notification>`, `<local-command-caveat>`, `<local-command-stdout>`, `<bash-stdout>` and `<bash-stderr>` blocks and `[Request interrupted by user]`; and `thinking` and `tool_use` parts of `assistant` records.
- Author: `user` records whose `origin.kind` is `human` are what the owner typed; in records without `origin`, from older Claude Code versions, a `user` record's text that Ignore does not drop. Within them, `<command-name>` and `<bash-input>` blocks are commands the owner ran, not statements, and `image` parts are attachments, not words. Pasted or quoted text is not the owner's unless the owner says they wrote it. Every other record is not the owner's.
- Anchor: the line number in the file.
- Updated At: the latest `timestamp` of any record.
- Dir: `chats`.
