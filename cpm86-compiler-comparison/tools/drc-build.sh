#!/bin/bash
# drc-build.sh <shared-source.c> <out.obj> [-b]  -- compile one benchmark with the
# GENUINE Digital Research C 1.11 compiler (headless under the patched emu2-cpm86)
# and copy the resulting Intel-OMF object to <out.obj>. DR C stands ALONE here:
# its own compiler + runtime, never combined with Open Watcom.
#
# Default = small model; `-b` = large model. DR C 1.11 lacks `unsigned char`
# (Error 13) but its plain `char` is unsigned, so we map `unsigned char`->`char`:
# identical 8-bit semantics, no algorithm change, harmless to sources without it.
set -u
SRC="$1"; OUT="$2"; FLAG="${3:-}"
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
EMU2="$ROOT/emu2-cpm86/emu2"
DRC_OFF="$ROOT/scratch/rc759-cmd-toolchain/rc759-drc-official"
DRC_FB="$ROOT/scratch/rc759-cmd-toolchain/drc86111"

W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
for f in DRC.CMD DRC860.CMD DRC861.CMD DRC862.CMD DRCRPP.CMD CPMEOF.ASC STDIO.H CTYPE.H PORTAB.H; do
    if   [ -f "$DRC_OFF/$f" ]; then cp "$DRC_OFF/$f" "$W/$f"
    elif [ -f "$DRC_FB/$f"  ]; then cp "$DRC_FB/$f"  "$W/$f"; fi
done
sed 's/unsigned char/char/g' "$SRC" > "$W/srcfile.c"
cat "$W/CPMEOF.ASC" >> "$W/srcfile.c" 2>/dev/null
( cd "$W" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" DRC.CMD "srcfile $FLAG" ) >/dev/null 2>&1
[ -f "$W/srcfile.obj" ] && cp "$W/srcfile.obj" "$OUT"
