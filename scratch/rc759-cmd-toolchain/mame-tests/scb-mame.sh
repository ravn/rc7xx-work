#!/bin/bash
# scb-mame.sh -- build stdcbench (SCB.CMD) for the DR C CP/M-86 target and run it
# in the REAL MAME rc759 driver, where the genuine PICCOLINE XIOS Int 28h "16 ms
# counter" drives stdcbench's self-timing (the Unicorn runner had to fake that
# clock; emu2 cannot provide it at all). The benchmark prints its score to the
# screen and, built with -DMAME_DONE, signals completion via OUT 0x2FE so the
# host stops the emulator and reads the final score without OCR.
#
# Usage:  ./scb-mame.sh [s|l]        (default s; l is the known-broken large model)
#
# Pipeline:
#   1. stdcbench-cpm86.sh -m <model>  (SCB_EXTRA=-DMAME_DONE, SCB_NORUN=1)
#      -> SCB-<model>.CMD  (~76 KB, integer c90base + c90lib)
#   2. cpmtools: copy mandel.img, free ~300 KB by removing large optional
#      utilities (the turnkey disk is packed), install SCB as autostart menu.cmd.
#   3. MAME rc759 (FDC/DMA-fixed regnecentralend): delete nvram to force the
#      seeded autoboot, boot (~290 emulated s), run scb_mame.lua which stops on
#      the done-signal (and snapshots every 500 frames as a hang breadcrumb).
#   4. Print the score from the DONE-SIGNAL line + point at the snapshot.
#
# NEVER search outside /Users/ravn/z80/.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
TC="$HERE/.."                       # scratch/rc759-cmd-toolchain
MODEL="${1:-s}"
CMD="SCB-$MODEL.CMD"

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls

echo "== 1. build stdcbench ($MODEL model) with -DMAME_DONE =="
( cd "$TC" && SCB_EXTRA="-DMAME_DONE" SCB_NORUN=1 bash stdcbench-cpm86.sh -m "$MODEL" )
[ -f "$TC/$CMD" ] || { echo "build did not produce $CMD"; exit 1; }
SZ=$(stat -f%z "$TC/$CMD"); echo "   $CMD = $SZ bytes"

echo "== 2. install $CMD as autostart menu.cmd on a copy of mandel.img =="
IMG="$IMAGES/scb.img"
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"                         # cpmtools reads ./diskdefs from CWD
# The turnkey disk is packed (~10 KB free). SCB.CMD is ~76 KB, so free plenty by
# removing large optional apps/tools not needed to boot+autorun. Keep ccpm.sys,
# the dd759*.sys drivers, dir/era/date, startup.0.
for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
         function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
         gencmd.cmd help.hlp mandel.cmd; do
    "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
done
"$CPMCP" -f "$FMT" "$IMG" "$TC/$CMD" 0:menu.cmd
"$CPMLS" -f "$FMT" -l "$IMG" | grep -i "menu.cmd" || { echo "install failed (disk full?)"; exit 1; }

echo "== 3. boot MAME rc759; stop on stdcbench done-signal (scb_mame.lua) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
# Cap covers boot (~290 emulated s) + the benchmark (c90base + c90lib each run
# until ~8 s elapsed). If the disk XIOS lacks Int 28h fn 19, stdcbench spins and
# never signals -> the cap ends it and the diagnostic snapshots show the state.
./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$HERE/scb_mame.lua" -seconds_to_run 600 \
  -nothrottle -sound none -video bgfx -window -nomax 2>&1 \
  | tee /tmp/scb_mame.log | grep -i "DONE-SIGNAL" || true

echo "== 4. result =="
if grep -qi "DONE-SIGNAL" /tmp/scb_mame.log; then
  grep -i "DONE-SIGNAL" /tmp/scb_mame.log
  echo "stdcbench finished on real MAME rc759."
else
  echo "WARNING: no DONE-SIGNAL within the cap -- stdcbench did not complete"
  echo "(likely the disk XIOS lacks Int 28h fn 19, so the timed loop spins)."
fi
LAST=$(ls snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "Latest snapshot (view for the score line): $MAME_DIR/snap/rc759/$LAST"
