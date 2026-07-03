# LTO + rcbios: section attributes required for .boot_code functions

**Status (2026-07-03): RESOLVED.** `-flto` is now ON in rcbios-in-c/clang/Makefile.

**Previous problem (a7a7293, 2026-06-28):** `-flto` was disabled because the linker
script `rc700_bios.ld` placed boot-code functions via per-input-file matchers
(`KEEP(*boot_entry.o(.text*))`, `KEEP(*bios_hw_init.o(...))`). Under LTO, `ld.lld`
merges all TUs into one combined bitcode module — per-file matchers match nothing,
functions fall to `.text` at VMA 0xDA00, which is empty at power-on. Boot fails.

**Fix (fd4a197, 2026-07-03):** mirrors what `boot_block.c` already did for `.boot`:

- `boot_entry.c`: `__attribute__((section(".boot_code"), used))` on `relocate_bios()`
  and `verify_relocation()`
- `bios_hw_init.c`: same on `set_i_reg()`, `setup_ivt()`, `bios_hw_init()`; const
  data `ivt_template[]` uses `__attribute__((section(".boot_rodata"), used))` (separate
  section avoids text/data type conflict)
- `rc700_bios.ld`: `KEEP(*(.boot_code))` + `KEEP(*(.boot_rodata))` added before per-file
  matchers (belt-and-braces — per-file matchers still work for non-LTO scenarios)

**Net result:** 5927 → 5906 B (−21 B). Boot verified: mame-test PASS, 77-track ERR=0.
All boot functions at correct physical addresses (_coldboot 0x0444, _bios_hw_init 0x02C8).

**General rule:** any linker script section that uses `*<file>.o(...)` matchers is
LTO-incompatible unless those symbols also carry explicit `__attribute__((section(...),
used))` tags. The section attribute is the LTO-safe anchor; the per-file matcher is
belt-and-braces for non-LTO builds. `retain` is optional when `KEEP()` is in the ld
script. Toggling a compile-time flag also requires `rm *.o` — relink alone reuses
cached bitcode and silently still LTOs.

**Why:** `section(".boot_code")` tells the LTO linker to emit the function into a named
section regardless of which TU it originated from. `used` prevents the IR-level DCE
from eliminating it before link.
