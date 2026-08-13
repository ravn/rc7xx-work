# RC759 / MAME acceptance test — DR C library via the Watcom bridge

Goal (per user): prove that **non-trivial C programs compile and run correctly
on real RC759 hardware** through the Open Watcom → Digital Research C 1.11 bridge,
with **full file I/O and integer arithmetic** — verified in the **MAME `rc759`
driver**, NOT emu2/unicorn (whose file read path is confounded and non-deterministic).

## Result (2026-08-13)

`mtest.c` → `MTEST.CMD` (large model) booted as the disk's autostart program in
the FDC/DMA-fixed MAME `rc759` and printed:

```
== RC759 DRC ACCEPTANCE ==
OK   long mul          OK   fopenb w
OK   long div          OK   256-byte rt
OK   long mod          OK   getw/putw
OK   shift 1<<20       OK   fread block
OK   u16 wrap          OK   ftell 269
OK   gcd 1071,462      OK   fseek/read
OK   sieve<100=25      OK   ungetc
OK   sdiv -7/2,%       OK   rewind
OK   popcount
OK   lfact 12!
OK   lpow10 5
RESULT: PASS 19/19
A>
```

Screenshot: `MTEST_PASS_19of19.png` (the on-screen oracle; captured from
`mame/snap/rc759/`). The same file I/O that emu2 garbles is **correct** here —
confirming emu2's read path was the confound and the DR C file-stream/syscall
path works on real hardware.

## What is exercised

- **Integer arithmetic:** 32-bit `long` mul/div/mod, `<<20` shift, unsigned
  16-bit wrap, Euclid gcd, Sieve of Eratosthenes (25 primes < 100), signed
  division truncation, popcount, and **loop-carried `long`** (`12!`=479001600 via
  a loop, `10^5` via a loop — the exact pattern that exposed the `__I4M` bug).
- **Full file I/O round-trip** (binary mode, `fopenb`): 256-byte `fputc`/`fgetc`
  stream, `putw`/`getw` words, `fwrite`/`fread` block, `ftell` (=269), `fseek`
  (SEEK_SET), `ungetc`, `rewind`.

Each check compares against a hand-computed constant (independent oracle) and
tallies PASS/FAIL; the final `RESULT:` line is drawn last so it survives scroll.

## Reproduce

```bash
./run-mame.sh mtest.c          # build -> disk -> boot MAME -> auto-stop on done
# prints: DONE-SIGNAL word=0x0013 pass=19 fail=0
# and snapshots mame/snap/rc759/0000.png (the RESULT line)
```

Uses the FDC/DMA-fixed `mame/regnecentralend` (commit 59b21dc1312, rebuilt
2026-08-13 — the older 75 MB `mame`/pre-fix debug binary do NOT boot CMDs).

## Completion signal (guest → host)

The guest no longer runs against a blind fixed timer. `mtest.c` ends with
`mame_done((fail<<8)|pass)` (from `mamedone.h`), which executes `OUT 0x2FE,AX`.
Port `0x2FE` is **undecoded** by the rc759 driver, so the write has no hardware
effect, but `done_signal.lua` installs a MAME io-space **write-tap** on it: on
the first write it snapshots the screen, prints
`DONE-SIGNAL word=0x…  pass=N fail=M`, and calls `machine:exit()`. So a passing
run stops in ~24 s real (frame ~4028) instead of waiting out the 400 s cap, and
the host learns pass/fail from the signal word (`0x0013` = 19 pass / 0 fail)
without OCR. `-seconds_to_run 400` remains only as a safety cap: if the guest
hangs and never signals, no `DONE-SIGNAL` line is printed → treat as failure.

To reuse in another program: `#include "mamedone.h"` and call `mame_done(code)`
as the last statement; any 16-bit `code` works (the Lua side just reports it).

## Bridge codegen bug found & FIXED here

A `long` **multiplied/divided in a loop** used to hang on MAME (and yield the
wrong value under emu2): `for(i=0;i<4;i++) r=r*10;` gave `1`, not `10000`. Root
cause was **not** a codegen writeback bug — Open Watcom's 32-bit helper `__I4M`
(`__I4D` for div/mod) was simply **undefined at link** (DR C's `CLEAR?.L86`
doesn't provide it, and `cc-cpm86.sh` didn't link Watcom's `i4m.obj`/`i4d.obj`),
so `call far ptr __I4M` jumped to ~0. Earlier single-long "passes" were all
constant-folded, so none emitted a runtime call. **Fixed** in `cc-cpm86.sh` by
classicizing + linking those cgsupp helpers (and broadening the undefined-symbol
guard). Now verified working: `longloop.c` prints `r=10000`, and `mtest.c`'s
`lfact 12!`/`lpow10 5` loop checks PASS on real MAME. Full write-up in
`../drc-libtest/COVERAGE.md`. `LONGLOOP_HANG_confirmed.png` is the pre-fix
evidence; `MTEST_PASS_19of19.png` is the post-fix proof.
