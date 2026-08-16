#!/usr/bin/env bash
# runticks.sh: Run a CP/M .COM file using z88dk-ticks with built-in BDOS emulation.
#
# Replaces ntvcm for the dcc toolchain.  The z88dk-ticks emulator has a built-in
# CP/M BDOS hook (hook_cpm.c) that fires when PC==7:
#
#   CALL 5 (BDOS entry) -> JP 7 (at address 5) -> hook fires at PC==7 -> RET
#
# Supported BDOS functions: 1 (console in), 2 (console out), 6 (raw I/O),
# 9 (print string), 11 (console status), 12 (BDOS version), 14 (select drive),
# 15-16 (open/close), 19-23 (file ops), 25 (get drive), 33-35 (random I/O).
# File I/O uses the host filesystem (current directory, lowercase names on
# case-sensitive hosts; macOS case-insensitive = works transparently).
#
# Exit: dcc programs exit with JP 0x0000 (CP/M warm boot).  The -end 0 flag
# tells ticks to stop when PC reaches 0x0000.
#
# T-states: pass -m / --measure to get the T-state count on the last line of
# stdout (suitable for `tail -1` capture).  Without -m, no T-state line is
# emitted so correctness output matches baselines exactly.
#
# Usage:
#   runticks.sh [-m|--measure] COM_FILE [args...]
#   runticks.sh [-m|--measure] COM_FILE arg1 arg2 ...
#
# Environment:
#   TICKS   path to z88dk-ticks (default: <workspace>/z88dk/bin/z88dk-ticks,
#           where <workspace> is this script's parent dir, dcc-bench/..)
#   RUNTICKS_TIMEOUT  max T-states before forced exit (default: 4000000000)

set -euo pipefail

_RUNTICKS_DIR="$(cd "$(dirname "$0")" && pwd)"
TICKS="${TICKS:-$(cd "$_RUNTICKS_DIR/.." && pwd)/z88dk/bin/z88dk-ticks}"
RUNTICKS_TIMEOUT="${RUNTICKS_TIMEOUT:-4000000000}"

# Parse flags
MEASURE=0
while [ $# -gt 0 ]; do
    case "$1" in
        -m|--measure) MEASURE=1; shift ;;
        --) shift; break ;;
        -*) echo "runticks.sh: unknown flag $1" >&2; exit 1 ;;
        *) break ;;
    esac
done

if [ $# -lt 1 ]; then
    echo "usage: runticks.sh [-m|--measure] COM_FILE [args...]" >&2
    exit 1
fi

COM_FILE="$1"; shift
# Remaining args are the program's command-line arguments
PROG_ARGS="${*:-}"

# Build the combined memory image: 256-byte CP/M stub + .COM at 0x0100.
TMPIMG=$(mktemp /tmp/cpm_XXXXXX.bin)
trap 'rm -f "$TMPIMG"' EXIT

python3 - "$COM_FILE" "$PROG_ARGS" "$TMPIMG" <<'PYEOF'
import sys

com_path  = sys.argv[1]
args_str  = sys.argv[2]   # program args (after program name), may be empty
out_path  = sys.argv[3]

# 65536-byte image, initialised to zero.
mem = bytearray(65536)

# --- CP/M page-zero stub (0x0000 – 0x00FF) ---
#
# 0x0005-0x0007: JP 0x0007
#   mem[5]=0xC3, mem[6]=0x07, mem[7]=0x00  (JP target = 0x0007)
#   At PC==7 ticks fires hook_cpm() using the C register as the BDOS
#   function number.  mem[7]=0x00 executes as NOP; the RET at 0x0008
#   then returns to the CALL 5 caller.
mem[0x0005] = 0xC3   # JP lo
mem[0x0006] = 0x07   # target lo = 7
mem[0x0007] = 0x00   # target hi = 0  (also a NOP when executed at addr 7)
mem[0x0008] = 0xC9   # RET — returns to caller after hook

# --- Command tail at 0x0080 ---
# CP/M convention: byte at 0x80 = length, bytes 0x81... = ' ' + args, 0x0D terminator.
if args_str:
    tail = (' ' + args_str).encode('ascii', errors='replace')
else:
    tail = b' '
tail_bytes = tail[:126]          # CP/M max 127 chars including leading space
mem[0x0080] = len(tail_bytes)
mem[0x0081:0x0081 + len(tail_bytes)] = tail_bytes
mem[0x0081 + len(tail_bytes)] = 0x0D   # CR terminator

# --- .COM file at 0x0100 ---
with open(com_path, 'rb') as f:
    com_data = f.read()
mem[0x0100:0x0100 + len(com_data)] = com_data

with open(out_path, 'wb') as f:
    f.write(mem)
PYEOF

# Run via z88dk-ticks:
#   -pc 100   start executing at 0x0100 (CP/M TPA)
#   -end 0    exit when PC reaches 0x0000 (JP 0 warm-boot)
#   -counter N  (measure mode only) emit T-state count on last stdout line
if [ "$MEASURE" -eq 1 ]; then
    "$TICKS" -pc 100 -end 0 -counter "$RUNTICKS_TIMEOUT" "$TMPIMG" 2>/dev/null
else
    "$TICKS" -pc 100 -end 0 "$TMPIMG" 2>/dev/null
fi
