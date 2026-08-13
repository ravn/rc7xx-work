#!/bin/bash
# bridge-scalar.sh -- PROOF that Watcom-compiled code can call a genuine DR C
# 1.11-compiled routine across the compiler/ABI boundary (the "hole through").
#
# Pipeline:
#   1. Compile bridge_add_lib.c  with DR C 1.11  -> far `add` (retf, DR C ABI)
#   2. Compile bridge_scalar.c   with Watcom -ml -> far-calls `add` via #pragma aux
#   3. Classicize both OMFs (LPUBDEF/LEXTDEF -> PUBDEF/EXTDEF) for LINK-86
#   4. Link app + add + marker-stub + CLEARL.L86 -> relocatable large-model CMD
#      (CLEARL supplies startup; NO hand-written crt0)
#   5. Run under patched emu2-cpm86; expect "16" (add(7,9)).
#
# WHY CLEARL startup (not our crt0): a hand-written single-group crt0 collapses
# to the CP/M-86 "8080 model", which does NOT relocate the far-call segment
# operand -> the far call jumps to garbage (observed: undefined opcode 0x63).
# Linking against CLEARL yields a proper multi-group relocatable CMD whose loader
# fixes up far-call segments, exactly like a native DR C large-model program.
#
# SCOPE: scalar args/returns only (int in/out, long in DX:AX). Pointer args need
# the `-zu` flag (SS != DGROUP) -- see bridge-pointer.sh and wlink-cpm86-plan.md (e).
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
EMU2="${EMU2:-$HERE/../cpm86-tools/emu2-cpm86/emu2}"
OW="${OW:-$HERE/../open-watcom-v2/build/binbuild}"
DRC="$HERE/drc86111"
[ -x "$EMU2" ] || { echo "emu2 not built at $EMU2"; exit 1; }
[ -x "$OW/bwcc" ] || { echo "Open Watcom not built at $OW"; exit 1; }

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
for f in DRC.CMD DRC860.CMD DRC861.CMD DRC862.CMD DRCRPP.CMD LINK86.CMD \
         CLEARL.L86 CPMEOF.ASC; do cp "$DRC/$f" "$WORK/"; done

# 1. DR C callee -> ADD.OBJ (EOF-pad the source the way DR C's batch files do)
cp "$HERE/bridge_add_lib.c" "$WORK/srcfile.c"; cat "$WORK/CPMEOF.ASC" >> "$WORK/srcfile.c"
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" DRC.CMD "srcfile -b" >/dev/null 2>&1 )
[ -f "$WORK/srcfile.obj" ] || { echo "DR C compile failed"; exit 1; }
cp "$WORK/srcfile.obj" "$WORK/ADD.OBJ"

# 2. Watcom app (large model), + marker-symbol stub for Watcom model markers
"$OW/bwcc" -0 -ml -s -q "$HERE/bridge_scalar.c" -fo="$WORK/APP.OBJ"
cat > "$WORK/wmarks.asm" <<'ASM'
        public _big_code_
        public _small_code_
_big_code_   equ 0
_small_code_ equ 0
        end
ASM
"$OW/bwasm" -q -fo="$WORK/WMARKS.OBJ" "$WORK/wmarks.asm"

# 3. classicize the Watcom OMFs so LINK-86 accepts them
python3 "$HERE/omf_classicize.py" "$WORK/APP.OBJ"    "$WORK/APPC.OBJ"    >/dev/null
python3 "$HERE/omf_classicize.py" "$WORK/ADD.OBJ"    "$WORK/ADDC.OBJ"    >/dev/null
python3 "$HERE/omf_classicize.py" "$WORK/WMARKS.OBJ" "$WORK/WMARKSC.OBJ" >/dev/null

# 4. link -> relocatable large-model CMD (CLEARL provides startup + entry)
( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" \
    LINK86.CMD "OUT=APPC,ADDC,WMARKSC,CLEARL.L86" > link.log 2>&1 )
if grep -qiE "target out|no file" "$WORK/link.log"; then
    echo "LINK-86 failed:"; cat "$WORK/link.log"; exit 1
fi
# `clear_error` (8087 emulator path) is expected-undefined and dead for integer code.
[ -f "$WORK/OUT.CMD" ] || { echo "no CMD produced"; cat "$WORK/link.log"; exit 1; }

# 5. run and check
OUTPUT="$( cd "$WORK" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2" OUT.CMD 2>&1 | tr -d '\r\n' )"
echo "emu2 output: [$OUTPUT]"
if [ "$OUTPUT" = "16" ]; then
    echo "PASS: Watcom -> DR C scalar ABI bridge works (add(7,9) == 16)"
    exit 0
else
    echo "FAIL: expected 16, got [$OUTPUT]"; exit 1
fi
