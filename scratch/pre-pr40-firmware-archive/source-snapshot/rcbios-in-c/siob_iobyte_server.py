#!/usr/bin/env python3
"""TCP server for SIO-B IOBYTE routing tests in MAME.

Mirrors sysgen_serial_server.py but targets SIO-B.  MAME connects via:
    -bitb2 "socket.localhost:4323"

Used by `make siob-iobyte-test` to verify that bios_reader_body's
IOB_BAT arm correctly routes RDR: to the SIO-B ring buffer.

Flow:
    1. Listen on 127.0.0.1:PORT (default 4323).
    2. Accept MAME's incoming connection.
    3. Wait for the Lua autoboot script to create /tmp/siob_iobyte_trigger
       (written once `PIP CON:=RDR:[E]` is running and ready to consume).
    4. Send the payload file slowly enough for the SIO-B ring buffer
       (256 bytes, no RTS flow control in the current BIOS).
    5. Send Ctrl-Z to terminate PIP's read.
    6. Keep the socket open briefly so the emulated UART can drain.

Usage:
    python3 siob_iobyte_server.py <payload-file> [port]
"""

import os
import socket
import sys
import time


def main() -> int:
    if len(sys.argv) < 2:
        print(f"usage: {sys.argv[0]} <payload-file> [port]", file=sys.stderr)
        return 1

    payload_path = sys.argv[1]
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 4323

    data = open(payload_path, "rb").read()
    print(f"[siob] serving {len(data)} bytes from {payload_path} on port {port}")

    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(("127.0.0.1", port))
    srv.listen(1)
    print("[siob] waiting for MAME connection ...")

    conn, addr = srv.accept()
    conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    print(f"[siob] MAME connected from {addr}")

    trigger = "/tmp/siob_iobyte_trigger"
    print(f"[siob] waiting for Lua trigger {trigger} ...")
    for _ in range(600):
        try:
            if open(trigger).read().strip() == "go":
                break
        except FileNotFoundError:
            pass
        time.sleep(0.5)
    else:
        print("[siob] ERROR: trigger timeout", file=sys.stderr)
        conn.close()
        srv.close()
        return 2
    os.unlink(trigger)
    print("[siob] trigger received, sending payload ...")

    # Pace the send: SIO-B ring buffer is 256 bytes, no RTS throttling.
    # At 38400 8N1 the wire carries ~3.8 KB/s, so 32-byte chunks every
    # 10 ms (3.2 KB/s) keeps the ring well below capacity.
    chunk = 32
    for i in range(0, len(data), chunk):
        conn.sendall(data[i:i + chunk])
        time.sleep(0.01)

    # Ctrl-Z terminates PIP CON:=RDR:[E]
    conn.sendall(b"\x1a")
    print(f"[siob] sent {len(data)} bytes + ^Z")

    # Keep the socket open until MAME disconnects (exits).
    # Closing early causes a broken pipe that crashes MAME.
    print("[siob] payload sent, waiting for MAME to disconnect ...")
    try:
        while True:
            d = conn.recv(1024)
            if not d:
                break
    except (ConnectionResetError, BrokenPipeError):
        pass
    conn.close()
    srv.close()
    print("[siob] done")
    return 0


if __name__ == "__main__":
    sys.exit(main())
