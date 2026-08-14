#!/usr/bin/env python3
"""Split a DR C .L86 (Intel-OMF library, 0xA4 LIBHED) into constituent OMF
object modules (THEADR..MODEND), skipping the library wrapper records
(LIBHED 0xA4 / LIBNAM 0xA6 / LIBLOC 0xA8 / LIBDIC 0xAA)."""
import sys, os
THEADR, MODEND1, MODEND2 = 0x80, 0x8A, 0x8B
data = open(sys.argv[1], 'rb').read()
outdir = sys.argv[2]; os.makedirs(outdir, exist_ok=True)
i, n = 0, len(data)
mod_start = None; mods = []
while i < n:
    rectype = data[i]
    if i + 3 > n: break
    length = data[i+1] | (data[i+2] << 8)   # LE record length (body incl chksum)
    rec_end = i + 3 + length
    if rec_end > n:
        sys.stderr.write("truncated record at 0x%x type=0x%02x len=%d\n" % (i, rectype, length))
        break
    if rectype == THEADR:
        mod_start = i
    elif rectype in (MODEND1, MODEND2) and mod_start is not None:
        mods.append((mod_start, rec_end))
        mod_start = None
    i = rec_end
# name each module from its THEADR string (fallback to index)
names = {}
manifest = []
for idx, (s, e) in enumerate(mods):
    # THEADR body: byte after 3-byte header = name-length, then name
    namelen = data[s+3]
    name = data[s+4:s+4+namelen].decode('ascii', 'replace')
    safe = ''.join(c if c.isalnum() else '_' for c in name) or ('mod%03d' % idx)
    # dedupe
    base = safe; k = 1
    while safe in names.values():
        safe = '%s_%d' % (base, k); k += 1
    fn = os.path.join(outdir, 'm%03d_%s.obj' % (idx, safe))
    names[idx] = safe
    open(fn, 'wb').write(data[s:e])
    manifest.append(fn)
print("modules:", len(mods))
open(os.path.join(outdir, 'MODLIST.txt'), 'w').write('\n'.join(manifest) + '\n')
