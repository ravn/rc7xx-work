#!/bin/sh
# build-ioslibs.sh -- archive the Open Watcom 16-bit iostream OBJECTS that the
# from-scratch OW build already compiled for the DOS/generic 8086 small model
# (bld/cpplib/iostream/generic.086/ms) into two CP/M-86-usable libraries:
#   iost_s.lib  -- iostreams, NO exception handling  (link with plibs.lib)
#   iosx_s.lib  -- iostreams, WITH exception handling (link with plbxs.lib, -xs)
#
# We do NOT port or recompile iostream: generic.086 is the OS-agnostic 8086
# target and the objects bottom out at POSIX `write`/`read` (symbol `write_`)
# plus clib helpers (`__clib_open_`, `__stdiobuf_read`) that the cpm86 clib
# (clibs.lib) supplies via a small fd shim -- there are NO Windows/DOS-int21
# externals (audited 2026-08-15). Reproducible, mirrors build-clib.sh.
set -e
OW="${OW:-/Users/ravn/z80/scratch/open-watcom-v2}"
WLIB="$OW/bld/nwlib/osxa64/wlib.exe"
IOSDIR="$OW/bld/cpplib/iostream/generic.086/ms"
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

[ -x "$WLIB" ] || { echo "no wlib at $WLIB" >&2; exit 1; }
[ -d "$IOSDIR" ] || { echo "no iostream objs at $IOSDIR" >&2; exit 1; }

build_lib() {
    lib="$1"; shift; dir="$1"
    rm -f "$lib"
    set --
    for o in "$dir"/*.obj; do set -- "$@" "+$o"; done
    "$WLIB" -q -b -n "$lib" "$@"
    echo "built $lib ($(wc -c < "$lib") bytes, $(ls "$dir"/*.obj | wc -l | tr -d ' ') objs)"
}

build_lib iost_s.lib "$IOSDIR"
build_lib iosx_s.lib "$IOSDIR/xobjs"
