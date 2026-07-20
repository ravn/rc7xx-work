#!/usr/bin/env bash
# sieve_beats_dcc_guard.sh — regression guard for ravn/llvm-z80#250.
#
# Builds the dcc `sieve` benchmark through `zcc +cpm -compiler=llvmz80` (the
# #250 pointer-walk stack is auto-on at -O2) and asserts it BEATS dcc's cycle
# count.  Also checks correctness at -O2 and -O3.  Exit non-zero on regression.
#
# Run: scratch/dcc-clang-bench/sieve_beats_dcc_guard.sh
set -uo pipefail   # not -e: `read` returns non-zero at EOF (printf has no \n)

ZCC=/Users/ravn/z80/z88dk/bin/zcc
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"
BENCH_DIR=$(cd "$(dirname "$0")" && pwd)
SRC=/Users/ravn/z80/dcc/tests/sieve.c
DCC=27979152          # dcc SIEVE.COM cycles (z88dk-ticks)
EXPECT="1899 primes." # correct output
OUT=$(mktemp -d)
rc=0

measure() { # opt -> prints "cycles<TAB>stdout"
  local opt=$1 com="$OUT/sieve_$1"
  "$ZCC" +cpm -compiler=llvmz80 -Cg-"$opt" -o "$com" "$SRC" 2>/dev/null
  local cyc so
  so=$(python3 "$BENCH_DIR/ticks_cpm.py" "$com" 2>/dev/null | head -1)
  cyc=$(python3 "$BENCH_DIR/ticks_cpm.py" "$com" 2>&1 1>/dev/null | awk '/^\[ticks\]/{print $2}')
  printf '%s\t%s' "$cyc" "$so"
}

# -O2: must be correct AND beat dcc (the #250 win).
IFS=$'\t' read -r o2cyc o2out < <(measure O2)
[ "$o2out" = "$EXPECT" ] || { echo "FAIL: -O2 wrong output: '$o2out'"; rc=1; }
if [ "${o2cyc:-0}" -lt "$DCC" ]; then
  echo "PASS: -O2 $o2cyc < dcc $DCC (beats dcc)"
else
  echo "FAIL: -O2 $o2cyc >= dcc $DCC (lost the #250 win)"; rc=1
fi

# -O3: the stack is intentionally OFF (loop unrolling regresses Z80), so this
# only checks correctness -- NOT a dcc-beat (unachievable at -O3, see #250).
IFS=$'\t' read -r o3cyc o3out < <(measure O3)
[ "$o3out" = "$EXPECT" ] || { echo "FAIL: -O3 wrong output: '$o3out'"; rc=1; }
echo "INFO: -O3 $o3cyc (stack off at -O3 by design; correctness only)"

rm -rf "$OUT"
exit $rc
