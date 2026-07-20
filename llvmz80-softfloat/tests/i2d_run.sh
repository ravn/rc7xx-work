#!/bin/sh
# i2d_run.sh -- int->double (__floatsidf) regression oracle for ravn/llvm-z80#273.
#
# Builds the f64 SoftFloat closure (build64.sh) + the nanoprintf %f formatter,
# links tests/ft_i2d.c, runs it under z88dk-ticks, and diffs the output against
# tests/ft_i2d.expected.  The %f path is LOSSLESS, so a wrong int->double
# shiftDist (the #273 clz-width bug: (double)5 -> 131074.5) fails this test --
# unlike ft_dbl, which only truncated via (long) and missed it.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)      # .../llvmz80-softfloat/tests
PROJ=$(dirname "$HERE")                  # .../llvmz80-softfloat
WS=$(dirname "$PROJ")                    # workspace root
TICKS="$WS/scratch/dcc-clang-bench/ticks_cpm.py"
export PATH="$WS/z88dk/bin:$PATH"
export ZCCCFG="$WS/z88dk/lib/config/"

V="$PROJ/vendor/berkeley-softfloat-3/source"
INC="-I$PROJ/vendor/config -I$V/8086 -I$V/include"

# 1) f64 closure (gives i32_to_f64, f64_div, intrt.o, rt_mem.o, ...).
CLOS=$(mktemp -d)
OPT=Oz OUT="$CLOS" sh "$PROJ/build64.sh" >/dev/null 2>&1 || { echo "closure build FAILED"; exit 1; }

# 2) nanoprintf %f formatter (reads raw f64 bits; no soft-float arithmetic).
#    -O2: #267's systemic pseudo-sizing fix landed (plus the bridge no longer
#    inflates jr cc->jp cc), so fmt64.c assembles clean at -O2 now.
zcc +cpm -compiler=llvmz80 -Cg-O2 -I"$PROJ/vendor/nanoprintf" -I"$PROJ/src" \
    -c -o "$CLOS/fmt64.o" "$PROJ/src/fmt64.c"

# 3) archive the closure into a dead-strippable lib, then link ft_i2d against it
#    (+ npf formatter + intrt/rt_mem).  Linking the raw *.o blob overflows the
#    CP/M code segment; the lib pulls only the referenced modules.
RT=$(mktemp -d)
rm -f "$CLOS/ft_dbl" "$CLOS/ft_dbl.o" "$CLOS/softfloat_cpm_z80.lib"
mv "$CLOS/intrt.o" "$CLOS/rt_mem.o" "$CLOS/fmt64.o" "$RT/" 2>/dev/null || true
( cd "$CLOS" && z88dk-z80asm -d -xsoftfloat_cpm_z80 *.o >/dev/null 2>&1 )
OUT=$(mktemp -d)
zcc +cpm -compiler=llvmz80 -Cg-O2 -I"$PROJ/vendor/nanoprintf" -I"$PROJ/src" \
    -o "$OUT/ft_i2d" "$PROJ/tests/ft_i2d.c" \
    "$RT/fmt64.o" "$RT/intrt.o" "$RT/rt_mem.o" \
    -L"$CLOS" -lsoftfloat_cpm_z80

GOT=$(python3 "$TICKS" "$OUT/ft_i2d" | grep -v '^\[ticks\]')
EXPECT=$(cat "$PROJ/tests/ft_i2d.expected")
echo "$GOT"
rm -rf "$CLOS" "$OUT" "$RT"
if [ "$GOT" = "$EXPECT" ]; then
    echo "RESULT: ft_i2d PASS"
else
    echo "RESULT: ft_i2d FAIL (int->double corrupt -- see ravn/llvm-z80#273)"
    echo "--- expected ---"; echo "$EXPECT"
    exit 1
fi
