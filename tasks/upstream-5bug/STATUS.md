# 5-bug upstream queue — status 2026-06-10

Reference build: upstream llvm-project at `de59f9ed` (~/llvm-upstream on
sonnyboy, built).  Process: feedback_explain_before_filing — one bug at a
time, explicit per-filing user go-ahead; report-only (no fix patches).

Watcher: remote routine `llvm-upstream-bug-watch` (trig_012Thn7hHeabxS59DsQPzkRS,
daily 06:00 UTC) reads THIS file for FILED issue numbers + always ravn/llvm-z80#217;
reports at claude.ai/code/routines. Keep "FILED ... llvm/llvm-project#NNNNN" wording
machine-findable when updating rows.

**Net state (2026-06-10):** queue tapped out after AVR triage 2026-06-07.
Bug 2 filed and watched.  Bug 1 dropped to #217.  Bugs 3-5 either dropped
or held with re-framing pending (see rows).  AVR triage in
`avr-triage-2026-06-07.md` is the load-bearing input — every "WEAKENED" or
"DROP" call below traces to a row in that doc.

| # | Bug | Status |
|---|-----|--------|
| 1 | deleteDeadLoop SSA malform | DROPPED from upstream queue — caller-contract violation by Z80PatternFillRecognize (was Z80LoopIdiomFill until 2026-06-09) + live HEAD regression. Filed **ravn/llvm-z80#217** (open; fix = formDedicatedExitBlocks in pass + revert generic LoopUtils divergence + clang-shaped lit test). |
| 2 | TruncInstCombine Argument-leaf | **FILED UPSTREAM: llvm/llvm-project#202112** (2026-06-07, explicit user go-ahead after staged iteration on ravn/llvm-z80#218, now closed w/ cross-ref). Two-voice form: user summary + attributed Claude deep-dive; line-exact L95-L105 permalink; rj_sb_inv provenance with corrected 147/16/31 numbers. AVR oracle STRENGTHENED (K&R rotl 20 vs ANSI 3 instr at all -O levels). Watch for maintainer responses. |
| 3 | SimplifyCFG foldTwoEntryPHINode | **MOVED to fork-internal tracker: ravn/llvm-z80#223** (2026-06-10).  Dropped from upstream queue per AVR triage 2026-06-07 — no in-tree target overrides `getPredictableBranchThreshold().isZero()` (`grep` confirms); AVR equalises select=branch=6-instr; Z80 −16 B win partly a measurement of our expensive select lowering.  Local fix already ships as ravn/llvm-z80#168 (CLOSED via `cd2a2ace8754` SimplifyCFG cost gate).  #223 carries the full analysis + revisit triggers so future work has the context.  Repro `bug3-twoentry-phi-no-pgo.ll` + `draft-bug3.md` retained as the historical record. |
| 4 | TruncInstCombine outside-user bail | **FILED UPSTREAM 2026-06-16: llvm/llvm-project#204098** ("[AVR][AggressiveInstCombine] TruncInstCombine bails on K&R uint8_t loop with outside-graph icmp user — emits 16-bit code where 8-bit is achievable"). AVR-targeted standalone filing with user's intro + AI disclosure, gf_log reducer (verbatim from public-domain AES-256), 70 B vs 48 B size delta, 825K vs 596K cycle witness on simavr, IR diff, 8-variant source-level workaround table, cause + direction sketch (no patch). Per `feedback_explain_before_filing` user gave explicit per-filing go-ahead.  Body at `tasks/upstream-5bug/issue-body-avr-gflog-missed-opt.md`; supporting artefacts: `avr-gflog-missed-opt.c`, `avr-gflog-runtime.c`, `gflog-variants.c`, `avr-gflog-workaround-2026-06-15.md`, `avr-gflog-oracle-2026-06-15.md`, `plan-bug4-unpark-2026-06-15.md`. Watch for maintainer responses. |
| 5 | InstCombine memcpy->illegal-int fold | Reproduces on de59f9ed. No duplicate found (3 search rounds). AVR triage 2026-06-07: WEAKENED on COST (AVR llc folded 37 = unfolded 37 — backend swallows i64 as byte traffic), but CONSISTENCY argument stands (InstCombine's own `shouldChangeType` gates on `DL.isLegalInteger` at `InstructionCombining.cpp:307`; `SimplifyAnyMemTransfer` doesn't). **HOLD on cost-led `draft-bug5.md` (the original); reframed consistency-led version saved as `draft-bug5-v2.md` (2026-06-10) — AWAITING user verdict on whether the standalone consistency argument is worth filing.** Provenance: cpnos `init.c:435` `__builtin_memcpy(&msg[DAT], login_pwd, 8)` (#73 -> #87 -> local guard `475a65378517` = InstCombineCalls.cpp:172). |

Draft bodies kept on disk:
- `draft-bug2.md` (filed as #202112)
- `draft-bug3.md` (DROPPED; kept for fork-internal context)
- `draft-bug4.md` (HOLD on #219 + icmp-narrow gate)
- `draft-bug5.md` (HOLD; original cost-led framing)
- `draft-bug5-v2.md` (NEW 2026-06-10; consistency-led reframing, AWAITING verdict)

`repro182.c` + `issue182reg.md` = the #217 filing (already filed).
