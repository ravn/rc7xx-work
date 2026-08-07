---
name: project_llvmz80_z88dk_callee_graphics_miscompile
description: ravn/llvm-z80 #281 FIXED + #282 FIXED (Phase 3, clang composition) — llvmz80 miscompiled z88dk <graphics.h> calls (__smallc __z88dk_callee); #281=missing conflict diagnostic, #282=no combined smallc-order+callee-clean convention. z80_smallc+z80_callee now compose to cc133 (CC_Z80SmallCCallee). Phase 4 (MAME e2e) remains. 2026-08-07.
metadata:
  type: project
---

**Candidate llvmz80 bug (found 2026-08-07, rc700 graphics demo):** the z88dk
`<graphics.h>` primitives are declared `__smallc __z88dk_callee` (e.g.
`plot_callee`, `draw_callee`, `circle_callee` — callee-pops, stack args). Under
`zcc +cpm -subtype=rc700 -compiler=llvmz80`, **most of these calls are
miscompiled**: a 5-primitive test (circle + 2 diagonals + dotted midline) drew
only ONE diagonal; the classic **sccz80** build of the identical source drew all
five correctly (verified in MAME rc702, `scratch/sine-demo/snap/gfxscc.png` vs
`gfxtest.png`). So it is a clang-z80 calling-convention bug for
`__smallc __z88dk_callee`, NOT a graphics-lib or disk-format problem.

**Impact:** blocks the llvmz80 route for any `<graphics.h>` program on rc700
(and every other gencon target). Ties into
[[project_z88dk_llvmz80_full_support_goal]] (full llvmz80 CP/M support).

**DONE (2026-08-07):** full bug-analyst pass + FILED as two ravn/llvm-z80 issues
(user go-ahead per [[feedback_explain_before_filing]]):
- **#281** (correctness/diagnostic): two Z80/SDCC CC attributes on one function are
  silently collapsed to the last one (miscompile, no diagnostic). Root cause
  `clang/lib/AST/Type.cpp` `AttributedType::isCallingConv()` omits `attr::SDCCCall,
  Z80AllReg, Z80FastCall, Z80Callee, Z80SmallC` → `getCallingConvAttributedType()`
  null → conflict guard in `SemaType.cpp` (~8385, `err_attributes_are_not_compatible`)
  never fires.
  **FIXED 2026-08-07** (local branch `fix-281-conflicting-cc-diagnostic`, not pushed):
  registered the 5 kinds in `isCallingConv()` + added their names to
  `getNameForCallConv()`; conflicting CC combos now error. Test
  `clang/test/Sema/z80-conflicting-callconv.c`. **Consequence:** `__smallc
  __z88dk_callee` (graphics.h) is now a HARD ERROR under llvmz80 until #282 lands.
- **#282** (missing convention): no clang-z80 CC expresses `__smallc __z88dk_callee`
  = left-to-right push + callee cleanup (the real z88dk clib convention; proven by
  `libsrc/classic/gfx/narrow/plot_callee.asm` pop order `pop hl(y); pop de(x)`).
  z80_smallc (L→R, caller) and z80_callee (R→L, callee) are separate; stacking both
  → z80_callee alone → args reversed. plot(x,y) → (y,x).
  **FIXED (Phase 3, 2026-08-07)** — see updated status below.
  **Design + plan** (user wants a composition mechanism, not one CC per combo):
  `llvm-z80/tasks/plan-2026-08-07-composable-z88dk-conventions.md`. Conventions are
  orthogonal axes (order/cleanup/reg-loc/preserves_regs). Key constraint: ABI axes
  (order/cleanup) MUST live in the function type (indirect calls via fn-pointers,
  e.g. qsort comparator) → must be CallingConv, not a decl-attr like preserves_regs.
  Approach: axis-encoded CC + clang composition layer; #281=same-axis conflict error,
  #282=different-axis compose. **Phase 0-2 DONE** (branch
  `fix-282-smallc-callee-composition`, off main, not pushed): backend value
  `Z80_SmallCCallee=133` (L2R+callee), `isSmallCArgOrder()` helper + isCalleeCleanup +
  classifyArg + getRegsForCC decode axes; byte-identical for existing CCs; lit test
  `z80-smallc-callee.ll`. **Phase 3 (clang composition layer) DONE 2026-08-07**
  (same branch `fix-282-smallc-callee-composition`, which now also contains #281 via
  `--no-ff` merge — composition reuses #281's conflict path). New frontend CC
  `CC_Z80SmallCCallee`; `composeZ80CallingConvs()` in SemaType.cpp
  `handleFunctionTypeAttr` composes smallc+callee→cc133 at the conflict point (order-
  independent), else keeps the #281 error for genuine same-axis conflicts. Wired
  through getNameForCallConv / Itanium+Microsoft mangling / TypePrinter / Z80
  checkCallingConvention / CGCall (toLLVMCallingConv + getCallingConventionForDecl
  both-attrs→cc133). Key: `handleCallConvAttr` returns early for `hasDeclarator`, so
  the TYPE-level `handleFunctionTypeAttr` is the right hook. Tests: CodeGen/
  z80-smallc-callee.c (cc133 on def+call site+fn-pointer); #281 Sema test updated
  (smallc+callee both spelling orders now OK/compose; real conflicts still error).
  End-to-end proven: caller push order flips R2L(cc131)→L2R(cc133) while keeping
  callee cleanup; original `both()==callee()` bug gone. Full Z80 backend lit 0 fail,
  all z80 clang tests green. Commit `76d948cb9be8`.
  **Phase 4 (e2e in MAME) REMAINS** — z88dk `include/sys/compiler.h` ALREADY maps
  `__smallc`→z80_smallc and `__z88dk_callee`→z80_callee, so existing clib source
  composes to cc133 with NO header churn. Left: rebuild the deployed clang toolchain
  (`make toolchain`), rebuild the rc700 `<graphics.h>` demos under `-compiler=llvmz80`,
  and confirm they render in MAME rc702 (oracle: sccz80 `scratch/sine-demo/snap/
  gfxscc.png`/`sinescc.png`).

Repro: `tasks/upstream-5bug/z80_smallc_callee_combine.c` (g_both == g_callee proves
z80_smallc dropped). Cross-compiler evidence: sccz80 renders all 5 gfx primitives in
MAME (`scratch/sine-demo/snap/gfxscc.png`), llvmz80 only the symmetric diagonal
(`gfxtest.png`). AVR cross-check N/A (Z80-specific CC attrs). See
[[reference_z88dk_calling_conventions]], [[reference_z88dk_clang_register_abi]].

**Two adjacent rc700 items surfaced same session (separate from this bug):**
- z88dk appmake cannot emit the RC702 mixed-density track 0 (FM26x128/MFM26x256)
  — `disc_spec` is uniform-geometry; needed for a B: data disk to be readable by
  the real RC702 BIOS (#36). See [[reference_z88dk_rc700_subtype_build]].
- `getchar()` after drawing pages the graphics plane out on rc700
  (`_GFX_PAGE_VRAM`); use non-blocking `getk()` instead (already fixed in the
  examples).
