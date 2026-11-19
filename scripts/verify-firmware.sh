#!/usr/bin/env bash
# verify-firmware.sh — rebuild clang+lld from s4 if needed, rebuild
# autoload+rcbios, run polypascal test using existing cpnos prom.
#
# Requires s4/z80-clang-builtins (includes null-streamer LTO fix) to be
# checked out and built in build-macos-asserts.
#
# Usage: ./verify-firmware.sh [--force-rebuild]
#   --force-rebuild  force ninja even if no backend files changed

set -euo pipefail

# Per-host paths (macbook vs sonnyboy)
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)
    WORKSPACE=/Users/ravn/z80
    BUILD_DIR=build-macos-asserts
    NINJA=/Applications/CLion.app/Contents/bin/ninja/mac/aarch64/ninja
    [ -x "$WORKSPACE/ccache/build/ccache" ] \
        && export PATH="$WORKSPACE/ccache/build:$PATH" \
        || echo "WARNING: ccache not found at $WORKSPACE/ccache/build/ccache — build may be slow"
    ;;
  Linux-x86_64)
    WORKSPACE=/home/ravn/z80
    BUILD_DIR=build-linux
    NINJA=$(command -v ninja || echo ninja)
    # Add ccache to PATH if the project-local binary exists; fall back to
    # system ccache or none (ninja will still work but without caching).
    [ -x "$WORKSPACE/ccache/build/ccache" ] \
        && export PATH="$WORKSPACE/ccache/build:$PATH" \
        || command -v ccache >/dev/null 2>&1 \
        || echo "WARNING: ccache not found — build may be slow"
    ;;
  *)
    echo "ERROR: unknown host $(uname -s)-$(uname -m)"; exit 1 ;;
esac

# Single shared ccache config (scripts/ccache-z80.conf).
export CCACHE_CONFIGPATH="$WORKSPACE/scripts/ccache-z80.conf"

LLVM=$WORKSPACE/llvm-z80
BUILD=$LLVM/$BUILD_DIR

AUTOLOAD=$WORKSPACE/rc700-gensmedet/autoload-in-c
RCBIOS=$WORKSPACE/rc700-gensmedet/rcbios-in-c
LOG=$LLVM/scratch/tmp
mkdir -p "$LOG"

FORCE_REBUILD=${1:-}

# ── 0. Switch llvm-z80 to s4 (includes null-streamer LTO fix) ────────────────
S4_BRANCH=s4/z80-clang-builtins
CURRENT_BRANCH=$(git -C "$LLVM" branch --show-current)
if [ "$CURRENT_BRANCH" != "$S4_BRANCH" ]; then
    echo "Switching llvm-z80: $CURRENT_BRANCH -> $S4_BRANCH"
    git -C "$LLVM" checkout "$S4_BRANCH"
fi
echo "Branch: $(git -C "$LLVM" branch --show-current)  tip: $(git -C "$LLVM" log --oneline -1)"

# ── 1. Rebuild clang+lld if backend changed ──────────────────────────────────
echo ""
echo "=== 1/4 checking if compiler needs rebuild ==="

CLANG_BIN=$BUILD/bin/clang
LLD_BIN=$BUILD/bin/ld.lld

NEWEST_SRC=$(find \
    "$LLVM/llvm/lib/Target/Z80" \
    "$LLVM/llvm/include/llvm/TargetParser/Triple.h" \
    "$LLVM/llvm/include/llvm/IR/RuntimeLibcalls.td" \
    -newer "$CLANG_BIN" 2>/dev/null | head -1)

if [ -n "$NEWEST_SRC" ] || [ "$FORCE_REBUILD" = "--force-rebuild" ]; then
    echo "  Rebuilding: $NEWEST_SRC"
    pgrep -f ninja && { echo "ERROR: ninja already running"; exit 1; }
    $NINJA -C "$BUILD" clang lld llc llvm-nm llvm-objcopy llvm-objdump \
        > "$LOG/build-verify-fw.log" 2>&1
    grep "error:\|FAILED:" "$LOG/build-verify-fw.log" | head -5 && exit 1 || true
    echo "  Compiler rebuilt OK"
else
    _mtime() { stat -f '%Sm' -t '%Y-%m-%d %H:%M' "$1" 2>/dev/null || stat -c '%y' "$1" 2>/dev/null | cut -c1-16; }
    echo "  Up to date  clang: $(_mtime "$CLANG_BIN")"
    echo "  Up to date  lld:   $(_mtime "$LLD_BIN")"
fi

# ── 2. Build autoload PROM ───────────────────────────────────────────────────
echo ""
echo "=== 2/4 building autoload PROM ==="
make -C "$AUTOLOAD" prom
PROM_SIZE=$(wc -c < "$AUTOLOAD/clang/text_compressed.zx0")
echo "  autoload: $PROM_SIZE B compressed (cap 2048 B)"
[ "$PROM_SIZE" -le 2048 ] || { echo "ERROR: autoload exceeds 2 KB cap!"; exit 1; }

# ── 3. Build rcbios ──────────────────────────────────────────────────────────
echo ""
echo "=== 3/4 building rcbios ==="
make -C "$RCBIOS" bios 2>&1 | grep -E "clang BIOS|error:" | head -5

# ── 4. PolyPascal test via rcbios ────────────────────────────────────────────
echo ""
echo "=== 4/4 polypascal test (rcbios) ==="

make -C "$RCBIOS" polypascal-test

echo ""
echo "=== verify-firmware.sh DONE ==="
