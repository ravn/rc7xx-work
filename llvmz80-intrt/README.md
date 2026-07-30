# llvmz80-intrt — minimal compiler-rt integer runtime for zcc + llvm-z80

`zcc +cpm -compiler=llvmz80` ships **no compiler-rt**, so any 32-bit multiply or
64-bit multiply/divide/mod becomes a libcall that is undefined at link. This
subproject supplies that missing subset, built entirely from shift/add/subtract/
compare (64-bit add/shift/compare *do* link) so the object has **zero libcall
dependencies** and cannot recurse into itself.

It exists because it is a hard prerequisite for Phase 3 of `../llvmz80-softfloat`
(double precision via Berkeley SoftFloat needs 64-bit integer multiply/divide),
and it independently fixes `long` / `long long` arithmetic for ordinary C.

## Symbols provided (verified missing on this toolchain, 2026-07-15)

| symbol | meaning | core |
|--------|---------|------|
| `__mulsi3`  | 32×32→32 multiply (low word)     | shift-add |
| `__muldi3`  | 64×64→64 multiply (low word)     | shift-add |
| `__udivdi3` | unsigned 64-bit divide           | restoring long division |
| `__umoddi3` | unsigned 64-bit remainder        | restoring long division |
| `__divdi3`  | signed 64-bit divide             | sign-magnitude around the unsigned core |
| `__moddi3`  | signed 64-bit remainder (sign of dividend) | sign-magnitude |

`__divsi3` / `__udivsi3` / `__modsi3` / `__umodsi3` and 16-bit multiply already
link (z88dk provides them), so they are intentionally **not** reimplemented.

## Layout

```
src/intrt.c     the six helpers + an internal udivmod64 + host self-test (-DINTRT_SELFTEST)
tests/ft_int.c  on-target ticks fixture (integer witnesses, printed with %ld)
tests/run.sh    host self-test + Z80 link/run + self-containment check
```

## Verify

```sh
sh tests/run.sh
```

Runs the host self-test (2,000,000 random cases vs native 32/64-bit, expect
`bad=0`) and the Z80 fixture under `z88dk-ticks` (expect `p=7006652`,
`quo=1000003 rem=99`, `sdv=-1000003 smd=-2`, `RESULT: ft_int PASS`).

## Notes / caveats

- The library is built at `-Cg-O0`: `-O1`+ trips the llvm-z80 branch-relaxation
  bug (**ravn/llvm-z80#267**, out-of-range `jr` → assembler `integer range`).
  Correctness is identical; these helpers are not on a hot path here.
- The shift-add / bit-at-a-time cores are correct but slow (32/64 iterations).
  A faster 8-bit-digit multiply and a normalized divide are a later optimization
  once double-precision soft-float is functional.
- Signed `%` follows C99: the remainder takes the sign of the dividend.
