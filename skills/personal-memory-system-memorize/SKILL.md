---
name: personal-memory-system-memorize
description: Capture the latest contents of the oldest queued conversation.
---
# Personal Memory System Memorize

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the queue using the `Queue` section of `<memory-folder>/operations/shared/shared-concepts.md`. If its `items` array is empty, report that no conversations are queued, release the lock, and stop.
4. Select the oldest entry in `items` as `<selected-item>`.
5. Locate the item's file:
    1. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`. Use the `Conversation Label` section of that file to identify the source type identifier for `<selected-item>`, and load its definition using the `Source Type Definitions` section.
    2. Search the selected source’s configured `paths` for files matching its definition’s **Source Items** criteria. Construct each candidate’s label using the `Conversation Label` section of `<memory-folder>/operations/shared/shared-concepts.md`, and stop searching when it matches `<selected-item>`’s label. If no source item matches, report an error with the selected label, release the lock, and stop with the queue unchanged.
6. Capture the matching source file using its source definition’s **Capture** section. Create `<memory-folder>/captures/` if needed and write the capture to a unique temporary file there. Compute the SHA-256 hash of the captured file’s complete uncompressed bytes, then rename it to `<label>--<capture-time>--<sha256>.jsonl`, where `<label>` is `<selected-item>`’s label, `<capture-time>` is the capture’s UTC timestamp in `YYYYMMDDTHHmmssffffffZ` format, and `<sha256>` is the full lowercase hexadecimal hash, used as the content version.
7. Follow the `Commit Changes` section of `<memory-folder>/operations/shared/shared-concepts.md`.
8. Report the selected entry’s label and the capture file’s absolute path.
9. Release the acquired lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` before finishing or stopping.
