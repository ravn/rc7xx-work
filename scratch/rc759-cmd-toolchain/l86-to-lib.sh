#!/bin/bash
# l86-to-lib.sh -- convert a Digital Research .L86 library into an Open Watcom
# OMF .lib that wlink links natively.
#
# WHY: wlink cannot read a DR .L86 container directly (E2012 "invalid library
# file attribute" -- .L86 starts with DR's 0xA4 header, not wlink's 0xF0 OMF
# LIB_HEADER_REC). But the modules INSIDE are ordinary Intel-8086 OMF (RASM-86),
# which wlink accepts. So: unpack the .L86 into .obj modules, then repackage
# them with wlib into a real OMF .lib.
#
# VERIFIED 2026-08-13: CLEARL.L86 -> 131 modules -> CLEARL.lib; wlink then
# resolves atoi (and its transitive CTYPE/INCDEC deps) from CLEARL.lib with no
# errors. This is the library-side half of retiring emulated DR LINK-86.
#
# Usage:  ./l86-to-lib.sh CLEARL.L86 [CLEARL.lib]
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
BWLIB="${BWLIB:-$HERE/../../open-watcom-v2/build/binbuild/bwlib}"
UNPACK="$HERE/unpack_l86.py"
SRC="$1"; [ -z "$SRC" ] && { echo "usage: l86-to-lib.sh in.L86 [out.lib]"; exit 1; }
OUT="${2:-$(basename "${SRC%.*}").lib}"
[ -x "$BWLIB" ] || { echo "bwlib not built at $BWLIB (build Open Watcom)"; exit 1; }
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
python3 "$UNPACK" "$SRC" "$WORK/mods" | tail -1
"$BWLIB" -q -b -c "$OUT" "$WORK"/mods/*.obj
echo "built $OUT ($(stat -f%z "$OUT") bytes, $(ls "$WORK"/mods/*.obj | wc -l | tr -d ' ') modules) -- wlink-linkable OMF library"
