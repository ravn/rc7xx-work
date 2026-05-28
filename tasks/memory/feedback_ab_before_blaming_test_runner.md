---
name: A/B before blaming test-runner
description: Before suspecting a new llvm-z80 patch caused test-runner regressions, stash + rebuild llc + rerun to A/B against baseline — test-runner has long-standing O1 noise unrelated to current work
type: feedback
originSessionId: 8ab450a7-bedb-47ba-bfd3-d7e910ab1992
---
When `z80-utils/test-runner` clang suite shows FAILs after a new llvm-z80 patch, do NOT assume the patch caused them.  A/B FIRST:

1. `git stash push -m "ab-test" <patched files>` in llvm-z80
2. Rebuild: `ninja -C build-macos llc` (incremental, ~3 s if only Z80 code changed)
3. Rerun the failing subset: `cargo run --release -- clang <subset>`
4. If same failures appear → pre-existing, not the patch
5. `git stash pop` + rebuild to restore

**Why:** Session 59b/#135 verification turned up 37 FAILs in `test_90_edge_*_O1` and `test_91_edge_prom_*_O1`.  Initial instinct: "#135 caused regressions, must investigate."  A/B took 3 minutes and proved the 37 FAILs are pre-existing O1-only miscompiles (filed as ravn/llvm-z80#136).  Without A/B I would have spent 30+ minutes chasing a non-#135 cause and possibly reverted a clean patch.

**Known pre-existing noise as of 2026-05-11:**
- `test_90_edge_*_O1` — 19 fixtures fail (DE=0x0001..0x0004, expected 0x0000)
- `test_91_edge_prom_*_O1` — 19 fixtures fail (same pattern)
- O0/O2/O3/Os/Oz pass for all the above; only O1 affected
- Filed as ravn/llvm-z80#136
- Possibly `test_27_array_2d_Os` — single failure

**How to apply:**
- Every time test-runner FAIL count rises after a patch, do the stash/rebuild/rerun cycle BEFORE diagnosing the patch.
- If A/B confirms the FAILs are pre-existing, note them inline ("test-runner: N PASS, M FAIL — A/B confirmed pre-existing #136 noise, not regression") in the commit message rather than treating them as gating.
- When #136 (or its successor) is fixed, retire this rule.
