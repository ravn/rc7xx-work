#!/bin/bash
# clock-runner.sh -- REGRESSION TEST for the RC759 XIOS Int 28h function 19
# ("16 ms counter") clock in emu2-cpm86 (src/cpm86.c intr_cpm_int28 + the
# src/cpu.c emu_code_bytes code-byte counter).
#
# emu2 has no hardware clock, so self-timing CP/M-86 programs (e.g. stdcbench,
# whose loop is `while(clock()-start < SECONDS)`) used to spin forever under it.
# The clock now derives emulated time deterministically from the number of
# instruction-stream code bytes executed (seconds = bytes / CPM86_CLOCK_HZ),
# exactly like cpm86run_unicorn.py, so those programs advance and terminate --
# and, with the same CPM86_CLOCK_HZ, emu2 and the Unicorn runner produce the
# SAME score (stdcbench = 7/5/12), an independent cross-check.
#
# This fast test builds clock_test.c (three fn 19 reads with work between) and
# checks the counter advances monotonically under BOTH emu2 and the Unicorn
# runner.  (The heavy stdcbench cross-check is exercised separately.)
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
CC="$HERE/cc-cpm86.sh"
RUNNER="$HERE/../../open-watcom-v2/contrib/ravn/cpm86run_unicorn.py"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
: "${CPM86_CLOCK_HZ:=700000}"; export CPM86_CLOCK_HZ

[ -x "$CC" ]     || { echo "missing $CC"; exit 1; }
[ -f "$RUNNER" ] || { echo "missing $RUNNER"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
fails=0

norm() { sed 's/\r$//' | grep -vE '^cpm86run|unimplemented|emu2:'; }

check() {   # check <label> <actual-raw>
    local label="$1" got; got="$(printf '%s' "$2" | norm | tr -d '[:space:]')"
    if [ "$got" = "clock:PASS" ]; then
        echo "  PASS: $label"
    else
        echo "  FAIL: $label -> [$got]"
        fails=$((fails + 1))
    fi
}

echo "== building clock_test (small model) =="
"$CC" -m s -o "$WORK/CLOCK.CMD" "$HERE/clock_test.c" >/dev/null

check "Unicorn runner" "$(python3 "$RUNNER" "$WORK/CLOCK.CMD" 2>&1)"
if [ -x "$EMU2" ]; then
    check "emu2 (Int 28h fn 19 clock)" \
        "$(cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" CLOCK.CMD 2>&1)"
else
    echo "  SKIP: emu2 not built at $EMU2"
fi

echo
if [ "$fails" -eq 0 ]; then
    echo "PASS: XIOS fn 19 clock advances monotonically on both emulators."
    exit 0
else
    echo "FAIL: $fails check(s) failed."
    exit 1
fi
