> **Status 2026-11-02:** S1–S4 are implemented and tested on local branches (see
> `tasks/patches/llvm-z80-intrinsics-static-frames-2026-11-02/` and
> `tasks/memory/project_z80_intrinsics_static_frames_2026-11-02.md`). S5 (firmware) partly done,
> S6 (#413) deferred. Written by an Opus subagent (model output, partly verified).
> Decisions by the user: high port byte unspecified; three im builtins; #413 wait; mid-body ei in ISR: not present in firmware today.

# Plan: Z80 machine instructions from C, keeping static frames

Status: PLAN ONLY (read-only analysis, 2026-11-02). Nothing here is implemented,
committed, pushed or filed.

## Executive summary

1. **Root cause.** The `llvm.z80.*` intrinsics lack `nocallback`. LLVM's CallGraph (CallGraph.cpp:93) therefore gives each one an edge to CallsExternal. Z80NonReentrant then sees a cycle through `main` and puts any function using them on the stack.
2. **S1 is the minimal fix:** add `IntrNoCallback` to the six existing intrinsics. It is verified by proxy without a rebuild: `nocallback` alone flips `main` to `norecurse "nonreentrant"`.
3. **No memory-semantics change is needed.** NoMem+HasSideEffects is already memory(unknown) in IR (IntrinsicEmitter.cpp:496-503), so IN/OUT/DI/EI stay full compiler barriers.
4. **S2:** select constant ports as `in a,(n)` / `out (n),a`, which saves 2 B per access compared with `ld c,n; in r,(c)`.
5. **S3:** add the missing `IM n` and `LD I,A` intrinsics, and fix `LD_I_A` lacking `Uses=[A]` (the cause of #419).
6. **S4:** restore the `__builtin_z80_*` clang builtins that firmware headers already call and that are absent on main. The `intrinsic_*` mapping lives in firmware headers and z88dk's `intrinsic.h`, never in a generic clang resource-dir `intrinsic.h`.
7. **S5:** firmware headers compile against main again; measure bytes and static-frame wins; boot-gate via Makefile targets only.
8. **S6:** keep the #413 inline-asm edge filter until no production asm remains. It is incomplete because Z80StaticFrameAlloc does not filter, which costs frame overlap. It is also unsound for asm that calls.
9. Every compiler stage is a small, independently mergeable branch in ravn/llvm-z80 with a lit test, and both test tiers run before and after.
10. Upstream filing (S1 first, as a bug report with a reproducer) needs a per-filing explanation and the user's explicit go-ahead.

## 1. Goal and non-goals

**Goal.** C code for the four firmware components can emit DI, EI, HALT, NOP, IN, OUT, IM n and LD I,A:
- without inline asm;
- without losing `+static-frame` / `-z80-static-frames` (`nonreentrant`) frames;
- from one source that also builds with SDCC/z88dk (`intrinsic_*` names).

The headers that call `__builtin_z80_*` must compile against llvm-z80 `main` again:
- `autoload-in-c/rom.h`
- `autoload-in-c/clang/intrinsic.h`
- `rcbios-in-c/hal.h`
- `rcbios-in-c/clang/intrinsic.h`
- `cpnos-in-c/src/hal.h`
- `cpnos-in-c/compiler/compat.h`

**Non-goals.**
- Restoring `address_space(2)` / AS_IO port lowering (the user decided against it).
- A new language feature (`__sfr`-like syntax).
- RETI/RETN/RST/EXX intrinsics. ISR return is already handled by the `interrupt` attribute.
- 16-bit port addressing via BC.
- SM83 support beyond keeping it compiling.
- Upstream (llvm/llvm-project) submission.

## Evidence base (verified, pinned llvm-z80 da06bcd8acc2, build-linux)

- `llc -mtriple=z80 -O1 -z80-static-frames -print-after=z80-nonreentrant` gives these results for `main` (alloca plus one call):
  - `@llvm.z80.halt`: no attributes, so `main` is on the stack (`add hl,sp`).
  - `declare @ext() nocallback`: `norecurse "nonreentrant"`.
  - `declare @ext() nofree nosync nounwind willreturn` (all but nocallback): no attributes.
  - `@llvm.readcyclecounter` (has nocallback, memory unknown): `nonreentrant`.
- ISR test (isr calls the callee, internal `fg` is called from main):
  - plain or intrinsic callee: no static frames anywhere;
  - `nocallback` callee: `L_fg.frame` and `L_isr.frame`.
- Layout test (main calls a, then b, both external linkage, 8-byte allocas):
  - no extra call: a and b overlap at +2;
  - `asm "nop"` in a (with #413): b moves to +10, a disjoint layout that wastes 8 B;
  - nocallback callee in a: a and b overlap at +2 again.
- `opt -O2` keeps an `llvm.z80.in` polling loop intact. `llc` emits `ld c,16` (hoisted) and `in a,(c)` inside the loop. The constant `out` costs 6 B (`ld b,65; ld c,17; out (c),b`).
- MIR after the legalizer is `G_INTRINSIC_W_SIDE_EFFECTS` (MachineIRBuilder.cpp:949 keys off memory effects, which are unchanged by S1).
- Other functions affected the same way (secondary finding): `llvm.trap`, `llvm.ubsantrap` and `llvm.debugtrap` also lack nocallback, so `__builtin_trap()` blocks static frames too.

## 2. Stages

Common test commands (Linux host sonnyboy, ccache on, build dir `llvm-z80/build-linux`):

```bash
cd /home/ravn/z80 && make toolchain                     # rebuild via ccache+Ninja (never in a scratch copy you don't own)
cd /home/ravn/z80/llvm-z80
build-linux/bin/llvm-lit -sv llvm/test/CodeGen/Z80/      # tier 1: lit
cd z80-utils && BUILD_DIR=../build-linux cargo run --release -- clang   # tier 2: runtime
# clang stages additionally:
build-linux/bin/llvm-lit -sv clang/test/CodeGen/z80-builtins*.c clang/test/Sema/z80-* 2>/dev/null
```

Run both tiers on the branch base first and record the numbers (baseline: 164 PASS + 6 XFAIL lit), then again after each stage.

### S1: `IntrNoCallback` on the six existing intrinsics (bug fix)

**Files.**
- `llvm/include/llvm/IR/IntrinsicsZ80.td`
- new test `llvm/test/CodeGen/Z80/static-frames-intrinsics.ll`

**Change** (memory property unchanged, so the effect stays memory(unknown)):
```tablegen
def int_z80_in   : Intrinsic<[llvm_i8_ty], [llvm_i8_ty],
                   [IntrNoMem, IntrHasSideEffects, IntrNoCallback, IntrWillReturn]>;
def int_z80_out  : Intrinsic<[], [llvm_i8_ty, llvm_i8_ty],
                   [IntrNoMem, IntrHasSideEffects, IntrNoCallback, IntrWillReturn]>;
def int_z80_halt : Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects, IntrNoCallback]>; // NOT willreturn: di;halt never returns
def int_z80_di   : Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects, IntrNoCallback]>; // no nosync: syncs with ISRs
def int_z80_ei   : Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects, IntrNoCallback]>;
def int_z80_nop  : Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects, IntrNoCallback, IntrWillReturn]>;
```
Add a comment stating why: the instructions cannot transfer control into module code. Interrupts are asynchronous and are modelled by `"interrupt"` context roots. Precedent: NVVM barriers, `Intrinsic<[], [llvm_i32_ty], [IntrConvergent, IntrNoCallback]>` (IntrinsicsNVVM.td:2320).

Fallback if review objects to WillReturn: ship `IntrNoCallback` only. That is the sole property the pass needs.

**Lit test** `static-frames-intrinsics.ll`:
```llvm
; RUN: llc -mtriple=z80 -O1 -z80-static-frames -verify-machineinstrs < %s | FileCheck %s
; RUN: opt -passes=function-attrs -S < %s | FileCheck %s --check-prefix=ATTR
; RUN: opt -passes=verify -S < %s | FileCheck %s --check-prefix=DECL
define i16 @a(i16 %x) noinline { ; 8-byte alloca, volatile st/ld, call @llvm.z80.nop() }
define i16 @b(i16 %x) noinline { ; 8-byte alloca, volatile st/ld }
define i16 @main() { ; 2-byte alloca; in/out/di/ei/halt; calls a then b }
define void @isr() #0 { ; alloca; call @llvm.z80.ei() }
; CHECK-DAG: L_main.frame = L___static_frames
; CHECK-DAG: L_a.frame = L___static_frames+[[OFF:[0-9]+]]
; CHECK-DAG: L_b.frame = L___static_frames+[[OFF]]
; CHECK-DAG: L_isr.frame = L___static_frames
; CHECK-LABEL: _main:
; CHECK-NOT: add hl,sp
; ATTR: define i16 @main() #[[M:[0-9]+]]
; ATTR: attributes #[[M]] = { {{.*}}norecurse
; DECL: declare void @llvm.z80.halt() #[[H:[0-9]+]]
; DECL: declare void @llvm.z80.nop() #[[N:[0-9]+]]
; DECL-DAG: attributes #[[H]] = { nocallback nounwind }
; DECL-DAG: attributes #[[N]] = { nocallback nounwind willreturn }
```
The CHECK-DAG with the shared `[[OFF]]` capture can be fragile. If it is, split it into two lines and use a FileCheck numeric variable. The point is to pin that **a and b overlap**.

Also add a negative control in the same file: an external declaration without nocallback keeps the caller on the stack (CHECK `add hl,sp`).

**Runtime fixture** (feasible): `z80-utils/test-runner/testcases/clang/intrinsic_static_frame.c`.
- Compile with static frames, if the runner supports per-test flags; check this first.
- A function with a local array that calls `__builtin_z80_di/ei/nop` only after S4, or via the asm-label trick before S4: `void z_di(void) __asm__("llvm.z80.di");`. Avoid HALT and ports.
- Body: `/* expect 0x1234 */`.
- If the runner cannot pass `-z80-static-frames`, skip it. Lit is the gate.

**Acceptance.**
- The new test passes.
- `intrinsics.ll`, `port-io-any-register.ll`, `static-frames*.ll` and `dangling-debug-value.ll` are unchanged.
- Both tiers show no regressions.

**Effort (estimate):** 0.5 day.

**Risk.** More functions become static-frame, which can expose latent static-frame bugs. Firmware is not affected until S5.

**Rollback:** revert one commit.

### S2: constant-port `IN A,(n)` / `OUT (n),A`

Cross-reference ravn/llvm-z80#421 (Defs/Uses on IN_A_n/OUT_n_A). I did not open it; confirm its scope before starting.

**Files.**
- `Z80InstrInfo.td:222-229`
- `Z80InstructionSelector.cpp`, the `z80_in`/`z80_out` cases at about lines 3944-3988
- tests: `port-io-any-register.ll` (extend) and new `port-io-immediate.ll`

**Change.**
- td: `IN_A_n { let Defs = [A]; let Uses = []; mayLoad=0; mayStore=0; hasSideEffects=1 }`. Do not add FLAGS to Defs: `in a,(n)` leaves the flags unchanged, unlike `in r,(c)`.
- td: `OUT_n_A { let Uses = [A]; mayLoad=0; mayStore=0; hasSideEffects=1 }`.
- Check how the operand is declared (PortMode/imm8) and that MC encoding still round-trips.
- Selector, when the port vreg is defined by `G_CONSTANT`:
  - IN: emit `IN_A_n imm`, then `COPY Dst <- A`.
  - OUT: emit `COPY A <- Val`, then `OUT_n_A imm`, with an implicit use of A on the MI or from the td Uses.
  - Otherwise keep the IN8_C/OUT8_C path.
- Outliner `Illegal` (Z80InstrInfo.cpp:2276) already lists both.

**High address byte (decision needed).**
- `in a,(n)` drives A15-A8 with A.
- `in r,(c)` drives A15-A8 with B, which is uninitialised today.

Choose one:
- (a) Document "8-bit port; the high byte is unspecified". This is correct for RC702 (8-bit decode) and is the cheapest.
- (b) Load B=0 on the (C) path. That costs bytes.
- (c) Add a separate 16-bit `llvm.z80.in16port`.

Recommendation: (a), with a comment in IntrinsicsZ80.td.

**Lit** (`port-io-immediate.ll`, `-O2`):
```llvm
; CHECK-LABEL: _rd:
; CHECK:      in a,(16)
; CHECK-NOT:  ld c,
; CHECK-LABEL: _wr:
; CHECK:      ld a,65
; CHECK-NEXT: out (17),a
; CHECK-LABEL: _poll:          ; loop re-reads the port each iteration
; CHECK: [[L:\.LBB[0-9_]+]]:
; CHECK-NEXT: in a,(16)
; CHECK: jr {{n?z}},[[L]]
; MIR: IN_A_n 16, implicit-def $a
```
Keep `port-io-any-register.ll` (variable port) unchanged. That proves the (C) path stays.

**Runtime fixture:** only if the test-runner emulator models a port (for example a loopback). Otherwise lit only.

**Acceptance.**
- Constant ports use the 2-byte forms; variable ports are unchanged.
- `-verify-machineinstrs` is clean.
- Both tiers pass.

**Effort (estimate):** 1 day, including the td flag audit.

**Risk.** Wrong Defs/Uses (#419-class) would let regalloc clobber A or delete the COPY. The lit MIR check pins the implicit operands.

**Rollback:** revert. The (C) path is untouched.

### S3: new intrinsics `im` and `set_i` (LD I,A)

**Files.**
- `IntrinsicsZ80.td`
- `Z80LegalizerInfo.cpp:836` (add the IDs to the "legal" list)
- `Z80InstructionSelector.cpp`
- `Z80InstrInfo.td:49` (`LD_I_A`)
- `intrinsics.ll` (extend)

**Change.**
```tablegen
def int_z80_im    : Intrinsic<[], [llvm_i8_ty],
                    [ImmArg<ArgIndex<0>>, IntrNoMem, IntrHasSideEffects, IntrNoCallback, IntrWillReturn]>;
def int_z80_set_i : Intrinsic<[], [llvm_i8_ty],
                    [IntrNoMem, IntrHasSideEffects, IntrNoCallback, IntrWillReturn]>;
```
- `LD_I_A`: add `let Uses = [A];`. Also audit `LD_A_I`/`LD_A_R` (Defs `[A, FLAGS]`) and `LD_R_A` (Uses `[A]`).
- Selector `im`: switch on the immediate 0/1/2 to `IM_0`/`IM_1`/`IM_2`. Other values give a verifier/selection error; add an IR Verifier check if cheap.
- Selector `set_i`: emit `COPY A <- val`, then `LD_I_A`. This is the historic 2883cdd8bb73 code, which only fails because of the missing Uses. Fixing the td fixes #419 at its root.
- Whether `im` is one intrinsic with an immarg or three (`im0/im1/im2`) is an open question. The historic code had only `im2`. One immarg intrinsic is cleaner; three match z88dk names 1:1. Either way the clang side can expose `__builtin_z80_im(n)` plus wrappers.

**Lit.**
```llvm
; CHECK-LABEL: _set_vec:
; CHECK:      ld a,{{[0-9]+|[a-z]}}
; CHECK-NEXT: ld i,a
; CHECK-LABEL: _set_vec_arg:      ; value arrives in A (sdcccall) -> no move, but ld i,a present
; CHECK:      ld i,a
; CHECK-LABEL: _im2:
; CHECK:      im 2
```
Add one test where the value is computed (for example `x+1`), so a dead-COPY regression would show as a missing `ld a`/`inc a`. Add a `-stop-after=instruction-select` MIR check for `LD_I_A implicit $a`. Extend `static-frames-intrinsics.ll` with both new intrinsics.

**Runtime fixture:** `ld i,a` followed by `ld a,i` would need `llvm.z80.get_i`, which is out of scope. Lit only.

**Effort (estimate):** 1 day.

**Rollback:** revert. Only additive, apart from the LD_I_A Uses change, which is a correctness fix.

### S4: clang builtins

**Source.** Commits 2883cdd8bb73 (builtins plus resource header plus tests) and 01c80da67276 (CodeGen wiring). Cherry-pick selectively.

**Keep.**
- `clang/include/clang/Basic/BuiltinsZ80.td` and the CMake hook.
- `TargetBuiltins.h`; `clang/lib/Basic/Targets/Z80.{h,cpp}` (builtin table).
- `CGBuiltin.cpp` dispatch, `CodeGenFunction.h`, `clang/lib/CodeGen/TargetBuiltins/Z80.cpp`.
- Tests `clang/test/CodeGen/z80-builtins.c` and `z80-builtins-sm83-gate.c`.

**Add.**
- `__builtin_z80_in(unsigned char)` and `__builtin_z80_out(unsigned char, unsigned char)`. Firmware uses them; check whether the historic commits had them. If they did not, add them.
- `__builtin_z80_im(n)` (constant-arg check) or `im0/1/2` per the S3 decision.
- `__builtin_z80_set_i(unsigned char)`.

**Gating.**
- di, ei, halt, nop: available on z80 and sm83. Check that SM83 selection exists for HALT/DI/EI/NOP.
- in, out, im, set_i: `Features = "z80"`, so sm83 gets a frontend diagnostic. Keep the sm83-gate test.

**Drop:** `clang/lib/Headers/intrinsic.h` and its `clang/lib/Headers/CMakeLists.txt` hunk. A generic name in the resource dir shadows user and system headers on every target, which reviewers would reject. Drop `clang/test/Headers/z80-intrinsic.c` too.

**Mapping lives in:**
- (i) z88dk's `include/intrinsic.h`, in the existing `#if defined(__LLVMZ80) || defined(__CLANG)` block (lines 135-139): `#define intrinsic_di() __builtin_z80_di()` and so on. This is a separate z88dk-fork change and needs its own go-ahead.
- (ii) The firmware `*/clang/intrinsic.h` files, which production uses because it drives clang directly.

**Acceptance.**
- The clang lit tests above pass.
- `clang --target=z80 -O1 -S` on a C file calling every builtin emits the expected instructions.
- With `-Xclang -target-feature -Xclang +static-frame`, functions using them get `L_*.frame`.
- Both tiers pass.

**Effort (estimate):** 1-1.5 days. Expect cherry-pick conflicts against the current clang tree.

**Risk.** Clang builtin-table churn on rebase. Rollback: revert; the IR intrinsics remain usable via the asm-label trick.

### S5: firmware migration and measurement (rc700-gensmedet)

**Files.**
- `autoload-in-c/rom.h` (port_in/out at :183-184; DI/EI/IM2/set_i at :280-299)
- `autoload-in-c/clang/intrinsic.h` (replace the `ld i,a` asm with `__builtin_z80_set_i`)
- `rcbios-in-c/hal.h` (:124-127 ports; `hal_ei()` asm at :220)
- `rcbios-in-c/clang/intrinsic.h`
- `cpnos-in-c/src/hal.h` (:43-49)
- `cpnos-in-c/compiler/compat.h` (:325-345: im_2 and ld_i_a asm; the #419 workaround)

Keep the SDCC branches unchanged. Out of scope: SET_SP, `push/ret` jumps, LDDR and other asm that has no intrinsic.

**Measurement.** Compare three variants, built with each Makefile:
- A: current headers on the last working compiler. Check whether it exists, given the builtins are absent on main.
- B: inline-asm-only headers on main plus #413.
- C: intrinsics on S1-S4.

Record for each:
- `autoload-in-c: make prom` gives `clang/prom.clang.bin` size against the 2048 B cap (baseline 1643 B).
- `cpnos-in-c: make prom1-lineprog COMPILER=clang` against 2048 B (baseline 2014 B, only 34 B free, so this is the most sensitive).
- `rcbios-in-c: make bios` (baseline 5462 B).
- Static-frame count: `grep -c '\.frame =' *.s` or `-print-after=z80-nonreentrant`, plus the `L___static_frames` region size.

Decide using these numbers:
- C ≤ B in bytes on all three components, and nothing breaks: merge.
- C > B on cpnos (34 B headroom): keep asm there.

**Boot gate (Makefile targets only, never MAME directly):**
- `cd autoload-in-c && make mame`
- `cd rcbios-in-c && make mame-test`
- `cd cpnos-in-c && make cpnos-polypascal-test`
- `cpnet/polypascal_pio_test.sh` (via its Makefile target, if there is one)

Also run the SDCC builds (`COMPILER=sdcc`, Docker z88dk:2.4) to prove single-source.

**Effort (estimate):** 1-2 days, including measurement.

**Rollback:** firmware headers are per-component; revert per component.

### S6: the #413 commits (78018171a730, on pinned main)

- **Keep until S5 has migrated all production asm** that the filter covers. Asm with no intrinsic (SET_SP, `push/ret`, LDDR in compat.h) still depends on it.
- **Known gap:** Z80StaticFrameAlloc builds its own CallGraph and does not filter asm edges, so frames lose overlap (measured: 8 B in the toy). Options:
  - (a) Factor the filter into a shared helper used by both passes. Small, but it widens an unsound rule.
  - (b) Leave it. Once S5 is done, remaining asm is rare.
  - (c) Narrow the filter to asm strings with no `call`/`rst`/`jp`/`jr`. Heuristic, not upstreamable.
  - Recommendation: (b) now, and (a) only if S5's measurements show a material RAM cost.
- **The drop branch** (`drop/413-inline-asm-callgraph-edges`, worktree `scratch/llvm-z80-drop413`) is a candidate for after S5. Revert #413 only when a firmware grep shows no static-frame-relevant asm left and frame/size numbers are unchanged. The `fix/413-...` branch stays as the reference.
- **Effort (estimate):** 0.5 day for the decision plus the measurement.

## 3. Branching and process

- All work happens in ravn/llvm-z80. Use one branch per stage from current `main`: `fix/z80-intrinsics-nocallback` (S1), `feat/z80-port-imm` (S2), `feat/z80-im-set-i` (S3), `feat/z80-clang-builtins` (S4). Firmware (S5) gets a branch in rc700-gensmedet.
- Every compiler change gets a lit test in `llvm/test/CodeGen/Z80/` (plus a clang test for S4). Runtime fixtures complement lit; they never replace it.
- Run both tiers on the base and on the branch tip. Merge with `--no-ff`.
- Commit locally. **No push and no PR without the user's explicit go-ahead.** After any push, check CI (`gh run list`).
- Upstream (fork-of-record, then llvm/llvm-project) is **bug-report-first**:
  - S1 is filed as "Z80 intrinsics lack nocallback, so CallGraph treats llvm.z80.* as escaping and static frames are lost", with the 12-line reproducer and before/after `-print-after=z80-nonreentrant` output.
  - It needs a per-filing explanation and the user's explicit go-ahead.
  - The fork owner doubted the address_space(2) port-I/O design, so present S1 as a pure attribute bug fix with no new language surface.
  - S2-S4 come later, separately.
- Never name the fork owner's handle in commits, issues or notes.

## 4. Ordering, dependencies, estimates

```
S1 ──┬─> S3 ──┐
     └─> S2 ──┼─> S4 ──> S5 ──> S6
              (S4 needs S3's intrinsics; S2 is independent of S3)
```
Estimates: S1 0.5 d, S2 1 d, S3 1 d, S4 1-1.5 d, S5 1-2 d, S6 0.5 d, about 5-6.5 days in total.

**Is S5 worth it?** Decide on these numbers:
- autoload PROM bytes against the 2048 B cap, and cpnos PROM1 against 2048 B (34 B free);
- the number of functions that gain `nonreentrant`;
- `L___static_frames` region size (RAM);
- whether IX-frame prologues and epilogues disappear in the ISR and foreground functions.

S1+S4 are worth doing even if S5 shows small gains: firmware headers are currently broken against main.

## 5. Risks and rollback (summary)

| Stage | Main risk | Detection | Rollback |
|---|---|---|---|
| S1 | latent static-frame bugs newly exposed; WillReturn objection | both tiers; S5 boot gate | revert one commit, or drop WillReturn |
| S2 | wrong Defs/Uses, so A is clobbered or a COPY is dead (#419 class) | MIR lit and `-verify-machineinstrs` | revert; the (C) path is unchanged |
| S3 | `LD_I_A` Uses change affects other users; bad `im` immediate | lit, runtime tier | revert |
| S4 | cherry-pick conflicts; sm83 gating | clang lit | revert; use the asm-label trick meanwhile |
| S5 | byte growth on cpnos (34 B headroom); ISR with mid-body `ei` gets a static frame (self re-entry) | size table; boot gates | per-component header revert |
| S6 | dropping #413 too early puts asm users back on the stack | frame-count diff | keep the `fix/413` branch |

Cross-cutting:
- Never switch the intrinsics to `DefaultAttrsIntrinsic`. That makes halt willreturn and di/ei nosync.
- Never drop `IntrHasSideEffects`. That gives memory(none), and polling INs would be CSE'd or hoisted.

## Open questions for the user (max 6)

1. **High address byte for ports.** Is "8-bit port, high byte unspecified" acceptable, or must `in r,(c)` set B (costs bytes)?
2. **`im` spelling.** One `__builtin_z80_im(n)` with an immediate, or three builtins matching z88dk's `intrinsic_im_0/1/2`?
3. **z88dk side.** Should the `intrinsic_*` mapping also go into z88dk's `include/intrinsic.h` (the LLVMZ80 branch), or only into the firmware headers?
4. **#413.** Keep it as-is after S5, extend it to Z80StaticFrameAlloc, or revert once asm is gone?
5. **ISR with `ei` inside.** Should the pass keep stack frames for an interrupt context that calls `llvm.z80.ei` before its last instruction (nested-interrupt safety), or is that the programmer's responsibility?
6. **Upstream.** Is filing S1 (bug report with reproducer) to the fork-of-record wanted at all, and when?
