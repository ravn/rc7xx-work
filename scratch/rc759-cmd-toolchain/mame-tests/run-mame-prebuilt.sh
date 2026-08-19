#!/bin/bash
# run-mame-prebuilt.sh -- install a PRE-BUILT Watcom-native CP/M-86 CMD as the
# autostart MENU.CMD on a copy of the turnkey disk, boot the real MAME rc759
# driver, and let the guest signal completion via OUT 0x2FE (done_signal.lua).
# This does NOT rebuild: pass in a CMD already produced by the native Watcom
# path (owcc -bcpm86, see ../USING_OWCC_CPM86.md) directly.
#
# Usage:  ./run-mame-prebuilt.sh /abs/path/to/PROG.CMD
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
CMDPATH="${1:?usage: run-mame-prebuilt.sh /abs/path/to/PROG.CMD}"
CMD="$(basename "$CMDPATH")"
PROG="$(basename "$CMD" .CMD)"

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls

echo "== 1. install $CMD ($(stat -f%z "$CMDPATH") bytes) as autostart MENU.CMD on mandel.img copy =="
IMG="$IMAGES/${PROG}.img"
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"
for f in menu.cmd comal80.cmd diskvedl.cmd help.hlp; do "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true; done
"$CPMCP" -f "$FMT" "$IMG" "$CMDPATH" 0:menu.cmd
"$CPMLS" -f "$FMT" -l "$IMG" | grep -i "menu.cmd" || true

echo "== 2. boot MAME rc759; guest signals completion via OUT 0x2FE (done_signal.lua) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
SDL_VIDEODRIVER=dummy ./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$HERE/done_signal.lua" -seconds_to_run 400 \
  -nothrottle -sound none -video none 2>&1 | tee /tmp/mame_done.log | grep -i "DONE-SIGNAL" || true
# NOTE: -video none is a ~3.5x speedup; pass/fail is the DONE-SIGNAL line
# (OUT 0x2FE io-tap), video-independent. SDL_VIDEODRIVER=dummy is REQUIRED so the
# SDL/Cocoa OSD opens NO window (-video none alone still opens a black fullscreen
# window without -window). Use -video bgfx only for diagnostic snapshots.

echo "== 3. result =="
if grep -qi "DONE-SIGNAL" /tmp/mame_done.log; then
  grep -i "DONE-SIGNAL" /tmp/mame_done.log
  echo "Guest signalled completion."
else
  echo "WARNING: no DONE-SIGNAL -- guest never finished (hang/regression?) within the cap."
fi
ls -la snap/rc759/*.png 2>/dev/null || echo "(no snapshot)"
LAST=$(ls snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "Latest snapshot: $MAME_DIR/snap/rc759/$LAST"
