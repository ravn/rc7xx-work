#!/bin/bash
# whet-mame.sh -- run the Watcom-clib Whetstone (whetstone.cmd) on the REAL MAME
# rc759 driver and measure its execution time FROM OUTSIDE.
#
# whetstone.cmd is built by the open-watcom-v2 contrib project (build-whetstone.sh
# with WHET_EXTRA=-DMAME_DONE), which brackets the benchmark with two OUT 0x2FE
# bus cycles (START/END, see mamedone.h). whet_time.lua reads MAME's emulated
# clock (emu.time()) at each edge and reports the elapsed emulated seconds -- the
# execution time on rc759 hardware, not self-timed inside Whetstone.
#
# Pipeline:
#   1. (re)build whetstone.cmd for MAME (unless WHET_SKIP_BUILD=1).
#   2. cpmtools: copy mandel.img, free space, install whetstone.cmd as autostart
#      menu.cmd.
#   3. MAME rc759 (FDC/DMA-fixed regnecentralend): delete nvram to force the
#      seeded autoboot, boot (~290 emulated s), run whet_time.lua which stops on
#      the END edge and prints WHET-TIME.
#   4. Print the elapsed time + point at the snapshot.
#
# NEVER search outside /Users/ravn/z80/.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
LIBC=/Users/ravn/z80/open-watcom-v2/contrib/ravn/watcom-cpm86-libc
BUILDDIR="$LIBC/build-whetstone-mame"
CMD="$BUILDDIR/whetstone.cmd"

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls

if [ "${WHET_SKIP_BUILD:-0}" != "1" ]; then
  echo "== 1. build whetstone.cmd (-DMAME_DONE) =="
  ( cd "$LIBC" && \
    WHET_EXTRA="-DMAME_DONE -i=$HERE" WHET_NORUN=1 OUTDIR=build-whetstone-mame \
    bash build-whetstone.sh >/tmp/whet_build.log 2>&1 )
fi
[ -f "$CMD" ] || { echo "no whetstone.cmd (build failed; see /tmp/whet_build.log)"; exit 1; }
SZ=$(stat -f%z "$CMD"); echo "   whetstone.cmd = $SZ bytes"

echo "== 2. install whetstone.cmd as autostart menu.cmd on a copy of mandel.img =="
IMG="$IMAGES/whet.img"
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"                         # cpmtools reads ./diskdefs from CWD
for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
         function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
         gencmd.cmd help.hlp mandel.cmd; do
    "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
done
"$CPMCP" -f "$FMT" "$IMG" "$CMD" 0:menu.cmd
"$CPMLS" -f "$FMT" -l "$IMG" | grep -i "menu.cmd" || { echo "install failed (disk full?)"; exit 1; }

echo "== 3. boot MAME rc759; stop on Whetstone END edge (whet_time.lua) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$HERE/whet_time.lua" -seconds_to_run 900 \
  -nothrottle -sound none -video bgfx -window -nomax 2>&1 \
  | tee /tmp/whet_mame.log | grep -iE "WHET-START|WHET-TIME" || true

echo "== 4. result =="
if grep -qi "WHET-TIME" /tmp/whet_mame.log; then
  grep -iE "WHET-START|WHET-TIME" /tmp/whet_mame.log
  echo "Whetstone finished on real MAME rc759."
else
  echo "WARNING: no WHET-TIME within the cap -- Whetstone did not signal END"
  grep -i "WHET-START" /tmp/whet_mame.log || echo "(not even START seen -- did it autostart?)"
fi
LAST=$(ls snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "Latest snapshot: $MAME_DIR/snap/rc759/$LAST"
