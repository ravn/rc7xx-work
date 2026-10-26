#!/usr/bin/env bash
#
# rebuild-open-watcom.sh - build the workspace Open Watcom v2 tree
# (open-watcom-v2/) with ccache on the host bootstrap and a progress display.
#
# Wraps the same environment as scripts/build_open_watcom.sh (OWTOOLS=GCC on
# Linux, CLANG on macOS; docs and distribution installers skipped) but never
# installs packages: it checks prerequisites and tells you what is missing.
#
# Usage:  ./rebuild-open-watcom.sh [options] [TARGET]
#   TARGET       builder target (default: rel; e.g. boot = bootstrap only)
#   --stats      show ccache statistics after the build
#   -h|--help    this text
#
# What is and isn't sped up:
#   * ccache only covers the host-compiler (gcc/clang) steps, via a PATH shim
#     of ccache symlinks. Open Watcom then builds most of itself with its own
#     compilers, which ccache can't see.
#   * There is no parallel-jobs knob: build.sh drives a serial `builder`.
#   * Progress counts the "=== HH:MM:SS dir ===" lines builder prints; the
#     percentage is relative to the last successful build (first run: seeded
#     from open-watcom-v2/build-rel.log if present).
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/build-progress.sh
source "$ROOT/scripts/build-progress.sh"

OWROOT="$ROOT/open-watcom-v2"
LOG_DIR="$ROOT/scratch/tmp"
LOG="$LOG_DIR/open-watcom-build.log"
TOTAL_FILE="$LOG_DIR/open-watcom-build.total"
SHIM="$LOG_DIR/ccache-shim"
PROGRESS_RE='^=+ [0-9]{2}:[0-9]{2}:[0-9]{2} /'

TARGET=rel STATS=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--stats)   STATS=1 ;;
		-h|--help) sed -n '2,/^set -e/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; exit 0 ;;
		-*)        echo "error: unknown option: $1" >&2; exit 2 ;;
		*)         TARGET="$1" ;;
	esac
	shift
done

[[ -f "$OWROOT/build.sh" && -f "$OWROOT/cmnvars.sh" ]] || {
	echo "error: not an Open Watcom v2 tree: $OWROOT (git submodule update --init open-watcom-v2)" >&2
	exit 1
}

case "$(uname -s)" in
	Darwin) OWTOOLS=CLANG; OWDOSBOX=dosbox-x; NEED=(clang make) ;;
	Linux)  OWTOOLS=GCC;   OWDOSBOX=dosbox;   NEED=(gcc g++ make) ;;
	*) echo "error: unsupported host $(uname -s)" >&2; exit 1 ;;
esac
MISSING=()
for c in "${NEED[@]}"; do command -v "$c" >/dev/null || MISSING+=("$c"); done
if ((${#MISSING[@]})); then
	echo "error: missing build tools: ${MISSING[*]} (scripts/build_open_watcom.sh can install them)" >&2
	exit 1
fi
command -v "$OWDOSBOX" >/dev/null ||
	echo "warning: $OWDOSBOX not found; DOS-hosted help tools in the rel build may fail" >&2

refuse_if_building
mkdir -p "$LOG_DIR"

# Seed the 100% mark from an earlier full rel build log, once.
if [[ ! -f $TOTAL_FILE && $TARGET == rel && -f $OWROOT/build-rel.log ]]; then
	grep -c -E "$PROGRESS_RE" "$OWROOT/build-rel.log" >"$TOTAL_FILE" || true
fi

# ccache masquerade: symlinks named like the host compilers, first on PATH.
if command -v ccache >/dev/null; then
	mkdir -p "$SHIM"
	for c in gcc g++ cc c++ clang clang++; do ln -sf "$(command -v ccache)" "$SHIM/$c"; done
	export PATH="$SHIM:$PATH"
	export CCACHE_BASEDIR="$OWROOT"
	ccache -z >/dev/null
else
	echo "warning: ccache not installed; building without it" >&2
fi

# Same environment as scripts/build_open_watcom.sh. cmnvars.sh/build.sh rely
# on unset variables, so they run in a plain sh without -u/-e.
export OWROOT OWTOOLS OWDOSBOX
export OWDOCBUILD=0      # skip the big DOS/dosbox manual set
export OWDISTRBUILD=0    # skip distribution installers

echo "=== open-watcom: OWTOOLS=$OWTOOLS target=$TARGET (log $LOG) ==="
progress_run "$LOG" count "$TOTAL_FILE" -- \
	sh -c 'cd "$OWROOT" && . ./cmnvars.sh && exec sh ./build.sh "$1"' sh "$TARGET"
if ((PROGRESS_RC != 0)); then
	echo "=== BUILD FAILED (rc=$PROGRESS_RC) after ${PROGRESS_ELAPSED}s; tail of $LOG: ===" >&2
	tail -n 30 "$LOG" >&2
	echo "bootstrap log: $OWROOT/build/*/bootx.log" >&2
	exit 1
fi
echo "=== built in ${PROGRESS_ELAPSED}s (${PROGRESS_DONE} directories) ==="
((STATS)) && command -v ccache >/dev/null && ccache -s | sed -n '1,8p'
exit 0
