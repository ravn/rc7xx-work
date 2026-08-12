# RC759 (MAME) — FDC/DMA program-load bug + NVRAM — findings 2026-08-12

Machine: MAME `rc759` (Regnecentralen RC759 Piccoline, Intel 80186) running
Concurrent CP/M-86 3.1. Driver: `src/mame/regnecentralen/rc759.cpp` (fork `ravn/mame`).

Confidence is marked per claim: **[known]** = verified this session from
code/traces/observation; **[guessed]** = inference/hypothesis not yet proven by a
check that would have failed if wrong.

> **CAVEAT (user, 2026-08-12): the MAME rc759 driver does NOT work — floppy
> program-load fails. Therefore no part of the driver may be assumed correct, even
> when it resembles a working driver. Resemblance to other drivers is not evidence;
> only a check that would have failed if the part were wrong counts. Every "matches
> the standard pattern" observation below is [guessed], never a clearance.**

---

## 1. The program-load bug (SOLVED 2026-08-12)

> **RESOLVED [known].** Root cause: MAME's `i80186` internal DMA serviced bytes
> **deferred** — `drq0_w()` only latched `m_dma[0].drq_state` and the actual byte
> drain happened at the top of `execute_run()`, i.e. on the CPU's schedule. The
> WD2797 delivers one byte every ~16us (500 kbit/s MFM); at certain sync points the
> deferral exceeded that window, so `wd_fdc::set_drq()` found `drq` still true and
> set **S_LOST**. Critically, once `S_LOST` is set, `set_drq()`'s
> `else if(!(status & S_LOST))` suppresses **all** further DRQ callbacks for the rest
> of the sector -> one slip poisons the whole sector -> every post-boot read fails
> -> every program load fails. It is an **ordering race, not CPU starvation** (proven:
> instrumenting `drq0_w` showed every DRQ arrived with `armed=1 latency=0
> drqstate=0`; the DMA never fell behind on the CPU side — which is why the coarse-
> quantum and HALT-path hypotheses both failed).
>
> **Fix [known]:** make `i80186::drq0_w()` respond to DREQ **immediately** — when a
> byte is requested and the channel is armed + source-synchronized + no pending
> latency, call `drq_callback(0)` in-line, matching real 80186 DMA and the working
> PCE emulator (which clocks its DMA every step). One-line semantic change in
> `src/devices/cpu/i86/i186.h`. No reentrancy problem: the drain path is
> `drq_callback -> read data reg -> drop_drq -> drq_cb(false) -> drq0_w(0)`, and the
> `if(state)` guard skips the immediate-service block on the `0` call.
>
> **Verification [known]:** with the fix, the config menu, disk-maintenance app, and
> a compiled **C program** (MANDEL.CMD, Digital Research C) all load and run to
> completion (Mandelbrot ASCII render, returns to `A>`). **A/B causal proof:**
> reverting *only* the `drq0_w` change reproduces the exact original
> "CCP/M fejl: Program indløsning" at `A>`; restoring it fixes it. The 4us quantum
> and the HALT-path idle-loop tried during debugging were **both unnecessary** and
> were removed — the immediate-DREQ change alone is sufficient (re-verified).
>
> **Scope note [known]:** `i186.h drq0_w` is a generic MAME core change affecting all
> i80186-internal-DMA drivers (lb186, slicer, …). A regression check on those is
> required before any upstream mamedev submission.

### Original investigation notes (superseded by the resolution above)

**Symptom [known]:** the machine boots the OS from floppy (reaches `A>`, shows
"Concurrent CP/M-86 3.1", correct clock), but *every* subsequent file access fails:
- any `.CMD` (date, pip, menu, …) -> "CCP/M fejl: Program indløsning"
- `dir` -> "Diskette fejl"

Even tiny programs fail, so it is not a size/overlay issue.

**Failure signature [known]:** every post-boot READ SECTOR completes with **LOST DATA
(status bit 0x04)** set; many track-2 reads additionally raise **RNF (0x20 -> status
0x24)**. Boot-time reads do NOT set LOST DATA and succeed. This points at the WD2797
data transfer via the 80186 internal DMA, but the exact root cause is **not** yet
proven — see below.

**Suspected cause [guessed, not yet proven]:** MAME's `i80186` DMA does not service
the WD2797's per-byte DRQ in time in the (source-synchronized) mode CCP/M programs
after boot, so the FDC data register is not drained before the next byte -> LOST DATA
-> the OS rejects the sector and retries, then gives up. The boot ROM uses a DMA
setup that happens to work; CCP/M's XIOS setup does not. This is consistent with the
long-standing driver TODO "Floppy I/O errors" (rc759.cpp:9). NOT yet confirmed by a
check of the i80186 DMA sync-mode handling.

### FDC trace evidence [known]
Instrumented the driver (wrappers `fdc_log_r`/`fdc_log_w` around the WD2797 register
window, plus a `floppy_control_w` CTL log) because **lua io taps do NOT catch the
80186's OUT instructions to the FDC** (only ~42 io writes seen in a whole boot, none
in 0x28x). Instrument the driver map handler, not an io tap.

Boot vs post-boot contrast (same machine, same disk = the in-machine oracle):

| Phase      | READ cmd bytes | CTL byte | LOST DATA? | Result   |
|------------|----------------|----------|------------|----------|
| Boot       | 8c / 9c / 9e   | 0x42/46  | no         | success  |
| Post-boot  | 88 / 8a        | 0x4a     | yes (0x04) | fails    |

- Side select is *exercised* [known — from traces]: post-boot reads target both sides
  (cmd bit1: 88=side0, 8a=side1) and both track 0 and track 2 (the CP/M directory
  track). RNF appears only on track 2, never track 0. This shows the side/track values
  the OS *requests*; it does NOT prove the driver's side/seek handling is correct.
- Notable CTL delta: post-boot always sets **bit3 (0x08)** (`0x4a`), boot never does
  (`0x42/0x46`). Driver comment labels bit3 "write precomp" [guessed — unverified
  whether bit3 has another HW meaning the driver drops].
- Seeks do happen [known]: type-I restore (0x00), seek (0x1c ×51), etc. Head is being
  commanded to track 2; the RNF-on-track-2-only pattern is consistent with either a
  seek that doesn't land or an ID/verify mismatch [guessed].

Trace reproduction:
```
cd /Users/ravn/z80/mame && rm -f nvram/rc759/nvram
./regnecentralend rc759 -bios 0 -sound none -window -skip_gameinfo \
  -flop1 <abs>/disk1.img -autoboot_script /tmp/rc759trace.lua -nothrottle \
  -seconds_to_run 480 2>&1 | grep -E 'FDC|>>>'
```
(the lua types `dir`/`date` at set frames; see /tmp/rc759trace.lua).

---

## 2. Oracle: **PCE is a complete, working oracle** [known]

PCE (Hampa Hug's emulator, v0.2.2, `src/arch/rc759/`) runs the **exact same machine,
same disk1.img, same CCP/M-86 3.1** and **dir/programs work**. So PCE is ground truth
for our precise case — better than any other MAME machine (which would be a different
disk/OS, e.g. `ngen` is even `MACHINE_NOT_WORKING`).

Why PCE works and MAME doesn't — the mechanism [known, from PCE source]:
- PCE's `wd179x` model **also** models DRQ + LOST DATA (wd179x.c:852-854), same
  semantics as MAME's `wd_fdc`. So the difference is *timing*, not a missing feature.
- PCE wires DRQ straight to the DMA (rc759.c:937):
  `wd179x_set_drq_fct(&wd179x, &dma, e80186_dma_set_dreq0)`.
- PCE's `e80186` DMA (chipset/80186/dma.c `e80186_dma_clock_chn`) is **source-
  synchronized on DREQ**: when the channel is started and `dreq[idx]` is asserted it
  transfers exactly one byte from the FDC data port (getio -> `wd179x_get_data`, which
  clears DRQ) to memory, then increments/decrements and decrements count. Control bits
  (dma.h): SYN1=0x80, SYN0=0x40 (bits 6-7 select sync mode), IDRQ=0x10 internal DRQ,
  STRT=0x02 start. `(ctl>>6)&3 == 0` -> unsynchronized; else if IDRQ -> internal; else
  -> external DREQ synchronized (the FDC path).
- The DMA is clocked every emulation step (`e80186_dma_clock2`), so a byte is moved
  promptly on each DRQ -> **DRQ is cleared before the next byte -> never LOST DATA.**

**What the oracle tells us [known]:** the correct behavior is that when the WD2797
asserts DRQ, the i80186 DMA channel (source-synchronized on drq0) must transfer that
byte promptly. MAME's "LOST DATA on every post-boot read" means MAME's i80186 DMA is
NOT draining the WD2797 data register while DRQ is up, for the DMA mode CCP/M uses.

**Next step to pin it [guessed direction]:** instrument PCE the same way (log each
wd179x command with C/H/S and each DMA byte), run boot+dir, and diff the sector
sequence and the DMA control-word CCP/M programs against what MAME's i80186 DMA does
with the same control word. Then check MAME `machine/i80186.cpp` DMA sync-mode /
transfer-on-DREQ handling against PCE's `e80186_dma_clock_chn`.

### Other MAME references (secondary) [known]
Drivers pairing a `wd_fdc`-family chip with the i80186 *internal* DMA via `drq_wr`:
- `ampro/lb186` (WD1772 -> drq0_w) and `slicer/slicer` (FD1797 -> drq0_w): same
  drq0 wiring as rc759. This does **not** clear rc759's wiring [guessed] — the driver
  does not work, so the DRQ path (and everything around it) stays suspect until a
  check proves it.
- `compugraphic/pwrview` (UPD765A -> drq0_w).
- `skeleton/ngen` (WD2797 -> drq1_w), `siemens/pcd`, `philips/yes`, `digilog320`
  (drq1_w). ngen is the only other WD2797 + i80186-DMA machine but is
  `MACHINE_NOT_WORKING`.
These show the wiring *pattern* exists elsewhere; they do NOT verify rc759's copy of
it and are not verified-working floppy references. PCE remains the authoritative
oracle.

---

## 3. NVRAM (documented; several bytes verified)

**Mechanism [known]:** 256 × 4-bit cells = 128 host bytes. Bank-switched via PPI port C
bits 4-5 (`ppi_portc_w`: `m_nvram_bank=(data>>4)&0x03`). I/O-mapped 0x080-0x0FF
(`nvram_r`/`nvram_w`). **Nibble order:** even cell index -> HIGH nibble of the host
byte, odd -> LOW (matches PCE `rc759_nvm_get_uint4`). This nibble order was fixed in
the driver this/earlier session.

**Checksum [known]:** byte0 is the checksum such that `sum(bytes[0..95]) & 0xff == 0xaa`
(PCE `rc759_nvm_fix_checksum`: `byte0 = (byte0 + 0xaa - sum) & 0xff`). After any edit,
recompute byte0 or the bootloader rejects the NVRAM.

**Sanitize [known]:** byte 0x1a = data-buffer count, must be >= 2 (PCE
`rc759_nvm_sanitize`); correlates with the boot screen "2 Data buffer(e)".

**Verified decoded bytes [known]:**
| Offset | Meaning                     | Notes                                        |
|--------|-----------------------------|----------------------------------------------|
| 0x00   | checksum                    | 0xdf for the working default                 |
| 0x17   | BAUD RATE index             | only reliably mapped serial field            |
| 0x19   | **DEFAULT LOAD** (autoboot) | ASCII medium letter: 'M'=PROM, 'N'=NET, 'A'=DRIVE A, 'B'=DRIVE B |
| 0x1a   | data buffers                | must be >= 2 (=2 in default)                 |

Other non-zero default bytes (semantics **[guessed]**, not individually verified):
0x0d=0x90, 0x0e=0x04, 0x11=0xc0, 0x13=0x21, 0x14=0x05, 0x16=0x07, 0x18=0x01, 0x35=0xff.

### Autoboot fix [known — verified boots to A> out-of-the-box]
Stock NVRAM had DEFAULT LOAD = 'M' (PROM) -> machine stops at the LOADMEDIUM prompt.
Setting **0x19 = 'A'** (DRIVE A) + fixing checksum **byte0 = 0xdf** makes it autoboot
straight to `A>`. Baked into the driver's `nvram_init` default (rc759.cpp ~540) with a
comment, so it works with no external nvram file. Diff vs stock default = exactly these
2 bytes.

### L (SYSTEM PARAMETERS) menu, param order [known]
0 BAUD RATE, 1 STOP BITS, 2 PARITY, 3 BITS/TEGN, 4 DEFAULT LOAD, 5 ISBX_TYPE, 6 MODE,
7 M-DISK, 8 DISK STOPTID, 9 SYSTEM DISK, 10 COLOUR.
W menu = clock/date (YEAR/MONTH/DAY/HOUR/MINUT/SECOND). Bootloader = "PICCOLINE
BOOTLOADER VERSION 2.1"; main menu = SELECT LOADMEDIUM (A/B/L/W).

### Editing NVRAM via the keyboard matrix [known]
The bootloader's arrow menus are **not** driven by `natkeyboard:post_coded("{DOWN}")`.
Drive the matrix directly:
`manager.machine.ioport.ports[":kbd:row_N"]:field(mask):set_value(1)` then `:set_value(0)`
~12-14 frames later. Reliable pattern for menus = consecutive DOWNs (300-frame spacing
OK) then RIGHTs; interleaving RIGHT-then-DOWN breaks (only the first edit registers).
Arrow masks: DOWN=row_5 0x0001, LEFT=row_4 0x2000, RIGHT=row_4 0x4000, UP=row_4 0x8000;
Y=row_1 0x0020. `natkeyboard:post("text")` works for typing commands.

---

## 4. Disk / FDC hardware facts [known]

- FDC = **WD2797** (`wd2797_device`), registers at 0x280/0x282/0x284/0x286 (16-bit
  spacing, `umask16 0x00ff`): cmd/status, track, sector, data.
- `floppy_control_w` (0x288): bit0 drive select, bit1 motor0, bit2 motor1, bit5 dden,
  bit6 clock (2/1 MHz), bit7 force_ready. bit3/bit4 per driver comment = write precomp
  / precomp select [guessed].
- Side select: no dedicated port; WD2797 `update_sso()` drives `floppy->ss_w` from
  command bit1 (wd2797 ctor sets `side_control=true, side_compare=false`). Traces show
  side1 reads are *issued* and reach the floppy call; this does NOT prove the side
  path is fully correct in the broken driver [guessed].
- Disk format (`rc759_dsk.cpp`): 5.25" DSHD MFM, 8 sec/track, 77 trk, 2 sides,
  1024 B/sec, base sector ID 1. disk1.img = 1,261,568 B = 77×2×8×1024 exactly.
- DRQ wiring: `m_fdc->drq_wr_callback().set(m_maincpu, i80186_cpu_device::drq0_w)`
  (rc759.cpp:714). `m_drq_source` (PPI port C bits 2-3) is stored but **not used** to
  gate the DRQ path. Whether hardwiring FDC DRQ to drq0 and ignoring `m_drq_source` is
  correct is **[guessed/suspect]** — the driver is broken, so this is a candidate bug,
  not a cleared component.

---

## 5. Save states [known]
`manager.machine:save("name")` works (writes `sta/rc759/name.sta`). LOAD (`-state name`)
restores CPU/RAM but leaves the **i82730 video blank** (display-list/CA state not
restored) — so save states are unreliable for visual iteration on rc759 as-is.

---

## Debugging quirks to remember [known]
- lua io read/write taps on the 80186 io space do NOT catch the CPU's OUT to the FDC;
  instrument the driver's memory-map handler instead.
- Always run MAME with `-window`; never plain `-log` (produces a 13 GB error.log).
- `-debug` starts paused so autoboot lua won't advance.
- Rebuild: `make SUBTARGET=regnecentralen DEBUG=1 SOURCES=...rc759.cpp,... TOOLS=1
  SYMLEVEL=3 SYMBOLS=1 OSD=sdl -j 10` (macOS needs OSD=sdl).

## Source references
- MAME: `src/mame/regnecentralen/rc759.cpp`, `src/devices/machine/wd_fdc.cpp`,
  `src/devices/machine/i80186.cpp` (DMA), `src/lib/formats/rc759_dsk.cpp`.
- PCE (oracle): `src/arch/rc759/{fdc.c,rc759.c,nvm.c}`,
  `src/chipset/wd179x.c`, `src/chipset/80186/dma.c` (extract from `/tmp/pcesrc/pce.tar.gz`).
