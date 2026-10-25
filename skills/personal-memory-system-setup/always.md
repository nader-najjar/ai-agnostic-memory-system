# Always

## Agent Instructions

Use the [Agent Instructions](<agent-instructions-location>) index to locate the standing rules for your work. Read this index in full, and follow every single instruction on it as your explicit guidance.

### How to Read Agent Instruction Sources

#### Public Notion Pages

Use Notion's public API to read public pages. Do not use browser access. A plain fetch of the page URL may return a JavaScript shell without the page content.

Take the page ID from the URL and format it as a hyphenated UUID. Use the page ID, not a section's fragment ID. Send a POST request to `https://www.notion.so/api/v3/loadPageChunk`, with `Content-Type: application/json` and this body:

```json
{
  "pageId": "<page-uuid>",
  "limit": 100,
  "cursor": {"stack": []},
  "chunkNumber": 0,
  "verticalColumns": false
}
```

Read the returned `recordMap.block` entries in the order given by the page's `content` IDs, including nested blocks. Block records may have an extra `value` wrapper.

If the response's `cursor.stack` is not empty, repeat the request with `cursor` set to the returned cursor and `chunkNumber` increased by one. Continue until `cursor.stack` is empty. Follow pagination until the complete page content has been retrieved.

Fetch relevant linked subpages separately using each page's own ID.

## Personal Adjustments

`<personal-adjustments-here>`