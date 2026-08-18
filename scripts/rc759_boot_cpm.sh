#!/bin/sh
# rc759_boot_cpm.sh -- launch MAME rc759 (Piccoline) with a CP/M-86 boot disk.
#
# Lives in the rc7xx-work top-level repo; drives the mame/ submodule.
# Counterpart to rc702_boot_cpm.sh (which boots the 8" RC702 CP/M 2.2 system).
#
# ROMs: MAME's rc759 driver ships four verified BIOS sets in mame/roms/rc759/
# (rc759-1-2.1 .. rc759-2-5.1).  The default BIOS (-bios 0) boots the disk.
#
# A: boot disk.  The RC759 uses 5.25" DS-HD floppies in the "rc759" format
# (FLOPPY_RC759_FORMAT: FF_525 / DSHD / MFM, 8 sectors x 1024 B, 77 cyl, 2
# heads = 1,261,568 bytes raw).  The default A: disk is a genuine CCP/M-86
# disk (NOT CDOS, a later/different successor OS) -- disk1 of "SW1400
# CCP/M-86 Distributionsdiskette 3.1a" (Bits:30004229, BAGIT-wrapped IMD;
# converted to raw with imd2raw.py, cached at
# scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img).
# Boots to the real "Installations- og Konfigureringsmenu, PICCOLINE Version
# 3.1" -- verified working under PCE 2026-08-18 (same shared ROMs/geometry,
# should load identically here). Same disk used by scripts/rc759_boot_pce.sh
# for a consistent A: across both emulators.
# Any 1,261,568-byte "BINARY" disk from the DDHF/Datamuseum RC759 archive is
# also directly loadable -- e.g. "Digital Research C" (Bits:30002664). See
# rc700-gensmedet/docs/DATAMUSEUM_RC759_ARTIFACTS.md for the full catalogue.
# Override with:  A_DISK=/path/to/disk.img sh scripts/rc759_boot_cpm.sh
#
# TODO (2026-08-18, deferred): this distribution disk's installer supports
# building either a 1-console or 4-console system ("Installer normal
# systemdiskette - 1 konsol" / "- 4 konsoller") -- disk1.img above is the
# un-installed distribution (boots to the installer menu itself), not a
# ready 4-console system. No pre-built 4-console CCP/M-86 disk exists in the
# cached archives yet.
#
# B: an empty, writable scratch disk in the *same* rc759 5.25"-HD geometry.
# It is a MAME floppy image (.mfi), built by converting an E5-filled raw
# rc759 image with floptool (rc759 is a wd177x format, so flopconvert lays
# down fully-formatted tracks -- unlike IMD, which cannot store a blank/
# unformatted disk).  A blank 8" u8dsdd image will NOT load on the rc759's
# 5.25"-HD drive, hence the rc759-geometry conversion here.
#
# Run from anywhere in the workspace:
#   sh scripts/rc759_boot_cpm.sh
#
# MAME is launched windowed so it can always be closed.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
MAME_DIR="$WORKSPACE/mame"
DISKDIR="$MAME_DIR/rc759_sw"
A_DISK="${A_DISK:-$WORKSPACE/scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img}"
# B: defaults to the mandel disk if present (both the Watcom/owcc build
# MANDEL.CMD and the Digital Research C build MANDELDR.CMD -- run as `b:mandel`
# / `b:mandeldr`), else a blank scratch disk.  Author it with
# scripts/rc759_make_mandel_b.sh.  Override with B_DISK=/path/to/disk.mfi.
if [ -n "$B_DISK" ]; then
    :
elif [ -f "$DISKDIR/B_mandel.mfi" ]; then
    B_DISK="$DISKDIR/B_mandel.mfi"
else
    B_DISK="$DISKDIR/B_blank.mfi"
fi
# rc759 lives in the scoped regnecentralen SUBTARGET; the debug (regnecentralend)
# and release (regnecentralen) binaries carry it, the plain "mame" may not.
# Pick the NEWEST validating binary, not the first: a stale binary built BEFORE
# a source fix still passes -validate (which only checks machine-config validity,
# not codegen), so "first that validates" could silently shadow a fixed newer
# build. This exact trap bit us once -- a regnecentralen built 16:15 shadowed the
# WD2797-LOST-DATA fix committed at 19:21 the same day, which only landed in the
# later regnecentralend. Newest-mtime wins, so a fresh rebuild always takes over.
MAME_BIN="${MAME_BIN:-}"
FLOPTOOL="${FLOPTOOL:-$MAME_DIR/floptool}"

mkdir -p "$DISKDIR"

if [ -z "$MAME_BIN" ]; then
    newest=0
    for cand in "$MAME_DIR/regnecentralen" "$MAME_DIR/regnecentralend" "$MAME_DIR/mame"; do
        if [ -x "$cand" ] && "$cand" -validate rc759 >/dev/null 2>&1; then
            mtime=$(stat -f %m "$cand" 2>/dev/null || stat -c %Y "$cand" 2>/dev/null || echo 0)
            if [ "$mtime" -ge "$newest" ]; then
                newest="$mtime"
                MAME_BIN="$cand"
            fi
        fi
    done
fi
if [ -z "$MAME_BIN" ]; then
    echo "ERROR: no MAME binary with the rc759 driver found in $MAME_DIR." >&2
    echo "Build one with e.g.:" >&2
    echo "  cd $MAME_DIR && make SUBTARGET=regnecentralen REGENIE=1 \\" >&2
    echo "    SOURCES=src/mame/regnecentralen/rc759.cpp OSD=sdl -j 10" >&2
    exit 1
fi

if [ ! -f "$A_DISK" ]; then
    echo "ERROR: A: boot disk not found: $A_DISK" >&2
    echo "Set A_DISK=/path/to/rc759-disk.img (a 1,261,568-byte rc759 image)," >&2
    echo "or fetch one from https://datamuseum.dk/bits/30002654 (CDOS systemdisk)." >&2
    exit 1
fi

# Create a blank writable B: image in rc759 5.25"-HD geometry if missing.
if [ ! -f "$B_DISK" ]; then
    echo "Creating blank writable B: image ($B_DISK) ..."
    TMP_IMG="$DISKDIR/.blank759.img"
    # 77 cyl * 2 heads * 8 sectors * 1024 B = 1,261,568 bytes, filled with the
    # CP/M empty-directory byte 0xE5 so floptool identifies it as rc759.
    : >"$TMP_IMG"
    perl -e 'print "\xE5" x 1261568' >"$TMP_IMG"
    "$FLOPTOOL" flopconvert rc759 mfi "$TMP_IMG" "$B_DISK"
    rm -f "$TMP_IMG"
fi

# Stale-binary guard for the mandel B: disk.  B_mandel.mfi is a *build product*
# of scripts/rc759_make_mandel_b.sh: edit mandel.c, rebuild the Watcom compiler
# (wcc.exe) or the cpm86 runtime, or bump MANDEL-DRC.CMD, and the .mfi silently
# goes stale -- MAME would then boot yesterday's program with none the wiser.
# So before launching, verify the .mfi is newer than every input that feeds it;
# if not, refuse and print the exact rebuild command.  This mirrors the
# newest-mtime MAME_BIN rule above: freshness is an mtime comparison, not trust.
# Override (boot the stale disk anyway) with RC759_ALLOW_STALE=1.
mtime_of() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || echo 0; }

if [ "$B_DISK" = "$DISKDIR/B_mandel.mfi" ] && [ "${RC759_ALLOW_STALE:-0}" != 1 ]; then
    OW="$WORKSPACE/open-watcom-v2"
    # Inputs to B_mandel.mfi (only those present are checked):
    #   mandel.c        Watcom source        -> MANDEL.CMD
    #   MANDEL-DRC.CMD  DR C prebuilt         -> MANDELDR.CMD
    #   wcc.exe         the Watcom compiler   (recompiled today to clear ICE 97)
    #   clibs.lib/cstartcpm.obj  cpm86 runtime linked into MANDEL.CMD
    #   rc759_make_mandel_b.sh   the authoring recipe itself
    disk_mtime=$(mtime_of "$B_DISK")
    stale=""
    for input in \
        "$OW/contrib/ravn/owc-drc/mandel.c" \
        "$OW/contrib/ravn/owc-drc/MANDEL-DRC.CMD" \
        "$OW/bld/cc/i86/osxa64/binbuild/wcc.exe" \
        "$OW/lib286/cpm86/clibs.lib" \
        "$OW/lib286/cpm86/cstartcpm.obj" \
        "$WORKSPACE/scripts/rc759_make_mandel_b.sh"; do
        [ -f "$input" ] || continue
        if [ "$(mtime_of "$input")" -gt "$disk_mtime" ]; then
            stale="$stale  $input\n"
        fi
    done
    if [ -n "$stale" ]; then
        echo "ERROR: B: disk is STALE -- $B_DISK is older than its build inputs:" >&2
        printf "$stale" >&2
        echo "Rebuild it before booting:" >&2
        echo "  sh $WORKSPACE/scripts/rc759_make_mandel_b.sh" >&2
        echo "Or boot the stale disk anyway with RC759_ALLOW_STALE=1." >&2
        exit 1
    fi
fi

exec "$MAME_BIN" rc759 \
    -rompath "$MAME_DIR/roms" \
    -flop1 "$A_DISK" \
    -flop2 "$B_DISK" \
    -window \
    -skip_gameinfo \
    -nothrottle
