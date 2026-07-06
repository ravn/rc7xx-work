# LTO + rcbios: section attributes required for .boot_code functions AND boot_data/bios_jt

**Status (2026-07-06): FULLY RESOLVED.** `-flto` is ON and boots to `A>` in MAME
(both compilers). The 2026-07-03 "RESOLVED" claim below was PREMATURE — it fixed
only the boot *code* placement, missing two data sections; the boot silently hung
in FDC SPECIFY for three days (documented as `KNOWN_ISSUE_clang_bios_fdc_hang`)
until the data-placement gap was found 2026-07-06.

**The 2026-07-06 completion — two MORE per-file matchers were LTO-broken:**

1. `.boot_data 0x0080` (`confi_on_disk[]` + `conv_tables[]` in `boot_confi.c`):
   under LTO these fell to generic `.rodata` at a high runtime addr (0xE78D/0xE80D).
   `relocate_bios()` copies FROM these symbols at coldboot (must be physical
   0x0080/0x0100 where ROM loaded Track 0) — so it read UNINITIALISED RAM into CFG,
   giving garbage CTC config -> spurious FDC interrupts (2nd Sense-Int ST0=0x80 at
   t=1.62s, phantom 2nd SPECIFY at t=3.43s) -> hang in `fdc_write` poll (PC 0xDA9E).
   FIX: `__attribute__((section(".boot_data"), used))` on both arrays + `KEEP(*(.boot_data))`.
2. `.bios_jt BIOSAD` (`bios_jump_vector_table` in `clang/bios_jump_vector_table.c`):
   the frozen CP/M BIOS ABI table MUST sit at 0xDA00. Under LTO the per-file matcher
   failed, `_jump_ccp` landed at 0xDA00 instead -> banner printed but CCP/BDOS called
   wrong entries -> no `A>`. FIX: `sym __attribute__((section(".bios_jt"), used))`
   (attribute AFTER the variable name — before it binds to the anon struct type and
   clang errors) + `KEEP(*(.bios_jt))`.

Diagnostic method that nailed it: MAME PC-trace showed SP climbing monotonically +2
per CRT-interrupt while PC bounced in relocate_bios's LDIR region, then wedging at
0xDA9E; the `relocate_bios` copy-source disasm (0xE78D vs 0x0080) was the smoking gun.
Result: 5906 B, boots in ~2s. **Lesson: after an LTO section-attr fix, grep the WHOLE
linker script for `*<file>.o(` and confirm EVERY matched symbol carries the attr — a
partial fix boots far enough to look plausible (banner shows) yet still hangs.**

**Defense-in-depth added 2026-07-06 (so this class fails LOUDLY at build time, never silently):**
1. **Link-time ASSERTs** in `clang/rc700_bios.ld` — `ASSERT(_confi_on_disk==0x0080)`,
   `ASSERT(_conv_tables==0x0100)`, `ASSERT(_bios_jump_vector_table==BIOSAD)`,
   `ASSERT(SIZEOF(.boot_data)==0x200)`, `ASSERT(SIZEOF(.bios_jt)==0x71)`.  Verified: they
   FIRE on a build missing the section attrs, PASS on a correct build.  Zero runtime cost.
   This is the cpnos-in-c/payload.ld discipline (which already asserts `_bios_boot==0xEE00`
   etc.) finally applied to rcbios — rcbios was the ONLY of the four components lacking it,
   which is exactly why the hang went undetected there.
2. **`.cflags` fingerprint** in `clang/Makefile` — every C object depends on a stamp file
   whose contents are `$(CFLAGS)`; toggling ANY compiler flag (e.g. `-flto`) bumps its mtime
   and forces a rebuild, killing the stale-`.o` trap that produced fd4a197's FALSE
   "mame-test PASS" (relink reused non-LTO objects -> looked fine -> clean rebuild next day
   exposed the real hang).  **General principle (user 2026-07-06): enabling a compiler flag
   must produce fewest surprises — either it just works or it fails loudly at build; never a
   silently-wrong artifact.  A flag lives in CFLAGS, so make the objects depend on CFLAGS.**
3. Follow-up parked: `rcbios-in-c/tasks/PARKED_lto_further_size_savings.md` (exploit LTO for
   more than the current −25 B, once safe).

**Superseded premature status (2026-07-03): "RESOLVED."** `-flto` is now ON in rcbios-in-c/clang/Makefile.

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
used))` tags — this applies to DATA (`confi_on_disk`, `conv_tables`, the CP/M jump
table) exactly as much as to code. The section attribute is the LTO-safe anchor; the
per-file matcher is belt-and-braces for non-LTO builds. `retain` is optional when
`KEEP()` is in the ld script. Toggling a compile-time flag also requires `rm *.o` —
relink alone reuses cached bitcode and silently still LTOs. When enabling/verifying
`-flto`, `grep -nE '\*[a-z_]+\.o\(' the_linker_script` and confirm EVERY matched symbol
carries the section attr — the fix is only complete when the count reaches zero
unanchored. For a variable with an inline anonymous struct type, the attribute must
follow the VARIABLE NAME (`} name __attribute__((...)) = {`), not the closing brace.

**Why:** `section(".boot_code")` tells the LTO linker to emit the function into a named
section regardless of which TU it originated from. `used` prevents the IR-level DCE
from eliminating it before link.
