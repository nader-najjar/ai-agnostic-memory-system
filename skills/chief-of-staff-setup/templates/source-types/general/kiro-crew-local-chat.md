# Kiro Crew Local Chat

- What It Is: a Kiro Crew dashboard chat's transcript, the file `~/.kiro/crew/sessions/dashboard_chat-<number>-<epoch>.jsonl`, confirmed as the intended chat by a distinctive recent owner message. Not Kiro Crew's cron, subagent or app sessions in that folder, and not the kiro-cli sessions Kiro Crew drives for its chats.
- Capture: a byte-for-byte copy of the file.
- Original Location: the file's absolute path.
- Identity: the file name without `.jsonl`, such as `dashboard_chat-66-1791513392`.
- Version: the file's SHA-256.
- Ignore: the first line, which is the chat's metadata, and every record whose `role` is not `user` or `assistant`, such as `tool`, `inject`, `nudge`, `system`, `subagent`, `notice`, `error`, `file` and `mcp_oauth`: tool calls and output, host notices and text the host or other agents injected.
- Author: records whose `role` is `user` and `source_user` is `dashboard` are what the owner sent, except text listed in the record's `meta.pastes`, which the owner pasted, and `[attached_file <n>] <path>` lines and `![image](<path>)` references, which point to attachments rather than being the owner's words. Pasted or quoted text is not the owner's unless the owner says they wrote it. Every other record is not the owner's.
- Anchor: the line number in the file.
- Updated At: the latest `ts` of any record.
- Dir: `chats`.
