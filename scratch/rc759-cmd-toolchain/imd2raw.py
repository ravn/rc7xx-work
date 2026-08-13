#!/usr/bin/env python3
"""imd2raw.py - decode an ImageDisk (.IMD) floppy image to a flat raw sector
image suitable for cpmtools.

Written for the official Regnecentralen RC759 "Piccoline" DR C diskettes archived
at datamuseum.dk (IMD 1.18 blobs). Verified geometry (30005869 "DR C v.1.11"):
77 cyl x 2 heads, 8 sectors/track, 1024 B/sector, sector-numbering skew
(2,3,4,5,6,7,8,1). We emit each track's sectors in LOGICAL sector-number order
(1..8) so cpmtools needs no further skew (diskdef skew 0). Track order in the
output is IMD file order = cyl0h0, cyl0h1, cyl1h0, cyl1h1, ...  which puts the
CP/M-86 directory (cylinder 2) at byte 0x8000 as DDHF's analysis reports.

Usage: imd2raw.py in.imd out.raw
"""
import sys

SS = {0: 128, 1: 256, 2: 512, 3: 1024, 4: 2048, 5: 4096, 6: 8192}


def decode(blob):
    i = blob.index(0x1A) + 1  # ASCII comment terminated by EOF (0x1A)
    p = i
    out = bytearray()
    ntr = 0
    while p < len(blob):
        mode, cyl, head, nsec, ssz = blob[p:p + 5]
        p += 5
        size = SS[ssz]
        hflag = head
        smap = list(blob[p:p + nsec]); p += nsec
        if hflag & 0x80:  # optional cylinder map
            p += nsec
        if hflag & 0x40:  # optional head map
            p += nsec
        # Read this track's sectors into a dict keyed by logical sector number.
        secs = {}
        for s in range(nsec):
            t = blob[p]; p += 1
            if t == 0:                      # unavailable
                data = b"\xe5" * size
            elif t in (1, 3, 5, 7):         # normal / with flags
                data = blob[p:p + size]; p += size
            elif t in (2, 4, 6, 8):         # compressed (single fill byte)
                data = bytes([blob[p]]) * size; p += 1
            else:
                raise SystemExit(f"bad sector-data type {t} at {p}")
            secs[smap[s]] = data
        # Emit in ascending sector-number order (de-skew). For the standard 1..8
        # numbering this is logical order; a disk that renumbers sectors still
        # yields a deterministic, gap-free layout.
        for n in sorted(secs):
            out += secs[n]
        ntr += 1
    return out, ntr


def main():
    if len(sys.argv) != 3:
        sys.exit("usage: imd2raw.py in.imd out.raw")
    blob = open(sys.argv[1], "rb").read()
    raw, ntr = decode(blob)
    open(sys.argv[2], "wb").write(raw)
    print(f"decoded {ntr} tracks -> {len(raw)} bytes ({sys.argv[2]})")


if __name__ == "__main__":
    main()
