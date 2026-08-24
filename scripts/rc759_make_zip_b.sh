#!/bin/sh
# rc759_make_zip_b.sh -- author the RC759 B: disk for testing Info-ZIP ZIP + UNZIP
# under genuine Concurrent CP/M-86 3.1 on MAME rc759.
#
# Disk contents:
#   ZIP.CMD     large-model deflate ZIP (owcc -bcpm86 -ml, M9 farheap fix)
#   UNZIP.CMD   small-model inflate UNZIP (owcc -bcpm86)
#   MINIZIP.CMD store-only native ZIP (safe MAME baseline, always works)
#   POEM.TXT    ~4 KB text (inflates well: ~86% compression ratio)
#   BIG.TXT     ~47 KB text (exercises the 32 KB inflate window fix)
#   HELLO.TXT   small text (sanity / stored-mode test)
#
# Usage:
#   sh scripts/rc759_make_zip_b.sh            # build disk + print boot command
#   B_DISK=mame/rc759_sw/B_zip.mfi sh scripts/rc759_boot_cpm.sh   # run MAME
#
# CP/M-86 test sequence (at the A> prompt after boot):
#   B:                              -- switch to B:
#   MINIZIP SMALL.ZIP HELLO.TXT     -- store-only test (always works)
#   ZIP POEM.ZIP POEM.TXT           -- M9: deflate a small file (target: works)
#   ZIP BIG.ZIP BIG.TXT             -- M9: deflate a large file
#   UNZIP -t POEM.ZIP               -- verify round-trip with UNZIP
#   UNZIP POEM.ZIP                  -- extract and TYPE POEM.TXT

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
IZIP="$WORKSPACE/infozip-cpm86-builds"
DISKDIR="$WORKSPACE/mame/rc759_sw"
FLOPTOOL="${FLOPTOOL:-$WORKSPACE/mame/floptool}"
DISKDEFS="$WORKSPACE/scratch/rc759-cmd-toolchain/diskdefs"
DEMO="$WORKSPACE/scratch/rc759-unzip-demo"
MKFS="${MKFS:-$(command -v mkfs.cpm  || echo "$HOME/.local/bin/mkfs.cpm")}"
CPMCP="${CPMCP:-$(command -v cpmcp   || echo "$HOME/.local/bin/cpmcp")}"
CPMLS="${CPMLS:-$(command -v cpmls   || echo "$HOME/.local/bin/cpmls")}"
RC759_BYTES=1261568

ZIP_CMD="$IZIP/out-zip-cpm86/ZIP.CMD"
MINIZIP_CMD="$IZIP/out-minizip-cpm86/MINIZIP.CMD"
UNZIP_CMD="$IZIP/out-cpm86/UNZIP.CMD"
ZIPNOTE_CMD="$IZIP/out-ziputils-cpm86/ZIPNOTE.CMD"
ZIPSPLIT_CMD="$IZIP/out-ziputils-cpm86/ZIPSPLIT.CMD"
ZIPCLOAK_CMD="$IZIP/out-ziputils-cpm86/ZIPCLOAK.CMD"
FUNZIP_CMD="$IZIP/out-funzip-cpm86/FUNZIP.CMD"

for f in "$ZIP_CMD" "$UNZIP_CMD"; do
    [ -f "$f" ] || { echo "MISSING: $f"; echo "Build: cd $IZIP && bash build-zip-cpm86.sh (+ build-cpm86.sh)"; exit 1; }
done
for f in "$ZIPNOTE_CMD" "$ZIPSPLIT_CMD" "$ZIPCLOAK_CMD"; do
    [ -f "$f" ] || { echo "MISSING: $f"; echo "Build: cd $IZIP && bash build-ziputils-cpm86.sh"; exit 1; }
done
[ -f "$FUNZIP_CMD" ] || { echo "MISSING: $FUNZIP_CMD"; echo "Build: cd $IZIP && bash build-funzip-cpm86.sh"; exit 1; }
[ -f "$DEMO/POEM.TXT" ] || { echo "MISSING: $DEMO/POEM.TXT"; exit 1; }
[ -f "$DEMO/BIG.TXT"  ] || { echo "MISSING: $DEMO/BIG.TXT"; exit 1; }
[ -f "$DEMO/hello.txt" ] || { echo "MISSING: $DEMO/hello.txt"; exit 1; }

mkdir -p "$DISKDIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp "$DISKDEFS" "$STAGE/diskdefs"

echo "==> authoring B_zip.mfi (full Info-ZIP suite + test files)"
cd "$STAGE"
"$MKFS" -f rc759-drc B_zip.img

# Full Info-ZIP suite
"$CPMCP" -f rc759-drc B_zip.img "$ZIP_CMD"      0:zip.cmd
"$CPMCP" -f rc759-drc B_zip.img "$UNZIP_CMD"    0:unzip.cmd
"$CPMCP" -f rc759-drc B_zip.img "$ZIPNOTE_CMD"  0:zipnote.cmd
"$CPMCP" -f rc759-drc B_zip.img "$ZIPSPLIT_CMD" 0:zipsplit.cmd
"$CPMCP" -f rc759-drc B_zip.img "$ZIPCLOAK_CMD" 0:zipcloak.cmd
"$CPMCP" -f rc759-drc B_zip.img "$FUNZIP_CMD"   0:funzip.cmd
[ -f "$MINIZIP_CMD" ] && "$CPMCP" -f rc759-drc B_zip.img "$MINIZIP_CMD" 0:minizip.cmd || true
# Test data
"$CPMCP" -f rc759-drc B_zip.img "$DEMO/POEM.TXT"  0:poem.txt
"$CPMCP" -f rc759-drc B_zip.img "$DEMO/BIG.TXT"   0:big.txt
"$CPMCP" -f rc759-drc B_zip.img "$DEMO/hello.txt" 0:hello.txt

# Pad to full rc759 geometry
cur=$(stat -f %z B_zip.img 2>/dev/null || stat -c %s B_zip.img)
perl -e 'print "\xE5" x ('"$RC759_BYTES"'-'"$cur"')' >> B_zip.img

echo "==> round-trip check (write -> read back -> compare)"
"$CPMCP" -f rc759-drc B_zip.img 0:zip.cmd   rt_zip.cmd
"$CPMCP" -f rc759-drc B_zip.img 0:unzip.cmd rt_unzip.cmd
cmp "$ZIP_CMD"   rt_zip.cmd   && echo "    ZIP.CMD   OK"
cmp "$UNZIP_CMD" rt_unzip.cmd && echo "    UNZIP.CMD OK"

"$CPMLS" -f rc759-drc B_zip.img
echo

echo "==> convert to MAME mfi"
"$FLOPTOOL" flopconvert rc759 mfi B_zip.img "$DISKDIR/B_zip.mfi" >/dev/null
ls -l "$DISKDIR/B_zip.mfi"
echo
echo "DONE. Boot med:"
echo "  B_DISK=\"$DISKDIR/B_zip.mfi\" sh $WORKSPACE/scripts/rc759_boot_cpm.sh"
echo
echo "Komplet Info-ZIP suite paa B:  ZIP UNZIP ZIPNOTE ZIPSPLIT ZIPCLOAK FUNZIP"
echo
echo "I MAME (efter boot til A>-prompt):"
echo "  B:                              -- skift til B:"
echo "  ZIP POEM.ZIP POEM.TXT           -- deflate-test (M9-fix)"
echo "  ZIP BIG.ZIP BIG.TXT             -- deflate stor fil"
echo "  ZIP ALL.ZIP *.TXT               -- wildcard-arkivering"
echo "  UNZIP -t POEM.ZIP               -- verificer round-trip"
echo "  ZIPNOTE POEM.ZIP                -- vis arkivkommentar"
echo "  FUNZIP POEM.ZIP > POEM2.TXT     -- stream-uddrag til fil"
echo "  ZIPCLOAK POEM.ZIP               -- kryptér (tast kodeord)"
echo "  MINIZIP SMALL.ZIP HELLO.TXT     -- store-only (baseline)"
