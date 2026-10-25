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
  ],
  "backup_file": null
}
```

Each selected source has one entry with its source type identifier and a nonempty array of approved absolute paths.

`backup_file` is the absolute path to `<backup-folder>/<memory-folder-name>.bundle`, where `<memory-folder-name>` is the memory folder’s final path component. Use `null` when the owner declines backup.

## Source Type Definitions

Source type definitions are the Markdown files in `<memory-folder>/operations/shared/source-types/`. Match each configured source's `identifier` to a definition's **Identifier** section to locate its definition.

## Queue

The queue is `<memory-folder>/operations/queue.json`: a UTF-8 JSON object:

```json
{
  "discovered_through": "<UTC-timestamp>",
  "items": [
    {"path": "<relative-capture-path>"}
  ]
}
```

`discovered_through` is the start time of the last successful discovery run, recorded as an ISO 8601 UTC timestamp.

Each item's `path` is relative to the memory folder and appears at most once. Items are ordered by when they were added, oldest first. An empty `items` array means no pending ingestion.

## Capture

The filename is `<source-type>:<UID>--<capture-time>--<sha256>.jsonl`, where `<source-type>` comes from the source definition’s **Identifier** section, `<UID>` follows its **UID** section, `<capture-time>` is the UTC capture time in `YYYYMMDDTHHmmssffffffZ` format, and `<sha256>` is the full lowercase hexadecimal SHA-256 hash of the capture’s complete uncompressed bytes. For the same conversation, equal hashes identify unchanged content; capture time does not determine whether the content changed.

## Memory Pages

Memory pages are Markdown files under `<memory-folder>/memory/`, organized by topic. Each page has YAML front matter with:

- `title`: the topic’s primary name.
- `aliases` (optional): a list of alternative names, abbreviations, or former names that should find this same topic during recall.
- `parent` (optional): the path of the memory page whose topic this page is a facet of, relative to `memory/`.

A facet covers one aspect of a broader topic, such as a project’s deployment. It has one parent page; a parent may have many facets. Standalone pages omit `parent`. The `parent` field defines the hierarchy independently of folder structure. Other relationships use links in the body.

The body is freeform Markdown with descriptive headings.

Citations are relative links to captured conversations, with record identifiers or line numbers as anchors.

`## Superseded` holds previous information, its dates and sources, and what replaced it.

## Commit Changes

Run `git add .` from `<memory-folder>` and commit with a message describing the operation. Skip the commit if nothing changed.

## Acquire Lock

The calling skill specifies whether the queue’s `items` array must be empty or nonempty.

1. Acquire the lock with `mkdir "<memory-folder>/.lock"`. If it fails, return `false`.
2. Run `git -C "<memory-folder>" status --porcelain=v1 --untracked-files=all`. If it fails or returns any output, release the lock and return `false`.
3. Read the [Queue](#queue). If it cannot be read or does not meet the calling skill’s requirement of empty or nonempty, release the lock and return `false`. Otherwise, return `true`.

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
