# Watcom→DR C bridge bug: `long` accumulated across a loop is not written back

Discovered 2026-08-13 building the RC759/MAME acceptance test.

**Symptom:** a `long` updated each iteration of a `for`/`while` loop keeps its
INITIAL value; sometimes hangs instead.

```c
long r = 1; int i;
for (i = 0; i < 4; i++) r = r * 10;   /* expected 10000; bridge yields 1 */
```

**Bisection (`-ecc -0 -ml`, cc-cpm86.sh, run under emu2):**
- SAFE: a single runtime `long` op OUTSIDE a loop — `a=a*7`, `b=b/13`, `c=c%13`,
  `s=s<<20` all correct.
- SAFE: `int` accumulated in a loop (sieve/gcd/popcount/sums).
- BROKEN: `long` accumulated in a loop (`r=r*10` and `r=r*10L` both yield 1);
  a long-returning factorial with a loop can hang.

**Likely cause:** the long lives in a register pair across the loop; the
`__I4M`/`__I4D` helper clobbers it and the result is not stored back — a
writeback/reg-alloc defect in the Watcom `-ecc` cdecl path for this target
(deterministically the *initial* value ⇒ store-back failure, NOT emu2 noise).

**CONFIRMED in real MAME rc759 (2026-08-13):** `longloop.c` (the `r=r*10` loop)
booted as the autostart program HANGS after printing its header — all 45 post-boot
snapshots are byte-identical (same md5). So the defect reproduces on genuine
RC759 hardware emulation, NOT just emu2: under emu2 the same pattern returns the
wrong value (r=1) or hangs; in MAME it hangs. Either way the loop never completes
correctly. Evidence: `mame-tests/LONGLOOP_HANG_confirmed.png`.

**Workaround:** keep loop-carried arithmetic in `int`; compute each `long` as a
single op outside any loop. Factorials/powers via loop accumulation must be
restructured or precomputed. `scratch/rc759-cmd-toolchain/mame-tests/mtest.c`
follows this (17/17 PASS in MAME).

**TODO:** disassemble the loop body (bwdis) to pin the missing store, then file
against the bridge / omf_classicize path. Full write-up: `drc-libtest/COVERAGE.md`
§"Known bridge codegen limitation".
