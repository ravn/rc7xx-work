# RC700 Serial Cable Wiring

## RC700 SIO-A Configuration

The RC700 SIO Channel A (terminal/modem port) uses **Auto Enables**
(WR3 bit 5 = 1):
- **CTS gates the transmitter**: SIO won't send unless CTS is asserted
- **DCD gates the receiver**: SIO ignores incoming data unless DCD is asserted

Both signals MUST be driven by the cable for reliable communication.

Default serial parameters: **38400 baud, 8-N-1** (CTC0 divisor=1,
SIO WR4=0x44 ×16 clock). Configurable via CONFI.COM.

## RC700 BIOS RTS Flow Control

The C BIOS (`bios.c`) implements hardware flow control on SIO-A:

- **256-byte ring buffer** (`rxbuf[]`) filled by the SIO-A receive ISR
- **RTS de-asserted** when buffer has ≥248 bytes (8 slots left):
  ISR writes WR5 with RTS=0 (`wr5a + 0x88`)
- **RTS re-asserted** when READER drains buffer below 240 bytes:
  writes WR5 with RTS=1 (`wr5a + 0x8A`)
- Thresholds: `RXTHHI=248`, `RXTHLO=240` (defined in `bios.h`)

The flow control works correctly — during PIP disk writes (which
block the READER for ~200ms), the ISR ring buffer fills and RTS
drops, pausing the sender.

## Working Configuration (Verified 2026-04-05)

### Cable: Straight DB-9 to DB-25 with mini null-modem adapter

Adapter mapping (DB-9 FTDI side → DB-25 RC700 side):

```
FTDI DB-9                    RC700 DB-25       Signal
─────────                    ───────────       ──────
Pin 2 (RX)  ──────────────── Pin 3 (RX)       Data: RC700 → host
Pin 3 (TX)  ──────────────── Pin 2 (TX)       Data: host → RC700
Pin 5 (GND) ──────────────── Pin 5 (CTS!)     ** see note **
Pin 7 (RTS) ──────────────── Pin 8 (DCD)      Assert DCD for Auto Enables
Pin 8 (CTS) ──────────────── Pin 7 (GND)      CTS tied low (always asserted)
Pin 4 (DTR) ──────────────── Pin 1+6          DTR → frame ground + DSR
Pin 1+6     ──────────────── Pin 4 (RTS)      RC700 RTS → FTDI DCD+DSR
```

**Note on Pin 5**: FTDI GND goes to RC700 DB-25 pin 5 which is CTS,
not signal ground. This accidentally keeps CTS asserted (ground level
= logic high for RS-232), allowing the RC700 to transmit. It works
but is not ideal.

### What makes it work

1. **FTDI RTS → RC700 DCD (pin 8)**: When the FTDI port is opened
   and RTS is asserted, RC700's DCD goes active. Auto Enables then
   allows the SIO to receive data. Without this, the SIO silently
   drops all incoming bytes.

2. **RC700 RTS → FTDI DCD+DSR (pins 1+6)**: When the RC700's ring
   buffer fills, the BIOS de-asserts RTS. The FTDI sees both DCD
   and DSR drop. This is visible via pyserial as `s.cts` changing
   state — the Linux FTDI driver maps CTS from the actual CTS pin,
   but the mini adapter routes RC700 RTS to FTDI CTS as well
   (verified empirically: CTS toggles during heavy transfers).

3. **Hardware flow control in pyserial**: `rtscts=True` tells the
   FTDI hardware to stop transmitting when CTS drops. Combined
   with `flush()` after each line, this ensures per-line flow
   control.

### Host software configuration

**pyserial (Python) — verified working:**

```python
import serial
s = serial.Serial("/dev/ttyUSB1", 38400, rtscts=True)
s.dtr = True
s.rts = True

# Send with per-line flush for reliable flow control
for line in lines:
    s.write((line + "\r\n").encode())
    s.flush()  # blocks until transmitted, honors CTS

# End PIP input
s.write(b"\x1a")  # single Ctrl-Z
```

Key requirements:
- `rtscts=True`: enables FTDI hardware flow control
- `s.flush()` after each write: prevents FTDI TX FIFO from buffering
  ahead of CTS. Without flush, the FTDI accepts ~4KB into its buffer
  and transmits it all regardless of CTS transitions during that burst.
- Single `\x1a` (Ctrl-Z) to end PIP input — do NOT send two.

**screen (interactive terminal):**

```bash
screen /dev/ttyUSB1 38400
# or on macOS:
screen /dev/cu.usbserial-FT4SXZNY1 38400
```

Note: `screen` does not support `crtscts` as a command-line option on
all platforms. For file transfers, use the pyserial sender script.

**Linux stty:**

```bash
stty -F /dev/ttyUSB1 38400 cs8 -parenb -cstopb crtscts
```

### Sender script

The working sender script (`send_hex_rtscts.py`) is deployed to
`/tmp/send_hex_rtscts.py` on the Linux machine. Usage:

```bash
python3 /tmp/send_hex_rtscts.py /dev/ttyUSB1 38400 /tmp/cpm56.hex
```

It sends each hex record with per-line flush, monitors CTS transitions,
and sends a single Ctrl-Z at the end.

Typical transfer stats for 779-record hex file at 38400 baud:
- Transfer time: ~96 seconds
- CTS drops: ~5300 (flow control very active)
- Average CTS drops per line: ~6.8

## Complete BIOS Update Workflow

1. On the Mac, rebuild and generate hex:
   ```bash
   cd rc700-gensmedet/rcbios-in-c
   rm -f clang/*.o && make bios
   python3 mk_cpm56.py cpm56_original.com clang/bios.cim clang/cpm56
   scp clang/cpm56.hex ravn@linux-host:/tmp/cpm56.hex
   ```

2. On the RC700, start PIP:
   ```
   PIP CPM56.HEX=RDR:
   ```

3. From the Linux host (or via ssh from the Mac):
   ```bash
   python3 /tmp/send_hex_rtscts.py /dev/ttyUSB1 38400 /tmp/cpm56.hex
   ```

4. On the RC700, verify and write:
   ```
   LOAD CPM56
   CPM56               (prints OK if BIOS checksum matches)
   SYSGEN CPM56.COM    (skip read, write to destination drive)
   ```

## Ideal Cable (Not Yet Built)

For a purpose-built cable without the mini adapter:

```
FTDI DB-9                    RC700 DB-25
─────────                    ───────────
Pin 3 (TX)  ──────────────── Pin 3 (RX)        Data: host → RC700
Pin 2 (RX)  ──────────────── Pin 2 (TX)        Data: RC700 → host
Pin 5 (GND) ──────────────── Pin 7 (GND)       Ground

Pin 4 (DTR) ──┬───────────── Pin 8 (DCD)       Assert DCD (SIO accepts data)
              └───────────── Pin 6 (DSR)       Assert DSR

Pin 8 (CTS) ──────────────── Pin 4 (RTS)       Flow control: RC700 → FTDI
Pin 7 (RTS) ──────────────── Pin 5 (CTS)       Flow control: FTDI → RC700
```

This would give clean bidirectional flow control. The current mini
adapter works but routes GND to CTS and has the flow control path
go through DCD+DSR instead of CTS directly.

## Previous Working Cable (circa 1993)

RC700 DB-25 ↔ PC DB-25, used with modem. Notes: `2-3, 3-2, (4+5
internally), 6+8-20, 7-7`.

```
RC700 DB-25                  PC DB-25
───────────                  ────────
Pin 2 (TX)  ──────────────── Pin 3 (RX)        Data crossover
Pin 3 (RX)  ──────────────── Pin 2 (TX)        Data crossover
Pin 7 (GND) ──────────────── Pin 7 (GND)       Ground
Pin 6+8     ──────────────── Pin 20 (DTR)      PC DTR → RC700 DCD+DSR
                             Pin 4+5 shorted    PC RTS looped to CTS
```

No RC700→PC flow control. Worked because modem/PC could keep up.
