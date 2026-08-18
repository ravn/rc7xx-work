#!/bin/bash
# ccrc759 - compile a C program to a CP/M-86 .CMD for RC759 (Concurrent CP/M-86 3.1)
# Pipeline (all host-side, verified 2026-08-13):
#   Open Watcom bwcc  -> 8086 OMF .obj
#   omf_classicize.py -> rewrite LPUBDEF/LEXTDEF -> classic PUBDEF/EXTDEF
#   DR C LINK-86 v1.4 -> .CMD  (run headless under emu2-cpm86)
# Entry point in the C source must be cmain() (Watcom watcall symbol cmain_).
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
OW=/Users/ravn/z80/scratch/open-watcom-v2/build/binbuild
EMU2=/Users/ravn/z80/emu2-cpm86/emu2
DRC="$HERE/drc-toolchain"
SRC="$1"; [ -z "$SRC" ] && { echo "usage: ccrc759.sh prog.c [out.cmd]"; exit 1; }
BASE="$(basename "${SRC%.c}")"
OUT="${2:-$BASE.CMD}"
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT

# 1. assemble crt0 (startup) and compile the C source
"$OW/bwasm" -q -fo="$WORK/CRT0.OBJ" "$HERE/crt0.asm" >/dev/null
"$OW/bwcc" -0 -ms -s -q "$SRC" -fo="$WORK/APP.OBJ" >/dev/null
# 2. normalize BOTH Watcom OMF objects -> classic Intel OMF for LINK-86
#    (rewrites LPUBDEF/LEXTDEF; shortens long THEADR names LINK-86 v1.4 rejects)
python3 "$HERE/omf_classicize.py" "$WORK/CRT0.OBJ" "$WORK/CRT0C.OBJ" >/dev/null
python3 "$HERE/omf_classicize.py" "$WORK/APP.OBJ" "$WORK/APPC.OBJ" >/dev/null
# 3. link with DR C LINK-86 under emu2 (crt0 first for offset-0 entry)
cp "$DRC/link86.cmd" "$WORK/LINK86.CMD"
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" LINK86.CMD "OUT=CRT0C,APPC" >/tmp/link86.log 2>&1 )
[ -f "$WORK/OUT.CMD" ] || { echo "LINK-86 failed:"; cat /tmp/link86.log; exit 1; }
cp "$WORK/OUT.CMD" "$OUT"
echo "built $OUT ($(stat -f%z "$OUT") bytes)"
