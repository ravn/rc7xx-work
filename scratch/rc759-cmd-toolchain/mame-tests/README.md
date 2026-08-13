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
RESULT: PASS 17/17
A>
```

Screenshot: `MTEST_PASS_17of17.png` (the on-screen oracle; captured from
`mame/snap/rc759/`). The same file I/O that emu2 garbles is **correct** here —
confirming emu2's read path was the confound and the DR C file-stream/syscall
path works on real hardware.

## What is exercised

- **Integer arithmetic:** 32-bit `long` mul/div/mod, `<<20` shift, unsigned
  16-bit wrap, Euclid gcd, Sieve of Eratosthenes (25 primes < 100), signed
  division truncation, popcount.
- **Full file I/O round-trip** (binary mode, `fopenb`): 256-byte `fputc`/`fgetc`
  stream, `putw`/`getw` words, `fwrite`/`fread` block, `ftell` (=269), `fseek`
  (SEEK_SET), `ungetc`, `rewind`.

Each check compares against a hand-computed constant (independent oracle) and
tallies PASS/FAIL; the final `RESULT:` line is drawn last so it survives scroll.

## Reproduce

```bash
./run-mame.sh mtest.c          # build -> disk -> boot MAME -> snapshot
# then view mame/snap/rc759/000N.png (last frame = RESULT line at A>)
```

Uses the FDC/DMA-fixed `mame/regnecentralend` (commit 59b21dc1312, rebuilt
2026-08-13 — the older 75 MB `mame`/pre-fix debug binary do NOT boot CMDs).

## Known bridge limitation found here

A `long` **accumulated across loop iterations** is not written back under this
bridge config (`-ecc -0 -ml`): `for(i=0;i<4;i++) r=r*10;` yields `1`, not
`10000`. Single `long` ops outside a loop are correct; loop-carried arithmetic
must stay in `int`. **Confirmed on real MAME rc759** by `longloop.c`, which
HANGS after its header (45 byte-identical post-boot snapshots —
`LONGLOOP_HANG_confirmed.png`), so this is a genuine bridge codegen defect, not
an emu2 artifact. Full bisection in `../drc-libtest/COVERAGE.md`
(§"Known bridge codegen limitation"). `mtest.c` is written to avoid the pattern.
