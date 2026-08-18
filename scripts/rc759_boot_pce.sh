#!/bin/sh
# rc759_boot_pce.sh -- launch PCE/rc759 (Piccoline) with a CP/M-86 boot disk.
#
# PCE counterpart to rc759_boot_cpm.sh (MAME). Same A_DISK/B_DISK env-var
# interface so the two can be driven identically -- see rc759_boot.sh for a
# thin dispatcher that picks between them.
#
# A: boot disk. Same rc759 5.25"-HD raw geometry as the MAME script (77 cyl x
# 2 heads x 8 sectors x 1024 B = 1,261,568 bytes). Default is a genuine
# CCP/M-86 disk (NOT CDOS, which is a later, different successor OS) --
# disk1 of "SW1400 CCP/M-86 Distributionsdiskette 3.1a" (Bits:30004229,
# BAGIT-wrapped IMD; converted to raw with imd2raw.py, cached at
# scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img).
# Boots to the real "Installations- og Konfigureringsmenu, PICCOLINE Version
# 3.1" -- verified 2026-08-18. Override with A_DISK=/path/to/disk.img.
#
# TODO (2026-08-18, deferred): this distribution disk's installer supports
# building either a 1-console or a 4-console system (its own menu strings:
# "Installer normal systemdiskette - 1 konsol" / "- 4 konsoller") -- the
# disk1.img above is the un-installed distribution, so it boots into that
# installer menu, not a ready-to-use 4-console system. No pre-built
# 4-console CCP/M-86 boot disk exists in the cached archives yet; producing
# one means actually running the installer's "4 konsoller" option through to
# completion. Neither script does that today -- both boot the plain
# distribution disk as-is.
#
# B: a writable scratch disk in the same geometry, rebuilt fresh on every run
# by default (set B_DISK=/path/to/keep.img to reuse one instead). Unlike
# MAME, PCE's disk backend reads/writes raw .img sector-addressable images
# directly -- no floptool/.mfi conversion needed, a plain 0xE5-filled raw
# image boots as a valid blank CP/M diskette as-is.
#
# ROM: defaults to the newest verified BIOS in mame/roms/rc759/ (shared ROM
# dumps -- PCE and MAME use the identical PROM images). Override with
# ROM=/path/to/rc759-x-y.z.rom.
#
# Run from anywhere in the workspace:
#   sh scripts/rc759_boot_pce.sh
# Type "gem" etc. directly into the PCE window -- it's a live X11/SDL
# terminal, same as a real keyboard. See tasks/memory/reference_pce_rc759_headless_automation.md
# for how to drive it non-interactively (script input, disk swap, screenshots).

set -e

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
PCE_DIR="$WORKSPACE/pce"
PCE_BIN="$PCE_DIR/src/arch/rc759/pce-rc759"
CACHE="$WORKSPACE/scratch/rc759-cmd-toolchain/ddhf-cache/bits"
WORKDIR="${RC759_PCE_WORKDIR:-$(mktemp -d /tmp/rc759-pce.XXXXXX)}"

A_DISK="${A_DISK:-$WORKSPACE/scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img}"
ROM="${ROM:-}"

mkdir -p "$WORKDIR"

if [ ! -x "$PCE_BIN" ]; then
    echo "ERROR: pce-rc759 not built. Build it with:" >&2
    echo "  cd $PCE_DIR && ./configure --with-sdl && make" >&2
    exit 1
fi

if [ ! -f "$A_DISK" ]; then
    echo "ERROR: A: boot disk not found: $A_DISK" >&2
    echo "Set A_DISK=/path/to/rc759-disk.img (a 1,261,568-byte rc759 image)," >&2
    echo "or fetch one: curl -sL -o $CACHE/30002654.bin https://datamuseum.dk/bits/30002654" >&2
    exit 1
fi

if [ -z "$ROM" ]; then
    for cand in "$WORKSPACE/mame/roms/rc759/rc759-1-5.1.rom" \
                "$WORKSPACE/mame/roms/rc759/rc759-1-2.1.rom"; do
        if [ -f "$cand" ]; then
            ROM="$cand"
            break
        fi
    done
fi
if [ -z "$ROM" ] || [ ! -f "$ROM" ]; then
    echo "ERROR: no rc759 PROM image found. Set ROM=/path/to/rc759-x-y.z.rom" >&2
    echo "(shared with MAME: mame/roms/rc759/)." >&2
    exit 1
fi

# B: a blank, writable scratch disk in rc759 raw geometry. PCE reads/writes
# raw .img directly (no floptool/.mfi step, unlike MAME) -- an 0xE5-filled
# image (the CP/M empty-directory byte) is a valid blank formatted diskette
# as-is.
if [ -z "$B_DISK" ]; then
    B_DISK="$WORKDIR/fd1.img"
fi
if [ ! -f "$B_DISK" ]; then
    echo "Creating blank writable B: image ($B_DISK) ..."
    perl -e 'print "\xE5" x 1261568' >"$B_DISK"
fi

CFG="$WORKDIR/pce-rc759.cfg"
cat >"$CFG" <<EOF
system {
	clock = 6000000
	alt_mem_size = 0
	nvm = "$WORKDIR/nvm.dat"
	sanitize_nvm = 1
	parport1 = "stdio:file=$WORKDIR/parport1.out:flush=1"
	parport2 = "stdio:file=$WORKDIR/parport2.out:flush=1"
}

video {
	mono = 0
	hires = 0
	min_h = 0
}

ram { address = 0; size = 256K; default = 0x00 }
ram { address = 0xd0000; size = 32K }

rom { address = 0xf0000; size = 64K; default = 0xff }

load {
	format  = "binary"
	address = 0xf8000
	file    = "$ROM"
}

terminal {
	driver = "x11"
	scale = 1
	aspect_x = 4
	aspect_y = 3
	min_w = 512
	min_h = 384
}

speaker {
	volume = 500
	sample_rate = 44100
	driver = "null"
}

fdc {
	file0 = "$WORKDIR/fd0.pbit"
	file1 = "$WORKDIR/fd1.pbit"
}

disk { drive = 0; optional = 1; type = "auto"; file = "$A_DISK" }
disk { drive = 1; optional = 1; type = "auto"; file = "$B_DISK" }
EOF

echo "A: $A_DISK"
echo "B: $B_DISK"
echo "ROM: $ROM"
echo "workdir: $WORKDIR"

exec "$PCE_BIN" -c "$CFG" -t x11 -r
