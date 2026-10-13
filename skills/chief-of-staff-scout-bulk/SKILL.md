---
name: chief-of-staff-scout-bulk
description: Manually invoked. Scout one of the owner's feeds over a named past span, such as a backfill, into that feed's own bulk inbox, kept apart from the daily chief-of-staff-scout. Never writes the memory and never ingests.
triggers: chief-of-staff scout bulk, cos scout bulk, scout backfill
---

# Chief-of-Staff Scout Bulk

Use this skill only when the owner explicitly invokes it, naming a feed and a span `from <time> to <time>` in ISO 8601 UTC. If either is missing or the span is not two ISO 8601 UTC times with the first before the second, stop with: `Name a feed and a span: $chief-of-staff-scout-bulk <feed> from <time> to <time>.`

Follow the `chief-of-staff-scout` skill, installed beside this one, exactly, with these differences:

- `<state>` is `~/Desktop/chief-of-staff-operations/scout-bulk/<feed>/`, holding only `inbox.md` and `.lock`. One backfill, run in as many spans as needed, builds this one inbox, which the owner reviews on its own.
- The span is the one named, not one read from `last-run.md`.
- An item's new part counts only records at or before the span's end.
- Skip the `scheduled` check, and never read or write `last-run.md`.
