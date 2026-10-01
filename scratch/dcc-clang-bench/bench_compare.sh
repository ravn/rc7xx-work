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
    # Kør .COM med z88dk-ticks' indbyggede CP/M-emulering (.com-extension
    # injecter automatisk ED FE ved adresse 5 og starter ved 0x100).
    # -end 0 stopper ved warm-boot (JP 0 / RET fra main via CRT0).
    # Output: "Ticks: N" på stdout.
    com=$1
    base=$(basename "$com")
    tmp=$(mktemp /tmp/bench_XXXXXX.com)
    cp "$com" "$tmp"
    z88dk-ticks -end 0 -w 4 "$tmp" 2>/dev/null | grep -v 'counter limit' | tail -1
    rm -f "$tmp"
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
