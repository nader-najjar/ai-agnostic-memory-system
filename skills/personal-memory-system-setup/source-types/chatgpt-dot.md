# chatgpt-dot

## Identifier

`chatgpt-dot`

## Display Name

ChatGPT Dot

## Description

Immutable JSONL chunks exported by dot from its ChatGPT room and stored in approved local folders. This source is Dot-specific; it does not list ordinary ChatGPT cloud conversations.

## Default Source Locations

```json
[{"type": "folder", "path": "<chatgpt-dot-source-folder>"}]
```

Placeholder only. Replace it with an approved absolute local folder path before configuring this source. Folder population is handled separately from discovery.

## Source Items

Immutable `.jsonl` chunks under any configured folder, including subdirectories, one file per export chunk.

## UID

The source filename without `.jsonl`.

## Capture

Save the complete source JSONL file unchanged, byte for byte. Do not capture snippets, summarize content, or include routine/configuration files.

