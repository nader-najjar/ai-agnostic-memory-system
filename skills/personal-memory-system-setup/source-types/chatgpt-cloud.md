# chatgpt-cloud

## Identifier

`chatgpt-cloud`

## Display Name

ChatGPT & Codex (cloud)

## Description

Best-effort full-conversation JSONL snapshots of regular ChatGPT, ChatGPT Work cloud, and Codex cloud conversations.

## Limitations

The active thread list may have no pagination, so older active conversations can be missed. Work cloud may expose separate ChatGPT and Codex IDs for the same conversation; keep both unless the tools identify them as the same item. Regular ChatGPT may return placeholders or omit assistant text even when `truncated` is false. Work cloud and Codex cloud may omit tool-result bodies even when outputs are requested. Treat exports as best-effort, not complete transcripts. Preserve returned placeholders and truncation markers; never infer or fill missing content.

