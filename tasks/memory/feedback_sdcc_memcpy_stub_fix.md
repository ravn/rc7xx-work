---
name: feedback_sdcc_memcpy_stub_fix
description: Fix for _memcpy/_memcpy_builtin conflict when z88dk sdcc is on PATH in the test runner
metadata:
  type: feedback
---

When z88dk `sdcc-build/bin` is added to PATH, `find_sdcc_lib` in the test runner
finds z88dk's `z80.lib`/`sm83.lib` (ar archives). These define `_memcpy` and
`___memcpy` in the same `memcpy.rel` module. When that module is lazily loaded
(because SDCC code calls `___memcpy`), it conflicts with `z80_rt.lib`'s eagerly-
linked `_memcpy` -> "Multiple definition of _memcpy".

Separately, clang at Os generates `___z80_memcpy_builtin` calls for struct
copies. This symbol lives in z80_rt.lib's `memcpy.o` alongside `_memcpy`. When
sdcc_lib's `_memcpy` module is loaded first, z80_rt.lib's `memcpy.o` never loads
-> `___z80_memcpy_builtin` undefined.

**Fix (2026-09-21):** Added standalone stubs in `z80-utils/test-runner/harness/`:
- `z80/z80_memcpy_builtin.asm` — defines `___z80_memcpy_builtin` (LDIR, register
  ABI) AND `___memcpy` (alias `jp _memcpy`)
- `sm83/z80_memcpy_builtin.asm` — same for SM83 (loop-based register ABI)

Both stubs are compiled and linked BEFORE sdcc_lib in the sdcc suite. By
pre-defining `___memcpy` and `___z80_memcpy_builtin`, sdcc_lib's `memcpy.rel`
is never loaded -> no duplicate `_memcpy` -> no conflict.

**Why:** Both symbols must be in ONE stub (not two), because defining `___memcpy`
blocks sdcc_lib's `memcpy.rel` from loading, which is what prevents the
`_memcpy` conflict. Defining only `___z80_memcpy_builtin` is not enough.

**Key files changed:**
- `z80-utils/test-runner/harness/z80/z80_memcpy_builtin.asm` (NEW)
- `z80-utils/test-runner/harness/sm83/z80_memcpy_builtin.asm` (NEW)
- `z80-utils/test-runner/src/harness/runtime.rs` — `ensure_memcpy_builtin_stub()`
  + per-target mutex (OnceLock) for crt0/stub build race
- `z80-utils/test-runner/src/suites/sdcc.rs` — stub included before main_rel in link

**How to apply:** If sdcc tests show `_memcpy` multiple definition or
`___z80_memcpy_builtin` undefined when z88dk sdcc is on PATH -> check if stubs
are built in `build-macos/lib/{z80,sm83}/elf-runtime/z80_memcpy_builtin.rel`.
Delete stubs to force rebuild if source changed.
