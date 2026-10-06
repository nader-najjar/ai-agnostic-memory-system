# Notion

- What It Is: a manually downloaded Notion HTML export ZIP of one root page and all its descendant subpages, including database entry pages and their descendants. The owner supplies the root page URL and confirms these export options: HTML; Page content Everything; Include subpages on; Create folders for subpages on; Export comments on. Accept the original Notion-produced export, not an HTML document reconstructed by an agent. This type captures the exported document tree, comments and bundled files; external URLs remain references. It does not claim to preserve native revision history, every database view, or content Notion does not export.
- Capture: these files:

  | File | Holds |
  |---|---|
  | `source.zip` | a byte-for-byte copy of the supplied export ZIP, including every exported file |
  | `reference.md` | the reference below, recording the supplied archive path, root page URL, root page UUID and confirmed options |

  ```markdown
  # Notion

  archive_path: <absolute path of the supplied ZIP>
  page_url: <root page URL supplied by the owner>
  page_id: <lowercase hyphenated root page UUID>
  export_format: HTML
  page_content: Everything
  include_subpages: true
  create_folders_for_subpages: true
  export_comments: true
  ```

  The root HTML's page UUID must match the supplied page URL. The archive must be readable and contain that root HTML. All local page and asset links must resolve to files in the ZIP; external links need no download. Reject a corrupt archive, an identity mismatch, missing required export options or a missing locally referenced file. Do not infer that a link to an external page makes it a descendant.

  Read the original HTML pages, database CSVs, comment sections and bundled files from a temporary extraction in the system temp directory. Preserve the ZIP unchanged; extraction is a reading copy. Do not follow external links as additional source evidence. Unsupported attachment contents are retained in full; report any inability to read them rather than infer their contents. Extract safely: reject absolute paths, parent traversal, duplicate member paths and symlinks.
- Original Location: the root Notion page URL supplied by the owner. The local ZIP path is retained in `reference.md` as the location the capture was obtained from.
- Identity: `notion:<lowercase hyphenated root page UUID>`. The UUID is read from the supplied page URL and checked against the root HTML's article ID. Renaming the page or ZIP does not change identity.
- Version: `sha256:<digest>` of the exported file tree, computed as follows: exclude ZIP directory entries; sort file member paths by their UTF-8 bytes; for each file append its path byte length as an unsigned 8-byte big-endian integer, its UTF-8 path bytes, its uncompressed content byte length in the same integer format, and its uncompressed original content bytes; hash the concatenation with SHA-256. Include every file, including attachments and styles. Exclude the ZIP container's compression, member order and timestamps, and exclude `reference.md` and the metadata sidecar. This identifies exported content, not a native Notion revision: a change to exported HTML or file paths changes Version even if the visible page text is unchanged.
- Ignore: export-generated CSS, layout scaffolding and interface decoration as evidence of the owner's knowledge or preferences. Keep them in the capture and version. Document text, formatting that conveys meaning, links, properties, comment contents and bundled files are evidence.
- Author: an exported comment's explicit author display name, matched exactly against an `owner` identity. A display name alone does not establish an account identity. Page or attachment ownership is not inferred from the exporter, page location or comment authors. Without a paired owner note establishing authorship, page and attachment authorship is unknown. Quoted or explicitly attributed passages retain their stated attribution.
- Anchor: `<ZIP-relative file path>::id:<HTML element ID>` for an HTML element; `<ZIP-relative file path>::comment:<section>:<thread ordinal>:<comment ordinal>` for comments, with section `page`, `inline`, `resolved-page` or `resolved-inline` as explicitly labeled in the exported page, and ordinals counted from 1 in document order within that section and thread. If no element ID exists, use `<ZIP-relative file path>::line:<line number>` in the original UTF-8 file, counted from 1. CSVs use `<ZIP-relative file path>::record:<record number>` counted from 1, including the header; multiline quoted fields are one record. Binary attachments use `<ZIP-relative file path>::file` for the whole file. Paths and anchors address the immutable capture, not the live page. Do not invent native comment IDs or precise comment-to-block links absent from the export.
- Updated At: unknown. ZIP timestamps, local file modification times and comment dates do not establish a source update time for the whole exported tree. Keep comment dates as displayed; do not infer their timezone.
- Dir: `notion`.
