# Handoff: Z80 Code Density Recovery & PR #40 Gap Analysis (2026-09-16)

**Session:** Antigravity on behalf of @ravn.
**Pick up with:** Read this document, then verify state with `git status` across repos and run tests as described below.

---

## 1. Executive Summary & Current State

Following the upstream LLVM 23.1.0 merge (PR #40 / PR #296, `cbaa9835043a`), the RC702 autoload firmware (`autoload-in-c`, `INIT_SEM702=1` with full ROA327 font) ballooned from fitting under the 2048-byte 2716 EPROM (IC66) ceiling to **2366 bytes (+318 B over limit)**.

Through systematic reintroduction and optimization, **-465 raw bytes** and **-297 compressed bytes** have been recovered. The current state is:

| Metrik | Før genindførelse (PR #40 baseline) | Nuværende tilstand (HEAD) | Samlet gevinst |
|---|---|---|---|
| **Rå `.text`** | 3879 B | **3414 B** | **-465 B** |
| **ZX0 komprimeret payload** | 2247 B | **1950 B** | **-297 B** |
| **Færdig PROM0 binær** | 2366 B (+318 B over) | **2069 B** (+21 B over) | **-297 B** |
| **LLVM Lit suite** | Fejlende tests | **249 PASS, 61 XFAIL, 0 FAIL** | 100% grøn |
| **MAME boot test** | Fejlede | **PASS** (boots to CP/M `A>`) | Verificeret |
| **MAME SW1 + QR orakler** | Fejlede | **PASS** (`mame_sw1_test`, `mame_qr_test`) | Verificeret |

The physical limit is **2048 bytes** (PROM0 is an unbuffered 2716 socket on RC702 without A11 wiring). We are currently **21 bytes over**.

---

## 2. Active Repositories & Working State

1. **`llvm-z80`** (submodule):
   - Branch: `experiment/static-frame-address-taken-context`
   - HEAD: `b86e19774a85 [Z80] Fold single-use 8-bit memory loads into CP (HL) in ISel`
   - Working tree: clean.
   - Built at: `build-macos/bin/clang`, `build-macos/bin/llvm-lit`, etc.

2. **`rc700-gensmedet`** (submodule):
   - Branch: `main`
   - HEAD: `aa515c0 autoload-in-c: update clang PROM listing and compressed payload (llvm-z80 b86e19774a85)`
   - Artifacts: `autoload-in-c/clang/prom.clang.lis` and `autoload-in-c/clang/text_compressed.zx0` committed.

3. **Root repo `/Users/ravn/z80`**:
   - Branch: `work/zcc-llvmz80-recovery`
   - HEAD: `5e646b6 tasks: update Z80 density recovery status and submodules`
   - Working tree: Submodules and tracking files committed.

---

## 3. What Was Recovered & Implemented

The recovery was executed across 6 primary levers:

1. **Direct Global Addressing in ISel (`37f696f38ee5`):**
   - Matches direct global loads/stores (`LD A,(nn)` / `LD (nn),A`) instead of loading the address into HL first.
   - Saved 3 B per access. Result: `.text` -194 B, PROM -125 B.

2. **Comparison Narrowing in ISel (`ce20d2bdf6b2`):**
   - Narrows 16-bit zext/sext comparisons down to 8-bit `CP` operations when upper bytes are proven zero/sign-extended.
   - `_check_sysfile` dropped from 98 B to 45 B. Result: PROM -47 B.

3. **Peephole #116/#117 (`f93cacb36c02`):**
   - 16-bit EQ/NE byte-XOR lowered to `AND A; SBC HL,rr` (3 B vs 6 B). Un-XFAIL'ed `issue-117-i16-eq-ne-neither-hl.mir`.

4. **In-Memory INC/DEC (`354d14db1273`):**
   - `LD A,(addr); INC/DEC A; LD (addr),A` -> `LD HL,addr; INC/DEC (HL)` (4 B vs 7 B). Result: PROM -3 B.

5. **Consecutive Store Chaining #85 (`74b2f251529f`):**
   - Folds >= 3 consecutive stores into `LD HL,addr; LD (HL),n; INC HL...` pointer chains. Test: `store-chain-walk.ll`. Result: PROM -4 B.

6. **Single-Use 8-bit Load-Fusion into `CP (HL)` and `SUB (HL)` (`b86e19774a85`):**
   - Folds single-use `G_LOAD` into `CP (HL)` and `SUB (HL)` in `emitFusedCompareAndBranch` and `G_ICMP`.
   - **Crucial HL affinity preservation (`isHLPreferred`):** In block compares (`*a++ != *b++`), tracks pointers through `G_PTR_ADD` and `G_PHI` back to `$hl`. Preserving HL in HL avoids register swapping that displaced register `B`, directly restoring hardware `DJNZ` loops in `compare_6bytes` and `check_sysfile`.
   - Lit test: `llvm/test/CodeGen/Z80/cp-hl-load-fuse.ll` (7 test cases).
   - Result: `.text` -11 B, PROM -3 B.

---

## 4. Analysis of the Remaining 21 Bytes & Root Causes

Detailed in `llvm-z80/tasks/analysis-autoload-over-2kb-after-pr40-2026-09-16.md`.

### Two PR #40 Regression Classes:
- **Class 1 — Inert `+static-frame` (~+975 B): FULLY RECOVERED.**
  Caused by inline-asm (`ei`) in ISR epilogue poisoning the `nonreentrant` attribute via `Z80NonReentrant.cpp` reachability walk. Fixed by `147d6f43` + ISel optimisations. `add hl,sp` frame operations dropped from 128 to 2.
- **Class 2 — Regalloc spill placement across calls: THE RESIDUAL 21 BYTES.**
  The remaining overage is concentrated in FDC helpers, dominated by `_fdc_read_result` (**+19 B**, 36 -> 55 B):
  - **Pre-PR #40 (36 B):** Loop counter stayed in callee-saved DE, preserved across call with cheap `push de` / `pop de` (no frame pointer, no SP adjustments).
  - **LLVM 23.1.0 (55 B):** Regalloc allocates a dynamic SP-relative frame (`push af; add hl,sp; ld (hl),c ... ld c,(hl); inc sp; inc sp`), adding prologue, epilogue, and slot-indexing bloat (+19 B).
  - Other Class 2 growers: `_floppy_legacy_boot` (+13 B), `_lookup_sectors_and_gap3` (+9 B), `_check_fdc_result` (+6 B), `_verify_seek_result` (+6 B).

### Why the Post-RA Peephole (#331) was PARKED as Unsound:
Attempting to rewrite the 14-byte dynamic SP frame spill/reload back to `push/pop` in `Z80LateOptimization.cpp` is **unsound**:
- It converts a reload to `pop`, which consumes the value from the stack. If there is a subsequent reload of the same slot in another block or loop iteration, it reads garbage / uninitialized stack data.
- This silently hung recursion in `z80-test-runner/testcases/clang/test_22_recursion.c` (Ackermann).
- **Conclusion:** Band-aid discarded. The correct fix must be made at the **regalloc / spill-weight** layer, preferring callee-saved registers (DE/BC) + scoped push/pop for values live across calls.

---

## 5. Active GitHub Issues & Tracking

### `ravn/rc700-gensmedet`
- **#130 (OPEN):** `autoload-in-c: clang PROM build overflows 2048-byte EPROM ceiling by 21 bytes (2069 / 2048 B)`.
  Tracks the production binary overage and links to the compiler issues below.

### `ravn/llvm-z80`
- **#331 (OPEN):** `Dynamic SP stack frame allocated for callee-saved scratch instead of direct PUSH/POP in non-static-frame functions`.
  The core Class 2 regalloc issue responsible for the ~19 B in `_fdc_read_result`.
- **#332 (OPEN):** `[Z80] -Oz miscompile: dynamic-SP-frame stack-argument read at wrong offset`.
  Pre-existing bug exposed by `test_33_string_ops.c` at `-Oz`. Two `push hl` emitted in prologue instead of one, so fixed-stack-offset calculations read the return address instead of the argument.
- **#333 (OPEN):** `[Z80] G_ZEXT(G_LOAD i1) in 8-bit comparison blocks CP (HL) memory fold`.
  `_Bool` in C lowers to `G_ZEXT(G_LOAD i1)`. In `_floppy_legacy_boot` (`rom.c`), `is_double_sided` load is not folded into `CP (HL)`. Fixing this can yield ~4 B.
- **#206 (OPEN):** `[Z80] #18 follow-up: extend known-constant copy to non-A registers (LD r,r' for any pair)`.
  Peephole constant reuse across GR8 registers. Test `issue-206-const-reuse-non-a.mir` currently XFAIL.
- **#327, #328, #329, #330 (CLOSED):** Verified closed and resolved.

---

## 6. Critical Lessons & Gotchas for Next Agent

1. **ZX0 PROMs: Optimize compressed bytes, not raw bytes!**
   Recorded in `tasks/memory/feedback_zx0_optimize_compressed_not_raw.md`.
   Raw assembly reductions do not always translate to compressed binary reductions. For instance, replacing repetitive `add a,a` chains with a loop can save raw bytes but destroy ZX0 LZ-match redundancy, making the compressed PROM *larger*. Always measure `text_compressed.zx0` and `prom.clang.bin`.
2. **MAME `**NO DISKETTE NOR LINEPROG**` is NOT a test failure:**
   - `sw1-test` and `qr-test` purposefully run *without* a floppy and with an empty PROM1 (0xFF) to test the fallback banner and QR display. In `qr-test`, `NO DISKETTE NOR LINEPROG` is an explicit requirement of the test assertions.
   - `floppy-boot-test` uses `test-disks/SW1711-I8.imd` and boots cleanly to CP/M `A>`.
3. **Makefile CEIL=2048 Gate:**
   `autoload-in-c/Makefile` has `CEIL=2048` and exits with code 1 if `prom.clang.bin` exceeds 2048 bytes. To run MAME tests during debugging while over 2048 bytes, pad `prom.clang.bin` up to 4096 bytes into `prom0.ic66` and copy to `../../mame/roms/rc702/roa375.ic66`.
4. **Attribution and PR rules (AGENTS.md):**
   - Never open a PR unless explicitly asked.
   - Do not push unless instructed.
   - GitHub issue bodies must separate symptoms from causes, long flowing lines (no hard wraps), and end with `--- / _Filed by Claude on behalf of @ravn.` or appropriate agent name.

---

## 7. Verification Commands Reference

```bash
# 1. Run LLVM lit suite (all must be PASS/XFAIL, 0 FAIL)
cd /Users/ravn/z80/llvm-z80
build-macos/bin/llvm-lit llvm/test/CodeGen/Z80

# 2. Build autoload PROM and inspect size
cd /Users/ravn/z80/rc700-gensmedet/autoload-in-c
make prom   # Reports: clang PROM: 2069 / 2048 bytes (PROM0 2 KB hard)

# 3. Verify Floppy Boot to CP/M A> in MAME
cd /Users/ravn/z80/rc700-gensmedet/autoload-in-c
perl -e 'print "\xff" x (4096 - 2069)' > /tmp/pad
cat clang/prom.clang.bin /tmp/pad > clang/prom0.ic66
cp clang/prom0.ic66 ../../mame/roms/rc702/roa375.ic66
rm -f /tmp/boot_test_result.txt
../../mame/regnecentralend rc702 -rompath ../../mame/roms -nothrottle -window -skip_gameinfo -seconds_to_run 30 -autoboot_script mame_boot_test.lua -flop1 "$(pwd)/test-disks/SW1711-I8.imd"
cat /tmp/boot_test_result.txt   # Must output: PASS ... A>

# 4. Run clang runtime tests in z80-test-runner
cd /Users/ravn/z80/z80-test-runner
# (e.g. test_22_recursion or all passing tests)
```
