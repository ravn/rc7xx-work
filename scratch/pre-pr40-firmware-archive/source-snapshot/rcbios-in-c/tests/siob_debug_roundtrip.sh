#!/bin/bash
# Bidirectional test: MAME SIO-B debug console accepts DIR command and replies.
set -u
cd "$(dirname "$0")/.."
HERE="$(pwd)"

MAME_DIR="${MAME_DIR:-$HOME/git/mame}"
MAME_BIN="$MAME_DIR/regnecentralend"
FLOPTOOL="$MAME_DIR/floptool"
IMG_MAXI="${IMG_MAXI:-$HOME/Downloads/SW1711-I8.imd}"
PATCH="python3 ../rcbios/patch_bios.py"
PORT=4023

WORK=/tmp/siob_rt
rm -rf "$WORK"; mkdir -p "$WORK"
cp "$IMG_MAXI" "$WORK/disk.imd"
$PATCH "$WORK/disk.imd" clang/bios.cim >/dev/null
$FLOPTOOL flopconvert auto mfi "$WORK/disk.imd" "$WORK/disk.mfi" >/dev/null 2>&1

python3 -u tests/siob_debug_roundtrip.py $PORT > "$WORK/bridge.log" 2>&1 &
BR=$!
sleep 0.4

"$MAME_BIN" rc702 -rompath "$MAME_DIR/roms" \
    -flop1 "$WORK/disk.mfi" \
    -rs232b null_modem \
    -bitb2 "socket.127.0.0.1:$PORT" \
    -skip_gameinfo -window -resolution 1100x720 \
    -autoboot_script "$HERE/mame_enable_siob_debug.lua" \
    > "$WORK/mame.log" 2>&1 &
MAME=$!

# Wait for bridge to finish (it self-terminates after 15s), then close MAME.
wait $BR
EXIT=$?
kill $MAME 2>/dev/null
wait $MAME 2>/dev/null

echo
echo "=== Bridge log ==="
cat "$WORK/bridge.log"
exit $EXIT
