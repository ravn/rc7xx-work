---
name: newlib clang remaining gaps — disk FILE* (#34) + variadic %f (#35)
description: After Phase C + qsort/strerror fixes, the two remaining newlib_iy skips; both root-caused, filed on ravn/z88dk
type: reference
---

**2026-07-24.** With the sanctioned `-clib=newlib_iy` route otherwise green
(23 PASS / 0 FAIL), exactly two genuine product gaps remain, both filed:

- **ravn/z88dk #34 — disk FILE\* I/O does not link on newlib — UNSUPPORTED FOR NOW**
  (wontfix, 2026-07-25). `fopen`/`open` -> `asm_vopen` delegates to target hooks
  `asm_target_open_p1`/`asm_target_open_p2`, which **no newlib z80 target
  implements** (symbols occur only as the EXTERN in `asm_vopen.asm`, header dated
  "October 2014"; `git log -S` finds zero impls). NOT CP/M-specific and NOT
  clang-specific — sccz80/sdcc/clang all fail, and rc2014/yaz180 `diskio` drivers
  are raw block/sector, not wired to fopen. stdin/stdout/stderr work because the
  CRT statically instantiates the console drivers, bypassing vopen. This is the
  newlib "last mile" the architect **aralbrec acknowledged in upstream
  z88dk/z88dk#1426** ("most of the pieces are there ... just missing the last
  mile"); no open upstream issue tracks its completion. **Decision: use the
  classic clib for CP/M file I/O (complete + MAME-verified); do not build the
  newlib disk driver.** If ever finished: `asm_target_open` dispatcher
  (device-name vs filename) + a CPM_DISK_FILE STDIO_MSG driver over BDOS FCB,
  porting the classic `libsrc/target/cpm/fcntl/` (~1760 lines). Test
  `runtime_file.sh` skipped on newlib. **Upstream discussion filed
  2026-07-25: z88dk/z88dk#3022** (status question + offer of an AI-assisted CP/M
  implementation of `asm_target_open` + a disk-file driver; cross-linked on
  ravn/z88dk #34). Await maintainer direction (implement the hook vs FatFs
  C-wrapper #1426 vs leave unsupported) before writing any code.

- **ravn/z88dk #35 — newlib variadic `%f` — FIXED 2026-07-25** (z88dk commit
  cbbcc50031). Stock `printf("%f")` on `-clib=newlib_iy` + `-D__LLVMZ80_IEEE_PRINTF`
  now prints correct IEEE-754 (`3.141593`); `runtime_printf_ieee` flipped
  skip→PASS (newlib_iy 24 PASS / 0 FAIL, classic 25/0). See
  [[reference_llvmz80_newlib_ieee_printf_fix]]. Original diagnosis: clang lowers
  `double` to IEEE-754; z88dk's variadic printf expects native math48/MBF. The
  classic `-D__LLVMZ80_IEEE_PRINTF` nanoprintf route is now also wired into the
  newlib `_DEVELOPMENT` stdio.h + a newlib-compiled shim lib.

- **ravn/z88dk #37 — `<math.h>` + libm — UNSUPPORTED FOR NOW** (wontfix,
  2026-07-26). `<math.h>` fails to compile under llvmz80 (its `_FLOAT16_T` block
  typedefs `_Float16`, a reserved clang keyword unsupported on z80); guard fix
  known but NOT applied. Even guarded, libm doesn't link (`_sqrt_fastcall` uses
  newlib's native float format, not clang IEEE-754 double; some compiler-rt float
  libcalls absent). clang doubles use softfloat (`LLVMZ80RTLIB`) + `mathf64`, not
  newlib math. All other core headers compile fine. Same "known gap" treatment as
  #34.

Not product gaps (no issue): `printf_ieee` on classic skips only because the
softfloat lib isn't pre-built at `/tmp/softfloat_lib/` (test-env artifact);
`xfail_tmpfile` is a CP/M platform limitation (no temp-file primitive).

Related: [[reference_newlib_integer_helper_gap]],
[[reference_llvmz80_qsort_strerror_classic_fix]].
