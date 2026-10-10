# CONOUT Benchmark — ASM FILEX Test

Cycle counts for the ASM FILEX integration test, comparing BIOS variants.
TYPE FILEX.PRN is dominated by CONOUT (character output) — the key metric.

## Results

| Date | BIOS | TYPE cycles | TYPE time | ASM cycles | PC samples |
|------|------|-------------|-----------|------------|------------|
| 2026-03-11 | original-maxi | 178,996,914 | 44.749s | 187,238,614 | 4462 |
| 2026-03-11 | c-bios-6402B | 188,278,829 | 47.070s | 188,598,895 | 4570 |
| 2026-03-11 | c-bios-6438B | 169,554,967 | 42.389s | 188,598,895 | 4336 |
| 2026-03-12 | c-bios-6449B | 162,193,449 | 40.548s | 190,599,307 | 4277 |
| 2026-03-12 | c-bios-6463B | 160,193,036 | 40.048s | 190,599,307 | 4252 |
| 2026-03-12 | c-bios-6438B | 157,712,525 | 39.428s | 188,598,895 | 4180 |
| 2026-03-12 | c-bios-6344B | 156,432,261 | 39.108s | 185,238,201 | 4122 |
| 2026-03-13 | c-bios-5460B | 156,432,261 | 39.108s | 185,238,201 | 4130 |

## Analysis (2026-03-13)

### After boot sector restructure (c-bios-5460B)

Restructured disk layout: moved _cboot into the 128-byte boot sector,
restored CONFI block + Danish conversion tables to their original disk
positions (offset 0x080-0x280), and split into two assembler sections
(BOOT at ORG 0x0000, CODE at ORG 0xDA00).  _cboot now uses linker
symbols to LDIR the CODE section from its physical disk position to
runtime 0xDA00, then copies CONFI to 0xD500 and conversion tables to
0xF680.  Eliminated 864 bytes of padding (6324→5460).  Performance
unchanged — same runtime code, different disk layout only.

## Analysis (2026-03-12)

### After removing all BIOS stack switches (c-bios-6344B)

Removed stack switches from `bios_home`, `bios_seldsk`, `bios_read`,
and `bios_write` — the CP/M 2.2 BDOS saves its own registers and does
not require BIOS functions to preserve any (see `BIOS_REGISTER_ABI.md`).
Saved 85 bytes and ~1.3M cycles.  The C BIOS is now **12.6% faster**
than the original assembly BIOS (156.4M vs 179.0M cycles).

Note: `bios_seldsk` still needs a small `__naked` shim to convert the
sdcccall(1) return register (DE) to CP/M's expected HL.

### After CONOUT stack switch removal (c-bios-6438B)

Eliminated the DI/stack-switch/EI overhead from `bios_conout`.  The old
wrapper saved SP, switched to a dedicated BIOS stack, pushed 4 register
pairs, called conout_body, then reversed everything.  The new version is
a 1-byte `ld a,c` shim that falls through to a normal C function — the
compiler handles register saving.  Saved ~2.5M cycles and 23 bytes.
The C BIOS is now **11.9% faster** than the original assembly BIOS
(157.7M vs 179.0M cycles).

### After deferred cursor update (c-bios-6463B)

Deferring cursor position updates from the CONOUT path to `isr_crt` (50 Hz)
saved ~2.0M cycles (160.2M vs 162.2M).  Instead of 3 port writes per
character (~34,000 times during TYPE), the cursor position is updated at
most once per display frame.  The C BIOS is now **10.5% faster** than the
original assembly BIOS (160.2M vs 179.0M cycles).  Visual effect: cursor
appears to jump to final position rather than tracking each character —
needs visual assessment in interactive use.

### After kbstat cached status optimization (c-bios-6449B)

The C BIOS is now **9.4% faster** than the original REL2.3 assembly BIOS
on TYPE FILEX.PRN (162.2M vs 179.0M cycles).  Pre-computing the console
status byte (`kbstat`) in the keyboard ISR and CONIN — instead of
comparing head/tail pointers on every `bios_const` call — saved ~7.4M
cycles.  `bios_const` is called ~86,000 times during TYPE (once per BDOS
character output), so reducing it from 6 instructions to 2 (`ld a,(kbstat)`
+ `ret`) adds up.

## Analysis (2026-03-11)

### After unrolled LDI scroll optimization (c-bios-6438B)

The C BIOS is now **5.3% faster** than the original REL2.3 assembly BIOS
on TYPE FILEX.PRN (169.6M vs 179.0M cycles).  The unrolled 16×LDI scroll
(16T/byte vs 21T/byte LDIR) recovered ~18.7M cycles from the previous
C BIOS measurement — even more than the predicted 10M, likely because
the LDIR fill trick for memset contributed additional savings.

### Before optimization (c-bios-6402B)

The C BIOS was **5.2% slower** on TYPE FILEX.PRN compared to the original
REL2.3 assembly BIOS.  ASM and STAT times are within 1%, so the difference
was concentrated in character output (CONOUT), not disk I/O.

### Methodology

- `run_mame.sh -c` / `run_mame.sh -oc` run identical tests:
  `ASM FILEX`, `STAT FILEX.PRN`, `TYPE FILEX.PRN`
- Keyboard input via MAME natural keyboard (`emu.keypost`) — BIOS-agnostic
- Timing via `manager.machine.time` (emulated time at 4 MHz Z80 clock)
- PC sampled at 50 Hz (frame rate) during all commands

### C BIOS PC profile (50 Hz sampling, 4570 samples)

| Function | Samples | % | Notes |
|----------|---------|---|-------|
| `_watir` | 1716 | 37.5% | CRT DMA refresh busy-wait (ISR) |
| `__code_compiler_size` | 1136 | 24.9% | BDOS code (not BIOS) |
| `_scroll` | 565 | 12.4% | Screen scroll (memcpy 80×24) |
| `__CODE_size` | 437 | 9.6% | CCP/TPA code |
| `_displ` | 185 | 4.0% | Display character on screen |
| `_bios_conout` | 143 | 3.1% | CONOUT entry + specc dispatch |
| `_cboot` | 100 | 2.2% | Cold boot init (one-time) |
| `_rwoper` | 57 | 1.2% | Disk read/write |
| `_bios_const` | 51 | 1.1% | Console status check |
| `_conout_body` | 43 | 0.9% | CONOUT inner processing |
| `_cursorxy` | 43 | 0.9% | Cursor positioning |
| `_cursor_right` | 32 | 0.7% | Advance cursor |

### Original BIOS PC profile (50 Hz, 4462 samples, no symbol map)

| Address range | Samples | % | Likely function |
|---------------|---------|---|-----------------|
| 0xE75B–0xE761 | 1642 | 36.8% | CRT DMA refresh (≈ `_watir`) |
| 0xDE7D–0xDE7F | 493 | 11.0% | CONIN/CONST busy-wait |
| 0xE4DB–0xE4DD | 59 | 1.3% | Display-related |
| 0xE1B6–0xE249 | ~300 | ~6.7% | Display/scroll code |

### Optimization targets

1. **`_scroll` (12.4%)** — largest BIOS-only hotspot.  The C version uses
   `memcpy()` which may generate slower code than the hand-tuned `LDIR`
   loop in the original BIOS.  Consider inline asm LDIR for the 1920-byte
   screen scroll.

2. **`_displ` + `_bios_conout` + `_conout_body` (8.0%)** — the CONOUT
   call chain.  Function call overhead (push/pop, parameter passing) adds
   up across ~34,000 calls during TYPE.  Merging or inlining small
   functions could help.

3. **`_cursorxy` + `_cursor_right` (1.6%)** — called on every character.
   Already optimized with tail-call fall-through.  Further gains possible
   by simplifying the row×80 multiplication.

## Known issues

- **CONFI.COM** does not print menus on screen.  CONFI uses extended BIOS
  calls and direct screen/cursor manipulation — may be affected by deferred
  cursor update or other recent CONOUT changes.  Needs investigation.

## CONOUT test program (conout_test.c) — IN PROGRESS

22-test exerciser for all CONOUT control characters, escape sequences,
BGSTAR modes, cursor wrapping, and screen operations.  Reads display
memory (0xF800) directly to verify results.

### Status (2026-03-13)

- **21 of 22 tests pass**, T10 (erase to end of screen, 0x1F) fails.
- T10 diagnostic: `A:x00y0B/RRR|` — cursor at (0,11) correct but rows
  10-12 all show 'R' (0x52), meaning erase_to_eos did not clear them.
- **Root cause identified**: `memset()` from z88dk stdlib uses sdcccall(0)
  calling convention (all params on stack), but the BIOS is compiled with
  sdcccall(1) (params in HL/DE/A registers).  This means memset reads
  garbage from the stack instead of the register values.  `clear_screen()`
  appeared to work by luck; `erase_to_eos()` fails because the garbage
  params happen to point elsewhere.
- **Fix written but not yet validated**: Custom `fill()` and `copy()`
  functions using inline asm LDIR replace all memset/memcpy calls in
  bios.c.  The fix compiles (6361 bytes) but T10 still fails — the fill
  function may have a bug, or the CONOUT test's BDOS column tracking
  interferes with cursor positioning for the erase_eos sequence.
- **BDOS TAB interception**: BDOS function 2 intercepts 0x09 and expands
  to spaces at 8-column tab stops.  T7 was rewritten to test BDOS
  behavior (expect 'B' at col 8, not col 5).
- **All test output uses BDOS function 2** (`con()`), no direct BIOS calls.
- conout_test.c is checked in but changes to bios.c are reverted pending
  further debugging of the fill/copy functions.

## Test infrastructure

```
make cycle-test         # C BIOS: timing + 50 Hz PC profile
make cycle-baseline     # Original BIOS: same test, unpatched disk
make profile            # C BIOS: instruction-level trace (debug MAME)
make profile-baseline   # Original BIOS: instruction-level trace
make asm-test           # Correctness test only (no timing)
```
| 2026-03-13 | c-bios-5473B | 156432261 | 39.108065s | 186598482 | 4130 |
| 2026-03-15 | c-bios-5477B | 156432261 | 39.108065s | 185238201 | 4122 |
| 2026-03-19 | c-bios-5542B | 158432673 | 39.608168s | 185238201 | 4155 |
| 2026-03-22 | c-bios-5542B | 157072393 | 39.268098s | 189239027 | 4188 |
| 2026-03-22 | c-bios-5542B | 157072393 | 39.268098s | 189239027 | 4188 |
| 2026-03-22 | c-bios-5542B | 157072393 | 39.268098s | 189239027 | 4188 |
| 2026-03-22 | c-bios-5542B | 157072393 | 39.268098s | 189239027 | 4188 |
| 2026-03-22 | c-bios-5542B | 157072393 | 39.268098s | 189239027 | 4188 |
