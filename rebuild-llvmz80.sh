#!/usr/bin/env bash
#
# rebuild-llvmz80.sh - (re)build the native Z80 clang toolchain in
# llvm-z80/build-linux (or build-macos) with ccache, precompiled headers off
# and an exact [n/N] progress display. Same TOOLS list as `make toolchain`:
#   clang lld llvm-objcopy llvm-objdump llvm-nm llc opt FileCheck
#
# Usage:  ./rebuild-llvmz80.sh [options] [TARGET...]
#   --reconfigure  re-run cmake (needed after Z80.cmake changes or a new tree)
#   --clean        `ninja -t clean` first (full rebuild; ccache makes it cheap)
#   --stats        show ccache statistics after the build
#   -j N           parallel jobs (default: nproc)
#   -h|--help      this text
#   TARGET...      ninja targets instead of the default TOOLS list
#
# Rebuild ALL tools after a backend edit (memory: feedback_rebuild_all_z80_tools),
# so the default list is the right choice unless you know better.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/build-progress.sh
source "$ROOT/scripts/build-progress.sh"

LLVM_Z80="$ROOT/llvm-z80"
CACHE="$LLVM_Z80/clang/cmake/caches/Z80.cmake"
if [[ "$(uname -s)" == Darwin ]]; then BUILD_DIR=build-macos; else BUILD_DIR=build-linux; fi
BUILD="$LLVM_Z80/$BUILD_DIR"
TOOLS=(clang lld llvm-objcopy llvm-objdump llvm-nm llc opt FileCheck)
JOBS="$(nproc 2>/dev/null || sysctl -n hw.ncpu)"
LOG_DIR="$ROOT/scratch/tmp"
LOG="$LOG_DIR/llvmz80-build.log"

RECONF=0 CLEAN=0 STATS=0 TARGETS=()
while [[ $# -gt 0 ]]; do
	case "$1" in
		--reconfigure) RECONF=1 ;;
		--clean)       CLEAN=1 ;;
		--stats)       STATS=1 ;;
		-j)            JOBS="$2"; shift ;;
		-j*)           JOBS="${1#-j}" ;;
		-h|--help)     sed -n '2,/^set -e/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit 0 ;;
		-*)            echo "error: unknown option: $1" >&2; exit 2 ;;
		*)             TARGETS+=("$1") ;;
	esac
	shift
done
((${#TARGETS[@]})) || TARGETS=("${TOOLS[@]}")

[[ -f "$CACHE" ]] || { echo "error: $CACHE missing (git submodule update --init llvm-z80)" >&2; exit 1; }
command -v ccache >/dev/null || { echo "error: ccache not installed" >&2; exit 1; }
refuse_if_building
mkdir -p "$LOG_DIR"

if ((RECONF)) || [[ ! -f "$BUILD/build.ninja" ]]; then
	echo "=== configuring $BUILD_DIR (ccache launcher, PCH off) ==="
	# PCH makes ~93% of compiles uncacheable (feedback_read_cmake_cache_header).
	# Speed: lld links the big binaries much faster than bfd; a few parallel
	# link jobs (each clang/lld link is memory-heavy, 121 GB here); no
	# benchmarks/examples/docs/plugins that the Z80 work never uses.
	cmake -C "$CACHE" -G Ninja \
		-DCMAKE_MAKE_PROGRAM="$(command -v ninja)" \
		-DCMAKE_C_COMPILER_LAUNCHER=ccache \
		-DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON \
		$([[ "$(uname -s)" != Darwin ]] && echo "-DLLVM_USE_LINKER=lld") \
		-DLLVM_PARALLEL_LINK_JOBS=4 \
		-DLLVM_INCLUDE_BENCHMARKS=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_INCLUDE_DOCS=OFF \
		-DLLVM_ENABLE_PLUGINS=OFF \
		-S "$LLVM_Z80/llvm" -B "$BUILD" >"$LOG_DIR/llvmz80-configure.log" 2>&1 ||
		{ tail -n 30 "$LOG_DIR/llvmz80-configure.log" >&2; exit 1; }
	# Verify, as the memory note prescribes.
	[[ $(grep -c 'LAUNCHER = .*ccache' "$BUILD/build.ninja") -gt 0 &&
	   $(grep -c 'include-pch' "$BUILD/build.ninja") -eq 0 ]] ||
		{ echo "error: ccache launcher missing or PCH still on in $BUILD/build.ninja" >&2; exit 1; }
fi

export CCACHE_BASEDIR="$LLVM_Z80"
if ((CLEAN)); then
	echo "=== ninja -t clean ==="
	ninja -C "$BUILD" -t clean >"$LOG_DIR/llvmz80-clean.log" 2>&1
fi
ccache -z >/dev/null

echo "=== ninja -j$JOBS ${TARGETS[*]} (log $LOG) ==="
progress_run "$LOG" ninja /dev/null -- ninja -C "$BUILD" -j"$JOBS" "${TARGETS[@]}"
if ((PROGRESS_RC != 0)); then
	echo "=== BUILD FAILED (rc=$PROGRESS_RC) after ${PROGRESS_ELAPSED}s; tail of $LOG: ===" >&2
	tail -n 30 "$LOG" >&2
	exit 1
fi
echo "=== built in ${PROGRESS_ELAPSED}s (${PROGRESS_DONE} steps) ==="
"$BUILD/bin/clang" --version | head -n 1
((STATS)) && ccache -s | sed -n '1,8p'
exit 0
