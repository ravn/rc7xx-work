#!/bin/sh
# Wrapper til RC759 RTM-service-tabel trace (#16)
# Kræver: mame/regnecentralend + rc759 ROMs + boot-disk
set -e

MAME_DIR=/Users/ravn/z80/mame
DISK=/Users/ravn/z80/scratch/rc759-pce/images/sw1400_r31a_d1.img
RESULT=/Users/ravn/z80/scratch/tmp/rtm_trace_result.txt
LUA=/Users/ravn/z80/scratch/tmp/rtm_svc_trace.lua
LOG=/Users/ravn/z80/scratch/tmp/rtm_trace_output.txt

# Ryd NVRAM for at tvinge autoboot (uden dette lander vi i ROM-monitor)
rm -f "$MAME_DIR/nvram/rc759/nvram"
echo "NVRAM ryddet — tvinger autoboot"

cd "$MAME_DIR"
./regnecentralend rc759 \
    -bios 0 \
    -skip_gameinfo \
    -rompath roms \
    -flop1 "$DISK" \
    -autoboot_script "$LUA" \
    -seconds_to_run 500 \
    -nothrottle \
    -sound none \
    -window \
    -nomax \
    2>&1 | tee "$LOG"

echo ""
echo "MAME stdout: $LOG"
echo "Lua resultat: $RESULT"
if [ -f "$RESULT" ]; then
    echo "--- RESULTAT ---"
    cat "$RESULT"
else
    echo "FEJL: $RESULT ikke genereret af Lua"
fi
