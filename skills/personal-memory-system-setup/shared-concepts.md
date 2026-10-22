# Shared Concepts

## Memory Configuration

The memory folder’s configuration is `<memory-folder>/config.json`:

```json
{
  "sources": [
    {
      "identifier": "<source-type-identifier>",
      "paths": ["<approved-absolute-source-path>"]
    }
  ]
}
```

Each selected source has one entry with its source type identifier and a nonempty array of approved absolute paths.

## Source Type Definitions

Source type definitions are the Markdown files in `<memory-folder>/operations/shared/source-types/`. Match each configured source's `identifier` to a definition's **Identifier** section to locate its definition.

## Conversation Label

A conversation’s label is `<source-type>:<UID>`, where `<source-type>` is the value from the source definition’s **Identifier** section and `<UID>` is obtained according to that definition’s **UID** section.

## Queue

The queue is `<memory-folder>/operations/queue.jsonl`: a UTF-8 JSON Lines file with one entry per line:

```json
{"label": "<conversation-label>", "path": "<absolute-source-file-path>"}
```

`label` follows the [Conversation Label](#conversation-label) definition. `path` is the source item’s current absolute file path. Each label appears at most once and represents pending ingestion of the conversation’s latest available content. Entries are ordered by when they were added, oldest first. An empty queue file means no pending ingestion.

## Acquire Lock

```sh
mkdir "<memory-folder>/.lock" 2>/dev/null && echo true || echo false
```

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
