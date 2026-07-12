#!/usr/bin/env python3
"""Run a CP/M .COM under z88dk-ticks (cycle-accurate) with a minimal BDOS stub.

Why: ntvcm's cycle counts are grossly wrong for prefixed (DD/FD/ED) opcodes
(e.g. `inc (ix+d)` counted as 6 T-states instead of 23, `ld bc,(nn)` as 8
instead of 20), so it cannot be trusted for Z80 cycle comparisons.  z88dk-ticks
is cycle-accurate (matches textbook T-states exactly) but is a bare Z80 with no
CP/M BDOS, so a plain CP/M .COM that prints via `call 5` cannot run to
completion on it.

This wraps ticks with a tiny BDOS stub injected at 0xF000 (reached via a `jp` at
0x0005) that services the BDOS calls a compute-and-print benchmark needs:
  C=0    system reset       exit
  C=2    conout             output E
  C=6    direct console IO  output E if E!=0xFF (input side returns 0)
  C=9    print string       output (DE..) until '$'
  C=12   return version     report CP/M 2.2 (HL=0x0022, A=0x22, B=0)
  C=108  CP/M3 P_RETCODE    dummy: echoes the return code (DE) to us as
                            "[108 rc=0xNNNN]", then returns

Any OTHER BDOS function is FATAL: the stub executes an illegal opcode (ED FF, a
semantic trap) and writes the sentinel 0xDEAD + the offending function number to
0xFFF0..0xFFF2.  ticks silently ignores illegal opcodes (no diagnostic, no exit
status), so this wrapper detects the fatal condition by reading ticks' RAM dump
(-output) and returns a non-zero status.  This guarantees a program that needs
an unimplemented BDOS call fails loudly instead of producing a wrong result or
bogus timing.

Program exit via `ret`/`jp 0`/BDOS fn 0 lands on a HALT at 0x0000; `-end 0x0000`
stops the emulator there.  Console output goes to a byte port serviced by ticks'
`-iochar 0`, i.e. to stdout.

Usage:  ticks_cpm.py [-q] <file.com>
Prints the program's console output to stdout, then one line to stderr:
  [ticks] <N> cycles
On an unsupported BDOS call, prints a fatal line to stderr and exits non-zero.
-q suppresses the cycle line on stderr.

The stub below is a pre-assembled position-dependent blob (org 0xF000) built from
bdos_stub.s in this directory.  To regenerate:
  clang --target=z80 -c bdos_stub.s -o /tmp/s.o
  ld.lld -Ttext=0xF000 -e _start /tmp/s.o -o /tmp/s.elf
  llvm-objcopy -O binary /tmp/s.elf /tmp/s.bin
  python3 -c "print(','.join(map(str,open('/tmp/s.bin','rb').read())))"
"""
import sys, os, subprocess, tempfile

TICKS = os.environ.get("Z88DK_TICKS", "/Users/ravn/z80/z88dk/bin/z88dk-ticks")
IOPORT = 0  # OUT (0),A -> stdout via -iochar 0

# Pre-assembled BDOS stub, org 0xF000 (position-dependent: MUST load at 0xF000).
# Handles: 0=exit, 2=conout, 6=direct-conout, 9=print-string, 11=console-status,
#          12=version, 13=disk-reset(nop), 14=select-disk(nop,A=0),
#          25=get-current-disk(A=0), 26=set-dma(nop), 108=P_RETCODE.
# To regenerate:
#   clang --target=z80 -c bdos_stub.s -o /tmp/s.o
#   ld.lld -Ttext=0xF000 -e _start /tmp/s.o -o /tmp/s.elf
#   llvm-objcopy -O binary /tmp/s.elf /tmp/s.bin
#   python3 -c "print(','.join(map(str,open('/tmp/s.bin','rb').read())))"
STUB = bytes([121,183,202,158,240,254,2,40,38,254,6,40,38,254,9,40,41,254,11,40,46,254,12,40,47,254,13,40,40,254,14,40,37,254,25,40,33,254,26,40,28,254,108,40,34,24,92,123,211,0,201,123,254,255,200,211,0,201,26,254,36,200,211,0,19,24,247,175,201,201,175,201,46,34,38,0,68,125,201,33,128,240,126,183,40,5,211,0,35,24,247,122,205,108,240,123,205,108,240,62,93,211,0,62,10,211,0,201,245,31,31,31,31,205,117,240,241,230,15,198,144,39,206,64,39,211,0,201,91,49,48,56,32,114,99,61,48,120,0,237,255,62,222,50,240,255,62,173,50,241,255,121,50,242,255,195,158,240,195,0,0])
STUB_ORG = 0xF000
# Fatal sentinel written by the stub's unsupported-function path.
SENT_ADDR = 0xFFF0
SENT = (0xDE, 0xAD)
FN_ADDR = 0xFFF2

def build_image(com: bytes) -> bytearray:
    if len(com) > STUB_ORG - 0x100:
        raise SystemExit(f"COM too large ({len(com)} B) to fit below BDOS stub")
    img = bytearray(65536)
    img[0x100:0x100 + len(com)] = com
    # 0x0000: HALT.  A CP/M program returning to warm-boot (ret / jp 0) stops here.
    img[0x0000] = 0x76                       # HALT
    # 0x0005: JP 0xF000  (BDOS entry vector the .COM CALLs)
    img[0x0005] = 0xC3; img[0x0006] = STUB_ORG & 0xFF; img[0x0007] = STUB_ORG >> 8
    img[STUB_ORG:STUB_ORG + len(STUB)] = STUB
    return img

def main():
    argv = sys.argv[1:]
    quiet = "-q" in argv
    args = [a for a in argv if a != "-q"]
    # Optional: --counter N stops ticks after N cycles (e.g. timeout for slow benchmarks)
    counter_args = []
    filtered = []
    i = 0
    while i < len(args):
        if args[i] == "--counter" and i + 1 < len(args):
            counter_args = ["-counter", args[i + 1]]
            i += 2
        else:
            filtered.append(args[i])
            i += 1
    args = filtered
    if len(args) != 1:
        sys.exit(__doc__)
    com = open(args[0], "rb").read()
    img = build_image(com)
    with tempfile.NamedTemporaryFile(suffix=".bin", delete=False) as f:
        f.write(img)
        imgpath = f.name
    dumppath = imgpath + ".out"
    try:
        r = subprocess.run(
            # -w 4: raise the run-time budget to 4 units (~1.6e9 cycles). The
            # ticks default caps at ~1e8 cycles, which a heavy benchmark (e.g.
            # tm's malloc/free stress at ~3.4e8) hits before exiting, leaving
            # PC != 0 so -end never triggers -- it would look like a hang.
            [TICKS, "-mz80", "-l", "0x0000", "-pc", "0x100",
             "-end", "0x0000", "-w", "4", "-iochar", str(IOPORT),
             "-x", dumppath, imgpath] + counter_args,
            capture_output=True, text=True)
        dump = open(dumppath, "rb").read() if os.path.exists(dumppath) else b""
    finally:
        os.unlink(imgpath)
        if os.path.exists(dumppath):
            os.unlink(dumppath)
    # ticks prints program console output followed by the total cycle count as
    # the final whitespace-separated token.
    out = r.stdout
    toks = out.split()
    cycles = None
    if toks and toks[-1].isdigit():
        cycles = int(toks[-1])
        console = out[:out.rfind(toks[-1])]
    else:
        console = out
    sys.stdout.write(console)
    if r.stderr:
        sys.stderr.write(r.stderr)
    # Fatal: the stub wrote 0xDEAD + fn number to RAM on an unsupported BDOS call.
    if len(dump) > FN_ADDR and dump[SENT_ADDR] == SENT[0] and dump[SENT_ADDR + 1] == SENT[1]:
        fn = dump[FN_ADDR]
        sys.stderr.write(f"[ticks_cpm] FATAL: program called unsupported BDOS "
                         f"function {fn} (0x{fn:02X})\n")
        sys.exit(2)
    if cycles is not None and not quiet:
        sys.stderr.write(f"[ticks] {cycles} cycles\n")
    # Don't propagate ticks' own exit code: with -w set it returns 1 even on a
    # clean -end exit. Fatal conditions are signalled by the sentinel above
    # (exit 2); a normal run exits 0.
    sys.exit(0)

if __name__ == "__main__":
    main()
