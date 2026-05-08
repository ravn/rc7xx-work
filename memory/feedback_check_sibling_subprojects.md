---
name: Check sibling subprojects before guessing build flags
description: When adding a build/compile/link flag to one subproject, ALWAYS grep the sibling subprojects in the same workspace for the same flag first
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE: when adding a compile, link, or toolchain flag to one
subproject (e.g., `cpnos-rom/Makefile`), GREP THE SIBLING
SUBPROJECTS in the same workspace (`rcbios-in-c/`, `autoload-in-c/`,
…) for the same flag BEFORE deciding how to wrap it.  The siblings
often have the answer already, and they may use a different
wrapping that handles edge cases your fresh attempt misses.

**Why:** session 47 (2026-05-07) -- I wrapped `--opt-code-size` as
`-Cs"--opt-code-size"` (passthrough to SDCC), got only 6 B savings
on a 2560 B resident, and concluded "size optimization is broken in
this codebase".  rcbios-in-c and autoload-in-c both use it as a
TOP-LEVEL zcc flag (`--opt-code-size -SO3`), which lets zcc swap
the peephole-rules file from `sdcc_peeph.3` (speed-tuned) to
`sdcc_peeph_cs.3` (code-size variant, ~3.6k more rules biased
toward shrinkage).  The user pointed it out: "We did all this for
the rcbios-in-c".

**How to apply:**
- Before adding any new build flag, run
  `grep -rn "<flag>" /Users/ravn/z80/rc700-gensmedet/`
  to find prior art.
- If a sibling already uses the flag, MIRROR THE SIBLING'S WRAPPING.
  Don't second-guess it from upstream docs -- the wrapping accounts
  for the toolchain's quirks.
- If no sibling uses it, document the wrapping decision in a comment
  next to the flag so the next subproject can adopt it without
  re-deriving.
- The siblings to check in this workspace are at least:
  rcbios-in-c, autoload-in-c, cpnos-rom, cpnos-build.
