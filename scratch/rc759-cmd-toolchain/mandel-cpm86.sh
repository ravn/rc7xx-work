#!/bin/bash
# mandel-cpm86.sh -- build & run the canonical fixed-point Mandelbrot through the
# large-model CP/M-86 target (install-cpm86-target.sh + cc-cpm86.sh). The compute
# kernel is verbatim from open-watcom-v2/contrib/ravn/owc-drc/mandel-ow.c (the DR
# C oracle's IMUL variant); only entry/putchar glue and width (80->78) differ.
# Asserts: 25 rows, each <= 78 columns, and the set body ('#') is present.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"

[ -f "$HERE/../open-watcom-v2/cpm86/_preincl.h" ] || "$HERE/install-cpm86-target.sh" >/dev/null
"$HERE/cc-cpm86.sh" -o "$HERE/MANDEL.CMD" "$HERE/mandel_cpm86.c" >/dev/null
trap 'rm -f "$HERE/MANDEL.CMD"' EXIT

OUT="$(EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" "$HERE/MANDEL.CMD" 2>&1 | sed 's/\r$//')"
echo "$OUT"
ROWS=$(printf '%s\n' "$OUT" | grep -c .)
MAXW=$(printf '%s\n' "$OUT" | awk '{ if(length>w) w=length } END{ print w }')
HASH=$(printf '%s\n' "$OUT" | grep -c '#' || true)
echo "--- rows=$ROWS max_width=$MAXW rows_with_set=$HASH ---"
if [ "$ROWS" -eq 25 ] && [ "$MAXW" -le 78 ] && [ "$HASH" -gt 0 ]; then
    echo "PASS: Mandelbrot built & ran on the CP/M-86 target (25x<=78, set present)"
else
    echo "FAIL: expected 25 rows, width<=78, set present"; exit 1
fi
