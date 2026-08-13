#!/bin/bash
# bridge-pointer.sh -- PROOF that Watcom-compiled code can pass POINTER arguments
# to a genuine DR C 1.11 library routine (strlen) across the compiler/ABI
# boundary. This closes the pointer gap left by bridge-scalar.sh.
#
# Pipeline (same as scalar, plus the -zu flag):
#   1. Compile bridge_pointer.c with Watcom -ml -zu -> far-calls "strlen",
#      pushing a REAL DGROUP segment fixup for data pointers (not `push ss`).
#   2. Classicize the OMF (LPUBDEF/LEXTDEF -> PUBDEF/EXTDEF) for LINK-86.
#   3. Link app + marker-stub + CLEARL.L86 -> relocatable large-model CMD
#      (CLEARL supplies startup, entry, AND strlen; NO hand-written crt0).
#   4. Run under patched emu2-cpm86; expect "5 0 11".
#
# WHY -zu: Watcom -ml otherwise assumes SS==DS==DGROUP and passes a data
# pointer's segment as `push ss`. DR C's CLEARL startup runs SS!=DS, so strlen
# would read the wrong segment and return 0. `-zu` (SS != DGROUP) makes Watcom
# emit a proper DGROUP segment relocation instead -- exactly like DR C's own
# code -- so strlen reads the correct segment. Verified: without -zu -> 0;
# with -zu -> correct length. See wlink-cpm86-plan.md finding (e).
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="$HERE/drc86111"
[ -x "$EMU2" ] || { echo "emu2 not built at $EMU2"; exit 1; }
[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
for f in LINK86.CMD CLEARL.L86; do cp "$DRC/$f" "$WORK/"; done

# 1. Watcom app, large model + -zu (pointer-safe DGROUP fixup)
"$OW/bwcc" -0 -ml -s -q -zu "$HERE/bridge_pointer.c" -fo="$WORK/APP.OBJ"
cat > "$WORK/wmarks.asm" <<'ASM'
        public _big_code_
        public _small_code_
_big_code_   equ 0
_small_code_ equ 0
        end
ASM
"$OW/bwasm" -q -fo="$WORK/WMARKS.OBJ" "$WORK/wmarks.asm"

# 2. classicize the Watcom OMFs so LINK-86 accepts them
python3 "$HERE/omf_classicize.py" "$WORK/APP.OBJ"    "$WORK/APPC.OBJ"    >/dev/null
python3 "$HERE/omf_classicize.py" "$WORK/WMARKS.OBJ" "$WORK/WMARKSC.OBJ" >/dev/null

# 3. link -> relocatable large-model CMD (CLEARL provides startup + strlen)
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" \
    LINK86.CMD "OUT=APPC,WMARKSC,CLEARL.L86" > link.log 2>&1 )
if grep -qiE "target out|no file" "$WORK/link.log"; then
    echo "LINK-86 failed:"; cat "$WORK/link.log"; exit 1
fi
# `clear_error` (8087 emulator path) is expected-undefined and dead for integer code.
[ -f "$WORK/OUT.CMD" ] || { echo "no CMD produced"; cat "$WORK/link.log"; exit 1; }

# 4. run and check
OUTPUT="$( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" OUT.CMD 2>&1 | tr -d '\r\n' )"
echo "emu2 output: [$OUTPUT]"
if [ "$OUTPUT" = "5 0 11" ]; then
    echo "PASS: Watcom -> DR C POINTER ABI bridge works (strlen of 3 strings)"
    exit 0
else
    echo "FAIL: expected '5 0 11', got [$OUTPUT]"; exit 1
fi
