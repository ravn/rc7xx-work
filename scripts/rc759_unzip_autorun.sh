#!/bin/bash
# rc759_unzip_autorun.sh -- headlessly run the compact-model UnZip on the real
# MAME rc759 CCP/M-86 oracle (the truth witness) and capture the result from a
# screen snapshot.  Counterpart to rc759_zip_autorun.sh.
#
# The turnkey mandel.img autostarts 0:menu.cmd on boot.  We install the
# CPM86_AUTORUN UNZIP.CMD as menu.cmd; built -DCPM86_AUTORUN it self-invokes
# `unzip -t BIG.ZIP` -- which inflates the whole >=32 KB DEFLATE stream through
# the compact-model far-heap 32 KB slide window (the exact path the compact
# UNZIP must prove on real CCP/M) and prints "No errors detected ...".
# Build the variant first:
#   cd infozip-cpm86-builds && \
#     OUT="$PWD/out-cpm86-autorun" EXTRA_DEFS="-DCPM86_AUTORUN" bash build-cpm86.sh
# NEVER search outside /Users/ravn/z80/.
set -e

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
UNZIP_CMD=/Users/ravn/z80/infozip-cpm86-builds/out-cpm86-autorun/UNZIP.CMD
BIGZIP=/Users/ravn/z80/scratch/rc759-unzip-demo/BIG.ZIP
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls
SECS="${SECS:-400}"   # rc759 CCP/M boots ~290 emulated s; menu.cmd runs ~t175-290
IMG="$IMAGES/uzdrv.img"

[ -f "$UNZIP_CMD" ] || { echo "missing $UNZIP_CMD (build with EXTRA_DEFS=-DCPM86_AUTORUN)"; exit 1; }
[ -f "$BIGZIP" ]    || { echo "missing $BIGZIP"; exit 1; }

echo "== 1. author A: image (turnkey + UNZIP as menu.cmd + BIG.ZIP) =="
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"                          # cpmtools reads ./diskdefs from CWD
# Strip every optional app the boot+autorun does not need (UNZIP.CMD is ~100 KB).
"$CPMRM" -f "$FMT" "$IMG" "0:*.cmd" 2>/dev/null || true
"$CPMRM" -f "$FMT" "$IMG" "0:*.mdf" 2>/dev/null || true
"$CPMRM" -f "$FMT" "$IMG" "0:*.sub" 2>/dev/null || true
for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
         function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
         gencmd.cmd help.hlp mandel.cmd mandeldr.cmd whet.cmd disktest.cmd \
         poem.zip poem.txt big.zip big.txt gkonfig.cmd graphics.cmd help.cmd \
         imenu.mdf instal.cmd konfig.cmd lanrel.cmd menu.mdf menuvedl.cmd \
         okonfig.cmd pip.cmd print.cmd ren.cmd reserver.cmd sdir.cmd set.cmd \
         show.cmd siorel.cmd submit.cmd systat.cmd sysvedl.cmd type.cmd \
         vcmode.cmd vindue.cmd; do
    "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
done
DEMO=/Users/ravn/z80/scratch/rc759-unzip-demo
"$CPMCP" -f "$FMT" "$IMG" "$UNZIP_CMD"    0:menu.cmd
"$CPMCP" -f "$FMT" "$IMG" "$DEMO/HELLO.ZIP" 0:hello.zip
"$CPMCP" -f "$FMT" "$IMG" "$DEMO/POEM.ZIP"  0:poem.zip
"$CPMCP" -f "$FMT" "$IMG" "$BIGZIP"       0:big.zip
"$CPMLS" -f "$FMT" -l "$IMG" | grep -iE "menu.cmd|big.zip" || { echo "install failed (disk full?)"; exit 1; }

echo "== 2. boot MAME rc759 headless (autostart menu.cmd -> unzip -t BIG.ZIP) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
SNAP_LUA=/Users/ravn/z80/scratch/rc759_unzip_snap.lua   # periodic snapshots across the ~290s boot
SDL_VIDEODRIVER=dummy ./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$SNAP_LUA" \
  -seconds_to_run "$SECS" \
  -nothrottle -sound none -video none -window 2>&1 \
  | tail -5 || true

echo "== 3. snapshots (read for 'No errors detected in compressed data') =="
ls -t "$MAME_DIR"/snap/rc759/*.png 2>/dev/null | head -5
LAST=$(ls -t "$MAME_DIR"/snap/rc759/*.png 2>/dev/null | head -1)
[ -n "$LAST" ] && echo "newest snapshot: $LAST"
