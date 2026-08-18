#!/bin/bash
# bridge-min.sh -- PROOF of the minimal Watcom -> DR C bridge (drcbridge.h).
# Per-program source surface: #include "drcbridge.h", one `#pragma aux (DRC) fn;`
# per DR C routine, and DRC_MAIN. This script is the fixed, reusable build recipe.
#
# Fixed infrastructure (shared by every bridge program, written once):
#   - build flags:  bwcc -0 -ml -s -q -zu   (large model + SS!=DGROUP pointer fix)
#   - omf_classicize.py  (LPUBDEF/LEXTDEF -> PUBDEF/EXTDEF for LINK-86)
#   - marker stub  (_big_code_ / _small_code_ = 0; Watcom model markers)
#   - link against CLEARL.L86  (DR C's own startup + libc; supplies `main` caller)
#
# Expect output "5" (strlen("HELLO")).
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../../emu2-cpm86/emu2}"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="$HERE/drc86111"
[ -x "$EMU2" ] || { echo "emu2 not built at $EMU2"; exit 1; }
[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
for f in LINK86.CMD CLEARL.L86; do cp "$DRC/$f" "$WORK/"; done

# compile (header is found via -i include path to the toolchain dir)
"$OW/bwcc" -0 -ml -s -q -zu -i="$HERE" "$HERE/bridge_min.c" -fo="$WORK/APP.OBJ"

# fixed marker stub
cat > "$WORK/wmarks.asm" <<'ASM'
        public _big_code_
        public _small_code_
_big_code_   equ 0
_small_code_ equ 0
        end
ASM
"$OW/bwasm" -q -fo="$WORK/WMARKS.OBJ" "$WORK/wmarks.asm"

python3 "$HERE/omf_classicize.py" "$WORK/APP.OBJ"    "$WORK/APPC.OBJ"    >/dev/null
python3 "$HERE/omf_classicize.py" "$WORK/WMARKS.OBJ" "$WORK/WMARKSC.OBJ" >/dev/null

( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" \
    LINK86.CMD "OUT=APPC,WMARKSC,CLEARL.L86" > link.log 2>&1 )
if grep -qiE "target out|no file" "$WORK/link.log"; then
    echo "LINK-86 failed:"; cat "$WORK/link.log"; exit 1
fi
# Only `clear_error` (8087 emulator path) should remain undefined; it is dead code.
BAD=$(sed -n '/Undefined/,/USE FACTOR/p' "$WORK/link.log" | grep -iE "big_code|small_code|cstart|_main|strlen" || true)
[ -z "$BAD" ] || { echo "Unexpected undefined symbols:"; echo "$BAD"; exit 1; }
[ -f "$WORK/OUT.CMD" ] || { echo "no CMD produced"; cat "$WORK/link.log"; exit 1; }

OUTPUT="$( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" OUT.CMD 2>&1 | tr -d '\r\n' )"
echo "emu2 output: [$OUTPUT]"
if [ "$OUTPUT" = "5" ]; then
    echo "PASS: minimal Watcom -> DR C bridge (drcbridge.h) works (strlen HELLO == 5)"
    exit 0
else
    echo "FAIL: expected 5, got [$OUTPUT]"; exit 1
fi
