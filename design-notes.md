# Design Notes

These are working thoughts and open questions, not settled requirements. The original notes are preserved below.

final instruction for use blurb. TO "INGEST" A NON CHAT SOURCE (ie make your ai learn it permanently) all you need to do is open a chat and give it that information. same exact way you would a human. once chat reads it and learns it plus says what it learned, that will automatically be saved and digested by virtue of this system. no hacky per source types. from end user perspective, treat ai as competent human. if ever give something trust it will remember it. at worst, we may need a specific skill for telling a chat "hey deep extract everything about this source, form connections, etc and lay everything out in chat in great detail so that cos can effectively ingest this info later without itself going to source" - but nothing more than that

now, with what we are doing, i do NOT think the policy should be to ignore tool call results and similar. if chat fetches code repo, just like how it sees it, the guardian should see it. so that it has full context. same with a slack message, same with a notion document, same with anything else. that way no context is lost or ignored. we can add ignore policies for specific things ONLY if they surface as an issue. This as a whole makes capturing sources other than chats a lot less important - they become proxy-captured by the chat as long as it reads it

need some kind of always.md mechanism still. is old one good or should it be simpler and better
* this is another core benefit of cos system. an always on rules file. i have been trying to get this to work for over a year and cos was the only impl that worked
* one failure mode ive seen a lot we need to resolve - after compaction, lots of always rules get ignored fully. one solution is keeping them as short as possible. another is an always rule that says how to preserve them post compaction. what are others

further - a general operating flow ive seen is you cannot allow an llm to do any large step. code, doc writing, whatever - if you allow it to one-shot a large piece or the entire thing, you get thrown into hell basically, and there is no way to correct what was made without extreme effort and effectively redoing the entire thing yourself. However, if you force it to only do bite sized chunks at every step of the way (one paragraph, one method, etc), then you do minor course corrections at every step and never allow it to get to hell in the first place. NEED TO FIND A WAY TO FORMALIZE THIS AND MAYBE ENFORCE IT

use cases
* making ai not useless. in general if when i open a new chat it is completely ephemeral, that is near useless. every single chat i do should make ai more and more useful the same way a teammate would become more and more useful as get experience
    * if each time you open a chat and have to waste 30 mins re-explaining project context or related background details / concepts about what you do, that is a waste of time and you could have done the task quicker yourself
* performance review mgr and leadership asks for what you did quantify and qualify. hard to do from scratch even if have all sources. easy for llm to crawl breadcrumbs
* SOP following (repeated procedures) - oncall leadership reporting weekly: teach it one time then it knows forever. Jira/asana updates: tell it expected leadership formats and it knows forever. production deployment SOP checks. etc
* job helping - regardless of role, code doc writing BA querying etc, it will always be much better if it has understanding of job vs not. For example will make less mistakes in code, know ahead of time things that can happen or should be checked, write more meaningful paragraphs in documents that need less rewriting and correcting, etc
* back and forth idea or brainstorm bouncing - lots of work is not actually producing an artifact but coming up with approach and thinking thru things. if it already knows full domain, it is much more effective
* personal - what use cases?


for anything and everything want to add to this in the future - must strictly justify from a concrete use case why it would be needed and why it cannot be done in current


tell ai to never update readmes or similar english documents unless there is explicit purpose. documents just get bloated with useless words

No owners note concept. For the end user perspective it should be as if this system doesn’t exist at all. Just like a person if I tell it something it better remember it. If need an “owners note” just open your ai and tell it something. It will remember
As of now only user interaction is recall and health check notif

Index md useful, giving each page some structure could still be useful but not prematurely

Do need always rules but what is best way to minimally enforce it? Maybe instead of built in there, just simply a pointer to one permanent agent instructions notion file that then links to what agent must read in full? Again work backwards from absolute minimum needed

What is simplest way to do backup mechanism

Simplest way to do locking? Tell it to call a script file that does synchronized{} block on a resource and returns either true or false? If false llm stops?

Each chat type needs capture way (json) , uuid, version for duplicate later ingrestion, and timestamp of capture. No sidecar, all in file name

Having structure of parent facet is good. Front matter is good. Not sure about rest of sections but yes do need superceded (nothing deleted ever) and web links. Maybe let the rest of page be Freeform, telling it to organize it well with headers and all. Anchors really good yes. May not need predefined file types like project etc, can let it freeform

No need for guardian policy until a need truly arises. At start simply just tell what to do

In general if anything needs to be referenced by >1 thing do not violate DRY, put its definition in a global file
