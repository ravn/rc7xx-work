#!/bin/bash
# disk-mame.sh -- run the Watcom disk FILE* oracle (test/disktest.c) on the REAL
# MAME rc759, the authoritative CP/M-86 oracle (emu2 is only a smoke test, and is
# explicitly NOT authoritative for the LRBC / exact-length semantics -- see the
# libc KNOWN_ISSUES.md). This exercises fopen/fread/fwrite/fseek/ftell/remove
# against real rc759 disk hardware through our thin FCB random-record BDOS seam.
#
# disktest.c is built -DMAME_DONE so it ends by streaming its result record
# (tag 0xD15C, full 16-bit test count, failures, end sentinel 0xE0F0) on the
# undecoded I/O port 0x2FE via mame_out() (mamedone.h). disk_done.lua collects
# the words, snapshots the screen -- where the guest's own "DISKIO: PASS (511
# tests, 0 failures)" line is the human oracle -- and stops the emulator,
# printing a machine-gateable DISK-RESULT: PASS/FAIL.
#
# Prereqs (all inside /Users/ravn/z80): mame/regnecentralend, the rc759 turnkey
# image scratch/rc759-pce/images/mandel.img with drc-rc759 diskdefs, cpmtools,
# and this dir's disk_done.lua + mamedone.h. NEVER search outside /Users/ravn/z80/.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
LIBC=/Users/ravn/z80/open-watcom-v2/contrib/ravn/watcom-cpm86-libc
BUILDDIR="$LIBC/build-diskio-mame"
CMD="$BUILDDIR/disktest.cmd"

MAME_DIR=/Users/ravn/z80/mame
IMAGES=/Users/ravn/z80/scratch/rc759-pce/images
FMT=drc-rc759
CPMCP=$HOME/.local/bin/cpmcp
CPMRM=$HOME/.local/bin/cpmrm
CPMLS=$HOME/.local/bin/cpmls

if [ "${DISK_SKIP_BUILD:-0}" != "1" ]; then
  echo "== 1. build disktest.cmd (-DMAME_DONE) =="
  ( cd "$LIBC" && \
    DISKIO_EXTRA="-DMAME_DONE -i=$HERE" DISKIO_NORUN=1 OUTDIR=build-diskio-mame \
    bash build-diskio.sh >/tmp/disk_build.log 2>&1 )
fi
[ -f "$CMD" ] || { echo "no disktest.cmd (build failed; see /tmp/disk_build.log)"; tail -20 /tmp/disk_build.log; exit 1; }
SZ=$(stat -f%z "$CMD"); echo "   disktest.cmd = $SZ bytes"

echo "== 2. install disktest.cmd as autostart menu.cmd on a copy of mandel.img =="
IMG="$IMAGES/disk.img"
cp "$IMAGES/mandel.img" "$IMG"
cd "$IMAGES"                         # cpmtools reads ./diskdefs from CWD
# The turnkey disk is packed; disktest is ~38 KB, so free space by removing large
# optional apps not needed to boot + autorun (same list owt-mame.sh uses).
for f in menu.cmd comal80.cmd comal80.erm diskvedl.cmd filadm.cmd function.cmd \
         function.sys asm86.cmd ddt86.cmd chset.cmd ed.cmd filex.a86 filex.cmd \
         gencmd.cmd help.hlp mandel.cmd; do
    "$CPMRM" -f "$FMT" "$IMG" "0:$f" 2>/dev/null || true
done
"$CPMCP" -f "$FMT" "$IMG" "$CMD" 0:menu.cmd
"$CPMLS" -f "$FMT" -l "$IMG" | grep -i "menu.cmd" || { echo "install failed (disk full?)"; exit 1; }

echo "== 3. boot MAME rc759; stop on disk-oracle end sentinel (disk_done.lua) =="
cd "$MAME_DIR"
rm -f snap/rc759/*.png nvram/rc759/nvram 2>/dev/null || true
./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms \
  -flop1 "$IMG" \
  -autoboot_script "$HERE/disk_done.lua" -seconds_to_run 300 \
  -nothrottle -sound none -video bgfx -window -nomax 2>&1 \
  | tee /tmp/disk_mame.log | grep -iE "DISK-DONE|DISK-RESULT" || true

echo "== 4. result =="
if grep -qi "DISK-RESULT: PASS" /tmp/disk_mame.log; then
  grep -iE "DISK-DONE|DISK-RESULT" /tmp/disk_mame.log
  echo "Watcom disk FILE* oracle PASSED on real MAME rc759 (screen snapshot shows DISKIO line)."
elif grep -qi "DISK-DONE" /tmp/disk_mame.log; then
  grep -iE "DISK-DONE|DISK-RESULT" /tmp/disk_mame.log
  echo "FAIL: disk oracle reported failures on real MAME rc759."
else
  echo "WARNING: no end sentinel within the cap -- disktest did not complete."
  echo "(Check the snapshot: the guest may have hung, or not autostarted.)"
fi
LAST=$(ls snap/rc759/ 2>/dev/null | tail -1)
[ -n "$LAST" ] && echo "Latest snapshot: $MAME_DIR/snap/rc759/$LAST"
