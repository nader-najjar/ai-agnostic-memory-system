# Design Notes

## user stories

* making ai not useless. in general if when i open a new chat it is completely ephemeral, that is near useless. every single chat i do should make ai more and more useful the same way a teammate would become more and more useful as get experience

* if each time you open a chat and have to waste 30 mins re-explaining project context or related background details / concepts about what you do, that is a waste of time and you could have done the task quicker yourself

* you shouldnt be "scared" of closing a chat because it is deep in your current workflow and dont want to lose that progress. chats should be able to be treated as extremely ephemeral, without fear of losing valuable context buildup

* when a session gets anything beyond short, the llm becomes delusional and quality severely degrades. it makes extremely clear mistakes, and holds on to very specific words from long before in the conversation, when it makes no sense to, and there is no way to remove that attention weighting. It is really frustrating and the difference is extremely clear if you just open a new fresh chat with no polluted context - the quality jump is huge. To be clear compacting does not help. All this to say that you need the ability to rapidly and frequently switch to a new ephemeral chat without losing any context

* SOP following (repeated procedures) - oncall leadership reporting weekly: teach it one time then it knows forever. Jira/asana updates: tell it expected leadership formats and it knows forever. production deployment SOP checks. etc

* regardless of role, code doc writing BA querying etc, it will always be much better if it has understanding of job vs not. For example will make less mistakes in code, know ahead of time things that can happen or should be checked, write more meaningful paragraphs in documents that need less rewriting and correcting, etc

* back and forth idea or brainstorm bouncing - lots of work is not actually producing an artifact but coming up with approach and thinking thru things. if it already knows full domain, it is much more effective




* it should remember what matters across my personal and professional life — preferences, goals, constraints, decisions and why, things tried, current state, open questions, and next actions



* useful things i tell the ai should become available in other chats within a reasonably short time


* i should be able to keep chatting or return to an old chat without confusing the memory system; later useful changes should get learned too


* i should be able to teach it naturally by talking to it, without thinking at all about how it is working behind the scenes. for example if i learn something, i should just be able to pop open a chat and say "hey fyi XYZ btw" and then it knows it forever just like i do

* if i give a chat a document, website, or other material and it reads it, the useful understanding should be remembered too


* if i correct something or change my mind, it should know the current understanding without losing the previous context and reasoning + why that old was wrong


* it should obviously know what is ai trash vs what is real; if ai says something in conversation it should be able to use non-polluted judgement to objectively record whats happening the same way my brain does

* auditability of memory claims (citations)

* retaining of the original memory sources

* needs some kind of mechanism for always-on rules, and this has to be robust and DRY

* chats marked private shouldnt be remembered

* it should auto-troubleshoot itself and fix any system issues by itself. i should not have to know it exists

* this isnt just some informal random memory ephemeral system - it should be agnostic of ai tool, and it should be formalized by being backed up to a cloud drive like icloud so that you truly have a permanent memory system following you for life that can always help you regardless of how the ai tools themselves evolve

* it should be as token efficient as possible. audit ALL mechanisms to make sure it properly balances freshness with as little flux of LLM as possible


## p0

made it to discover chats from previous discovery time to current time, and queue them in md file. discover locks so only one at a time. queue items labeled as source-type:uid. memorize takes first item from queue and searches for that matching item in file system. once finds it it copies it to captures and extracts anything useful. if previous version of same chat exists it only evaluates diff but still uses whole chat for context on what was being talked about. when done it removes that item from queue. memorize also locks so only one at a time, and shares the same lock as discover. both skills wrapped in lock, and inside that, wrapped with git commit boundary. currently backs up to a cloud folder periodically. theres also an auto-troubleshooter that runs periodically that looks for a stale lock or dirty git. if that is the case and there are no running jobs (or a stalled job doing nothing), then rather than letting that break the system until human intervention, it goes in and fixes the state back to last successful state. then the system resumes as usual. should be pretty robust

now the issue is that these jobs are scheduled to run once every hour or so. that is not enough - think of if there are like 10 chats to ingest. it should happen a bit quicker. also, in the current state, the second a chat has a message, it is in the window of what discover can find. that means an ongoing usual chat will be discovered every single run, and will be repeatedly memorized, wasting tokens and llm flux. ideally we ignore chats until they have been inactive for a set period. to do these things, we will need to make states and state transitions + edge cases easier to reason about and optimize early exits of the skills. that is p1

## p1

the first thing is the most important - p0 had a pretty big issue in that the event driven stuff isnt immutable. the chats queued can change a ton from discover to ingest and thinking about all possible behaviors is really hard. to make it easier:

1. **Capture the eligible version during discovery and queue that snapshot.** Memorize should process that exact immutable capture. Later source updates can qualify separately. This will require queue labels containing versions as well
   * why technically: a label pointing to a live source can resolve to different contents by the time memorize runs, including messages that never satisfied the inactivity window. A fixed capture makes the queued work, retries, and state transitions easier to reason about. Save the capture and its queue entry together.
   * user need: returning to a chat shouldn’t disrupt learning what was already discussed, and later useful changes should still get learned. We accept processing an older eligible version even if newer messages exist.

as a prereq to just optimize skills and make it all easier to reason about atomicity:

2. **Short-circuit based on queue status.** Acquire the shared lock first; if unavailable, stop. Check Git cleanliness while holding the lock; if dirty or the check fails, release and stop. Read the queue once: discover requires empty, memorize requires nonempty. If unreadable or ineligible, release and stop; otherwise do the work and release. No queue precheck, waiting, or additional coordination state. likely easiest way to do this is define a single shared concept section that has instructions to take lock, after that check git, and after check queue, and what to do in each case?
   * why technically: repeated discovery scans can hold the lock whenever memorize tries to run, even though work is already waiting. Discovery has no need to refill a nonempty queue; yielding gives the queued batch priority. Checking Git and queue under the lock avoids making the decision on state another writer is changing.
   * user need: pending learning should make progress without babysitting. Newly eligible chats wait for the current batch to drain; a repeatedly failing oldest item can hold that up.

then with that we can do the first issue and actually reason about how it will work in all cases - not wasting llm flux. in other words, you can guarantee that any given chat is not ingested more than once every N hours:

3. **Wait for inactivity before discovering a chat.** Scan file modification times from the previous successful scan’s end time up to, but not including, run-start minus N hours. N is still to be chosen. Advance `discovered_through` to that cutoff only after a successful scan.
   * why technically: scanning up to now can repeatedly queue an active conversation and spend tokens processing intermediate versions. Assuming messages update the file’s modification time, ongoing chats stay ahead of the window and quiet chats eventually enter it.
   * user need: don’t waste tokens repeatedly processing an ongoing conversation. This trades some freshness for lower cost; it measures inactivity, not confirmed completion, and a continuously active chat can keep being deferred.

at this point we have better reliability and reasoning guarantees but still no fix to big backlogs. now finally:

4. **Accelerate ingestion and stagger the jobs.** Discover hourly at :00; memorize at :15, :30, and :45. Keep one conversation per fresh memorize run. Troubleshoot hourly at :55 to avoid starting alongside memorize. Update setup to recommend this cadence after the coordination above is implemented.
   * why technically: the old two-hour memorize interval processes at most twelve conversations a day, so normal usage can build a days-long backlog. This allows three memorize starts per hour while hourly discovery reduces wakeups for chats already waiting through the inactivity window. The tradeoff is slower discovery and retry after a missed discovery turn; memorize attempts are fifteen, fifteen, then thirty minutes apart. Staggering reduces deliberate overlap but does not guarantee fairness or prevent long runs from overlapping.
   * user need: balance reasonably fresh memory with fewer unnecessary AI wakeups. Target starting processing within roughly seventy-five minutes after eligibility when there is no backlog, discovery is quick, and the computer and scheduler are running; inactivity waiting, long runs, and backlog add delay. This is a target, not a guaranteed SLA. Reassess manual ingestion after trying it.

### state transition thinking

basically trace what actually happens before saying this works. this is reasoning thru the instructions, not an end to end test

* setup at 12 sets discovered_through to 10. discovery at 1 has cutoff 11, so searches modifications after 10 thru 11 inclusive. after success the timestamp is 11. next scan starts after 11 so no overlap
* chat stays quiet: last edit at 12, discover at 1 ignores it, discover at 2 can capture it. snapshot + queue entry + timestamp committed together
* chat keeps changing: last edit keeps moving ahead of cutoff, so it waits. once quiet for 2 hours it can enter the window
* chat resumes after capture: queued snapshot doesnt change. later edits can qualify for another snapshot once quiet again
* queue already has stuff: discover stops without moving timestamp. memorize takes oldest snapshot. once queue drains, discovery scans from where it left off so the waiting time doesnt create a gap
* memorize first version: move snapshot to captures, learn full thing, remove queue entry, commit together. changed version: same but learn delta with full context. same hash: delete pending snapshot, remove queue entry, commit, no memory rewrite
* nothing qualifies: still move timestamp to cutoff and commit. otherwise we keep scanning the same empty time range
* lock already held: stop without touching anything. dirty git or unreadable queue after taking lock: release and stop. wrong queue state: same
* interrupted before commit: recovery returns to last committed state. failed discovery loses its pending snapshots and retries from old timestamp. failed memorize gets its queued snapshot back and retries. interrupted after commit but before unlock: recovery keeps committed work and clears stale lock
* timing caveat we accepted: chat can change between checking its modification time and copying it. saved snapshot can include newer messages. 2 hours is the eligibility filter, not a promise every message captured is 2 hours old
* assumes new messages advance source modification time and clock moves normally. existing memories using the old timestamp meaning need thought when upgrading; setup change only handles new ones

## p2

backfill capability - when first setting this up there is already a ton of useful stuff in old chats. should be able to say go back thru this source for this time range and learn it, using the same snapshot + memorize flow. shouldnt need to mess with the normal discovery timestamp or manually feed it every old chat. figure out simplest way to do that without old backlog taking over all the new stuff

one failure mode ive seen a lot - after compaction, lots of always rules get ignored fully. idea: initially read full instructions, but also have a small table of contents router in persistent instructions saying what section applies to what kind of work. whenever convo enters that domain / phase (code, review, formal pr, merge, cleanup etc), reread the actual section unless already read in current uncompacted context. summary saying it was read doesnt count. dont need to reread every msg or keep a second condensed copy of all the rules in sync

DONE human health updates on how the system is doing - make this part of recall itself. every time i recall it should do a quick read only health check. if all good say nothing, if something is broken or stuck tell me. no extra skill or thing i have to remember to run. troubleshoot still handles fixes


### p3

there are 2 aspects - where the worker runs, and where recall is available to end user. if was working at open ai, would be simple, just queue all chats (cloud, local, codex, work, anything), in sqs, lambda runs memorize, put mem in s3, integrate the s3 with the chatgpt desktop app associated to user. then no hacky git, local troubleshooting or local machine dependency, etc. but we are external so we have to do some hacky things.

we can accept that the worker jobs will always be dependent on local computer. you COULD put it on aws, but that is overly complex for a hacky solution which is what this will always be. so worker (setup, discover, backfill, memorize, troubleshoot) will yes live on local.

then the only 2 questions from there are 1) how do we legitimately seamlessly support all sources for ingestion (right now it is just local chat jsonl files, not cloud chats too), and 2) how do we seamlessly support all sources for recall (again right now only chats with access to my pc can fetch recall).

for the second one, easiest solution is to put the existing git repo on private github host. that is super ez, literally one step since we already use git anyways. way simpler than dealing with s3. then with that, since chatgpt has the github connector which is logged in to personal account, any medium can access the memory recall - even regular chatgpt chats (non-work non-codex).

so the only remaining problem is source ingestion of cloud chats

to summarize
* we can put ingestion on cloud or on local. will avoid cloud to not blow up complexity. that is why we have the setup, backfill, troubleshoot, discover, and memorize skills.
* for ingestion sources we accept that since we dont work at open ai we're limited to what we can scrape here. for local chats, we have the full jsonl file with all content of chat. for cloud chats we are limited to what is exposed. nothing we can do
* for recall we CAN make sure that is seamless via github repo private which then any chat, local or cloud, codex or work or regular, can run recall on
* so:
    * do local workers to avoid cloud blow up complexity
    * mandate a github connector connection + recall skill as the "medium" (since dont work at open ai and cant integrate backend chatgpt app with this)
    * accept cloud chats as ingestion sources will be best-effort again bc do not work at open ai so are relying on what is exposed
    * but other than that the system is perfect and as robust as it can be


todo
* best effort ingest ALL source types / mediums - regular chats, Work cloud, Work local, codex cloud, codex local, codex cli, !!! DOTS TOO !!!
* make the auto sync bridge from local git to private gh and integrate that setup into the setup skill
* somehow make sure all mediums have 1) the gh connector and 2) the recall skill
* make a good design diagram showing every single thing this does so is easy to reason about and discuss and all that


deep dive
* `list_threads` + `list_archived_threads` are conceptually like the two source folders. entries have stable IDs and `updatedAt`; `read_thread` is the file read. tools return JSON we could save as a snapshot, not original JSONL
* no time filter on either listing, so filter returned timestamps ourselves. archived listing has pagination. active listing only exposes `limit`, no cursor, so still need to establish exhaustive discovery. pinned chats come in a separate array
* two cloud Work tests each appeared as a `chatgpt` conversation and a `codex` thread on host `durable`, with matching messages and times but different IDs. likely conversation + execution, but no explicit ID mapping was returned. archiving one moved its ChatGPT entry into the archived list while its Codex entry remained active
* taking only `chatgpt` entries would avoid those duplicates, but `kind` doesnt distinguish regular Chat from Work. local Work appears as `codex`, so this also isnt a replacement for local capture
* regular Chat returned `::chatgpt-content-reference{... source_message_id="..."}` instead of assistant text. reproduced with a brand new chat too. no exposed resolver found. same issue reported on multiple platforms: [openai/codex #50329](https://github.com/openai/codex/issues/50329) (open when checked)
* richer Work test used web research + Python. ChatGPT ID returned prompt and final answer, omitted tool activity, and replaced citations with references. Codex ID returned commentary, commands + outputs, web calls and final answer, but omitted web result bodies. so readable final answers alone dont prove complete capture
* reader supports turn pagination and an output length limit. raising the limit recovered truncated command outputs in a test; doesnt prove arbitrary long messages are recoverable. likely local cache locations checked had no transcript for the first cloud test

## p4

ai learning my writing style - would be super useful if it learned from stuff i actually write, drafts i approve, and edits i make to its writing. not just copying words but how much i explain, what i leave implicit, how direct i am etc. notes vs messages vs formal writing are different. maybe this is just another facet of memory rather than a whole separate system. figure out a workflow where it gets better from my corrections instead of me having to explain my style every time. this is honestly a big investment initially will be hard but once done it could literally save hours and hours every week
* this applies to much more than just writing too. should make a general style learning framework. things like how to format notion documents, how i flow pptx presentations, how i edit videos and images, how i style code, and so on

## stretch goals

claude equivalents of everything

final instruction for use blurb. TO "INGEST" A NON CHAT SOURCE (ie make your ai learn it permanently) all you need to do is open a chat and give it that information. same exact way you would a human. once chat reads it and learns it plus says what it learned, that will automatically be saved and digested by virtue of this system. no hacky per source types. from end user perspective, treat ai as competent human. if ever give something trust it will remember it. at worst, we may need a specific skill for telling a chat "hey deep extract everything about this source, form connections, etc and lay everything out in chat in great detail so that cos can effectively ingest this info later without itself going to source" - but nothing more than that

for anything and everything want to add to this in the future - must strictly justify from a concrete use case why it would be needed and why it cannot be done in current

## core

!! these were all done in p0 pretty much

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
