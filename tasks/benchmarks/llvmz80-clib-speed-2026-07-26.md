# llvmz80 speed: classic vs newlib clib (2026-07-26)

**Question (user):** with the compiler held fixed (llvmz80 -O2), is code faster
with the classic clib or the newlib clib? **Answer: it depends on the operation —
no single winner; newlib is consistently ~half the code size.**

## Method (controlled)

- Same compiler (`zcc +cpm -compiler=llvmz80 -O2 -create-app`), same C source.
- Only the library route varies: `-clib=default` (classic) vs `-clib=newlib_iy`.
- Compiler codegen is therefore identical between the two — **pure-compute code
  runs the same**; only library calls differ, so only library-heavy ops are shown.
- Comparator declared `__smallc` (portable: sdcccall(0) under clang).
- Cycles = whole-program **cycle-accurate** count via
  `scratch/dcc-clang-bench/ticks_cpm.py` (z88dk-ticks + BDOS stub). ntvcm cycle
  counts are NOT trustworthy for DD/FD/ED opcodes — do not use them.
- Output verified identical across variants (`r=…` matches) → all execute correctly.

## Results (per operation, 150 iterations)

| Operation | classic | newlib (shellsort default) | winner |
|-----------|--------:|---------------------------:|--------|
| qsort (96 ints)          | 82.9M cyc / 7811 B | 125.3M cyc / 3953 B | classic 1.51× faster |
| sprintf (`%d/%u/%x`)     | 27.2M cyc / 7537 B | 18.5M cyc / 3741 B  | **newlib 1.47× faster** |
| string (strcpy/strlen/memcpy) | 393K cyc / 7431 B | 377K cyc / 3582 B | ~tie (newlib 4%) |

Takeaways:
- **qsort**: classic much faster; **sprintf**: newlib much faster; **string**: tie.
- **newlib is ~half the .com size** across the board.
- A naive combined benchmark showed "newlib 38% slower overall" — that was
  **qsort-dominated and misleading**; the per-op split is the real picture.

## Root cause of the qsort gap — and its fix (verified)

Both clibs share the tunable sort engine `libsrc/stdlib/z80/sort/`, but pick
different algorithms via `__CLIB_OPT_SORT`:
- **classic** = `2` → quicksort (hardcoded in `libsrc/classic/stdlib/qsort_core.asm`,
  `QSORT=0`: plain middle pivot).
- **CP/M newlib** = `1` → **shellsort** (template
  `libsrc/newlib/target/cpm/config/config_clib.m4:470`; the generated
  `config_cpm_private.inc` is rebuilt from it — edit the .m4, not the .inc).

Shellsort does more comparisons for these sizes (slower) but is iterative and
smaller (part of newlib's size win). **Verified fix:** set `__CLIB_OPT_SORT = 2`
in the .m4, `make -C libsrc/newlib cpm-clean && make -C libsrc/newlib cpm`,
re-measure isolated qsort:

| qsort | cycles | size |
|-------|-------:|-----:|
| classic quicksort        | 82.9M | 7811 B |
| newlib shellsort (before)| 125.3M | 3953 B |
| newlib quicksort (after) | **93.2M** | 4147 B |

→ **−26% cycles for +194 B**; gap to classic shrinks from +51% to +12%. Residual
12% = newlib quicksort enables insertion-tail + equal-dispersal (`QSORT=0x0c`)
while classic uses plain middle-pivot (`QSORT=0`). **The change was reverted**
(shellsort is the z88dk default; whether to switch CP/M newlib to quicksort is a
size/speed decision + a z88dk-target matter, not shipped here).

## Reproduce

```
export ZCCCFG=…/z88dk/lib/config PATH=…/z88dk/bin:$PATH
export LLVMZ80EXE=…/llvm-z80/build-macos/bin/clang
export LLVMZ80RTLIB=/tmp/softfloat_lib/softfloat_cpm_z80   # sprintf/double
TK=…/scratch/dcc-clang-bench/ticks_cpm.py
# per op, per clib:
zcc +cpm -compiler=llvmz80 -clib=default   -O2 -DOP_QSORT -create-app bench_lib.c -o b
python3 "$TK" b.com 2>&1 1>/dev/null | awk '/^\[ticks\]/{print $2}'
zcc +cpm -compiler=llvmz80 -clib=newlib_iy -O2 -DOP_QSORT -create-app bench_lib.c -o b
python3 "$TK" b.com 2>&1 1>/dev/null | awk '/^\[ticks\]/{print $2}'
```

Harness source: `bench_lib.c` (this directory) — `-DOP_QSORT` / `-DOP_STR` /
`-DOP_SPRINTF` select the isolated workload.
