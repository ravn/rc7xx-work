# z88dk Notes for BIOS-in-C

## z80.h Block I/O Functions

z88dk provides `z80_otir()`, `z80_otdr()`, `z80_inir()`, `z80_indr()` in two headers:
- `<z80.h>` — newlib/sdcc path (`_DEVELOPMENT/sdcc/z80.h`), guarded by `__Z80`
- `<arch/z80.h>` — classic path, uses `__LIB__` / `__smallc` conventions

### Why they don't work with `--no-crt`

Our build uses `--no-crt` (no C runtime) to control binary layout exactly.
This means:
1. The `__Z80` preprocessor macro isn't defined, so `<z80.h>` is empty
2. The z80 library (`z80.lib`) isn't linked automatically
3. The callee convention wrappers expect stack-based parameter passing
   that doesn't match `--sdcccall 1` (register params)

### z80_otir assembly size

The actual implementation is tiny:
```asm
; asm_z80_otir (core): 3 bytes
otir
ret

; z80_otir_callee (sdcc wrapper): ~12 bytes
pop af          ; return address
pop hl          ; src
pop bc          ; B=num, C=port
push af         ; restore return
otir
ret
```

### Recommendation: inline asm

For our `--no-crt` standalone binary, inline asm is better:
- Zero overhead (no call/ret, no stack parameter marshalling)
- No library dependency
- 6 bytes per OTIR sequence (ld hl + ld b + ld c + otir)

```c
__asm
    ld hl, _psioa
    ld b, #9
    ld c, #0x0A
    otir
__endasm;
```

vs. library call which adds ~15 bytes per call site (push params + call + wrapper).

If we needed OTIR in many places, a C wrapper function would be worth it:
```c
static void block_out(void *src, uint8_t port, uint8_t count)
{
    (void)src; (void)port; (void)count;
    __asm
        ; sdcccall(1): HL=src, D=port, E=count
        ld c, d         ; port
        ld b, e         ; count
        otir
    __endasm;
}
```

This gives C-callable OTIR with zero library dependency at ~6 bytes.

## Other Useful z80.h Functions

| Function | Purpose | Useful for us? |
|----------|---------|----------------|
| `z80_delay_ms()` | Millisecond delay | No — we have CTC-based timers |
| `z80_delay_tstate()` | T-state delay | No — same reason |
| `z80_inp()` | Port input | No — `__sfr __at` is better (single IN instruction) |
| `z80_outp()` | Port output | No — `__sfr __at` is better |
| `z80_otir()` | Block output | Inline asm preferred (see above) |
| `z80_inir()` | Block input | Same — inline asm if needed |
| `z80_bpoke/bpeek()` | Memory access | No — just use pointers |

**Conclusion**: None of the z80.h functions are worth linking for our standalone
`--no-crt` build. The `__sfr __at` port declarations generate optimal single
IN/OUT instructions, and block I/O is best done with 3-line inline asm.

## Warning 296

`warning 296: non-default sdcccall specified, but default stdlib or crt0`

This is emitted by sdcc when `--sdcccall 1` is used but no matching CRT0/stdlib
is found. Since we use `--no-crt` and provide our own crt0.asm, the warning is
harmless — we don't link any standard library code with mismatched conventions.

Cannot be suppressed currently, but is safe to ignore.
