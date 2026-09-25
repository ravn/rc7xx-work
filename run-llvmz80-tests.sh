#!/bin/sh
# Kør llvmz80 test-runner suite (clang + lit som standard).
#
# Brug:
#   ./run-llvmz80-tests.sh              # clang + lit (alle opt-niveauer)
#   ./run-llvmz80-tests.sh full         # alt: clang + lit + torture på begge targets
#   ./run-llvmz80-tests.sh clang        # kun clang C-tests
#   ./run-llvmz80-tests.sh lit          # kun LLVM lit-tests
#   ./run-llvmz80-tests.sh clang -opt Os -native-oracle
#   BUILD_DIR=<anden build-mappe> ./run-llvmz80-tests.sh
#
# Alle argumenter videresendes uændret til z80-test-runner.

set -e
WORKSPACE=$(cd "$(dirname "$0")" && pwd)
TESTRUNNER_DIR="$WORKSPACE/llvm-z80/z80-utils/test-runner"

# Auto-detekter BUILD_DIR
if [ -z "$BUILD_DIR" ]; then
    for candidate in \
        "$WORKSPACE/llvm-z80/build-macos" \
        "$WORKSPACE/llvm-z80/build-linux" \
        "$WORKSPACE/llvm-z80/build"; do
        if [ -x "$candidate/bin/clang" ]; then
            BUILD_DIR="$candidate"
            break
        fi
    done
fi

if [ -z "$BUILD_DIR" ]; then
    echo "FEJL: Kan ikke finde build-mappen — sæt BUILD_DIR"
    exit 1
fi
export BUILD_DIR

# Auto-tilføj z88dk sdcc-build til PATH (indeholder sdcc, sdasz80, sdldz80 osv.)
SDCC_BUILD="$WORKSPACE/z88dk/src/sdcc-build/bin"
if [ -x "$SDCC_BUILD/sdcc" ]; then
    PATH="$SDCC_BUILD:$PATH"
fi

# Auto-tilføj z80-utils Rust-binærer til PATH (elf2rel, rel2elf til utils-suiten)
Z80UTILS_BIN="$WORKSPACE/llvm-z80/z80-utils/target/debug"
if [ -x "$Z80UTILS_BIN/elf2rel" ]; then
    PATH="$Z80UTILS_BIN:$PATH"
fi
export PATH

echo "=== llvmz80 test-runner ==="
echo "  BUILD_DIR : $BUILD_DIR"
echo "  clang     : $BUILD_DIR/bin/clang"
echo "  sdcc      : $(command -v sdcc 2>/dev/null || echo 'ikke fundet')"
echo ""

cd "$TESTRUNNER_DIR"

if [ "$#" -eq 0 ]; then
    cargo run -- clang -opt all
    echo ""
    cargo run -- lit
else
    cargo run -- "$@"
fi
