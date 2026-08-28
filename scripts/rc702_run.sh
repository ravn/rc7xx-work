#!/bin/sh
# rc702_run.sh -- build an rc702 (RC700 CP/M 2.2, Z80) B: disk from a list of
# host files and boot MAME.  The disk is rebuilt only when the output MFI is
# older than one of the source files (make-style freshness check).
#
# Usage:
#   sh scripts/rc702_run.sh [OPTIONS] [FILE[:CPMNAME] ...]
#
# Each FILE[:CPMNAME] argument copies a host file onto the B: disk.
# CPMNAME defaults to uppercase basename(FILE).  Examples:
#   autoload.rom:AUTOLOAD.ROM
#   build/BIOS.COM
#   /tmp/test.com:TEST.COM
#
# Options:
#   --out PATH     Output MFI path (default: mame/rc702_sw/B_custom.mfi)
#   --disk PATH    Use an existing MFI as-is; skip building entirely
#   --a-disk PATH  Override the A: boot disk (default: SW1711-I8.imd)
#   --force        Rebuild disk even if already up to date
#   --no-boot      Build (or check) disk but do not launch MAME
#   --dry-run      Print what would happen; do nothing
#   --nothrottle   Pass -nothrottle to MAME (useful for unattended tests)
#   --seconds N    Pass -seconds_to_run N (headless / CI mode)
#   --sound none   Pass -sound none
#   --             Stop option parsing; remaining tokens passed to MAME verbatim
#
# Quick examples:
#   sh scripts/rc702_run.sh                                 # boot with default B:
#   sh scripts/rc702_run.sh BIOS.COM TEST.COM               # build disk + boot
#   sh scripts/rc702_run.sh --disk mame/rc702_sw/B_my.mfi   # use existing MFI
#   sh scripts/rc702_run.sh --force BIOS.COM                # force rebuild
#   sh scripts/rc702_run.sh --no-boot BIOS.COM              # build only
#
# Disk geometry:
#   RC702 8" DS/DD: 77 cyl × 2 heads × 15 sectors × 512 B = 1,184,640 bytes
#   cpmtools diskdef: rc702-8dd.  MAME format: u8dsdd.
#   Diskdefs location: rc700-gensmedet/rcbios/diskdefs
#
# A: disk:
#   Default is SW1711-I8.imd (RC700 CP/M 2.2 system disk, from the firmware
#   workspace).  Fetched from rc700-gensmedet if absent.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
MAME_DIR="$WORKSPACE/mame"
DISKDIR="$MAME_DIR/rc702_sw"
DISKDEFS="$WORKSPACE/rc700-gensmedet/rcbios/diskdefs"
FLOPTOOL="${FLOPTOOL:-$MAME_DIR/floptool}"
MKFS="${MKFS:-$(command -v mkfs.cpm 2>/dev/null || echo "$HOME/.local/bin/mkfs.cpm")}"
CPMCP="${CPMCP:-$(command -v cpmcp 2>/dev/null || echo "$HOME/.local/bin/cpmcp")}"

# ---- defaults ----
A_DISK="${A_DISK:-$DISKDIR/SW1711-I8.imd}"
OUT_MFI="$DISKDIR/B_custom.mfi"
FIXED_DISK=""
FORCE=0; NO_BOOT=0; DRY_RUN=0; NOTHROTTLE=1   # rc702 defaults to nothrottle
SECONDS_TO_RUN=""; SOUND=""
EXTRA_MAME=""
HOSTFILES=""

# ---- parse arguments ----
while [ $# -gt 0 ]; do
    case "$1" in
        --out)          OUT_MFI="$2";        shift 2 ;;
        --disk)         FIXED_DISK="$2";     shift 2 ;;
        --a-disk)       A_DISK="$2";         shift 2 ;;
        --force)        FORCE=1;             shift ;;
        --no-boot)      NO_BOOT=1;           shift ;;
        --dry-run)      DRY_RUN=1;           shift ;;
        --nothrottle)   NOTHROTTLE=1;        shift ;;
        --throttle)     NOTHROTTLE=0;        shift ;;
        --seconds)      SECONDS_TO_RUN="$2"; shift 2 ;;
        --sound)        SOUND="$2";          shift 2 ;;
        --)             shift; EXTRA_MAME="$*"; break ;;
        --*)            echo "unknown option: $1" >&2; exit 1 ;;
        *)              HOSTFILES="$HOSTFILES $1"; shift ;;
    esac
done

mkdir -p "$DISKDIR"

# ---- fetch A: disk if needed ----
if [ ! -f "$A_DISK" ] && [ "$A_DISK" = "$DISKDIR/SW1711-I8.imd" ]; then
    RC700GS="https://raw.githubusercontent.com/ravn/rc700-gensmedet/main"
    echo "==> fetching RC702 boot disk SW1711-I8.imd ..."
    [ "$DRY_RUN" = 0 ] && curl -fsSL "$RC700GS/autoload-in-c/test-disks/SW1711-I8.imd" -o "$A_DISK"
fi
[ -f "$A_DISK" ] || [ "$DRY_RUN" = 1 ] || { echo "ERROR: A: disk not found: $A_DISK" >&2; exit 1; }

# ---- select B: disk path ----
if [ -n "$FIXED_DISK" ]; then
    B_DISK="$FIXED_DISK"
    [ -f "$B_DISK" ] || { echo "ERROR: --disk not found: $B_DISK" >&2; exit 1; }
elif [ -n "$HOSTFILES" ]; then
    B_DISK="$OUT_MFI"
else
    for cand in "$OUT_MFI" "$DISKDIR/B_blank.mfi"; do
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
        echo "==> building rc702 B: disk -> $OUT_MFI"
        STAGE="$(mktemp -d)"
        trap 'rm -rf "$STAGE"' EXIT
        cp "$DISKDEFS" "$STAGE/diskdefs"
        cd "$STAGE"
        if [ "$DRY_RUN" = 0 ]; then
            "$MKFS" -f rc702-8dd B.img
        fi
        for entry in $HOSTFILES; do
            src="${entry%%:*}"; cpmname="${entry##*:}"
            [ "$cpmname" = "$entry" ] && cpmname="$(basename "$src" | tr '[:lower:]' '[:upper:]')"
            echo "    $src -> 0:$cpmname"
            if [ "$DRY_RUN" = 0 ]; then
                abs="$src"; [ "${abs#/}" = "$abs" ] && abs="$WORKSPACE/$src"
                [ -f "$abs" ] || abs="$src"
                "$CPMCP" -f rc702-8dd B.img "$abs" "0:$cpmname"
            fi
        done
        if [ "$DRY_RUN" = 0 ]; then
            "$FLOPTOOL" flopconvert u8dsdd mfi B.img "$OUT_MFI" >/dev/null
            echo "    -> $OUT_MFI"
        else
            echo "    [dry-run] flopconvert u8dsdd mfi -> $OUT_MFI"
        fi
        cd "$WORKSPACE"
    else
        echo "==> B: disk up to date: $OUT_MFI"
    fi
fi

# ---- create blank B: if still missing ----
if [ ! -f "$B_DISK" ] && [ "$DRY_RUN" = 0 ]; then
    echo "==> creating blank rc702 B: disk ($B_DISK)"
    "$FLOPTOOL" flopcreate mfi u8dsdd "$B_DISK"
fi

[ "$NO_BOOT" = 1 ] || [ "$DRY_RUN" = 1 ] && {
    [ "$DRY_RUN" = 1 ] && echo "[dry-run] would boot rc702  A=$A_DISK  B=$B_DISK"
    exit 0
}

# ---- pick MAME binary ----
MAME_BIN="${MAME_BIN:-$MAME_DIR/mame}"
[ -x "$MAME_BIN" ] || {
    echo "ERROR: MAME binary not found: $MAME_BIN" >&2
    echo "  Build MAME in $MAME_DIR, or set MAME_BIN=/path/to/mame." >&2
    exit 1
}

# ---- launch ----
echo "==> rc702: A=$(basename "$A_DISK")  B=$(basename "$B_DISK")  [$MAME_BIN]"
MAME_ARGS="-rompath $MAME_DIR/roms -flop1 $A_DISK -flop2 $B_DISK -window -skip_gameinfo"
[ -n "$SOUND" ]          && MAME_ARGS="$MAME_ARGS -sound $SOUND"
[ "$NOTHROTTLE" = 1 ]    && MAME_ARGS="$MAME_ARGS -nothrottle"
[ -n "$SECONDS_TO_RUN" ] && MAME_ARGS="$MAME_ARGS -seconds_to_run $SECONDS_TO_RUN"
[ -n "$EXTRA_MAME" ]     && MAME_ARGS="$MAME_ARGS $EXTRA_MAME"
# shellcheck disable=SC2086
exec "$MAME_BIN" rc702 $MAME_ARGS
