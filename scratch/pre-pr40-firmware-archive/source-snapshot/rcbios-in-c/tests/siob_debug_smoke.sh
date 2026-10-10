#!/bin/bash
# siob_debug_smoke.sh -- non-interactive smoke test for SIO-B debug console.
# Boots MAME with DIP S01 set, SIO-B bridged to a TCP capture. Checks that
# the BIOS boot banner (chars "C-bios/clang") appears on SIO-B.
set -u
cd "$(dirname "$0")/.."
HERE="$(pwd)"

MAME_DIR="${MAME_DIR:-$HOME/git/mame}"
MAME_BIN="$MAME_DIR/regnecentralend"
FLOPTOOL="$MAME_DIR/floptool"
IMG_MAXI="${IMG_MAXI:-$HOME/Downloads/SW1711-I8.imd}"
PATCH="python3 ../rcbios/patch_bios.py"
PORT=4023

WORK=/tmp/siob_smoke
rm -rf "$WORK"; mkdir -p "$WORK"

cp "$IMG_MAXI" "$WORK/disk.imd"
$PATCH "$WORK/disk.imd" clang/bios.cim >/dev/null
$FLOPTOOL flopconvert auto mfi "$WORK/disk.imd" "$WORK/disk.mfi" >/dev/null 2>&1

python3 tests/punch_tcp_count.py $PORT > "$WORK/tcp.log" 2>&1 &
TCP=$!
sleep 0.4

"$MAME_BIN" rc702 -rompath "$MAME_DIR/roms" \
    -flop1 "$WORK/disk.mfi" \
    -rs232b null_modem \
    -bitb2 "socket.127.0.0.1:$PORT" \
    -skip_gameinfo -window -resolution 1100x720 \
    -autoboot_script "$HERE/mame_enable_siob_debug.lua" \
    > "$WORK/mame.log" 2>&1 &
MAME=$!

# Let MAME boot; it stays up forever by default, so kill after 12s.
sleep 12
kill $MAME 2>/dev/null
wait $MAME 2>/dev/null
wait $TCP 2>/dev/null

echo "=== TCP log ==="
tail -60 "$WORK/tcp.log"
echo
# Each byte is logged on its own line; match on the hex-encoded form
# of "C-bios" (= 432d62696f73) at the trailer line.
if grep -q '432d62696f73' "$WORK/tcp.log"; then
    echo "=== PASS: SIO-B saw boot banner ==="
    exit 0
else
    echo "=== FAIL: no 'C-bios' in SIO-B stream ==="
    exit 1
fi
