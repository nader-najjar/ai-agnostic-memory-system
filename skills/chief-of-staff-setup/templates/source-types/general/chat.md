# Chat

- What It Is: the transcript file the AI tool itself saved, confirmed as the intended session by a distinctive recent owner message; never a reconstruction.
- Capture: a byte-for-byte copy.
- Original Location: the transcript file's absolute path.
- Identity: the session ID the tool assigned.
- Version: the file's SHA-256.
- Ignore: context the tool inserted that no one said in this conversation: system and developer prompts, injected memory, rules, instruction files, skills and environment details, replays of earlier messages, and hidden reasoning.
- Author: the messages the owner typed in this conversation. Tell them apart by the tool's own labels first, such as role, type and metadata fields, and by content second; a user role alone is not enough. Pasted or quoted text is not the owner's unless the owner says they wrote it. When unsure, a message is not the owner's.
- Anchor: the line number in the transcript file.
- Updated At: the file's modification time.
- Dir: `chats`.
