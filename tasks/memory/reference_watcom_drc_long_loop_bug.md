# Watcom→DR C bridge: `long` mul/div in a loop — undefined `__I4M`, FIXED

Root-caused & fixed 2026-08-13 while building the RC759/MAME acceptance test.

**Symptom (before fix):** a `long` updated with `*`/`/`/`%` each iteration of a
`for`/`while` loop kept its INITIAL value under emu2 and HUNG on real MAME rc759.

```c
long r = 1; int i;
for (i = 0; i < 4; i++) r = r * 10;   /* wanted 10000; hung / yielded 1 */
```

**ROOT CAUSE (verified: `bwdis` disasm + full manual LINK-86):** Open Watcom's
32-bit long-math helper `__I4M` (`__I4D` for div/mod) was UNDEFINED at link.
DR C's `CLEAR?.L86` doesn't provide it and `cc-cpm86.sh` didn't link Watcom's own
`i4m.obj`/`i4d.obj`. `call far ptr __I4M` → unresolved ~0000:0000 → hang on real
80186 (MAME), wrong/no-op under emu2. Watcom's loop codegen was CORRECT
(accumulator DX:AX, multiplier CX:BX, counter SI).

**Why undetected earlier:** every prior "passing" single-long case (`a=a*7L`,
probe8 A/B/C) was CONSTANT-FOLDED at compile time and never emitted a runtime
`__I4M` call. A loop-carried long multiply is the first non-foldable long op.
This RETRACTS the earlier "register writeback / store-back" hypothesis — it was a
missing library link, not a codegen bug.

**FIX (`cc-cpm86.sh`):** classicize the model's cgsupp helpers
(`bld/clib/cgsupp/library/msdos.086/{ms,ml}/i4m.obj`→`I4M.OBJ`, `i4d.obj`→
`I4D.OBJ`; small model needs `--merge-text-into-code`) and link
`OUT=$OBJLIST,I4M,I4D,WMARKS,$CLEAR`. Also broadened the undefined-symbol guard to
fail on ANY undefined except the dead `clear_error` 8087 path (old allowlist only
caught `big_code|small_code|cstart`, so `__I4M` slipped through → silent hang).
i4m.obj = `__U4M`/`__I4M`, i4d.obj = `__U4D`/`__I4D`.

**VERIFIED FIXED:**
- emu2, both models: `mame-tests/longloop.c` → `loop r=10000`.
- **Real MAME rc759, large model: `mame-tests/mtest.c` → RESULT: PASS 19/19**,
  incl. loop-carried `lfact 12!`(=479001600) and `lpow10 5`(=100000). Evidence:
  `mame-tests/MTEST_PASS_19of19.png`.

Full write-up: `scratch/rc759-cmd-toolchain/drc-libtest/COVERAGE.md`
§"Bridge codegen bug: `long` mul/div in a loop — ROOT-CAUSED & FIXED".
