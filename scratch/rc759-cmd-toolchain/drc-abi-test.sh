#!/bin/bash
# drc-abi-test.sh -- regression gate for the DR C return-register ABI bridge.
#
# Builds atol_bridge_test.c through cc-cpm86.sh in BOTH DR C models and asserts
# the returned long is read from DR C's BX:AX (not Watcom's default DX:AX). A
# PASS proves _preincl.h's DRC_LONG alias (`value [bx ax]`) is present and
# correct; without it the high word is dropped and the output is 00001170.
#
# Ground truth: atol("70000") = 0x00011170. Verified against the genuine DR C
# 1.11 runtime (CLEARL/CLEARS.L86) under emu2.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
EXPECT="00011170"
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT

run() {  # run a CMD, return its first non-emu2 output line
    EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" "$1" 2>&1 \
        | sed 's/\r$//' | grep -vE 'emu2:|unimplemented' | grep . | head -1
}

FAIL=0
for M in l s; do
    case "$M" in l) NAME="large (CLEARL)";; s) NAME="small (CLEARS)";; esac
    "$HERE/cc-cpm86.sh" -m "$M" -o "$WORK/T.CMD" "$HERE/atol_bridge_test.c" >/dev/null
    GOT="$(run "$WORK/T.CMD")"
    if [ "$GOT" = "$EXPECT" ]; then
        printf '  %-16s atol("70000")=0x%s  PASS\n' "$NAME" "$GOT"
    else
        printf '  %-16s got 0x%s expected 0x%s  FAIL\n' "$NAME" "$GOT" "$EXPECT"
        FAIL=1
    fi
done

if [ "$FAIL" -eq 0 ]; then
    echo "PASS: DR C long-return bridge (BX:AX) correct in both models"
else
    echo "FAIL: DR C long-return bridge broken (check _preincl.h DRC_LONG alias)"
    exit 1
fi
