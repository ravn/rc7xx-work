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
#
# Env flags (default off = the original small-libc integer-oracle behaviour):
#   DRC_PUTCHAR=1  link a LARGE-model FAR putchar (owc-drc/putchar-far.asm) so
#                  putchar()-emitting programs actually produce output. DR C
#                  large-model far-calls externals; the small/near putchar
#                  corrupts the stack (see wlink-cpm86-plan.md). The far putchar
#                  is assembled by Open Watcom bwasm with -nm=PF, which sets the
#                  OMF module name DIRECTLY -- this is the whole point: without
#                  it bwasm stamps the 82-char absolute mktemp path into the
#                  THEADR and DR LINK-86 v1.4 rejects any name >35 chars with
#                  "OBJECT FILE ERROR 10". -nm= is a NATIVE tool flag, so there
#                  is NO THEADR post-patch / OMF-checksum fix-up script.
#   DRC_8087=1     compile with -f (inline 8087 ESC codegen) instead of the
#                  default software double. NOT RC759-faithful (RC759 has no
#                  8087); use only for the coprocessor-timing comparison.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../../emu2-cpm86/emu2}"
BWASM="${BWASM:-$HERE/../../open-watcom-v2/build/binbuild/bwasm}"
PUTFAR_ASM="${PUTFAR_ASM:-$HERE/../../open-watcom-v2/contrib/ravn/owc-drc/putchar-far.asm}"
# MAME bracket markers (mame_start/mame_end -> OUT 0x2FE) as a FAR stub, linked
# only when DRC_MAMEMARK=1. Additive, exactly like DRC_PUTCHAR above.
MAMEMARK_ASM="${MAMEMARK_ASM:-$HERE/../../cpm86-compiler-comparison/tools/mame-mark-far.asm}"
# Toolchain source. Default = the OFFICIAL Regnecentralen RC759 DR C v1.11 disk
# (datamuseum.dk bits 30005869), extracted to rc759-drc-official/ -- the pristine
# oracle. The hobby drc86111/ port (identical codegen passes, ~9 patched serial
# bytes in DRC/LINK86/RASM86) is the FALLBACK, and also supplies the few helper
# files the single official disk lacks (CPMEOF.ASC, DOS.H, ALLOC.H). Override
# with DRC=... to force a specific toolchain dir.
DRC="${DRC:-$HERE/rc759-drc-official}"
DRC_FALLBACK="${DRC_FALLBACK:-$HERE/drc86111}"
SRC="$1"; [ -z "$SRC" ] && { echo "usage: drc-oracle.sh prog.c [out.cmd]"; exit 1; }
BASE="$(basename "${SRC%.c}")"
OUT="${2:-$BASE.CMD}"
[ -x "$EMU2" ] || { echo "emu2 not built at $EMU2 (run make in its dir)"; exit 1; }
if [ -n "$DRC_PUTCHAR" ]; then
    [ -x "$BWASM" ] || { echo "bwasm not built at $BWASM (build Open Watcom)"; exit 1; }
    [ -f "$PUTFAR_ASM" ] || { echo "putchar-far.asm not found at $PUTFAR_ASM"; exit 1; }
fi
if [ -n "$DRC_MAMEMARK" ]; then
    [ -x "$BWASM" ] || { echo "bwasm not built at $BWASM (build Open Watcom)"; exit 1; }
    [ -f "$MAMEMARK_ASM" ] || { echo "mame-mark-far.asm not found at $MAMEMARK_ASM"; exit 1; }
fi

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
# DR C compiler chain + large-model libc. Prefer $DRC (official disk); fill any
# file it lacks from $DRC_FALLBACK (hobby port). Official disk stores lowercase
# names; macOS FS is case-insensitive so DRC.CMD matches drc.cmd.
for f in DRC.CMD DRC860.CMD DRC861.CMD DRC862.CMD DRCRPP.CMD LINK86.CMD \
         CLEARL.L86 CPMEOF.ASC STDIO.H CTYPE.H PORTAB.H DOS.H ALLOC.H; do
    if [ -f "$DRC/$f" ]; then cp "$DRC/$f" "$WORK/$f"
    elif [ -f "$DRC_FALLBACK/$f" ]; then cp "$DRC_FALLBACK/$f" "$WORK/$f"; fi
done

# Copy any sibling headers next to the source so DR C's `#include "x.h"` (which
# searches the compile CWD = WORK) resolves them. Names must fit CP/M 8.3.
for h in "$(dirname "$SRC")"/*.h; do
    [ -f "$h" ] && cp "$h" "$WORK/$(basename "$h")"
done

# DR C needs the source EOF-padded with esc bytes (its batch files do this via an
# intermediate file); replicate by appending CPMEOF.ASC.
cp "$SRC" "$WORK/srcfile.c"
cat "$WORK/CPMEOF.ASC" >> "$WORK/srcfile.c" 2>/dev/null || true

# 1. compile: DRC.CMD chains DRC860 (preprocess) -> DRC861 (codegen) -> srcfile.obj
#    -b = big/large model; DRC_8087 adds -f for inline 8087 codegen.
CFLAGS="-b"; [ -n "$DRC_8087" ] && CFLAGS="-b -f"
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" DRC.CMD "srcfile $CFLAGS" )
[ -f "$WORK/srcfile.obj" ] || { echo "DR C compile failed"; exit 1; }

# 2. link with the LARGE-model runtime -> runnable CMD.
#    DRC_PUTCHAR adds the FAR putchar. bwasm -nm=PF sets the OMF module name
#    directly (NATIVE flag) so DR LINK-86 accepts the THEADR -- no post-patch.
cp "$WORK/srcfile.obj" "$WORK/OUT.OBJ"
LINKLIST="OUT,CLEARL.L86[S]"
if [ -n "$DRC_PUTCHAR" ]; then
    "$BWASM" -0 -ml -nm=PF "$PUTFAR_ASM" -fo="$WORK/PUTFAR.OBJ" >/dev/null
    [ -f "$WORK/PUTFAR.OBJ" ] || { echo "bwasm putchar-far failed"; exit 1; }
    LINKLIST="OUT,PUTFAR,CLEARL.L86[S]"
fi
if [ -n "$DRC_MAMEMARK" ]; then
    "$BWASM" -0 -ml -nm=MM "$MAMEMARK_ASM" -fo="$WORK/MAMEMARK.OBJ" >/dev/null
    [ -f "$WORK/MAMEMARK.OBJ" ] || { echo "bwasm mame-mark-far failed"; exit 1; }
    # Insert MAMEMARK after OUT (and after PUTFAR if present) but before the libc.
    LINKLIST="$(printf '%s' "$LINKLIST" | sed 's/,CLEARL.L86\[S\]/,MAMEMARK,CLEARL.L86[S]/')"
fi
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" LINK86.CMD "$LINKLIST" )
[ -f "$WORK/OUT.CMD" ] || { echo "DR C link failed"; exit 1; }
cp "$WORK/OUT.CMD" "$OUT"
echo "built $OUT ($(stat -f%z "$OUT") bytes) via DR C 1.11 oracle${DRC_8087:+ [8087]}${DRC_PUTCHAR:+ [far-putchar]}"
