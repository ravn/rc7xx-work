# kox.pas — CRT Display Breaker

Turbo Pascal program photographed from an RC702 screen.
Source: `A:KOX.PAS` (photo `IMG_3994.jpeg`)

Deliberately corrupts the CRT display by rapidly cycling through
nonsensical 8275 parameters until a key is pressed, then restores
the correct settings. A visual stress test / prank program.

## Transcription

```pascal
program koxfix;
(*$u-,s+,r-,a-*)

var a:char;
    x:integer;

begin (*Ready to break down*)
    x:=0;
    repeat
        port(.1.):=0;(*Breaking down until any key is pressed*)
        port(.0.):=64;port(.0.):=16;port(.0.):=$9a;port(.0.):=80+x;
        port(.1.):=35;port(.1.):=128;
        port(.0.):=0;port(.0.):=0;
        x:=(x+1) mod 175
    until keypress;(*No more breaking*)
    port(.1.):=0;
    port(.0.):=$4f;port(.0.):=$98;port(.0.):=122;
    port(.0.):=205;
    port(.1.):=35;port(.1.):=$80;
    port(.0.):=0;port(.0.):=0;
end.
```

## Notes

- `port(.0.)` / `port(.1.)` is Turbo Pascal trigraph for `port[0]` / `port[1]`
  (alternative bracket syntax: `(.` = `[`, `.)` = `]`)
- Port 0 = 8275 CRT data register (PAR writes, cursor position)
- Port 1 = 8275 CRT command register (Reset, Start Display, Load Cursor)
- `(*$u-,s+,r-,a-*)` = Turbo Pascal compiler directives:
  user break off, stack checking on, range checking off, absolute code off

## Analysis

### The breaking loop

Each iteration sends a full 8275 Reset + Start Display + Load Cursor
sequence with a different PAR4 value, deliberately corrupting the
display as fast as possible:

| Step | Code | Port | Value | Meaning |
|------|------|------|-------|---------|
| 1 | `port[1]:=0` | cmd | 0x00 | Reset command |
| 2 | `port[0]:=64` | data | 0x40 | PAR1: 65 chars/row |
| 3 | `port[0]:=16` | data | 0x10 | PAR2: V=0(1 VRTC), R=16 → 17 rows |
| 4 | `port[0]:=$9a` | data | 0x9A | PAR3: U=9(underline), L=10 → 11 lines/char |
| 5 | `port[0]:=80+x` | data | varies | PAR4: cycles 0x50..0xFE |
| 6 | `port[1]:=35` | cmd | 0x23 | Start Display (burst space=0, burst=8) |
| 7 | `port[1]:=128` | cmd | 0x80 | Load Cursor |
| 8 | `port[0]:=0;0` | data | 0,0 | Cursor at (0,0) |

The loop counter `x` runs from 0 to 174, making PAR4 cycle from
80 (0x50) to 254 (0xFE). Combined with the non-standard PAR1-PAR3
values (65 chars/row, 17 rows), this produces rapidly changing
garbage on screen — the display "breaks down" until a key is pressed.

### The restore block

After pressing a key, restores the machine's normal CRT settings:

| Step | Code | Port | Value | Meaning |
|------|------|------|-------|---------|
| 1 | `port[1]:=0` | cmd | 0x00 | Reset command |
| 2 | `port[0]:=$4f` | data | 0x4F | PAR1: 80 chars/row (standard) |
| 3 | `port[0]:=$98` | data | 0x98 | PAR2: V=2(3 VRTC), R=24 → 25 rows (standard) |
| 4 | `port[0]:=122` | data | 0x7A | PAR3: U=7, L=10 → 11 lines/char (standard) |
| 5 | `port[0]:=205` | data | 0xCD | PAR4: see below |
| 6 | `port[1]:=35` | cmd | 0x23 | Start Display |
| 7 | `port[1]:=$80` | cmd | 0x80 | Load Cursor |
| 8 | `port[0]:=0;0` | data | 0,0 | Cursor at (0,0) |

PAR4 restore value 205 = 0xCD = `1100 1101`:
- Bits 7:4 = 0xC → 12+1 = **13 lines per character row**
- M = 1 (line counter offset by 1)
- F = 1 (non-transparent field attributes)
- CC = 00 (blinking reverse video block cursor)
- ZZZZ = 1101 → (13+1)*2 = 28 horizontal retrace character clocks

This machine used **13 lines/char** — taller than the standard BIOS
settings (REL30: 7 lines = 0x6D, REL21: 5 lines = 0x4D). Possibly
a higher-resolution character generator ROM or a custom display
preference for more inter-line spacing.

### Comparison with known BIOS PAR4 values

| Source | PAR4 | Lines/char | Cursor | Notes |
|--------|------|-----------|--------|-------|
| REL21 (original) | 0x4D | 5 | blink block | Compact display |
| REL30 (Comal80) | 0x6D | 7 | steady block | Standard |
| kox.pas restore | 0xCD | 13 | blink rev block | Tall characters |
| ROA375 PROM | 0x5D | 6 | blink underline | Boot ROM |
