---
name: project_upstream_all_prs_status_2026-09-22
description: Status of upstream-all-prs branch and pending merges as of 2026-09-22
metadata:
  type: project
---

## Branch: upstream-all-prs (ravn/llvm-z80)

Working branch for work targeting llvm-z80/llvm-z80 upstream.

### Merged upstream (already in llvm-z80/llvm-z80 main)
PR #29, #41, #43, #44, #45, #46, #47, #48, #346 — all merged.

### On upstream-all-prs but NOT yet upstream
- `#357`: G_MEMSET inline + EX DE,HL swap-fold + distinct-object memmove bypass
- DJNZ rename (`-z80-split-djnz-counters` → `-z80-split-djnz`)
- test-runner fixes (sdcc stub, llc direct-ar, utils direct-ar, #267 drift guard)

### Pending PR
- **#360** (fix-359-utils-link-rels-ar-archive → upstream-all-prs): utils
  link_rels ar-archive fix. Ready to merge.

### Needs merge from main into upstream-all-prs
- **Pi/CSE fix** (`6385494bcfd7` + `ed90a4e96a76` on main): MO_MCSymbol
  `isIdenticalTo`/`getHashValue` now compare offset. Root-fixes B15 (pi CSE
  miscompile) and #247 (fannkuch branch-folder). NOT yet on upstream-all-prs.
  Until merged, CSE must stay off by default.
  Filed upstream as ravn/llvm-project#1.

### On separate branch (not yet merged anywhere)
- **cc133 (#281+#282)**: `fix-282-smallc-callee-composition` — composable
  z80_smallc + z80_callee → CC_Z80SmallCCallee. Phase 0-3 done, MAME e2e
  not needed (graphics.h fix was separate HL→DE issue). Ready to evaluate for
  merge.

## Correctness gate (2026-09-22): CLEARED

No open miscompiles on upstream-all-prs. All known bugs either fixed or
explicitly parked:

| Issue | Status |
|---|---|
| #267 pseudo undersize | FIXED + lit test (cfb6e417fff4) |
| #331 PUSH/POP spill | PARKED — 4B, not worth pursuing |
| graphics.h HL→DE | FIXED — __z88dk_fastcall in graphics.h (ravn/z88dk#50) |
| CSE/branch-fold (#247) | FIXED in main, not yet on upstream-all-prs |
| rcbios -flto #312 | PARKED — upstream LLVM Z80DanglingDebugCleanup |

**Why:** Pi/CSE fix is in `main` (merged 2026-09-20 as #247) but `upstream-all-prs`
diverged before that commit. Need explicit merge to bring it in.
