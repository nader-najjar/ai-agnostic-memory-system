---
name: personal-memory-system-memorize
description: Memorize the oldest queued conversation using its latest captured contents.
---
# Personal Memory System Memorize

Never modify `<memory-folder>/always.md`; it is owner-managed.

1. The input to this skill is the path to the personal memory folder. This is what `<memory-folder>` refers to in this skill. If missing from input, stop here. Read and follow the `Evidence and Instructions` section of `<memory-folder>/operations/shared/shared-concepts.md`.
2. Read the `Acquire Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` and follow its acquisition instructions. If it returns `false`, the lock is unavailable, in which case you must stop here.
3. Read the queue using the `Queue` section of `<memory-folder>/operations/shared/shared-concepts.md`. If its `items` array is empty, report that no conversations are queued, release the lock, and stop.
4. Select the oldest entry in `items` as `<selected-item>`.
5. Locate the item's file:
    1. Read the memory configuration using the `Memory Configuration` section of `<memory-folder>/operations/shared/shared-concepts.md`. Use the `Conversation Label` section of that file to identify the source type identifier for `<selected-item>`, and load its definition using the `Source Type Definitions` section.
    2. Search the selected source’s configured `paths` for files matching its definition’s **Source Items** criteria. Construct each candidate’s label using the `Conversation Label` section of `<memory-folder>/operations/shared/shared-concepts.md`, and stop searching when it matches `<selected-item>`’s label. If no source item matches, report an error with the selected label, release the lock, and stop with the queue unchanged.
6. Prepare the capture:
    1. Create `<memory-folder>/captures/` if needed. Capture the matching source file to a unique temporary file there using its source definition’s **Capture** section.
    2. Record the capture’s UTC timestamp and compute the SHA-256 hash of its complete uncompressed bytes.
    3. The final filename is `<label>--<capture-time>--<sha256>.jsonl`: the selected label, UTC timestamp in `YYYYMMDDTHHmmssffffffZ` format, and full lowercase hexadecimal content hash. Do not yet rename the file.
7. Find the most recent existing capture for the selected label, ordered by the timestamp in its filename. Call it `<previous-capture>`.
8. Handle the version:
    - **`<previous-capture>` does not exist:** Rename the temporary file to its final filename.
    - **Unchanged hash between `<previous-capture>` and the temporary file:** Reuse `<previous-capture>` and remove the temporary file.
    - **Changed hash between `<previous-capture>` and the temporary file:** Rename the temporary file to its final filename and compare both captures in full.
9. For a first or changed version, read the `Memory Extraction` and `Memory Pages` sections of `<memory-folder>/operations/shared/shared-concepts.md` and follow them to memorize the new capture. Create `<memory-folder>/memory/` if needed. For a changed version, only the delta between old and new is what is being memorized; the full file however can be used to understand context of words in this delta. Skip extraction when the hash is unchanged.
10. After successful extraction, or when the hash is unchanged, remove `<selected-item>` from the queue’s `items` array.
11. Follow the `Commit Changes` section of `<memory-folder>/operations/shared/shared-concepts.md`, committing the queue change together with this run’s capture and memory changes.
12. Report the completed entry’s label, the capture file’s absolute path, whether this is a first, changed, or unchanged version, and the memory pages created or updated. If no memory changes were needed, report that instead.
13. Release the acquired lock using the `Release Lock` section of `<memory-folder>/operations/shared/shared-concepts.md` before finishing or stopping.
