# 5-bug upstream queue — status 2026-06-06 (sonnyboy)

Reference build: upstream llvm-project at `de59f9ed` (~/llvm-upstream on
sonnyboy, built).  Process: feedback_explain_before_filing — one bug at a
time, explicit per-filing user go-ahead; report-only (no fix patches).

| # | Bug | Status |
|---|-----|--------|
| 1 | deleteDeadLoop SSA malform | DROPPED from upstream queue — caller-contract violation by Z80LoopIdiomFill + live HEAD regression. Filed **ravn/llvm-z80#217** (open; fix = formDedicatedExitBlocks in pass + revert generic LoopUtils divergence + clang-shaped lit test). |
| 2 | TruncInstCombine Argument-leaf | Reproduces on de59f9ed. No tracker duplicate found. **Draft presented in chat — AWAITING user verdict.** Draft basis: `llvm-z80/tasks/upstream-158-truncinstcombine-argument-leaf-submission.md` (trim fix to one line). Repro: `narrow-through-argument.ll` (rotl_u8 returned unchanged). |
| 3 | SimplifyCFG foldTwoEntryPHINode | Still present but REFRAMED: upstream now gates on getPredictableBranchThreshold ONLY when branch weights exist (SimplifyCFG.cpp:3771); no-PGO path speculates regardless. Demonstrable generically via `-predictable-branch-threshold` cl::opt. Draft NOT yet written. |
| 4 | TruncInstCombine outside-user allowlist | Reproduces on de59f9ed (both fns stay i32). No duplicate found. Draft NOT yet written. Note: missed-optimization framing. Repro: `issue-165-trunc-outside-user.ll`. |
| 5 | InstCombine memcpy->illegal-int fold | Reproduces on de59f9ed. No duplicate found (3 search rounds). **Draft presented in chat — AWAITING user verdict.** Non-constant-src repro: `bug5-upstream.ll`. Consistency arg: InstCombine's own shouldChangeType gates on DL.isLegalInteger (InstructionCombining.cpp:307). Provenance: cpnos `init.c:435` `__builtin_memcpy(&msg[DAT], login_pwd, 8)` (#73 -> #87 -> local guard `475a65378517` = InstCombineCalls.cpp:172). |

Draft bodies for 2 and 5 are in the session chat (2026-06-06); reconstruct
from this file + the repro .ll files if the transcript is gone.  repro182.c +
issue182reg.md = the #217 filing (already filed).
