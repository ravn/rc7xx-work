#!/usr/bin/env python3
"""Send an Intel HEX file to MAME's null_modem via TCP.

MAME's -bitb "socket.localhost:PORT" CONNECTS to this server.
Server must be started BEFORE MAME.

Flow: listen → accept MAME connection → wait for trigger → send data.

Usage:
    python3 sysgen_serial_server.py <hexfile> [port]
"""

import socket
import sys
import time
import os

def main():
    if len(sys.argv) < 2:
        print(f"usage: {sys.argv[0]} <hexfile> [port]", file=sys.stderr)
        sys.exit(1)

    hexfile = sys.argv[1]
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 4322

    data = open(hexfile, 'rb').read()
    print(f"Serving {hexfile} ({len(data)} bytes) on port {port}")

    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(('127.0.0.1', port))
    srv.listen(1)
    print("Listening for MAME connection...")

    conn, addr = srv.accept()
    conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    print(f"MAME connected from {addr}")

    # Wait for trigger file from Lua script (PIP is ready)
    trigger_file = '/tmp/sysgen_serial_trigger'
    print("Waiting for trigger (PIP ready)...")
    for _ in range(600):
        try:
            if open(trigger_file).read().strip() == 'go':
                break
        except FileNotFoundError:
            pass
        time.sleep(0.5)
    else:
        print("ERROR: trigger timeout")
        conn.close(); srv.close(); sys.exit(1)
    os.unlink(trigger_file)
    print("Trigger received, sending data...")

    # Send file data in small chunks to avoid overflowing the
    # 256-byte BIOS ring buffer. At 38400 baud, 128 bytes takes ~33ms.
    # PIP needs time to process each byte (BDOS calls), so send slowly.
    chunk_size = 32
    sent = 0
    for i in range(0, len(data), chunk_size):
        chunk = data[i:i + chunk_size]
        conn.sendall(chunk)
        sent += len(chunk)
        # At 38400 baud 8N1, one byte = 10 bits = 0.26ms
        # Send at wire speed — the null_modem serializes at emulated baud rate
        # No sleep needed when MAME runs at real time (no -nothrottle)
        time.sleep(0.001)
    # Send ^Z separately (CP/M PIP EOF)
    conn.sendall(b'\x1a')
    sent += 1
    print(f"Sent {sent} bytes (+ ^Z)")

    # Keep connection alive to let emulated serial drain
    time.sleep(30)
    conn.close()
    srv.close()
    print("Done")


if __name__ == '__main__':
    main()
