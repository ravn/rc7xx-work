---
name: reference-ticks-cpm-harness
description: ticks_cpm.py wraps z88dk-ticks with a BDOS stub for cycle-accurate measurement of CP/M .com programs — use this, not ntvcm (ntvcm DD/FD/ED cycle counts are wrong).
metadata:
  type: reference
---

## Harness path

`/Users/ravn/z80/scratch/dcc-clang-bench/ticks_cpm.py`

## Usage

```bash
python3 /Users/ravn/z80/scratch/dcc-clang-bench/ticks_cpm.py program.com
```

Prints program console output to stdout, then `[ticks] N cycles` to stderr.

```bash
python3 .../ticks_cpm.py -q program.com           # suppress cycle line
python3 .../ticks_cpm.py --counter 50000000 x.com # cap run length
```

## Why, not ntvcm

ntvcm's cycle counts are **grossly wrong** for prefixed (DD/FD/ED) opcodes:
`ld (ix+d),r` counted as 6 T-states instead of 23. z88dk-ticks is
cycle-accurate (matches textbook T-states exactly).

## How it works

The script injects a BDOS stub at 0xFE00 and a `jp 0xFE00` at 0x0005.
The stub services BDOS fn 0 (exit → HALT at 0x0000), 2 (conout), 6, 9,
11, 12, 13, 14, 25, 26, 108. Unsupported BDOS functions write a 0xDEAD
sentinel to 0xFFF0 (fatal, detected via -output dump).

Program exit via ret/jp 0/BDOS fn 0 reaches HALT at 0x0000; `-end 0x0000`
stops ticks there. Cycle count = complete program run including CRT0.

## Mandelbrot benchmark result (2026-10-01)

24×64 integer mandelbrot, MAXIT=16, `+static-frame -z80-assume-no-callbacks`
vs plain stack frame:

| Variant | Cycles |
|---|---|
| Stack (IX-frame) | 100,196,893 |
| Static-frame (BSS) | 94,419,451 |
| Speedup | **+5.8%** |

Both versions produce byte-identical output (verified). At 4 MHz = ~1.4s
faster on real hardware (~25s → ~23.6s).

## Same binary in ntvcm and ticks

The same `.com` file runs correctly under both ntvcm and ticks_cpm.py.
ntvcm emits CRLF (`\r\n`), ticks emits LF (`\n`) — strip `\r` to compare.

## Related

[[reference_ticks_canonical_exit_trap]] — for firmware/bare-metal ticks
harnesses (ED FE trap, not BDOS stub).
