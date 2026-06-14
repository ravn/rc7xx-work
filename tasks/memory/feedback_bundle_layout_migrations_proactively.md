---
name: feedback-bundle-layout-migrations-proactively
description: HARD — when you defer a layout/migration task with the rationale "we don't need it yet", check headroom on the affected region.  If headroom is < 200 B, the next workstream is likely to need it; bundle the move proactively rather than blocking the next session on it.
metadata:
  type: feedback
---

When you're about to defer a layout migration (PROM region shrink,
TPA-grow, BSS region move, dead-code retire) with the rationale "we
don't need it yet", **check the current headroom of the affected
region**.  If headroom is < 200 B, the NEXT workstream is likely to
hit the cap and need the migration anyway.  Bundle it proactively
into the current commit train; otherwise the next session pays the
cost of stopping mid-flight to do the move.

200 B is the rough threshold because typical feature wire-ups
(transport block recv with dispatch flag, sub-protocol handler, new
CP/NET frame field) tend to grow PROM payload by 50-250 B.  Anything
above ~200 B of headroom usually absorbs the next feature; below it
the next feature blocks on layout.

**Why:** 2026-06-14 hit this concretely.  The 2026-06-13 design
refinement at session-2026-06-13-phase4-inir-and-mame-findings.md
proposed shrinking the cpnos-in-c PIO_RX ring from 256 B to 16 B
(freeing ~240 B) "when Phase 2 finally lands".  At session-end
that was deferred as a "later" item — fine in isolation, since the
ring shrink isn't behavior-blocking.

The next session (today) attempted Step 2+4 of #115 (variant H +
DI bracket).  The C-version wire-up cost +232 B raw / overflowed
the 2 KB PROM cap by 176 B.  The deferred ring shrink would have
unblocked it directly.  Net: ~2 hours of analysis + revert + writeup
that could have been spent landing Step 2+4 if the layout move had
been bundled at the time it was identified.

The headroom at the moment of deferral was ~18 B free (PROM1
clang 2030 / 2048).  Far under 200 B.  The "we don't need it yet"
deferral logic missed that ANY non-trivial follow-up would.

**How to apply:** when deciding to defer a layout migration:
1. Sum the headroom of the affected region in BOTH compilers' bins
   (clang and SDCC raw + compressed if PROM-resident).  If either
   is < 200 B, mark the migration as "bundle now".
2. If the migration is behavior-preserving (typical for
   layout-only moves), there's no reason to defer it.  The
   "we don't need it yet" reasoning applies only to behavior
   changes.
3. Ship the migration as a separate commit BEFORE the workstream
   that would otherwise depend on it.  This way: if the workstream
   stalls, the layout move still shipped; if the workstream lands,
   the layout move's wins are visible in the same release.
4. Update memory / tracker (TaskList) noting the bundled move so
   the rationale survives across sessions.

Related: [[feedback_check_sibling_subprojects]] (sibling layout
patterns to mirror); [[feedback_compare_total_section_sizes]] (use
total section sums, not per-function, when assessing headroom).
