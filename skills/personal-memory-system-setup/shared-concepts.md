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

## Acquire Lock

```sh
mkdir "<memory-folder>/.lock" 2>/dev/null && echo true || echo false
```

## Release Lock

```sh
rmdir "<memory-folder>/.lock"
```
