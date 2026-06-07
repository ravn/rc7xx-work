# 5-bug upstream queue — status 2026-06-06 (sonnyboy)

Reference build: upstream llvm-project at `de59f9ed` (~/llvm-upstream on
sonnyboy, built).  Process: feedback_explain_before_filing — one bug at a
time, explicit per-filing user go-ahead; report-only (no fix patches).

Watcher: remote routine `llvm-upstream-bug-watch` (trig_012Thn7hHeabxS59DsQPzkRS,
daily 06:00 UTC) reads THIS file for FILED issue numbers + always ravn/llvm-z80#217;
reports at claude.ai/code/routines. Keep "FILED ... llvm/llvm-project#NNNNN" wording
machine-findable when updating rows.

| # | Bug | Status |
|---|-----|--------|
| 1 | deleteDeadLoop SSA malform | DROPPED from upstream queue — caller-contract violation by Z80LoopIdiomFill + live HEAD regression. Filed **ravn/llvm-z80#217** (open; fix = formDedicatedExitBlocks in pass + revert generic LoopUtils divergence + clang-shaped lit test). |
| 2 | TruncInstCombine Argument-leaf | **FILED UPSTREAM: llvm/llvm-project#202112** (2026-06-07, explicit user go-ahead after staged iteration on ravn/llvm-z80#218, now closed w/ cross-ref). Two-voice form: user summary + attributed Claude deep-dive; line-exact L95-L105 permalink; rj_sb_inv provenance with corrected 147/16/31 numbers. Watch for maintainer responses. |
| 3 | SimplifyCFG foldTwoEntryPHINode | Reframed + repro VERIFIED on de59f9ed 2026-06-07: contrast pair `bug3-twoentry-phi-no-pgo.ll` — noweights fn folds to select despite `-predictable-branch-threshold=0`, weighted twin keeps branch (threshold only consulted inside extractBranchWeights, SimplifyCFG.cpp:3767-3781; no-PGO budget is flat `two-entry-phi-node-folding-threshold`×TCC_Basic). **Draft written (`draft-bug3.md`) — AWAITING user verdict.** |
| 4 | TruncInstCombine outside-user bail | Re-verified on de59f9ed 2026-06-07 (both fns stay i32). NOTE: upstream has NO icmp-const allowlist at all — any outside user of a non-ext node aborts (TruncInstCombine.cpp:276-283); the "allowlist" was our fork's prior extension, so the draft targets the all-or-nothing bail. Missed-optimization framing. **STAGED as ravn/llvm-z80#219** (2026-06-07): two-voice scaffold, user summary placeholder, L274-L288 permalink. User iterates -> move upstream on go-ahead. Repro: `issue-165-trunc-outside-user.ll`. |
| 5 | InstCombine memcpy->illegal-int fold | Reproduces on de59f9ed. No duplicate found (3 search rounds). **Draft presented in chat — AWAITING user verdict.** Non-constant-src repro: `bug5-upstream.ll`. Consistency arg: InstCombine's own shouldChangeType gates on DL.isLegalInteger (InstructionCombining.cpp:307). Provenance: cpnos `init.c:435` `__builtin_memcpy(&msg[DAT], login_pwd, 8)` (#73 -> #87 -> local guard `475a65378517` = InstCombineCalls.cpp:172). |

Draft bodies for 2 and 5 are in the session chat (2026-06-06); reconstruct
from this file + the repro .ll files if the transcript is gone.  repro182.c +
issue182reg.md = the #217 filing (already filed).
