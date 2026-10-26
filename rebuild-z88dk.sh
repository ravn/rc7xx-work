#!/usr/bin/env bash
#
# rebuild-z88dk.sh - (re)build the native z88dk development fork (z88dk/):
# z80asm, zcc and friends plus the bundled zsdcc, with ccache.
# (z88dk/Makefile wraps CC/CXX in ccache itself when ccache is on PATH; this
# script adds -j, logging and a progress display.)
#
# Usage:  ./rebuild-z88dk.sh [options] [TARGET...]
#   --clean      `make clean` first (ccache keeps the rebuild cheap)
#   --stats      show ccache statistics after the build
#   -j N         parallel jobs (default: nproc)
#   -h|--help    this text
#   TARGET...    make targets instead of `all` (e.g. libs)
#
# The first build includes SDCC's configure + build (~10-15 min).
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/build-progress.sh
source "$ROOT/scripts/build-progress.sh"

Z88DK="$ROOT/z88dk"
JOBS="$(nproc)"
LOG_DIR="$ROOT/scratch/tmp"
LOG="$LOG_DIR/z88dk-build.log"

CLEAN=0 STATS=0 TARGETS=()
while [[ $# -gt 0 ]]; do
	case "$1" in
		--clean)   CLEAN=1 ;;
		--stats)   STATS=1 ;;
		-j)        JOBS="$2"; shift ;;
		-j*)       JOBS="${1#-j}" ;;
		-h|--help) sed -n '2,/^set -e/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit 0 ;;
		-*)        echo "error: unknown option: $1" >&2; exit 2 ;;
		*)         TARGETS+=("$1") ;;
	esac
	shift
done
((${#TARGETS[@]})) || TARGETS=(all)

[[ -f "$Z88DK/Makefile" ]] || { echo "error: $Z88DK/Makefile missing (git submodule update --init z88dk)" >&2; exit 1; }
command -v ccache >/dev/null || { echo "error: ccache not installed" >&2; exit 1; }
refuse_if_building
mkdir -p "$LOG_DIR"

export CCACHE_BASEDIR="$Z88DK"
ccache -z >/dev/null

if ((CLEAN)); then
	echo "=== make clean ==="
	make -C "$Z88DK" clean >"$LOG_DIR/z88dk-clean.log" 2>&1 ||
		{ tail -n 30 "$LOG_DIR/z88dk-clean.log" >&2; exit 1; }
fi

# make prints no totals: count compiler/assembler steps; percent is relative
# to the last successful full build.
PROGRESS_RE='(^|[ /])(gcc|g\+\+|cc|c\+\+|ccache|sdcc|zcc|z80asm|z88dk-[a-z0-9-]+) '
echo "=== make -j$JOBS ${TARGETS[*]} (log $LOG) ==="
progress_run "$LOG" count "$LOG_DIR/z88dk-build.total" -- make -C "$Z88DK" -j"$JOBS" "${TARGETS[@]}"
if ((PROGRESS_RC != 0)); then
	echo "=== BUILD FAILED (rc=$PROGRESS_RC) after ${PROGRESS_ELAPSED}s; tail of $LOG: ===" >&2
	tail -n 30 "$LOG" >&2
	exit 1
fi
echo "=== built in ${PROGRESS_ELAPSED}s (${PROGRESS_DONE} steps) ==="
ls -l "$Z88DK/bin/zcc" "$Z88DK/bin/z88dk-z80asm" 2>/dev/null || true
((STATS)) && ccache -s | sed -n '1,8p'
exit 0
