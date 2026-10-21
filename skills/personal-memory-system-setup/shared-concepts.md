# Shared Concepts

## Memory Configuration

The memory folder’s configuration is `<memory-folder>/config.json`:

```json
{
  "sources": [
    {
      "identifier": "<source-type-identifier>",
      "path": "<approved-absolute-source-path>"
    }
  ]
}
```

Each selected source has one entry with its source type identifier and approved absolute path.

## Source Type Definitions

Source type definitions are the Markdown files in `<memory-folder>/operations/shared/source-types/`. Match each configured source's `identifier` to a definition's **Identifier** section to locate its definition.

## Acquire Lock

```sh
mkdir "<memory-folder>/.lock" 2>/dev/null && echo true || echo false
```

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
