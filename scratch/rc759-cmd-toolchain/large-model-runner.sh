#!/bin/bash
# large-model-runner.sh -- REGRESSION TEST for the Unicorn runner's large
# ("compact") memory-model CP/M-86 loader (cpm86run_unicorn.py `_load`).
#
# History: the runner originally loaded ONLY the CODE and DATA groups, so any
# large-model .CMD -- which also carries EXTRA / STACK / auxiliary code+data
# groups (CMD descriptor types 3..8) and needs them all placed in memory AND
# described in the base page -- aborted at startup with "You must link with
# LINK86 V1.2 or later." (DR C's CLEARL walks those base-page descriptors).
# `_load` now allocates a successive segment for every group, loads its image,
# and fills the full base-page descriptor table (offsets 0x0C/0x12/0x18.. ),
# mirroring emu2's proven CP/M-86 loader.
#
# This test builds a deliberately minimal large-model program (far_main.c +
# far_lib.c, two modules -> genuine FAR inter-module calls and FAR data
# pointers, producing CODE+DATA+EXTRA+STACK+AUX4 groups) and checks that:
#   1. it runs under the Unicorn runner and prints the expected numbers;
#   2. emu2 (an independent, real CP/M-86 loader) agrees; and
#   3. the small model still works (guards against a regression in the shared
#      base-page / segment setup).
# The expected numbers are computed independently on the host (see far_main.c /
# far_lib.c), so the oracle does not share the runner's code path.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
CC="$HERE/cc-cpm86.sh"
RUNNER="$HERE/../../open-watcom-v2/contrib/ravn/cpm86run_unicorn.py"
EMU2="${EMU2:-$HERE/../../emu2-cpm86/emu2}"
SRCS="$HERE/far_main.c $HERE/far_lib.c"
EXPECT=$'fold=51662\r\npick=353'    # independent host reference (see far_main.c)

[ -x "$CC" ]        || { echo "missing $CC"; exit 1; }
[ -f "$RUNNER" ]    || { echo "missing $RUNNER"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
fails=0

norm() { sed 's/\r$//' | grep -vE '^cpm86run|unimplemented|emu2:'; }

check() {   # check <label> <actual-raw>
    local label="$1" got; got="$(printf '%s' "$2" | norm)"
    local want; want="$(printf '%s' "$EXPECT" | norm)"
    if [ "$got" = "$want" ]; then
        echo "  PASS: $label -> $(printf '%s' "$got" | tr '\n' ' ')"
    else
        echo "  FAIL: $label"
        echo "    expected: $(printf '%s' "$want" | tr '\n' '|')"
        echo "    got:      $(printf '%s' "$got"  | tr '\n' '|')"
        fails=$((fails + 1))
    fi
}

echo "== building large-model demo (two modules) =="
"$CC" -m l -o "$WORK/FARDEMO.CMD" $SRCS >/dev/null

echo "== large model =="
check "large / Unicorn runner" "$(python3 "$RUNNER" "$WORK/FARDEMO.CMD" 2>&1)"
if [ -x "$EMU2" ]; then
    check "large / emu2 (cross-check)" \
        "$(cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" FARDEMO.CMD 2>&1)"
else
    echo "  SKIP: emu2 not built at $EMU2"
fi

echo "== small model (regression guard) =="
"$CC" -m s -o "$WORK/FARDEMOS.CMD" $SRCS >/dev/null
check "small / Unicorn runner" "$(python3 "$RUNNER" "$WORK/FARDEMOS.CMD" 2>&1)"

echo
if [ "$fails" -eq 0 ]; then
    echo "PASS: Unicorn runner large-model loader works (far calls + far data)."
    exit 0
else
    echo "FAIL: $fails check(s) failed."
    exit 1
fi
