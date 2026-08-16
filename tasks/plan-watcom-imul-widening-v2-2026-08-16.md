# Plan v2: emit a single IMUL/MUL for widened 16→32 multiplies on OW i86 (ccpm86 #9)

Status: PLAN. Supersedes `plan-watcom-imul-widening-2026-08-16.md` (whose "back
end already complete" premise was disproven by a spike). Target: `open-watcom-v2`
fork (submodule `ravn/open-watcom-v2-ccpm86`), i86 (16-bit) backend only.
Tracking: ccpm86 #9. Related: #18 (80186 shifts). Date: 2026-08-16.

## Goal (unchanged)

`(int)((long)a * b >> k)`, `r = (long)a * (long)b`, and the unsigned twin should
compile to a single hardware `IMUL r/m16` / `MUL r/m16` (32-bit product in DX:AX)
instead of `call __I4M`/`__U4M` + an 8-iteration shift loop. Measured upside on
the Mandelbrot kernel: ~4.6× fewer clocks, ~128 B (see #9).

## What the spike established (empirical, this session — KNOWN, not guessed)

Build/test loop used: scratch tree `/Users/ravn/z80/scratch/open-watcom-v2`
(bootstrapped toolchain) for building; submodule `/Users/ravn/z80/open-watcom-v2`
is the commit source-of-record (cg sources byte-identical between the trees).
`wcc.exe` at `bld/cc/i86/osxa64/binbuild/wcc.exe`; disasm `bld/ndisasm/.../wdis.exe`.

1. **The recognizer works.** A new i86-guarded IL pass `WidenMul()` (in
   `bld/cg/c/multiply.c`, called from `PreOptimize()` in `generate.c` after
   `MulToShiftAdd()`) correctly matches `OP_MUL(I4/U4)` whose *both* operands are
   widening `OP_CONVERT`s sharing one narrow class (I2→I4 or U2→U4), and rewrites
   to `OP_EXT_MUL` with the two 16-bit convert-sources as operands, keeping the
   I4/U4 type_class (so the result stays the full DX:AX 32-bit value and the
   encoder picks imul vs mul by sign). Uniform-sign is enforced by requiring both
   converts share `narrow`. Helper `WidenMulSource()` does the backward scan +
   clobber-safety check.

2. **`OP_EXT_MUL` was dead scaffolding on Intel, not a working path.** The i86
   `ExtMul[]` table (`i86table.c`) had a single self-looping `R_MAKECYPMUL`
   entry with no terminal encoder → infinite reduce (I4→I2→I1→BAD). I replaced it
   with terminal encoding entries mirroring `Mul2[]`'s tail (`G_R2`/`G_M2` +
   `RG_WORD_MUL`, op1→AX, result→DX:AX). **After this, instruction SELECTION
   succeeds — a real `imul` is generated** (verified: no crash in selection).
   `OP_EXT_MUL` is only implemented end-to-end on RISC (MIPS/PPC/Alpha); it is
   `__X__` (invalid) on 386. No Intel template exists.

3. **The remaining blocker is downstream, in the register scoreboard.** wcc now
   segfaults (`EXC_BAD_ACCESS` at `scins.c:221`, `TryRegOp` → `ScoreList[...]`
   NULL) during the post-selection scoreboard/register-renaming pass. Native
   `OP_MUL(I2)` imul (the `(int)((long)a*b)` case, already emitted today) survives
   this pass; my `OP_EXT_MUL(I4)` imul does not. Cause (STRONGLY SUSPECTED, not
   yet confirmed by a fix): `OP_EXT_MUL` is missing from Intel opcode-dispatch
   `switch`es that special-case `OP_MUL`/`OP_EXT_ADD`. Sites found where it is
   absent but a sibling is present:
   - `bld/cg/c/regalloc.c:471` — commutative-operand list has `OP_EXT_ADD`,
     `OP_MUL`, but **not** `OP_EXT_MUL`.
   - `bld/cg/intel/c/x86ver.c:185` — `case OP_MUL` (verifier), no `OP_EXT_MUL`.
   - `bld/cg/intel/c/x86enc.c:1260` — `case OP_MUL` (encoder), `OP_EXT_MUL` at
     :1254 is under `OP_EXT_ADD` — check it reaches the mul-encoding, not add.
   - `bld/cg/intel/i86/c/i86rtrtn.c:197` — `case OP_MUL` (rt-routine lowering).
   - `bld/cg/c/peepopt.c:532` — `case OP_MUL`.
   (Sites that ALREADY handle `OP_EXT_MUL`: `inssched.c:501/549`, `foldins.c:359`.)

### Two earlier attempts and why they failed (so we don't repeat them)
- **Retype `OP_MUL`→I2** (drop the 32-bit type): hardware imul emitted, but the
  IL models only AX as the result → DX (high 16 bits) dropped → **MISCOMPILE**
  (high word read from an uninitialised stack slot). Rejected.
- **`OP_EXT_MUL` keeping I4** (current WIP): correct in principle (DX:AX kept,
  sign by type_class); selection works; blocked by the scoreboard crash above.

## Decision: two viable paths — recommend Path A, keep B as fallback

### Path A (recommended): finish wiring `OP_EXT_MUL` through the i86 back end
Thread the new opcode through every Intel dispatch list it is missing from, one
at a time, rebuilding after each and re-running the value oracle. Concretely:
1. Add `OP_EXT_MUL` next to `OP_MUL`/`OP_EXT_ADD` at each site in §3 above,
   copying the `OP_MUL` behaviour (it is the same DX:AX fixed-register shape).
   Start with `regalloc.c:471` and re-test — that governs the reg operands the
   scoreboard walks and is the likeliest crash root.
2. If the scoreboard still faults, dump the offending instruction (build a debug
   wcc / add a targeted print in `TryRegOp`) to confirm whether the bad
   `reg_index` comes from the operand (op1 should be AX) or the DX:AX result
   pair, then fix the specific list.
3. Verify no *silent* miscompile: the value oracle (below) is the gate, because a
   dropped high half or wrong sign will otherwise pass "it compiles".
Effort: uncertain — bounded by the number of dispatch lists (small, ~5 known) but
each omission risks a fresh crash or a silent miscompile. ~1–2 focused days.

### Path B (fallback): keep the recognizer, avoid `OP_EXT_MUL` entirely
If Path A's back-end surface proves too large/fragile, model the widening multiply
without the never-before-generated opcode:
- Emit a native `OP_MUL(I2)` (imul→AX, fully supported today) to get the low
  16 bits, then explicitly materialise the high 16 bits from DX via a second IL
  name bound to DX, assembling an I4 result. Requires expressing "DX after the
  imul" in IL (the hard part — DX is implicit today). Investigate how I4 ADD/shift
  already assemble DX:AX results and whether that machinery can be reused.
This avoids the systemic opcode gap at the cost of a more intricate recognizer.

## Test strategy (unchanged from v1 — the value oracle is the real gate)

1. Baseline first: capture current `__I4M` asm + #9 numbers on unmodified cg.
2. Cases: (a) #9 idiom `(int)((long)a*b>>8)` signed; (b) `r=(long)a*(long)b`
   full 32-bit; (c) unsigned `(unsigned long)au*bu`; (d) NEGATIVE control:
   mixed sign `(long)(int)a*(unsigned)b` MUST stay `__I4M`; (e) POSITIVE
   controls: plain `int*int` (unchanged), true non-widened `long*long` (MUST
   stay `__I4M`), 386 build (MUST be native `MUL4`, unaffected); (f) constant
   operand `(long)a*256` (WidenMul currently needs both operands to be converts —
   decide whether to add a range-checked constant path).
3. **Runtime value oracle** (the gate): compute products with non-zero high 16
   bits (e.g. 1000*1000 = 0x000F4240), print/compare the full 32-bit result vs a
   host-computed expected value across sign combos + near-overflow. Run under
   emu2 (CP/M-86) or dosbox (DOS). Catches dropped-half and wrong-sign — the
   likely bugs. `imul`-present + `__I4M`-absent in disasm is necessary but NOT
   sufficient.
4. Re-run the CP/M-86 port build + MAME smoke; re-measure the #9 kernel delta.

## Siblings (from v1, still valid) — file/track separately, do not scope-creep
- **32/16 IDIV/DIV** (`OP_DIV`/`OP_MOD` I4/U4→`__I4D`/`__U4D`): native `IDIV/DIV
  r/m16` does DX:AX÷r/m16. NOT unconditionally safe — #DE on 16-bit quotient
  overflow. Separate, lower-priority issue with the overflow analysis up front.
  (todo `imul-sibling-div`.)
- Unsigned MUL twin: in scope of this plan (U2→U4 branch).
- Constant right-shift of a freshly-widened product: the other half of #9; can
  compose with #18. Follow-up.

## WIP location
The spike code (recognizer + ExtMul table + wiring) is preserved on submodule
branch `watcom-imul-widening-wip` (NOT on master; NOT pushed). Four files:
`bld/cg/c/multiply.c`, `bld/cg/h/multiply.h`, `bld/cg/c/generate.c`,
`bld/cg/intel/i86/c/i86table.c`. Resume from Path A step 1.

## Risks
- Silent miscompile (dropped high half / wrong sign) — mitigated only by the
  runtime value oracle; do not trust "it compiles".
- Back-end surface larger than the ~5 known dispatch sites (Path A open-ended).
- Keep strictly 16-bit-guarded; 386/RISC must be untouched.
- Fork enhancement only; any upstream filing needs a per-filing explanation +
  explicit go-ahead (repo rule). Prove on the fork first.
