# kiro-crew-local

## Identifier

`kiro-crew-local`

## Display Name

Kiro Crew (local)

## Description

Conversations from the Kiro Crew dashboard.

## Default Source Locations

```json
[{"type": "folder", "path": "~/.kiro/crew/sessions"}]
```

## Source Items

`dashboard_chat-*.jsonl` files directly under any configured folder.

Exclude chats whose first record (metadata) has `memory_mode` set to `incognito` or `temporary`, either at the top level or under `execution_context`.

## Discovery

Search each configured folder for files matching **Source Items**.

## Source Modification Time

The source file’s filesystem modification time.

## UID

The session identifier between `dashboard_chat-` and `.jsonl` in the source filename.

## Capture

An uncompressed `.jsonl` file containing the complete original source item, byte for byte.
