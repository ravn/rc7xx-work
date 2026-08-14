#!/bin/sh
# Build the CP/M-86 crt0 + install the Watcom-native clib so 'owcc -bcpm86' links.
# Requires: a built Open Watcom (wasm/wcc/wlink) and $WATCOM pointing at the install root.
set -e
OW="${OW:-/Users/ravn/z80/scratch/open-watcom-v2}"
WASM="$OW/bld/wasm/osxa64/wasm.exe"
HERE="$(cd "$(dirname "$0")" && pwd)"
CRT0SRC="$HERE/../wlink-cmd-test/crt0sm.asm"     # small-model crt0 (VERIFIED on RC759)
: "${WATCOM:?set WATCOM to the OW install root}"
DEST="$WATCOM/lib286/cpm86"
mkdir -p "$DEST"
# 1) assemble crt0 -> cstartcpm.obj  (provides _cstart_, __STK, _small_code_)
"$WASM" -0 "$CRT0SRC" -fo="$DEST/cstartcpm.obj"
# 2) install the Watcom-native clib (auto-fetched via the 'clibs' default-lib record)
cp "$HERE/clibs.lib" "$DEST/clibs.lib"
echo "Installed: $DEST/{cstartcpm.obj,clibs.lib}"
echo "Now: owcc -bcpm86 -mcmodel=s prog.c -o prog.cmd"
