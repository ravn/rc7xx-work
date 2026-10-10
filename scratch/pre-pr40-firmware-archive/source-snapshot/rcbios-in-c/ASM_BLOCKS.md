# Inline Assembly Blocks in bios.c

Analysis of every `__asm` block: what it does, why it's asm, and whether it
could be rewritten in C.

## Summary

| Category | Count | Could be C? |
|----------|-------|-------------|
| ISR wrappers (stack switch + RETI) | 3 | No |
| BIOS entry stubs (stack switch) | 6 | No |
| Block memory ops (LDIR/LDDR) | 5 | Maybe (size cost) |
| Block I/O (OTIR) | 1 | Yes (loop) |
| CP/M ABI glue (BC param, A return) | 10 | No |
| Boot entry (SP setup + jump) | 2 | No |
| HALT spin loop | 1 | No |

## `__naked` keyword

`__naked` tells sdcc to generate no prologue, no epilogue, no RET. The
function body is entirely hand-written asm. Without it, sdcc adds register
saves and calling-convention return sequences.

### Experimentally verified: `__naked` is NOT needed for 8-bit returns

sdcccall(1) returns 8-bit in A, matching CP/M. Normal C functions returning
uint8_t generate **identical code** to `__naked` asm versions:

```
/* Normal C — generates: ld a,0xff; ret (3 bytes) */
uint8_t bios_listst(void) { return 0xFF; }

/* __naked asm — generates: ld a,#0xFF; ret (3 bytes) */
uint8_t bios_listst(void) __naked { __asm ld a,#0xFF \n ret __endasm; }
```

Empty void stubs are even better as normal C — sdcc optimizes them to share
a single `l_ret` return point (0 bytes per stub).

### Where `__naked` IS needed

1. **ISR wrappers** — must control DI/EI placement, stack switching, RETI
2. **BIOS entries with stack switching** — SP must change before C code runs
3. **CP/M BC parameter entries** — `bios_settrk/setsec/setdma` receive in BC
   (sdcccall(1) expects HL), need `ld (var),bc` which C can't express
4. **16-bit returns to CP/M** — `bios_seldsk` must return in HL, but
   sdcccall(1) returns 16-bit in DE (`__z88dk_fastcall` solves this)

### Functions that could drop `__naked` (pure C)

| Function | Current | C equivalent | Notes |
|----------|---------|-------------|-------|
| `bios_const` | 7 asm instructions | `return (kbtail != kbhead) ? 0xFF : 0;` | 8-bit return in A matches |
| `bios_listst` | `ld a,#0xFF; ret` | `return 0xFF;` | Identical codegen |
| `bios_reads` | `xor a; ret` | `return 0;` | Identical codegen |
| `bios_wfitr` | `ret` | `void bios_wfitr(void) {}` | Smaller (shared l_ret) |
| `bios_linsel` | `ret` | `void bios_linsel(void) {}` | Smaller |
| `bios_exit` | `ret` | `void bios_exit(void) {}` | Smaller |
| `bios_clock` | `ret` | `void bios_clock(void) {}` | Smaller |
| `bios_hrdfmt` | `ret` | `void bios_hrdfmt(void) {}` | Smaller |

## Cannot be C

### ISR wrappers (`isr_crt`, `isr_pio_kbd`, `isr_floppy`)

Must save/restore all registers, switch SP to ISTACK, call body, EI+RETI.
sdcc's `__interrupt` puts EI at function *entry* which enables nested
interrupts and corrupts `sp_sav`. These must stay `__naked` + asm.

### BIOS entry stubs with stack switching

`bios_conout`, `bios_home`, `bios_seldsk`, `bios_read`, `bios_write` all
switch to the BIOS private stack before calling C code. This is necessary
because CP/M uses a small stack that can't support C call depth. The pattern
is: DI, save SP to `sp_sav`, set SP to 0xF500, call C body, restore SP, EI, RET.

`bios_boot`, `bios_wboot`: set SP=0xF500 and jump to C function. Trivial asm.

### CP/M ABI glue

CP/M passes parameters in BC and expects return values in A (8-bit) or HL
(16-bit). sdcccall(1) uses A/HL for params and A/DE for returns. See
`SDCCCALL.md` "CP/M BIOS ABI vs sdcccall(1)" for the full mismatch table.

**8-bit returns (A) match** — `bios_const`, `bios_listst`, `bios_reads`
could theoretically be pure C since sdcccall(1) returns 8-bit in A. But
they're 1–3 instruction stubs where C adds prologue overhead.

**16-bit returns (HL) don't match** — sdcccall(1) returns 16-bit in DE.
`__z88dk_fastcall` returns in HL (matching CP/M) but takes params in HL
(not BC). So `bios_seldsk` and `bios_sectran` still need asm glue.

**16-bit params (BC) don't match** — sdcccall(1) expects first param in HL.
`bios_settrk/setsec/setdma` store BC directly (2 instructions). A C version
would need an extra `ld hl, bc` equivalent that the compiler can't generate.

Stubs in this category:
- `bios_const`: return 0 or 0xFF in A (keyboard status)
- `bios_conin`: wait loop + ring buffer read + INCONV lookup, return in A
- `bios_settrk/setsec/setdma`: store BC to variable (2 instructions each)
- `bios_listst`: return 0xFF in A
- `bios_sectran`: move BC to HL
- `bios_reads`: return 0 in A
- `bios_wfitr/linsel/exit/clock/hrdfmt`: bare RET stubs

**No benefit from C rewrite** — all are 1–3 instructions.

### HALT

`bios_conin` uses `__asm__("halt")` to wait for interrupts. No C equivalent.

## Could potentially be C

### Block memory operations (LDIR/LDDR)

5 blocks use LDIR or LDDR for bulk memory copy/fill:

1. **`scroll()`** — LDIR 1920 bytes (ROW1→ROW0). C equivalent: `memcpy` or
   byte loop. LDIR is 21T/byte, a C loop would be ~30-40T/byte. For 1920
   bytes that's ~17K extra T-states per scroll. Scroll is visible to the user
   (screen update speed). **Keep asm.**

2. **`clear_screen()`** — LDIR fill 2000 bytes with 0x20. C: `memset` loop.
   Same timing argument as scroll. **Keep asm.**

3. **`delete_line()`** — LDIR variable count (ROW24_OFFSET - cury bytes).
   Complex address arithmetic in asm (13 instructions). C equivalent would be
   cleaner but slower. Count calculation uses `SBC HL,BC` which has no direct
   C equivalent that compiles efficiently. **Keep asm for speed**, but the
   code is fragile — consider C if size reduction is needed.

4. **`insert_line()`** — LDDR variable count (copy backwards). Same analysis
   as delete_line. LDDR has no C equivalent without a reverse loop.
   **Keep asm.**

5. **`init_bios()` display clear** — LDIR fill 0xF800–0xFFCF with spaces.
   Only runs once at cold boot. **Could be C** (loop), but saves nothing
   since it's the same size either way.

6. **`init_bios()` work area clear** — LDIR fill 0xFFD1–0xFFFF with zeros.
   Only runs once. **Could be C.**

### Block I/O (OTIR)

**`init_bios()` SIO programming** — OTIR sends 9/11 bytes to SIO ports.
C equivalent: `for` loop writing each byte. OTIR is faster but this only
runs once at boot. **Could be C** — a loop over the parameter arrays would
be clearer and about the same size.

### bios_conin — the largest rewritable block

24 instructions. Does:
1. Spin waiting for `kbtail != kbhead`
2. Read `kbbuf[kbtail]`
3. Increment tail with wrap (AND 0x0F)
4. Index INCONV table
5. Return character in A

This *could* be C:
```c
uint8_t bios_conin(void) {
    while (kbtail == kbhead)
        __asm__("halt");
    uint8_t raw = kbbuf[kbtail];
    kbtail = (kbtail + 1) & 0x0F;
    return *((uint8_t *)(INCONV_ADDR + raw));
}
```

**Problem**: sdcccall(1) returns 8-bit in A, which is correct. But `__naked`
is needed to avoid prologue/epilogue, and then we can't use C. The asm version
is also tighter (no static variable overhead). **Keep asm** unless the ring
buffer logic needs to change (e.g., for SIO integration).

### bios_const — 7 instructions

Could be `return (kbtail != kbhead) ? 0xFF : 0x00;` but the CP/M convention
requires the result in A, not in the sdcccall(1) return register. With
`__naked`, we'd still need asm for the return. **Keep asm.**

## Conversions completed

All block memory operations and bare stubs have been converted to C:

| Original asm | C replacement | Notes |
|-------------|---------------|-------|
| `scroll()` LDIR | `memcpy(DSPROW(0), DSPROW(1), ...)` | Compiles to LDIR |
| `clear_screen()` LDIR fill | `memset(screen, ' ', SCRN_SIZE)` | Compiles to LDIR |
| `delete_line()` LDIR | `memcpy(dst, dst + 80, count)` | Compiles to LDIR |
| `insert_line()` LDDR | Backward byte loop | sdcc can't generate LDDR; memmove library hangs |
| `init_bios()` LDIR fills | `memset(...)` | Compiles to LDIR |
| `init_bios()` SIO OTIR | C `for` loop | Runs once at boot |
| `bios_list`, `bios_punch` | Empty `void` functions | Share `l_ret` (0 bytes) |
| `bios_reader` | `return 0x1A` | sdcccall(1) 8-bit return in A matches CP/M |
| `bios_const` | `return (kbtail != kbhead) ? 0xFF : 0` | 8-bit return matches |
| `bios_conin` | C with `__asm__("halt")` | Ring buffer in C |
| `bios_listst`, `bios_reads` | `return 0xFF` / `return 0` | Trivial C |
| 5 void stubs | Empty C functions | `wfitr`, `linsel`, `exit`, `clock`, `hrdfmt` |

### memmove library bug

The z88dk `memmove_callee` library function hangs when used for overlapping
backward copies (insert_line). Verified in MAME: the function never returns.
`memcpy` works correctly for non-overlapping forward copies (scroll, delete).
`insert_line` uses an explicit backward byte loop as a workaround.

## Remaining asm (cannot be C)

1. **ISR wrappers** (3): stack switch to ISTACK, register save/restore, EI+RETI
2. **BIOS stack-switch entries** (7): SP to 0xF500 before calling C body
3. **CP/M ABI glue** (4): BC param store, BC→HL identity translation
4. **DI/EI/HALT intrinsics**: `__asm__("di")`, `__asm__("ei")`, `__asm__("halt")`
5. **CCP jump**: `jump_ccp()` moves drive from A to C, jumps to CCP_BASE

z88dk provides `intrinsic_di()`, `intrinsic_ei()`, `intrinsic_halt()` in
`<intrinsic.h>` as potential replacements for the single-instruction asm blocks.
