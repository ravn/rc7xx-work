---
name: No "want me to..." in active debug loop
description: When in an authorized debug/test loop (MAME, mpm-net2, builds), proceed without asking — just do the next diagnostic
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When already in a debug loop with standing authorization (MAME launches,
mpm-net2 spawns, cpnos rebuilds, smoke_inject runs — all covered by
`feedback_mame_mpm_no_permission`), do NOT close turns with "Want me
to ...?" / "Should I ...?" — just run the next test or diagnostic.

**Why:** User feedback 2026-04-28 ("can you please, please not need to
ask me for every command?").  Asking for go-aheads on each iteration
inside a known-safe debug cycle is friction, not safety; the standing
authorization already covers it.  Each ask burns a turn that could be a
test result.

**How to apply:** When the next step is observably reversible and lives
inside an in-progress debug cycle, run it.  Reserve confirmations for:
genuine design forks (`feedback_ask_about_design_decisions`), risky
actions (force push, branch delete, package downgrades), or when I
truly do not know which of two approaches the user wants.  An open
question to the user mid-debug should usually be "this isn't working,
should we change strategy?" — not "may I run the next step?"
