#!/bin/bash
# rc759_zip_autorun.sh -- headlessly run the KEEP_BADZIP+AUTORUN ZIP.CMD on the
# real MAME rc759 CCP/M-86 oracle, then leave POEM.ZIP on the disk image for
# offline deflate-stream extraction/diff (rc759_zip_stream_diff.sh).
#
# The turnkey mandel.img autostarts 0:menu.cmd on boot. We install ZIP.CMD as
# menu.cmd; built -DCPM86_AUTORUN it self-invokes `zip POEM.ZIP POEM.TXT`, and
# built -DCPM86_KEEP_BADZIP it keeps the archive even on the size-mismatch that
# aborts a stock build. NEVER search outside /Users/ravn/z80/.
set -e

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
ZIP_CMD=/Users/ravn/z80/infozip-cpm86-builds/out-zip-cpm86/ZIP.CMD
POEM=/Users/ravn/z80/scratch/rc759-unzip-demo/poem.txt
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls
SECS="${SECS:-40}"
IMG="$IMAGES/zipdrv.img"

[ -f "$ZIP_CMD" ] || { echo "missing $ZIP_CMD (build with EXTRA_DEFS=-DCPM86_KEEP_BADZIP -DCPM86_AUTORUN)"; exit 1; }

echo "== 1. author A: image (turnkey + ZIP as menu.cmd + POEM.TXT) =="
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"                          # cpmtools reads ./diskdefs from CWD
# Free space: ZIP.CMD is ~196 KB, so strip every optional app the boot+autorun
# does not need (same list as disk-mame.sh, plus mandel).
"$CPMRM" -f "$FMT" "$IMG" "0:*.cmd" 2>/dev/null || true
"$CPMRM" -f "$FMT" "$IMG" "0:*.mdf" 2>/dev/null || true
"$CPMRM" -f "$FMT" "$IMG" "0:*.sub" 2>/dev/null || true
for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
         function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
         gencmd.cmd help.hlp mandel.cmd mandeldr.cmd whet.cmd disktest.cmd \
         poem.zip poem.txt gkonfig.cmd graphics.cmd help.cmd imenu.mdf instal.cmd \
         konfig.cmd lanrel.cmd menu.mdf menuvedl.cmd okonfig.cmd pip.cmd print.cmd \
         ren.cmd reserver.cmd sdir.cmd set.cmd show.cmd siorel.cmd submit.cmd \
         systat.cmd sysvedl.cmd type.cmd vcmode.cmd vindue.cmd; do
    "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
done
"$CPMCP" -f "$FMT" "$IMG" "$ZIP_CMD" 0:menu.cmd
"$CPMCP" -f "$FMT" "$IMG" "$POEM"    0:poem.txt
"$CPMLS" -f "$FMT" -l "$IMG" | grep -iE "menu.cmd|poem.txt" || { echo "install failed (disk full?)"; exit 1; }

echo "== 2. boot MAME rc759 headless (autostart menu.cmd -> zip POEM.ZIP POEM.TXT) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
SDL_VIDEODRIVER=dummy ./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -seconds_to_run "$SECS" \
  -nothrottle -sound none -video none -window 2>&1 \
  | tail -5 || true

echo "== 3. read back A: directory =="
cd "$IMAGES"
"$CPMLS" -f "$FMT" -l "$IMG" | grep -iE "poem" || echo "(no poem.* on disk -- did it run/writeback?)"
LAST=$(ls "$MAME_DIR"/snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "snapshot: $MAME_DIR/snap/rc759/$LAST"

echo
echo "== 4. extract + diff the CCP/M deflate stream =="
if "$CPMLS" -f "$FMT" "$IMG" | grep -qi "poem.zip"; then
  "$CPMCP" -f "$FMT" "$IMG" 0:poem.zip /tmp/ccpm_poem.zip
  echo "extracted -> /tmp/ccpm_poem.zip ($(stat -f%z /tmp/ccpm_poem.zip) B)"
  REF=/tmp/emu2_deflate.bin OUT=/tmp/ccpm_poem.zip \
    python3 /Users/ravn/z80/scripts/_zip_decode_diff.py /tmp/ccpm_poem.zip /tmp/emu2_deflate.bin
else
  echo "POEM.ZIP not present -- check snapshot for the KEEP_BADZIP line."
fi
