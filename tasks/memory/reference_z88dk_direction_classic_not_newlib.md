---
name: z88dk direction — classic is the way forward, newlib deprecated; neither lib is sdcccall(1)
description: Maintainer-stated architecture/direction (z88dk/z88dk#3022) + the precise clang ABI reality; corrects the "newlib=sdcccall(1)" wording
type: reference
metadata:
  type: reference
---

**Authoritative z88dk direction, stated by the maintainers on z88dk/z88dk#3022
(suborb = Dominic Morris, member; feilipu = Phillip Stevens, collaborator),
2026-07-25.** This is ground truth; align project understanding to it.

## Library direction: classic, not newlib
- **"classic is the way forward; newlib will continue to exist for compatibility
  reasons."** newlib was a proving ground, supports few targets; moving 150+
  targets to newlib is infeasible. `_DEVELOPMENT` newlib is being deprecated and
  everything useful folded back into classic (largely done; PR #2800; feilipu's
  remaining +zx/+sms targets tracked in #3023).
- **Adding newlib file support (e.g. #34/#3022) is explicitly NOT wanted** —
  less useful than extending classic. So: do not build the newlib disk-file
  layer; use classic for CP/M file I/O.
- classic already serves **sccz80, sdcc, ez80-clang, xcc, 80cc** from ONE set of
  library routines.

## ABI reality (verified from source + codegen, 2026-07-25)
- **Neither library uses plain `sdcccall(1)`.** Public clib functions (classic
  AND newlib) are decorated `__smallc` (=sdcccall(0), stack/caller-clean),
  `__z88dk_callee` (stack/callee-clean), or `__z88dk_fastcall` (one arg in a
  fixed reg by width). clang matches these via `compiler.h` `__LLVMZ80`:
  `__smallc->sdcccall(0)`, `__z88dk_callee->z80_callee`,
  `__z88dk_fastcall->z80_fastcall`.
- Register passing where it matters = **`__z88dk_fastcall`** (suborb's words).
  sdcccall rev1 is <3% best case over rev0+callee/fastcall (feilipu, issue
  #1827); **using sdcccall(0) as the compiler convention is substantially better
  than swapping conventions on every library call.**

## The real newlib-vs-classic difference for llvmz80 (verified, commit 8fec011)
- **newlib** ships native `_callee`/`_fastcall` variants (e.g. `_memcpy_callee`,
  `_strlen_fastcall`) that clang-z80 calls DIRECTLY -> the per-function
  `ex de,hl` ADAPTER modules in `libsrc/l/llvmz80/` are not needed (0 adapter
  `ex de,hl` in the newlib smoke build).
- **classic** needs those hand-written adapter modules (`___memcpy` =
  `call asm_memcpy; ex de,hl; ret`) because the old classic workers return in HL.
- **Correction:** the z88dk/z88dk#3022 intro called this "newlib supports
  sdcccall(1)" — imprecise. The substance (newlib eliminates the ex-de-hl adapter
  layer) is correct and was a real verified conclusion; the mechanism is the
  `_callee`/`_fastcall` variants, NOT sdcccall(1). This is compatible with
  suborb's "neither lib is sdcccall(1)".

## Consequence for the llvmz80 effort
- newlib support for what newlib does TODAY is complete (newlib_iy 24 PASS/0 FAIL;
  only disk FILE* skipped = #34, which we deliberately do NOT fill). Match newlib's
  existing surface; do not extend it.
- Strategically, **classic is the target** the project should keep investing in
  (bridges + callee/fastcall variants), since newlib is compat-only. The
  register-ABI win the project chased is realised via `__z88dk_fastcall`/`_callee`
  variants, not a global sdcccall(1). See [[reference_z88dk_calling_conventions]],
  [[reference_z88dk_clang_register_abi]], [[reference_newlib_remaining_gaps_file_printf]].
