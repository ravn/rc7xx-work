# CP/M Structure Naming Conventions

Canonical DRI CP/M 2.2 abbreviations for the disk-management structures
referenced throughout `bios.c`, `bios.h`, and documentation. Use these names
verbatim inside DPB / DPH / FSPA structs so future readers can correlate
with the CP/M manuals and reference implementations.

Primary reference:
- https://www.idealine.info/sharpmz/dpb.htm
- CP/M 2.2 System Interface Guide (http://www.cpm.z80.de/manuals/cpm22-m.pdf), section 6.10

## DPH (Disk Parameter Header) — 16 bytes, one per drive

| Field | Meaning |
|-------|---------|
| `XLT`    | Logical-to-physical sector translation table pointer |
| `TRACK`  | Current track workspace |
| `SECTOR` | Current sector workspace |
| `DIRNUM` | Current directory number workspace |
| `DIRBUF` | 128-byte scratchpad for directory operations |
| `DPB`    | Disk Parameter Block pointer |
| `CSV`    | Check Sum Vector (media change detection) |
| `ALV`    | Allocation Vector (free-block bitmap) |

## DPB (Disk Parameter Block) — 15 bytes, one per format

| Field | Meaning |
|-------|---------|
| `SPT` | Sectors Per Track (logical, 128-byte) |
| `BSH` | Block Shift Factor (log2 of allocation block size) |
| `BLM` | Block Mask (2^BSH − 1) |
| `EXM` | Extent Mask |
| `DSM` | max allocation block number (disk size − 1 in blocks) |
| `DRM` | max directory entry number (dir entries − 1) |
| `AL0`, `AL1` | Allocation block reservation bits (16-bit pair for dir blocks) |
| `CKS` | Check area Size (size of CSV) |
| `OFF` | System-reserved tracks offset |

## Related

- `BLS`    — Block Size (derived: 2^(BSH+7))
- `SELDSK` — disk selection BIOS routine (returns DPH)
- `SETTRK` — track setter (applies OFF offset)

## Naming guidance for C code (applied in this codebase)

- Use `xlt_*` for skew tables (matches DRI tradition, short, recognizable).
- Use `dpb_*`, `dph_*`, `csv_*`, `alv_*`, `dirbuf`, `xlt` as short
  field/variable names.
- Use `disk_parameter_block` and `disk_parameter_header` as full typedef
  names — descriptive for new readers, while the short form stays at
  field access sites.
- Keep CP/M field names verbatim inside DPB/DPH structs: `spt`, `bsh`,
  `blm`, `exm`, `dsm`, `drm`, `al0`, `al1`, `cks`, `off`. Don't expand
  these — they are the language of CP/M and documented everywhere.

## Where this convention is applied

- `bios.h` — `disk_parameter_header` and `disk_parameter_block` typedefs,
  FSPA struct with working-copy fields.
- `bios.c` — `dpb_maxi_128`, `dpb_maxi_512`, `dpb_mini_512`, `dpb_maxi_256`
  format instances; `xlt_maxi_128`, `xlt_maxi_512`, `xlt_mini_512`,
  `xlt_identity` sector translation tables.
- `bios_hw_init.c` — runtime DPH table population (`dph_table[]`).
