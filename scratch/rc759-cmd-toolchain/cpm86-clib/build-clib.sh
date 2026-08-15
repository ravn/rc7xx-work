#!/bin/sh
# build-clib.sh -- (re)compile the minimal CP/M-86 C library sources and archive
# them into clibs.lib, so `wcl -l=cpm86 / owcc -bcpm86` can link C (and the C++
# runtime bits that reference C helpers like __clib_fatal).  Reproducible.
set -e
OW="${OW:-/Users/ravn/z80/scratch/open-watcom-v2}"
WCC="$OW/bld/cc/i86/osxa64/binbuild/wcc.exe"
WASM="$OW/bld/wasm/osxa64/wasm.exe"
WLIB="$OW/bld/nwlib/osxa64/wlib.exe"
INC="$OW/bld/hdr/dos/h"
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
for c in cpmio fileio printf stdlib string cpprt ehsupp; do
    "$WCC" -0 -ms -zq -i="$INC" "$c.c" -fo="$c.o"
done
# setjmp86.obj = Watcom's own 8086 small-model setjmp/longjmp, assembled straight
# from bld/clib/startup/a/stjmp086.asm (proven-correct jmp_buf ABI; -d__SMALL__
# selects the small-model, non-overlay path). Provides _setjmp_/longjmp_ for C++
# exceptions (Track B); the overlay/handler seams it references come from ehsupp.c.
cp -f "$OW/bld/clib/startup/a/stjmp086.asm" setjmp86.asm
"$WASM" -0 -d__SMALL__ -i="$OW/bld/watcom/h" setjmp86.asm -fo=setjmp86.obj
rm -f clibs.lib
"$WLIB" -q -b -n clibs.lib +cpmio.o +fileio.o +printf.o +stdlib.o +string.o +cpprt.o +ehsupp.o +setjmp86.obj +i4m.obj +i4d.obj
echo "built clibs.lib ($(wc -c < clibs.lib) bytes)"
