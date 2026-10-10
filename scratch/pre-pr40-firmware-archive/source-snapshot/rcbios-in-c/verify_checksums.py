#!/usr/bin/env python3
"""Compute expected per-track checksums for RC702 BIOS disk read test.

Reads an IMD file and computes the same byte-sum checksums that the
BIOS test code produces, using the same sector translation tables
and side-splitting logic.

Usage: python3 verify_checksums.py <image.imd>
"""

import sys, struct

# Sector translation tables (from crt0.asm)
TRAN8 = [1,5,9,13, 2,6,10,14, 3,7,11,15, 4,8,12]   # 8" DD 512B, skew 4
TRAN24 = list(range(1, 27))                            # 1..26, no translation

def parse_imd(path):
    """Parse IMD file, return list of (cyl, head, sector_id, data) tuples."""
    with open(path, 'rb') as f:
        raw = f.read()
    pos = raw.index(0x1A) + 1
    sectors = []
    while pos < len(raw):
        mode = raw[pos]; pos += 1
        cyl = raw[pos]; pos += 1
        head_byte = raw[pos]; pos += 1
        head = head_byte & 1
        has_cyl_map = (head_byte & 0x80) != 0
        has_head_map = (head_byte & 0x40) != 0
        nsec = raw[pos]; pos += 1
        secsize_code = raw[pos]; pos += 1
        secsize = 128 << secsize_code
        sec_map = list(raw[pos:pos+nsec]); pos += nsec
        if has_cyl_map:
            pos += nsec
        if has_head_map:
            pos += nsec
        for i in range(nsec):
            dtype = raw[pos]; pos += 1
            if dtype == 0:
                sdata = b'\x00' * secsize
            elif dtype == 1:
                sdata = raw[pos:pos+secsize]; pos += secsize
            elif dtype == 2:
                sdata = bytes([raw[pos]]) * secsize; pos += 1
            elif dtype == 3:
                sdata = raw[pos:pos+secsize]; pos += secsize
            elif dtype == 4:
                sdata = bytes([raw[pos]]) * secsize; pos += 1
            else:
                sdata = b'\x00' * secsize
            sectors.append((cyl, head, sec_map[i], sdata))
    return sectors

def find_sector(sectors, cyl, head, sec_id):
    for c, h, s, d in sectors:
        if c == cyl and h == head and s == sec_id:
            return d
    return None

def compute_track_cksum(sectors, trk, cpm_sectors_per_track, deblock_shift, track0_sectors_per_side, sector_xlate):
    """Compute track checksum using same logic as BIOS test."""
    cksum = 0
    errors = 0
    for cpm_sec in range(cpm_sectors_per_track):
        # Compute host sector: cpm_sector >> (deblock_shift-1)
        hostbuf_sector = cpm_sec >> (deblock_shift - 1)
        # Determine side and physical sector
        if hostbuf_sector < track0_sectors_per_side:
            side = 0
            phys_sec = sector_xlate[hostbuf_sector]
        else:
            side = 1
            phys_sec = sector_xlate[hostbuf_sector - track0_sectors_per_side]
        # Record offset within host sector
        deblock_mask = (1 << (deblock_shift - 1)) - 1
        rec_offset = (cpm_sec & deblock_mask) * 128
        data = find_sector(sectors, trk, side, phys_sec)
        if data is None:
            errors += 1
            continue
        chunk = data[rec_offset:rec_offset+128]
        cksum = (cksum + sum(chunk)) & 0xFFFF
    return cksum, errors

def compute_checksums(imd_path):
    sectors = parse_imd(imd_path)
    max_cyl = max(c for c,h,s,d in sectors)
    disk_cksum = 0
    total_errors = 0

    print(f"Image: {imd_path}")
    print(f"Tracks: {max_cyl + 1}")

    # --- Track 0 Side 0: FM 128B (format 16) ---
    # FSPA16: SPT=26, deblock_shift=1, deblock_mask=0, sector_xlate=xlt_identity, track0_sectors_per_side=26
    cksum, errs = compute_track_cksum(sectors, 0, 26, 1, 26, TRAN24)
    disk_cksum = (disk_cksum + cksum) & 0xFFFF
    total_errors += errs
    err_str = f"!E{errs}" if errs else ""
    print(f"T0S0={cksum:04X}{err_str}", end="")

    # --- Track 0 Side 1: MFM 256B (format 24, side 1 only) ---
    # FSPA24: SPT=104, deblock_shift=2, deblock_mask=1, sector_xlate=xlt_identity, track0_sectors_per_side=26
    # Only read cpm_sector 52..103 (side 1)
    cksum = 0
    errs = 0
    for cpm_sec in range(52, 104):
        hostbuf_sector = cpm_sec >> 1  # deblock_shift-1 = 1
        side = 1
        phys_sec = TRAN24[hostbuf_sector - 26]
        rec_offset = (cpm_sec & 1) * 128
        data = find_sector(sectors, 0, side, phys_sec)
        if data is None:
            errs += 1
            continue
        chunk = data[rec_offset:rec_offset+128]
        cksum = (cksum + sum(chunk)) & 0xFFFF
    disk_cksum = (disk_cksum + cksum) & 0xFFFF
    total_errors += errs
    err_str = f"!E{errs}" if errs else ""
    print(f" T0S1={cksum:04X}{err_str}")

    # --- Tracks 1 through max_cyl: MFM 512B (format 8) ---
    # FSPA08: SPT=120, deblock_shift=3, deblock_mask=3, sector_xlate=xlt_maxi_512, track0_sectors_per_side=15
    col = 0
    line = ""
    for trk in range(1, max_cyl + 1):
        cksum, errs = compute_track_cksum(sectors, trk, 120, 3, 15, TRAN8)
        disk_cksum = (disk_cksum + cksum) & 0xFFFF
        total_errors += errs
        err_str = "!" if errs else ""
        line += f"{trk}:{cksum:04X}{err_str} "
        col += 1
        if col >= 6:
            print(line.rstrip())
            line = ""
            col = 0
    if line:
        print(line.rstrip())

    print(f"DISK={disk_cksum:04X} ERR={total_errors}")
    return disk_cksum, total_errors

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <image.imd> [image2.imd ...]")
        sys.exit(1)
    for path in sys.argv[1:]:
        compute_checksums(path)
        if len(sys.argv) > 2:
            print()
