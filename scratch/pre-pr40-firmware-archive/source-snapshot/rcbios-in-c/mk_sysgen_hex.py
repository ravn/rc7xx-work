#!/usr/bin/env python3
"""Generate Intel HEX for SYSGEN BIOS install via PIP+LOAD.

Creates a HEX file that, when LOADed and run as a .COM:
  - At 0x0100: checksum validator that verifies the payload at 0x4500,
    prints OK/FAIL, then exits
  - Places BIOS track 0 data at 0x4500 in SYSGEN's memory layout
    (side0 FM + 3328B gap + side1 MFM)

The workflow:
  1. SYSGEN read A: (loads CCP+BDOS at 0x0900)
  2. PIP BIOS.HEX=RDR: (receives this file over serial)
  3. LOAD BIOS (creates BIOS.COM, loads data into memory)
  4. BIOS (runs .COM — validates checksum, prints result, exits.
     Memory at 0x4500 is set regardless.)
  5. SYSGEN (skip read, write A:)

Usage:
    python3 mk_sysgen_hex.py bios.cim sysgen_bios.hex
"""

import sys

SIDE0_SIZE = 26 * 128   # 3328 bytes (FM side 0)
GAP_SIZE   = 26 * 128   # 3328 bytes (gap)
SIDE1_SIZE = 26 * 256   # 6656 bytes (MFM side 1)
T0_SIZE    = SIDE0_SIZE + GAP_SIZE + SIDE1_SIZE  # 13312

COM_BASE   = 0x0100     # CP/M .COM load address
T0_ADDR    = 0x4500     # SYSGEN track 0 location in memory


def ihex_record(rtype, addr, data):
    """Format one Intel HEX record."""
    length = len(data)
    record = [length, (addr >> 8) & 0xFF, addr & 0xFF, rtype] + list(data)
    checksum = (-sum(record)) & 0xFF
    hex_bytes = ''.join(f'{b:02X}' for b in record)
    return f':{hex_bytes}{checksum:02X}'


def ihex_data(addr, data, max_per_line=16):
    """Generate Intel HEX data records for a block of data."""
    lines = []
    offset = 0
    while offset < len(data):
        chunk = data[offset:offset + max_per_line]
        lines.append(ihex_record(0x00, addr + offset, chunk))
        offset += len(chunk)
    return lines


def build_checksum16_loop():
    """Z80: 16-bit sum DE over (HL) for BC bytes.
    loop:
        LD A,(HL)    ; 7E
        ADD A,E      ; 83
        LD E,A       ; 5F
        JR NC,+1     ; 30 01
        INC D        ; 14
        INC HL       ; 23
        DEC BC       ; 0B
        LD A,B       ; 78
        OR C         ; B1
        JR NZ,loop   ; 20 F4
    """
    return [0x7E, 0x83, 0x5F, 0x30, 0x01, 0x14, 0x23, 0x0B, 0x78, 0xB1, 0x20, 0xF4]


def build_validator(expected_sum, regions):
    """Build Z80 code that checksums multiple memory regions and prints OK/FAIL.

    regions: list of (addr, length) tuples to checksum consecutively.
    16-bit sum in DE accumulates across all regions.
    """
    code = []
    # LD DE, 0 (clear 16-bit accumulator)
    code += [0x11, 0x00, 0x00]
    for addr, length in regions:
        # LD HL, addr; LD BC, length
        code += [0x21, addr & 0xFF, (addr >> 8) & 0xFF]
        code += [0x01, length & 0xFF, (length >> 8) & 0xFF]
        code += build_checksum16_loop()
    # Compare DE against expected 16-bit sum
    # LD A,E; CP expected_low
    code += [0x7B, 0xFE, expected_sum & 0xFF]
    # JR NZ, fail
    code += [0x20, 0x00]  # placeholder 1
    fail_jr1_pos = len(code) - 1
    # LD A,D; CP expected_high
    code += [0x7A, 0xFE, (expected_sum >> 8) & 0xFF]
    # JR NZ, fail
    code += [0x20, 0x00]  # placeholder 2
    fail_jr2_pos = len(code) - 1

    # OK: print "OK\r\n$" via BDOS
    for ch in "OK\r\n$":
        code += [0x1E, ord(ch), 0x0E, 0x02, 0xCD, 0x05, 0x00]
    code += [0xC9]  # RET

    # Patch JR NZ offsets
    fail_start = len(code)
    code[fail_jr1_pos] = (fail_start - (fail_jr1_pos + 1)) & 0xFF
    code[fail_jr2_pos] = (fail_start - (fail_jr2_pos + 1)) & 0xFF

    # FAIL: print "FAIL\r\n$"
    for ch in "FAIL\r\n$":
        code += [0x1E, ord(ch), 0x0E, 0x02, 0xCD, 0x05, 0x00]
    code += [0xC9]  # RET

    return bytes(code)


def main():
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <bios.cim> <output.hex>", file=sys.stderr)
        sys.exit(1)

    cim = open(sys.argv[1], 'rb').read()
    print(f"bios.cim: {len(cim)} bytes")

    if len(cim) > SIDE0_SIZE + SIDE1_SIZE:
        print(f"ERROR: bios.cim too large ({len(cim)}B > {SIDE0_SIZE + SIDE1_SIZE}B)",
              file=sys.stderr)
        sys.exit(1)

    # 16-bit checksum over bios.cim
    expected_sum = sum(cim) & 0xFFFF
    print(f"Payload checksum: 0x{expected_sum:04X} (16-bit sum of {len(cim)} bytes)")

    # Build validator: checksums BIOS side 0 and side 1 at their SYSGEN addresses
    s0_len = min(len(cim), SIDE0_SIZE)
    s1_len = max(0, len(cim) - SIDE0_SIZE)
    regions = [(T0_ADDR, s0_len)]
    if s1_len > 0:
        regions.append((T0_ADDR + SIDE0_SIZE + GAP_SIZE, s1_len))
    validator = build_validator(expected_sum, regions)
    print(f"Validator: {len(validator)} bytes at 0x{COM_BASE:04X}")

    lines = []

    # Validator code at 0x0100
    lines.extend(ihex_data(COM_BASE, list(validator)))

    # Side 0 FM data at 0x4500 — emit ALL bytes (no zero skip, checksummed)
    s0_data = cim[:s0_len]
    lines.extend(ihex_data(T0_ADDR, s0_data))

    # Gap is not emitted (not checksummed, MLOAD/LOAD fills with zeros)

    # Side 1 MFM data at 0x5F00 — emit ALL bytes
    if len(cim) > SIDE0_SIZE:
        s1_data = cim[SIDE0_SIZE:]
        s1_addr = T0_ADDR + SIDE0_SIZE + GAP_SIZE
        lines.extend(ihex_data(s1_addr, s1_data))

    # CP/M EOF: zero-length data record (type 00), not Intel type 01
    lines.append(ihex_record(0x00, 0x0000, []))

    hex_content = '\r\n'.join(lines) + '\r\n'
    # Also write a CR-only version for CP/M serial transfer
    hex_content_cr = '\r'.join(lines) + '\r'
    cr_path = sys.argv[2].replace('.hex', '_cr.hex')
    with open(cr_path, 'wb') as f:
        f.write(hex_content_cr.encode('ascii'))
    print(f"CR-only: {cr_path}")

    with open(sys.argv[2], 'w') as f:
        f.write(hex_content)

    total_data = len(validator) + len(s0_data) + (len(cim) - SIDE0_SIZE if len(cim) > SIDE0_SIZE else 0)
    print(f"HEX file: {len(lines)} records, {total_data} data bytes")
    print(f"  0x{COM_BASE:04X}: validator ({len(validator)} bytes)")
    print(f"  0x{T0_ADDR:04X}: side 0 ({len(s0_data)} bytes)")
    s1_used = max(0, len(cim) - SIDE0_SIZE)
    if s1_used:
        print(f"  0x{T0_ADDR + SIDE0_SIZE + GAP_SIZE:04X}: side 1 ({s1_used} bytes)")
    print(f"Written: {sys.argv[2]}")


if __name__ == '__main__':
    main()
