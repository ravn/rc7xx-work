#!/bin/sh
# rc759_make_unzip_b.sh -- author the RC759 B: disk holding the CP/M-86 build of
# Info-ZIP UnZip plus a few demo ZIP archives, so you can watch UnZip run on the
# real MAME rc759:
#
#   UNZIP.CMD   owcc -bcpm86 (Open Watcom) build (infozip-cpm86-builds)
#   HELLO.ZIP   STORED  -> HELLO.TXT (123 B)          -- no compression
#   POEM.ZIP    DEFLATE -> POEM.TXT  (3960 B)         -- normal inflate
#   BIG.ZIP     DEFLATE -> BIG.TXT   (47000 B, >32 K) -- exercises the >=32 KB
#                                                        stack-overflow FIX
#
# Output: mame/rc759_sw/B_unzip.mfi (rc759 5.25"-HD geometry), mounted as B: by
# scripts/rc759_boot_cpm.sh via B_DISK.
#
# Boot + run:
#   B_DISK="$PWD/mame/rc759_sw/B_unzip.mfi" sh scripts/rc759_boot_cpm.sh
# then at the CP/M-86 prompt:
#   B:               (switch to the B: drive so extracted files land there)
#   UNZIP HELLO.ZIP  (or POEM.ZIP / BIG.ZIP -- answer 'y' to any overwrite)
#   TYPE HELLO.TXT   (view the extracted file)
set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
DISKDIR="$WORKSPACE/mame/rc759_sw"
FLOPTOOL="${FLOPTOOL:-$WORKSPACE/mame/floptool}"
DISKDEFS="$WORKSPACE/scratch/rc759-cmd-toolchain/diskdefs"   # defines rc759-drc
DEMO="$WORKSPACE/scratch/rc759-unzip-demo"
UNZIP_CMD="$WORKSPACE/infozip-cpm86-builds/out-cpm86/UNZIP.CMD"
MKFS="${MKFS:-$(command -v mkfs.cpm || echo "$HOME/.local/bin/mkfs.cpm")}"
CPMCP="${CPMCP:-$(command -v cpmcp || echo "$HOME/.local/bin/cpmcp")}"
CPMLS="${CPMLS:-$(command -v cpmls || echo "$HOME/.local/bin/cpmls")}"
RC759_BYTES=1261568

[ -f "$UNZIP_CMD" ] || { echo "missing $UNZIP_CMD (build it in infozip-cpm86-builds)"; exit 1; }
[ -f "$DEMO/HELLO.ZIP" ] || { echo "missing demo zips in $DEMO"; exit 1; }

mkdir -p "$DISKDIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp "$DISKDEFS" "$STAGE/diskdefs"
cp "$UNZIP_CMD" "$STAGE/UNZIP.CMD"
cp "$DEMO/HELLO.ZIP" "$DEMO/POEM.ZIP" "$DEMO/BIG.ZIP" "$STAGE/"
# ENV = the clib's file-backed environment (portmisc.c getenv reads "ENV" on the
# current drive, NAME=VALUE per line).  "UNZIP=-t" makes UnZip's own envargs()
# prepend the LOWER-CASE -t (test-archive) option -- something the CCP-uppercased
# command tail can never carry.  Contents are case-preserving because the CCP
# never touches a file's bytes.  Remove it in CP/M with `ERA ENV` to return to
# the default extract action.
printf 'UNZIP=-t\r\n' > "$STAGE/ENV"

echo "==> author blank rc759 CP/M-86 image + copy UnZip + demo zips + ENV"
cd "$STAGE"
"$MKFS" -f rc759-drc B_unzip.img
"$CPMCP" -f rc759-drc B_unzip.img UNZIP.CMD 0:unzip.cmd
"$CPMCP" -f rc759-drc B_unzip.img HELLO.ZIP 0:hello.zip
"$CPMCP" -f rc759-drc B_unzip.img POEM.ZIP  0:poem.zip
"$CPMCP" -f rc759-drc B_unzip.img BIG.ZIP   0:big.zip
"$CPMCP" -f rc759-drc B_unzip.img ENV       0:env
# pad to full rc759 geometry with the CP/M empty byte so floptool lays all tracks
cur=$(stat -f %z B_unzip.img 2>/dev/null || stat -c %s B_unzip.img)
perl -e 'print "\xE5" x ('"$RC759_BYTES"'-'"$cur"')' >> B_unzip.img

echo "==> round-trip integrity check (write -> read back -> compare)"
"$CPMCP" -f rc759-drc B_unzip.img 0:unzip.cmd rt_unzip.cmd
"$CPMCP" -f rc759-drc B_unzip.img 0:big.zip   rt_big.zip
cmp UNZIP.CMD rt_unzip.cmd
cmp BIG.ZIP   rt_big.zip
echo "    UNZIP.CMD + BIG.ZIP verified byte-identical after write/read"
"$CPMLS" -f rc759-drc B_unzip.img

echo "==> convert to MAME mfi"
"$FLOPTOOL" flopconvert rc759 mfi B_unzip.img "$DISKDIR/B_unzip.mfi" >/dev/null
ls -l "$DISKDIR/B_unzip.mfi"
echo "DONE.  Boot with:"
echo "  B_DISK=\"$DISKDIR/B_unzip.mfi\" sh scripts/rc759_boot_cpm.sh"
echo "Then at the CP/M prompt:  B:   then   UNZIP HELLO.ZIP   (TYPE HELLO.TXT)"
echo "The ENV file carries UNZIP=-t, so  UNZIP BIG.ZIP  TESTS the archive"
echo "(prints 'No errors detected ...').  Run  ERA ENV  to revert to extract."
