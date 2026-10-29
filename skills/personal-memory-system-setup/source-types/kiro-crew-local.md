# kiro-crew-local

## Identifier

`kiro-crew-local`

## Display Name

Kiro Crew (local)

## Description

Conversations from the Kiro Crew dashboard.

## Source Items

`kiro-crew-local--<UID>.jsonl` files directly under any configured folder. Each file holds the latest staged full conversation; the source exporter handles exclusions and replaces the file atomically when the conversation changes.

## UID

The filename without its `kiro-crew-local--` prefix and `.jsonl` suffix. This preserves the original Kiro session identifier.

## Capture

An uncompressed `.jsonl` file containing the complete original source item, byte for byte.
