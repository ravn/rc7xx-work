#!/usr/bin/env bash
# printf_run.sh -- build + verify the nanoprintf-backed printf family
# (src/npf_printf.c) under zcc +cpm -compiler=llvmz80, output diffed against
# tests/ft_printf.expected (byte-identical to glibc for the %f cases).
#
# Prereqs: the clang-z80 jump-table off-by-one fix (nanoprintf %x) and va_start
# (ravn/z88dk#31/#270).  Skips if zcc/ntvcm/softfloat lib are unavailable.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(dirname "$HERE")"
WS="$(dirname "$PROJ")"

export PATH="$WS/z88dk/bin:$PATH"
export ZCCCFG="$WS/z88dk/lib/config/"
export LLVMZ80EXE="${LLVMZ80EXE:-$WS/llvm-z80/build-macos/bin/clang}"
NTVCM="${NTVCM:-$WS/ntvcm/ntvcm}"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
[ -x "$NTVCM" ] || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

# The f64 %f path needs the softfloat runtime archive.
RTLIB="${LLVMZ80RTLIB:-/tmp/softfloat_lib/softfloat_cpm_z80}"
[ -f "$RTLIB.lib" ] || { echo "SKIP: softfloat lib not built ($RTLIB.lib) — run tools/build_softfloat_lib.sh"; exit 0; }
export LLVMZ80RTLIB="$RTLIB"

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT

if ! zcc +cpm -compiler=llvmz80 -O2 -I"$PROJ/src" -I"$PROJ/vendor/nanoprintf" \
        -I"$PROJ/vendor/config" -create-app -o "$WORK/ftpf" \
        "$PROJ/tests/ft_printf.c" "$PROJ/src/npf_printf.c" >"$WORK/build.log" 2>&1; then
    echo "FAIL: build error"; grep -iE 'error' "$WORK/build.log" | head; exit 1
fi

"$NTVCM" "$WORK/ftpf.com" 2>/dev/null | tr -d '\r' > "$WORK/out.txt"
if diff -u "$PROJ/tests/ft_printf.expected" "$WORK/out.txt"; then
    echo "PASS: nanoprintf printf/%f byte-identical to golden"
else
    echo "FAIL: output diverged from tests/ft_printf.expected"; exit 1
fi
