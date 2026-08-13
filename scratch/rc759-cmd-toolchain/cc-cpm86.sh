#!/bin/bash
# cc-cpm86.sh -- "select the CP/M-86 target" driver for Open Watcom + DR C 1.11.
# Compiles one or more C sources into a CP/M-86 .CMD, pulling in the Watcom-side
# target glue (install-cpm86-target.sh must have been run first). The user's C
# needs NO bridge pragmas: _preincl.h in the target dir is auto-included and
# supplies the DR C calling convention, DRC_MAIN, and the stdlib pragmas.
#
# Usage:  cc-cpm86.sh -o OUT.CMD file1.c [file2.c ...]
#
# Pipeline per the verified recipe: bwcc -0 -ml -s -q -zu -i<target> ; classicize ;
# LINK-86 objs + WMARKS + CLEARL.L86 -> relocatable large-model CMD.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="${DRC:-$HERE/drc86111}"
CPM86_TARGET_DIR="${CPM86_TARGET_DIR:-$HERE/../open-watcom-v2/cpm86}"
[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }
[ -f "$CPM86_TARGET_DIR/_preincl.h" ] || { echo "Run install-cpm86-target.sh first (no $CPM86_TARGET_DIR/_preincl.h)"; exit 1; }

OUT="A.CMD"; SRCS=()
while [ $# -gt 0 ]; do
  case "$1" in
    -o) OUT="$2"; shift 2;;
    *)  SRCS+=("$1"); shift;;
  esac
done
[ ${#SRCS[@]} -gt 0 ] || { echo "usage: cc-cpm86.sh -o OUT.CMD file.c [...]"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
cp "$DRC/LINK86.CMD" "$DRC/CLEARL.L86" "$CPM86_TARGET_DIR/WMARKS.OBJ" "$WORK/"

OBJLIST=""
i=0
for src in "${SRCS[@]}"; do
  i=$((i+1)); OBJ="M$i"
  # -zu: pointer args need a real DGROUP fixup (DR C runs SS!=DS).
  # -i=<target>: auto-includes _preincl.h (the glue).
  "$OW/bwcc" -0 -ml -s -q -zu -i="$CPM86_TARGET_DIR" "$src" -fo="$WORK/$OBJ.OBJ"
  python3 "$HERE/omf_classicize.py" "$WORK/$OBJ.OBJ" "$WORK/${OBJ}C.OBJ" >/dev/null
  OBJLIST="${OBJLIST:+$OBJLIST,}${OBJ}C"
done

( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" \
    LINK86.CMD "OUT=$OBJLIST,WMARKS,CLEARL.L86" > link.log 2>&1 )
if grep -qiE "target out|no file" "$WORK/link.log"; then
    echo "LINK-86 failed:"; cat "$WORK/link.log"; exit 1
fi
# Only `clear_error` (dead 8087 path) may remain undefined for integer programs.
BAD=$(sed -n '/Undefined/,/USE FACTOR/p' "$WORK/link.log" | grep -iE "big_code|small_code|cstart" || true)
[ -z "$BAD" ] || { echo "Unexpected undefined symbols:"; echo "$BAD"; cat "$WORK/link.log"; exit 1; }
[ -f "$WORK/OUT.CMD" ] || { echo "no CMD produced"; cat "$WORK/link.log"; exit 1; }
cp "$WORK/OUT.CMD" "$OUT"
echo "wrote $OUT"
