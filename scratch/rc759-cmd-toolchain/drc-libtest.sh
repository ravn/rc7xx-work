#!/bin/bash
# drc-libtest.sh -- DR C library conformance suite via the DIFFERENTIAL ORACLE.
#
# For each portable K&R test program (drc-libtest/t_*.c), build it THREE ways:
#   1. genuine DR C 1.11      (drc-oracle.sh)          = GROUND TRUTH
#   2. Watcom bridge, large   (cc-cpm86.sh -m l)
#   3. Watcom bridge, small   (cc-cpm86.sh -m s)
# run all three headless under emu2, and diff the bridge outputs against the
# genuine one. A test PASSES iff BOTH bridge models reproduce genuine DR C's
# output byte-for-byte. This needs no hand-computed expected values: the real
# DR C library IS the oracle, so the suite certifies that Watcom's caller drives
# each DR C routine with faithful args + return registers.
#
# Usage:  ./drc-libtest.sh [t_string t_conv ...]   (default: all t_*.c)
# Env:    KEEP=1  keep built CMDs + output logs under $OUTDIR
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
TDIR="$HERE/drc-libtest"
OUTDIR="${OUTDIR:-$(mktemp -d)}"
[ -n "${KEEP:-}" ] || trap 'rm -rf "$OUTDIR"' EXIT

run_cmd() {   # run_cmd <file.CMD> -> stdout (CR-stripped, emu2 noise removed)
    local w; w="$(mktemp -d)"; cp "$1" "$w/T.CMD"
    ( cd "$w" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" T.CMD 2>/dev/null \
        | tr -d '\r' | LC_ALL=C grep -avE "unimplemented|^emu2:" )
    rm -rf "$w"
}

TESTS=("$@")
if [ ${#TESTS[@]} -eq 0 ]; then
    for f in "$TDIR"/t_*.c; do TESTS+=("$(basename "${f%.c}")"); done
fi

pass=0; fail=0; FAILED=""
printf '%-14s %-8s %-8s %s\n' "TEST" "LARGE" "SMALL" "RESULT"
printf '%-14s %-8s %-8s %s\n' "----" "-----" "-----" "------"
for t in "${TESTS[@]}"; do
    src="$TDIR/$t.c"
    [ -f "$src" ] || { echo "$t: no such source"; fail=$((fail+1)); continue; }
    G="$OUTDIR/$t.gen.CMD"; L="$OUTDIR/$t.lrg.CMD"; S="$OUTDIR/$t.sml.CMD"

    # Oracle source: a committed t_NAME.expect (used when the GENUINE DR C build
    # is confounded under emu2 -- e.g. file I/O, where genuine's read path fails
    # but the bridge is independently correct) OR, by default, the genuine DR C
    # build itself (the differential oracle).
    if [ -f "$TDIR/$t.expect" ]; then
        cp "$TDIR/$t.expect" "$OUTDIR/$t.gen.out"; ora="expect"
    else
        if ! DRC_PUTCHAR=1 "$HERE/drc-oracle.sh" "$src" "$G" >"$OUTDIR/$t.gen.build" 2>&1; then
            printf '%-14s %-8s %-8s %s\n' "$t" "-" "-" "BUILD-FAIL(genuine)"; fail=$((fail+1)); FAILED="$FAILED $t"; continue
        fi
        run_cmd "$G" >"$OUTDIR/$t.gen.out"; ora="genuine"
    fi
    "$HERE/cc-cpm86.sh" -m l -o "$L" "$src" >"$OUTDIR/$t.lrg.build" 2>&1; lok=$?
    "$HERE/cc-cpm86.sh" -m s -o "$S" "$src" >"$OUTDIR/$t.sml.build" 2>&1; sok=$?

    lres="FAIL"; sres="FAIL"
    if [ $lok -eq 0 ]; then run_cmd "$L" >"$OUTDIR/$t.lrg.out"
        diff -q "$OUTDIR/$t.gen.out" "$OUTDIR/$t.lrg.out" >/dev/null && lres="ok"; else lres="build"; fi
    if [ $sok -eq 0 ]; then run_cmd "$S" >"$OUTDIR/$t.sml.out"
        diff -q "$OUTDIR/$t.gen.out" "$OUTDIR/$t.sml.out" >/dev/null && sres="ok"; else sres="build"; fi

    if [ "$lres" = ok ] && [ "$sres" = ok ]; then
        printf '%-14s %-8s %-8s %s\n' "$t" "$lres" "$sres" "PASS ($ora)"; pass=$((pass+1))
    else
        printf '%-14s %-8s %-8s %s\n' "$t" "$lres" "$sres" "FAIL ($ora)"; fail=$((fail+1)); FAILED="$FAILED $t"
    fi
done
echo "----"
echo "PASS=$pass FAIL=$fail"
[ -n "${KEEP:-}" ] && echo "artifacts in $OUTDIR"
[ -n "$FAILED" ] && { echo "failed:$FAILED"; exit 1; }
exit 0
