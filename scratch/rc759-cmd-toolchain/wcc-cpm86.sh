#!/bin/bash
# wcc-cpm86.sh -- compile a C program to a native CP/M-86 .CMD with Open Watcom's
# OWN cpm86 target (system cpm86 / FORMAT CPM86).  NO DR C, NO hand-invoked wlink,
# NO bridge: it is just the normal Watcom driver (wcl) building for -l=cpm86.
#
#   ./wcc-cpm86.sh SRC.c OUT.cmd [extra wcc flags...]
#   e.g. ./wcc-cpm86.sh hello.c hello.cmd -otexan
#
# What this wires up (the pieces the driver needs, discovered 2026-08-15):
#   * WLINK_LNK  -> bld/wl/lnk/osxa64/wlink.lnk  (the generated systems file that
#                   actually contains `system cpm86`; without it wlink says
#                   "undefined system name: cpm86").
#   * WATCOM     -> a staging install root with lib286/cpm86/{clibs.lib,
#                   cstartcpm.obj} (the Watcom-native CP/M-86 clib + crt0),
#                   installed idempotently from cpm86-clib/build-and-install.sh.
#   * PATH       -> symlinks wcc/wasm/wlink so the wcl driver can find the tools.
# NEVER search outside /Users/ravn/z80/.
set -euo pipefail

SRC="${1:?usage: wcc-cpm86.sh SRC.c OUT.cmd [extra wcc flags]}"
OUT="${2:?usage: wcc-cpm86.sh SRC.c OUT.cmd [extra wcc flags]}"
shift 2 || true
EXTRA=("$@")

OW="${OW:-/Users/ravn/z80/scratch/open-watcom-v2}"          # built OW tree (cpm86 source == root committed)
CLIBDIR=/Users/ravn/z80/scratch/rc759-cmd-toolchain/cpm86-clib
WCL="$OW/bld/wcl/i86/osxa64/wcl.exe"
WLINK_LNK_SRC="$OW/bld/wl/lnk/osxa64/wlink.lnk"

for t in "$WCL" "$WLINK_LNK_SRC" "$OW/bld/cc/i86/osxa64/binbuild/wcc.exe" \
         "$OW/bld/wasm/osxa64/wasm.exe" "$OW/bld/wl/osxa64/wlink.exe" \
         "$CLIBDIR/build-and-install.sh"; do
    [ -e "$t" ] || { echo "MISSING: $t" >&2; exit 1; }
done
grep -qi "cpm86" "$WLINK_LNK_SRC" || { echo "stale wlink.lnk (no cpm86); rebuild wlink_lnk" >&2; exit 1; }

# 1) staging WATCOM with the native cpm86 clib + crt0 (idempotent)
export WATCOM="${WATCOM:-/tmp/owwat}"
if [ ! -f "$WATCOM/lib286/cpm86/clibs.lib" ] || [ ! -f "$WATCOM/lib286/cpm86/cstartcpm.obj" ]; then
    mkdir -p "$WATCOM"
    ( cd "$CLIBDIR" && WATCOM="$WATCOM" OW="$OW" ./build-and-install.sh >/dev/null )
fi

# 2) tool symlinks so wcl/owcc find wcc/wasm/wlink by bare name, plus specs.owc.
#    FindPath() (_searchenv on PATH) does NOT look in owcc's own dir, so the
#    cpm86-carrying specs.owc must be ON PATH or `owcc -bcpm86` fails with
#    "Unable to find 'specs.owc'".
BINX="${BINX:-/tmp/owbin}"; mkdir -p "$BINX"
ln -sf "$OW/bld/cc/i86/osxa64/binbuild/wcc.exe" "$BINX/wcc"
ln -sf "$OW/bld/wasm/osxa64/wasm.exe"           "$BINX/wasm"
ln -sf "$OW/bld/wl/osxa64/wlink.exe"            "$BINX/wlink"
cp -f "$OW/bld/wcl/owcc/osxa64/specs.owc"       "$BINX/specs.owc"
export PATH="$BINX:$PATH"
export WLINK_LNK="$WLINK_LNK_SRC"

# 3) the normal Watcom build: 8086 small model, cpm86 system -> .CMD
"$WCL" -l=cpm86 -0 -ms "${EXTRA[@]}" -fe="$OUT" "$SRC"
echo "built $OUT ($(wc -c < "$OUT") bytes) -- native Watcom CP/M-86"
