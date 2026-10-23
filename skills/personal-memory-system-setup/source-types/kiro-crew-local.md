# kiro-crew-local

## Identifier

`kiro-crew-local`

## Display Name

Kiro Crew (local)

## Description

Conversations from the Kiro Crew dashboard.

## Default Source Locations

```json
["~/.kiro/crew/sessions"]
```

## Source Items

`dashboard_chat-*.jsonl` files directly under any configured path.

Exclude chats whose first record (metadata) has `memory_mode` set to `incognito` or `temporary`, either at the top level or under `execution_context`.

## UID

The session identifier between `dashboard_chat-` and `.jsonl` in the source filename.

## Capture

An uncompressed `.jsonl` file containing the complete original source item, byte for byte.
