#!/usr/bin/env python3
"""Convert bios.cim to SYSGEN track 0 memory layout.

bios.cim is a contiguous binary: side0 FM data + side1 MFM data.
SYSGEN expects: side0 (3328B) + gap (3328B zeros) + side1 (6656B) = 13312B.

Usage:
    python3 mk_sysgen_t0.py bios.cim sysgen_t0.bin
"""

import sys

SIDE0_SIZE = 26 * 128   # 3328 bytes (FM, 26 sectors x 128B)
GAP_SIZE   = 26 * 128   # 3328 bytes (unused logical sectors 26-51)
SIDE1_SIZE = 26 * 256   # 6656 bytes (MFM, 26 sectors x 256B)
TOTAL      = SIDE0_SIZE + GAP_SIZE + SIDE1_SIZE  # 13312 = 0x3400

def main():
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <bios.cim> <sysgen_t0.bin>", file=sys.stderr)
        sys.exit(1)

    cim = open(sys.argv[1], 'rb').read()
    print(f"bios.cim: {len(cim)} bytes")

    if len(cim) > SIDE0_SIZE + SIDE1_SIZE:
        print(f"ERROR: bios.cim ({len(cim)}B) exceeds track 0 capacity ({SIDE0_SIZE + SIDE1_SIZE}B)",
              file=sys.stderr)
        sys.exit(1)

    out = bytearray(TOTAL)

    # Side 0: first 3328 bytes of bios.cim
    s0_len = min(len(cim), SIDE0_SIZE)
    out[0:s0_len] = cim[0:s0_len]

    # Gap: zeros (already zero from bytearray init)

    # Side 1: remaining bytes of bios.cim, placed after gap
    if len(cim) > SIDE0_SIZE:
        s1_data = cim[SIDE0_SIZE:]
        out[SIDE0_SIZE + GAP_SIZE : SIDE0_SIZE + GAP_SIZE + len(s1_data)] = s1_data

    with open(sys.argv[2], 'wb') as f:
        f.write(out)

    s1_used = max(0, len(cim) - SIDE0_SIZE)
    print(f"SYSGEN track 0: {TOTAL} bytes (side0={s0_len}B + gap={GAP_SIZE}B + side1={s1_used}B/{SIDE1_SIZE}B)")
    print(f"Written: {sys.argv[2]}")

if __name__ == '__main__':
    main()
