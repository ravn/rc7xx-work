# BIOS Size Comparison: Assembly (REL30 MAXI) vs C

Comparing the original hand-written Z80 assembly BIOS with the C rewrite
(z88dk/sdcc). Both target the same REL30 MAXI (8" floppy, 56K CP/M) variant.

Source files:
- Assembly: [`rcbios/src/`](../rcbios/src/) — BIOS.MAC and included modules
- C: [`rcbios-in-c/`](.) — bios.c, crt0.asm, hal.h

## Summary

| Metric | Assembly | C | Difference |
|--------|----------|---|------------|
| Binary size | 6,426 B | 6,784 B | +358 B (+5.6%) |
| Code+data | 6,656 B | 6,655 B | −1 B (parity) |
| crt0.asm overhead | (included) | 280 B | JP table, IVT, config block |

The C BIOS is only 358 bytes (5.6%) larger than hand-written assembly.
Module-level analysis below shows where the overhead comes from.

## Module Comparison

```
Module       ASM      C    Diff  Ratio  Description
------------ ------ ------ ------ -----  --------------------------------
INIPARMS      256B   128B  -128B   50%  Config parameters
DANISH        384B   384B    +0B  100%  Character conversion tables
INIT          768B  1306B  +538B  170%  Hardware initialization + BOOTDPB
CPMBOOT       672B   516B  -156B   77%  JP table, boot, wboot, messages
SIO           391B   517B  +126B  132%  Serial I/O driver + ISRs
DISPLAY      1871B  1721B  -150B   92%  Display driver + BGSTAR
FLOPPY       1188B  1627B  +439B  137%  Floppy driver + blocking/deblocking
DISKTAB       420B   248B  -172B   59%  DPBs, translation tables, FDFs
INTTAB        256B     0B  -256B    0%  Interrupt vector table (in crt0.asm)
PIO           450B   208B  -242B   46%  Keyboard + parallel port + CRT ISRs
```

## Largest Discrepancies (C > ASM)

### 1. INIT: +538 bytes (170% of ASM)

The hardware initialization is the biggest source of C overhead.

| C function | Size | Notes |
|------------|------|-------|
| `cboot` | 879 B | crt0.asm entry + BSS clear + hw_init call + signon |
| `bios_hw_init` | 427 B | Port initialization sequences |

**Why larger**: The C compiler generates individual `ld a,N / out (port),a`
sequences for each port write. The assembly BIOS uses compact `OTIR` loops
that output arrays of bytes to sequential ports. The init parameter tables
(INIPARMS) are 128 bytes smaller in C because some are inlined as immediates,
but the code to use them is much larger.

**Optimization**: Replace individual port writes with OTIR-style inline asm
loops. The INIPARMS data could feed C wrapper functions that use `__asm` OTIR.
Estimated saving: 200–300 bytes.

### 2. FLOPPY: +439 bytes (137% of ASM)

| C function | Size | Notes |
|------------|------|-------|
| `rwoper` | 286 B | Blocking/deblocking with cache |
| `bios_seldsk_c` | 229 B | Disk selection + format detection |
| `xwrite` | 170 B | Buffered write with retry |
| `chktrk` | 130 B | Multi-density track dispatch |
| `secwr` | 106 B | Sector write to cache |
| `secrd` | 105 B | Sector read from cache |

**Why larger**: The blocking/deblocking algorithm (`rwoper`, `secrd`, `secwr`)
uses many static variables and conditional branches. sdcc generates verbose
load/store sequences for static variable access (3 bytes per access: `ld a,(NN)`
or `ld (NN),a`). The assembly version uses register-cached values and falls
through branches more compactly. `bios_seldsk_c` has complex format table
lookups that compile to large switch/if-else chains.

**Optimization**: Merge `secrd`/`secwr` common code paths (they share ~60%
of logic). Consider keeping hot variables in a struct accessed via pointer
(HL-relative) instead of individual statics. Estimated saving: 80–150 bytes.

### 3. SIO: +126 bytes (132% of ASM)

| C function | Size | Notes |
|------------|------|-------|
| `isr_sio_a_rx` | 70 B | Serial receive ISR |
| `linsel_reslin` | 68 B | Line selector reset |
| `bios_reader` | 49 B | Reader device |
| `isr_sio_a_spec` | 37 B | SIO special condition ISR |

**Why larger**: ISR wrappers have fixed overhead (SP switch, PUSH/POP 4 regs,
EI+RETI = ~20 bytes per ISR). The assembly ISRs share a common prologue/
epilogue via fall-through. Seven SIO ISRs × ~15B overhead ≈ 105B of pure
wrapper cost. The LINSEL code also generates verbose port I/O sequences.

**Optimization**: Merge trivial ISR stubs (sio_b_tx, sio_b_ext only set
flags). Consider a shared ISR dispatcher. Estimated saving: 40–60 bytes.

## Where C Wins

### DISPLAY: −150 bytes (92% of ASM)

The C display driver is *smaller* than assembly despite including BGSTAR.
`memcpy`/`memset` calls replace inline LDIR loops. The `specc` switch
statement compiles to a compact jump table. `scroll`, `insert_line`,
`delete_line` benefit from C's structured control flow.

### PIO: −242 bytes (46% of ASM)

The C ISRs for keyboard and parallel port are much more compact. The assembly
PIO module includes the full parallel output state machine inline; the C
version uses a simpler implementation.

### DISKTAB: −172 bytes (59% of ASM)

The C BIOS supports fewer disk formats (4 vs 9 FDFs, 4 vs 9 FSPAs) since
hard disk formats are excluded. The translation tables and DPBs are the same
size but there are fewer of them.

### CPMBOOT: −156 bytes (77% of ASM)

The boot code is more compact in C. The signon message and error strings are
shorter. The warm boot logic benefits from structured C.

## Top 20 Largest C Functions

```
Function                      Size   Module
cboot                         879B   INIT
bios_hw_init                  427B   INIT
convta (data)                 384B   DANISH
rwoper                        286B   FLOPPY
bg_clear_from                 274B   DISPLAY
bios_seldsk_c                 229B   FLOPPY
insert_line                   216B   DISPLAY
specc                         189B   DISPLAY
xwrite                        170B   FLOPPY
isr_crt                       150B   PIO
pchsav (data)                 145B   CPMBOOT
delete_line                   137B   DISPLAY
chktrk                        130B   FLOPPY
wboot_c                       117B   CPMBOOT
erase_to_eos                  109B   DISPLAY
secwr                         106B   FLOPPY
secrd                         105B   FLOPPY
clear_foreground               89B   DISPLAY
xyadd                          87B   DISPLAY
infd0 (data)                   81B   INIPARMS
```

## Optimization Priority

Ranked by potential byte savings:

1. **INIT port sequences** (+538B): Replace individual port writes with
   OTIR loops. Highest impact, moderate effort. Target: −200 to −300B.

2. **FLOPPY deblocking** (+439B): Refactor `secrd`/`secwr` shared logic,
   struct-pack hot variables. Moderate impact, high effort. Target: −80 to −150B.

3. **SIO ISR overhead** (+126B): Merge trivial ISR stubs, shared dispatcher.
   Low-moderate impact, moderate effort. Target: −40 to −60B.

4. **bg_clear_from** (274B): This is the largest BGSTAR function. Could
   use `memset` for whole-byte ranges. Target: −50 to −80B.

Total potential: −370 to −590 bytes, bringing the C BIOS close to or below
assembly size.
