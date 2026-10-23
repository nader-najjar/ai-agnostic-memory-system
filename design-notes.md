# Design Notes

## meta

use cases
* making ai not useless. in general if when i open a new chat it is completely ephemeral, that is near useless. every single chat i do should make ai more and more useful the same way a teammate would become more and more useful as get experience
    * if each time you open a chat and have to waste 30 mins re-explaining project context or related background details / concepts about what you do, that is a waste of time and you could have done the task quicker yourself
    * you shouldnt be "scared" of closing a chat because it is deep in your current workflow and dont want to lose that progress. chats should be able to be treated as extremely ephemeral, without fear of losing valuable context buildup
    * 3rd reason - when a session gets anything beyond short, the llm becomes delusional and quality severely degrades. it makes extremely clear mistakes, and holds on to very specific words from long before in the conversation, when it makes no sense to, and there is no way to remove that attention weighting. It is really frustrating and the difference is extremely clear if you just open a new fresh chat with no polluted context - the quality jump is huge. To be clear compacting does not help. All this to say that you need the ability to rapidly and frequently switch to a new ephemeral chat without losing any context
* performance review leadership asks for what you did quantify and qualify. hard to do from scratch even if have all sources. easy for llm to crawl breadcrumbs
* SOP following (repeated procedures) - oncall leadership reporting weekly: teach it one time then it knows forever. Jira/asana updates: tell it expected leadership formats and it knows forever. production deployment SOP checks. etc
* job helping - regardless of role, code doc writing BA querying etc, it will always be much better if it has understanding of job vs not. For example will make less mistakes in code, know ahead of time things that can happen or should be checked, write more meaningful paragraphs in documents that need less rewriting and correcting, etc
* back and forth idea or brainstorm bouncing - lots of work is not actually producing an artifact but coming up with approach and thinking thru things. if it already knows full domain, it is much more effective
* personal - what use cases?


Very first thing is make a mermaid diagram of flow bare min
* source items
* One single queue
* Memory folder
* Something to periodically put new items in queue
* Something to periodically ingest single item from queue into memory folder
* Removal from queue once ingested - should this be a 3rd schedule? Or the ingestor takes 2 roles? What is most robust for queue correctness and non duplication
* Locking (global across entire folder top level) - so only 1 git root
* Backup
* Recall skill

## core

DONE Add Claude Code source type.

now, with what we are doing, i do NOT think the policy should be to ignore tool call results and similar. if chat fetches code repo, just like how it sees it, the guardian should see it. so that it has full context. same with a slack message, same with a notion document, same with anything else. that way no context is lost or ignored. we can add ignore policies for specific things ONLY if they surface as an issue. This as a whole makes capturing sources other than chats a lot less important - they become proxy-captured by the chat as long as it reads it

need some kind of always.md mechanism still. is old one good or should it be simpler and better
* this is another core benefit of cos system. an always on rules file. i have been trying to get this to work for over a year and cos was the only impl that worked

DONE further - a general operating flow ive seen is you cannot allow an llm to do any large step. code, doc writing, whatever - if you allow it to one-shot a large piece or the entire thing, you get thrown into hell basically, and there is no way to correct what was made without extreme effort and effectively redoing the entire thing yourself. However, if you force it to only do bite sized chunks at every step of the way (one paragraph, one method, etc), then you do minor course corrections at every step and never allow it to get to hell in the first place. NEED TO FIND A WAY TO FORMALIZE THIS AND MAYBE ENFORCE IT

tell ai to never update readmes or similar english documents unless there is explicit purpose. documents just get bloated with useless words

DONE No owners note concept. For the end user perspective it should be as if this system doesn’t exist at all. Just like a person if I tell it something it better remember it. If need an “owners note” just open your ai and tell it something. It will remember

As of now only user interaction is recall and health check notif

DONE Maybe best is for the ingest to guarantee certain preconditions, execute, and guarantee postconditions. And one of the preconditions is that one item in the queue is marked with ~, and that was the previously ingested item. If previous was successful, the new run marks it as done, then marks the next item with ~ and ingests. Surrounding all of this is a lock that ensures only one parallel execution

Index md useful, giving each page some structure could still be useful but not prematurely

Do need always rules but what is best way to minimally enforce it? Maybe instead of built in there, just simply a pointer to one permanent agent instructions notion file that then links to what agent must read in full? Again work backwards from absolute minimum needed

What is simplest way to do backup mechanism

DONE Simplest way to do locking? Tell it to call a script file that does synchronized{} block on a resource and returns either true or false? If false llm stops?

DONE Each chat type needs capture way (json) , uuid, version for duplicate later ingrestion, and timestamp of capture. No sidecar, all in file name

Having structure of parent facet is good. Front matter is good. Not sure about rest of sections but yes do need superceded (nothing deleted ever) and web links. Maybe let the rest of page be Freeform, telling it to organize it well with headers and all. Anchors really good yes. May not need predefined file types like project etc, can let it freeform

DONE In general if anything needs to be referenced by >1 thing do not violate DRY, put its definition in a global file

Maybe need to enforce some kind of recording of current state for projects. That is always useful bc the final superseded page will have a full history log of all states. But may not need to explicitly tell LLM, it may do this on its own

DONE At a bare minimum I do think it is good idea to enforce an event driven architecture rather than having no order. We have a definition of a unit of work so is natural to queue for robustness and ease of reasoning

DONE scout may not need agentic. may just fetch files edited based on timestamp

What is best option for the “something” that periodically does stuff? script? ai tool cron?

Need policy for what good quality memory means

## stretch:

Add Claude Cowork local-chat source type.

one failure mode ive seen a lot we need to resolve - after compaction, lots of always rules get ignored fully. one solution is keeping them as short as possible. another is an always rule that says how to preserve them post compaction. what are others

final instruction for use blurb. TO "INGEST" A NON CHAT SOURCE (ie make your ai learn it permanently) all you need to do is open a chat and give it that information. same exact way you would a human. once chat reads it and learns it plus says what it learned, that will automatically be saved and digested by virtue of this system. no hacky per source types. from end user perspective, treat ai as competent human. if ever give something trust it will remember it. at worst, we may need a specific skill for telling a chat "hey deep extract everything about this source, form connections, etc and lay everything out in chat in great detail so that cos can effectively ingest this info later without itself going to source" - but nothing more than that

for anything and everything want to add to this in the future - must strictly justify from a concrete use case why it would be needed and why it cannot be done in current


## AI-made — status as of 2026-10-23

### To do

1. Historical backfill.
2. **Improve memory freshness:** Discover every 5 minutes; memorize every 5 minutes, offset by 2 minutes. Keep one conversation per fresh memorize run and the shared lock. Target processing starting within roughly 7 minutes when there is no backlog and the computer and scheduler are running. This is a target, not a guaranteed SLA; long runs and backlog increase delay. Reassess the need for manual ingestion after trying this cadence.

### Done

- Setup ends with a short usage guide covering recall, ordinary chats, external sources, and standing instructions.
- Private Kiro Crew chat exclusions.
- Automatic interrupted-run recovery, wired into setup and scheduling.
- Evidence-versus-instructions rules.
- Durable captures and memory-reference rules.
- Dated-information handling in recall.

### Skipped

- One-hop related-page expansion during recall.
- Deep-reading skill for external sources.
- Owner identity configuration.
- Separate memory-precedence policy.
- Backup restoration and scheduler removal instructions.
- Additional third-party privacy rules.

### Stretch

- Determine how to set Kiro Crew reasoning effort.
- Claude Cowork support.
- Restoring standing instructions after compaction.
- Separate health analysis and notifications.
- Skip unchanged backups.
- Memory index, if needed.

E2E testing is final validation when implementation is done, not a feature-list item.
