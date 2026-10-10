# Using a Motherboard Serial Port (Native 16550 UART) with the RC700

This is a sibling note to [`serial_cable_wiring.md`](serial_cable_wiring.md),
which documents the working FTDI USB-serial cable. It answers the question:
how do I configure a different Linux PC that has only a built-in
motherboard COM port to talk to the RC700 the same way?

## Short answer

The same physical cable works. Plug it into the motherboard DE-9 instead
of the FTDI dongle, then use `/dev/ttyS0` (or `/dev/ttyS1`) wherever the
existing scripts say `/dev/ttyUSB1`. No driver install, no kernel module,
no special baud-rate divisor work needed.

The motherboard 16550 UART exposes the **same nine RS-232 signals on
the same DE-9 pinout** as the FTDI cable, so the wiring described in
`serial_cable_wiring.md` (FTDI RTS → RC700 DCD, RC700 RTS → FTDI CTS,
GND → CTS hack, etc.) carries over byte-for-byte. From the kernel's
point of view both devices are tty-class character devices controlled
through the same `termios` API and the same `TIOCMGET`/`TIOCMSET` modem
control lines.

## Why it "just works"

The interesting bits of the FTDI setup that matter for the RC700 are:

1. **38400 8-N-1**: every PC UART since the original 8250 has supported
   this. The 16550A in any motherboard chipset (or its modern PCH/SuperIO
   replacement) handles 38400 trivially.
2. **DCD asserted by host (via FTDI RTS)**: the RC700 SIO-A has Auto
   Enables and refuses to receive without DCD. On a motherboard UART,
   the same routing — host RTS pin into RC700 DCD — produces the same
   behaviour, because RTS on a motherboard DE-9 is the same RS-232
   signal.
3. **RC700 RTS → host CTS for flow control**: 16550A directly exposes
   CTS as a modem-status bit and termios `crtscts` honours it in the
   kernel. No FTDI-specific behaviour here at all.
4. **Per-line `flush()` discipline**: still useful, but **less critical**
   on a motherboard UART. The FT232 has a 256-byte TX FIFO, so without
   `flush()` the FTDI happily accepts ~4 KB into its USB-bulk buffer
   and ignores CTS transitions during the burst. A 16550A has only a
   16-byte TX FIFO, so the back-pressure window is one to two RC700
   characters, not 4 KB. The existing per-line `flush()` strategy is
   safe; it is also more forgiving on bare hardware.

There are no features the FTDI provides that the motherboard UART
doesn't. (FTDI has a configurable USB latency timer; native UARTs are
strictly better in that regard.)

## Step-by-step on a fresh Linux PC

### 1. Make sure the COM port exists and is enabled

Many modern motherboards ship with the legacy COM port disabled in
firmware even when a header is present. In the BIOS / UEFI setup:

* Enable "Serial Port" / "COM A" / "Onboard Serial Port".
* Confirm the standard resources (most boards offer only `3F8/IRQ4`
  for COM1, sometimes `2F8/IRQ3` for COM2). Either is fine.

After Linux boots, verify the kernel detected it:

```bash
dmesg | grep -i ttyS
# expect: serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A

ls -l /dev/ttyS0
# crw-rw---- 1 root dialout 4, 64 ... /dev/ttyS0
```

If `dmesg` shows nothing about `ttyS0`, the port is still disabled in
firmware (or the SuperIO chip needs `setserial`). Re-check BIOS setup
before going further.

### 2. Add yourself to the `dialout` group

```bash
sudo usermod -aG dialout "$USER"
# log out and back in for the new group to take effect
groups | tr ' ' '\n' | grep dialout
```

This is the **only** permission step needed. There is no udev rule to
write, no driver to install — `serial8250` is built into every stock
Linux kernel.

### 3. Connect the existing cable

The cable described in `serial_cable_wiring.md` has a DE-9 male end
(originally for the FTDI dongle). It plugs straight into the
motherboard's DE-9 male back-panel jack with a standard female-to-female
or male-to-female DE-9 gender changer if needed. **No null-modem swap
should be added** — the cable already contains the required null-modem
crossover and the DCD/RTS routing tricks for the RC700 SIO Auto Enables.
Adding a second null-modem would un-cross the data lines and break
everything.

If the motherboard only has an internal 2x5 (10-pin IDC) header and no
back-panel jack, you need a "COM port bracket" cable. **Two pinout
variants exist** — the common AT/Intel mapping and a reversed mapping
used by some Asus and Tyan boards. Always check the motherboard manual
before plugging in: a wrong-pinout bracket cable won't damage anything,
but it will swap several signals and produce silent failure. A safe
sanity check is to measure DE-9 pin 5 with a multimeter; it should read
0 V to chassis ground.

### 4. Configure termios identically to the FTDI setup

```bash
stty -F /dev/ttyS0 38400 cs8 -parenb -cstopb crtscts -ixon -ixoff \
                   -icanon -isig -icrnl -opost -echo -echoe -echok -echoctl
```

These flags are the raw-mode equivalent of the FTDI side and match
what `pyserial` configures internally when you pass `rtscts=True` in
raw 8-N-1.

Optional but recommended: keep DTR asserted across opens so a
disconnect-and-reconnect cycle doesn't blip the RC700's modem-status
inputs:

```bash
stty -F /dev/ttyS0 -hup
```

### 5. Override the device path in the existing scripts

Both `deploy.sh` and the standalone `send_hex_rtscts.py` accept the
device path either as the first argument or via the `RC700_PORT`
environment variable. So:

```bash
export RC700_PORT=/dev/ttyS0
./deploy.sh clang
```

or

```bash
python3 /tmp/send_hex_rtscts.py /dev/ttyS0 38400 /tmp/cpm56.hex
```

Nothing else in the workflow changes — the same Intel HEX file, the
same PIP/SYSGEN sequence on the RC700, the same RTS/CTS pacing.

### 6. Quick smoke test

Open two terminals on the PC:

```bash
# Terminal 1: continuous reader
stty -F /dev/ttyS0 38400 cs8 -parenb -cstopb crtscts -ixon -ixoff \
                   -icanon -isig -icrnl -opost -echo
cat /dev/ttyS0
```

```bash
# Terminal 2: send "DIR\r\n" to the RC700
printf 'DIR\r\n' > /dev/ttyS0
```

If the RC700 echoes a directory listing into terminal 1, every link in
the chain — UART, cable, RTS→DCD trick, BIOS RTS flow control — is
working. From here `deploy.sh` is reliable.

## Things that bite people once

* **Wrong COM port bracket cable.** Two physical pinouts exist; a
  wrong one will silently invert RTS/CTS or swap TX/RX. Always check
  the motherboard manual.
* **Half-installed gender changer.** Adding a null-modem to a cable
  that already contains one will undo the data crossover. Use a
  straight gender changer only.
* **Permission failures.** `Permission denied` on `/dev/ttyS0` almost
  always means the user is not yet in `dialout` (or the active
  ModemManager has the device open — `systemctl mask ModemManager`
  on a workstation that has no modem fixes that for good).
* **`screen` and `cu` not honouring `crtscts` consistently.** The
  RC700 worked under `pyserial` because `crtscts` is requested
  explicitly in code. If you want an interactive terminal program,
  prefer `picocom -b 38400 -f h /dev/ttyS0` or `minicom` with
  hardware flow control enabled in its setup menu.
* **USB-to-serial dongles other than FT232.** The RC700 wiring trick
  depends on the host driving DCD via RTS. Some cheap CH340 cables
  do not break out RTS/DTR at all and cannot drive DCD. A real
  motherboard UART always exposes both, which is one reason the
  bare-metal port is the safer choice.

## Same expected throughput

`send_hex_rtscts.py` reports ~96 s and ~5300 CTS drops for the 779-record
HEX file at 38400 baud over the FTDI cable. The motherboard UART should
hit the same number — the bottleneck is the RC700's BIOS ring buffer
draining into PIP, not the host side. Any difference will be in the
noise.

## TL;DR

1. Enable the COM port in BIOS / UEFI.
2. `usermod -aG dialout $USER`, log out and back in.
3. Plug the existing FTDI cable into the motherboard DE-9 (no extra
   null-modem).
4. `export RC700_PORT=/dev/ttyS0` and reuse `deploy.sh`.
