#!/bin/sh
# rc759_make_mandel_b.sh -- author the RC759 B: disk holding BOTH mandelbrot
# builds, entirely from source in git:
#
#   MANDEL.CMD    Open Watcom build, via `owcc -bcpm86` (contrib/ravn/cpm86-clib)
#   MANDELDR.CMD  Digital Research C build (contrib/ravn/owc-drc/MANDEL-DRC.CMD)
#
# Both render byte-identical console output (the deterministic cross-compiler
# mandel oracle) -- run them on the RC759 as `b:mandel` and `b:mandeldr`.
#
# Output: mame/rc759_sw/B_mandel.mfi (rc759 5.25"-HD geometry), which
# scripts/rc759_boot_cpm.sh mounts as B: by default.
set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
OW="$WORKSPACE/open-watcom-v2"
DISKDIR="$WORKSPACE/mame/rc759_sw"
FLOPTOOL="${FLOPTOOL:-$WORKSPACE/mame/floptool}"
# cpmtools reads ./diskdefs from the CWD; the verified rc759 def lives here.
DISKDEFS="$WORKSPACE/scratch/rc759-cmd-toolchain/diskdefs"
MKFS="${MKFS:-$(command -v mkfs.cpm || echo "$HOME/.local/bin/mkfs.cpm")}"
CPMCP="${CPMCP:-$(command -v cpmcp || echo "$HOME/.local/bin/cpmcp")}"
CPMLS="${CPMLS:-$(command -v cpmls || echo "$HOME/.local/bin/cpmls")}"
RC759_BYTES=1261568

mkdir -p "$DISKDIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp "$DISKDEFS" "$STAGE/diskdefs"

echo "==> ensure owcc -bcpm86 runtime is built (lib286/cpm86)"
if [ ! -f "$OW/lib286/cpm86/clibs.lib" ] || [ ! -f "$OW/lib286/cpm86/cstartcpm.obj" ]; then
    sh "$OW/contrib/ravn/cpm86-clib/build.sh" >/dev/null
fi

echo "==> build Watcom mandel -> MANDEL.CMD"
# shellcheck disable=SC1091
. "$OW/contrib/ravn/cpm86-clib/env.sh" >/dev/null 2>&1
# RC759 target: -march=i186 (80186, the Piccoline CPU).  The former wcc ICE 97
# at -O1+ on mandel.c's ternary/string-index line was a stale incremental binary,
# not a stock bug -- gone after a clean rebuild (2026-08-16) -- so build -O2.
owcc -bcpm86 -march=i186 -mcmodel=s -O2 "$OW/contrib/ravn/owc-drc/mandel.c" -o "$STAGE/MANDEL.CMD"

echo "==> take DR C mandel -> MANDELDR.CMD"
cp "$OW/contrib/ravn/owc-drc/MANDEL-DRC.CMD" "$STAGE/MANDELDR.CMD"

echo "==> author blank rc759 CP/M-86 image + copy both"
cd "$STAGE"
"$MKFS" -f rc759-drc B_mandel.img
"$CPMCP" -f rc759-drc B_mandel.img MANDEL.CMD   0:mandel.cmd
"$CPMCP" -f rc759-drc B_mandel.img MANDELDR.CMD 0:mandeldr.cmd
# pad to full rc759 geometry with the CP/M empty byte so floptool lays all tracks
cur=$(stat -f %z B_mandel.img 2>/dev/null || stat -c %s B_mandel.img)
perl -e 'print "\xE5" x ('"$RC759_BYTES"'-'"$cur"')' >> B_mandel.img

echo "==> round-trip integrity check"
"$CPMCP" -f rc759-drc B_mandel.img 0:mandel.cmd   rt1.cmd
"$CPMCP" -f rc759-drc B_mandel.img 0:mandeldr.cmd rt2.cmd
cmp MANDEL.CMD rt1.cmd
cmp MANDELDR.CMD rt2.cmd
echo "    both files verified byte-identical after write/read"
"$CPMLS" -f rc759-drc B_mandel.img

echo "==> convert to MAME mfi"
"$FLOPTOOL" flopconvert rc759 mfi B_mandel.img "$DISKDIR/B_mandel.mfi" >/dev/null
ls -l "$DISKDIR/B_mandel.mfi"
echo "DONE.  Boot with:  sh scripts/rc759_boot_cpm.sh   (B: = B_mandel.mfi)"
echo "Then at the CP/M prompt:  b:mandel   or   b:mandeldr"
