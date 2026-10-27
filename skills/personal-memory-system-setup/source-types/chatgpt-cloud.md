# chatgpt-cloud

## Identifier

`chatgpt-cloud`

## Display Name

ChatGPT and Codex (cloud)

## Description

Best-effort full-conversation JSONL snapshots of regular ChatGPT, ChatGPT Work cloud, and Codex cloud conversations.

## Default Source Locations

```json
[{"type": "folder", "path": "<chatgpt-cloud-source-folder>"}]
```

Placeholder only. Replace it with an approved absolute local folder path before configuring this source. Folder population is handled separately from discovery.

## Source Items

Immutable `.jsonl` snapshots under any configured folder, including subdirectories, one new local file for each exported conversation version. Each snapshot contains the full available conversation and keeps its original conversation UID in its metadata.

## UID

The original conversation UID (`<kind>-<id>`) from the snapshot’s metadata record.

## Capture

Save the complete source JSONL file unchanged, byte for byte.

## Limitations

The active thread list may have no pagination, so older active conversations can be missed. Work cloud may expose separate ChatGPT and Codex IDs for the same conversation; keep both unless the tools identify them as the same item. Regular ChatGPT may return placeholders or omit assistant text even when `truncated` is false. Work cloud and Codex cloud may omit tool-result bodies even when outputs are requested. Treat exports as best-effort, not complete transcripts. Preserve returned placeholders and truncation markers; never infer or fill missing content.

