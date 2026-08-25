#!/bin/sh
# rc759_zip_stream_diff.sh -- extract the CCP/M-written POEM.ZIP from the B: disk
# image and byte-diff its deflate stream against the known-good emu2 reference.
#
# Prereq: boot MAME with the KEEP_BADZIP-instrumented ZIP.CMD, then at B:> run
#         ZIP POEM.ZIP POEM.TXT
# The instrumentation keeps the malformed archive (no destroy(tempzip)), so it
# survives on B: for extraction here.
#
# Usage: sh scripts/rc759_zip_stream_diff.sh [B_zip.mfi] [guest-archive-name]
set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
MFI="${1:-$WORKSPACE/mame/rc759_sw/B_zip.mfi}"
GUEST_ARCHIVE="${2:-poem.zip}"
TOOLCHAIN="$WORKSPACE/scratch/rc759-cmd-toolchain"
FLOPTOOL="${FLOPTOOL:-$WORKSPACE/mame/floptool}"
CPMCP="${CPMCP:-$HOME/.local/bin/cpmcp}"
CPMLS="${CPMLS:-$HOME/.local/bin/cpmls}"
REF="${REF:-/tmp/emu2_deflate.bin}"      # produced by the decode step below
OUT="${OUT:-/tmp/ccpm_${GUEST_ARCHIVE}}"
RAW="/tmp/B_zip_extract.img"

[ -f "$MFI" ] || { echo "missing mfi: $MFI" >&2; exit 1; }

echo "==> mfi -> raw"
"$FLOPTOOL" flopconvert mfi rc759 "$MFI" "$RAW"

echo "==> directory of B:"
( cd "$TOOLCHAIN" && "$CPMLS" -f rc759-drc "$RAW" )

echo "==> extracting 0:$GUEST_ARCHIVE -> $OUT"
( cd "$TOOLCHAIN" && "$CPMCP" -f rc759-drc "$RAW" "0:$GUEST_ARCHIVE" "$OUT" )

echo "==> decode + diff against emu2 reference ($REF)"
python3 - "$OUT" "$REF" <<'PY'
import struct, sys, hashlib, zlib
path, ref = sys.argv[1], sys.argv[2]
d = open(path, 'rb').read()
if d[:4] != b'PK\x03\x04':
    print("!! not a local-file-header zip:", d[:8].hex()); sys.exit(1)
(sig,ver,flg,method,mt,md,crc,csize,usize,nlen,elen) = struct.unpack('<IHHHHHIIIHH', d[:30])
name = d[30:30+nlen].decode('latin1')
off = 30 + nlen + elen
comp = d[off:off+csize]
print(f"CCP/M archive: name={name!r} method={method} flg={flg} crc={crc:08x}")
print(f"  header csize={csize} usize={usize}  extracted comp-bytes={len(comp)} sha={hashlib.sha1(comp).hexdigest()[:12]}")
try:
    out = zlib.decompressobj(-15).decompress(comp)
    print(f"  raw-inflate -> {len(out)} bytes  crc={zlib.crc32(out)&0xffffffff:08x}")
except Exception as e:
    print(f"  raw-inflate FAILED: {e}")
open('/tmp/ccpm_deflate.bin','wb').write(comp)
print("  -> /tmp/ccpm_deflate.bin")
try:
    r = open(ref,'rb').read()
    print(f"\nemu2 reference : {len(r)} bytes sha={hashlib.sha1(r).hexdigest()[:12]}")
    print(f"CCP/M stream   : {len(comp)} bytes sha={hashlib.sha1(comp).hexdigest()[:12]}")
    n = min(len(r), len(comp))
    first = next((i for i in range(n) if r[i]!=comp[i]), None)
    if first is None and len(r)==len(comp):
        print("IDENTICAL streams")
    else:
        print(f"first divergence at byte {first}  (emu2={r[first]:#04x} vs ccpm={comp[first]:#04x})" if first is not None
              else f"common prefix identical; lengths differ emu2={len(r)} ccpm={len(comp)}")
except FileNotFoundError:
    print(f"(no reference at {ref}; run the emu2 decode step first)")
PY

echo
echo "hexdump side-by-side (first divergence region): use"
echo "  cmp -l /tmp/emu2_deflate.bin /tmp/ccpm_deflate.bin | head"
