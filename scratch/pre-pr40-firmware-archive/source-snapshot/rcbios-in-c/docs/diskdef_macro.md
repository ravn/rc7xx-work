# The DRI DISKDEF macro — reference

`DISKDEF` is a [MAC](http://www.cpm.z80.de/manuals/mac.pdf) macro library shipped
with the original Digital Research CP/M 2.2 distribution. Its job: take a handful
of physical-geometry primitives for a disk format and **expand** into the
complete set of CP/M data structures — DPH, DPB, XLT (skew table), CSV, and ALV
storage reservations — that the BIOS needs for that format.

Without DISKDEF you hand-calculate all ten DPB fields per format, plus write the
DPH entries, compute AL0/AL1 bitmaps, and reserve CSV/ALV buffers. With DISKDEF
you write one line per format and the macro library does the arithmetic.

The RC702 BIOS doesn't use this macro (it's written in C, not assembly, and the
four formats are hand-tabulated in [bios.c](../bios.c)). The reason to document
DISKDEF here is that **understanding it is the shortest path to understanding
the structures**. Our DPB values look like arbitrary numbers until you know
what primitives they were derived from — DISKDEF is the canonical derivation.

## Sources (authoritative)

- [CP/M 2.2 Alteration Guide (1979)](https://bitsavers.trailing-edge.com/pdf/digitalResearch/cpm/2.2/CPM_2.2_Alteration_Guide_1979.pdf) §10-11 — the primary reference; includes the full DISKDEF.LIB listing in Appendix F and the field-by-field derivation tables
- [CP/M 2.2 HTML manual, §6 (CP/M Alteration)](http://www.gaby.de/cpm/manuals/archive/cpm22htm/ch6.htm) — rendered HTML of the same material
- [CP/M 2.2 HTML manual, Appendix F (Disk Definition Library)](http://www.gaby.de/cpm/manuals/archive/cpm22htm/axf.htm) — DISKDEF.LIB source walk-through
- [idealine.info: DPB field reference](https://www.idealine.info/sharpmz/dpb.htm) — compact DPB/DPH field summary (our `cpm_naming.md` distills this)

## Macro invocation form

```
DISKDEF   dn, fsc, lsc, [skf], bls, dks, dir, cks, ofs, [0]
```

| Parameter | Meaning |
|-----------|---------|
| `dn`  | Logical disk number being defined, `0..n-1` |
| `fsc` | First physical sector number on a track (usually 0 or 1) |
| `lsc` | Last physical sector number on a track |
| `skf` | **Optional** sector skew factor; omit or 0 for no interleave |
| `bls` | Data allocation block size in bytes. Must be one of 1024, 2048, 4096, 8192, 16384 |
| `dks` | Total disk size, expressed as a count of `bls`-sized blocks |
| `dir` | Total number of directory entries (may exceed 255) |
| `cks` | Number of directory entries to include in the check vector (0 for fixed media, = `dir` for removable) |
| `ofs` | Number of reserved system tracks skipped at the start of the (logical) disk |
| `[0]` | **Optional** CP/M 1.4 compatibility flag — forces 16K allocation per directory record |

Shorthand: `DISKDEF i, j` gives disk `i` the same characteristics as previously defined disk `j`.

A full BIOS disk definition sequence looks like:

```
        MACLIB  DISKDEF
        ...
        DISKS   n                       ; allocates n DPH slots
        DISKDEF 0, 1, 26, 6, 1024, 243, 64, 64, 2
        DISKDEF 1, 0                    ; drive 1 same as drive 0
        DISKDEF 2, 0
        DISKDEF 3, 0
        ENDEF                           ; reserves CSV/ALV storage
```

`DISKS` generates the DPH table at label `DPBASE`. `ENDEF` emits uninitialized
BSS areas for the check vectors (CSV0, CSV1, ...) and allocation vectors (ALV0,
ALV1, ...) whose sizes are derived from each disk's CKS and DSM.

## Derivation of the 10 DPB fields

Given the primitives, DISKDEF computes every DPB field:

### SPT — Sectors Per Track

```
SPT = lsc - fsc + 1
```

Straightforward — count of physical sectors on a track.

### BSH, BLM — Block Shift, Block Mask

Fixed table keyed by `bls`:

| BLS   | BSH | BLM | (BLS = 2^(BSH+7))             |
|-------|-----|-----|-------------------------------|
| 1024  | 3   | 7   | 128 × 2^3 = 1024 bytes        |
| 2048  | 4   | 15  | 128 × 2^4 = 2048 bytes        |
| 4096  | 5   | 31  | 128 × 2^5 = 4096 bytes        |
| 8192  | 6   | 63  | 128 × 2^6 = 8192 bytes        |
| 16384 | 7   | 127 | 128 × 2^7 = 16384 bytes       |

Formulas: `BSH = log2(BLS / 128)`, `BLM = 2^BSH - 1 = (BLS / 128) - 1`.

### EXM — Extent Mask

Depends on both `bls` and whether `DSM` is small (`< 256`, fits one byte) or
large (`> 255`, needs word):

| BLS   | DSM < 256 | DSM > 255 |
|-------|-----------|-----------|
| 1024  | 0         | N/A       |
| 2048  | 1         | 0         |
| 4096  | 3         | 1         |
| 8192  | 7         | 3         |
| 16384 | 15        | 7         |

(Formula: `EXM = (BLS / 1024) - 1` for small DSM; `EXM = (BLS / 2048) - 1` for large DSM. BLS=1024 with large DSM is marked invalid — the FCB extent field is too small.)

### DSM — Disk Size (in blocks), minus one

```
DSM = dks - 1
```

`DSM` is the maximum valid block number. Total storage in bytes = `BLS × (DSM + 1)`. Must fit on the physical medium after subtracting reserved tracks (`ofs × SPT × sector_size`).

### DRM — Directory Entries, minus one

```
DRM = dir - 1
```

### AL0, AL1 — Directory-Block Reservation Bitmap

A 16-bit bitmap (AL0 = high byte, AL1 = low byte) with the top N bits set,
where N is the number of `bls`-sized blocks needed to hold `dir` directory
entries (each entry is 32 bytes):

```
N = ceil(dir × 32 / BLS)
```

Each set bit reserves one data block for directory use. Bit position 0 = MSB of
AL0; position 15 = LSB of AL1. So for 2 reserved blocks, AL0 = 11000000₂ = 0xC0
and AL1 = 0. For 4 reserved blocks, AL0 = 0xF0, AL1 = 0.

Direct entries per block:

| BLS   | dir entries per block |
|-------|------------------------|
| 1024  | 32                     |
| 2048  | 64                     |
| 4096  | 128                    |
| 8192  | 256                    |
| 16384 | 512                    |

Example: DRM = 127 (128 entries), BLS = 1024 → 32 entries/block → 128/32 = 4 blocks → AL0 = 0xF0, AL1 = 0.

### CKS — Check area Size

```
CKS = (DRM + 1) / 4    when media is removable (floppy)
CKS = 0                when media is fixed      (hard disk)
```

CP/M uses CSV bytes to checksum-watch directory entries and detect media change
between calls. Fixed media doesn't change between BDOS calls so no checking is
needed.

### OFF — Reserved Tracks

```
OFF = ofs
```

Directly passed through. `SETTRK` adds `OFF` to every logical track before the
physical seek; lets you reserve tracks for the boot image / system area without
the BDOS seeing them.

## DPH expansion

For each disk defined, `DISKS` emits a 16-byte DPH of the form:

```
DPE0:   DW   XLT0, 0000H, 0000H, 0000H, DIRBUF, DPB0, CSV0, ALV0
```

- **XLT0** — translation table (or 0000H if `skf` was omitted)
- **0000H × 3** — three words of BDOS scratch
- **DIRBUF** — the shared 128-byte directory buffer (one per *system*, not per disk)
- **DPB0** — pointer to this disk's DPB
- **CSV0** — pointer into the CSV BSS area (sized `CKS` bytes)
- **ALV0** — pointer into the ALV BSS area (sized `(DSM/8) + 1` bytes)

When multiple disks share identical characteristics, `DISKDEF i, j` makes disk
`i` point at disk `j`'s DPB and XLT but still allocates independent CSV and ALV
buffers (each disk needs its own per-drive state).

## XLT — Sector translation (skew) table

Built only when `skf` is non-zero. Generated by walking sector numbers starting
at `fsc`, stepping by `skf` mod `SPT`, skipping already-placed entries. Size is
`SPT` bytes if `SPT < 256`, else word-per-entry (for megabyte-class drives).

Our `verify_skew.py` runs exactly this algorithm against our hand-written
`xlt_*` tables.

## ENDEF — BSS reservation

After all `DISKDEF` calls, the `ENDEF` macro emits:

```
CSV0:   DS   CKS0         ; size from disk 0's CKS
CSV1:   DS   CKS1         ; size from disk 1's CKS
...
ALV0:   DS   (DSM0/8)+1
ALV1:   DS   (DSM1/8)+1
...
DIRBUF: DS   128           ; shared by all disks
```

These labels match the addresses stamped into each DPH.

## Worked examples from the Alteration Guide

```
DISKDEF 0, 1, 26,  6, 1024,  243,  64,  64, 2   ; 8" SSSD IBM standard
DISKDEF 0, 1, 58,   , 2048,  256, 128, 128, 2   ; 8" DSDD, removable
DISKDEF 0, 1, 58,   , 2048, 1024, 300,   0, 2   ; 8" DSDD, fixed (non-removable)
```

First call: 26 sectors/track, skew 6, 1KB blocks, 243 blocks (~249KB), 64 dir
entries, all 64 checked (removable), 2 reserved tracks.

Third call: same physical format but fixed media, so `CKS=0` (no checking) and a
larger dir (300 entries, allowed to exceed 255).

## Relation to our RC702 C BIOS

Our four DPBs in [bios.c](../bios.c) can be read as manually-expanded DISKDEF
invocations:

```
DISKDEF MAXI_FM,  1, 26,  6, ?,  ?,    ?, ?, 2   /* dpb_maxi_128 */
DISKDEF MAXI_DD,  1, 15,  4, ?,  ?,    ?, ?, 2   /* dpb_maxi_512 */
DISKDEF MINI,     1,  9,  2, ?,  ?,    ?, ?, 0   /* dpb_mini_512 */
DISKDEF MAXI_T0,  1, 26,   , ?,  ?,    ?, ?, 0   /* dpb_maxi_256 */
```

The missing primitives (`bls`, `dks`, `dir`, `cks`) are implicit in each DPB's
values — e.g., `dpb_maxi_512.bsh == 4` tells us `BLS = 2048`. When we want to
derive the DPBs algorithmically (see the todo item "capture metadata-to-DPB
derivation in code"), we'll need to specify those primitives explicitly in a
Python generator or a set of C preprocessor macros that expands to the same
10-field initializer.

The chief value of writing the derivation in code:

1. **Single source of truth** — changing `bls` in the metadata updates `bsh`,
   `blm`, `exm`, and the AL0/AL1 bitmap consistently
2. **Spec validation** — a build-time check that hand-written DPBs match the
   derivation is an analog of [verify_skew.py](../verify_skew.py) but for
   BDOS-ABI layout
3. **Pedagogical** — a new contributor reading the generator learns the
   derivation, whereas reading `{ 120, 4, 15, 0, 449, 127, 192, 0, 32, 2 }`
   teaches them nothing

## See also

- [cpm_naming.md](cpm_naming.md) — field-by-field naming conventions used in this BIOS
- [intel_8275_datasheet.md](intel_8275_datasheet.md) — CRT controller transcription
- [../verify_skew.py](../verify_skew.py) — runtime implementation of the DISKDEF skew algorithm as a build-time check
