---
name: read-memory-on-summary-resume
description: "HARD — resuming from a compaction/handoff summary is NOT a substitute for reading tasks/memory/MEMORY.md. Read the index BEFORE acting, and on any goal change re-survey the toolbox + prior art."
metadata:
  node_type: memory
  type: feedback
---

**HARD RULE (read MEMORY.md even on summary-resume):** A compaction
summary or checkpoint hand-off is *not* a session start substitute.
Before taking the first substantive action after a resume, read
`tasks/memory/MEMORY.md` (and open the entries relevant to the current
task). The summary captures the last segment's *narrative*; it does
NOT contain the durable cross-session facts, and it will silently omit
prior art that makes the current work unnecessary or already-solved.

**Corollary (goal-change trigger):** When the goal shifts from what the
inherited plan/checkpoint assumed, STOP and re-derive from first
principles — do not continue the inherited framing. Two checks to run
on a goal change: (1) **toolbox** — what does the tool we already use
provide? (AGENTS.md "survey the toolbox before you need it"); (2)
**prior art** — grep MEMORY.md + repo for the symptom/goal keywords
(`feedback_prior_art_before_own_fix`).

**Why (2026-08-14):** Resumed the Aztec-libc #13 segment from a
compaction summary and spent a session "planning from scratch" how to
build a CP/M-86 libc — recompiling Aztec stdlib source — when
`MEMORY.md` already recorded **"stdcbench 0.8 on CP/M-86 via Watcom→DR
C bridge — final score 13 on both the Unicorn runner and real MAME
rc759"** (open follow-ups: large model rc7xx-work#4, math #3). I also
never asked "what does Watcom's OWN clib provide?" — it is retargetable
via a thin low-level layer (handleio/streamio/startup/heap over
BDOS), which is a cleaner path than recompiling Aztec. The user had to
prompt twice ("why not Watcom's printf? it needs no I/O", "Watcom has a
low-level layer") and then: "why didn't you follow AGENTS.md?". This is
the SAME prior-art miss that `feedback_prior_art_before_own_fix.md` was
created to prevent (also from a stdcbench incident). The missing step
was not a rule I lacked — it was reading the memory that holds it.

**The one-line habit:** first action after any resume =
`cat tasks/memory/MEMORY.md`, then a keyword grep for the task's goal.
