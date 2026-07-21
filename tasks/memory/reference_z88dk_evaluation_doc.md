---
name: reference_z88dk_evaluation_doc
description: Living evaluation document about llvmz80 as z88dk backend — update when status changes
metadata:
  type: reference
---

Living document for the z88dk project at `tasks/z88dk-llvmz80-evaluation-2026-07-21.md`.

**Why:** User wants to share a balanced pros/cons assessment with z88dk maintainers.

**How to apply:** After any change that affects z88dk llvmz80 integration (new bridge, bug fix, benchmark result, float support), update the relevant section of the document. Keep it current — it reflects what is TRUE NOW, not what was true when it was created.

Sections to watch:
- §1 "What works today" table — update when new bridges land or gaps close
- §1 "Known gaps" table — update with type (LINK_ERROR/NOT_DECLARED/NO_LIBM/BROKEN) and reason
- §4 DCC benchmark table — update when cycles change after compiler improvements
- §5 "libm status" — update when transcendental functions are ported or whetstone becomes feasible
- §6 recommendations — adjust if any recommendation becomes stale

Current gap types (2026-07-21):
- LINK_ERROR: strerror (missing __rodata_error_strings_head in z80 CP/M clib)
- NOT_DECLARED: bsearch, tmpfile (not in z88dk CP/M headers)
- NO_LIBM: all math.h functions (no transcendental libm)
- BROKEN: user va_start in variadic fns (ravn/llvm-z80#270)
- NO_FORMAT: printf("%f") needs nanoprintf closure

Test suite at `z88dk/test/clang/` (2026-07-21):
- run_all.sh: master runner (auto-detects LLVMZ80EXE/NTVCM/ZCCCFG)
- 15 tests all PASS: run with LLVMZ80EXE + NTVCM set
