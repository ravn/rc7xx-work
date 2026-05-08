---
name: Always test both z88dk and clang before committing rcbios changes
description: Any change touching shared rcbios sources MUST build cleanly under BOTH z88dk SDCC and clang before commit — they have different inline-asm dialects
type: feedback
---

**Rule:** Before committing any change to shared rcbios sources
(`bios.c`, `bios_hw_init.c`, `hal.h`, etc. — anything used by both
build paths), build with **both** compilers:

```
cd rc700-gensmedet/rcbios-in-c
make bios COMPILER=clang     # native macOS clang Z80
make -C sdcc bios.cim        # z88dk SDCC via Docker
```

**Why:** They have subtly different inline-asm dialects and language
quirks. The pitfall I hit: clang requires `__asm__ volatile("...")`
to prevent DCE of outputless inline asm; SDCC's gcc-compat parser
errors with `syntax error: token -> 'volatile'` on that exact form.
SDCC inline asm is implicitly volatile — the keyword is unnecessary
*and* unaccepted. I added `volatile` defensively across `bios.c` and
`bios_hw_init.c`, ran the clang build, saw 5827 bytes, committed and
pushed. The SDCC build path was broken in two commits before the user
caught it.

**How to apply:** When in doubt, build BOTH. The SDCC build via Docker
takes ~30 seconds — cheaper than the cleanup of a broken commit.

The portable pattern for inline asm that needs `volatile` semantics:

```c
/* in hal.h */
#ifdef __clang__
#define ASM_VOLATILE(...) __asm__ volatile(__VA_ARGS__)
#else
#define ASM_VOLATILE(...) __asm__(__VA_ARGS__)
#endif
```

Use `ASM_VOLATILE("...")` in shared sources. Variadic so extended-asm
constraints (`: : "i"(...) : "memory"`) pass through unchanged.

**Other dual-compiler differences worth knowing:**

- SDCC `__naked inline` warns "warning 221: inline function is
  __naked" — harmless, just an SDCC heads-up.
- SDCC accepts `__asm` ... `__endasm` (its native syntax) AND
  `__asm__("string")` (gcc-compat). It does NOT accept `__asm__
  volatile("string")`.
- Clang Z80 has its own ISR shim wrappers in `clang/bios_shims.s`
  that handle save/switch/call/restore. The SDCC build does the
  save/restore inline via `isr_enter*/isr_exit*` helpers. These
  helpers MUST be empty no-op stubs in the clang build path or the
  wrapper double-saves and crashes on RETI.
- Clang reports `const DPB *` → `void *` qualifier loss as a warning;
  SDCC reports the same as `warning 196: pointer target lost const
  qualifier`. Both harmless but be aware.
