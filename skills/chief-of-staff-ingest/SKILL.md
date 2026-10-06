---
name: chief-of-staff-ingest
description: Manually invoked. Ingest one source of a type the memory's source-types/ folder defines, an owner note, or both into the Chief-of-Staff memory at ~/Desktop/chief-of-staff through an isolated guardian subagent.
triggers: chief-of-staff ingest, ingest to chief of staff, cos ingest
---

# Chief-of-Staff Ingest

The Chief-of-Staff memory is a plain-Markdown knowledge base at `~/Desktop/chief-of-staff`. It is the authority over any AI tool's built-in memory. Only an isolated guardian subagent may write to it, following `GUARDIAN.md` in that folder.

Use this skill only when the owner explicitly invokes it.

## Hard Rule

This session never creates, edits, moves or deletes anything under `~/Desktop/chief-of-staff`, and it never summarizes, filters or characterizes the source for the guardian. Its only jobs are to find the source, start the guardian, and relay the result. If any step below cannot be met, stop and report why. Never fall back to writing yourself. The one exception is the cleanup in step 5, and only after the owner explicitly approves it.

## Steps

1. **Check the folder.** Expand `~` to an absolute path. Confirm `SCHEMA.md`, `GUARDIAN.md`, `index.md`, `always.md`, `deferred.md`, `log.md` and `source-types/` exist and that `SCHEMA.md` starts with `schema_version: 2`. If anything is missing, stop with: `Chief-of-Staff memory not found or invalid at <path>.` Do not create it. Then run `git status --porcelain` in the folder. If it prints anything, stop with: `Chief-of-Staff memory has uncommitted changes; commit or discard them before ingesting.` Otherwise record the current `HEAD` commit, read every file under `source-types/`, and read the One Ingestion section of `GUARDIAN.md`.

2. **Identify the inputs.** An invocation carries what `GUARDIAN.md` One Ingestion allows. If it has neither a source nor a note, ask the owner for one.
   - **Source:** optional, at most one, and it must meet a type in `source-types/`. If it does not, ask the owner for what is missing. If the invocation names more than one source, stop without ingesting any: `One source per invocation; invoke this skill once for each source.`
   - **Note:** optional. Include one only when the owner explicitly tells you to add a note, and use the owner's exact words, never your paraphrase or additions. An explicit request to add something to `always.md` is such a note. When the owner gives the note as a Markdown file, pass that file. When the note is too long to pass whole in your runtime's subagent prompt, write the owner's exact words to a new Markdown file in the system temp directory and pass that file; never shorten or split the note.

3. **Start one fresh subagent** using your runtime's own mechanism. It must not inherit this conversation, and it should inherit as little of the runtime's memory, lessons and project context as the runtime allows. It needs read access to the source, git access to check out code repositories, and write access to the folder. If your runtime cannot provide an isolated subagent with those capabilities, stop and say so. Give it a budget of at least 1000 tool calls, or the runtime's maximum if that is lower; never leave it on a smaller default. Give it exactly this prompt, filling in only `<root>` (the absolute folder path), `<source>` and `<note>`, and dropping the `Source:` or `Owner note:` line when that input is absent:

   ```text
   You are the Chief-of-Staff memory guardian. Memory root: <root>.
   Read <root>/SCHEMA.md and <root>/GUARDIAN.md first, then follow GUARDIAN.md exactly to ingest the following.
   Source: <source>
   Owner note: <note>
   ```

   Add nothing else: no context, intent, summary or emphasis. For a note in a file, replace the `Owner note:` line with `Owner note file: <absolute path of the file>`.

4. **Relay the result.** Report the guardian's result faithfully and completely.

5. **Check for an incomplete ingest.** The ingest is incomplete if `git status --porcelain` now prints anything, or if the guardian did not report a failure and `HEAD` has not moved past the commit recorded in step 1. When it is incomplete, tell the owner so, list every uncommitted file, and suggest discarding them by returning to the latest commit:

   ```text
   cd <root> && git restore --staged --worktree -- . && git clean -fd -- .
   ```

   State that this permanently deletes the uncommitted files and leaves committed work untouched. Run it only when the owner explicitly approves.
