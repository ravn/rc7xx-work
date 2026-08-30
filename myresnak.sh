#!/usr/bin/env bash
#
# myresnak.sh - launch RC759 Piccoline "MYRESNAK" (Danish Logo turtle
# graphics) in MAME, exactly as set up in this workspace.
#
# The Myresnak disk (30004078.imd, Release 1.2 Apr 85) boots directly into
# Myresnak. The graphics screen ("KLAR TIL MYRESNAK" with the turtle triangle,
# and the drawing pages) renders via the RC759 82730 graphics-mode support in
# our local mame build (src/mame/regnecentralen/rc75x.cpp + i82730).
#
# Usage:  ./myresnak.sh            # normal interactive window
#         ./myresnak.sh --debug    # drop into the MAME debugger on start
#
set -euo pipefail

# Resolve the workspace root from this script's location so it works on any host.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MAME_DIR="$ROOT/mame"
DISK="$ROOT/scratch/rc759-cmd-toolchain/30004078.imd"

# Newest-mtime regnecentralen binary (avoid stale 'regnecentralend').
BIN="$(ls -t "$MAME_DIR"/regnecentralen "$MAME_DIR"/regnecentralend 2>/dev/null | head -n1 || true)"

if [[ -z "${BIN:-}" || ! -x "$BIN" ]]; then
	echo "error: regnecentralen MAME binary not found in $MAME_DIR" >&2
	echo "       build it with:" >&2
	echo "       cd mame && make SUBTARGET=regnecentralen REGENIE=1 SOURCES=src/mame/regnecentralen/rc759.cpp OSD=sdl -j10" >&2
	exit 1
fi

if [[ ! -f "$DISK" ]]; then
	echo "error: Myresnak disk image not found: $DISK" >&2
	exit 1
fi

EXTRA=()
if [[ "${1:-}" == "--debug" ]]; then
	EXTRA+=(-debug)
fi

# MAME resolves -rompath relative to its own working directory, so run from
# the mame dir. The RC759 BIOS 0 is the standard boot ROM set.
cd "$MAME_DIR"
exec "$BIN" rc759 \
	-bios 0 \
	-skip_gameinfo \
	-rompath roms \
	-flop1 "$DISK" \
	-window \
	-nomaximize \
	${EXTRA[@]+"${EXTRA[@]}"}
