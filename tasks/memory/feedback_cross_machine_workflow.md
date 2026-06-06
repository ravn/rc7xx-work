---
name: feedback_cross_machine_workflow
description: User works across multiple machines (macbook + sonnyboy + future hosts) and must be able to switch hosts mid-flight. State that isn't in git is lost on switch. Commit-push at end of every working segment; pull at start; use tasks/handoff/ for live narrative.
metadata:
  type: feedback
---

**The rule (user-set, 2026-06-06):**

> "I need to be able to work on both machines depending on what is
> available.  So state must be in the projects."

The user has at least two working hosts (macbook + sonnyboy-class Ubuntu)
and will pick whichever is available.  A working state that lives only
on one machine -- uncommitted changes, half-finished edits, a Claude
session that knows "where we are" -- is invisible to the other.

**What goes in git (and gets committed + pushed regularly):**

* All memory rules under `tasks/memory/`.
* All planning docs under `tasks/` (roadmaps, finishing checklists, ...).
* Live in-progress narrative under `tasks/handoff/YYYY-MM-DD[-slug].md`
  — see "handoff convention" below.
* Sub-project source changes (committed in the sub-repo, then the
  workspace submodule pointer bumped).
* BOOTSTRAP.md / CLAUDE.md / AGENTS.md / PROJECT.md updates.

**What stays per-machine (intentionally not in git):**

* Build artifacts.
* `~/.claude/sessions/` (Claude Code's per-machine session log; would
  be fragile to rsync).
* Shell history.
* API keys.

## Cadence

Treat each working segment as if it could end abruptly:

1. **At end of segment**: commit + push everything that should survive.
   Workspace last (so the submodule pointer bumps reflect the sub-repo
   pushes that just happened).
2. **At start of segment** (on either host): `git pull --recurse-submodules`
   in the workspace.  Read the latest `tasks/handoff/`.
3. **Between segments**: if you're in the middle of something
   non-trivial, write a one-paragraph entry to `tasks/handoff/<today>.md`
   and push, even if no other change is ready.

## Handoff convention (`tasks/handoff/`)

`tasks/handoff/YYYY-MM-DD-slug.md`, one per session or major thread.  Format:

```markdown
# Handoff — 2026-06-06 — short-slug

**Where we are:** one-paragraph status.
**Last touched:** files / commits / external state.
**Next action:** what the next Claude session should do first.
**Open questions for the user:** anything I'd stop and ask.
**Pinned context:** any tricky detail not yet in CLAUDE.md / memory.
```

The new session reads this on first turn (you can paste it into the
first prompt or just `cat` it).  It is NOT a substitute for memory --
it is the *short-lived* layer above memory.  When the work concludes,
either delete the file or fold its surviving insight into memory.

## How to apply

* Treat "I am idle / done for now" as a commit-push trigger, not "I'm
  fully finished."  Idle is when context loss costs the most.
* If the user signals they're switching machines, push everything
  outstanding FIRST, then confirm; don't switch mid-push.
* When starting on a host where I haven't worked in a while, the very
  first action is `git pull --recurse-submodules` from `~/z80` and a
  read of the most recent `tasks/handoff/*.md`.

Related: [[user_profile]], [[feedback_no_apology]] (just push, don't
narrate the regret of having forgotten),
[[feedback_timeline_record_keeping]] (timeline is the long-form record;
handoff is the short-form one).
