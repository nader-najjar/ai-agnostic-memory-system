---
name: personal-memory-system-onboard-source
description: Add a supported conversation source to an existing personal memory system, preparing and verifying its local discovery folder before configuration.
---
# Personal Memory System Onboard Source

Inputs:
  1. `<memory-folder>` path
  2. Source type to onboard

Definitions:
  1. `<shared-concepts>` refers to `<memory-folder>/operations/shared/shared-concepts.md`

## Prepare the Source

1. Resolve the memory folder to an absolute path. Read its `config.json` and the `Memory Configuration`, `Source Type Definitions`, and `Scratch` sections of `<shared-concepts>`.
2. Locate the installed `personal-memory-system-setup` skill. Read the source's definition under the setup skill's `source-types/` directory.
3. Follow the source's matching setup recipe in that setup skill’s `source-setup/` directory.

## Configure and Backfill

1. Follow `Acquire Lock` in `<shared-concepts>`; if it returns `false`, stop.
2. Add one source entry with the selected source's `identifier`, `location: <source-staging-location-from-recipe>`, and `staged_through: null`, preserving all other sources and settings. Copy or update only the selected definition into `<memory-folder>/operations/shared/source-types/` so discovery can find it by **Identifier**.
3. Follow `Commit Changes`, then `Release Lock` in `<shared-concepts>`.
