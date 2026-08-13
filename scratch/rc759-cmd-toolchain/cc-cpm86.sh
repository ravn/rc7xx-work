#!/bin/bash
# cc-cpm86.sh -- "select the CP/M-86 target" driver for Open Watcom + DR C 1.11.
# Compiles one or more C sources into a CP/M-86 .CMD, pulling in the Watcom-side
# target glue (install-cpm86-target.sh must have been run first). The user's C
# needs NO bridge pragmas: _preincl.h in the target dir is auto-included and
# supplies the DR C calling convention, DRC_MAIN, and the stdlib pragmas.
#
# Usage:  cc-cpm86.sh [-m s|l] -o OUT.CMD file1.c [file2.c ...]
#   -m l  large model (default): bwcc -ml       + link CLEARL.L86
#   -m s  small model          : bwcc -ms -nt=CODE + link CLEARS.L86
#
# Both models share ONE _preincl.h (model-conditional on __LARGE__/__SMALL__) and
# ONE user source. Pipeline: bwcc -0 -m? -s -q -zu -i<target> ; classicize ;
# LINK-86 objs + WMARKS + CLEAR?.L86 -> relocatable CMD.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="${DRC:-$HERE/drc86111}"
CPM86_TARGET_DIR="${CPM86_TARGET_DIR:-$HERE/../open-watcom-v2/cpm86}"
[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }
[ -f "$CPM86_TARGET_DIR/_preincl.h" ] || { echo "Run install-cpm86-target.sh first (no $CPM86_TARGET_DIR/_preincl.h)"; exit 1; }

MODEL="l"; OUT="A.CMD"; SRCS=()
while [ $# -gt 0 ]; do
  case "$1" in
    -m) MODEL="$2"; shift 2;;
    -o) OUT="$2"; shift 2;;
    *)  SRCS+=("$1"); shift;;
  esac
done
[ ${#SRCS[@]} -gt 0 ] || { echo "usage: cc-cpm86.sh [-m s|l] -o OUT.CMD file.c [...]"; exit 1; }

# Model -> Watcom code-gen flags + DR C runtime library.
#   -ecc  : default calling convention = cdecl (args on stack, caller cleans) --
#           MUST match DR C, and stdcbench proved it is required for the program's
#           OWN inter-module + recursive calls too: with Watcom's default (watcall,
#           register-based) deep recursion corrupts the return linkage and the
#           program terminates mid-run instead of returning (small model: no scores
#           without -ecc, 7/5/12 with it).
#   -fpi87: inline 8087 float (DR C's library provides no Watcom float helpers).
#   -zu   : SS != DGROUP -- correct only for the LARGE model (DR C small has
#           SS == DS == DGROUP, where -zu wrongly introduces far pointers, W112).
case "$MODEL" in
  l) MFLAGS="-ml";           CLEAR="CLEARL.L86"; ZU="-zu"; CGMODEL="ml"; CGMERGE="";;
  s) MFLAGS="-ms -nt=CODE";  CLEAR="CLEARS.L86"; ZU=""; CGMODEL="ms"; CGMERGE="--merge-text-into-code";;  # -nt=CODE: merge text into CLEARS's CODE group
  *) echo "unknown model '$MODEL' (use s or l)"; exit 1;;
esac

# 32-bit long helpers (__U4M/__I4M/__U4D/__I4D) are NOT in DR C's CLEAR?.L86 --
# they are Open Watcom's OWN pre-built cgsupp objects (i4m.obj = __U4M/__I4M,
# i4d.obj = __U4D/__I4D). Without linking them, any runtime `long` mul/div emits
# `call far ptr __I4M` to an UNDEFINED symbol (address ~0) -> hang on real
# hardware (MAME rc759), wrong value under emu2. Watcom's build already picks the
# correct near(ms)/far(ml) RET per model; ms needs the helper _TEXT merged into
# CODE (CGMERGE) like the user modules. (msdos.086 == canonical 8086; the helpers
# are pure integer math, OS-agnostic.)
CGDIR="$CPM86_TARGET_DIR/../bld/clib/cgsupp/library/msdos.086/$CGMODEL"

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
cp "$DRC/LINK86.CMD" "$DRC/$CLEAR" "$CPM86_TARGET_DIR/WMARKS.OBJ" "$WORK/"

# Classicize Open Watcom's long-math helper objects (see CGDIR note above).
[ -f "$CGDIR/i4m.obj" ] && [ -f "$CGDIR/i4d.obj" ] || { echo "Watcom cgsupp helpers not built at $CGDIR"; exit 1; }
python3 "$HERE/omf_classicize.py" "$CGDIR/i4m.obj" "$WORK/I4M.OBJ" $CGMERGE >/dev/null
python3 "$HERE/omf_classicize.py" "$CGDIR/i4d.obj" "$WORK/I4D.OBJ" $CGMERGE >/dev/null

OBJLIST=""
i=0
for src in "${SRCS[@]}"; do
  i=$((i+1)); OBJ="M$i"
  # -i=<target>: auto-includes _preincl.h (the glue).
  "$OW/bwcc" -0 $MFLAGS -s -q $ZU -ecc -fpi87 -i="$CPM86_TARGET_DIR" "$src" -fo="$WORK/$OBJ.OBJ"
  python3 "$HERE/omf_classicize.py" "$WORK/$OBJ.OBJ" "$WORK/${OBJ}C.OBJ" >/dev/null
  OBJLIST="${OBJLIST:+$OBJLIST,}${OBJ}C"
done

( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" \
    LINK86.CMD "OUT=$OBJLIST,I4M,I4D,WMARKS,$CLEAR" > link.log 2>&1 )
if grep -qiE "target out|no file" "$WORK/link.log"; then
    echo "LINK-86 failed:"; cat "$WORK/link.log"; exit 1
fi
# Fail on ANY undefined symbol -- only `clear_error` (dead 8087 path) is allowed.
# A missing runtime helper (e.g. __I4M when the cgsupp link is dropped) otherwise
# links to address ~0 and produces a CMD that HANGS on real hardware, so this
# guard must be broad, not a big_code/small_code/cstart allowlist. Undefined rows
# are "symbol  FILE.{L86,OBJ}  MODULE"; match on the file-reference column to
# avoid the trailing CODE/DATA/EXTRA/STACK segment-size table in the same block.
BAD=$(sed -n '/Undefined/,/USE FACTOR/p' "$WORK/link.log" | grep -iE "\.(L86|OBJ)" | grep -viE "clear_error" || true)
[ -z "$BAD" ] || { echo "Unexpected undefined symbols:"; echo "$BAD"; cat "$WORK/link.log"; exit 1; }
[ -f "$WORK/OUT.CMD" ] || { echo "no CMD produced"; cat "$WORK/link.log"; exit 1; }
cp "$WORK/OUT.CMD" "$OUT"
echo "wrote $OUT"
