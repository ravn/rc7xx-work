# Parallel-Port Cable Investigation (2026-04-17)

> **PARTIALLY SUPERSEDED 2026-04-25.** The cable diagnosis below
> remains useful as background — straight-through DB-25 is unfit, a
> custom cable is required. The host side has changed:
> [`../../docs/cpnet_fast_link.md`](../../docs/cpnet_fast_link.md)
> (Option P) replaces the Linux-PC-with-LPT host with a Pi 4B + Pi
> Pico over USB-CDC, and the cable target shifts from J4 / PIO-A to
> **J3 / PIO-B** (only port with both BSTB and BRDY routed). The new
> doc has the current cable specification (11 wires + 9 series
> resistors). The pin-mapping investigation below still documents
> what's wrong with the existing straight-through DB-25, useful when
> reusing connector hardware.

Diagnoses the DB-25 cable currently running between the Linux host's
parallel port (ASIX AX99100, see `linux_host_hardware.md`) and the RC702,
and specifies the custom cable we need to get a working high-speed
parallel transport.

## Summary

| Question                                    | Answer                                       |
|---------------------------------------------|----------------------------------------------|
| Is the current cable plugged in?             | Yes — probe sees the RC702 end.              |
| Is it the right topology for bit-banging?    | **No.** It is a straight-through DB-25.       |
| Does it carry any useful signal?             | One: PIO BRDY on J3-12 reaches PC PE input.  |
| Can we drive the PIO data bus through it?    | No — PC data outputs land on unused or GND pins. |
| What do we need?                             | A custom 10-conductor cable, pinout below.   |

## Host-side observations

The Linux parport is visible and accessible (`crw-rw-r-- root:lp` on
`/dev/parport0`; user in `lp` group). Running a probe via `ppdev` ioctls:

```
[idle] status=0x48   ~BUSY(p11)=0 ACK(p10)=1 PE(p12)=0 SLCT(p13)=0 ~ERR(p15)=1
[idle] control=0x0c  ~SLIN(p17)=1 INIT(p16)=1 ~AFD(p14)=0 ~STB(p1)=0
[write data=0x00] status=0x48  delta=0x00
[write data=0xff] status=0x48  delta=0x00
[write data=0x55] status=0x48  delta=0x00
[write data=0xaa] status=0x48  delta=0x00
[ctrl bit0 (~STB(p1))]   lo=0x48 hi=0x48 delta=0x00
[ctrl bit1 (~AFD(p14))]  lo=0x48 hi=0x48 delta=0x00
[ctrl bit2 (INIT(p16))]  lo=0x48 hi=0x48 delta=0x00
[ctrl bit3 (~SLIN(p17))] lo=0x48 hi=0x48 delta=0x00
[tristate] read data=0x01  status=0x48
```

Then, passively watching the data bus with the bus in tristate / input
mode (no host drive) for 8 seconds:

```
t=0.0s  data=0x01
t=0.1s  data=0x21
t=0.1s  data=0x31
t=0.2s  data=0x79
t=0.2s  data=0x7d
t=0.3s  data=0xfd        ← stable
```

### What those numbers say

1. **No host output affects any host input.** Neither writing data nor
   toggling any of the four control lines changes the status register
   even by one bit. That means none of the PC's output pins are connected
   to a *PIO output* through the cable.
2. **Bit D1 (bus pin 3) is stuck at 0 forever.** When the bus is driven
   or not, D1 reads 0. All other bits settle to 1 via weak pullups. D1
   being held at 0 can only mean it is physically tied to ground through
   the cable. DB-25 pin 3 on the PC side is the D1 output; on the RC702
   J3 side, pin 3 is GND. A straight-through cable connects the two —
   exactly matching the observation.
3. **PE (pin 12) reads low constantly.** PC DB-25 pin 12 is the PE input,
   which maps straight-through to J3-12 = PIO BRDY output. BRDY's idle
   state is low. This is the one signal the current cable carries
   correctly.
4. **RC-settling of the data bus** (0x01 → 0xfd over 300 ms) is the
   cable's line capacitance + pullup signature when the bus transitions
   from driven-low to high-Z input mode. Consistent with PC data pins
   connected to mostly-floating J3 pins with occasional grounds.

All four observations converge: the cable is a commodity straight-through
DB-25 M/F, the kind sold as "IEEE-1284 parallel printer cable" or "DB-25
M/F extension cable."

## Why straight-through is wrong for this link

Laying the PC parport DB-25 pinout next to the verified J3 pinout (see
`docs/schematics/MIC07_pinout.md`):

| PC DB-25 pin | PC signal (dir) | → J3 pin | J3 signal (MIC07)     | On a straight cable: |
|--------------|-----------------|----------|-----------------------|----------------------|
| 1            | /STROBE (out)    | 1        | (unused)              | wasted                |
| 2            | D0 (out/bidir)   | 2        | **BSTB (input)**      | PC D0 → PIO strobe — dangerous, toggles strobe accidentally |
| 3            | D1 (out/bidir)   | 3        | **GND**               | **D1 pinned to GND**  |
| 4–9          | D2–D7 (out/bidir)| 4–9      | unused                | no effect              |
| 10           | /ACK (in)        | 10       | unused                | no effect              |
| 11           | BUSY (in)        | 11       | unused                | no effect              |
| **12**       | **PE (in)**      | **12**   | **BRDY (PIO out)**    | **useful** — only working signal |
| 13           | SLCT (in)        | 13       | **GND**               | ties SLCT low forever  |
| 14           | /AUTOFD (out)    | 14       | **GND**               | shorts /AUTOFD to GND  |
| 15           | /ERROR (in)      | 15       | unused                | no effect              |
| 16           | /INIT (out)      | 16       | unused                | no effect              |
| 17           | /SLIN (out)      | 17       | **B4 (PIO data)**     | single bit reachable   |
| 18–20        | GND              | 18–20    | **B5, B6, B7**        | **PIO bits pinned to GND** |
| 21           | GND              | 21       | **B3**                | **PIO bit pinned to GND** |
| 22–24        | GND              | 22–24    | **B0, B1, B2**        | **PIO bits pinned to GND** |
| 25           | GND              | 25       | unused                | wasted                 |

Key problems:
- **Seven of the eight PIO data lines are shorted to PC ground.** They
  cannot respond to PC writes because the ground short dominates.
- **PC data outputs don't land on any PIO data pin.** Only /SLIN reaches
  one data bit (B4). The cable simply doesn't route data.
- **Pin 2 is a worst-case hazard.** PC D0 (an output) lands on J3 BSTB
  (the PIO strobe input, pulled up via R39 15K). Every PC data bus write
  toggles BSTB depending on D0's value, so any unrelated parport traffic
  can spuriously strobe the PIO. Harmless today because the BIOS does
  not init PIO-B, but it would be a real functional bug the moment we do.
- **PE does reach BRDY.** That's a useful coincidence, and it means the
  back-channel for a Mode 0 / Mode 1 handshake already works on this
  cable — we're just missing the data path and the strobe.

**Electrical concern:** driving a PC output into a PIO output that is
actively sourcing the opposite level results in fight current through
both chips' output stages. The PIO tolerates short bus contention, but
sustained contention will eventually fail. Don't leave the current cable
plugged in during PIO-B experiments.

## The custom cable we need

Ten functional conductors — eight data, one strobe, one ready — plus
ground. Everything is 5 V TTL on both sides, no level-shifting required.

### Wiring table (PIO Port B on J3, Mode 0 output from PC or Mode 1 input to PIO)

```
PC DB-25 (M)   direction   RC702 J3 DB-25 (?)   RC702 signal
─────────────  ──────────  ──────────────────   ────────────
 2  (D0 out)   ──────────▶  22   (B0)            data bit 0
 3  (D1 out)   ──────────▶  23   (B1)            data bit 1
 4  (D2 out)   ──────────▶  24   (B2)            data bit 2
 5  (D3 out)   ──────────▶  21   (B3)            data bit 3
 6  (D4 out)   ──────────▶  17   (B4)            data bit 4
 7  (D5 out)   ──────────▶  18   (B5)            data bit 5
 8  (D6 out)   ──────────▶  19   (B6)            data bit 6
 9  (D7 out)   ──────────▶  20   (B7)            data bit 7
 1  (/STROBE)  ──────────▶   2   (/BSTB in)      host-to-PIO byte strobe
12  (PE in)    ◀──────────  12   (BRDY out)      PIO "register ready"
18  (GND)      ───────────   3   (GND)           ground reference
```

Eleven wires, including one ground. The remaining DB-25 pins must be
left **unconnected** on both ends — pay particular attention that none
of the PC's `GND` pins (18–25) touch any J3 pin other than pin 3, 13, or
14. A standard ribbon or multi-core cable into custom-terminated
solder-cup DB-25 shells is the cleanest construction.

### RC702 side connector gender

J3 on the RC702 back panel is a DSUB-25 **female** (per MIC07 and the
prior analysis). So the cable's RC702 end needs a **DB-25 male** plug.
The PC side of a standard parport is a DB-25 **female** socket, so the
cable's PC end needs a **DB-25 male** as well. Both ends DB-25 male.

### Protocol this supports natively

With this cable, PIO Port B in **Mode 1 (byte input)** gives us the clean
handshaked PC→RC702 flow the CP/NET split-channel transport (see
`cpnet/SPLIT_CHANNEL_TRANSPORT.md`) is designed around:

- Host places byte on D0–D7.
- Host pulses /STROBE → latches as BSTB on the PIO.
- PIO latches byte, raises interrupt, drops BRDY (which the host sees as
  PE going low).
- RC702 ISR reads the byte. BRDY rises again; host sees PE high → may
  send next byte.

No electrical issues, no cable tricks, no level-shifting.

### Why not also try Mode 2 (full-duplex) on J3?

Mode 2 bidirectional requires **all four** handshake lines on Port A
(ASTB, ARDY, BSTB, BRDY) — and it's **only available on Port A**. J3 is
Port B, which supports Modes 0, 1, and 3 only. For full duplex the
split-channel design uses parallel downstream + SIO-A TX upstream
instead. See `parallel_host_interface.md` for the Mode 2 variant
(different connector, needs hardware mods).

## Throughput ceiling on this custom cable

Same as earlier analysis — Z80 ISR bound, not cable bound:

| Mode                                          | Rate                  |
|-----------------------------------------------|-----------------------|
| PIO Mode 1 with interrupt                     | ~30 KB/s sustained     |
| PIO Mode 1 polled tight loop                  | ~100 KB/s burst        |
| AX99100 PIO via `ppdev` (host side)           | ~50–100 KB/s           |
| PC→RC702 38400 serial for reference           | 3.8 KB/s               |

So ~8× faster than serial in the downstream direction. Combined with
SIO-A TX at 250 kbaud upstream, a full CP/NET split-channel session
runs at ~30 KB/s bulk down, ~23 KB/s bulk up.

## Open practical questions

1. **Where to source the cable.** A hand-built cable with solder-cup
   DB-25 shells and 10-conductor flat cable or hookup wire is ~15 min of
   work. Alternatively, a commercial "null-parallel" / "Laplink / Direct
   Cable Connect" cable has some crossovers but *not* the one we need —
   those cables cross data-to-status for PC↔PC file transfer, which
   doesn't match the PIO-B topology. Custom is the answer.
2. **Strain relief on a back-panel DB-25.** J3 is inside the RC702 case
   on a back-panel bracket; any cable should have standard DB-25 hood
   strain relief.
3. **Do not plug the current cable into J4 "by mistake."** J4 carries
   +12V on pins 3, 13, 14 (see `MIC07_pinout.md`). A cable that routes
   those to PC ground would short the RC702's +12V supply. This is a
   real hazard worth labeling physically on the cable.

## Next actions

These were the next steps for the now-superseded plan. Current bring-up
sequence lives in
[`../../docs/cpnet_fast_link.md`](../../docs/cpnet_fast_link.md)
"Bring-up sequence (deferred until hardware available)" — same shape
but PIO-B (J3) instead of PIO-A (J4) target, Pi 4B + Pi Pico host stack
instead of Linux PC + LPT, and measurements feed into
`docs/cpnet_fast_link.md` rather than the now-tombstoned
`SPLIT_CHANNEL_TRANSPORT.md`.
