#!/usr/bin/env python3
"""
patch_fast_bootprom.py -- Producerer en Fast-Boot version af RC759 Boot PROM v2.1.

Patchet fjerner:
1. 32 KB PROM checksum-loopet (offset 3D39h).
2. 32 KB CRT VRAM 2-pass mønstertesten (offset 3D88h).
3. 40.000 loop delay og System RAM 2-pass testen (offset 406Ch).
4. Selftest-menuen og nedtællingsløkken før boot (offset 44F8h).

Resultatet er en boot-ROM der initialiserer al hardware korrekt og overdrager
kontrollen til styresystemets bootsektor på under 0,5 sekunder.
"""

import hashlib
import os
import sys
import zlib

SRC_ROM = "mame/roms/rc759/rc759-1-2.1.rom"
DST_ROM = "mame/roms/rc759/rc759-fast.rom"

PATCHES = [
    # (offset, original_bytes, patched_bytes, description)
    (0x3D39, bytes([0x74, 0x4D]), bytes([0xEB, 0x4D]), "Skip PROM checksum test"),
    (0x3D88, bytes([0xFD, 0xB8, 0xAA, 0x55]), bytes([0xE9, 0x21, 0x01, 0x90]), "Skip 32 KB CRT VRAM test"),
    (0x406C, bytes([0x74, 0x03]), bytes([0x90, 0x90]), "Skip 40k loop delay & System RAM test"),
    (0x44F8, bytes([0x75, 0x6E]), bytes([0xEB, 0x6E]), "Skip selftest countdown loop -> direct bootloader"),
]

def main():
    if not os.path.exists(SRC_ROM):
        print(f"ERROR: Source ROM not found: {SRC_ROM}", file=sys.stderr)
        sys.exit(1)

    with open(SRC_ROM, "rb") as f:
        data = bytearray(f.read())

    if len(data) != 32768:
        print(f"ERROR: Expected 32768 bytes, got {len(data)}", file=sys.stderr)
        sys.exit(1)

    # Verify original bytes
    for offset, orig, patched, desc in PATCHES:
        actual = data[offset:offset+len(orig)]
        if actual != orig:
            print(f"ERROR at offset {hex(offset)} ({desc}): expected {orig.hex()}, got {actual.hex()}", file=sys.stderr)
            sys.exit(1)

    # Apply patches
    for offset, orig, patched, desc in PATCHES:
        data[offset:offset+len(patched)] = patched
        print(f"Applied patch at {hex(offset)}: {orig.hex()} -> {patched.hex()} ({desc})")

    with open(DST_ROM, "wb") as f:
        f.write(data)

    crc = zlib.crc32(data) & 0xFFFFFFFF
    sha1 = hashlib.sha1(data).hexdigest()

    print(f"\nSuccessfully wrote fast-boot ROM to {DST_ROM}")
    print(f"Size:   {len(data)} bytes")
    print(f"CRC32:  {crc:08x}")
    print(f"SHA1:   {sha1}")

if __name__ == "__main__":
    main()
