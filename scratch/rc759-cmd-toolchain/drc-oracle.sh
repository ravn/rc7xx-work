#!/bin/bash
# drc-oracle.sh -- build a C program with the genuine DR C 1.11 toolchain,
# fully headless under patched emu2-cpm86. This is the CORRECTNESS ORACLE.
#
# DR C runs headless thanks to three emu2-cpm86 fixes (FCB bit-7 masking,
# auxiliary-group loading, BDOS 47 chaining) captured in emu2-patches/ and
# forked at ravn/emu2-cpm86 (branch cpm86-drc-headless).
#
# Usage:  ./drc-oracle.sh prog.c [out.cmd]
#   prog.c must define main() (DR C entry). DR C is K&R C89: no unsigned char
#   casts (Error 13), old-style params. DR C defaults to the LARGE model, so we
#   link with CLEARL.L86 (small-model CLEARS gives __BDOS TARGET OUT OF RANGE).
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
DRC="$HERE/drc86111"
SRC="$1"; [ -z "$SRC" ] && { echo "usage: drc-oracle.sh prog.c [out.cmd]"; exit 1; }
BASE="$(basename "${SRC%.c}")"
OUT="${2:-$BASE.CMD}"
[ -x "$EMU2" ] || { echo "emu2 not built at $EMU2 (run make in its dir)"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
# DR C compiler chain + large-model libc, all from the tracked drc86111 archive.
for f in DRC.CMD DRC860.CMD DRC861.CMD DRC862.CMD DRCRPP.CMD LINK86.CMD \
         CLEARL.L86 CPMEOF.ASC STDIO.H CTYPE.H PORTAB.H DOS.H ALLOC.H; do
    [ -f "$DRC/$f" ] && cp "$DRC/$f" "$WORK/"
done

# DR C needs the source EOF-padded with esc bytes (its batch files do this via an
# intermediate file); replicate by appending CPMEOF.ASC.
cp "$SRC" "$WORK/srcfile.c"
cat "$WORK/CPMEOF.ASC" >> "$WORK/srcfile.c" 2>/dev/null || true

# 1. compile: DRC.CMD chains DRC860 (preprocess) -> DRC861 (codegen) -> srcfile.obj
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" DRC.CMD "srcfile -b" )
[ -f "$WORK/srcfile.obj" ] || { echo "DR C compile failed"; exit 1; }

# 2. link with the LARGE-model runtime -> runnable CMD
cp "$WORK/srcfile.obj" "$WORK/OUT.OBJ"
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" LINK86.CMD "OUT,CLEARL.L86[S]" )
[ -f "$WORK/OUT.CMD" ] || { echo "DR C link failed"; exit 1; }
cp "$WORK/OUT.CMD" "$OUT"
echo "built $OUT ($(stat -f%z "$OUT") bytes) via DR C 1.11 oracle"
