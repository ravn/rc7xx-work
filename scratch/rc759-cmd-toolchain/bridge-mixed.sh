#!/bin/bash
# bridge-mixed.sh -- PROOF that the DRC bridge convention touches ONLY DR C stdlib
# routines: a program calling both DR C `strlen` (via #pragma aux (DRC)) and our
# OWN Watcom-compiled `triple()` (native convention, no pragma) links and runs
# correctly. Expect output "5 21".
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../../emu2-cpm86/emu2}"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="$HERE/drc86111"
[ -x "$EMU2" ] || { echo "emu2 not built at $EMU2"; exit 1; }
[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
for f in LINK86.CMD CLEARL.L86; do cp "$DRC/$f" "$WORK/"; done

# app (uses DR C strlen via DRC + our own triple via native) and our own lib
"$OW/bwcc" -0 -ml -s -q -zu -i="$HERE" "$HERE/bridge_mixed.c" -fo="$WORK/APP.OBJ"
"$OW/bwcc" -0 -ml -s -q -zu           "$HERE/mylib_own.c"    -fo="$WORK/MYLIB.OBJ"

cat > "$WORK/wmarks.asm" <<'ASM'
        public _big_code_
        public _small_code_
_big_code_   equ 0
_small_code_ equ 0
        end
ASM
"$OW/bwasm" -q -fo="$WORK/WMARKS.OBJ" "$WORK/wmarks.asm"

for o in APP MYLIB WMARKS; do
  python3 "$HERE/omf_classicize.py" "$WORK/$o.OBJ" "$WORK/${o}C.OBJ" >/dev/null
done

# Prove the split in the disassembly: bare `strlen` vs mangled `triple_`.
echo "== call conventions in APP.OBJ =="
"$OW/bwdis" "$WORK/APP.OBJ" 2>/dev/null | grep -iE "call[[:space:]]+(strlen|triple)" | sed 's/^/   /'

( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" \
    LINK86.CMD "OUT=APPC,MYLIBC,WMARKSC,CLEARL.L86" > link.log 2>&1 )
[ -f "$WORK/OUT.CMD" ] || { echo "link failed"; cat "$WORK/link.log"; exit 1; }

OUTPUT="$( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" OUT.CMD 2>&1 | tr -d '\r\n' )"
echo "emu2 output: [$OUTPUT]"
if [ "$OUTPUT" = "5 21" ]; then
    echo "PASS: DRC convention isolated to DR C stdlib; own routine stays native"
    exit 0
else
    echo "FAIL: expected '5 21', got [$OUTPUT]"; exit 1
fi
