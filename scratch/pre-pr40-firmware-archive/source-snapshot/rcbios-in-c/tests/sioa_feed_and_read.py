#!/usr/bin/env python3
"""TCP bridge for SIO-A RX + bidirectional tests.

Listens on a port for MAME (-bitb1 client). After an optional startup delay,
sends N configured bytes (one per short gap), then logs anything received
back from CP/M for a configured duration. Prints a summary.

Env vars:
  SIOA_FEED_BYTES   Hex string of bytes to send (default: 41..54 = 'A'..'T')
  SIOA_FEED_DELAY_SECS   Seconds to wait after accept before sending (default 4)
  SIOA_FEED_INTERCHAR_MS Milliseconds between sent bytes (default 30)
  SIOA_FEED_LISTEN_SECS  Total time to read replies after last send (default 8)
"""
import os, sys, socket, select, time

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 4001
BYTES = bytes.fromhex(os.environ.get("SIOA_FEED_BYTES",
    "4142434445464748494a4b4c4d4e4f5051525354"))
DELAY_BEFORE_SEND = float(os.environ.get("SIOA_FEED_DELAY_SECS", "4.0"))
SYNC_BYTE = os.environ.get("SIOA_FEED_SYNC_BYTE")  # hex string like "A5" or unset
SYNC_TIMEOUT = float(os.environ.get("SIOA_FEED_SYNC_TIMEOUT", "20.0"))
INTERCHAR_MS = int(os.environ.get("SIOA_FEED_INTERCHAR_MS", "30"))
LISTEN_SECS = float(os.environ.get("SIOA_FEED_LISTEN_SECS", "8.0"))

srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
srv.bind(("127.0.0.1", PORT))
srv.listen(1)
srv.settimeout(60)
print(f"[feed] listen :{PORT}", flush=True)

try:
    conn, addr = srv.accept()
except socket.timeout:
    print("[feed] no MAME connection in 60s"); sys.exit(2)
conn.setblocking(False)
print(f"[feed] connected {addr}", flush=True)

received = bytearray()
start = time.time()
to_send_idx = 0
sent_done_at = None

# Optional handshake: wait for a specific sync byte in the RX stream
# (sent by the CP/M echo program once it's in its CONIN loop) before
# starting to send test data.  Avoids losing leading bytes to whatever
# code ran between program-load and CONIN-loop-entry.
if SYNC_BYTE:
    sync_val = int(SYNC_BYTE, 16)
    print(f"[feed] waiting up to {SYNC_TIMEOUT}s for sync 0x{sync_val:02X}", flush=True)
    sync_deadline = time.time() + SYNC_TIMEOUT
    while time.time() < sync_deadline:
        r, _, _ = select.select([conn], [], [], 0.1)
        if r:
            try:
                data = conn.recv(4096)
            except OSError:
                data = None
            if not data:
                print("[feed] EOF during sync wait"); sys.exit(2)
            received.extend(data)
            if sync_val in data:
                # Consume bytes up to and including the sync byte
                idx = received.rfind(bytes([sync_val]))
                print(f"[feed] sync 0x{sync_val:02X} seen at position {idx+1}", flush=True)
                # Keep pre-sync bytes in 'received' for logging but don't
                # treat them as echoed data.
                received = bytearray()
                break
    else:
        print(f"[feed] sync 0x{sync_val:02X} timeout"); sys.exit(2)
else:
    print(f"[feed] sleeping {DELAY_BEFORE_SEND}s before sending", flush=True)

if SYNC_BYTE:
    start = time.time() - DELAY_BEFORE_SEND  # bypass pre-send delay

while True:
    now = time.time()
    if sent_done_at is None and now - start >= DELAY_BEFORE_SEND:
        # Time to send a byte
        if to_send_idx < len(BYTES):
            try:
                conn.sendall(BYTES[to_send_idx:to_send_idx+1])
            except OSError as e:
                print(f"[feed] send error {e}"); break
            print(f"[feed] sent byte #{to_send_idx+1} 0x{BYTES[to_send_idx]:02X}", flush=True)
            to_send_idx += 1
            # sleep a bit before next byte
            t_next = start + DELAY_BEFORE_SEND + to_send_idx * INTERCHAR_MS / 1000.0
            delay = max(0, t_next - time.time())
        else:
            sent_done_at = now
            print(f"[feed] all {len(BYTES)} bytes sent, listening {LISTEN_SECS}s", flush=True)
            delay = 0.2
    else:
        delay = 0.1

    timeout = min(delay, 0.5)
    r, _, _ = select.select([conn], [], [], timeout)
    if r:
        try:
            data = conn.recv(4096)
        except OSError:
            break
        if not data:
            print("[feed] EOF from MAME"); break
        received.extend(data)
        for b in data:
            c = chr(b) if 32 <= b < 127 else "."
            print(f"[feed] RX #{len(received)}: 0x{b:02X}  {c}", flush=True)

    if sent_done_at is not None and time.time() - sent_done_at >= LISTEN_SECS:
        break

print(f"[feed] total RX bytes: {len(received)}")
print(f"[feed] RX hex: {received.hex()}")
sys.exit(0)
