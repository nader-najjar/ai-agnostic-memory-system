# Shared Concepts

This system turns AI conversations into durable, source-backed memory. Setup configures sources, standing instructions, schedules, and optional backups. Discovery saves conversation snapshots and queues them; backfill supplies older conversations; memorization processes snapshots into topic pages; recall loads those pages and checks system health. Captures preserve the evidence. A shared lock coordinates writers, Git preserves committed state, troubleshooting recovers abandoned runs, and backups preserve the repository outside the memory folder.

## Memory Configuration

The memory folder’s configuration is `<memory-folder>/config.json`:

```json
{
  "sources": [
    {
      "identifier": "<source-type-identifier>",
      "locations": [{"type": "folder", "path": "<approved-absolute-source-path>"}]
    }
  ],
  "backup_file": null,
  "github_repository": null
}
```

Each selected source has one entry with its source type identifier and a nonempty `locations` array. A folder location has `type: "folder"` and an absolute `path`. An MCP location has `type: "mcp"`, a `tool` name, and optional `arguments`. The source definition explains how to discover and capture items from those locations.

`backup_file` is the absolute path to `<backup-folder>/<memory-folder-name>.bundle`, where `<memory-folder-name>` is the memory folder’s final path component. Use `null` when the owner declines backup.

`github_repository` is the private GitHub repository URL used for publishing only committed `memory/`, `always.md`, and `remote-recall.md` with separate history, or `null` when publishing is disabled. This is the authoritative destination; setup configures `origin` in the separate `.tmp/github-publish` checkout from it. The main memory repository has no publishing remote; captures, operational files, and the full local Git history remain in the local repository and its backup.

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

`discovered_through` is the timestamp through which the last successful discovery scan searched, inclusive, recorded as an ISO 8601 UTC timestamp.

Each item's `path` is relative to the memory folder and appears at most once. Items are ordered by when they were added, oldest first. An empty `items` array means no pending ingestion.

## Backfill

The backfill worklist is `<memory-folder>/operations/backfill.json`: a UTF-8 JSON object:

```json
{
  "items": [
    {"path": "<relative-capture-path>"}
  ]
}
```

Items follow the same format as the queue and identify saved snapshots awaiting admission to it. Paths are relative to the memory folder and appear at most once. Items are processed in list order. An empty `items` array means no pending backfill.

## Capture

The filename is `<source-type>--<UID>--<source-modified-time>--<sha256>.jsonl`, where `<source-type>` comes from the source definition’s **Identifier** section, `<UID>` follows its **UID** section, `<source-modified-time>` follows its **Source Modification Time** section, observed when selecting the item, expressed in UTC in `YYYYMMDDTHHmmssffffffZ` format, and `<sha256>` is the full lowercase hexadecimal SHA-256 hash of the capture’s complete uncompressed bytes. For the same conversation, equal hashes identify unchanged content; modification time does not determine whether the content changed.

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

1. Acquire the lock with `mkdir "<memory-folder>/.lock"`. If it fails, return `false`.
2. Run `git -C "<memory-folder>" status --porcelain=v1 --untracked-files=all`. If it fails or returns any output, release the lock and return `false`.
3. Return `true`.

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
