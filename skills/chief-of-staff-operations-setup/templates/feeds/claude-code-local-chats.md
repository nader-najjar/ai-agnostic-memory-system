# Claude Code Local Chats

## Type

`claude-code-local-chat`.

## Item

One session: one `<session id>.jsonl` file, all of it. Its Identity is the session ID.

## Where

`<home>/.claude/projects/<project folder>/<session id>.jsonl`, one file per session, directly in a project folder. Not the files inside a `<session id>/` folder, which hold subagent transcripts and saved tool output.

## New

A session has updates since a time when a `user` or `assistant` record has a `timestamp` later than that time. Its new part is those records.

## Private

None: Claude Code has no private sessions. Still skip a session with no message the owner typed, outside the turns `Ignore` names.

## Ignore

- Everything the type's Ignore names.
- This system's own turns: every owner message that calls any `/chief-of-staff-` or `$chief-of-staff-` skill anywhere in it, through the next owner message.
- Tool calls and tool output. Links count only when they appear in the owner's messages or the assistant's replies.
