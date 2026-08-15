# Z80 Code Density Optimization Todo

## Current (2026-06-24, dcc-corpus three-compiler oracle)

- [x] **CP/M three-compiler oracle built** — `llvm-z80/z80-utils/compiler-zoo/cpm_zoo.py`
  compares dcc / clang / clangp / zsdcc over the dcc test corpus (raw codegen
  size + T-states + consensus verdict). clang CP/M runtime in `llvm-z80/z80-utils/cpm/`
  (crt0 + minimal libc + argc/argv tail parsing). Refs #35.
- [x] **clangp `+static-stack` recursion-gated** — `is_recursive()` (IR call-graph
  cycle check) drops static-stack on recursive tests; implements memory rule
  `feedback_static_stack_nonrecursive_only`. nqueens DIFF→AGREE.
- [x] **clangp `-disable-lsr` dropped** — confirmed stale (#232/#234); was the sole
  cause of clangp regressing vs clang (tqsort −38% speed). clangp now ties-or-beats
  clang everywhere.
- [x] **B17 — FIXED 2026-06-24** multi-byte `sbc a,a` carry-materialization.
  Root-caused (ISel models inter-limb carry as GR8; pseudo expansion round-trips
  via `sbc a,a;and 1` / `rrca`; AVR keeps it in CF -> Z80-backend gap, not a
  generic bug). New post-RA `Z80FuseCarryChain` pass threads carry in the flag
  for add/sub chains with a dead terminal carry. add32 −5 instr, i64 add −11;
  production byte-identical; lit 173+6, runtime 872 PASS, new lit + `test_224`.
  Writeup `llvm-z80/tasks/b17-fuse-carry-chain-2026-06-24.md`. NOT committed yet.
  Follow-up candidates (not done): fuse chains whose terminal carry IS observed
  (needs an `ADC_HL_rr_CI` flag-in/capture-out pseudo); the i32 `==0`/`<`
  comparison-boolean `sbc a,a` is a SEPARATE shape, still open.
- [ ] **IndVarSimplify SCEV closed-form → multiply libcall** (triangle n·(n+1)/2
  emits `mulsi3`/`muldi3`). Generic (AVR confirmed), NOT the size driver here, so
  low priority. Candidate for llvm/llvm-project — needs minimal repro + explicit
  go-ahead (`feedback_explain_before_filing`) before any upstream post.

## Earlier (2026-06-21, Z80 TTI modelling investigation)

Active queue, in priority order:

- [x] **Z80 TTI modelling holes 2026-06-21 — sweep CLOSED**
  (`llvm-z80/tasks/session-2026-06-21-z80-tti-modelling-investigation.md`).
  All five empirically tested:
  - [x] **#227** `getCmpSelInstrCost` — VERIFIED INERT (lit suite + synthetic + predictable-branch all byte-identical).  Held open at fork.
  - [x] **#228** `getCallInstrCost` — VERIFIED INERT (lit suite + call-heavy synthetic).  Held open at fork.
  - [x] **#229** `getIntImmCost` family — VERIFIED INERT (ConstantHoisting fires, regalloc dematerializes via `isReMaterializable`).  Held open at fork.
  - [x] **#230** `isLegalICmpImmediate` — VERIFIED INERT (LSR consumer is decline-only; GISel doesn't reach SDAG consumers).  Held open at fork.
  - [x] **#231** `Z80NarrowIV` predicate — pass doesn't exist; cpnos pain hypothetical.  Speculative-future at fork.
  Conclusion: cost-model fixes correct as model statements but downstream Z80-specific machinery already produces the right shapes.

- [ ] **Inverse analysis: Z80 machinery that would be better modelled (2026-06-21 continuation)**
  - [x] **#232 CLOSED WONT-FIX (2026-06-21)** Empirical A/B showed LSR is locally good (raw −1 B autoload / +2 B cpnos) but ZX0 compresses the LSR'd output worse (+13 B both). Outside TTI's expressive power — same class as #184. Writeup: `llvm-z80/tasks/issue232-lsr-sledgehammer-investigation-2026-06-21.md`.
  - [ ] **#234** (NEW from #232 investigation) Remove stale `-mllvm -disable-lsr` from rcbios Makefile — verified byte-identical no-op (5462 B both, instruction-level identical disassembly).  Tiny chore.
  - [ ] **#115 PARKED 2026-06-21** — user pivot to "3-pair set right for LDIR/DJNZ" first.  Examination complete: ~21 B recoverable (autoload 6 + rcbios 15), design sketch ready (HLReg/DEReg per BCReg precedent), full pickup runbook in `llvm-z80/tasks/issue115-iy-unreserve-investigation-2026-06-21.md`.  Implementation gated on the 3-pair-set pivot resolving.
  - [ ] **#233** Cleanup: fix mis-labelled "Vectorizer-only hooks" comment at `Z80TargetTransformInfo.cpp:38-44`.  Tiny chore; carry findings from #227-#230 into the comment.

- [ ] **Upstream 5-bug filings** — drafts 2/3/4/5 complete in `tasks/upstream-5bug/`,
  repros verified on llvm-project `de59f9ed`; each AWAITING per-filing user go-ahead
  (`feedback_explain_before_filing`). Bug 1 rerouted to ravn/llvm-z80#217.
- [ ] **ravn/llvm-z80#217** — Z80LoopIdiomFill violates `hasDedicatedExits()` caller
  contract; regression at HEAD. Fix plan (in issue): `formDedicatedExitBlocks` in the
  pass + revert the generic LoopUtils divergence + clang-shaped lit test.
- [ ] **Upstream packaging track** (after filings): #180 peephole-audit reviewability
  (~3-5 genuine stand-ins), #186 U-LLVM queue. Per session #74: only high-value
  compiler work remaining.
- [x] **PR #17 retraction cleanup COMPLETE** (verified 2026-06-07): fork issues
  #18-#25 closed/withdrawn, #176 closed, #26 + PR #27 remain (correctly scoped).
- PARKED: cpnos work awaits physical parallel cable (`project_cpnos_parked_awaiting_parallel_cable`).
- [x] **Investigate GDB-over-physical-RC702** (2026-06-17 → 2026-06-17 — first-pass done,
  see `rc700-gensmedet/tasks/gdb-z80-stub-findings-2026-06-19.md`).  Built z80-elf-gdb 17.2 in Docker; verified it reads
  our clang DWARF5 ELF (resolves `_bios_hw_init`, `_specc`, `_isr_crt` to addresses + 12
  source files).  MAME-gdbstub wire is already proven via `gdb_trace.py` (raw RSP) and
  `z88dk-gdb` (in our z88dk:2.4 Docker image).  Physical-hardware path: **Pi/Pico bus
  bridge** (recommended) — same hardware unblocks the parked INIR work.  Pre-existing
  scaffolding: `rcbios-in-c/run_mame.sh -g`, `gdb_trace.py`, `gdb_bgstar.py`.

Stale-item corrections to the sections below: #205 CLOSED (session 76, pattern-fill
intrinsic), #194 CLOSED (session 73s-cont2). #203 forward-scan restructure and the
~56 FATALs triage remain open, low priority.

## After session 73s cont. (differential oracles + #136/#202/#204, 2026-05-27)

DONE this session (all committed + pushed):
- [x] **#202 CLOSED** — cross-block BSS-spill->PUSH/POP dropped a loop-carried store-back;
  unified the loop-carried guard across all 4 spill peepholes.
- [x] **#204 CLOSED** — address-taken slot's store wrongly converted to PUSH (found by the
  native oracle); unified the address-taken guard across all 4 peepholes.
- [x] **#136 CLOSED** — "38 mystery O1 fixtures" root-caused (5-line repro, opt-bisect ->
  Z80LoopIdiomFill overlapping memcpy mis-inlined by InstCombine at -O1) and fixed with a
  one-line `volatile`. Production byte-identical; regression test_176.
- [x] **Two differential oracles built** (`test-runner -diff-opt`, `-native-oracle`) — now
  at a CLEAN baseline (0 DIFFOPT/0 NATIVE) in default + static-stack configs. SKIP-IF gained
  `+feature` support; test_36 skipped under +static-stack.
- [x] rc700#100 CLOSED (autoload banner check). IX un-reserve investigated + reverted; #12
  write-up filed.

OPEN / next:
- [ ] **#203 — unify the remaining spill-peephole guards** (orphan-access, cross-block
  UsedElsewhere [has #155 dominator relaxation], SP-write, stack-depth). The 2 *drifted*
  guards (loop-carried, address-taken) are unified; these are structurally embedded in each
  peephole's scan loop -> behavior-sensitive, not yet drifted into a bug. Lower priority.
- [ ] **#205 — non-UB representation for the LDIR-fill** (Z80LoopIdiomFill currently emits a
  volatile *overlapping* memcpy = UB-in-IR, un-exploited). K=1 -> memset (but a naive switch
  regressed -Oz across test_90/91 -- investigate first); K>1 -> target intrinsic / memset.pattern.
- [ ] **CI differential gate — PARKED** (user: not now). Design in
  `llvm-z80/tasks/ci-test-runner-differential-gate-PARKED.md`. Run locally meanwhile.
- [ ] **Triage the ~56 test-runner FATALs** (gates a clean exit-code CI gate): 50 = "no
  register value in emulator output" (huge test_90/91 fixtures at O0 -- emulator can't
  extract a result; harness/limit issue), 6 = test_48_dynamic_alloca missing `alloca.h`
  (test-setup; alloca under +static-stack is dubious anyway). Test-infra, not codegen.

## Open after session 73s (#198 + verifier triage, 2026-05-26)

- [ ] **#194 — surgical live-in fix for the cross-block #60 `LD A,r` removal.**
  Z80LateOptimization.cpp ~3874 removes a redundant cross-block `LD A,r` but leaves
  the using block's live-ins stale (gf_log `ADD_A_A` reads undefined `$a`). Benign at
  runtime. Blanket `fullyRecomputeLiveIns` is REJECTED (+2 B cpnos via aes_ar_cpy
  block-placement). Open path: path-limited recompute (def block .. reload block).
  Byte-neutrality plausible (the +2 B was aes_ar_cpy, not gf_log) — measure before
  committing. Verify: gf_log -verify clean, cpnos size unchanged, cpnos boot, lit,
  test-runner A/B.
- [x] **#201 — create-time GR16NoIR chokepoint — DONE 2026-05-26.** Constrained all 8
  GR16NoIR pseudos' operands to GR16NoIR at ISel; "Illegal virtual register" verifier
  class -> 0. Density default-config-favorable (cpnos 2036->2033, autoload 0, BIOS +1).
  Oracle green (lit 118+5, test-runner default byte-identical, cpnos boot PASS).
  Caveat: test_54_O0_ss FAIL->FATAL under +static-stack (pre-existing #192-class O0,
  non-production). Merged + closed.
- [ ] **Remaining -verify gates (#197) -- 2 of 4 cleared (2026-05-26):**
  DONE: illegal-vreg (#201 chokepoint), multiple-vreg-defs (tied INC16 fresh-dst --
  also fixed test_38_sort_search O1 miscompile). REMAINING: #194 (undefined-physreg
  liveins, ~74 -- delicate, multi-block recompute; blanket rejected +2B) and #200
  (SPILL_GR16 array/offset operand count, ~22 -- cosmetic, frame-lowering). Clear both
  -> flip the test-runner `-verify` flag to a blocking CI lane.
- [ ] **#200 — SPILL_GR16 array/offset operand-count cleanup** (cosmetic): model the
  2-operand resolved form to match the 3-operand declaration, or split the pseudo.
- [ ] **#197 — flip the test-runner `-verify` flag (landed) to a blocking CI gate**
  once #112/#189 + #194 + #200 clear (backend verify-clean at -O2).
- [ ] **#38 — IX/IY MIR cost model** (per-value shuttle-vs-spill). The big code-density
  lever; un-reserve IX/IY by default. Independent of the above; fresh focused session.

## IY un-reserve ("#38" lever) — MEASURED 2026-05-26, size-win / small-speed-cost

- [x] **Un-reserve IY gated on size-opt -- DONE + LANDED (2026-05-26).** Shipped:
  (1) BSS-spill->PUSH/POP SP-write guard (Z80LateOptimization) -- fixes the blocker
  AND a pre-existing latent miscompile (test_58_O0_ss +static-stack, #192-class),
  with an MIR regression test; (2) z80IsIYAllocatable(MF) = flag || (hasOptSize &&
  staticStack), threaded through getReservedRegs/getLargestLegalSuperClass/
  Z80NarrowNoIndex. Result: ~33 B production win at -Oz (cpnos 2033->2027, autoload
  1483->1478, BIOS 5920->5897), 0 undoc IY ops, gate precise (-O2 0 IY / -Oz 65),
  lit 119+5, test-runner default byte-identical + static-stack improved, cpnos boot
  PASS, autoload boots to A>. Speed reserved for -O2/-O3 (+0.11% IY-access cost).
  FLAG-gated history below kept for reference.
- [ ] **(superseded -- now DONE above) earlier blocked attempt:** Built a shared `z80IsIYAllocatable(MF)` =
  `Z80UnreserveIY || (hasOptSize && staticStack)`, threaded through getReservedRegs,
  getLargestLegalSuperClass, and Z80NarrowNoIndex. Gate works precisely: aes256
  -O2+ss = 0 IY operands (speed path untouched), -Oz+ss = 74; default (non-ss) suite
  byte-identical; production banks the win at -Oz with NO flag (cpnos 2025, autoload
  1478 comp, BIOS 5897 -- ~35 B). lit 118+5.
  **BLOCKER:** test-runner -static-stack caught a NEW miscompile -- test_58_fixed_point
  **Os_ss/Oz_ss** return 0x0037 vs 0x003F. test_58 uses NO IY itself, so it is a
  side-effect of the GR16NoIR-discipline machinery (Z80NarrowNoIndex / the
  getLargestLegalSuperClass no-widen) being activated at Os/Oz -- machinery that was
  only ever exercised under the off-by-default flag and has a latent bug (likely
  Z80NarrowNoIndex over-narrowing a vreg, or the no-widen reducing coalescing into a
  bad spill; matches the drill's "applied bluntly -> net-harmful" warning, and the
  "any vreg feeding COPY %x.sub_lo/.sub_hi" residual). REVERTED per no-commit-on-
  miscompile; production clang restored (test_58 Os/Oz pass again).
  **Next:** diagnose the test_58 Os/Oz miscompile under z80IsIYAllocatable (which vreg
  Z80NarrowNoIndex/the no-widen mishandles), fix, then re-run the gate + full oracle.
  Mechanism + ~35 B win are proven; only this residual correctness bug blocks the flip.
- [ ] **Do the same IX un-reserve analysis as IY (TO DO LATER, user 2026-05-26).**
  IX is the frame pointer when not +static-stack; under +static-stack it can be freed
  (hasFP=false had a parked runtime bug, #12). Measure size/speed of un-reserving IX
  the same way (per-function byte deltas + AES tstate), same size-vs-speed gating.
- [ ] **autoload `make mame` clang banner check is stale (found 2026-05-26).**
  EXPECT_BANNER for clang = "RC700 CL" (Makefile line 124) but the actual clang
  banner is "RC700 ROA375 CL", so the substring match always FAILs even though the
  autoload boots correctly to CP/M A>. Fix EXPECT to "RC700 ROA375 CL" (or match on
  "CL"). Codegen-independent; surfaced verifying the IY size-gate.
- [ ] **Look at the O0+static-stack hang later (user 2026-05-26).** NOTE: the
  test_54 hang context changed -- #201's chokepoint caused it; the IY size-gate
  keeps O0 reserved so it does not trigger there. Re-check whether it still occurs.
- [ ] **(orig) Look at the O0+static-stack hang later (user 2026-05-26).** test_54_unsigned_
  compare_O0_ss went FAIL->FATAL (timeout) under #201 + +static-stack -- a pre-existing
  #192-class O0 failure changing manifestation (wrong-value -> hang). Non-production
  (O0); production opt levels unaffected. Understand why it now hangs.

## Backlog (reinvestigate later)

- [ ] **Reinvestigate whether the EXX shadow register bank could be useful** (2026-05-26).
  EXX swaps BC/DE/HL with a second hidden copy (the shadow bank) in 1 byte. Prior
  work parked it: the shadow bank is a *context switch*, not addressable extra
  registers (EXX swaps all three pairs at once, so you can't hold a live value in
  one pair and reach the shadow of another) — see ravn/llvm-z80 **#7** and the
  modelled candidate in `llvm-z80/tasks/exx-candidate-analysis.md` (**#114**, the
  `_specc` shape: a u16 outer counter spilled across an inner no-CALL loop) +
  lit fixture `llvm/test/CodeGen/Z80/issue-114-exx-bracket-candidate.ll`.
  Why revisit now: the IX/IY un-reserve work (#189/#27/#112, session-73ab) made the
  "extra register pair vs memory spill" economics concrete (a register that costs a
  few bytes to reach can still beat a 3-byte BSS spill). The same lens applies to an
  **EXX bracket** — `EXX; <inner region where BC/DE/HL are dead-then-restored>; EXX`
  — which would give the inner region 3 fresh pairs for free *if* the bracket
  boundaries can be proven safe (all of BC/DE/HL dead across the swap, no CALL, no
  interrupt-shared state). Open questions to settle: (a) can the compiler identify
  such brackets reliably (the `_specc` outer-counter-across-inner-loop shape is the
  prototype)? (b) does it beat the current BSS-spill on size/speed? (c) interaction
  with `+shadow-regs` (currently only wired for ISR save/restore, "not yet functional
  for spill reduction"). Start from a measured drill on the #114 fixture, not theory.

  **REINVESTIGATED 2026-05-26 (measured drill on the #114 fixture, current llc):**
  Verdict — legitimate candidate, NOT fundamentally dead, but modest payoff and gated
  on a zero-sum tradeoff. Findings:
  - The fixture's spill shape still reproduces; the locked-in lit test passes.
  - **The EXX bracket sidesteps the original killer** (#7 finding "shadow not
    addressable / no encoding"): the bracketed inner region uses the MAIN bank
    registers normally (fully encodable); the shadow just invisibly holds the parked
    value across the region. So the encoding blocker does NOT apply to the bracket.
  - **Payoff is Tier-1 only (~6 B + 2 B BSS per qualifying loop).** Measured the inner
    loop: it already uses A+BC+DE+HL and BSS-spills `dp` every iteration because it
    wants a *4th* pair. EXX swaps all 3 pairs wholesale — it cannot hand the inner loop
    a 4th, so it does NOT eliminate the per-inner-iteration spill (my initial hope; the
    measurement refuted it). The only win is replacing the per-*outer*-iteration
    `ld (nn),bc … ld bc,(nn)` (8 B) with `EXX … EXX` (2 B).
  - **Hard blocker: shadow single-owner conflict with `+shadow-regs` ISR save/restore.**
    Calling conv `Z80_Interrupt_EXX_CSR` already makes ISRs save the interrupted context
    via EXX into the shadow bank. An ISR firing mid-bracket swaps the parked value into
    the main bank and clobbers it -> corruption on bracket-exit. The two uses are
    MUTUALLY EXCLUSIVE; only one owner of the shadow bank per build. All production
    firmware (autoload, BIOS, cpnos) has ISRs, so adopting EXX brackets means GIVING UP
    the 2 B ISR save (a real, shipped win) in exchange.
  - **Recommendation: keep parked.** Pursue only if a measured count shows many
    qualifying loops in a byte-critical target (cpnos PROM1) AND that target can cede
    the shadow bank from its ISRs. Lower priority than **#38** (IX/IY MIR cost model),
    which addresses the dominant BSS-spill bloat far more generally and without the
    single-owner tradeoff. The #114 fixture + this verdict stay as the durable record.

## Status: IX/IY reverted to reserved — CLANG BEATS SDCC

SDCC: 1910B | Clang: 1767B | Clang is 143B smaller (-7.5%)
BIOS: SDCC 5797B | Clang 5843B (+46B, +0.8% — was +64B before #66 fix)

## Session 13 (issue #66 — redundant BSS reloads, -18B BIOS)

Two waste patterns eliminated in `Z80LateOptimization.cpp`:
1. New peephole collapses `LD A,r ; PUSH AF ; LD A,r ; LD (addr),A ; POP AF`
   into `LD A,r ; LD (addr),A` (4 instances × 3B = 12B).
2. BSS load forwarding extended from MCSymbol-only to also track GlobalValue
   operands (C globals), with volatile-access guard. Eliminates store-then-
   reload of globals (2 instances × 3B = 6B).

Verified: 49/49 lit tests pass; BIOS shrinks 5861→5843B exactly as predicted;
no PROM regression. Submodule SHA bumped in superproject.

### Session 13 follow-ups (housekeeping)

* Combined this machine's local session-12 BIOS work with origin's session-12
  PROM work via `--no-ff` merges in both `llvm-z80` and the superproject
  (the two sides had been developed in parallel and were diverged on
  CLAUDE.md, `Z80LateOptimization.cpp`, and the test files).
* Brought `rc700-gensmedet` onto `main` (was sitting on `feature/iobyte`,
  7 commits ahead of `main` since session 10) via `--no-ff` merge.
* Brought `z88dk` onto its primary `master` branch (was in detached HEAD
  at `120cd6ec87`, equal to `origin/master` but with stale local `master`).
* New doc `rcbios-in-c/docs/serial_motherboard_uart.md` — how to use a
  native PC motherboard 16550 COM port instead of the FTDI USB-serial
  cable (same wiring; only `RC700_PORT=/dev/ttyS0` and `dialout` group
  need to change). Sibling to existing `serial_cable_wiring.md`.
* Parked todo in `rc700-gensmedet/tasks/todo.md`: investigate using an
  RP2040 / Arduino as a server for the Z80-PIO Channel A parallel port —
  same use case as the serial cable but with much higher throughput.

### Open: lit-test reproducibility on this Linux machine — issue #69 (to file)

> **Note:** issue #69 is *not yet filed* — `gh` is unauthenticated on this
> machine. A ready-to-paste draft for `ravn/llvm-z80` issue #69 is below
> under "Issue draft for #69".

Three lit tests failed on this machine but pass on the user's other
machine *at the same llvm-z80 SHA*:

1. `branch.ll`, `fib.ll`, `narrow-add-cmp.ll` — failed because at -O0 the
   functions sit right at the JR ±127-byte range edge; this machine's build
   produces them slightly larger so branch relaxation widens `jr` to `jp`
   and the `; CHECK: jr <cond>,` lines stop matching. **Mitigated** in
   `4f9d7b6` by relaxing the CHECK lines to `j{{[rp]}}`. Removes the
   fragility on every machine forever.
2. After merging origin, three *different* tests (`loop-counter-narrow.ll`,
   `bss-self-clear.ll`, `store-via-hl.ll`) fail in the same direction —
   this machine isn't picking up loop-counter narrowing / BSS-clear /
   store-via-HL peepholes that the other machine is. These are **not**
   relaxable; they show a real codegen difference at the same SHA.

Both observations point to a build-environment-dependent codegen
difference. Suspected causes (untested, see issue #69):

* `LLVM_ENABLE_ASSERTIONS` — this machine is built with assertions
  *off*. Toggling it via `cmake -DLLVM_ENABLE_ASSERTIONS=ON … && ninja`
  did not change the output, but ninja did not actually do a clean
  rebuild (only ~75 of ~3600 .o files recompiled, and `llc --version`
  still says `Optimized build.` with no assertions tag). A real test
  needs `rm -rf build && cmake … && ninja clang`, ~1.5 h on this box.
* Host C++ compiler version (this machine's GCC vs the other machine's
  Clang) producing slightly different LLVM binaries that pick different
  but deterministic choices in size-edge passes.
* Some other Release-build flag interacting with peephole ordering.

The session-12 BIOS/PROM end-to-end results are *not* affected — BIOS
builds at exactly the predicted size on both machines. The fragility
is confined to a handful of CHECK lines around size-edge peepholes.

#### Issue draft for #69

```
Title: Lit tests fail on Linux Release-no-asserts build at SHAs that pass on developer machine

At llvm-z80 main SHA 8f1e1d5 (and earlier 8f1e1d5's ancestors back at
least to 8896f598 "session 12: fix #58 JP→JR"), three lit tests fail
on a stock Linux Release build with assertions OFF, but pass on the
primary developer machine:

  LLVM :: CodeGen/Z80/loop-counter-narrow.ll
  LLVM :: CodeGen/Z80/bss-self-clear.ll
  LLVM :: CodeGen/Z80/store-via-hl.ll

These are *real* codegen differences, not test fragility. Example —
loop-counter-narrow.ll expects:

  ld   a,e
  cp   #7

but on the failing machine the function emits

  push af
  push af
  ld   de,#_buf
  ld   bc,#7
.LBB0_1:
  ld   l,c
  ld   h,b
  ld   a,l
  or   a
  jr   z,.LBB0_3
  …

i.e. the loop-counter narrowing peephole is not firing at all.

A separate, related fragility was found and fixed in 4f9d7b6:
branch.ll, fib.ll, and narrow-add-cmp.ll matched a literal `jr <cond>,`
on functions that sit at the JR ±127-byte range edge. The CHECK lines
were relaxed to `j{{[rp]}}` so either form is accepted, removing the
fragility.

Build environment on failing machine:
  - Ubuntu / Linux 6.17.0-20-generic
  - cmake from clang/cmake/caches/Z80.cmake (Release, no assertions)
  - LLVM_ENABLE_ASSERTIONS=OFF
  - Host compiler: GCC 15
  - llc --version reports: "Optimized build."

Suspected causes (untested):
  1. LLVM_ENABLE_ASSERTIONS=ON on the developer machine, gating
     code that has side effects on optimization decisions.
  2. Host C++ compiler difference (GCC vs Clang) producing slightly
     different LLVM binaries that pick different deterministic
     branches in size-edge passes.
  3. Some Release-build flag (LTO, PGO, NDEBUG-only paths) interacting
     with peephole ordering.

Reproduction:
  cd llvm-z80
  rm -rf build
  cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
  ninja -C build clang
  build/bin/llvm-lit llvm/test/CodeGen/Z80/

Expected: 50/50 pass.
Actual on this machine: 47/50 pass; the three above fail.

To investigate: clean rebuild with LLVM_ENABLE_ASSERTIONS=ON from
scratch (not just `cmake -DLLVM_ENABLE_ASSERTIONS=ON build` which
ninja does not propagate to all .o files). If that fixes it, the
peepholes have an assertion-side-effect bug. If not, swap the host
C++ compiler and rebuild.

End-to-end correctness is not affected: BIOS and PROM build to the
expected sizes on both machines.
```

## Completed

- [x] Phase 1: Direct global+offset addressing (-234B, 2352→2118)
  - `LD A,(sym+off)` instead of `LD rr,addr; LD A,(rr)`
  - Cascading: fewer spills → IX removal fires more
  - All 40 lit tests pass, MAME boot PASS

- [x] Comparison narrowing: i16 icmp through zext/sext → i8 (-12B, 2118→2106)
  - LLVM InstCombine widens i8 compares to i16 via zext/sext
  - ISel now looks through extensions for EQ/NE/unsigned/signed predicates
  - Applied in both materialized G_ICMP and fused compare-and-branch
  - All 40 lit tests pass, MAME boot PASS

- [x] **hasFP=false regalloc bug** (-72B, 2106→2034, FIXED)
  - **Root cause:** IX constant propagation peephole in Z80LateOptimization
    treated INC IX inside a loop body as a one-time adjustment (+1) to the
    initial LD IX,0. Replaced `PUSH IX; POP HL` (actual counter) with
    `LD HL,1` (constant), creating an infinite loop in `fdc_write_full_cmd`.
  - **Bisection:** Automated binary search over 25 non-ISR functions found
    `fdc_write_full_cmd` as the sole culprit in 6 rounds.
  - **Fix:** Check for back-edges (loop membership) in the INC/DEC IX handler.
    If the block containing INC/DEC IX has a successor with number <= itself,
    mark IX as non-constant to prevent folding.
  - **Files changed:** Z80LateOptimization.cpp (loop check), Z80FrameLowering.cpp
    (removed staticStack guard)
  - **Test:** ix-loop-const-prop.ll, all 41 lit tests pass, MAME boot PASS

## Remaining (prioritized)

- [x] Loop index→pointer conversion (-76B, 2025→1949)
  - Root cause was **Z80IndexIV pass**, not SROA. The pass converted
    pointer-increment GEPs (`gep ptr, 1` → INC HL, 1B) into base+index
    GEPs (`gep base, index` → LD HL,base; ADD HL,BC, 4+B).
  - Fix: skip Z80IndexIV when +static-stack is active (locals in BSS,
    not IX-relative, so IX+d indexed addressing has no benefit).
  - TODO: investigate whether Z80IndexIV helps non-static-stack code
    where IX+d indexed addressing is available.
  - Files changed: Z80IndexIV.cpp (static-stack guard)
  - All 42 lit tests pass, MAME boot PASS

- [x] PUSH/POP instead of BSS spills across CALLs (-8B, 2033→2025)
  - Post-RA peephole: LD (bss),A; CALL; LD A,(bss) → PUSH AF; CALL; POP AF
  - Conservative: only single store/single load pairs (multi-load re-PUSH
    caused stack interaction bugs between nested converted functions)
  - 2 instances fired: fdc_write_full_cmd, main_relocated
  - Multi-load pattern (fdc_seek, fdc_select: 2+ loads) deferred — needs
    investigation of stack depth interaction when multiple callers/callees
    are converted simultaneously
  - GR16 variant (PUSH HL/DE/BC) also supported but no instances in PROM

- [x] ~~OR (HL) / AND (HL) fusion~~ — not worth it, only 3 SDCC instances,
  clang's direct addressing is equivalent. Closed #12.

- [x] MAME boot test to verify PROM correctness (2026-03-27, SW1711-I8.imd)

- [x] Interleaved C source in clang listing (make clang_src_lis)

- [x] Investigate `clang -Weverything -c` on PROM sources — DONE: -Weverything default, zero warnings
- [x] ~~Experiment with HI-Tech C~~ — parked, not pursuing

## Remaining (prioritized)

- [x] Signed 16-bit comparison bloat (ravn/llvm-z80#19) — FIXED: -38B
  - `icmp sgt i16 X, 0` (and SLE X, 0) now uses branchless algorithm:
    non-negative mask (RLCA; SBC A,A; CPL) AND non-zero test (OR hi,lo)
  - Fused branch: 12B (was 34B). Materialized: 14B (was 30B).
  - Avoids the JP PO/JP P MBB split entirely — no MBB splitting needed.
  - PROM: 1944B → 1906B (-38B). Now 6B SMALLER than SDCC (1912B).

- [x] Multi-value BSS spill across CALL (ravn/llvm-z80#20) — partial: -5B
  - Fixed LIFO safety bug: PUSH/POP depth tracking prevents stack corruption
    when multiple spills convert in the same MBB
  - Fixed dangling PUSH bug: flags check moved before store replacement
  - Enabled multi-load re-PUSH: POP+PUSH after each load except last
  - Fired: fdc_select_drive_cylinder_head (2 loads, 5B), fdc_seek (2 loads,
    5B but gc'd — function inlined), main_relocated (1 load, 4B, pre-existing)
  - Net new savings: 5B (1949→1944)
  - Remaining unconverted: cross-MBB spills (wait_fdc_ready, verify_seek_result),
    cross-register (fdc_get_result_bytes: store BC, load HL)

- [x] +static-stack incorrect code in large functions (ravn/llvm-z80#29) — FIXED
  - Root cause: SPILL_IMM8 expansion in static-stack BSS mode clobbered A register
    without saving it. The pseudo has no implicit-def of A (correct for IX-indexed
    LD (IX+d),n expansion), but the BSS path uses LD A,imm; LD (addr),A.
  - Fix: check isRegLiveAt(A) and PUSH AF/POP AF when A is live, matching SPILL_GR8.
  - File: Z80RegisterInfo.cpp (eliminateFrameIndex, static-stack SPILL_IMM8 handler)
  - Edge-case tests: 25/25 pass (was 14/25), all 43 lit tests pass
  - Also expanded test generator with 4 inline test categories (31 total)

- [x] Multi-compiler comparison framework (compiler-zoo)
  - Python + Makefile framework comparing clang vs z88dk zsdcc
  - Uses PROM flags: +static-stack, +shadow-regs, -disable-lsr (clang);
    --allow-unsafe-read, --sdcccall 1, --max-allocs-per-node 1M (zsdcc)
  - Fair size comparison: CRT excluded from both compilers
  - T-states measurement via z88dk-ticks
  - Assembly listings with debug info (clang: -g + objdump -S, zsdcc: --fverbose-asm)
  - 10 benchmark programs from existing test suite
  - Results: clang wins 7/10 on size, zsdcc wins on 32/64-bit arithmetic
  - Found 4 clang correctness failures in large benchmarks (ravn/llvm-z80#30)
  - 3 distinct bugs identified:
    - Bug A: static-stack volatile spill/reload mismatch (PUSH vs BSS load)
    - Bug B: 32-bit arithmetic codegen (CRC-32 produces wrong result, not static-stack specific)
    - Bug C: infinite loop in string ops without static-stack
  - 4 zsdcc correctness failures too (div/mod, string ops)
  - Renamed edgecase-testing → test-gen, added --categories flag (31 cat files)
  - --full flag for including _cat_*.c files in comparison
  - Portable NOINLINE macro for cross-compiler category files
  - Fixed compare.py: z88dk-ticks -trace now pipes through tail -20 (prevented disk fill)
  - Fixed compare.py: z88dk:v2.4 → z88dk:2.4 tag

- [x] Build llvm-z80 clang natively on macOS (eliminate Docker for compilation)
- [ ] Get CLion remote development working for this project
- [x] Recalibrate DELAY_T for -Oz (or make delay() timing-independent) — DONE: delay_ms() macro + DELAY_T=16
- [ ] Build z88dk locally on macOS (eliminate Docker for SDCC builds)
- [ ] Simplify BIOS jump table IFDEF logic (REL14/REL20/HARDDISK conditional JP entries)
- [x] Clang PROM missing NMI handler (RETN) at 0x0066 — DONE: .nmi section in linker script
- [x] PROM delay() should take milliseconds — DONE: delay_ms(), z80_delay_ms() for SDCC
- [ ] Investigate how much code can be shared between autoload PROM and BIOS
- [ ] Investigate clang-only features (C17/C23, attributes) that could improve Z80 codegen
- [ ] Investigate if compare_6bytes could use CPI for more compact codegen
- [ ] Legacy boot reads to INTVEC_ADDR (0x7000) — assumes exactly 0x7000 bytes from disk. May be a latent bug if disk content differs
- [x] Investigate `clang -Weverything -c` on PROM sources — DONE: -Weverything default, zero warnings
- [x] ~~Experiment with HI-Tech C~~ — parked, not pursuing
- [ ] Per-pair 16-bit copy cost in register allocator (ravn/llvm-z80#27)
- [ ] Tail call blocked by PUSH in IY copy (prom1_if_present: PUSH DE; POP IY;
  CALL __call_iy; RET — HasPush check falsely blocks, 1B)
- [ ] `__attribute__((noreturn))` prevents tail-call JP optimization — start() calling
  noreturn main_relocated() emits CALL instead of JP, wasting 2 bytes (return addr push).
  Workaround: omit noreturn from declaration visible to caller.
- [ ] SDCC peephole rules not found at link time — `-custom-copt-rules=sdcc/peephole.def`
  fails because link step does `cd sdcc &&` making the relative path wrong

- [x] Boot banner missing (ravn/llvm-z80#51) — **FIXED** (asm BSS clear)
  - Root cause: +static-stack BSS self-clobber in relocate_bios()
  - Compiler stored p+1 pointer to BSS, then *p=0 zeroed the low byte
  - memcpy destination became $EB00 instead of $EB69, zeroing .rodata
  - Fix: inline asm BSS clear (no compiler locals → no BSS overlap)
  - Sentinel word (0x1842) added to linker script to catch future bugs
  - Bisected to commit 1fa0b125 (#45 direct addressing changed codegen)

- [x] SPILL_GR16/RELOAD_GR16 reject Anyi16 class (ravn/llvm-z80#52) — **FIXED**
  - getLargestLegalSuperClass returned Anyi16 (includes SP), spill pseudos
    only accepted GR16. Fixed by widening pseudos + restricting superclass.
  - Lit test: spill-regclass.ll

- [ ] +static-stack allocates trivially-constant locals to BSS (ravn/llvm-z80#53)
  - All locals go to BSS regardless of register pressure
  - SDCC only spills when needed — smarter approach

- [ ] Large function codegen incorrect without +undocumented (ravn/llvm-z80#38)
  - Original trigger (IX/IY allocation) fixed by reserving IX/IY
  - Banner manifestation (#51) was actually BSS self-clobber, not regalloc
  - May still have residual issues in other large functions

## Issues filed (ravn/llvm-z80)
- ravn/llvm-z80#19 — Signed 16-bit comparison bloat — **CLOSED** (branchless SGT X,0)
- ravn/llvm-z80#20 — BSS spill across CALL (~33B remaining: 5 functions)
- ravn/llvm-z80#21 — Redundant 16-bit loads for port I/O — **CLOSED** (source fix + peephole)
- ravn/llvm-z80#22 — 8→16 bit promotion in byte comparisons — **CLOSED** (narrow add+cmp through zext, -19B)
- ravn/llvm-z80#23 — Null ISR shadow-reg overhead (~4B)
- ravn/llvm-z80#24 — Missed RRCA/RET C conditional return — **CLOSED** (-6B)
- ravn/llvm-z80#25 — fdc_seek inlining bloat (~21B)
- ravn/llvm-z80#26 — IX callee-save transfer wastes bytes vs PUSH/POP — **CLOSED** (-4B)
- ravn/llvm-z80#15 — Loop index→pointer conversion — FIXED (Z80IndexIV disabled)
- ravn/llvm-z80#16 — PUSH/POP instead of IX-indexed spills (~8B remaining, was ~40B pre-optimization)
- ravn/llvm-z80#12 — OR/AND (HL) memory operand fusion (~10B)
- ravn/llvm-z80#17 — hasFP=false regalloc bug — FIXED
- ravn/llvm-z80#18 — Known-value register copy optimization
- ravn/llvm-z80#7 — DJNZ, LDIR, CPIR, CP (HL) (~7B from DJNZ in PROM)
- ravn/llvm-z80#27 — Per-pair 16-bit register copy cost (structural)
- ravn/llvm-z80#28 — O0 code generation failures in large functions
- ravn/llvm-z80#29 — +static-stack incorrect code in large functions — **CLOSED** (SPILL_IMM8 missing A save)
- ravn/llvm-z80#30 — Incorrect code in benchmarks: umbrella for #31, #32, #33
- ravn/llvm-z80#31 — Static-stack volatile spill via PUSH, reload from stale BSS
- ravn/llvm-z80#32 — 32-bit CRC-32: PUSH/POP IX copies corrupt SP-relative offsets (root cause found, fix reverted)
- ravn/llvm-z80#34 — Crash: passing i32 as function argument
- ravn/llvm-z80#33 — bench_string infinite loop without +static-stack
- ravn/llvm-z80#37 — Undocumented LD A,IYH emitted without +undocumented — **CLOSED** (SEXT16/SEXT_GR8/ZEXT_GR8 expansion fix)
- ravn/llvm-z80#38 — Large function codegen incorrect without +undocumented (layout-sensitive)
- ravn/llvm-z80#39 — IX constant propagation removes setup when +undocumented sub-reg reads present — **CLOSED** (IXH/IXL use detection fix)
- ravn/llvm-z80#51 — Boot banner missing (BSS self-clobber) — **FIXED** (asm BSS clear in boot_entry.c)
- ravn/llvm-z80#52 — SPILL_GR16/RELOAD_GR16 reject Anyi16 — **FIXED** (widen pseudos + restrict superclass)
- ravn/llvm-z80#53 — +static-stack allocates trivially-constant locals to BSS
- ravn/llvm-z80#54 — Fall-through JP elimination (6B)
- ravn/llvm-z80#55 — ADD HL,DE commutativity peephole — **CLOSED** (-6B)
- ravn/llvm-z80#56 — Shift-left-7 strength reduction — **CLOSED** (RRCA+AND, -4B)
- ravn/llvm-z80#57 — Comparison reversal peephole — **CLOSED** (-2B, post-RA)
- ravn/llvm-z80#58 — JP where JR suffices / branch relaxation — **CLOSED** (-4B, JP→JR in LateOpt)
- ravn/llvm-z80#59 — 16-bit loop counter where 8-bit suffices — **FIXED** (-2B, comparison only)
- ravn/llvm-z80#60 — Redundant LD A,reg when A unchanged — peephole implemented, 0B in PROM (cross-block)
- ravn/llvm-z80#62 — IV narrowing for loop counter register pair (4B)
- ravn/llvm-z80#61 — In-memory DEC (HL) / INC (HL) peephole — **CLOSED** (-6B)

## Parked (investigated, not worth pursuing now)

- [x] BIT n,A branch fusion — investigated, AND+JR patterns already efficient
  (same size as BIT+JR). The `xor $80; cp $40` pattern is a range check,
  not a single-bit test. PostRACompareMerge correctly handles redundant OR A.

- [x] 8→16-bit comparison promotion — this IS happening but the root cause
  is the loop index→pointer problem (Phase 2), not type legalization.
  The comparisons themselves are i8, but the loop counter and pointer
  arithmetic are i16 because of index-based GEP.

- [x] Known-value register copy / duplicate LD rr,imm (ravn/llvm-z80#18)
  - 0 instances in current PROM (eliminated by hasFP=false + direct addressing)
  - Revisit when working on rcbios-in-c (priority 2 test case)

## Metrics

| Date | SDCC | Clang | Gap | Change |
|------|------|-------|-----|--------|
| 2026-03-26 | 1912 | 2352 | 440 (23%) | baseline (post-merge) |
| 2026-03-27 | 1912 | 2118 | 206 (11%) | Phase 1: direct addressing |
| 2026-03-27 | 1912 | 2106 | 194 (10%) | Narrow i16 cmp through zext/sext |
| 2026-03-27 | 1912 | 2034 | 122 (6%) | hasFP=false: IX constant prop loop fix |
| 2026-03-27 | 1912 | 2033 | 121 (6%) | OR A; LD r,0 → LD r,A peephole |
| 2026-03-27 | 1912 | 2025 | 113 (6%) | BSS spill → PUSH/POP across CALLs |
| 2026-03-27 | 1912 | 1949 | 37 (1.9%) | Disable Z80IndexIV for +static-stack |
| 2026-03-27 | 1912 | 1944 | 32 (1.7%) | Multi-load BSS spill→PUSH/POP + LIFO fix |
| 2026-03-28 | 1910 | 1906 | -6 (-0.3%) | Branchless SGT X,0 optimization (#19) |
| 2026-03-28 | 1910 | 1893 | -17 (-0.9%) | DMA macro fix + high-byte peephole (#21) |
| 2026-03-28 | 1910 | 1874 | -36 (-1.9%) | Narrow add+cmp through zext to 8-bit (#22) |
| 2026-03-28 | 1910 | 1870 | -40 (-2.1%) | IX callee-save transfer → PUSH/POP (#26) |
| 2026-03-28 | 1910 | 1864 | -46 (-2.4%) | Branch-to-RET + RRCA/RLCA peepholes (#24) |
| 2026-03-28 | 1910 | 1872 | -38 (-2.0%) | COPY16_PUSHPOP pseudo for IX/IY copies (#32) |
| 2026-03-31 | 1910 | 1876 | -34 (-1.8%) | +undocumented, IX sub-reg const-prop (#37/#39) |
| 2026-03-31 | 1910 | 1853 | -57 (-3.0%) | Revert IX/IY allocation (#38), reserve both |
| 2026-04-01 | 1910 | 1842 | -68 (-3.6%) | #45 const-addr LD, #46 ptrtoint fold, #47 linker wrap |
| 2026-04-02 | 1910 | 1842 | -68 (-3.6%) | Fix #51 BSS self-clobber, #52 spill class. BIOS 5709B |
| 2026-04-02 | 1910 | 1842 | -68 (-3.6%) | Merge memcpy_z80 scroll, BIOS 5742B. TYPE 4.7% faster |
| 2026-04-02 | 1910 | 1842 | -68 (-3.6%) | CLion integration: __z80__ guards, MAME run configs |
| 2026-04-03 | 1910 | 1802 | -108 (-5.7%) | Native macOS build, delay_ms(), -Oz, dead code GC |
| 2026-04-03 | 1910 | 1791 | -119 (-6.2%) | Static inlining: fdc_seek, display_banner_and_start_crt |
| 2026-04-06 | 1910 | 1791 | -119 (-6.2%) | Gap analysis: 8 new issues (#54-#61), ~37B potential |
| 2026-04-06 | 1910 | 1789 | -121 (-6.3%) | Fix #59: narrow 16-bit loop compare to 8-bit CP (-2B) |
| 2026-04-06 | 1910 | 1785 | -125 (-6.5%) | Fix #56: SHL 7 via RRCA+AND (-4B) |
| 2026-04-06 | 1910 | 1779 | -131 (-6.9%) | Fix #55: ADD HL,DE commutativity (-6B) |
| 2026-04-06 | 1910 | 1777 | -133 (-7.0%) | Fix #57: comparison reversal peephole (-2B) |
| 2026-04-06 | 1910 | 1771 | -139 (-7.3%) | Fix #61: in-memory INC/DEC (HL) peephole (-6B) |
| 2026-04-06 | 1910 | 1767 | -143 (-7.5%) | Fix #58: JP→JR branch shortening (-4B), #60 peephole (0B) |

## Rejected: DMA-assisted screen scrolling

~~Am9517A memory-to-memory DMA for screen scroll~~ — **infeasible**: RC702 PCB DMA
channel wiring does not support memory-to-memory mode (ch0+ch1 are hardwired to
HD and floppy DREQ lines respectively, cannot be repurposed).

## Todo: Unified BIOS source across compilers

- Currently bios.c and other BIOS sources have several `#ifdef __clang__`
  / `#ifdef __SDCC` blocks for things like:
    - sio_wr5/sio_rd1 (clang uses port_out_rt, SDCC uses noinline split)
    - relocate_bios memcpy (clang uses __builtin_memcpy)
    - ISR helpers (clang uses bios_shims.s wrappers, SDCC uses inline asm)
- Goal: keep bios.c, bios_hw_init.c, boot_entry.c as pure portable C with
  no per-compiler `#ifdef`. Move all compiler-specific differences into
  per-compiler files (e.g., clang/bios_compat.h, sdcc/bios_compat.h)
  loaded via `-include` or via the Makefile.
- Builds on the "unified port I/O API" todo.
- Future work, not priority

## Todo: Inline ISR routines in clang to avoid wrapper CALL overhead

- Currently clang ISRs use a wrapper function (e.g., `isr_crt_wrapper`)
  defined in `bios_shims.s` that does register save/restore in assembly,
  then `call`s the C function `isr_crt`.
- This adds CALL overhead per interrupt: 3 bytes + 17 T-states for call,
  3 bytes + 10 T-states for ret.
- Investigate whether clang can inline the C ISR body directly into the
  wrapper, or use `__attribute__((interrupt))` directly so the C function
  IS the entry point (with proper register save/restore generated).
- Z80 backend supports `__attribute__((interrupt))` — check if it generates
  the right prologue/epilogue for IM2 ISRs that need to switch stacks.
- Future work, not priority

## Todo: Full debug info in SDCC BIOS build

- Currently SDCC produces `bios.lis` that's just the section layout asm,
  not a full instruction-level disassembly with source line annotations.
- The user found `bios.c.lis` in some other location with proper listing,
  but it isn't generated by the standard `make -C sdcc` flow.
- Investigate z88dk/SDCC flags to produce a complete listing showing
  source-line ↔ generated asm correlation, similar to what `clang -g +
  llvm-objdump -dS` provides.
- This would help debug compiler issues and verify codegen across compilers.
- Future work, not priority

## Todo: Unified port I/O API across compilers

- Currently port I/O for runtime addresses works only in clang (via
  the `__io` address_space(2) mechanism + #44 fix → OUT (C),A).
- SDCC has no clean pure-C way to do runtime port I/O — `__sfr` requires
  constant addresses. Inline asm helpers can't be `static inline __naked`
  without SDCC pasting the `ret` and breaking the caller (cf. session 12
  bug in sio_wr5).
- Code that needs runtime port selection (e.g., sio_wr5 picking SIO
  channel A or B) currently needs `#ifdef __clang__` per-compiler paths.
- Goal: design a `port_in_rt(p)` / `port_out_rt(p, v)` abstraction that
  works in both compilers in pure C, OR settle on a portable inline asm
  pattern that doesn't trip the SDCC inliner.
- Future work, not priority

## Todo: Comprehensive BIOS test suite via MAME

- Build a comprehensive test case exercising all CP/M BIOS jump table
  entries (BOOT, WBOOT, CONST, CONIN, CONOUT, LIST, PUNCH, READER, HOME,
  SELDSK, SETTRK, SETSEC, SETDMA, READ, WRITE, LISTST, SECTRAN)
- Run automated via MAME with deterministic assertions on results
- Cover edge cases: disk sector wrap, multi-track operations, console
  control characters, status polling
- Ideally generates pass/fail report like the autoload-in-c MAME boot test
- Future work, not priority

## Todo: PROM legacy ID-COMAL disk support

- Make the PROM work with legacy id-comal disks
- Need to investigate the id-comal disk format and what changes are needed
  in fdc_detect_sector_size_and_density / disk format tables
- Future work, not priority

## Todo: QR code on RC700 screen

- Display a QR code on the RC700 CRT using semigraphic characters (2×3 block mosaic)
- The RC700 character ROM includes semigraphic characters that divide each cell into a 2×3 grid of pixels
- Each semigraphic character encodes 6 "pixels" per cell, giving ~160×72 effective resolution on 80×24
- Need: QR code generator (C, must fit in PROM or CP/M .COM), semigraphic character mapping
- This is a future/fun project, not priority

## Todo: z88dk

- Add +cpmdisk support for RC700 to z88dk
- Add semigraphics character rendering support for RC700 to z88dk

## Todo: CONOUT speed

- [x] #50: memcpy_z80 — 16xLDI Duff's device for scroll() (MERGED)
  - 20% faster per-byte (16T vs 21T), 4.7% end-to-end on TYPE FILEX.PRN
  - Cycle test: 170.9M → 162.8M cycles

- Hardware scroll via split-DMA (from ROA375 PROM analysis):
  The original asm PROM uses **zero-copy hardware scrolling**:
  - Display buffer at DSPSTR (0xF800) treated as circular buffer
  - SCROLLOFSET variable tracks where visible screen starts
  - Ch2 (high priority): DMA from DSPSTR+S to end (2000-S bytes)
  - Ch3 (low priority): DMA from DSPSTR for wrap-around (S bytes)
  - 8275 CRT requests 2000 chars/frame; ch2 serves tail, ch3 serves head
  - Scroll = update SCROLLOFSET (one word write) — no memory copy at all
  - Requires ch2 number < ch3 number (Am9517A priority: lower ch = higher)
  - The C BIOS currently copies 1920 bytes per scroll (memcpy_z80)
  - Implementing this in C would eliminate scroll CPU cost entirely
  - Complications: insert_line/delete_line need to modify the circular
    buffer correctly; clear_screen resets offset to 0; cursor addressing
    must account for the offset
  - DMA channel assignments are now configurable (feature/dma-channel-config)

- DMA-assisted memory-to-memory scroll (alternative approach):
  - Am9517A memory-to-memory mode: ch0 (source) + ch1 (dest), software request
  - No DREQ lines needed — triggered by writing to request register (port 0xF9)
  - Would still copy memory but via DMA instead of CPU (frees CPU during copy)
  - Requires ch0+ch1 free during scroll (no concurrent disk I/O — safe in CONOUT)
  - Less benefit than hardware scroll but simpler to implement

## BIOS size gap analysis (session 12, 2026-04-06/07)

**Clang 5861B vs SDCC 5797B (+64B, +1.1%)**
Started at 5952B (+155B, +2.7%). Reduced by 91B through compiler + source fixes.

### Current per-function gap (post-fixes)

Clang larger (+395B total across these functions):

| Function | Clang | SDCC | Gap | Root cause |
|---|---|---|---|---|
| sec_rw | 287 | 115 | **+172** | BSS round-trips, struct access, 16-bit on 8-bit |
| bg_clear_from | 279 | 209 | **+70** | BSS round-tripping, register allocation |
| rwoper | 262 | 203 | **+59** | Duplicated sector-offset calc, BSS round-trip |
| bios_list_body | 70 | 33 | **+37** | |
| bios_conin | 90 | 73 | +17 | |
| bios_const | 42 | 28 | +14 | |

Clang smaller (-164B total): terminal group (-44), bios_hw_init (-42),
isr_pio_kbd (-23), isr_sio_a_rx (-23), isr_crt (-16), bios_seldsk_c (-10).

### Compiler fixes applied in session 12

| # | Fix | Savings |
|---|-----|---------|
| 62 | Constant fold G_PTR_ADD(GV, const) → LD rr,sym+off | -12B |
| 63 | SUB/AND/OR/XOR (HL) memory operand fusion | -15B |
| 64 | INC/DEC (HL) peephole: handle RET + fallthrough | -3B |
| 65a | DJNZ peephole: DEC A; LD B,A; [OR A;] JR NZ | -0B (no eligible BIOS loops) |
| 65b | G_UADDO/G_USUBO legal for i8 (prevent 8→16 widening) | -0B (BIOS loops use explicit cmp) |
| 68 | Prefer cascaded branches over jump tables for ≤7 cases | **-46B** |

### Source-level fixes applied in session 12

| Change | Savings |
|--------|---------|
| `cursorxy()` → static inline (11 call sites) | -11B |
| `hstsec`, `sekhst` word → byte | -3B |
| `serial_conout` timeout word → byte | -1B |
| `fdc_result` loop → pointer-based countdown | -0B |

### Remaining open issues

| # | Issue | Est. impact | Notes |
|---|-------|-------------|-------|
| ~~66~~ | ~~BSS static-stack SP-relative access~~ | ~~~30B~~ | **FIXED** session 12: SP-relative pattern + redundant PUSH AF/POP AF + global store-reload forwarding. BIOS 5861→5843B (-18B). |
| 67 | sec_rw 2.5x SDCC | ~50B | Compound of BSS reloads, missing idioms, regalloc |
| — | Register allocation pressure | ~30B | Clang spills more conservatively than SDCC |

The remaining 46B gap is now dominated by sec_rw (+172B) partially offset
by clang wins elsewhere (-164B − the -18B from #66).

## Todo: CLion debugger via MAME gdbstub

**Done (session #9):**
- [x] CLion fully indexes BIOS via `__z80__` guards (HOST_TEST removed)
- [x] .clangd: `-xc -std=c99 -Iclang -DMSIZE=56` + warning suppressions
- [x] 6 persistent run configurations in .idea/runConfigurations/
- [x] MAME GDB Stub run config (`run_mame.sh -g`)
- [x] Port I/O stubs use volatile (CLion doesn't assume constant zero)
- [x] bios_sources EXCLUDE_FROM_ALL (Build All doesn't try host compile)

**Remaining:**
- [ ] Build z80-elf-gdb from binutils-gdb for source-level debugging
  - `./configure --target=z80-unknown-elf` + `make all-gdb`
  - CLion Remote GDB Server: z80-elf-gdb + bios.elf + localhost:23946
- [ ] Fallback: enhance gdb_trace.py with pyelftools DWARF source mapping

## Todo: MAME DMA port assignment from emulated code

Currently MAME's RC702 driver hardcodes the DMA channel-to-device wiring
(which DREQ/DACK lines connect to which peripheral). Investigate whether
the emulated Z80 code can configure this dynamically instead:
- Can the Am9517A DMA mode register writes in MAME's 8237 emulation be
  observed to infer which channel is used for what?
- Does MAME's rc702.cpp wire DREQ/DACK lines at machine config time?
  If so, can this be made software-configurable?
- The RC702 hardware has fixed PCB traces for DREQ routing — the software
  can't change which peripheral triggers which DMA channel. But MAME
  emulation doesn't need to follow this constraint.
- Goal: allow the BIOS C code to use different channel assignments without
  also modifying the MAME driver source.

## Todo: MAME DMA port assignment from emulated code

Currently MAME's RC702 driver hardcodes the DMA channel-to-device wiring
(which DREQ/DACK lines connect to which peripheral). Investigate whether
the emulated Z80 code can configure this dynamically instead:
- Can the Am9517A DMA mode register writes in MAME's 8237 emulation be
  observed to infer which channel is used for what?
- Does MAME's rc702.cpp wire DREQ/DACK lines at machine config time?
  If so, can this be made software-configurable?
- The RC702 hardware has fixed PCB traces for DREQ routing — the software
  can't change which peripheral triggers which DMA channel. But MAME
  emulation doesn't need to follow this constraint.
- Goal: allow the BIOS C code to use different channel assignments without
  also modifying the MAME driver source.

## Todo: Sync MAME port map with BIOS port definitions

The MAME RC702 driver (`rc702.cpp`) hardcodes I/O port addresses in its
`io_map()` function (e.g. CRT at 0x00, FDC at 0x04, DMA at 0xF0). These
must match the `PORT_*` constants in `hal.h`. Currently they're maintained
independently — changing a port in one place requires manually updating
the other.

Investigate:
- Can MAME's rc702.cpp read port assignments from a shared header or
  generated file that's also used by the BIOS build?
- Or: generate the MAME io_map() fragment from hal.h at build time
  (e.g. a Python script that parses #define PORT_* and emits C++ map calls)
- Or: have the MAME driver read port assignments from the PROM binary
  itself (a configuration table embedded in the ROM)
- Note: DMA channel assignments (DMA_CH_*) affect which DREQ/DACK lines
  connect to which peripheral in MAME — this is separate from port addresses
  but also needs to stay in sync

## Todo: 26th status line via DMA split

Investigate using the ch2/ch3 DMA split to display a 26th status line
sourced from a separate memory region, without the 8275's 25-row limit:

- The 8275 CRT controller can be programmed for 26 rows instead of 25
- The DMA split (ch2 tail, ch3 head) could point ch3 at a status buffer
  located outside the 2000-byte display area at 0xF800
- The status line buffer must NOT overlap with the work area (0xFFD0+)
  or BSS variables
- Possible location: below display memory (e.g. 0xF750, 80 bytes)
  or in a gap between BIOS BSS end and the display buffer
- Content: drive letter, user number, current track, free space, etc.
- The circular scroll approach already uses the ch2/ch3 split — the
  status line would be a third segment. Check if this is feasible
  with only two DMA channels, or if the status line replaces the
  wrap-around (meaning the scroll buffer shrinks to 1920 bytes +
  80-byte status line = 2000 bytes, no wrap needed)
- Alternative: use the 8275's built-in "end of screen" row with a
  fixed DMA source address (simpler but may require 8275-specific setup)

## Todo: Circular display buffer via DMA split (zero-copy scroll)

The ROA375 PROM already does this — investigate implementing it in the C BIOS:

- Display buffer at DSPSTR (0xF800) is a 2000-byte circular buffer
- SCROLLOFSET tracks where the visible screen starts (0..1999)
- Ch2 (high priority): DMA from DSPSTR+S to end of buffer (2000-S bytes)
- Ch3 (low priority): DMA from DSPSTR for wrap-around (S bytes)
- Scroll up = add 80 to SCROLLOFSET (mod 2000) — no memory copy
- The isr_crt() already reprograms ch2/ch3 every frame at 50Hz
- Just needs to compute the split addresses from SCROLLOFSET

Impact on CONOUT:
- scroll(): set SCROLLOFSET += 80, memset new bottom row — no memcpy
- displ(): screen[locad] must account for circular offset
- insert_line/delete_line: need to work within circular buffer
- clear_screen(): reset SCROLLOFSET = 0, memset entire buffer
- cursor addressing: locad = (cury + curx + SCROLLOFSET) % 2000

Prerequisite: remove BGSTAR (background semigraphics overlay) support.
BGSTAR maintains a parallel 250-byte bitmap that shadows display memory
and must be scrolled in sync. With a circular buffer, keeping BGSTAR
in sync adds complexity for no practical benefit — BGSTAR is an RC702
demo feature, not used by any CP/M application.

Estimated speedup: eliminates 1920-byte copy entirely (currently 31950T
with memcpy_z80, would become ~100T for offset update + 80-byte memset).
That's ~99.7% reduction in scroll CPU cost.

## Todo: Build variants — compatible and fast

Two BIOS variants from the same source, each in its own output directory:

- `clang/` — compatible: all features (BGSTAR, memcpy scroll), drop-in
  replacement for original BIOS, 100% feature parity
- `clang-fast/` — optimized: circular DMA scroll, no BGSTAR, tuned for
  interactive terminal use (editing, compiling, TYPE)
- Same for SDCC: `sdcc/` and `sdcc-fast/`

Implementation:
- `VARIANT ?= compatible` (default) in Makefile
- `make bios` → `clang/bios.cim` (compatible)
- `make bios VARIANT=fast` → `clang-fast/bios.cim`
- Fast variant adds `-DFAST_SCROLL` to CFLAGS
- Source uses `#ifdef FAST_SCROLL` to select circular buffer vs memcpy
- Each variant directory has its own sub-Makefile (or shared with extra flags)
- MAME targets respect VARIANT: `make mame-maxi VARIANT=fast`

## Reference: z88dk-dis

Linear Z80 disassembler in z88dk Docker image. Reads `.map` files for symbol labels.
Usage: `z88dk-dis -mz80 -o 0x0000 -x sdcc/bios.map sdcc/bios.cim`
Limitation: no data/code distinction — disassembles everything as instructions.
The SDCC `.lis` files and `llvm-objdump -d` for clang are better for routine analysis.
Useful for quick spot-checks of specific address ranges in raw `.cim` binaries.

## Reference: Getting T-states from compiler output

### SDCC (via z88dk)
Add `-Cs"--fverbose-asm"` to ZFLAGS. This makes sdcc annotate each
instruction with its T-state count in the `.c.asm` intermediate file.
The `.c.asm` files are generated during compilation but may be cleaned
by z88dk. To preserve them, add `--list` to the final link step or
compile with `-S` to get assembly only.

Example: `zcc ... -Cs"--fverbose-asm" -S bios.c -o bios.c.asm`

### Clang (LLVM-Z80)
The clang Z80 backend does not emit T-state annotations.
Use the Z80 instruction timing table:
- LD r,r: 4T | LD r,n: 7T | LD r,(HL): 7T | LD (HL),r: 7T
- LD rr,nn: 10T | LD (nn),A: 13T | LD A,(nn): 13T
- OUT (n),A: 11T | IN A,(n): 11T | OUT (C),r: 12T
- LDIR: 21T/byte (16T last) | LDI: 16T
- PUSH: 11T | POP: 10T | CALL: 17T | RET: 10T
- JR: 12T (taken) / 7T (not taken) | JP: 10T

### z88dk-ticks
For measuring actual T-states of a code path, use z88dk-ticks
emulator with `-end` at the target address. See TICKS.md in
z80-utils/test-gen/.

## Reference: isr_crt timing analysis

The CRT display refresh ISR runs at 50Hz (every 20ms). Timing from
clang bios.lis instruction analysis:

| Section | T-states | Notes |
|---------|----------|-------|
| CRT status read | 11T | acknowledge interrupt |
| DMA ch2/ch3 mask | 36T | mask both channels |
| Clear byte pointer | 15T | |
| Ch2 addr + word count | 58T | DSPSTR=0xF800, 2000 bytes |
| Ch3 word count | 26T | zero (no attributes) |
| DMA ch2/ch3 unmask | 36T | enable transfer |
| **DMA subtotal** | **~198T** | |
| Wrapper (SP save, EXX) | ~40T | isr_crt_wrapper overhead |
| Cursor update (if dirty) | ~60T | 3 port writes |
| Timer/blanking logic | ~80T | clktim, screen blank |
| **Total per invocation** | **~320-380T** | |
| **Per second (50Hz)** | **~16,000-19,000T** | ~0.4-0.5% CPU at 4MHz |

With FAST_SCROLL (circular buffer): the DMA section grows by ~40T for
computing split addresses from SCROLLOFSET (negate, add, two address
sets instead of one fixed). Total ~360-420T per invocation. Negligible
difference — the ISR cost is dominated by the port I/O, not arithmetic.

## Todo: Make CONFI.COM settings configurable in BIOS source

Currently the CONFI.COM configuration block (128 bytes at disk Track 0
offset 0x80) controls serial port settings, cursor size/blink, keyboard
mapping, and other hardware parameters. The BIOS copies this block to
CFG_ADDR (0xD500) at cold boot and reads fields from there at runtime.

The defaults are hardcoded in boot_confi.c as a binary blob. Make these
human-readable and configurable:

- Map the full 128-byte ConfiBlock layout (which bytes control what)
- Define named constants/struct fields for each setting
- SIO configuration: baud rate, data bits, parity, stop bits, handshaking
- CRT cursor: size (underline/block), blink rate, visibility
- Keyboard: repeat rate, click, national character set selection
- DMA mode values for each channel
- Any other hardware parameters controlled by CONFI.COM

Goal: change a #define in the BIOS source instead of running CONFI.COM
on the target machine. The ConfiBlock struct in bios.h already has some
field definitions — extend it to cover all 128 bytes with documented fields.

## Todo: Remove unnecessary type casts in bios.c

Several variables store addresses as `word` instead of proper pointer types,
requiring casts at every use. Changing them to pointers removes casts and
improves type safety:

- `dskad` (word → byte *): DMA buffer address, flows into flp_dma_setup()
- `dmaadr` (word → byte *): CP/M DMA address, used in memcpy for sector I/O
- FSPA struct initializers: `(DPB *)&dpb0`, `(byte *)tran0` — align field types
- `(byte *)&rstab` at line 315 — use proper fdc_result_block pointer

Ripple: dskad/dmaadr changes affect flp_dma_setup (port writes take low/high
bytes), memcpy calls, and hstbuf indexing. Not trivial but straightforward.

## Todo: 26-line display with status line (feature/26-line-status)

Plan complete. Implementation in 3 phases:

- [ ] Phase 1: CRT26 flag + DMA split (ch2: 2000B display, ch3: 80B status from BSS)
  - Modify PAR2 in bios_hw_init.c (SUB 0x3F for 26 rows)
  - Add hal_dma_atr_addr macro to hal.h
  - Update isr_crt: program ch3 address+wc for status buffer
  - Add CRT26 build flag to Makefiles
  - MAME: should work without driver changes (8275 recompute_parameters)
- [ ] Phase 2: Status line driver (callback-based, clock display)
- [ ] Phase 3: Interactive status line (SystemRequest key menu)

See: rcbios-in-c/tasks/26-line-status.md

## Todo: Serial transfer to physical RC700

- [x] Serial transfer pipeline working (2026-04-05)
  - Linux + pyserial + RTS/CTS + per-line flush: reliable at 38400 baud
  - BIOS-only hex (363 records, ~24s) via MLOAD+BDOSCCP.COM workflow
  - 16-bit checksum validator, drain-to-empty RTS flow control
- [x] RTS flow control: drain buffer to empty before re-asserting (59 vs 5300 CTS drops)
- [x] macOS FTDI: confirmed broken tcdrain() — use Linux for transfers
- [ ] IOBYTE support in BIOS for remote console via serial
- [ ] Investigate 115200 baud (SIO WR4 clock mode change)
- [ ] Build proper FTDI↔RC700 cable (see rcbios-in-c/docs/serial_cable_wiring.md)
- [ ] macOS: investigate pyftdi for direct FTDI USB control (bypass kernel driver)
- [ ] Investigate serial communication optimization (Z80 struggles with per-character interrupts at 38400)
- [ ] Investigate switch vs if-then-else codegen for Z80 (IOBYTE dispatch adds 240B, may be reducible)
- [ ] Investigate if a PC with traditional RS-232 serial port works with current cable
  - The FTDI needs rtscts=True + per-line flush() on Linux
  - A real 16550 UART handles CTS in hardware natively — may just work with crtscts
  - Check if the mini adapter pinout is compatible with a PC DB-9 COM port

## Future / Fun

- [ ] Fast storage peripheral for RC700 — two approaches under investigation

  **Option A: Parallel port (PIO-A, DB-25) — simpler, no internal mods**
  - Z80 PIO byte mode: 8 data bits + hardware handshake (ASTB/ARDY), ~100-200 KB/s
  - Needs 5V-capable MCU (or Pico + 74HCT245/74LVC245 level shifters)
  - Protocol: command byte → LBA address → 128-byte sector transfer, PIO handshake paces each byte
  - MCU provides SD card storage, responds to READ_SECTOR/WRITE_SECTOR commands
  - CP/M side: custom block driver replacing or supplementing FDC
  - Reference projects:
    - **ParPortProp** (N8VEM/RetroBrew) — Propeller on Z80 PIO, provides SD+serial+keyboard
    - **Amstrad Symbiface** — external peripheral via PIO, IDE/CF storage
    - **Commodore sd2iec** — excellent command/response protocol design over parallel-like bus
    - **PC parallel ZIP/Jaz** (EPST/Shuttle protocol) — multiplexing over limited parallel interface
  - Hardware candidates: Pico + level shifters ($10 BOM), STM32F103 Blue Pill (5V tolerant inputs), Arduino Mega (native 5V)

  **Option B: Z80 bus via J8 connector — faster, full bus access**
  - J8 exposes complete Z80 bus (address, data, control signals)
  - Needs 5V-capable device responding within Z80 bus timing (IORQ/MREQ, WAIT)
  - Could appear as native I/O-mapped device, no PIO overhead
  - Reference projects:
    - **RC2014 CompactFlash** — CF in IDE mode, direct I/O port access (simplest)
    - **Z80-MBC2** — ATmega32A on Z80 bus with active WAIT generation, SD storage
    - **PropIO v2** — Propeller on bus, 5V tolerant, 8 cogs handle timing without WAIT
    - **RomWBW** — CP/M BIOS framework with drivers for IDE/CF/SD/PropIO
    - **NABU-LIB/CloudCP/M** — RP2040 on Z80 bus via 74LVC245 transceivers, PIO state machines
    - **Teensy-Z80** designs — Teensy + bus transceivers monitoring IORQ/RD/WR
  - Hardware candidates: FPGA (iCE40 + level shifters), RP2040 + bus transceiver, 5V-tolerant MCU
- [ ] QR code generator using semi-graphics (block characters for Z80 terminal output)
- [ ] Initialize custom character generator ROM (SEM702) from BIOS
  - Character generator defined in roa375/PHE358A.MAC
  - Some BIOS versions reprogram it at boot for custom character sets
- [ ] Prepare PROM1 (ROA327) binary for SEM702 character generator loader
  - load_chargen in autoload PROM expects a properly prepared PROM1 at 0x2000
  - Need to build/extract the correct ROM image with the right font data and bit order
- [ ] Printer support in the MAME rc702 driver so printer output is captured to a file
  - Purpose: capture LST:/printer output somewhere when SIO-B is NOT being used to drive
    debug I/O (currently SIO-B doubles as the debug/console channel; a real printer sink
    frees it and lets us verify programs that print)
  - Likely a printer/paper-tape device wired to the printer port, with a `-bitbN file` sink

## Plan: rc7xx-work#8 — Watcom-native float/double on CP/M-86 (RC759, no 8087)

### Goal & oracle (first priority = Watcom's OWN tests)
Prove Open Watcom's UNCHANGED float/double path runs on CP/M-86 through our thin
Layer-2 seam, using **Watcom's own float regression tests** (bld/ctest/positive/
source/float01–04.c, self-checking via fail.h/_PASS — an independent, Watcom-
authored oracle) as the primary proof. Whetstone is bonus only.

### Verified findings (KNOWN, this session)
- Watcom 8086 float == the 8087 EMULATOR. `-fpi`/`-fpc` both emit real 8087 ESC
  opcodes (fld/fadd/fmul/fstp, FWAIT-prefixed 0x9B). There is NO pure-integer
  softfloat in the 8086 clib. `fpuemu/i86/asm/emu8087.asm` is the pure-software
  interpreter (0 native 8087 opcodes) that executes the trapped ops.
- Dispatch: the ESC opcodes carry emulator FIXUP records. wlink (with emulation)
  rewrites FWAIT+ESC → INT 0x38–0x3D targeting emulator entries (FIARQQ/FISRQQ/
  FIDRQQ/FIWRQQ/FICRQQ/FIERQQ/FJ*RQQ, published by initemu.asm).
- Vector install is DOS-coupled: initemu.asm `xchg_vects` uses INT 21h (fn 35h/25h
  get/set-vector). **INT 21h is fatal here** — must be reseamed to a direct IVT
  poke (INT n vector lives at physical 0x0000:n*4; 0x38→0x00E0 … 0x3D→0x00F4; no
  clash with BDOS INT 0xE0 whose vector is at 0xE0*4=0x380).
- %f/%g needs the REAL formatter (setefg.c/dsetefg + mathlib efgfmt.c/ldcvt.c),
  pulled by the `_fltused` reference; the integer-only builds used the noefgfmt stub.
- Transcendentals (sqrt/sin/cos/exp/log/atan) live in mathlib/{a,c}; the -fpc
  interface symbols are IF@DSIN/IF@DSQRT/… .

### Make-or-break spike (do FIRST, cheap)
S0. Link a minimal `-fpi` float program as `format cpm86` with emu8087 + initemu
    (minus DOS init) and confirm the linked .CMD contains INT 0x38–0x3D (i.e. wlink
    cpm86 actually performs the emulator FWAIT→INT conversion) and NOT raw ESC.
    - If wlink cpm86 IGNORES emulator fixups → fall back: force `-fpc` calls +
      provide a non-ESC software FD library, OR patch fixups post-link. Re-plan.
    - Also confirm INT 0x38–0x3D vectors are free/writable under emu2 AND MAME
      rc759 (Concurrent CP/M-86) — spike a tiny vector-poke+trigger.

### Implementation steps (after spike is green)
1. **Emulator link closure** (fp-emu-link): compile fpuemu/i86 emu8087 + support
   (flda/fldd/fsld/normdw/… as pulled) for 8086; resolve the FIARQQ/FI*RQQ entry
   symbols. Empirical undefined-symbol loop (as in the stdio milestone).
2. **CP/M-86 emulator-init seam** (fp-vec-seam): new `port/emu87cpm.asm` (or .c)
   that installs the INT 0x38–0x3D vectors by writing the IVT directly (segment
   0, offset n*4 = emu entry), replacing initemu's INT-21h xchg_vects. Called from
   crt0/`__InitFiles`-analogue before first float op. Zero INT 21h.
3. **mathlib closure** (fp-mathlib): sqrt/sin/cos/exp/log/atan + real %f path
   (setefg/efgfmt/ldcvt + _uatof/_ustrtod if scanf-side needed). Resolve IF@DSIN
   etc. Keep -fpi so they route through the emulator too.
4. **Relink Watcom's own tests** (fp-owtests): compile float01–04.c with
   `-Dmain=owfloat_main` + a scbport-style driver that calls each, prints a single
   `FLOATtest: PASS`/`FAIL line N` marker (via the proven printf), returns count.
   Build script mirrors build-stdio.sh; purity gate asserts INT21h==0, INTE0h>0.
5. **Run-verify**: emu2 (expect zero `failure on line` output → PASS) + MAME rc759
   cross-check (mame_done score = error count, expect 0). Byte-oracle = the tests'
   own self-checks; independent of our seam by construction.
6. **Bonus** (fp-whet): double Whetstone driver with known-value oracle (T=0.499975
   etc.) for an RC759-comparable float score vs DR C.
7. **Docs**: README float section + memory note; mark #3 "retired on the Watcom
   route" and update #8 acceptance boxes when green.

### Risks
- R1 (highest): wlink cpm86 may not emulate fixups → spike S0 gates everything.
- R2: INT 0x38–0x3D may be reserved by Concurrent CP/M-86 XIOS → may need a
  different free vector range; the emulator INT numbers are compiler/linker-fixed,
  so a clash forces a post-link fixup remap. Verify in S0.
- R3: emulator may reference a DOS control-word/init symbol beyond xchg_vects
  (__dos87emucall/__8087cw) — audit initemu/dosinit; provide CP/M stubs.
- R4: emu2's own float handling — must confirm emu2 does NOT silently provide an
  8087 (would make emu2 PASS while real HW fails). MAME rc759 is the true oracle.
