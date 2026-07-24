---
name: newlib clang remaining gaps — disk FILE* (#34) + variadic %f (#35)
description: After Phase C + qsort/strerror fixes, the two remaining newlib_iy skips; both root-caused, filed on ravn/z88dk
type: reference
---

**2026-07-24.** With the sanctioned `-clib=newlib_iy` route otherwise green
(23 PASS / 0 FAIL), exactly two genuine product gaps remain, both filed:

- **ravn/z88dk #34 — disk FILE\* I/O does not link on newlib.** `fopen`/fcntl
  pull `libsrc/newlib/fcntl/z80/asm_vopen.asm`, which delegates to target hooks
  `asm_target_open_p1`/`asm_target_open_p2`. The CP/M **newlib** target
  (`libsrc/newlib/target/cpm/`) ships console/char drivers but **no file-open
  driver**, so both hooks are undefined. **Compiler-independent** — sccz80
  (`-clib=new`), sdcc (`-clib=sdcc_ix`) and clang (`-clib=newlib_iy`) all fail
  identically. Classic clib FILE\* is complete + MAME-verified, so classic is
  the working CP/M file-I/O path. Test `runtime_file.sh` skipped on newlib.

- **ravn/z88dk #35 — newlib variadic `%f` drops clang IEEE-754 double.**
  `printf("%f", 3.5)` links + runs but prints `val=` (empty). clang lowers
  `double` to IEEE-754; z88dk's variadic printf float converter expects native
  math48/MBF. On **classic** the opt-in `-D__LLVMZ80_IEEE_PRINTF` header route
  swaps in a nanoprintf/softfloat converter (works → `3.141593`), but that
  interposition is not wired into the **newlib** stdio `vfprintf` path (plan
  Phase D). Distinct from #25 (dhrystone spurious %f link fail) and #31
  (variadic return-value garbage). Test `runtime_printf_ieee.sh` skipped on
  newlib.

Not product gaps (no issue): `printf_ieee` on classic skips only because the
softfloat lib isn't pre-built at `/tmp/softfloat_lib/` (test-env artifact);
`xfail_tmpfile` is a CP/M platform limitation (no temp-file primitive).

Related: [[reference_newlib_integer_helper_gap]],
[[reference_llvmz80_qsort_strerror_classic_fix]].
