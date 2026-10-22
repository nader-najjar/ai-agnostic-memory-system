# claude-code-local

## Identifier

`claude-code-local`

## Display Name

Claude Code (local)

## Description

Local conversations from Claude Code in the terminal, IDE extensions, or the Claude desktop app’s Code tab. Cowork, Cloud, and SSH sessions are outside this source type.

## Default Source Locations

```json
["~/.claude/projects"]
```

If Claude Code uses `CLAUDE_CONFIG_DIR`, its `projects/` directory replaces the default location.

## Source Items

`.jsonl` conversation files directly inside project folders under any configured path. The filename is the conversation’s session UUID followed by `.jsonl`.

Exclude:

- Subagent transcripts in `subagents/` folders.
- Orphaned or superseded transcript copies.

## UID

The session UUID in the source filename, without `.jsonl`.

## Capture

An uncompressed `.jsonl` file containing the complete original source item, byte for byte.
