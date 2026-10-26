# ChatGPT Remote Recall

## Chat Surfaces

- Regular ChatGPT: desktop, mobile.
- ChatGPT Work: local on desktop; cloud on desktop, mobile.
- Codex: desktop local; cloud on desktop and mobile; desktop local CLI; desktop local IDE extension.
- Mobile remote access: connect to existing desktop Codex or Work sessions; execution stays on the desktop.
- Dots: desktop, mobile.

## Common Steps

1. Use the repository URL and configured recall skill supplied by setup.
2. Check whether the GitHub plugin is connected to the owner's ChatGPT account. If needed, guide the owner through connecting it and granting access to the private memory repository.
3. Verify that the GitHub integration can read a file in that repository.

## Explain How to Recall

Tell the owner they can invoke the recall skill in chats where it is available. For other chats, give them the link to `<github_repository>/blob/main/remote-recall.md` and this reusable prompt, replacing `<recall-file-url>` with the actual link:

> Follow the recall instructions at <recall-file-url> to recall <topics> from GitHub.
