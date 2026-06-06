# Handoff 2026-06-07 — upstream 5-bug queue: all drafts ready

Host: sonnyboy. Reference build: llvm-project `de59f9ed` at `~/llvm-upstream` (built).

## State

All four upstream drafts are written and verdict-gated (`feedback_explain_before_filing`,
report-only, target llvm/llvm-project). Everything in `tasks/upstream-5bug/`:

| Bug | Draft | Repro | Verified |
|---|---|---|---|
| 2 TruncInstCombine Argument-leaf | draft-bug2.md | narrow-through-argument.ll | 06-06 |
| 3 SimplifyCFG foldTwoEntryPHINode | draft-bug3.md | bug3-twoentry-phi-no-pgo.ll | 06-07 |
| 4 TruncInstCombine outside-user bail | draft-bug4.md | issue-165-trunc-outside-user.ll | 06-07 |
| 5 InstCombine memcpy->illegal-int | draft-bug5.md | bug5-upstream.ll | 06-06 |

Duplicate searches done 06-06 (none found). Bug 1 dropped from the upstream queue
(our pass violates the caller contract) -> ravn/llvm-z80#217, OPEN, fix plan in issue.

Sharpened this session:
- Bug 3 reframed: `getPredictableBranchThreshold()` is consulted ONLY inside the
  `extractBranchWeights` guard (SimplifyCFG.cpp:3767-3781) — dead for non-PGO code.
  Contrast-pair repro proves it (`-predictable-branch-threshold=0`: unweighted twin
  folds, weighted twin keeps branch).
- Bug 4 corrected: upstream has NO outside-user allowlist at all (any outside user of
  a non-ext node aborts, TruncInstCombine.cpp:276-283); the icmp-const allowlist was
  our fork's extension. Draft targets the all-or-nothing bail.

## Retraction cleanup — COMPLETE (verified via gh 06-07)

llvm-z80/llvm-z80 #18-#25 closed, ravn/llvm-z80#176 closed, #26 + PR #27 remain.

## Next actions

1. User: per-filing verdicts on drafts 2/3/4/5 (read the draft files; say "go ahead"
   per bug). Then file at llvm/llvm-project, each issue body = draft text.
2. After filings (or independently): ravn/llvm-z80#217 fix.
3. Then: #180 reviewability / #186 queue (upstream packaging track).

Session also delivered earlier (separate commits): CLAUDE.md cleanup, token-efficiency
overhaul (MEMORY.md 32->22 KB, new HARD rule feedback_token_efficiency, tiered
show-thinking), rc700-gensmedet/CLAUDE.md staleness fixes.
