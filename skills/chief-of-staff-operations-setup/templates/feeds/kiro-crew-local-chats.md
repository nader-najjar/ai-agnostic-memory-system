# Kiro Crew Local Chats

## Type

`kiro-crew-local-chat`.

## Item

One chat: one `dashboard_chat-*.jsonl` file, all of it. Its Identity is the file name without `.jsonl`.

## Where

`<home>/.kiro/crew/sessions/dashboard_chat-*.jsonl`.

## New

Each line of a chat's file is one JSON record, and the first is the chat's metadata. A chat has updates since a time when a record after that first line has a `ts` later than that time. Its new part is those records.

## Private

Skip a chat whose metadata line has a `memory_mode` of `incognito` or `temporary`, at its top level or under `execution_context`. Also skip a chat with no message the owner typed, outside the turns `Ignore` names.

## Ignore

- Everything the type's Ignore names.
- This system's own turns: every owner message that calls any `$chief-of-staff-` skill anywhere in it, through the next owner message.
- Tool calls and tool output. Links count only when they appear in the owner's messages or the assistant's replies.
- Raw kiro-cli sessions: never list a file under `<home>/.kiro/sessions/cli/` as a source, even when a chat names or links one. Kiro Crew drives kiro-cli for every chat, so those sessions repeat chats this feed already covers, wrapped in Kiro Crew's own prompts.
