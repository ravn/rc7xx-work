#!/bin/sh
# Kør z88dk + llvmz80 integrationstest-suite.
#
# Brug:
#   ./run-z88dk-tests.sh                      # classic clib (standard)
#   TEST_CLIB=newlib_iy ./run-z88dk-tests.sh  # newlib via llvmz80
#   TEST_TIMEOUT=60 ./run-z88dk-tests.sh      # længere timeout per test
#
# Alle miljøvariable videresendes til run_all.sh:
#   LLVMZ80EXE, NTVCM, ZCCCFG, TEST_CLIB, ZCC_CLIB, TEST_TIMEOUT

set -e
WORKSPACE=$(cd "$(dirname "$0")" && pwd)
Z88DK_DIR="$WORKSPACE/z88dk"
TEST_DIR="$Z88DK_DIR/test/clang"

# Auto-detekter LLVMZ80EXE
if [ -z "$LLVMZ80EXE" ]; then
    for candidate in \
        "$WORKSPACE/llvm-z80/build-macos/bin/clang" \
        "$WORKSPACE/llvm-z80/build-linux/bin/clang" \
        "$WORKSPACE/llvm-z80/build/bin/clang"; do
        if [ -x "$candidate" ] && "$candidate" --version 2>&1 | grep -qi "z80"; then
            LLVMZ80EXE="$candidate"
            break
        fi
    done
fi
export LLVMZ80EXE

# Auto-detekter z88dk (ZCCCFG + PATH)
if [ -z "$ZCCCFG" ] && [ -f "$Z88DK_DIR/lib/config/cpm.cfg" ]; then
    ZCCCFG="$Z88DK_DIR/lib/config/"
    PATH="$Z88DK_DIR/bin:$PATH"
fi
export ZCCCFG PATH

# Auto-detekter ntvcm
if [ -z "$NTVCM" ]; then
    for candidate in \
        "$WORKSPACE/ntvcm/ntvcm" \
        "$(command -v ntvcm 2>/dev/null)"; do
        if [ -x "$candidate" ]; then
            NTVCM="$candidate"
            break
        fi
    done
fi
export NTVCM

exec sh "$TEST_DIR/run_all.sh" "$@"
