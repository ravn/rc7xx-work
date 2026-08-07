---
name: reference_llvmz80_bdos_pointer_arg_scramble
description: FIXED — bdos() scrambled the func number under -compiler=llvmz80 when an arg was a pointer; root cause was #279 (__smallc→z80_smallc) breaking cpm.h's reversed-param workaround
metadata:
  type: reference
---

**FIXED 2026-08-07** (ravn/z88dk#52, cpm.h commit `b9e7e72b98`, branch
`fix/llvmz80-graphics-hl-return`, local/unpushed). Root cause: cpm.h had an
llvmz80-only reversed-order `__bdos_llvmz80(arg,func)` + swapping macro, correct
while `__smallc` == sdcccall(0) (right-to-left). **#279 redefined `__smallc` as
`z80_smallc` (left-to-right)** → double reversal → `func` on top, but the
`bdos_callee.c` worker pops `de=arg` (top) / `bc=func` (deeper), so a pointer
arg became the func number (0xE8) and `bdos(f,0)` issued func 0 = warm boot.
Fix: drop the llvmz80 special-case; natural `bdos(func,arg)` is correct for both
conventions now. Guard: `test/clang/issue52_bdos_ptr_abi.{c,sh}` (pointer arg).
Both classic + clang builds of the cpnos disk-quicksort test now pass. The rest
of this note is the original diagnosis (kept for context).

`zcc +cpm -compiler=llvmz80`: `bdos(func, arg)` works when both args are
small integers (e.g. `bdos(12, 0)` version — ravn/z88dk#20 GREEN,
[[z88dk_z88dk_callee_llvmz80_abi_class]]), but **scrambles when `arg` is a
pointer** cast to int — the common FCB / set-DMA case
(`bdos(26, (int)dmabuf)`, `bdos(33, (int)fcb)`).

Symptom (2026-08-07, building `cpnos-shared/testutil/qsort_disk.c` for the
`cpnos-qsort-test` random-access disk test): under ntvcm the llvmz80 `.COM`
prints `unhandled BDOS FUNCTION 186 = 0xBA` / `125 = 0x7D` — i.e. the BDOS
function number comes out as a byte of the pointer, so func and the
pointer arg are mis-passed. The IDENTICAL source built with z88dk classic
(sccz80) PASSES (`QSORT OK 32`), so it is compiler-specific, not an
algorithm bug.

Root class: the `__z88dk_callee`/`__smallc` push-order + arg-width mismatch
(`[[z88dk_z88dk_callee_llvmz80_abi_class]]`). `bdos`/`bdosh` were "fixed"
there, but the fix/guard (issue20) only exercises integer args; the
pointer-arg path is still broken. ~1500 decls remain unaudited.

Consequence for CP/M file-I/O tests: build them with **z88dk classic**
(the working build) until the llvmz80 bdos pointer-arg ABI is fixed in the
z88dk fork. That is a separate z88dk-bridge task, not a per-test fix.
See [[project_rc702_mame_fork_reconciled_2026-08-07]] for the qsort test.
