#!/bin/sh
# rc702_boot_cpm.sh -- fetch a CP/M boot disk and launch MAME rc702.
#
# Lives in the rc7xx-work top-level repo; drives the mame/ submodule.
#
# ROMs (roa375.ic66, roa296.rom, roa327.rom) are assumed already present in
# mame/roms/rc702/ under the MAME rompath.
#
# The boot disk (SW1711-I8.imd) is an 8" DS/DD RC700 CP/M 2.2 system disk
# with 1-based sector IDs (real-hardware / MAME convention).  It is fetched
# from the rc702 firmware workspace:
#   https://github.com/ravn/rc700-gensmedet
# Do NOT use the jbox disk images -- they have 0-based sector IDs and will
# not boot under MAME.
#
# Run from anywhere in the workspace:
#   sh scripts/rc702_boot_cpm.sh
#
# MAME is launched windowed so it can always be closed.

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
MAME_DIR="$WORKSPACE/mame"
DISKDIR="$MAME_DIR/rc702_sw"
DISK="$DISKDIR/SW1711-I8.imd"
RC700GS="https://raw.githubusercontent.com/ravn/rc700-gensmedet/main"
MAME_BIN="${MAME_BIN:-$MAME_DIR/mame}"

mkdir -p "$DISKDIR"

if [ ! -f "$DISK" ]; then
    echo "Fetching SW1711-I8.imd ..."
    curl -fsSL "$RC700GS/autoload-in-c/test-disks/SW1711-I8.imd" -o "$DISK"
fi

exec "$MAME_BIN" rc702 \
    -rompath "$MAME_DIR/roms" \
    -flop1 "$DISK" \
    -window \
    -skip_gameinfo
