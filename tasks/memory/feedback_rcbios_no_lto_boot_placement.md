# LTO breaks rcbios per-input-file linker placement → no boot

**Lesson (HARD, verified 2026-06-28):** Do NOT enable `-flto` on the rcbios clang
BIOS build. The linker script `rc700_bios.ld` places the pre-relocation boot-code
functions (`relocate_bios`, `verify_relocation`, `bios_hw_init`) into the low
`.boot_code` region via **per-input-file matchers**
(`KEEP(*boot_entry.o(.text*))`, `KEEP(*bios_hw_init.o(.text*))`). Under `-flto`,
`ld.lld` merges every C translation unit into ONE combined LTO module, so those
per-file matchers match nothing and the functions fall through to the high BIOS
`.text` region at VMA 0xDA00 — which is still EMPTY at power-on. `_coldboot`
(low) then `call`s them into unpopulated RAM → NOP-slide → the clang BIOS never
reaches `A>`.

**Fix:** `-flto` removed from `rcbios-in-c/clang/Makefile` CFLAGS. Costs ~15 B
(LTO's win was just inlining one-shot BIOS jump-vector helpers); BIOS region has
~1 KB free.

**General rule:** any linker script that relies on `*<file>.o(...)` input-section
matchers is LTO-incompatible unless those symbols carry explicit
`__attribute__((section(...), used, retain))` tags (the LTO-safe `boot_header`
pattern). Toggling a *compile-time* flag also requires `rm *.o` — a relink alone
reuses cached bitcode and silently still LTOs.

Full writeup: `rc700-gensmedet/rcbios-in-c/tasks/lto-boot-placement-bug.md`.
