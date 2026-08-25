#!/usr/bin/env python3
# Decode a CCP/M-written zip's deflate stream and diff it against a raw-deflate
# reference (the known-good emu2 stream). Args: <archive.zip> <reference.bin>
import struct, sys, hashlib, zlib

path, ref = sys.argv[1], sys.argv[2]
d = open(path, 'rb').read()
if d[:4] != b'PK\x03\x04':
    print("!! not a local-file-header zip:", d[:8].hex()); sys.exit(1)
(sig, ver, flg, method, mt, md, crc, csize, usize, nlen, elen) = struct.unpack('<IHHHHHIIIHH', d[:30])
name = d[30:30 + nlen].decode('latin1')
off = 30 + nlen + elen
comp = d[off:off + csize]
print(f"CCP/M archive: name={name!r} method={method} flg={flg} crc={crc:08x}")
print(f"  header csize={csize} usize={usize}  extracted comp-bytes={len(comp)} sha={hashlib.sha1(comp).hexdigest()[:12]}")
try:
    out = zlib.decompressobj(-15).decompress(comp)
    print(f"  raw-inflate -> {len(out)} bytes  crc={zlib.crc32(out) & 0xffffffff:08x}")
except Exception as e:
    print(f"  raw-inflate FAILED: {e}")
open('/tmp/ccpm_deflate.bin', 'wb').write(comp)
print("  -> /tmp/ccpm_deflate.bin")

try:
    r = open(ref, 'rb').read()
except FileNotFoundError:
    print(f"(no reference at {ref})"); sys.exit(0)
print(f"\nemu2 reference : {len(r)} bytes sha={hashlib.sha1(r).hexdigest()[:12]}")
print(f"CCP/M stream   : {len(comp)} bytes sha={hashlib.sha1(comp).hexdigest()[:12]}")
n = min(len(r), len(comp))
first = next((i for i in range(n) if r[i] != comp[i]), None)
if first is None and len(r) == len(comp):
    print("IDENTICAL streams")
elif first is None:
    print(f"common prefix ({n} B) identical; lengths differ emu2={len(r)} ccpm={len(comp)}")
else:
    print(f"first divergence at byte {first}  (emu2={r[first]:#04x} vs ccpm={comp[first]:#04x})")
    a = max(0, first - 8)
    print(f"  emu2[{a}:{first+8}] = {r[a:first+8].hex()}")
    print(f"  ccpm[{a}:{first+8}] = {comp[a:first+8].hex()}")
