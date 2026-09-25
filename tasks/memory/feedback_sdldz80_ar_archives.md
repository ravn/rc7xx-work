---
name: feedback_sdldz80_ar_archives
description: sdldz80 cannot lazily resolve symbols from ar archives — only from SDCC text-format .lib files. Always pass ar archives as direct file arguments.
metadata:
  type: feedback
---

`sdldz80 -k dir -l libname` (lazy library search) only works with **SDCC
text-format `.lib` files** — a newline-delimited index of `<name>\n<path>` pairs.
It does NOT understand `ar` archives (`!<arch>` magic).

When given an ar archive via `-k`/`-l`, sdldz80 silently finds nothing and
skips the archive. Symbols from the archive (e.g. `___mulhi3`, `___umodhi3`,
`___udivhi3` from `z80_rt.a`) remain undefined. sdldz80 resolves undefined
symbols to address 0x0000 = start of crt0 → program jumps to crt0 on any
arithmetic call → infinite restart loop → emulator hangs.

**Why:** SDCC's linker predates ar-format libraries; it has its own text-format
lib index. The ar format (ELF toolchain origin) was never supported.

**How to apply:** whenever linking with `sdldz80` and a `.a` ar archive is
needed, pass it as a **direct positional argument**:
```
sdldz80 -m -i out crt0.rel main.rel z80_rt.a   # correct
sdldz80 -m -i out crt0.rel main.rel -k dir -l z80_rt  # WRONG for ar
```

**Fixed locations:**
- `z80-utils/test-runner/src/suites/llc.rs` — commit `0417ed813280`
- `z80-utils/test-runner/src/suites/utils.rs` — commit `13c678f3f4da` (PR #360)

**Symptom:** `?ASlink-Warning-Undefined Global ___mulhi3 referenced by module X`
in linker output → if you see this, z80_rt.a is not being eagerly loaded.
