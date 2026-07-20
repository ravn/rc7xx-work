# Pending canonical AGENTS.md edits (apply upstream, then mirror to every repo)

AGENTS.md is canonical at https://github.com/ravn/AGENTS.md and mirrored into each
project root. Cross-project rule changes must be made to the canonical repo FIRST,
then propagated. This file queues such changes discovered here but not yet applied
(the canonical repo is not cloned in this workspace).

## QUEUED 2026-07-21 — proactive oracle-coverage rule (from ravn/llvm-z80#273)

Target section: **"Verification & commit discipline"**.

Proposed addition:

> **A closure / runtime library is not verified until every public entry point has
> run at least once — especially the *sole* user of an internal helper.** Arithmetic-
> only tests are insufficient; include conversions/casts. When a helper has exactly
> one call site, that site must appear explicitly in the oracle, or the helper is de
> facto untested.

Rationale / provenance: #273 ((double)int miscompiled) sat undetected because
`softfloat_countLeadingZeros32` had exactly one user — `i32_to_f64` (int→double) —
and the verify corpus tested only literals + add/sub/mul/div (which normalize via
clz64). The one code path exercising the broken clz32 was never run. This is the
PROACTIVE complement to the existing reactive rule "a bug found by luck is a bug in
your oracle" (which only says what to do AFTER a lucky find). See tasks/lessons.md
2026-07-21 and the z80-specific note now in CLAUDE.md ("GCC builtins operate on
16-bit int here").

Status: NOT yet applied to canonical AGENTS.md. The z80-specific half (16-bit-int
builtin trap) IS already applied to this repo's CLAUDE.md ("C Language Standard").
