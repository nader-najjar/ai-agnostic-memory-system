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

## Memory Pages

Memory pages are Markdown files under `<memory-folder>/memory/`, organized by topic. Each page has YAML front matter with:

- `title`: the topic’s primary name.
- `aliases` (optional): a list of alternative names, abbreviations, or former names that should find this same topic during recall.
- `parent` (optional): the path of the memory page whose topic this page is a facet of, relative to `memory/`.

A facet is one aspect of a broader topic, split into its own page because it has enough detail to stand alone. For example, a project’s deployment page can have the project’s overview page as its parent. The parent describes the broader topic; the facet describes that particular aspect. Each facet has one parent, while a parent can have many facets. Omit `parent` for standalone topics. Parent relationships must not form cycles and do not require matching folder nesting. Other relationships belong in links in the body.

The body is freeform Markdown with descriptive headings.

Include useful web links and links to related memory pages or specific sections.

Support memorized information with relative links to its captured conversation and the relevant record identifiers or line numbers (call this an "anchor"). Preserve useful web links from the conversation.

IMPORTANT: Preserve previously memorized information. When information changes, place the previous information under a `## Superseded` heading, retaining its dates and supporting sources and identifying what replaced it. Make the current understanding clear. The journey should be easily understandable.

## Memory Extraction

Preserve enough understanding that the owner can leave any chat and start a fresh one without fearing the loss of valuable context or having to explain everything again.

Weigh each claim by what supports it: the owner’s statements or confirmations, original source material, tool results, or an AI assistant’s assertions. An assistant’s assertion alone does not establish a fact; it needs the owner’s confirmation or supporting evidence from the conversation. Keep unsupported assistant claims unconfirmed.

Preserve useful beliefs, preferences, intentions, and estimates as statements attributed to whoever expressed them. They need not be objectively proven to be worth remembering; retain their uncertainty rather than presenting them as established facts.

Read the complete captured conversation, including tool calls and results. Retain context that would help a future chat understand the owner’s personal and professional life, make decisions, continue effectively, or avoid rediscovery and repeated explanation: the owner’s goals, preferences and constraints, decisions and their reasons, useful rejected approaches and failed attempts, working knowledge, current state, unresolved questions, and next actions.

Update relevant existing memory pages before creating new ones, integrating new information without repeating what is already known. Distinguish confirmed outcomes from proposals, attempts, and unresolved claims; preserve meaningful dates and uncertainty. Organize by the subjects discussed rather than by chat, and create no page when the conversation adds no useful information. Omit chatter and process narration that add no useful context.

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
