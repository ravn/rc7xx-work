# AVR triage of the upstream-bug queue — 2026-06-07

User directive: triage all possibly-upstream bugs against an in-tree target
before (further) upstream filing.  Toolchain: PRISTINE upstream llvm-project
`de59f9ed` at `~/llvm-upstream`, rebuilt with `LLVM_TARGETS_TO_BUILD=
"X86;AArch64;AVR;MSP430"` (the z80 fork is NOT involved except where fork
behavior is itself the subject).  AVR = the only in-tree 8-bit target
(8-bit registers, 16-bit int — same promotion pain profile as Z80).

| Bug | AVR result | Upstream-filing verdict |
|---|---|---|
| 2 TruncInstCombine Argument-leaf (FILED llvm/llvm-project#202112) | **K&R rotl 20 instructions vs ANSI 3 (6.7x) at -Os/-O2/-O3** — ANSI compiles to the canonical `lsl r24; adc r24,r1; ret`, K&R does the full 16-bit dance | **STRENGTHENED.** In-tree victim confirmed. Add the AVR datum as a comment on #202112 (user go-ahead needed). |
| 3 SimplifyCFG foldTwoEntryPHINode no-PGO | select vs branch = 6 = 6 instructions (backend equalizes). ALSO: grep shows **NO in-tree target overrides getPredictableBranchThreshold** — the isZero() path has zero in-tree constituency | **WEAKENED to fork-relevant.** Recommend NOT filing upstream; Z80 cost (−16 B) is real but stems from our expensive select lowering. Keep as fork knowledge + cl::opt demo. |
| 4 TruncInstCombine outside-user bail (staged ravn/llvm-z80#219, HELD) | sound-(a) micro-shape: escaping-cmp 10 = hand-narrowed 10 (no cost — AVR splits 16-bit ops into byte pairs natively) | **WEAKENED pending evidence.** Micro-shapes equalize on AVR; the gf_log-scale claim is untested there AND our Z80 numbers are contaminated by the soundness bug until the gate fix + re-measure. Hold #219. |
| 5 InstCombine memcpy->illegal-int fold | fold fires on 16-bit DL (i64 load/store materialized); AVR llc: folded 37 = unfolded 37 (backend swallows the illegal i64 as byte traffic) | **WEAKENED on cost, consistency argument stands** (InstCombine's own shouldChangeType gates on DL.isLegalInteger; the fold doesn't). Z80 pain was real (cpnos #87). Decide after bug-4/2 outcomes; if filed, lead with consistency, not cost. |

## Reading

The asymmetry between bug 2 (6.7x) and bugs 3/4/5 (free) on AVR: a mature
byte-oriented backend recovers raw WIDTH costs during legalization, but it
cannot recover missed IDIOMS — the K&R rotate stays unrecognized at i16, so
the cost survives.  Conversely, several of our "upstream" pain points are
partly measurements of our own immature Z80 expansion, not of the mid-end
limitation.  Bug-by-bug in-tree evidence is now the bar before any filing
(memory rule [[thorough-tests-for-upstream-bugs]] + this triage as template).

## Caveats

- Micro-shapes only; large real-code shapes (gf_log) not yet built for AVR.
- gf_log itself is under soundness suspicion (fork icmp-narrowing miscompile,
  see test_220/221/222 + the lit matrix) — its numbers are unusable until the
  gate fix + re-measure.
- MSP430 also built but not exercised (int=16=register width there, so the
  promotion-pain argument doesn't apply; kept for future comparisons).
