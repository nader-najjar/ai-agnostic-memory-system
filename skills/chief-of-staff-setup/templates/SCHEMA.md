schema_version: 2
owner: [<alias>, <email>, <github-username>, <Full Name>]

# Chief-of-Staff Memory: Schema

A local, tool-agnostic knowledge base for the owner's whole life, including personal and professional context. It is the durable authority; any AI tool's built-in memory is a cache that loses on conflict. Everything is plain Markdown, found with normal file search.

## Layout

```text
SCHEMA.md     this file: the shared format
GUARDIAN.md   the only write policy
index.md      one line per wiki page
always.md     the pages every session reads before anything else
deferred.md   open deferred items
log.md        append-only ingestion outcomes
source-types/ one file per source type, in group folders
raw/          immutable captured evidence, one folder per source type's dir
wiki/         curated knowledge pages
backup-mechanism/  backup script and setup guide (BACKUP.md)
```

Files written under an earlier version of this schema, such as older raw captures and log entries, keep their original form and remain valid. Read them as written; everything new follows this schema. A sidecar with no `schema_version` is version 1, and its `origin` is its `original_location`.

During ingestion only the guardian writes, and only as `GUARDIAN.md` allows. Outside ingestion, only the owner, or a request made with the owner's explicit permission, may change anything here. Every other session is read-only. Missing subfolders are created when first needed.

## Source Types

Captures are the only part of this memory that is hard to replace. Building the library is the hard part: going back to every source and re-collecting it is a huge effort, if the source still exists at all. So `raw/` is a permanent library of immutable captures, and everything built from it is cheap to change. Sidecars, wiki pages, `index.md`, `always.md`, `deferred.md` and `log.md` can all be corrected or rebuilt later from `raw/`. A type's Capture must therefore be exact and complete from the start, saving every fact its other fields need. Every other field can change later, with old sidecars and pages updated to match.

Every type defines the same fields, and a new type must fill in all of them:

- **What It Is:** the input it accepts.
- **Capture:** the most faithful form of the whole source: the original itself, or a pin that retrieves it exactly, so any version can be re-read later. Never retyped, converted, reworded or summarized.
- **Original Location:** the sidecar's `original_location`: where this capture was taken from.
- **Identity:** the sidecar's `source_id`. It must be both unique, belonging to this source alone, and stable, staying the same across versions, so a later capture of the same source can be recognized. `none` means every input is a new source.
- **Version:** the sidecar's `version`. It changes exactly when the content changes. Versions of one source are ordered by `captured_at`. It is `none` exactly when Identity is `none`.
- **Ignore:** parts of the source that are not evidence and must never be learned from, or `none`.
- **Author:** which parts of the source are the owner's, directly or by an author identity to match against `owner`, or `none`.
- **Anchor:** how a citation points to a place inside the captured source, or `none`.
- **Updated At:** the sidecar's `source_updated_at`: the source's own timestamp for this version, ignoring any dates in its content.
- **Dir:** the capture's `raw/` folder.

An ingestion fails and saves nothing unless the source meets every field of its type. A field is `none` or `unknown` only where the type lists that value.

`owner` lists the owner's identities. A part of a source is the owner's when its type's Author makes it so, or when a paired note says so. Every other part is someone else's.

Each type is one file, `source-types/<group>/<name>.md`, named by the type's name in lowercase with spaces as hyphens, such as `remote-code.md`, and unique across all groups. It is titled with the type's name and fills in every field above.

Each group is a folder. A group's `README.md` says which types belong in it and holds rules that are part of every type in it, and is never a type file. A type goes in `general/` unless another group's `README.md` claims it.

## Raw Captures

Each capture is one folder, named by its stem, holding a metadata sidecar and its content files:

```text
raw/<dir>/<YYYY-MM-DDTHHMMSSZ>_<type>_<slug>/meta.md
raw/<dir>/<YYYY-MM-DDTHHMMSSZ>_<type>_<slug>/<content files>
```

- `dir` is the source type's Dir, and `type` is its type file's name without `.md`, such as `remote-code`. The timestamp is UTC capture time, and `slug` is a short lowercase hyphenated name.
- A capture with one content file names it `source.<ext>`, with `ext` following the type's Capture. A type whose Capture has several files names each one.
- Raw files are never edited, renamed or deleted. A newer version of the same source is a new capture.

Sidecar:

```yaml
schema_version: <this file's schema_version when captured>
source_type: <the type file's name without .md>
original_location: <the type's Original Location>
source_id: <the type's Identity>
version: <the type's Version>
captured_at: <the folder name's timestamp, in ISO 8601 UTC>
source_updated_at: <the type's Updated At>
note: <see Owner Notes>
```

## Owner Notes

An owner note is a `note` capture: the owner's own words, with a sidecar like any other capture. It is the one source type that can be paired with another source in the same ingestion, as `GUARDIAN.md` One Ingestion defines.

- A note's sidecar has `about` in place of `note`: the stem of the source paired with it, or `none`. Every other sidecar has `note`: the stem of the note paired with it, or `none`.
- Claims cite the capture they come from: the note's stem for the owner's words, the source's stem for the source.

## Wiki Pages

A page is `wiki/<slug>.md`, with one subject per page. Slugs are permanent; pages are never renamed or deleted. A subject that grows too large splits into children named `<parent>.<facet>.md`, for example `<slug>.architecture.md`. The parent links each child.

```markdown
---
title: <Subject>
aliases: [<other names>]
type: project | system | decision | principle | research | topic
status: active | settled | archived | merged
parent: <slug, or none>
merged_into: <slug, or none>
related: [<slug>, ...]
updated: <YYYY-MM-DD the guardian last changed this page>
---

# <Subject>

<Two or three sentences: what this is and why it matters.> [s:<raw stem>]

## Knowledge
- <Durable claim.> [s:<raw stem>]

## Current state
- (as of YYYY-MM-DD) <Point-in-time fact.> [s:<raw stem>]

## Decisions
- YYYY-MM-DD: <decision>, because <rationale>. [s:<raw stem>]

## Open
- <Unresolved question or disagreement, with what would resolve it.> [s:<raw stem>]

## Superseded
- YYYY-MM-DD: "<old claim>" was replaced by "<new claim>", because <reason>. [s:<old stem>] [s:<new stem>]

## Web Links
- [<title>](<url>): <what it is, in a few words>. [s:<raw stem>]
```

- `type`: `project` is bounded work toward a goal; `system` is anything ongoing that is run and maintained, technical or not, such as a service, a tool, an SOP or an app people work in; `decision`, `principle` and `research` are standalone topics of that kind; `topic` is anything else. No page is about a person: a fact about someone goes on the page of what it concerns. `status`: `active` is changing, `settled` is stable, `archived` is no longer relevant, and `merged` is folded into the page named by `merged_into`. A merged page's body is one line linking that page, and its index line says `merged into <slug>`.
- Every page type uses this one template. Omit empty sections, so each type naturally uses only the sections that apply.
- Every body claim, including the summary, cites at least one raw capture: `[s:<raw stem>#<anchor>]`, with the anchor its type's Anchor defines and several separated by commas, such as `#1842,1907`. The `#<anchor>` is omitted only when the type's Anchor is `none`. Frontmatter and index lines need no citation. Find a stem's files in `raw/*/<stem>/`.
- Web Links holds only `http` or `https` URLs to resources about the subject, each citing the capture it came from. Links to other wiki pages go in `related`.
- `aliases` lists every name for the subject found in any source or page: acronyms, code names, package names. Recall depends on it.
- Every date on a page is a UTC date, `YYYY-MM-DD`.
- The as-of date is the most precise date known: an explicit date stated for the claim, then message time, then the sidecar's `source_updated_at`, then capture time.
- Knowledge is never deleted. A changed conclusion moves to Superseded and must be removed from every other section, so only its replacement appears there.

## index.md

One line per page, sorted by slug:

```markdown
- [<Subject>](wiki/<slug>.md) | aliases: <other names> | <one-line summary>
```

## always.md

The owner's standing rules: one line per `principle` page that every session must read and follow, sorted by slug:

```markdown
- [<Subject>](wiki/<slug>.md) | governs: <when the rules apply>
```

- Listed pages are the owner's instructions, followed rather than weighed as evidence. They never contradict each other.

## deferred.md

One line per open deferred item, oldest first:

```markdown
- <item>: <why it was deferred, and what would resolve it> [s:<raw stem>]
```

- An item is added when an ingestion defers it, and removed when a later ingestion resolves it.
- The line cites the capture it came from, like a wiki claim.

## log.md

Each ingestion appends one entry, newest last. Use `none` for an empty field.

```markdown
## <captured_at> <source stem, or the note stem when there is no other source>
pages: created <slugs>; updated <slugs>
deferred:
- <item>: <why>
resolved:
- <item>, now <accepted | rejected>
rejected: <brief reasons>
```

The log records what each ingestion deferred and resolved; open items live in `deferred.md`.
