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
if [ "$GOT" = "$EXPECT" ]; then echo "RESULT: PASS"; else
    echo "RESULT: FAIL"; echo "--- expected ---"; echo "$EXPECT"; exit 1
fi
rm -rf "$OUT"
