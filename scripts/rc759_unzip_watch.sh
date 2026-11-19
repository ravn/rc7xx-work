#!/bin/bash
# rc759_unzip_watch.sh -- kør UNZIP-demoén med synligt vindue.
# Bruger den eksisterende uzdrv.img (bygget af rc759_unzip_autorun.sh).
# NOTHROTTLE=1 bash rc759_unzip_watch.sh  for at køre så hurtigt som muligt (~17s reel tid)
# Standard: normal hastighed (~5 min reel tid — floppy er den flaskehals)
set -e
WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
MAME_DIR="$WORKSPACE/mame"
IMG="$WORKSPACE/scratch/rc759-pce/images/uzdrv.img"
SNAP_LUA="$WORKSPACE/scratch/rc759_unzip_snap.lua"
SECS="${SECS:-400}"

[ -f "$IMG" ] || { echo "!! uzdrv.img mangler — kør rc759_unzip_autorun.sh først"; exit 1; }

THROTTLE_FLAG=""
[ "${NOTHROTTLE:-0}" = "1" ] && THROTTLE_FLAG="-nothrottle" && echo "== boost: nothrottle ==" || echo "== normal hastighed =="
rm -f "$MAME_DIR/nvram/rc759/nvram" 2>/dev/null || true
cd "$MAME_DIR"
exec ./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$SNAP_LUA" \
  -seconds_to_run "$SECS" \
  $THROTTLE_FLAG -sound none -window
