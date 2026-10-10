# SYSGEN BIOS Install via Serial Transfer

## Goal

Install a new BIOS onto an RC702 disk using SYSGEN.COM, with the BIOS data
transferred over the serial line. Tested in MAME, targeting real hardware.

## SYSGEN Memory Layout (MAXI 8")

SYSGEN loads the system image at 0x0900 (LOADP). Track 1 first, then track 0:

```
0x0900-0x44FF  Track 1 (CCP+BDOS)   15360 bytes, interleaved per maxitrans
0x4500-0x51FF  Track 0 Side 0 (FM)    3328 bytes = bios.cim[0:3328]
0x5200-0x5EFF  Track 0 gap            3328 bytes of zeros
0x5F00-0x78FF  Track 0 Side 1 (MFM)   6656 bytes = bios.cim[3328:]
```

The gap (logical sectors 26-51) exists because the BIOS maps side 0 to
sectors 0-25 and side 1 starting at sector 52.

## Workflow

### Preparation (host side)

1. Extract original CPM56.COM from the target disk via MAME:
   ```
   # SYSGEN read A: + memory dump (mame_sysgen_dump.lua or cpm56_dump.lua)
   # Produces cpm56_original.com (27392 bytes = 107 pages)
   ```

2. Patch BIOS into CPM56.COM and generate Intel HEX:
   ```
   python3 mk_cpm56.py cpm56_original.com clang/bios.cim cpm56
   ```
   Outputs `cpm56.com` (patched) and `cpm56.hex` (for serial transfer).
   The HEX only includes non-zero regions (CCP+BDOS + new BIOS).

3. Get `CPM56.HEX` onto the CP/M disk:
   - **Serial**: `PIP CPM56.HEX=RDR:` (requires working serial port)
   - **Disk injection**: `cpmcp -f rc702-8dd image.imd cpm56.hex 0:CPM56.HEX`

### Installation (CP/M side — single session)

```
A>LOAD CPM56              ← converts HEX to COM
A>SYSGEN CPM56.COM        ← reads file, writes system tracks
DESTINATION DRIVE NAME... A
DESTINATION ON A...       (RETURN)
FUNCTION COMPLETE
```

SYSGEN with a filename argument reads the file directly (skipping the
"SOURCE DRIVE" prompt) and goes straight to the destination prompt.
See CPM_FOR_RC702_USERS_GUIDE.pdf appendix C for the official procedure.

## Tools

### Primary (the working pipeline)
- `mk_cpm56.py` — Patch bios.cim into CPM56.COM, generate Intel HEX
- `mame_boot_verify.lua` — MAME: boot and verify banner

### Supporting
- `mk_sysgen_t0.py` — Convert bios.cim to raw SYSGEN track 0 binary
- `mk_sysgen_hex.py` — Convert bios.cim to standalone Intel HEX (track 0 only)
- `mame_sysgen_dump.lua` — MAME: dump SYSGEN memory layout for analysis
- `mame_sysgen_write.lua` — MAME test: Lua memory injection + SYSGEN write
- `sysgen_serial_server.py` — TCP server for serial transfer to MAME
- `mame_confi_set.lua` — MAME: run CONFI.COM to change serial port settings

## Intel HEX Format (CP/M)

CP/M LOAD.COM expects a zero-length data record as EOF, NOT Intel type 01:
```
:0000000000    ← CP/M EOF (zero-length type 00 record)
:00000001FF    ← Standard Intel HEX EOF (NOT recognized by LOAD.COM)
```

The `[H]` flag in PIP validates Intel HEX during transfer.

## MAME Test Results

### Lua injection (mame_sysgen_write.lua) — WORKING

Injects BIOS data directly into Z80 memory via Lua after SYSGEN read.
Fully verified: track 0 bytes match, track 1 unchanged, boots with
clang BIOS banner (`RC700 56k CP/M 2.2 C-bios/clang`).

Must use `manager.machine:exit()` (not `os.exit()`) for clean shutdown
so MAME flushes the MFI file to disk.

### Serial transfer (mame_sysgen_serial.lua) — BLOCKED by original BIOS

The original BIOS (rel 2.3) only buffers a single character in the SIO
(no ring buffer, no working RTS flow control). Characters are lost even
at 1200 baud with byte-by-byte pacing.

The clang BIOS has a 256-byte ring buffer with RTS/CTS flow control.
Serial transfer will work after the first BIOS install.

## Original Disk Serial Settings

```
1200 baud, 7 data bits, even parity, 1 stop bit (1200 7E1)
```

Configurable via CONFI.COM (option 2: Terminal Port). CONFI saves to
the disk's config sector; cold reboot required to activate.

The MAME driver defaults for the null_modem must match. Changed in
`rc702.cpp` rs232a_defaults to 1200 7E1 (was 38400 8N1).

## Real Hardware Path

1. **First install**: inject BIOS.HEX into disk image, or use Raspberry Pi
   parallel port typing, or direct disk image write.
2. **Subsequent installs**: serial transfer via PIP works with clang BIOS
   ring buffer.

## Future Work

- Rebuild CP/M CCP+BDOS for different MTYPE (memory size) values.
  This would require constructing the full SYSGEN image including a
  properly interleaved track 1 (CCP+BDOS), not just track 0 (BIOS).
