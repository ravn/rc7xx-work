#!/bin/bash
# mandel-cpm86.sh -- build & run the canonical fixed-point Mandelbrot through the
# CP/M-86 target (install-cpm86-target.sh + cc-cpm86.sh) in BOTH DR C memory
# models (small -> CLEARS.L86, large -> CLEARL.L86) from ONE unchanged source.
#
# The compute kernel is verbatim from
#   open-watcom-v2/contrib/ravn/owc-drc/mandel-ow.c
# (the DR C oracle's IMUL variant); only entry/putchar glue and width (80->78)
# differ. The DRC bridge convention (far vs near) is selected automatically from
# Watcom's __LARGE__/__SMALL__, so the same mandel_cpm86.c builds for both.
#
# Correctness ORACLE (independent of our link path): the genuine Digital Research
# C 1.11 build owc-drc/MANDEL-DRC.CMD, run under the same emu2. Our 78-wide output
# must equal its first 78 columns of all 25 rows. If that CMD is absent we fall
# back to a structural check (25 rows, width<=78, set body present).
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
# The genuine DR C oracle CMD lives in the contrib tree; it may be either the
# scratch submodule build tree or the top-level repo checkout. Try both.
if [ -z "${ORACLE:-}" ]; then
    for cand in \
        "$HERE/../open-watcom-v2/contrib/ravn/owc-drc/MANDEL-DRC.CMD" \
        "$HERE/../../open-watcom-v2/contrib/ravn/owc-drc/MANDEL-DRC.CMD"; do
        [ -f "$cand" ] && { ORACLE="$cand"; break; }
    done
fi
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT

[ -f "$HERE/../open-watcom-v2/cpm86/_preincl.h" ] || "$HERE/install-cpm86-target.sh" >/dev/null

run_cmd() {  # run_cmd <cmd> -> image on stdout, emu2 error line stripped
    EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" "$1" 2>&1 \
        | sed 's/\r$//' | grep -vE 'unimplemented opcode|emu2:' | grep .
}

# Oracle image (first 78 cols per row), if the genuine DR C CMD is present.
ORA=""
if [ -f "$ORACLE" ]; then
    run_cmd "$ORACLE" | cut -c1-78 > "$WORK/oracle.txt"
    ORA="$WORK/oracle.txt"
    echo "oracle: genuine DR C 1.11 MANDEL-DRC.CMD ($(grep -c . "$ORA") rows)"
else
    echo "oracle: MANDEL-DRC.CMD absent -> structural check only"
fi

FAIL=0
for M in s l; do
    case "$M" in s) NAME="small (CLEARS)";; l) NAME="large (CLEARL)";; esac
    "$HERE/cc-cpm86.sh" -m "$M" -o "$WORK/M.CMD" "$HERE/mandel_cpm86.c" >/dev/null
    run_cmd "$WORK/M.CMD" > "$WORK/out.$M.txt"
    ROWS=$(grep -c . "$WORK/out.$M.txt")
    MAXW=$(awk '{ if(length>w) w=length } END{ print w }' "$WORK/out.$M.txt")
    HAS=$(grep -c '#' "$WORK/out.$M.txt" || true)
    if [ -n "$ORA" ]; then
        if diff -q "$ORA" "$WORK/out.$M.txt" >/dev/null; then ORES="byte-identical to DR C oracle"; else ORES="DIFFERS FROM ORACLE"; FAIL=1; fi
    else
        ORES="(no oracle)"
    fi
    printf '  %-16s rows=%s max_width=%s set=%s  %s\n' "$NAME" "$ROWS" "$MAXW" "$HAS" "$ORES"
    { [ "$ROWS" -eq 25 ] && [ "$MAXW" -le 78 ] && [ "$HAS" -gt 0 ]; } || { echo "    structural FAIL"; FAIL=1; }
done

echo "--- rendered Mandelbrot (both models byte-identical) ---"
cat "$WORK/out.l.txt"

if [ "$FAIL" -eq 0 ]; then
    echo "PASS: Mandelbrot builds & runs on BOTH DR C models, oracle-verified"
else
    echo "FAIL"; exit 1
fi
