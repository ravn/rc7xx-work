#!/bin/sh
# run.sh -- build + verify the llvmz80-intrt compiler-rt integer subset.
#   1) host self-test of the cores vs native 32/64-bit arithmetic
#   2) Z80 link+run of tests/ft_int.c against src/intrt.c under z88dk-ticks,
#      plus a check that the library object has NO libcall dependency (it must
#      not recurse into __mulsi3/__muldi3/__udivdi3).
#
# Resumable: derives all paths from the workspace root (parent of this dir).
set -e

HERE=$(cd "$(dirname "$0")" && pwd)      # .../llvmz80-intrt/tests
PROJ=$(dirname "$HERE")                  # .../llvmz80-intrt
WS=$(dirname "$PROJ")                    # workspace root

TICKS="$WS/scratch/dcc-clang-bench/ticks_cpm.py"
export PATH="$WS/z88dk/bin:$PATH"
export ZCCCFG="$WS/z88dk/lib/config/"

echo "=== [1/2] host self-test (cores vs native 32/64-bit) ==="
# intrt_mulsi3.c is a separate TU now (see intrt_mulsi3.c) -- compile both.
cc -O2 -DINTRT_SELFTEST -o /tmp/intrt_selftest \
    "$PROJ/src/intrt.c" "$PROJ/src/intrt_mulsi3.c"
/tmp/intrt_selftest

echo
echo "=== [2/2] Z80 link + run (ticks) ==="
OUT=$(mktemp -d)
# Build at -O0: -O1+ trips the llvm-z80 branch-relaxation bug (ravn/llvm-z80#267,
# out-of-range `jr` -> assembler "integer range") in large functions.
zcc +cpm -compiler=llvmz80 -Cg-O0 -c -o "$OUT/intrt.o" "$PROJ/src/intrt.c"
zcc +cpm -compiler=llvmz80 -Cg-O0 -c -o "$OUT/intrt_mulsi3.o" "$PROJ/src/intrt_mulsi3.c"

# The library must be self-contained: linking ft_int against ONLY the intrt
# objects must resolve every symbol (no other multiply/divide helper pulled in).
# __mulsi3 now comes from its own object intrt_mulsi3.o (split out so the
# packaged archive can share it with newlib's imath -- see intrt_mulsi3.c).
zcc +cpm -compiler=llvmz80 -Cg-O2 -o "$OUT/ft_int" \
    "$PROJ/tests/ft_int.c" "$OUT/intrt.o" "$OUT/intrt_mulsi3.o"
GOT=$(python3 "$TICKS" "$OUT/ft_int" | grep -v '^\[ticks\]')
echo "$GOT"

EXPECT='p=7006652
quo=1000003 rem=99
sdv=-1000003 smd=-2'
if [ "$GOT" = "$EXPECT" ]; then echo "RESULT: ft_int PASS"; else
    echo "RESULT: ft_int FAIL"; echo "--- expected ---"; echo "$EXPECT"; exit 1
fi
rm -rf "$OUT"
