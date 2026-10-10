# CP/M 2.2 BIOS Calling Convention (ABI)

Sources: DRI CP/M 2.2 BDOS source (`OS3BDOS.ASM`), DRI Skeletal CBIOS (`CBIOS.ASM`),
seasip.info CP/M BIOS reference, RC702 BIOS source (`rcbios/src/`).

## Critical BDOS Detail

The BDOS entry point receives user parameters in C (function number) and DE (data).
Before dispatching to character I/O BIOS functions, it executes:

    mov c,e   ;possible output character to C

The BIOS always receives the character in **C**, never in E.

## All 17 BIOS Entry Points

| # | Name    | Offset | Input                              | Output                           |
|---|---------|--------|------------------------------------|----------------------------------|
| 0 | BOOT    | +00h   | none                               | does not return                  |
| 1 | WBOOT   | +03h   | none                               | does not return                  |
| 2 | CONST   | +06h   | none                               | A = 00h (not ready) / FFh (ready)|
| 3 | CONIN   | +09h   | none                               | A = character (7-bit)            |
| 4 | CONOUT  | +0Ch   | C = character                      | none                             |
| 5 | LIST    | +0Fh   | C = character                      | none                             |
| 6 | PUNCH   | +12h   | C = character                      | none                             |
| 7 | READER  | +15h   | none                               | A = character (or 1Ah if none)   |
| 8 | HOME    | +18h   | none                               | none                             |
| 9 | SELDSK  | +1Bh   | C = drive (0-15), E bit0 = login   | HL = disk_parameter_header address (0 = error)     |
|10 | SETTRK  | +1Eh   | BC = track number (16-bit)         | none                             |
|11 | SETSEC  | +21h   | BC = translated sector (16-bit)    | none                             |
|12 | SETDMA  | +24h   | BC = DMA address (16-bit)          | none                             |
|13 | READ    | +27h   | (uses previously set drv/trk/sec)  | A = 0 (OK), nonzero (error)      |
|14 | WRITE   | +2Ah   | C = write type (0/1/2)             | A = 0 (OK), nonzero (error)      |
|15 | LISTST  | +2Dh   | none                               | A = 0 (not ready) / FFh (ready)  |
|16 | SECTRAN | +30h   | BC = logical sector, DE = xlat tbl | HL = physical sector             |

## Register Preservation

The BDOS saves any registers it needs before calling BIOS functions.
BIOS functions may freely clobber A, BC, DE, HL, and flags.

## sdcccall(1) Mapping

For a C BIOS using z88dk with sdcccall(1):

| Convention       | 1st 8-bit param | 2nd 8-bit param | 1st 16-bit param | 2nd 16-bit param | 8-bit return | 16-bit return |
|------------------|-----------------|-----------------|-------------------|------------------|--------------|---------------|
| CP/M BIOS        | C register      | E register      | BC registers      | DE registers     | A register   | HL registers  |
| sdcccall(1)      | A register      | L register      | HL registers      | DE registers     | A register   | DE registers  |

### Entry shims needed (parameter in C, sdcccall expects A)

    ; CONOUT, LIST, PUNCH: byte param in C → A
    _bios_xxx:
        ld a, c
        jp _bios_xxx_body

    ; WRITE: byte param (write type) in C → A
    _bios_write:
        ld a, c
        jp _bios_write_body

    ; SELDSK: C = drive (→ A), E = login flag (→ L for 2nd param)
    ; sdcccall(1): 1st 8-bit in A, 2nd 8-bit in L
    ; C→A needed, E→L needed — both happen to match
    ; Returns: sdcccall gives DE, CP/M wants HL → ex de, hl

    ; SETTRK, SETSEC, SETDMA: 16-bit param in BC → HL
    _bios_settrk:
        ld h, b
        ld l, c
        jp _bios_settrk_body

    ; SECTRAN: BC = sector (→ HL), DE = table (→ DE)
    ; 1st 16-bit in HL, 2nd 16-bit in DE — DE is already correct
    _bios_sectran:
        ld h, b
        ld l, c
        jp _bios_sectran_body

### Exit shims needed (sdcccall returns in A, but CP/M caller expects C)

READER and READS return a byte. sdcccall(1) returns in A.
**However**: the BDOS and most CP/M programs read the return value from **A**, not C.
The `ld c, a` exit shim is only needed for callers that explicitly read C
(e.g., SNIOS does `LD C,A` before `JP B$PUNCH`, suggesting it expects READER
to return in A — which it does natively).

    ; READER, READS: byte return in A — no shim needed for BDOS
    ; But SNIOS RECVBY does OR A after CALL B$READ, reading A — also fine.
    ; The ld c,a shim is defensive but harmless:
    _bios_reader:
        call _bios_reader_body
        ld c, a        ; defensive: some callers may read C
        ret

### Functions with no shim needed

- BOOT, WBOOT, HOME: no params, no return value
- CONST, CONIN, LISTST: no params, return in A (matches sdcccall)
- READ: no params, return in A (matches sdcccall)
- SELDSK: C→A, E→L — happens to match sdcccall(1) 2-param convention
