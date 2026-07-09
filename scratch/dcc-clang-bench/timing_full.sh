#!/usr/bin/env bash
# Full timing table: dcc vs clang at Os/O1/O2/O3 — 2026-07-09
NTVCM=/Users/ravn/z80/ntvcm/ntvcm
OUT=/tmp/dcc_clang_compare2
DCC=/Users/ravn/z80/dcc/build

# Run at full speed; -p gives cycle count, -s:4000000 just calibrates the Hz display
cycles() { $NTVCM -p "$1" 2>&1 | awk '/Z80.*cycles:/{gsub(/,/,"",$NF); print $NF}'; }

printf "%-7s  %12s  %12s  %12s  %12s  %12s\n" \
    "program" "dcc" "clang-Os" "clang-O1" "clang-O2" "clang-O3"
printf "%-7s  %12s  %12s  %12s  %12s  %12s\n" \
    "-------" "---" "--------" "--------" "--------" "--------"

for name in sieve e ttt tm; do
    U=$(echo "$name" | tr a-z A-Z)
    d=$(cycles $DCC/${U}.COM)
    os=$(cycles $OUT/Os/${U}.COM)
    o1=$(cycles $OUT/O1/${U}.COM)
    o2=$(cycles $OUT/O2/${U}.COM)
    o3=$(cycles $OUT/O3/${U}.COM)
    r_os=$(python3 -c "print(f'{int(\"$os\")/int(\"$d\"):.2f}x')")
    r_o1=$(python3 -c "print(f'{int(\"$o1\")/int(\"$d\"):.2f}x')")
    r_o2=$(python3 -c "print(f'{int(\"$o2\")/int(\"$d\"):.2f}x')")
    r_o3=$(python3 -c "print(f'{int(\"$o3\")/int(\"$d\"):.2f}x')")
    printf "%-7s  %12s  %10s(%s)  %10s(%s)  %10s(%s)  %10s(%s)\n" \
        "$name" "$d" "$os" "$r_os" "$o1" "$r_o1" "$o2" "$r_o2" "$o3" "$r_o3"
done

