#!/bin/sh
# validate-cpm86-build.sh -- end-to-end validation of the production Open Watcom
# CP/M-86 toolchain (owcc -bcpm86) on macOS. Run after any rebuild/re-stage of
# the compiler to confirm the first-class -bt=cpm86 target still works.
#
#   ./scratch/rc759-cmd-toolchain/validate-cpm86-build.sh
#
# Exit 0 = all checks PASS; non-zero = a check FAILED (details printed).
#
# What it validates:
#   1. host tools present in $WATCOM/armo64 (owcc, wcc, wlink) + emu2
#   2. macro gate: wcc -bt=cpm86 defines __CPM86__ + __DOS__/_DOS/MSDOS,
#      and -bt=dos does NOT define __CPM86__ (test_cpm86_target.c probe)
#   3. full path: owcc -bcpm86 -> Watcom clib -> wlink format cpm86 -> a .CMD
#      with a valid group-descriptor header that runs correctly on emu2
#      (validate_prog.c prints a fixed marker; mandel_watcom.c renders)
#
# See: scratch/rc759-cmd-toolchain/USING_OWCC_CPM86.md
#      tasks/memory/reference_cpm86_vs_msdos_model.md
#
# Toolchain (env script + emu2) lives in the per-machine, gitignored
# scratch/cpm86-tools/; this script + its test programs are tracked here.
set -u

# --- locate the workspace + activate the toolchain --------------------------
HERE="$(cd "$(dirname "$0")" && pwd)"          # .../scratch/rc759-cmd-toolchain
Z80="$(cd "$HERE/../.." && pwd)"               # workspace root
TOOLS="$Z80/scratch/cpm86-tools"              # env script + emu2 (gitignored)
EMU="$TOOLS/emu2-cpm86/emu2"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# shellcheck source=/dev/null
. "$TOOLS/ow-macos-env.sh" >/dev/null 2>&1

fail=0
pass() { printf '  PASS  %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n' "$1"; fail=1; }

echo "== 1. host tools present =="
for t in owcc wcc wlink; do
    if [ -x "$WATCOM/armo64/$t" ]; then pass "$t"; else bad "$t missing in $WATCOM/armo64"; fi
done
if [ -x "$EMU" ]; then pass "emu2"; else bad "emu2 missing at $EMU"; fi

echo "== 2. compiler macro gate (__CPM86__ + DOS family) =="
if "$WATCOM/armo64/wcc" "$HERE/test_cpm86_target.c" -bt=cpm86 -0 -ms -i="$WATCOM/h" \
        -fo="$TMP/probe.o" >/dev/null 2>&1; then
    pass "wcc -bt=cpm86 compiles probe (all four macros present)"
else
    bad "wcc -bt=cpm86 did NOT define the expected macros"
fi
if "$WATCOM/armo64/wcc" "$HERE/test_cpm86_target.c" -bt=dos -0 -ms -i="$WATCOM/h" \
        -fo="$TMP/probe2.o" >/dev/null 2>&1; then
    bad "wcc -bt=dos unexpectedly defines __CPM86__ (should not)"
else
    pass "wcc -bt=dos rejects probe (no __CPM86__ under bare DOS)"
fi

echo "== 3. end-to-end .CMD build + emu2 run =="
# 3a. deterministic marker program through the standard clib
if owcc -bcpm86 -mcmodel=s -O2 -o "$TMP/V.CMD" "$HERE/validate_prog.c" >/dev/null 2>&1; then
    hdr=$(od -An -tx1 -N1 "$TMP/V.CMD" | tr -d ' ')
    [ "$hdr" = "01" ] && pass "validate_prog .CMD header 0x01 (code group)" \
                       || bad "validate_prog .CMD header is 0x$hdr, expected 0x01"
    out=$("$EMU" "$TMP/V.CMD" 2>/dev/null)
    case "$out" in
        *CPM86-PROD-OK\ marker=42*) pass "validate_prog runs on emu2 (marker=42)";;
        *) bad "validate_prog emu2 output wrong: [$out]";;
    esac
else
    bad "owcc -bcpm86 failed to build validate_prog.c"
fi
# 3b. real program (Mandelbrot) -- stable substring check
if owcc -bcpm86 -mcmodel=s -O2 -o "$TMP/M.CMD" "$HERE/mandel_watcom.c" >/dev/null 2>&1; then
    mout=$("$EMU" "$TMP/M.CMD" 2>/dev/null)
    case "$mout" in
        *:::::*-----*=====*) pass "mandel_watcom renders on emu2";;
        *) bad "mandel_watcom emu2 output did not match expected shading";;
    esac
else
    bad "owcc -bcpm86 failed to build mandel_watcom.c"
fi

echo
if [ "$fail" -eq 0 ]; then
    echo "RESULT: PASS -- production owcc CP/M-86 toolchain validated."
else
    echo "RESULT: FAIL -- see failures above."
fi
exit "$fail"
