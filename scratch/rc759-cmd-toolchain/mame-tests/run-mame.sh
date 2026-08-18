#!/bin/bash
# run-mame.sh -- build a self-checking C program, put it on a bootable RC759
# disk as the autostart program, boot it in the real MAME rc759 driver, and
# capture screenshots. The on-screen "RESULT: PASS n/n" line is the oracle
# (view the PNG); emu2/unicorn is NOT used -- it confounds the DR C file path.
#
# Usage:  ./run-mame.sh [mtest.c]
#
# Pipeline:
#   1. cc-cpm86.sh -m l  ->  <PROG>.CMD  (Watcom -> DR C 1.11 bridge, large model)
#   2. cpmtools: copy the pristine turnkey disk (mandel.img), free space, and
#      install <PROG>.CMD as MENU.CMD so startup.0's "menu imenu" autostarts it.
#   3. MAME rc759 (the FDC/DMA-fixed `regnecentralend`, commit 59b21dc1312):
#      delete nvram to force the seeded autoboot, run ~400 emulated seconds
#      (boot alone takes ~290s), snapshot every 500 frames from frame 12500.
#   4. View snap/rc759/000N.png -- the last frame shows the RESULT line at A>.
#
# Prereqs verified present: MAME `regnecentralend` (rebuilt WITH the fix,
# 2026-08-13), roms/rc759, cpmtools on $HOME/.local/bin, the pristine
# ../../rc759-pce/images/mandel.img turnkey disk + its diskdefs (format
# drc-rc759). NEVER search outside /Users/ravn/z80/.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${1:-mtest.c}"
PROG="$(basename "$SRC" .c)"
CMD="$(echo "$PROG" | tr '[:lower:]' '[:upper:]').CMD"

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls

echo "== 1. build $SRC -> $CMD (large model, DR C bridge) =="
cp "$HERE/../drc-libtest/drctest.h" "$HERE/" 2>/dev/null || true
( cd "$HERE" && bash ../cc-cpm86.sh -m l -o "$CMD" "$SRC" )

echo "== 2. install $CMD as autostart MENU.CMD on a copy of mandel.img =="
IMG="$IMAGES/${PROG}.img"
cp "$IMAGES/mandel.img" "$IMG"
# cpmtools reads ./diskdefs from CWD (DISKDEFS env is ignored), so run from $IMAGES.
cd "$IMAGES"
# The turnkey disk is packed (~10K free); free room for the ~55K CMD by removing
# utilities not needed to boot + autorun (comal/diskvedl/help + the old menu).
for f in menu.cmd comal80.cmd diskvedl.cmd help.hlp; do "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true; done
"$CPMCP" -f "$FMT" "$IMG" "$HERE/$CMD" 0:menu.cmd
"$CPMLS" -f "$FMT" -l "$IMG" | grep -i "menu.cmd" || true

echo "== 3. boot MAME rc759; guest signals completion via OUT 0x2FE (done_signal.lua) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
# -seconds_to_run is only a SAFETY CAP now: done_signal.lua calls machine:exit()
# the instant the guest writes port 0x2FE, so a passing run stops early (~150s
# real). If the guest hangs/regresses and never signals, the cap ends it and no
# "DONE-SIGNAL" line is printed -- which the caller can treat as failure.
SDL_VIDEODRIVER=dummy ./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$HERE/done_signal.lua" -seconds_to_run 400 \
  -nothrottle -sound none -video none 2>&1 | tee /tmp/mame_done.log | grep -i "DONE-SIGNAL" || true
# NOTE: -video none is a ~3.5x speedup (full mtest boot+run ~6.5s vs ~24s wall).
# Pass/fail comes from the DONE-SIGNAL line (OUT 0x2FE io-tap), which is
# video-independent, so dropping rendering is zero-fidelity-risk here.
# SDL_VIDEODRIVER=dummy is REQUIRED: -video none alone still makes the SDL/Cocoa
# OSD open a (black, fullscreen without -window) window; the dummy SDL driver
# creates NO window at all -> truly headless. Use -video bgfx -window only when
# you need the diagnostic screen snapshot.

echo "== 4. result =="
if grep -qi "DONE-SIGNAL" /tmp/mame_done.log; then
  grep -i "DONE-SIGNAL" /tmp/mame_done.log
  echo "Guest signalled completion."
else
  echo "WARNING: no DONE-SIGNAL -- guest never finished (hang/regression?) within the cap."
fi
ls -la snap/rc759/*.png 2>/dev/null || echo "(no snapshot)"
LAST=$(ls snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "Latest snapshot (view for the RESULT line): $MAME_DIR/snap/rc759/$LAST"
