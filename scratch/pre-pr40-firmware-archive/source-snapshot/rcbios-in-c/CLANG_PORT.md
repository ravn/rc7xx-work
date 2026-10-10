# Clang/LLVM-Z80 Port of rcbios-in-c

## Status: BOOTS CP/M (5957 bytes -Oz, MAME verified 2026-04-01)

## Size Comparison (2026-04-01, same source, MSIZE=56)

| Compiler | Binary | vs SDCC | Notes |
|----------|--------|---------|-------|
| SDCC (z88dk) | 5570 B | — | Fits MINI (6144B) |
| **Clang -Oz** | **5957 B** | **+387B (+6.9%)** | **Fits MINI (187B spare)** |

Both MINI (6144B) and MAXI (9984B) supported.

### Size history

| Change | Clang | Delta | Cumulative |
|--------|-------|-------|------------|
| Initial -Os build | 6379 B | — | — |
| Switch to -Oz | 6041 B | -338 B | -338 B |
| Remove blanket volatile | 5996 B | -45 B | -383 B |
| scroll: memmove→memcpy (LDIR) | 5957 B | -39 B | -422 B |

## Decision Log
- No `+shadow-regs` for rcbios (ISRs use explicit register save/restore)
- All assembly in single `bios_shims.s` file
- Keep clang C files assembly-free (intrinsic.h with static inline OK)
- Two jump vector tables: SDCC (naked shims in bios.c) and clang (shims in bios_shims.s)
- Banner shows compiler: `C-bios/clang` or `C-bios/sdcc`

## Bugs Found / Fixed
- ravn/llvm-z80#44 — address_space(2) PHI crash on conditional port I/O
  - Workaround: noinline per-channel SIO functions (~12B overhead)
- Missing `__umodqi3` (8-bit unsigned modulo) — added to runtime.s
- Blanket `volatile` on WorkArea struct (from 2f06e78 refactoring) prevented
  optimizer from keeping display fields in registers. Fixed: per-field volatile
  on ISR-modified fields only. Saved 45B.

## Compiler Features Verified

| Feature | Status | Notes |
|---------|--------|-------|
| `__attribute__((naked))` | WORKS | Suppresses prologue/epilogue |
| `__attribute__((interrupt))` | WORKS | Generates EI + RETI (ravn/llvm-z80#3 fixed) |
| `__attribute__((section("...")))` | WORKS | Places code in named sections |
| `address_space(2)` port I/O | WORKS | Generates IN/OUT (crashes on PHI, #44) |
| Undocumented instructions | CLEAN | No IXH/IXL/IYH/IYL in output |

## Issues

### rc700-gensmedet
- #1 — Umbrella: Port rcbios-in-c to clang — **IN PROGRESS**
- #2 — Inline asm translation — **CLOSED** (bios_shims.s)
- #3 — LLD linker script — **CLOSED**
- #4 — ISR handling — **CLOSED**
- #5 — bios_shims.s — **CLOSED**

### llvm-z80
- ravn/llvm-z80#3 — EI before RETI — **CLOSED**
- ravn/llvm-z80#4 — `__critical` equivalent — OPEN (workaround: Z80 HW disables interrupts on entry)
- ravn/llvm-z80#42 — Built-in intrinsics — OPEN (low priority, intrinsic.h workaround)
- ravn/llvm-z80#43 — Custom CP/M calling convention — OPEN (low priority, shims work)
- ravn/llvm-z80#44 — address_space(2) PHI crash — OPEN (noinline workaround)

## Clang Build Command

```bash
CFLAGS="--target=z80 -Os -nostdlib -ffunction-sections -fdata-sections \
  -Xclang -target-feature -Xclang +static-stack -mllvm -disable-lsr \
  -Iclang_z80 -I. -Wno-gcc-compat -Wno-return-type -DMSIZE=56"

# Compile C files with $CFLAGS, assemble .s with --target=z80
# Link with: ld.lld --gc-sections --defsym BIOSAD=0xDA00 -T clang_z80/rc700_bios.ld
# Extract binary: llvm-objcopy -O binary bios.elf bios.bin
```

## Relocation Sentinel Check (#51)

The BIOS is loaded from disk Track 0 to low memory, then `relocate_bios()`
in `boot_entry.c` copies it to the runtime address (BIOSAD = 0xDA00) and
zeros the BSS section.  The BSS clear uses a forward-LDIR trick:

```
LD HL, bss_start      ; first byte
LD (HL), 0            ; zero it
LD D,H / LD E,L       ; DE = HL
INC DE                 ; DE = bss_start + 1
LD BC, bss_size - 1
LDIR                   ; forward-copy the zero through BSS
```

**Bug #51:** With `+static-stack`, clang allocates function locals in BSS.
The C version of this code stored the `dest = bss_start + 1` pointer to
a BSS static variable, then `*(bss_start) = 0` zeroed the low byte of
that stored pointer.  Result: LDIR wrote to a wrong address, zeroing
`.rodata` including the boot banner string.

**Fix:** The BSS clear is now inline asm (clang path), computing the
destination in registers without touching BSS.

**Sentinel:** The linker script (`clang/rc700_bios.ld`) places a 2-byte
sentinel word `0x1842` at the end of `.data`, immediately before `.bss`:

```
.sentinel : {
    __sentinel_addr = .;
    SHORT(0x1842)
} > BIOS
```

After the BSS clear, `boot_entry.c` verifies the sentinel is intact:

```c
if (_sentinel_addr != SENTINEL_VALUE)
    for (;;) hal_halt();  /* hang — BSS clear overwrote data */
```

If the sentinel is zeroed, the BIOS halts immediately — no banner, no boot.
This catches any future BSS clear overwrite regression at the earliest
possible point.

## Remaining Work
- [x] Unrolled LDI scroll (memcpy_z80, 20% faster, 4.7% TYPE speedup)
- [x] Sentinel check for BSS clear (#51)
- [x] Build refactor: clang/ and sdcc/ folders, COMPILER variable
- [ ] rc700-gensmedet#6: z88dk memmove hangs (blocks LDDR in insert_line for SDCC)
- [ ] ravn/llvm-z80#53: +static-stack allocates constant locals to BSS
