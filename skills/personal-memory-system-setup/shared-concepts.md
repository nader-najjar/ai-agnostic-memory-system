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

A conversation’s label is `<source-type>:<UID>`, using its source type’s **Identifier** and its **UID**.

## Acquire Lock

```sh
mkdir "<memory-folder>/.lock" 2>/dev/null && echo true || echo false
```

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
