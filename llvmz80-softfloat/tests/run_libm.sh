#!/usr/bin/env bash
# run_libm.sh -- libm correctness suite for zcc + llvm-z80, replacing the
# Whetstone driver (which cannot fit a 64 KB CP/M TPA; see README "Whetstone /
# libm -- the 64 KB size wall").
#
# Strategy: build ONE mathf64.lib (SoftFloat f64 closure + vendored musl libm)
# and link ONE tiny binary PER transcendental against it, so z80asm pulls only
# the modules that function needs.  Each binary is run under the cycle-accurate
# CP/M harness (z88dk-ticks) and its output compared to the native oracle.
#
# Only the transcendentals that FIT the TPA are covered here: sqrt, atan, exp.
# log/sin/cos individually exceed the TPA (log_data 13.5 KB; __rem_pio2 15 KB)
# even with dead-module stripping -- documented + parked in the README.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)      # .../tests
PROJ=$(dirname "$HERE")                  # project root
WS=$(dirname "$PROJ")                    # workspace root
export PATH="$WS/z88dk/bin:$PATH"
export ZCCCFG="$WS/z88dk/lib/config/"
TICKS="$WS/scratch/dcc-clang-bench/ticks_cpm.py"
LIB=/tmp/mathf64_lib
Z="zcc +cpm -compiler=llvmz80 -Cg-Oz -Ivendor/config -Ivendor/musl-math"

echo "=== build mathf64.lib ==="
( cd "$PROJ" && OUT="$LIB" bash tools/build_mathlib.sh )

OUT=$(mktemp -d); rc=0
# one row per fitting transcendental:  test-source   expected-output
run_one(){
    local name="$1" src="$2" expect="$3"
    ( cd "$PROJ" && $Z -o "$OUT/$name" "$src" -L"$LIB" -lmathf64 ) 2>"$OUT/$name.err" || {
        echo "  $name: LINK FAIL ($(grep -m1 -iE 'undef|error|overflow' "$OUT/$name.err"))"; rc=1; return; }
    local sz got
    sz=$(stat -f%z "$OUT/$name")
    got=$(python3 "$TICKS" "$OUT/$name" 2>/dev/null | grep -v '^\[ticks\]')
    if [ "$got" = "$expect" ]; then echo "  $name PASS  ($sz B)  -> $got"
    else echo "  $name FAIL  ($sz B)  got [$got] expect [$expect]"; rc=1; fi
}

echo "=== libm transcendentals (fit TPA) ==="
run_one sqrt "tests/ft_sqrt.c"     "sq2=14142 sq2b=17320 fa=15 cs=-25"
run_one atan "tests/ft_atan_min.c" "7853 4636"
run_one exp  "tests/ft_exp_min.c"  "27182 16487"

rm -rf "$OUT"
[ "$rc" -eq 0 ] && echo "RESULT: libm PASS" || { echo "RESULT: libm FAIL"; exit 1; }
