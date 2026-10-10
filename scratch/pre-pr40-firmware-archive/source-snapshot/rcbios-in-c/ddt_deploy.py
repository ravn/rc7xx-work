#!/usr/bin/env python3
"""ddt_deploy.py — upload a .cim (or any raw 0x100-origined binary)
to the RC702 by typing its bytes into DDT over the SIO-B console,
verify with DDT's D (dump) command, then SAVE it as a .COM file and
leave CP/M at the A> prompt ready to run.

Replaces the PIP+MLOAD path entirely (user directive 2026-04-18):
single-channel over the console, no SIO-A involvement, no stale
ring-buffer bytes, per-byte echo as inherent verification.

DDT commands used (per CP/M User's Guide §4.2.6):
  DDT          — launch (at A>)
  Snnnn        — set memory starting at nnnn; per-byte prompts
  .            — end S mode
  Dnnnn,mmmm   — dump hex + ASCII from nnnn to mmmm
  G0           — Go to address 0 = warm boot back to CCP (preserves
                 TPA so SAVE can pick up the bytes we typed)
CCP command:
  SAVE n ufn   — write n×256-byte pages from 0x0100 to ufn

Usage:
  ddt_deploy.py PATH.cim TARGET.COM [--port /dev/ttyUSB1] [--run]
"""
from __future__ import annotations

import argparse
import re
import serial
import sys
import time
from pathlib import Path


def read_until(s: serial.Serial, markers, timeout: float = 5.0) -> str:
    if isinstance(markers, str):
        markers = [markers]
    buf = ""
    deadline = time.time() + timeout
    while time.time() < deadline:
        chunk = s.read(s.in_waiting or 1)
        if chunk:
            text = chunk.decode("ascii", errors="replace")
            sys.stdout.write(text)
            sys.stdout.flush()
            buf += text
            if any(m in buf for m in markers):
                return buf
        time.sleep(0.02)
    return buf


def send(s: serial.Serial, text: bytes | str) -> None:
    if isinstance(text, str):
        text = text.encode("ascii")
    s.write(text)
    s.flush()


def enter_bytes_via_ddt(s: serial.Serial, addr: int, data: bytes) -> None:
    """Feed bytes into DDT's S command starting at addr.  Each byte
    prompt looks like:   0100 F3 <new-value>

    DDT echoes whatever we type plus a newline then shows the next
    prompt.  We look for the address of the *next* prompt as our
    sync point, which is tolerant of timing skew.
    """
    send(s, f"S{addr:04X}\r")
    # The first prompt is what we just asked for; read up to it.
    next_addr = addr
    # Read the first prompt line.
    read_until(s, f"{next_addr:04X}", timeout=5)
    # After DDT prints "xxxx YY ", it waits for our input.
    for i, b in enumerate(data):
        # Wait for the space that separates current byte from input.
        # The prompt is "xxxx YY " — we just matched xxxx, DDT still
        # needs to emit " YY " before reading.  Give it a beat.
        time.sleep(0.01)
        send(s, f"{b:02X}\r")
        next_addr = addr + i + 1
        # Read up to the next address echo, or the final "." prompt
        # area.  If it's the last byte, DDT still prints one more
        # address prompt; we'll end with "." afterwards.
        read_until(s, f"{next_addr:04X}", timeout=3)
    # Exit S mode.
    time.sleep(0.01)
    send(s, ".\r")
    read_until(s, "-", timeout=3)


_DUMP_LINE = re.compile(r"([0-9A-Fa-f]{4})\s+((?:[0-9A-Fa-f]{2}\s+){1,16})")


def parse_dump(text: str, base: int) -> dict[int, int]:
    """Parse DDT D output lines into {addr: byte}.  Lines look like:
       0100 F3 3E 05 D3 0A 3E 68 D3 0A 3E 0A D3 0A 3E 00 D3  .>...>h..>....>.
    """
    out: dict[int, int] = {}
    for m in _DUMP_LINE.finditer(text):
        addr = int(m.group(1), 16)
        hexes = m.group(2).split()
        for j, h in enumerate(hexes):
            out[addr + j] = int(h, 16)
    return out


def verify_via_ddt(s: serial.Serial, addr: int, data: bytes) -> bool:
    """Run D{addr},{addr+len-1} and compare to `data`."""
    end = addr + len(data) - 1
    send(s, f"D{addr:04X},{end:04X}\r")
    # Wait for the address that begins the LAST dump line, i.e. the
    # start of the 16-byte row containing `end`.  That guarantees the
    # full dump has been received.  A bare "-" would match inside the
    # ASCII column (any byte 0x2D prints as '-').  After the last row
    # DDT prints newline + "-" prompt; we read a little extra to make
    # sure the prompt byte is in the buffer.
    last_row = end & ~0x0F
    buf = read_until(s, f"{last_row:04X}", timeout=15)
    # Small grace read for the remaining row + prompt.
    time.sleep(0.3)
    extra = s.read(s.in_waiting or 1)
    if extra:
        buf += extra.decode("ascii", errors="replace")
    mem = parse_dump(buf, addr)
    ok = True
    for i, expected in enumerate(data):
        got = mem.get(addr + i)
        if got != expected:
            print(f"MISMATCH @ {addr+i:04X}: expected {expected:02X} got {got}",
                  file=sys.stderr)
            ok = False
    return ok


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cim")
    ap.add_argument("com_name", help="target filename on RC702, e.g. SIOASDLC.COM")
    ap.add_argument("--port", default="/dev/ttyUSB1")
    ap.add_argument("--baud", type=int, default=38400)
    ap.add_argument("--run", action="store_true",
                    help="run the program by sending its name at A>")
    args = ap.parse_args()

    data = Path(args.cim).read_bytes()
    base = 0x0100
    # SAVE n pages: ceil(len/256).
    n_pages = (len(data) + 255) // 256
    print(f"# {args.cim}: {len(data)} bytes, {n_pages} pages, target {args.com_name}")

    s = serial.Serial(args.port, args.baud, timeout=2, rtscts=True)
    s.dtr = True
    time.sleep(0.1)
    s.reset_input_buffer()

    try:
        # Ensure A> prompt.
        send(s, "\r")
        if "A>" not in read_until(s, "A>", timeout=5):
            print("ERROR: no A> prompt", file=sys.stderr)
            return 1

        # Launch DDT.
        send(s, "DDT\r")
        read_until(s, "-", timeout=10)

        # Type bytes into the TPA.
        t0 = time.time()
        enter_bytes_via_ddt(s, base, data)
        print(f"# entered {len(data)} bytes in {time.time()-t0:.1f}s")

        # Verify with D command.
        ok = verify_via_ddt(s, base, data)
        if not ok:
            print("VERIFY FAILED — aborting before SAVE", file=sys.stderr)
            send(s, "G0\r")   # warm boot anyway so CCP is usable
            return 2
        print("# verified OK")

        # Exit DDT via warm boot (preserves TPA for the upcoming SAVE).
        send(s, "G0\r")
        read_until(s, "A>", timeout=10)

        # Persist to disk.
        # First delete any stale copy so SAVE doesn't ask / fail.
        send(s, f"ERA {args.com_name}\r")
        read_until(s, "A>", timeout=5)

        send(s, f"SAVE {n_pages} {args.com_name}\r")
        read_until(s, "A>", timeout=10)
        print(f"# saved {args.com_name}")

        if args.run:
            stem = args.com_name.split(".")[0]
            send(s, f"{stem}\r")
            # Let the program run and print its banner/done message.
            read_until(s, "A>", timeout=15)
    finally:
        s.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
