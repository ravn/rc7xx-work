#!/bin/bash
# measure.sh <benchmark.c> -- compile one benchmark with all four CP/M-86 C
# compilers and print the emitted module code size (bytes). CODE-SIZE only.
#
# Metric = total machine-code bytes of the compiled module, read from each
# toolchain's own dumper (all measure the SAME single source, so the numbers are
# apples-to-apples):
#   Open Watcom : sum of Intel OMF CODE-class segment lengths (omfsize.py).
#   DR C 1.11   : the code-gen pass's own `code: N` report (== OMF CODE length).
#   Aztec 3.40/4.2 : the MAX cumulative "Block start, ends @ NNNN" offset from
#                    obd -- obd lays every function's block end-to-end, so the
#                    last/greatest end offset is the whole module's code size.
#                    (Do NOT sum the per-block ends: they are cumulative.)
#
# The source must be in the K&R/C89 common subset so ONE file drives all four.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="/Users/ravn/z80"
SRC="${1:?usage: measure.sh benchmark.c}"
[ -f "$SRC" ] || SRC="$HERE/$SRC"
NAME="$(basename "${SRC%.c}")"

# Open Watcom leg is driven through the one-step production driver owcc with the
# first-class CP/M-86 target (-bcpm86 => -bt=cpm86). owcc needs WATCOM set to
# locate specs.owc; -c makes it a single compile step yielding an OMF object
# (no link), so the module CODE-size metric stays apples-to-apples with the
# raw-wcc numbers (verified identical: sieve 72/74, aes256 1754).
OWROOT="$ROOT/open-watcom-v2"
OWCC="$OWROOT/rel/armo64/owcc"
export WATCOM="$OWROOT/rel" INCLUDE="$OWROOT/rel/h" PATH="$OWROOT/rel/armo64:$PATH"
CROSS="$ROOT/open-watcom-v2/contrib/ravn/cpm86-crossdev"
EMU2_DRC="$ROOT/scratch/cpm86-tools/emu2-cpm86/emu2"
DRC_OFF="$ROOT/scratch/rc759-cmd-toolchain/rc759-drc-official"
DRC_FB="$ROOT/scratch/rc759-cmd-toolchain/drc86111"

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
omfcode() { python3 "$HERE/omfsize.py" "$1" | awk '/class=CODE/{s+=substr($3,5)} END{print s+0}'; }
azmax() { python3 -c "import sys,re;v=[int(x,16) for x in re.findall(r'ends @ *([0-9a-fA-F]+)',sys.stdin.read())];print(max(v) if v else 0)"; }

echo "=== $NAME -- module code size (bytes), small model unless noted ==="
printf "%-20s %-12s %s\n" "compiler" "opt/model" "code bytes"

# Open Watcom (small model), one-step owcc: -os size, -otexan speed passed
# through with -Wc,. -fpc = software float (calls, no 8087) -- matches RC759
# (no 8087) and the DR C / Aztec default FP model, so float benchmarks are
# apples-to-apples; no effect on integer code.
"$OWCC" -bcpm86 -c -Wc,-ms -Wc,-fpc -Wc,-os     -o "$TMP/w_os.o" "$SRC" >/dev/null 2>&1 && printf "%-20s %-12s %s\n" "Open Watcom" "-os"     "$(omfcode "$TMP/w_os.o")"
"$OWCC" -bcpm86 -c -Wc,-ms -Wc,-fpc -Wc,-otexan -o "$TMP/w_ot.o" "$SRC" >/dev/null 2>&1 && printf "%-20s %-12s %s\n" "Open Watcom" "-otexan" "$(omfcode "$TMP/w_ot.o")"

# Aztec C86 3.40a (K&R) and 4.2 (ANSI), fixed code-gen
export PATH="$CROSS/bin:$PATH"
cp "$SRC" "$TMP/a.c"
( cd "$TMP" && aztec34_cc a.c >/dev/null 2>&1 )
printf "%-20s %-12s %s\n" "Aztec C86 3.40a" "default" "$( ( cd "$TMP" && aztec34_obd a.o ) 2>/dev/null | azmax)"
( cd "$TMP" && rm -f a.o && aztec42_cc a.c >/dev/null 2>&1 )
printf "%-20s %-12s %s\n" "Aztec C86 4.2" "default" "$( ( cd "$TMP" && aztec42_obd a.o ) 2>/dev/null | azmax)"

# Genuine DR C 1.11 via patched emu2-cpm86 (headless); default=small, -b=large
drc() {
    local W; W="$(mktemp -d)"
    for f in DRC.CMD DRC860.CMD DRC861.CMD DRC862.CMD DRCRPP.CMD CPMEOF.ASC STDIO.H CTYPE.H PORTAB.H; do
        if [ -f "$DRC_OFF/$f" ]; then cp "$DRC_OFF/$f" "$W/$f"; elif [ -f "$DRC_FB/$f" ]; then cp "$DRC_FB/$f" "$W/$f"; fi
    done
    # DR C 1.11 lacks the `unsigned char` type (Error 13), but its plain `char`
    # is UNSIGNED by default (verified: 0x80 rotate -> 1, not 255). So map the
    # canonical `unsigned char` typedef to `char` -- identical 8-bit-unsigned
    # semantics on DR C, no algorithm change. Harmless to sources without it.
    sed 's/unsigned char/char/g' "$SRC" > "$W/srcfile.c"; cat "$W/CPMEOF.ASC" >> "$W/srcfile.c" 2>/dev/null
    ( cd "$W" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2_DRC" DRC.CMD "srcfile $1" ) 2>/dev/null \
        | awk -F'code:' '/code:/{split($2,a," ");print a[1];exit}'
    rm -rf "$W"
}
printf "%-20s %-12s %s\n" "DR C 1.11" "small"     "$(drc '')"
printf "%-20s %-12s %s\n" "DR C 1.11" "large (-b)" "$(drc '-b')"

echo
echo "Only Open Watcom has size/speed opt levels; DR C and Aztec emit fixed code-gen."
