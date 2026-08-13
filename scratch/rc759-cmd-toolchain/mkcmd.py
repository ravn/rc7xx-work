#!/usr/bin/env python3
"""Build a CP/M-86 .CMD from raw NASM `-f bin` output.

Small-model layout: CODE group (type 1) + DATA group (type 2), both
base=0 (relocatable), no fixups. Header is 128 bytes of 9-byte group
descriptors; each group's bytes follow, padded to a 128-byte record.

Usage: mkcmd.py [code.bin] [data.bin] [out.CMD]
Defaults: code.bin, (optional) data.bin, HELLO.CMD in this directory.

NOTE (verified on RC759 Concurrent CP/M-86 3.1, 2026-08-12): a
self-contained program that sets DS=SS=CS itself and reads its strings
from the CODE group via a CS: override runs reliably. Relying on the
loader to point DS at the DATA group with data at DS:0x100 did NOT work
here (printed garbage) -- real DR C/Watcom programs get DS set up by
their crt0 startup, so that path is the linker's job, not hand-asm's.
"""
import struct, sys, os

HERE = os.path.dirname(os.path.abspath(__file__))
code_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'code.bin')
data_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, 'data.bin')
out_path  = sys.argv[3] if len(sys.argv) > 3 else os.path.join(HERE, 'HELLO.CMD')

code = open(code_path, 'rb').read()
try:
    data = open(data_path, 'rb').read()
except FileNotFoundError:
    data = b''

def para(n):            # bytes -> paragraphs (round up)
    return (n + 15) // 16
def pad128(b):
    r = len(b) % 128
    return b + b'\x00' * ((128 - r) if r else 0)
def gd(typ, length_para, base, minp, maxp):   # 9-byte group descriptor
    return struct.pack('<BHHHH', typ, length_para, base, minp, maxp)

code_para = para(len(code))
data_para = para(len(data)) if data else 1
data_min  = 0x60        # >=0x600 bytes headroom for data + stack

hdr  = gd(1, code_para, 0, code_para, 0)      # CODE group (type 1)
hdr += gd(2, data_para, 0, data_min,   0)     # DATA group (type 2)
hdr  = hdr.ljust(128, b'\x00')

out = hdr + pad128(code) + pad128(data if data else b'\x00')
open(out_path, 'wb').write(out)
print("CODE %d B (%d para), DATA %d B (%d para) -> %s (%d B)" %
      (len(code), code_para, len(data), data_para, out_path, len(out)))
