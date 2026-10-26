#!/usr/bin/env bash
#
# rebuild-mame.sh - (re)build the workspace MAME with ccache and a trimmed,
# fast configuration. Produces only the two binaries we use:
#   mame/regnecentralen   (release)
#   mame/regnecentralend  (debug, symbols)
#
# Usage:  ./rebuild-mame.sh [options]
#   --release    build only regnecentralen
#   --debug      build only regnecentralend
#   --regenie    force GENie project regeneration (needed after adding/removing
#                driver source files or changing SOURCES)
#   --clean      make clean before each build (ccache keeps the rebuild cheap)
#   --stats      show ccache statistics after the build
#   -j N         parallel jobs (default: nproc)
#   -h|--help    this text
#
# Environment overrides: SOURCES (comma-separated .cpp list), JOBS.
#
# Never runs MAME itself (see CLAUDE.md): launch via the Makefile targets or
# scripts that enforce -window / -seconds_to_run.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAME_DIR="$ROOT/mame"
LOG_DIR="$ROOT/scratch/tmp"
# shellcheck source=scripts/build-progress.sh
source "$ROOT/scripts/build-progress.sh"
# MAME's make prints one line per step ("Compiling src/x.cpp...", Compressing/
# Archiving/Linking); percent is relative to the last successful build.
PROGRESS_RE='^(Compiling|Compressing|Archiving|Linking) '
SUBTARGET=regnecentralen
SOURCES="${SOURCES:-src/mame/regnecentralen/rc702.cpp,src/mame/regnecentralen/rc759.cpp,src/mame/regnecentralen/rc750.cpp}"
JOBS="${JOBS:-$(nproc 2>/dev/null || sysctl -n hw.ncpu)}"

VARIANTS=(release debug)
REGENIE=0 CLEAN=0 STATS=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--release) VARIANTS=(release) ;;
		--debug)   VARIANTS=(debug) ;;
		--regenie) REGENIE=1 ;;
		--clean)   CLEAN=1 ;;
		--stats)   STATS=1 ;;
		-j)        JOBS="$2"; shift ;;
		-j*)       JOBS="${1#-j}" ;;
		-h|--help) sed -n '2,/^set -e/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit 0 ;;
		*) echo "error: unknown option: $1" >&2; exit 2 ;;
	esac
	shift
done

[[ -f "$MAME_DIR/makefile" ]] || {
	echo "error: $MAME_DIR/makefile missing (git submodule update --init mame)" >&2
	exit 1
}
command -v ccache >/dev/null || { echo "error: ccache not installed" >&2; exit 1; }

refuse_if_building

mkdir -p "$LOG_DIR"

# ccache: normalise paths so the cache is stable across checkouts/hosts.
export CCACHE_BASEDIR="$MAME_DIR"
export CCACHE_NOHASHDIR=1
export CCACHE_COMPRESS=1

# gcc wrapped in ccache (same compiler as the existing objects); PCH off
# because it defeats ccache hits; no audio backends / tools (headless host,
# -sound none). Default GNU ld on purpose: MAME's static libs reference each
# other in a cycle and lld (no archive rescan) fails with undefined symbols
# (device_state_entry::..., 2026-10-26).
BASE_ARGS=(
	SUBTARGET="$SUBTARGET"
	SOURCES="$SOURCES"
	OSD=sdl
	OVERRIDE_CC="ccache gcc"
	OVERRIDE_CXX="ccache g++"
	PRECOMPILE=0
	NO_USE_PORTAUDIO=1
	NO_USE_PULSEAUDIO=1
	TOOLS=0
)
((REGENIE)) && BASE_ARGS+=(REGENIE=1)

ccache -z >/dev/null   # per-run statistics
cd "$MAME_DIR"

for variant in "${VARIANTS[@]}"; do
	ARGS=("${BASE_ARGS[@]}")
	if [[ $variant == debug ]]; then
		ARGS+=(DEBUG=1 SYMBOLS=1 SYMLEVEL=3)
		OUT="$MAME_DIR/${SUBTARGET}d"
	else
		OUT="$MAME_DIR/$SUBTARGET"
	fi
	LOG="$LOG_DIR/mame-build-$variant.log"

	echo "=== $variant: -j$JOBS, ccache on, log $LOG ==="
	if ((CLEAN)); then
		make "${ARGS[@]}" clean >>"$LOG" 2>&1
	fi
	TOTAL_FILE="$LOG_DIR/mame-build-$variant.total"
	progress_run "$LOG" count "$TOTAL_FILE" -- make "${ARGS[@]}" -j"$JOBS"
	if ((PROGRESS_RC != 0)); then
		echo "=== $variant BUILD FAILED (rc=$PROGRESS_RC) after ${PROGRESS_ELAPSED}s; tail of $LOG: ===" >&2
		tail -n 30 "$LOG" >&2
		exit 1
	fi
	echo "=== $variant built in ${PROGRESS_ELAPSED}s (${PROGRESS_DONE} steps) ==="
	ls -lh "$OUT"
done

if ((STATS)); then
	ccache -s | sed -n '1,8p'
fi
