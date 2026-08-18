#!/usr/bin/env python3
"""Sum the CODE-class segment length(s) of an Intel OMF-86 object.

Used to measure the machine-code byte count a compiler emitted for a benchmark,
uniformly across Open Watcom and genuine DR C 1.11 (both write Intel OMF).
Aztec C86 uses its own object format instead -> use `aztecNN_obd` and read the
function's "Block start, ends @ NNNN" offset. DR C also prints `code: N`
directly from its code-gen pass, which agrees with this parser.
"""
import sys, struct

def parse(fn):
    d = open(fn, 'rb').read()
    i = 0
    lnames = ['']
    segs = []
    while i + 3 <= len(d):
        rt = d[i]
        ln = struct.unpack_from('<H', d, i + 1)[0]
        body = d[i + 3:i + 3 + ln - 1]
        i += 3 + ln
        if rt == 0x96:  # LNAMES
            p = 0
            while p < len(body):
                n = body[p]
                lnames.append(body[p + 1:p + 1 + n].decode('latin1'))
                p += 1 + n
        elif rt in (0x98, 0x99):  # SEGDEF16 / SEGDEF32
            acbp = body[0]; p = 1
            if (acbp >> 2) & 7 == 0:   # absolute segment carries frame+offset
                p += 3
            if rt == 0x98:
                seglen = struct.unpack_from('<H', body, p)[0]; p += 2
            else:
                seglen = struct.unpack_from('<I', body, p)[0]; p += 4
            segname = body[p] if p < len(body) else 0
            classname = body[p + 1] if p + 1 < len(body) else 0
            segs.append((lnames[segname] if segname < len(lnames) else '?',
                         lnames[classname] if classname < len(lnames) else '?',
                         seglen))
    return segs

def code_total(fn):
    return sum(l for _n, cls, l in parse(fn) if cls.upper() == 'CODE')

# `omfsize.py --code file...` prints ONLY the summed CODE bytes (one integer per
# file, or a single grand total for multiple files) -- the machine-readable form
# the per-compiler Makefiles consume. Without --code it prints the verbose
# per-segment breakdown for humans.
if len(sys.argv) > 1 and sys.argv[1] == '--code':
    files = sys.argv[2:]
    print(sum(code_total(f) for f in files))
    sys.exit(0)

total = 0
for f in sys.argv[1:]:
    print(f)
    for name, cls, l in parse(f):
        mark = ' <-- CODE' if cls.upper() == 'CODE' else ''
        if cls.upper() == 'CODE':
            total += l
        print("  seg=%-14s class=%-8s len=%d%s" % (name, cls, l, mark))
if len(sys.argv) > 2:
    print("TOTAL CODE bytes: %d" % total)
