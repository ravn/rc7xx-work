#!/usr/bin/env python3
"""cim_to_hex.py — convert a CP/M .cim binary to Intel HEX at 0x0100.

Used to stage .COM-equivalent payloads for the RC702 PIP+MLOAD deploy
path (same trick the BIOS deploy uses).
"""
import sys
from pathlib import Path


def to_hex(data: bytes, base: int = 0x0100) -> str:
    lines: list[str] = []
    i = 0
    while i < len(data):
        chunk = data[i : i + 16]
        addr = base + i
        byte_count = len(chunk)
        rec_type = 0x00
        checksum = byte_count + (addr >> 8) + (addr & 0xFF) + rec_type
        for b in chunk:
            checksum += b
        checksum = (-checksum) & 0xFF
        lines.append(
            f":{byte_count:02X}{addr:04X}{rec_type:02X}"
            f"{chunk.hex().upper()}{checksum:02X}"
        )
        i += 16
    # EOF record.
    lines.append(":00000001FF")
    return "\r\n".join(lines) + "\r\n"


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: cim_to_hex.py IN.cim OUT.hex", file=sys.stderr)
        return 2
    src = Path(sys.argv[1]).read_bytes()
    Path(sys.argv[2]).write_text(to_hex(src))
    print(f"{sys.argv[1]} ({len(src)} B) -> {sys.argv[2]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
