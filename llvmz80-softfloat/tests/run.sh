#!/bin/sh
# run.sh -- build + verify the llvmz80-softfloat Phase 1 work.
#   1) host self-test of the integer cores vs native float
#   2) Z80 link+run of tests/ft_add.c against src/sf32.c, executed under
#      z88dk-ticks (cycle-accurate), output compared to the expected oracle.
#
# Resumable: derives all paths from the workspace root (parent of this dir).
set -e

HERE=$(cd "$(dirname "$0")" && pwd)      # .../llvmz80-softfloat/tests
PROJ=$(dirname "$HERE")                  # .../llvmz80-softfloat
WS=$(dirname "$PROJ")                    # workspace root

CLANG="$WS/llvm-z80/build-macos/bin/clang"
TICKS="$WS/scratch/dcc-clang-bench/ticks_cpm.py"
export PATH="$WS/z88dk/bin:$PATH"
export ZCCCFG="$WS/z88dk/lib/config/"

echo "=== [1/2] host self-test (cores vs native float) ==="
cc -O2 -DSF_SELFTEST -o /tmp/sf32_selftest "$PROJ/src/sf32.c"
/tmp/sf32_selftest

echo
echo "=== [2/2] Z80 link + run (ticks) ==="
OUT=$(mktemp -d)
# Build the soft-float lib at -O0: -O1/-O2/-O3 currently trip an llvm-z80
# branch-relaxation bug (out-of-range `jr` in large functions -> assembler
# "integer range"). -O0 lays the code out so all branches fit. Correctness is
# identical; the shim is not on a hot path.  See EVIDENCE.md.
zcc +cpm -compiler=llvmz80 -Cg-O0 -c -o "$OUT/sf32.o" "$PROJ/src/sf32.c"
zcc +cpm -compiler=llvmz80 -Cg-O2 -o "$OUT/ft_add" \
    "$PROJ/tests/ft_add.c" "$OUT/sf32.o"
GOT=$(python3 "$TICKS" "$OUT/ft_add" | grep -v '^\[ticks\]')
echo "$GOT"

EXPECT='s=5 d=1 e=105 f=94
gt=1 lt=0 eq=1
acc=35'
if [ "$GOT" = "$EXPECT" ]; then echo "RESULT: ft_add PASS"; else
    echo "RESULT: ft_add FAIL"; echo "--- expected ---"; echo "$EXPECT"; exit 1
fi

echo
echo "=== [3/3] Z80 mul/div link + run (ticks) ==="
zcc +cpm -compiler=llvmz80 -Cg-O2 -o "$OUT/ft_mul" \
    "$PROJ/tests/ft_mul.c" "$OUT/sf32.o"
GOTM=$(python3 "$TICKS" "$OUT/ft_mul" | grep -v '^\[ticks\]')
echo "$GOTM"

EXPECTM='m=3 q2=25 sq=9 r=2
qq=1 pacc=1024'
if [ "$GOTM" = "$EXPECTM" ]; then echo "RESULT: ft_mul PASS"; else
    echo "RESULT: ft_mul FAIL"; echo "--- expected ---"; echo "$EXPECTM"; exit 1
fi

echo
echo "=== [4/4] Z80 rodata.cstN regression (ticks) ==="
# Regression guard for the ".rodata.cstN -> SECTION IGNORE" bridge bug in
# z88dk/lib/llvmz80/llvmz80_rules.1: a runtime-indexed static const double[]
# must read its real values, not 0.0.  Needs only the intrt memmove helper.
zcc +cpm -compiler=llvmz80 -Cg-O2 -o "$OUT/ft_rocst" \
    "$PROJ/tests/ft_rocst.c" "$WS/llvmz80-intrt/src/rt_mem.asm"
GOTR=$(python3 "$TICKS" "$OUT/ft_rocst" | grep -v '^\[ticks\]')
echo "$GOTR"
EXPECTR='ROCST 16436 16420'
if [ "$GOTR" = "$EXPECTR" ]; then echo "RESULT: ft_rocst PASS"; else
    echo "RESULT: ft_rocst FAIL (rodata.cstN dropped -> const double[] reads 0)"
    echo "--- expected ---"; echo "$EXPECTR"; exit 1
fi
rm -rf "$OUT"

echo
echo "=== [libm] transcendental suite via mathf64.lib ==="
# Whetstone is NOT a suite member: full IEEE-754-64 Whetstone does not fit a
# 64 KB CP/M TPA (see README "Whetstone / libm -- the 64 KB size wall").
# Instead run_libm.sh verifies the transcendentals that DO fit (sqrt/atan/exp),
# one binary each, linked against the dead-strippable mathf64.lib.
sh "$HERE/run_libm.sh"

echo
echo "=== [i2d] int->double (__floatsidf) via lossless %f -- ravn/llvm-z80#273 ==="
# Regression guard for the clz-width bug: (double)5 -> 131074.5.  Observes the
# FULL value through nanoprintf %f (not a lossy (long) truncation like ft_dbl),
# so a wrong i32_to_f64 shiftDist is caught.
sh "$HERE/i2d_run.sh"
