---
name: reference_run_all_tests
description: Canonical one-command test aggregator for the whole workspace — run at merge/checkpoint
metadata:
  type: reference
---

`tasks/tools/run-all-tests.sh` is the single entry point that runs every test
group in the workspace. Run it manually at a merge / checkpoint (NOT a git hook
— user chose canonical-script-only, 2026-07-22, to avoid slow per-push gating).

Groups (each SKIPs if its tool is missing, never hard-fails):
- **A lit** — `llvm-lit CodeGen/Z80` (glob-discovered .ll)
- **B runtime** — test-runner value oracle (`cargo run -- clang`, glob-discovered
  `testcases/clang/*.c`) — the slow one (~minutes)
- **C z88dk** — `z88dk/test/clang/run_all.sh` (itoa/printf_ret/vaarg/strerror/
  stdlib_coverage/str/mem/float/printf_autoformat/rodata_cstn/… — auto-detects
  LLVMZ80EXE/NTVCM/ZCCCFG; also covers 32-bit double/float via `--math32`)

Scope: `run-all-tests.sh fast` = A+C (~1-3 min, skips slow runtime oracle);
no arg = full (A+B+C); or one group: `lit|runtime|z88dk`.
`SKIP_TESTS=1` short-circuits. Non-zero exit if any group FAILs.

Individual tests are still auto-discovered *within* their suites — this script
just runs all four suites from one place. There is no hosted CI (tests need the
local zcc/ntvcm/clang/MAME toolchain; ravn/llvm-z80 Actions are OFF per
[[feedback_ravn_llvm_z80_ci_disabled]]).
