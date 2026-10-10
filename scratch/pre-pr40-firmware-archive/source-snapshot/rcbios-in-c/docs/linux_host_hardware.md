# Linux Host Hardware for RC702 Transfers

> **CONTEXT NOTE 2026-04-25.** The CP/NET fast-link host design has
> moved to **Pi 4B + Pi Pico over USB-CDC** (see
> [`../../docs/cpnet_fast_link.md`](../../docs/cpnet_fast_link.md),
> Option P). The Linux-workstation-with-PCIe-parallel-port path
> documented below is no longer the planned production target. The
> info here remains useful for ad-hoc transfers, BIOS flashing over
> serial, and as reference if the parallel-port path is ever revived.

Reference for the USB-serial and PCIe-parallel interfaces on the Linux
workstation used to flash the RC702 BIOS and run other data transfers.
Captured 2026-04-17 on Ubuntu 24.04, kernel 6.17.

## USB Serial Adapter

### Chipset: FTDI **FT2232C/D** (not FT2232H)

| Field        | Value                         |
|--------------|-------------------------------|
| USB VID:PID  | `0403:6010`                   |
| bcdDevice    | `5.00` → FT2232C or FT2232D   |
| bcdUSB       | `2.00` (Full-Speed, 12 Mbit/s)|
| Serial       | `FT4SXZNY`                    |
| Product str. | `USB FAST SERIAL ADAPTER` (marketing; chip itself is Full-Speed) |
| Kernel drv.  | `ftdi_sio`                    |

Identification keys:
- USB VID:PID `0403:6010` is shared by FT2232C, FT2232D, and FT2232H;
  `bcdDevice` disambiguates (`0x0500` = C/D; `0x0700` = H).
- Link speed `12 Mbit/s` and endpoint `wMaxPacketSize = 64` confirm
  Full-Speed operation — FT2232H would be 480 Mbit/s with 512-byte
  endpoints.

### Device layout

Two independent UART channels, each exposed as its own USB interface:

| tty node       | FTDI channel | by-id symlink                    |
|----------------|--------------|----------------------------------|
| `/dev/ttyUSB0` | Channel A    | `usb-FTDI_USB_FAST_SERIAL_ADAPTER_FT4SXZNY-if00-port0` |
| `/dev/ttyUSB1` | Channel B    | `usb-FTDI_USB_FAST_SERIAL_ADAPTER_FT4SXZNY-if01-port0` |

Each interface has one bulk IN and one bulk OUT endpoint, 64-byte
packets. Same physical chip — same serial on both ports.

Both ports share ownership `root:dialout 0660`; user must be in
`dialout` group.

### Capabilities (UART mode)

- Baud range: 300 baud → **3 Mbaud**. The 38400 baud used for RC702
  SIO-A is trivial for the hardware.
- 7/8 data bits, 1/1.5/2 stop bits, all parity modes.
- Full modem control: RTS/CTS/DTR/DSR/DCD/RI.
- **Hardware flow control** (RTS/CTS) — required by the RC702 SIO-A
  Auto Enables; see `serial_cable_wiring.md`.
- Buffers: 384-byte RX FIFO per channel, 128-byte TX FIFO.

### Alternate modes per channel

Not used today but available if we want to repurpose a channel:
- Async bit-bang (GPIO)
- Synchronous bit-bang
- **MPSSE** (Multi-Protocol Synchronous Serial Engine) — SPI / I²C /
  JTAG / arbitrary clocked serial up to 6 MHz. Channel A only on
  FT2232C; either channel on FT2232D.
- MCU host bus (8048/8051 emulation)
- Fast Opto-Isolated Serial (FT2232D only)
- FT1248 parallel interface

Access non-UART modes via `libftdi1` or `pyftdi` (bypasses `ftdi_sio`).

### Full-Speed USB implications

At 38400 baud the bus carries ~4 KB/s — ~60 USB packets/sec — well
under Full-Speed capacity. 64-byte packet size only becomes a
bottleneck above a few hundred kbit/s of sustained throughput; not a
concern for any current workflow.

## PCIe Parallel Port

### Chipset: **ASIX AX99100** (PCIe-to-Multi-I/O controller)

| Field            | Value                                       |
|------------------|---------------------------------------------|
| PCI BDF          | `02:00.2`                                   |
| PCI VID:PID      | `125b:9100`                                 |
| Subsystem        | `a000:2000` (ASIX "parallel port")          |
| prog-if          | `0x03` = IEEE 1284                          |
| Kernel driver    | `parport_pc` (with `ppdev`, `lp` stacked)   |
| IRQ              | 19 (shared)                                 |

The AX99100 is a multi-function chip that can expose up to 4 UART
functions plus one parallel function; on this board only the parallel
function (`.2`) is wired/enabled.

### Resources

- **I/O BARs:** `0xe010` (size 8) — SPP register window; `0xe000`
  (size 8) — ECP register window.
- **MMIO BARs:** two 4 KB regions at `0xf7100000` / `0xf7101000` for
  the AX99100's enhanced register set (ECP FIFO configuration,
  IEEE 1284 timing, etc.).
- **DMA:** `-1` in `/proc/sys/dev/parport/parport0/dma` — no legacy
  ISA DMA channel. `parport_pc` runs this part in PIO-only mode; the
  chip is capable of PCIe bus-master DMA but the Linux driver does not
  use it.
- **spintime 500** µs — busy-wait time in SPP handshake before yielding.

### Modes the driver reports

From `/proc/sys/dev/parport/parport0/modes`:

```
PCSPP, TRISTATE, COMPAT, EPP, ECP
```

| Mode      | IEEE 1284  | What it is                                    |
|-----------|------------|-----------------------------------------------|
| PCSPP     | —          | PC-style Standard Parallel Port (base)        |
| TRISTATE  | —          | Data bus switchable to input (bidirectional SPP) |
| COMPAT    | Mode 0     | Centronics-compatible, host→peripheral only   |
| EPP       | Mode 4     | 8-bit bidirectional, hardware handshake, ~0.5–2 MB/s |
| ECP       | Mode 5     | Bidirectional + 16-byte FIFO + RLE, ~1–2 MB/s |

Not listed (confirming PIO operation): `DMA`.

### User-space access

- `/dev/parport0` (`ppdev`) — raw access via ioctls (`PPCLAIM`,
  `PPWDATA`, `PPRSTATUS`, `PPNEGOT`, …). Correct choice for talking to
  the RC702 PIO host interface with a custom handshake.
- `/dev/lp0` (`lp`) — line-printer cooked mode; not useful here.
- Ownership `root:lp 0664` — user must be in `lp` group.

## Implications for RC702 Flashing

### Serial path (current)

- Runs on either FT2232 channel at 38400 baud with RTS/CTS.
  `deploy.sh` defaults to `/dev/ttyUSB0`; override via `RC700_PORT`.
- Effective throughput ~3.8 KB/s → ~25 s/byte × 5.7 KB BIOS ≈ 1.5 min
  of transfer time, plus PIP/SYSGEN overhead.

### Parallel path (future)

Decision depends on how the RC702 PIO host side signals — see
`parallel_host_interface.md`.

Two candidate host implementations:

1. **AX99100 via `ppdev`** — drives IEEE 1284 signals directly.
   - Best if the RC702 side implements EPP/Centronics-like handshake:
     the chip then handshakes in hardware, ~0.5 MB/s realistic.
   - Plain SPP bidirectional with manual handshake: ~50–150 KB/s,
     still ~15× faster than 38400 serial.
2. **FT2232 MPSSE bit-bang** — use one FTDI channel as a 4-wire
   clocked parallel interface.
   - Up to 6 MHz shift clock; packets of bytes buffered in-chip
     (no per-byte PCI round-trip).
   - Easier to iterate on timing/protocol from user space.
   - No IEEE 1284 semantics — we write the handshake ourselves.

For a bespoke RC702 protocol the FTDI-MPSSE path is often faster in
practice and definitely easier to debug, because the command FIFO
insulates it from host scheduling jitter. For a 1284-standard
peripheral the AX99100 wins because it handles the handshake in
hardware.

Benchmark both once the serial path is confirmed working; decide
based on measured throughput and protocol fit.

## Group Memberships

User must be in both groups to use devices without `sudo`:

```
sudo usermod -aG dialout,lp $USER
# log out and back in
```

Confirm with `groups`; should list `dialout` and `lp`.
