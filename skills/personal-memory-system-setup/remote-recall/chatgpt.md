# ChatGPT Remote Recall

## Chat Surfaces

- Regular ChatGPT: desktop, mobile.
- ChatGPT Work: desktop local, desktop cloud, mobile cloud.
- Codex: desktop local, desktop cloud, mobile cloud.
- Dots: desktop, mobile.

## Common Steps

1. Use the repository URL and configured recall skill supplied by setup.
2. Check whether the GitHub plugin is connected to the owner's ChatGPT account. If needed, guide the owner through connecting it and granting access to the private memory repository.
3. Verify that the GitHub integration can read a file in that repository.

## Explain How to Recall

Tell the owner they can invoke the recall skill in chats where it is available. For other chats, explain that they must give that chat the following prompt:

> Follow the recall instructions at <URL to github_repository>/blob/main/remote-recall.md> to recall <topics> from GitHub.
