# chatgpt-local

## Identifier

`chatgpt-local`

## Display Name

ChatGPT (local)

## Description

Local conversations from ChatGPT Work, Codex desktop, or Codex CLI. Cloud-based ChatGPT conversations are outside this tool definition.

## Default Source Locations

```json
["~/.codex/sessions", "~/.codex/archived_sessions"]
```

## Source Items

`rollout-*.jsonl` and `rollout-*.jsonl.zst` files under any configured path, including subdirectories, with a `session_meta` record. A file counts as a source item unless its `session_meta` record has either:

- A `payload.source` object containing `subagent` or `internal`.
- A `payload.thread_source` of `guardian_review`, `subagent`, `memory_consolidation`, `automation`, or `onboarding_checklist`.

## UID

The `payload.id` of the `session_meta` record.

## Capture

An uncompressed `.jsonl` file containing the complete source item:

- For a `.jsonl` source item, its original bytes.
- For a `.jsonl.zst` source item, its bytes after lossless Zstandard decompression.
