#!/usr/bin/env bash
# diff_ez80clang_llvmz80.sh -- differential oracle for the z88dk classic-lib
# <-> llvmz80 bridging work (ravn/z88dk#31 and friends).
#
# WHY this exists:  z88dk exposes classic-library routines (compiled by
# sccz80/sdcc) to two stock-clang backends via the __ZPROTO macros in
# include/sys/proto.h.  The two backends differ in ONE way that matters for
# bridging -- the 16-bit-int RETURN register:
#
#     ez80-clang  (__stdc)       -> returns 16-bit in HL  == classic clib
#     llvmz80     (sdcccall(1))  -> returns 16-bit in DE  != classic clib
#
# So ez80-clang is return-compatible with the classic library with NO
# `ex de,hl` fixup, while llvmz80 needs one (the __ZPROTO bridges add it, but
# the variadic printf/scanf family is un-bridged -> #31 garbage return).
#
# That makes ez80-clang a free KNOWN-GOOD ORACLE: compile the same
# classic-lib-calling program with both backends, run both under z88dk-ticks,
# and diff stdout.  A divergence pins a llvmz80 bridging defect (ez80-clang =
# reference truth).  When llvmz80's path is fixed, the outputs converge.
#
# Usage:   diff_ez80clang_llvmz80.sh [FILE.c ...]
#          (no args -> runs every tests/bridge/*.c)
# Exit:    0 = all cases converge, 1 = at least one divergence, 2 = setup error.

set -u

# --- locate the workspace and toolchain -------------------------------------
TOOL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SF_DIR="$(cd "$TOOL_DIR/.." && pwd)"          # llvmz80-softfloat/
WS="$(cd "$SF_DIR/.." && pwd)"                 # workspace root
Z88DK="$WS/z88dk"
LLVMZ80_CLANG="$WS/llvm-z80/build-macos/bin/clang"

export PATH="$Z88DK/bin:$PATH"
export ZCCCFG="$Z88DK/lib/config"
export LLVMZ80EXE="${LLVMZ80EXE:-$LLVMZ80_CLANG}"

for need in "$Z88DK/bin/zcc" "$Z88DK/bin/z88dk-ticks" "$LLVMZ80EXE" \
            "$Z88DK/bin/ez80-clang"; do
    [ -x "$need" ] || { echo "SETUP ERROR: missing $need" >&2; exit 2; }
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# run one .c under one backend, echo its program stdout (BDOS via ticks)
build_and_run() {
    local src="$1"
    local name="$2"
    local flags="$3"
    local out="$TMP/$name"
    if ! zcc +cpm $flags "$src" -o "$out" -create-app >"$TMP/$name.log" 2>&1; then
        echo "__BUILD_FAIL__"; return
    fi
    # ticks parses the .com path as a CP/M FCB; a long absolute path breaks the
    # command tail, so run from $TMP with a short relative basename.
    # ticks prints a trailing t-state count on its own line -> drop it
    ( cd "$TMP" && z88dk-ticks -mz80 "$name.com" 2>/dev/null ) | sed '${/^[0-9][0-9]*$/d;}'
}

# --- gather test cases ------------------------------------------------------
if [ "$#" -gt 0 ]; then
    CASES=("$@")
else
    CASES=("$SF_DIR"/tests/bridge/*.c)
fi

fails=0
for src in "${CASES[@]}"; do
    base="$(basename "$src" .c)"
    ref="$(build_and_run "$src" "${base}_ez80" "-compiler=ez80clang")"
    tst="$(build_and_run "$src" "${base}_llvm" "-compiler=llvmz80")"

    if [ "$ref" = "$tst" ] && [ "$ref" != "__BUILD_FAIL__" ]; then
        printf 'PASS  %s\n' "$base"
        printf '        %s\n' "$ref"
    else
        fails=$((fails + 1))
        printf 'FAIL  %s  (ez80-clang reference vs llvmz80 diverge)\n' "$base"
        printf '  ez80-clang (ref): %s\n' "$ref"
        printf '  llvmz80          : %s\n' "$tst"
    fi
done

echo "----"
if [ "$fails" -eq 0 ]; then
    echo "all cases converge"
else
    echo "$fails case(s) diverge -- llvmz80 bridging defect(s)"
fi
exit $([ "$fails" -eq 0 ] && echo 0 || echo 1)
