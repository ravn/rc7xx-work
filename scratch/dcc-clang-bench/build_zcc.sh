#!/usr/bin/env bash
# build_zcc.sh — byg et benchmark med zcc +cpm -compiler=llvmz80 og mål cycles.
# Brug: build_zcc.sh <name> <opt> <outdir>
#   name ∈ {sieve, e, ttt, tm}
#   opt  = O2 | Os | O1 | O3
#   outdir = output-mappe (oprettes hvis nødvendig)
# Output: én linje til stdout:  "<name> zcc-llvmz80 <opt>: <size> B, <cyc> cycles"
# Returnerer path til .COM via $outdir/${name}_zcc (ingen extension — rå CP/M binary).
set -euo pipefail
BENCH_DIR=$(cd "$(dirname "$0")" && pwd)
name=$1; opt=$2; outdir=$3

ZCC=/Users/ravn/z80/z88dk/bin/zcc
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"   # zcc shells out til z88dk-z80asm
SRC=/Users/ravn/z80/dcc/tests

mkdir -p "$outdir"
out="$outdir/${name}_zcc"

# tm: malloc/calloc peak ~22 KB live → standard 8 KB heap udtømt → NULL.
case "$name" in
  tm)  heap=48000 ;;
  *)   heap=8000 ;;
esac

"$ZCC" +cpm -compiler=llvmz80 -"$opt" \
    -pragma-define:CLIB_MALLOC_HEAP_SIZE=$heap \
    -o "$out" "$SRC/$name.c" 2>/dev/null

size=$(wc -c < "$out")
# z88dk-ticks er cycle-præcis (korrekte DD/FD/ED T-states); ntvcm er IKKE.
cyc=$(python3 "$BENCH_DIR/ticks_cpm.py" "$out" 2>&1 1>/dev/null \
      | awk '/^\[ticks\]/{print $2}')
echo "$name zcc-llvmz80 $opt: ${size} B, ${cyc} cycles"
