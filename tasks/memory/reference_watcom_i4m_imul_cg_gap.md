---
name: Watcom 16-bit cg never folds (long)a*b>>k into a single IMUL — structural, not flag-gated
description: Source-verified root cause (2026-08-16) of Open Watcom emitting __I4M + shift loop instead of one imul for the fixed-point idiom on the 16-bit (i86) target.
metadata:
  type: reference
---

**Fact (source-verified in `open-watcom-v2/bld/cg`, 2026-08-16):** on the 16-bit
x86 target the idiom `(int)((long)a * b >> k)` is lowered to `call __I4M` (full
32×32 runtime multiply) + a shift loop, and **no compiler flag changes this** —
it is a structural gap, not a missing `-o`/`-1` switch. Enhancement is filed as
**ravn/open-watcom-v2-ccpm86#9**; per-op impact estimate + the 80186 angle on
**#18**.

Three independent layers, each verified:
1. **`bld/cg/intel/i86/c/i86optab.c` OP_MUL row is result-type dispatch.** Column
   order `U1 I1 U2 I2 U4 I4 …`: `I2→MUL2` (hardware `imul`), but `I4→RTN4C` =
   `__I4M` runtime call, unconditionally. The `(long)` cast makes the multiply
   node `I4`, so `__I4M` is always selected. (386 table: `I4→MUL4` hardware — so
   this is a 16-bit-only gap.)
2. **Front end never emits the widening multiply, AND the Intel back end for
   it is incomplete.** `OP_EXT_MUL`/`emul` (16×16→32) has an optab row (`EMUL`)
   in `bld/cg/intel/i86/c/i86optab.c:54`, but (a) `bld/cc`/`bld/plusplus` never
   request it for `(long)(int)a*(int)b`, AND (b) — verified 2026-08-16 by a spike
   — the i86 `ExtMul[]` selection table was **dead scaffolding**: a single
   self-looping `R_MAKECYPMUL`→`HalfType` entry with no terminal encoder, so it
   would infinitely re-reduce (I4→I2→I1→BAD). `OP_EXT_MUL` is only implemented
   end-to-end on the RISC targets (MIPS/PPC/Alpha); it is `__X__` (invalid) on
   386. So "machinery present, just unwired" (the earlier framing) is WRONG:
   emitting `OP_EXT_MUL` on Intel is a back-end feature that must be threaded
   through selection → regalloc → scoreboard → scheduler → encoder. A spike got
   **selection** working (a real `imul` is generated after fixing `ExtMul[]`),
   but wcc then crashes downstream in the register scoreboard (`scins.c:221`,
   `TryRegOp`) because `OP_EXT_MUL` is absent from several Intel opcode-dispatch
   lists that special-case `OP_MUL`/`OP_EXT_ADD` (e.g. `regalloc.c:471` has
   `OP_EXT_ADD` but not `OP_EXT_MUL`). See
   `tasks/plan-watcom-imul-widening-v2-2026-08-16.md`.
3. **The only multiply optimizer is out of scope.** `bld/cg/c/multiply.c`
   (`MulToShiftAdd`/`CheckMul`) strength-reduces multiply-**by-constant** only,
   and only for `type_class == WD/SW` = the **native machine word**
   (`bld/cg/h/targsys.h`: `WD/SW = U2/I2` on 16-bit, `U4/I4` on 32-bit). FP_MUL
   is variable×variable AND `I4` → excluded on both counts.

**Why it was never fixed (well-founded inference, not a source fact):** the gap
is structurally 16-bit-only. On 386+ the same `long` multiply is native
(`MUL4`); the "wider-than-native multiply of narrower operands" case only
reappears at `long long` (I8→`__I8M`), which is rare. Active Open Watcom
development targets 32/64-bit hosts where this optimization has ~zero value, so
the 16-bit lever was never built. No explicit `NYI`/`TODO` names it in the cg
source — it is simply absent.

**Practical takeaway:** to get the single `imul` today you must hand-write it
(`#pragma aux imul` — see `contrib/ravn/owc-drc/mandel-ow.c`), or teach the cg to
recognize the pattern. Full flag reference (incl. this finding):
`open-watcom-v2/contrib/ravn/watcom-cpm86-libc/docs/WATCOM_FLAGS.md`.
