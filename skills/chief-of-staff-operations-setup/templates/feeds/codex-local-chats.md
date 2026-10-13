# Codex Local Chats

## Type

`codex-local-chat`.

## Item

One thread: one rollout file, all of it. Its Identity is the thread ID.

## Where

`<codex home>/sessions/<yyyy>/<mm>/<dd>/rollout-*.jsonl` and `rollout-*.jsonl.zst`, one file per thread, where `<codex home>` is `$CODEX_HOME` when set, else `<home>/.codex`. Search every date folder, since a resumed thread keeps appending to the file in the folder of the day it started. Read a `.zst` file with `zstd -dc`. When both forms of one name exist, read the `.jsonl`. Skip a thread whose first line's `session_meta` payload has a `source` of `subagent` or `internal`, or a `thread_source` that is present and other than `user`. Not `<codex home>/archived_sessions/`, which holds threads the owner archived.

## New

A thread has updates since a time when a line has a `timestamp` later than that time. Its new part is those lines.

## Private

None: Codex does not save ephemeral threads at all. Still skip a thread with no message the owner typed, outside the turns `Ignore` names.

## Ignore

- Everything the type's Ignore names.
- This system's own turns: every owner message that calls any `$chief-of-staff-` skill anywhere in it, through the next owner message.
- Tool calls and tool output. Links count only when they appear in the owner's messages or the assistant's replies.
