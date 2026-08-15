#!/bin/bash
# owt-mame.sh -- run one of Open Watcom's OWN float regression tests
# (float01..float04) on the REAL MAME rc759 as an independent no-8087 cross-check.
#
# The floatNN test is built (build-owtests.sh) with OWT_EXTRA=-DMAME_DONE so
# test/owtdrv.c brackets the run with two OUT 0x2FE bus cycles (START 0xB000 /
# END 0xE000, mamedone.h). whet_time.lua reads MAME's emulated clock at each edge,
# stops on END, and snapshots the screen -- which shows the test's own
# "OWTEST: PASS" verdict rendered on real rc759 hardware (i80186 @ 6 MHz, no 8087).
# The tests are self-checking, so a PASS on screen is Watcom's own float suite
# validating our -fpc soft-float path on the metal.
#
# Env: OWT_ONE=float01 (which test); default float01 (most runtime arithmetic).
# NEVER search outside /Users/ravn/z80/.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
LIBC=/Users/ravn/z80/open-watcom-v2/contrib/ravn/watcom-cpm86-libc
BUILDDIR="$LIBC/build-owtests-mame"
ONE="${OWT_ONE:-float01}"
CMD="$BUILDDIR/$ONE.cmd"

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls

if [ "${OWT_SKIP_BUILD:-0}" != "1" ]; then
  echo "== 1. build $ONE.cmd (-DMAME_DONE) =="
  ( cd "$LIBC" && \
    OWT_EXTRA="-DMAME_DONE -i=$HERE" OWT_NORUN=1 OWT_TESTS="$ONE" \
    OUTDIR=build-owtests-mame bash build-owtests.sh >/tmp/owt_build.log 2>&1 )
fi
[ -f "$CMD" ] || { echo "no $ONE.cmd (build failed; see /tmp/owt_build.log)"; tail -20 /tmp/owt_build.log; exit 1; }
SZ=$(stat -f%z "$CMD"); echo "   $ONE.cmd = $SZ bytes"

echo "== 2. install $ONE.cmd as autostart menu.cmd on a copy of mandel.img =="
IMG="$IMAGES/owt.img"
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"                         # cpmtools reads ./diskdefs from CWD
for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
         function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
         gencmd.cmd help.hlp mandel.cmd; do
    "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
done
"$CPMCP" -f "$FMT" "$IMG" "$CMD" 0:menu.cmd
"$CPMLS" -f "$FMT" -l "$IMG" | grep -i "menu.cmd" || { echo "install failed (disk full?)"; exit 1; }

echo "== 3. boot MAME rc759; stop on OWTEST END edge (whet_time.lua) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$HERE/whet_time.lua" -seconds_to_run 300 \
  -nothrottle -sound none -video bgfx -window -nomax 2>&1 \
  | tee /tmp/owt_mame.log | grep -iE "WHET-START|WHET-TIME" || true

echo "== 4. result =="
if grep -qi "WHET-TIME" /tmp/owt_mame.log; then
  grep -iE "WHET-START|WHET-TIME" /tmp/owt_mame.log
  echo "$ONE finished on real MAME rc759 -- screen snapshot shows OWTEST verdict."
else
  echo "WARNING: no END edge within the cap"
  grep -i "WHET-START" /tmp/owt_mame.log || echo "(not even START -- did it autostart?)"
fi
LAST=$(ls snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "Latest snapshot: $MAME_DIR/snap/rc759/$LAST"
