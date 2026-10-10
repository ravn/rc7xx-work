#!/usr/bin/env python3
"""Recover SIO-A after a broken SIOASDLC.COM run, using DDT over the
SIO-B console.  Enters a tiny fix-up program at 0x0100 via DDT's S
command and executes it with G100.

The fix program is 18 bytes:
  DI; WR5 = 0x68; WR10 = 0x00; EI; RST 0
That restores SIO-A's TX/RTS and clears NRZI encoding, then warm-boots.
"""
import serial
import sys
import time

PORT = "/dev/ttyUSB1"
BAUD = 38400

BYTES = bytes.fromhex("F3 3E 05 D3 0A 3E 68 D3 0A 3E 0A D3 0A 3E 00 D3 0A FB C7".replace(" ", ""))
assert len(BYTES) == 19


def read_until(s, markers, timeout=5):
    if isinstance(markers, str):
        markers = [markers]
    buf = ""
    deadline = time.time() + timeout
    while time.time() < deadline:
        c = s.read(s.in_waiting or 1)
        if c:
            txt = c.decode("ascii", errors="replace")
            sys.stdout.write(txt); sys.stdout.flush()
            buf += txt
            if any(m in buf for m in markers):
                return buf
        time.sleep(0.02)
    return buf


def main() -> int:
    s = serial.Serial(PORT, BAUD, timeout=2, rtscts=True)
    s.dtr = True
    time.sleep(0.1)
    s.reset_input_buffer()

    # Wake up CCP.
    s.write(b"\r")
    read_until(s, "A>", 5)

    # Launch DDT.
    s.write(b"DDT\r")
    s.flush()
    read_until(s, "-", 10)   # DDT prompt

    # Start Set-memory at 0x0100.
    s.write(b"S100\r")
    s.flush()
    # DDT prints "0100 XX " then waits for input.
    time.sleep(0.2)

    for i, b in enumerate(BYTES):
        # DDT has already printed the address + current byte + space.
        # Give it a moment to settle, then send new value + CR.
        read_until(s, " ", 2)
        s.write(f"{b:02X}\r".encode())
        s.flush()
        time.sleep(0.05)

    # Exit S command.
    read_until(s, " ", 2)
    s.write(b".\r")
    s.flush()
    read_until(s, "-", 5)

    # Execute the fix.  It ends with RST 0 which warm-boots back to A>.
    s.write(b"G100\r")
    s.flush()
    read_until(s, "A>", 10)

    print("\n*** SIO-A restored ***")
    s.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
