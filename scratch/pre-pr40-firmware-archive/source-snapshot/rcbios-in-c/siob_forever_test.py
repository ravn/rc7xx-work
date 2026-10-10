#!/usr/bin/env python3
"""siob_forever_test.py

End-to-end test of the new non-stack-switching SIO-B RX ISR:

  1. Connect to /dev/ttyUSB0 (SIO-A console, 38400) — expects A> prompt.
  2. Upload siob_forever.bin to FOREVER.COM on the RC700 via DDT S.
  3. Run FOREVER (it prints banner, then loops echoing every SIO-B byte
     as 2 hex digits + space on SIO-A).
  4. Open /dev/ttyUSB1 (SIO-B) and send bytes one at a time, reading the
     corresponding hex echo back from SIO-A.
  5. Report how many bytes were echoed correctly vs lost/mangled.

Machine stays alive throughout — if the new ISR is correct, the banner
displays, each sent byte produces its hex echo, and nothing hangs.
"""

import serial
import sys
import time

CONSOLE = "/dev/ttyUSB0"
SIOB = "/dev/ttyUSB1"
BAUD = 38400
BIN_PATH = "siob_forever.bin"

# How many bytes to push through the test
N_BYTES = 64


def wait_for(con, needle, timeout=5.0):
    """Read from con until needle appears or timeout elapses."""
    deadline = time.monotonic() + timeout
    buf = b""
    while time.monotonic() < deadline:
        chunk = con.read(256)
        if chunk:
            buf += chunk
        if needle in buf:
            return buf
    return buf


def expect_prompt(con, prompt, timeout=5.0):
    buf = wait_for(con, prompt, timeout)
    if prompt not in buf:
        raise RuntimeError(
            f"did not see {prompt!r} within {timeout}s; got: {buf!r}"
        )
    return buf


def upload_via_ddt(con, binary, addr=0x0100):
    # Enter DDT
    con.write(b"DDT\r")
    expect_prompt(con, b"-", timeout=5.0)
    # Start S command at target address
    con.write(f"S{addr:04X}\r".encode())
    # Wait for first address prompt (DDT echoes "ADDR XX ")
    time.sleep(0.3)
    con.read(4096)  # drain
    for i, byte in enumerate(binary):
        con.write(f"{byte:02X}\r".encode())
        con.flush()
        # DDT needs ~40ms between bytes per prior observation
        time.sleep(0.05)
        if (i + 1) % 16 == 0:
            # drain echo so the buffer doesn't overflow on our side
            con.read(4096)
    # Terminate S with '.'
    con.write(b".\r")
    time.sleep(0.2)
    con.read(4096)
    # Exit DDT via G0 (warm boot)
    con.write(b"G0\r")
    expect_prompt(con, b"A>", timeout=5.0)


def main():
    with open(BIN_PATH, "rb") as f:
        binary = f.read()
    print(f"Loaded {len(binary)} bytes from {BIN_PATH}")

    con = serial.Serial(CONSOLE, BAUD, timeout=0.3)
    siob = serial.Serial(SIOB, BAUD, timeout=0.3)

    # Drain anything stale on both ports
    time.sleep(0.2)
    con.read(4096)
    siob.read(4096)

    # Confirm the RC700 is at A>
    con.write(b"\r")
    expect_prompt(con, b"A>", timeout=3.0)
    print("At A> prompt.")

    print("Uploading FOREVER.COM via DDT S...")
    upload_via_ddt(con, binary, addr=0x0100)

    # Save it
    pages = (len(binary) + 255) // 256
    con.write(f"SAVE {pages} FOREVER.COM\r".encode())
    expect_prompt(con, b"A>", timeout=5.0)
    print(f"Saved {pages} page(s) as FOREVER.COM")

    # Run it
    print("Running FOREVER...")
    con.write(b"FOREVER\r")
    banner = wait_for(con, b"reader", timeout=5.0)
    print(f"Banner: {banner!r}")
    if b"reader" not in banner:
        print("FAIL: no banner, aborting")
        return 1

    # Drain anything after the banner
    time.sleep(0.3)
    con.read(4096)

    # Now the main loop: send 1 byte on SIO-B, read back "XX " on SIO-A
    print(f"Sending {N_BYTES} bytes, one at a time...")
    ok = 0
    mismatch = 0
    lost = 0
    for i in range(N_BYTES):
        want = (i + 1) & 0xFF  # skip 0x00
        siob.write(bytes([want]))
        siob.flush()
        # Expect 3 characters: two hex digits + space
        buf = b""
        deadline = time.monotonic() + 1.0
        while len(buf) < 3 and time.monotonic() < deadline:
            buf += con.read(3 - len(buf))
        if len(buf) < 3:
            lost += 1
            print(f"  [{i:3d}] sent {want:02X}  got {buf!r}  LOST")
            continue
        got_hex = buf[:2].decode("ascii", errors="replace")
        try:
            got = int(got_hex, 16)
        except ValueError:
            mismatch += 1
            print(f"  [{i:3d}] sent {want:02X}  got {buf!r}  MANGLED")
            continue
        if got != want:
            mismatch += 1
            print(f"  [{i:3d}] sent {want:02X}  got {got:02X}  MISMATCH")
        else:
            ok += 1

    print()
    print(f"=== Results ===")
    print(f"  Sent:     {N_BYTES}")
    print(f"  OK:       {ok}")
    print(f"  Mismatch: {mismatch}")
    print(f"  Lost:     {lost}")
    print(f"  PASS: {ok == N_BYTES}")

    con.close()
    siob.close()
    return 0 if ok == N_BYTES else 1


if __name__ == "__main__":
    sys.exit(main())
