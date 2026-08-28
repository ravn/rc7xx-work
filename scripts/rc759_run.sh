#!/bin/sh
# rc759_run.sh -- build an rc759 (Piccoline, CP/M-86) B: disk from a list of
# host files and boot MAME.  The disk is rebuilt only when the output MFI is
# older than one of the source files (make-style freshness check).
#
# Usage:
#   sh scripts/rc759_run.sh [OPTIONS] [FILE[:CPMNAME] ...]
#
# Each FILE[:CPMNAME] argument copies a host file onto the B: disk.
# CPMNAME defaults to uppercase basename(FILE).  Examples:
#   UNZIP.CMD                         -> 0:UNZIP.CMD
#   out/prog.cmd:PROG.CMD             -> 0:PROG.CMD
#   /tmp/data.zip:DATA.ZIP            -> 0:DATA.ZIP
#
# Options:
#   --out PATH     Output MFI path (default: mame/rc759_sw/B_custom.mfi)
#   --disk PATH    Use an existing MFI as-is; skip building entirely
#   --a-disk PATH  Override the A: boot disk
#   --force        Rebuild disk even if already up to date
#   --no-boot      Build (or check) disk but do not launch MAME
#   --dry-run      Print what would happen; do nothing
#   --nothrottle   Pass -nothrottle to MAME
#   --seconds N    Pass -seconds_to_run N (headless / CI mode)
#   --sound none   Pass -sound none (recommended for unattended runs)
#   --             Stop option parsing; remaining tokens passed to MAME verbatim
#
# Quick examples:
#   sh scripts/rc759_run.sh                                 # boot with default B:
#   sh scripts/rc759_run.sh UNZIP.CMD test.zip:TEST.ZIP     # build disk + boot
#   sh scripts/rc759_run.sh --disk mame/rc759_sw/B_mandel.mfi   # use existing MFI
#   sh scripts/rc759_run.sh --force UNZIP.CMD               # force rebuild
#   sh scripts/rc759_run.sh --no-boot UNZIP.CMD             # build only, no MAME
#
# Disk geometry:
#   RC759 "Piccoline" 5.25" DS-HD: 77 cyl × 2 heads × 8 sectors × 1024 B
#   = 1,261,568 bytes raw.  cpmtools diskdef: rc759-drc.  MAME format: rc759.
#   Diskdefs location: scratch/rc759-cmd-toolchain/diskdefs

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
MAME_DIR="$WORKSPACE/mame"
DISKDIR="$MAME_DIR/rc759_sw"
DISKDEFS="$WORKSPACE/scratch/rc759-cmd-toolchain/diskdefs"
FLOPTOOL="${FLOPTOOL:-$MAME_DIR/floptool}"
MKFS="${MKFS:-$(command -v mkfs.cpm 2>/dev/null || echo "$HOME/.local/bin/mkfs.cpm")}"
CPMCP="${CPMCP:-$(command -v cpmcp 2>/dev/null || echo "$HOME/.local/bin/cpmcp")}"

# ---- defaults ----
A_DISK="${A_DISK:-$WORKSPACE/scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img}"
OUT_MFI="$DISKDIR/B_custom.mfi"
FIXED_DISK=""
FORCE=0; NO_BOOT=0; DRY_RUN=0; NOTHROTTLE=0
SECONDS_TO_RUN=""; SOUND=""
EXTRA_MAME=""
HOSTFILES=""   # accumulated "hostpath:cpmname" tokens

# ---- parse arguments ----
while [ $# -gt 0 ]; do
    case "$1" in
        --out)        OUT_MFI="$2";        shift 2 ;;
        --disk)       FIXED_DISK="$2";     shift 2 ;;
        --a-disk)     A_DISK="$2";         shift 2 ;;
        --force)      FORCE=1;             shift ;;
        --no-boot)    NO_BOOT=1;           shift ;;
        --dry-run)    DRY_RUN=1;           shift ;;
        --nothrottle) NOTHROTTLE=1;        shift ;;
        --seconds)    SECONDS_TO_RUN="$2"; shift 2 ;;
        --sound)      SOUND="$2";          shift 2 ;;
        --)           shift; EXTRA_MAME="$*"; break ;;
        --*)          echo "unknown option: $1" >&2; exit 1 ;;
        *)            HOSTFILES="$HOSTFILES $1"; shift ;;
    esac
done

mkdir -p "$DISKDIR"

# ---- select B: disk path ----
if [ -n "$FIXED_DISK" ]; then
    B_DISK="$FIXED_DISK"
    [ -f "$B_DISK" ] || { echo "ERROR: --disk not found: $B_DISK" >&2; exit 1; }
elif [ -n "$HOSTFILES" ]; then
    B_DISK="$OUT_MFI"
else
    # no files given: use OUT_MFI if it exists, else B_mandel, else B_blank
    for cand in "$OUT_MFI" "$DISKDIR/B_mandel.mfi" "$DISKDIR/B_blank.mfi"; do
        if [ -f "$cand" ]; then B_DISK="$cand"; break; fi
    done
    : "${B_DISK:=$DISKDIR/B_blank.mfi}"
fi

# ---- build disk if files were given and we are not using a fixed disk ----
_build_needed() {
    [ "$FORCE" = 1 ] && return 0
    [ ! -f "$OUT_MFI" ] && return 0
    disk_mt=$(stat -f %m "$OUT_MFI" 2>/dev/null || stat -c %Y "$OUT_MFI" 2>/dev/null || echo 0)
    for entry in $HOSTFILES; do
        src="${entry%%:*}"
        [ -f "$src" ] || { echo "ERROR: source file not found: $src" >&2; exit 1; }
        src_mt=$(stat -f %m "$src" 2>/dev/null || stat -c %Y "$src" 2>/dev/null || echo 0)
        [ "$src_mt" -gt "$disk_mt" ] && return 0
    done
    return 1
}

if [ -n "$HOSTFILES" ] && [ -z "$FIXED_DISK" ]; then
    if _build_needed; then
        echo "==> building rc759 B: disk -> $OUT_MFI"
        STAGE="$(mktemp -d)"
        trap 'rm -rf "$STAGE"' EXIT
        cp "$DISKDEFS" "$STAGE/diskdefs"
        cd "$STAGE"
        if [ "$DRY_RUN" = 0 ]; then
            "$MKFS" -f rc759-drc B.img
        fi
        for entry in $HOSTFILES; do
            src="${entry%%:*}"; cpmname="${entry##*:}"
            [ "$cpmname" = "$entry" ] && cpmname="$(basename "$src" | tr '[:lower:]' '[:upper:]')"
            echo "    $src -> 0:$cpmname"
            if [ "$DRY_RUN" = 0 ]; then
                # resolve relative paths from workspace
                abs="$src"; [ "${abs#/}" = "$abs" ] && abs="$WORKSPACE/$src"
                [ -f "$abs" ] || abs="$src"
                "$CPMCP" -f rc759-drc B.img "$abs" "0:$cpmname"
            fi
        done
        if [ "$DRY_RUN" = 0 ]; then
            cur=$(stat -f %z B.img 2>/dev/null || stat -c %s B.img)
            [ "$cur" -lt 1261568 ] && perl -e "print \"\\xE5\" x (1261568-$cur)" >> B.img
            "$FLOPTOOL" flopconvert rc759 mfi B.img "$OUT_MFI" >/dev/null
            echo "    -> $OUT_MFI"
        else
            echo "    [dry-run] pad+flopconvert rc759 mfi -> $OUT_MFI"
        fi
        cd "$WORKSPACE"
    else
        echo "==> B: disk up to date: $OUT_MFI"
    fi
fi

# ---- create blank B: if still missing ----
if [ ! -f "$B_DISK" ] && [ "$DRY_RUN" = 0 ]; then
    echo "==> creating blank rc759 B: disk ($B_DISK)"
    TMP="$(mktemp)"
    perl -e 'print "\xE5" x 1261568' > "$TMP"
    "$FLOPTOOL" flopconvert rc759 mfi "$TMP" "$B_DISK" >/dev/null
    rm -f "$TMP"
fi

[ -f "$A_DISK" ] || { echo "ERROR: A: disk not found: $A_DISK" >&2; exit 1; }

[ "$NO_BOOT" = 1 ] || [ "$DRY_RUN" = 1 ] && {
    [ "$DRY_RUN" = 1 ] && echo "[dry-run] would boot rc759  A=$A_DISK  B=$B_DISK"
    exit 0
}

# ---- pick newest valid MAME binary ----
MAME_BIN="${MAME_BIN:-}"
if [ -z "$MAME_BIN" ]; then
    newest=0
    for c in "$MAME_DIR/regnecentralend" "$MAME_DIR/regnecentralen" "$MAME_DIR/mame"; do
        if [ -x "$c" ] && "$c" -validate rc759 >/dev/null 2>&1; then
            mt=$(stat -f %m "$c" 2>/dev/null || stat -c %Y "$c" 2>/dev/null || echo 0)
            [ "$mt" -ge "$newest" ] && { newest=$mt; MAME_BIN=$c; }
        fi
    done
fi
[ -n "$MAME_BIN" ] || {
    echo "ERROR: no MAME binary with rc759 driver found in $MAME_DIR." >&2
    echo "  Build: cd $MAME_DIR && make SUBTARGET=regnecentralen REGENIE=1 \\" >&2
    echo "    SOURCES=src/mame/regnecentralen/rc759.cpp OSD=sdl -j10" >&2
    exit 1
}

# ---- launch ----
echo "==> rc759: A=$(basename "$A_DISK")  B=$(basename "$B_DISK")  [$MAME_BIN]"
MAME_ARGS="-rompath $MAME_DIR/roms -flop1 $A_DISK -flop2 $B_DISK -window -skip_gameinfo"
[ -n "$SOUND" ]          && MAME_ARGS="$MAME_ARGS -sound $SOUND"
[ "$NOTHROTTLE" = 1 ]    && MAME_ARGS="$MAME_ARGS -nothrottle"
[ -n "$SECONDS_TO_RUN" ] && MAME_ARGS="$MAME_ARGS -seconds_to_run $SECONDS_TO_RUN"
[ -n "$EXTRA_MAME" ]     && MAME_ARGS="$MAME_ARGS $EXTRA_MAME"
# shellcheck disable=SC2086
exec "$MAME_BIN" rc759 $MAME_ARGS
