#!/bin/bash
# wpp-cpm86.sh -- compile a C++ program to a native CP/M-86 .CMD with Open
# Watcom's own cpm86 target (FORMAT CPM86), with optional iostreams and
# exceptions. Sibling of wcc-cpm86.sh; adds the C++ pieces:
#   * wpp on PATH (wcl dispatches .cpp -> wpp).
#   * dos/h C++ headers on the include path (so <iostream> resolves).
#   * iostream + base C++ runtime libs archived from the from-scratch OW build:
#       no-EH : iost_s.lib + plibs.lib
#       EH    : iosx_s.lib + plbxs.lib   (with -xs)
#     both over our cpm86 clibs.lib (fd shim: write/read -> BDOS console).
#
#   ./wpp-cpm86.sh SRC.cpp OUT.cmd [--eh] [extra wpp flags...]
#
# NEVER search outside /Users/ravn/z80/.
set -euo pipefail

SRC="${1:?usage: wpp-cpm86.sh SRC.cpp OUT.cmd [--eh] [extra flags]}"
OUT="${2:?usage: wpp-cpm86.sh SRC.cpp OUT.cmd [--eh] [extra flags]}"
shift 2 || true

EH=0
EXTRA=()
for a in "$@"; do
    case "$a" in
        --eh) EH=1;;
        *) EXTRA+=("$a");;
    esac
done

OW="${OW:-/Users/ravn/z80/scratch/open-watcom-v2}"
CLIBDIR=/Users/ravn/z80/scratch/rc759-cmd-toolchain/cpm86-clib
WCL="$OW/bld/wcl/i86/osxa64/wcl.exe"
WPP="$OW/bld/plusplus/i86/osxa64/wpp.exe"
WLINK_LNK_SRC="$OW/bld/wl/lnk/osxa64/wlink.lnk"
INC="$OW/bld/hdr/dos/h"

for t in "$WCL" "$WPP" "$WLINK_LNK_SRC" \
         "$OW/bld/cc/i86/osxa64/binbuild/wcc.exe" \
         "$OW/bld/wasm/osxa64/wasm.exe" "$OW/bld/wl/osxa64/wlink.exe" \
         "$CLIBDIR/build-and-install.sh" "$CLIBDIR/build-ioslibs.sh" \
         "$INC/iostream"; do
    [ -e "$t" ] || { echo "MISSING: $t" >&2; exit 1; }
done
grep -qi "cpm86" "$WLINK_LNK_SRC" || { echo "stale wlink.lnk (no cpm86)" >&2; exit 1; }

# 1) staging WATCOM with the native cpm86 clib + crt0 + iostream libs (idempotent)
export WATCOM="${WATCOM:-/tmp/owwat}"
DEST="$WATCOM/lib286/cpm86"
if [ ! -f "$DEST/clibs.lib" ] || [ ! -f "$DEST/cstartcpm.obj" ]; then
    mkdir -p "$WATCOM"
    ( cd "$CLIBDIR" && WATCOM="$WATCOM" OW="$OW" ./build-and-install.sh >/dev/null )
fi
if [ ! -f "$CLIBDIR/iost_s.lib" ] || [ ! -f "$CLIBDIR/iosx_s.lib" ]; then
    ( cd "$CLIBDIR" && OW="$OW" ./build-ioslibs.sh >/dev/null )
fi
mkdir -p "$DEST"
cp -f "$CLIBDIR/iost_s.lib" "$CLIBDIR/iosx_s.lib" "$DEST/"

# 2) tool symlinks so wcl finds wcc/wpp/wasm/wlink by bare name, plus specs.owc.
BINX="${BINX:-/tmp/owbin}"; mkdir -p "$BINX"
ln -sf "$OW/bld/cc/i86/osxa64/binbuild/wcc.exe" "$BINX/wcc"
ln -sf "$WPP"                                    "$BINX/wpp"
ln -sf "$OW/bld/wasm/osxa64/wasm.exe"           "$BINX/wasm"
ln -sf "$OW/bld/wl/osxa64/wlink.exe"            "$BINX/wlink"
cp -f "$OW/bld/wcl/owcc/osxa64/specs.owc"       "$BINX/specs.owc"
export PATH="$BINX:$PATH"
export WLINK_LNK="$WLINK_LNK_SRC"

# 3) lib selection: EH vs no-EH. Copy the base C++ runtime into the staging
#    lib dir under its bare name too, so the DEFAULT LIBRARY 'plibs'/'plbxs'
#    directive embedded in the C++ objects resolves without a W1008 warning.
if [ "$EH" = 1 ]; then
    IOSLIB="$DEST/iosx_s.lib"; BASESRC="$OW/bld/cpplib/library/generic.086/ms/plbxs.lib"
    BASERT="$DEST/plbxs.lib"; EHFLAG="-xs"
else
    IOSLIB="$DEST/iost_s.lib"; BASESRC="$OW/bld/cpplib/library/generic.086/ms/plibs.lib"
    BASERT="$DEST/plibs.lib"; EHFLAG=""
fi
cp -f "$BASESRC" "$BASERT"

# 4) build: 8086 small model, cpm86 system, C++ headers on -i, iostream+rt libs.
#    Libraries are passed as bare positional args (wcl recognises .lib); do NOT
#    use -l= for them (that is the wcl *system* selector and collides).
"$WCL" -l=cpm86 -0 -ms ${EHFLAG:+$EHFLAG} -i="$INC" \
    "$SRC" -fe="$OUT" \
    "$IOSLIB" "$BASERT" \
    ${EXTRA[@]+"${EXTRA[@]}"}
echo "built $OUT ($(wc -c < "$OUT") bytes) -- native Watcom CP/M-86 C++ (EH=$EH)"
