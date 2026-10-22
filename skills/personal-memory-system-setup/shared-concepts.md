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

The queue is `<memory-folder>/operations/queue.json`: a UTF-8 JSON object:

```json
{
  "discovered_through": "<UTC-timestamp>",
  "items": [
    {"label": "<conversation-label>"}
  ]
}
```

`discovered_through` is the start time of the last successful discovery run, recorded as an ISO 8601 UTC timestamp.

Each item's `label` follows the [Conversation Label](#conversation-label) definition. Each label appears at most once and represents pending ingestion of the conversation’s latest available content. Items are ordered by when they were added, oldest first. An empty `items` array means no pending ingestion.

## Commit Changes

Stage only the files changed by this run and commit them with a message describing the operation. Skip the commit if nothing changed.

## Acquire Lock

```sh
memory_git_status=$(git -C "<memory-folder>" status --porcelain=v1 --untracked-files=all) && [ -z "$memory_git_status" ] && mkdir "<memory-folder>/.lock" 2>/dev/null && echo true || echo false
```

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
