#!/bin/bash
# sdlc_deploy.sh — full-auto SDLC TX experiment on physical RC702.
#
# Flow (single SIO-B console channel, no PIP):
#   1. Build sioa_sdlc_tx.cim.
#   2. Type the bytes into DDT at 0x0100 over SIO-B, verify with D,
#      SAVE as SIOASDLC.COM.
#   3. Start FTDI bit-bang receiver on the interface cabled to SIO-A.
#   4. Send SIOASDLC at A> to trigger the frame transmission.
#   5. Print the decoded capture.
#
# Cable layout on this box:
#   ttyUSB1 ↔ SIO-B (console)   — commands, DDT, trigger
#   ttyUSB0 ↔ SIO-A (data)       — FTDI bit-bang capture (interface A)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

CON_PORT="${RC700_PORT:-/dev/ttyUSB1}"
CAPTURE_IFACE="${SDLC_IFACE:-A}"
BAUD="${RC700_BAUD:-38400}"
CAPTURE_LOG=/tmp/sdlc_capture.log

echo "=== build ==="
../zmac/bin/zmac -z sioa_sdlc_tx.asm >/dev/null

echo
echo "=== DDT deploy SIOASDLC.COM via $CON_PORT (SIO-B) ==="
python3 ddt_deploy.py zout/sioa_sdlc_tx.cim SIOASDLC.COM \
    --port "$CON_PORT" --baud "$BAUD"

echo
echo "=== FTDI C capture on interface $CAPTURE_IFACE (SIO-A), 3 s @ 80 kHz ==="
# Ensure the C binary is built.
cc -O2 -Wall -o sdlc_capture sdlc_capture.c \
    /usr/lib/x86_64-linux-gnu/libftdi1.so.2 2>/dev/null
# 80000 Hz / 10000 baud = exactly 8 samples/bit.  80 kHz is well
# under the FT2232D's sustained-capture ceiling so USB-scheduling
# gap drops should be negligible.
./sdlc_capture -i "$CAPTURE_IFACE" -s 80000 -t 3 /tmp/sdlc_raw.bin \
    2>"$CAPTURE_LOG" &
RECV_PID=$!
sleep 0.5

echo "=== trigger SIOASDLC (via SIO-B console) ==="
python3 - "$CON_PORT" "$BAUD" <<'PYEOF'
import serial, sys, time
port, baud = sys.argv[1], int(sys.argv[2])
s = serial.Serial(port, baud, timeout=2, rtscts=True)
s.dtr = True
time.sleep(0.1)
s.reset_input_buffer()
s.write(b"SIOASDLC\r")
s.flush()
time.sleep(3.0)
out = s.read(s.in_waiting or 1)
if out:
    sys.stdout.write(out.decode("ascii", errors="replace"))
s.close()
PYEOF

wait "$RECV_PID" || true

# Reattach kernel ftdi_sio so ttyUSB* returns for the next run.
python3 /tmp/ftdi_reattach.py >/dev/null 2>&1 || true

echo
echo "=== capture stats ==="
cat "$CAPTURE_LOG"

echo
echo "=== offline decode (80 kHz sample, 10 kbaud line, 8 sps) ==="
python3 sdlc_receiver.py --interface "$CAPTURE_IFACE" \
    --sample-hz 80000 --baudrate-hint 10000 \
    --seconds 0 --decode-only /tmp/sdlc_raw.bin \
    || true
