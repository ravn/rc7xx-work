---
name: Proper fixes — backend is immature
description: Z80 backend is immature; question prior design decisions instead of patching around them
type: feedback
originSessionId: 5242441f-d4fe-49e7-9d7f-aefb5393d9f7
---
The Z80 backend in ravn/llvm-z80 is preliminary and unfinished.  Previous
work — including code I wrote in earlier sessions — could have made
incorrect design decisions that should be questioned, not preserved.

**Why:** the user's framing is to *finish the backend correctly*, not
to optimize a finished one.  Band-aids that work around a wrong
abstraction (e.g. a peephole admitting "the pattern is specific
enough" instead of doing real liveness analysis, or a libcall fallback
that papers over a missing pseudo) leave latent bugs and accumulate
technical debt against an immature foundation.

**How to apply:**
- When fixing a bug, look upstream of the symptom.  If a peephole has
  a comment admitting it skips a check, the comment is the bug.
- Reject "minimal-change" fixes when they preserve a questionable
  design choice.  Sketch the right design, even if it costs more.
- Be willing to revert or replace prior session's code, including my
  own peepheoles / passes, when their design is the actual problem.
- Do not optimize for diff size at the expense of correctness or
  design integrity.
- This **strengthens** `feedback_root_cause_over_peephole`: not just
  "prefer upstream fixes" but "question whether the existing
  abstraction is right at all".
