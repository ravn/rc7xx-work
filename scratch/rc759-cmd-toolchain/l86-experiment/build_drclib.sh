#!/bin/sh
# Convert a DR C .L86 (Intel-OMF 0xA4 library) into a Watcom .lib that wlink links.
# Usage: ./build_drclib.sh ../rc759-drc-official/clears.l86 drclib.lib
set -e
OW="${OW:-/Users/ravn/z80/scratch/open-watcom-v2}"
WLIB="$OW/bld/nwlib/osxa64/wlib.exe"
SRC="${1:-../rc759-drc-official/clears.l86}"
OUT="${2:-drclib.lib}"
rm -rf objs; python3 split_l86.py "$SRC" objs           # .L86 -> 129 OMF modules
rm -f "$OUT"
CMD=$(for f in objs/*.obj; do printf '+%s ' "$f"; done)
"$WLIB" -q -c -l=drclib.lst "$OUT" $CMD                 # modules -> Watcom .lib
echo "Built $OUT ($(wc -c < "$OUT") bytes) from $SRC"
