#!/bin/bash
# measure-sieve.sh -- compile sieve.c with all four CP/M-86 C compilers and
# report the emitted machine-code byte count of the sieve() function.
#
# CODE-SIZE only (compilation, no link/run). Uniform metric = "bytes of machine
# code the compiler emitted for sieve()", read from each toolchain's own dumper:
#   Watcom / DR C : Intel OMF CODE-class segment length (omfsize.py); DR C also
#                   self-reports `code: N`.
#   Aztec 3.40/4.2: Manx object "Block start, ends @ NNNN" function extent (obd).
#
# Run from this directory. Paths are workspace-relative (macbook layout).
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="/Users/ravn/z80"
SRC="$HERE/sieve.c"

WCC="$ROOT/open-watcom-v2/rel/armo64/wcc"
CROSS="$ROOT/open-watcom-v2/contrib/ravn/cpm86-crossdev"
EMU2_DRC="$ROOT/scratch/cpm86-tools/emu2-cpm86/emu2"
DRC_OFF="$ROOT/scratch/rc759-cmd-toolchain/rc759-drc-official"
DRC_FB="$ROOT/scratch/rc759-cmd-toolchain/drc86111"

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
azend() { python3 -c "import sys;print(int(sys.argv[1],16))" "$1"; }

echo "=== Byte sieve -- sieve() code size (bytes), small memory model ==="
printf "%-22s %-10s %s\n" "compiler" "opt" "code bytes"

# --- Open Watcom (small model) ---
"$WCC" "$SRC" -ms -os     -fo="$TMP/w_os.o" >/dev/null 2>&1
"$WCC" "$SRC" -ms -otexan -fo="$TMP/w_ot.o" >/dev/null 2>&1
wos=$(python3 "$HERE/omfsize.py" "$TMP/w_os.o" | awk '/class=CODE/{print $3}' | sed 's/len=//')
wot=$(python3 "$HERE/omfsize.py" "$TMP/w_ot.o" | awk '/class=CODE/{print $3}' | sed 's/len=//')
printf "%-22s %-10s %s\n" "Open Watcom" "-os"     "$wos"
printf "%-22s %-10s %s\n" "Open Watcom" "-otexan" "$wot"

# --- Aztec C86 3.40a (K&R) and 4.2 (ANSI), default codegen ---
export PATH="$CROSS/bin:$PATH"
cp "$SRC" "$TMP/s.c"
( cd "$TMP" && aztec34_cc s.c >/dev/null 2>&1 )
a34=$( ( cd "$TMP" && aztec34_obd s.o ) 2>/dev/null | awk -F'@ ' '/ends @/{print $2; exit}')
( cd "$TMP" && rm -f s.o && aztec42_cc s.c >/dev/null 2>&1 )
a42=$( ( cd "$TMP" && aztec42_obd s.o ) 2>/dev/null | awk -F'@ ' '/ends @/{print $2; exit}')
printf "%-22s %-10s %s\n" "Aztec C86 3.40a" "default" "$(azend ${a34:-0})"
printf "%-22s %-10s %s\n" "Aztec C86 4.2"   "default" "$(azend ${a42:-0})"

# --- Genuine DR C 1.11 via patched emu2-cpm86 (headless) ---
drc_compile() { # $1 = extra flags (e.g. -b); echoes code bytes
    local W; W="$(mktemp -d)"
    for f in DRC.CMD DRC860.CMD DRC861.CMD DRC862.CMD DRCRPP.CMD CPMEOF.ASC STDIO.H CTYPE.H PORTAB.H; do
        if [ -f "$DRC_OFF/$f" ]; then cp "$DRC_OFF/$f" "$W/$f"
        elif [ -f "$DRC_FB/$f" ]; then cp "$DRC_FB/$f" "$W/$f"; fi
    done
    cp "$SRC" "$W/srcfile.c"; cat "$W/CPMEOF.ASC" >> "$W/srcfile.c" 2>/dev/null
    ( cd "$W" && EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A "$EMU2_DRC" DRC.CMD "srcfile $1" ) 2>/dev/null \
        | awk -F'code:' '/code:/{split($2,a," ");print a[1];exit}'
    rm -rf "$W"
}
dsm=$(drc_compile "")     # default = small model
dlg=$(drc_compile "-b")   # -b = large model
printf "%-22s %-10s %s\n" "DR C 1.11" "small"        "${dsm:-?}"
printf "%-22s %-10s %s\n" "DR C 1.11" "large (-b)"   "${dlg:-?}"

echo
echo "Note: DR C 1.11 has no optimizer switch; Aztec optimizer (sqz) not yet wired."
