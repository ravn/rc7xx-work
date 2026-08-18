#!/bin/sh
# rc759_boot.sh -- uniform entry point for booting RC759 CP/M-86 under
# either MAME or PCE, with the same A_DISK/B_DISK env-var interface.
#
# Usage:
#   sh scripts/rc759_boot.sh mame [A_DISK=... B_DISK=...]
#   sh scripts/rc759_boot.sh pce  [A_DISK=... B_DISK=... ROM=...]
#
# Or set EMULATOR=mame|pce and call with no argument. Defaults to pce (no
# ROM-fetch/build dance needed once built once; MAME needs the regnecentralen
# SUBTARGET binary, see rc759_boot_cpm.sh).
#
# Delegates entirely to rc759_boot_cpm.sh (MAME) / rc759_boot_pce.sh (PCE) --
# see those for emulator-specific detail and the disk-format notes
# (MAME needs .mfi for a blank B:, PCE takes raw .img directly).

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

WHICH="${1:-${EMULATOR:-pce}}"

case "$WHICH" in
    mame)
        exec sh "$WORKSPACE/scripts/rc759_boot_cpm.sh"
        ;;
    pce)
        exec sh "$WORKSPACE/scripts/rc759_boot_pce.sh"
        ;;
    *)
        echo "usage: $0 {mame|pce}" >&2
        echo "  or:  EMULATOR={mame|pce} $0" >&2
        exit 1
        ;;
esac
