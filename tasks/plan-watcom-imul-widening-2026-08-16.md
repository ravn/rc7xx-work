# Plan: teach the Open Watcom 16-bit cg to emit a single IMUL/MUL for widened multiplies (ccpm86 #9)

> **⚠️ SUPERSEDED 2026-08-16 — see `plan-watcom-imul-widening-v2-2026-08-16.md`.**
> A spike disproved this plan's central premise (the "back end is already
> complete" section below). `OP_EXT_MUL` is **not** wired end-to-end on Intel —
> it is only implemented on the RISC targets (MIPS/PPC/Alpha) and is `__X__`
> (invalid) on 386. On i86 it existed only as dead scaffolding (a single
> self-looping `ExtMul[]` table entry with no terminal encoder). Making it work
> is a **back-end feature** threaded through selection → regalloc → scoreboard →
> scheduler → encoder, not a recognizer/peephole. The recognizer, sign-uniformity
> rules, test strategy, and sibling-optimization sections below **remain valid**;
> only the "tractable / back-end complete" framing is wrong. Read v2 for the
> corrected approach and the empirical findings (selection now works; the crash
> is downstream in the register scoreboard).

Status: SUPERSEDED (see banner). Target: `open-watcom-v2` fork, i86 (16-bit) backend.
Tracking issue: ravn/open-watcom-v2-ccpm86#9. Related: #18 (80186 shifts, separate).
Date: 2026-08-16.

## Goal

Make `(int)((long)a * b >> k)` and the general `(long)(int)a * (int)b`
(and the unsigned twin) compile to a single hardware `IMUL r/m16` / `MUL r/m16`
(product in DX:AX) instead of `call __I4M` + an 8-iteration `sar/rcr/loop` shift.
Measured upside on the Mandelbrot kernel: ~4.6x fewer clocks, ~4.8x fewer
instructions, -128 B (see #9).

## Why this is tractable — the back end is already complete

The widening-multiply *encoding path already exists and is wired end-to-end*;
it is simply never generated for C on the 16-bit target. Verified in the fork:

- `bld/cg/intel/i86/c/i86optab.c:54` — `OP_EXT_MUL` row maps U2/I2/U4/I4 -> `EMUL`.
- `bld/cg/intel/i86/h/_tables.h:59` — `pick( EMUL, ExtMul, ExtMul )`.
- `bld/cg/intel/i86/c/i86table.c:561` — `ExtMul[]` generate-table, action `R_MAKECYPMUL`.
- `bld/cg/intel/c/x86split.c:106` — `rMAKECYPMUL()` calls `HalfType(ins)`, reducing
  the EXT_MUL to 16-bit operands with a 32-bit (DX:AX) result -> the hardware
  `IMUL`/`MUL r/m16`.
- `bld/cg/intel/c/x86opcod.c:94` — `EXT_MUL` encodings `0xe0f6` (IMUL) / `0x20f6` (MUL).

So the deliverable is a **recognizer/rewrite**, not new encoding/regalloc work.

## What is missing (the three root-cause layers, from the cg-gap memory note)

1. Instruction selection is result-type-driven: `OP_MUL` with I4/U4 type ->
   `RTN4C` = `__I4M`/`__U4M` (`_rtinfo.h:117/126`), unconditionally. The `(long)`
   cast makes the multiply node I4.
2. The front end never emits `OP_EXT_MUL` for `(long)(int)a*(int)b`.
3. The only multiply optimizer (`bld/cg/c/multiply.c`) is by-constant + native-word
   (WD/SW) only, so it never touches a variable x variable I4 multiply.

## The transform to add

Recognize, on the 16-bit target only:

```
  MUL(res : I4)  ( CONVERT(I2->I4) x ,  CONVERT(I2->I4) y )   ->  EXT_MUL(res:I4)(x16, y16)   [signed  IMUL]
  MUL(res : U4)  ( CONVERT(U2->U4) x ,  CONVERT(U2->U4) y )   ->  EXT_MUL(res:U4)(x16, y16)   [unsigned MUL]
```

Correctness rules:
- **Sign must be uniform.** Signed IMUL requires *both* operands sign-extended
  (I2->I4); unsigned MUL requires *both* zero-extended (U2->U4). A mixed pair
  (one signed-, one zero-extended) is NOT a single hardware multiply -> leave as
  `__I4M`. This is the #1 correctness trap.
- The 32-bit DX:AX product equals the 32x32 product's low 32 bits exactly when
  both inputs are true 16-bit widenings, so the rewrite is value-identical for
  the full 32-bit result (no need to require the result be narrowed).
- **Constant operand variant** (very common in fixed-point: `(long)a * SCALE`):
  when one operand is a `CONVERT(I2->I4)` and the other is an absolute constant
  that fits the matching 16-bit signed/unsigned range, materialize the constant
  as a 16-bit operand and take the same path. Guard the range carefully
  (e.g. signed: -32768..32767).

## Where to hook it — two candidate insertion points (spike needed)

**(A) Tree phase — preferred if an EXT_MUL tree form is viable.**
`bld/cg/c/treefold.c` already rewrites `O_TIMES` trees and sees child nodes
(`u.left`, `u1.t.rite`) with types (`->tipe`), so an `O_TIMES(tipe==I4)` whose
both children are widening `O_CONVERT` unary nodes is matchable here — *before*
`bld/cg/c/rtcall.c`/`rtrtn.c:LookupRoutine` lowers the I4 multiply to `__I4M`.
OPEN QUESTION for the spike: there is an `OP_EXT_MUL` *instruction* opcode but
no obvious `O_` *tree* op; confirm whether the tree->IL generator can be taught
to emit `OP_EXT_MUL`, or whether (B) is cleaner.

**(B) IL peephole — robust fallback.**
After tree->IL generation but *before* the RT-call lowering, add an i86-guarded
peephole that matches `OP_MUL` (I4/U4) whose two operand temps are each *defined*
by a widening `OP_CONVERT` (and each single-use / foldable), and rewrites via
`MakeBinary(OP_EXT_MUL, x16, y16, res, tclass)` + `ins->table = CodeTable(ins)`
— exactly the construction the split pass already uses for `OP_EXT_ADD`
(`bld/cg/intel/i86/c/i86splt2.c:462`). Must confirm the def-use visibility of the
feeding CONVERTs at this phase and that dropping them doesn't strand live ranges.

Recommended: a short spike to decide A vs B, then implement the chosen one.

## Test strategy (Watcom cg has an owc regression suite)

1. **Baseline first** (mandatory): capture the current `__I4M` asm for the repro
   on unmodified cg (`wcc -0 -ms -oentry?`), and the current #9 cycle/size numbers.
2. Add targeted `.c` cases producing checkable asm/behaviour:
   - exact #9 idiom `(int)((long)a*b>>8)` (signed);
   - `(unsigned)((unsigned long)a*b>>8)` (unsigned MUL path);
   - constant operand `(long)a*256`;
   - **negative control:** mixed sign `(long)(int)a*(unsigned)b` MUST stay `__I4M`;
   - **positive controls:** plain 16-bit `int*int`, plain 32-bit `long*long`
     (both true I4 vars, not widenings — MUST stay `__I4M`), 386 build (MUST be
     unaffected, still native MUL4).
3. Verify each: (a) emitted asm contains a single `imul`/`mul` and no `__I4M`
   call for the positive cases; (b) *runtime value* equals a host oracle for a
   spread of inputs incl. sign combinations and near-overflow (the value oracle
   is the real gate — a wrong-sign multiply is the likely bug).
4. Re-run the CP/M-86 port build + MAME rc759 smoke (no regressions), then
   re-measure the #9 kernel for the before/after delta.

## Risks

- Sign-mismatch miscompile (mitigated by the uniform-sign rule + negative control).
- Stranding the feeding CONVERT temps if they had other uses (only fold when the
  widened temp is single-use / dead after folding).
- 386 / other targets: the transform is 16-bit-only; guard so 386 keeps native
  `MUL4` and RISC/other targets are untouched.
- Upstream posture: this is a fork enhancement; per repo rules, filing anything
  upstream needs a per-filing explanation + explicit go-ahead. Keep on the fork
  first, prove it, then decide.

## Effort estimate (rough)

Spike A/B: ~0.5 day. Implementation of the recognizer + constant variant: ~1 day.
Tests + oracle + port/MAME re-verify: ~1 day. Total ~2.5 days.

---

## Sibling missed optimizations found in the same 16-bit dispatch table

While root-causing #9 I audited the whole `i86optab.c` arithmetic block. The same
"wider-than-native op falls to a runtime helper although an 8086 instruction with
a wider accumulator exists" shape appears in a few more cells (all 16-bit-only,
all invisible on 32/64-bit dev hosts):

1. **32 / 16 -> 16 divide and remainder (highest-value sibling).**
   `OP_DIV`/`OP_MOD` with I4/U4 -> `RTN4` = `__I4D`/`__U4D` (`_rtinfo.h:118/119/127/128`).
   The 8086 `IDIV/DIV r/m16` natively computes `DX:AX / r/m16 -> AX quotient,
   DX remainder` (32÷16). So `(int)((long)a / b)` / `(int)((long)a % b)` where the
   dividend is a widened 32-bit value and the quotient fits 16 bits is a single
   hardware divide. **Caveat:** unlike multiply this is not unconditionally safe —
   if the quotient overflows 16 bits the 8086 raises #DE (INT 0), whereas `__I4D`
   returns a full 32-bit quotient. So the substitution is only valid when the
   result is narrowed back to 16-bit AND overflow is acceptable/impossible
   (e.g. divisor magnitude guarantees it, or C semantics already truncate). Worth
   a separate, lower-priority issue with the overflow analysis. Same DX:AX regs
   as the mul path, so it reuses the widening-recognizer scaffolding.

2. **Unsigned multiply twin.** `OP_MUL U4 -> __U4M`; folded by the same #9
   recognizer's U2->U4 branch (hardware `MUL r/m16`). Not separate work — it is
   in scope of this plan (call it out in the tests).

3. **Compounding: constant right-shift of a freshly-widened 32-bit product.**
   After the IMUL the 32-bit product sits in DX:AX; `>> 8` then narrow-to-int is a
   near-free byte realignment (`mov al,ah; mov ah,dl`) rather than an 8-iteration
   `sar/rcr/loop`. This is the *other* half of the #9 win and is separable: even
   without the IMUL fold, a constant multi-bit shift of a 32-bit value that is
   immediately narrowed can be strength-reduced by byte count. Overlaps #18
   (80186 immediate-count shifts) only for the standalone-shift case. Candidate
   follow-up once the IMUL fold lands (the two compose to give the full #9 number).

NOT siblings (checked, ruled out): `OP_ADD/SUB` already split to native
`add/adc`/`sub/sbb` (EXT_ADD/EXT_SUB), `OP_AND/OR/XOR` are native `AND4/OR4`,
`OP_POW I4` is a genuine library routine (no single-instruction form).

## Suggested issue hygiene

- Post the implementation approach (this file, condensed) as a comment on #9.
- File the 32/16 divide/remainder sibling as its own enhancement (cross-link #9),
  with the #DE-overflow safety analysis front and centre.
- The constant-shift-of-widened-value compounding: note on #9 as a follow-up,
  or fold into #18's scope.
