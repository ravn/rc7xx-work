#!/usr/bin/env bash
# build_zcc.sh — byg et benchmark med zcc +cpm -compiler=llvmz80 og mål cycles.
# Brug: build_zcc.sh <name> <opt> <outdir>
#   name ∈ {sieve, e, ttt, tm}
#   opt  = O2 | Os | O1 | O3
#   outdir = output-mappe (oprettes hvis nødvendig)
set -euo pipefail
name=$1; opt=$2; outdir=$3

ZCC=/Users/ravn/z80/z88dk/bin/zcc
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"   # zcc shells out to z88dk-z80asm
SRC=/Users/ravn/z80/dcc/tests
NTVCM=/Users/ravn/z80/ntvcm/ntvcm

mkdir -p "$outdir"
out="$outdir/${name}_zcc"

# tm exercises malloc/calloc up to allocs=66 with growing block sizes (~22 KB
# live at peak), so the default 8 KB heap is exhausted -> calloc returns NULL.
# Give it a large heap; other benchmarks use little or no heap.
case "$name" in
  tm)  heap=48000 ;;
  *)   heap=8000 ;;
esac

"$ZCC" +cpm -compiler=llvmz80 -"$opt" \
    -pragma-define:CLIB_MALLOC_HEAP_SIZE=$heap \
    -o "$out" "$SRC/$name.c" 2>/dev/null

size=$(wc -c < "$out")
cyc=$("$NTVCM" -p "$out" 2>&1 | awk '/Z80.*cycles:/{gsub(/,/,"",$NF); print $NF}')
echo "$name zcc-llvmz80 $opt []: ${size} B, ${cyc} cycles"
