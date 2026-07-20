#!/usr/bin/env bash
# bench_compare.sh — dcc vs zcc+llvmz80 på 4 klassiske CP/M benchmarks.
#
# Begge sider producerer rigtige CP/M .COM-filer der kører med z88dk runtime.
# Cycles måles med z88dk-ticks (cycle-præcis, korrekte DD/FD/ED T-states).
#
# Brug: bench_compare.sh [opt_level]   (default: Os)
#   opt_level: Os | O2 | O1 | O3
#
# Output: tabel med size (B) + cycles + ratioer (zcc/dcc).
set -euo pipefail
BENCH_DIR=$(cd "$(dirname "$0")" && pwd)
OPT=${1:-Os}
OUTDIR=/tmp/bench_zcc_vs_dcc/$OPT
DCC_DIR=/Users/ravn/z80/dcc/build

mkdir -p "$OUTDIR"

ticks_cycles() {
    # Kør .COM med ticks_cpm.py, returner cycle-antal (kun stderr-linje).
    python3 "$BENCH_DIR/ticks_cpm.py" "$1" 2>&1 1>/dev/null \
        | awk '/^\[ticks\]/{print $2}'
}

printf "\ndcc vs zcc+llvmz80  (-%s, z88dk-ticks cycle-accurate)\n\n" "$OPT"
printf "%-8s  %8s  %13s    %8s  %13s    %6s  %7s\n" \
    "bench" "dcc-sz" "dcc-cycles" "zcc-sz" "zcc-cycles" "sz-rat" "cyc-rat"
printf "%-8s  %8s  %13s    %8s  %13s    %6s  %7s\n" \
    "--------" "--------" "-------------" "--------" "-------------" "------" "-------"

for name in sieve e ttt tm ackerman tak hanoi nqueens; do
    U=$(echo "$name" | tr a-z A-Z)
    DCC_COM="$DCC_DIR/${U}.COM"

    # Byg zcc+llvmz80 (stil for at undgå noise på stdout)
    bash "$BENCH_DIR/build_zcc.sh" "$name" "$OPT" "$OUTDIR" >/dev/null
    ZCC_COM="$OUTDIR/${name}_zcc"

    dcc_sz=$(wc -c < "$DCC_COM")
    zcc_sz=$(wc -c < "$ZCC_COM")
    dcc_cyc=$(ticks_cycles "$DCC_COM")
    zcc_cyc=$(ticks_cycles "$ZCC_COM")

    sz_rat=$(python3 -c "print(f'{$zcc_sz/$dcc_sz:.2f}x')")
    cyc_rat=$(python3 -c "print(f'{$zcc_cyc/$dcc_cyc:.2f}x')")

    printf "%-8s  %8s  %13s    %8s  %13s    %6s  %7s\n" \
        "$name" "$dcc_sz" "$dcc_cyc" "$zcc_sz" "$zcc_cyc" "$sz_rat" "$cyc_rat"
done

printf "\n(sz-rat og cyc-rat < 1.00x = zcc+llvmz80 vinder; > 1.00x = dcc vinder)\n"
