# RC759 Piccoline CCP/M-86 XIOS — Reverse Engineering

Byte-perfekt NASM-genskabelse af **Concurrent CP/M-86 3.1** til Regnecentralen RC759 Piccoline (dansk 80186-skolecomputer, 1984–89).

## Status

**100% byte-identisk** mod alle referencebinaries (commit `c0b9396`):
- `XIOS1.CON` (25.728 bytes) — 1 virtuel konsol
- `XIOS4.CON` (29.440 bytes) — 4 virtuelle konsoller
- `ccpm.sys` (77.568 bytes) — komplet CCP/M-86 kerne

Alle tre orakler er versioneret i `dist/` (SHA256 i `dist/SHA256SUMS`).

## Serienummer / licens

Hvert MEMIF-modul bærer en DRI-copyright-streng der slutter med licensnummer +
serienummer — i DRI's kilde (`ccpmv31` `D1/INIT.SUP`) en placeholder `'654321'`
som GENCCPM patchede pr. licensager. RC759-distributionen har licens
`1034-0261` (Regnecentralen) og serienummer `007041`. Der er ingen runtime-validering.

Generel en variant med andet serienummer (svarende til GENCCPMs patch):

```bash
docker run --rm -v "$PWD:/work" -w /work/tasks/rc759-xios rc759-nasm \
  nasm -f bin -DLICENSE_NO='"1034-0261-"' -DSERIAL='"007042"' \
  -o /work/scratch/tmp/ccpm_variant.sys ccpm.asm
```

Standardværdier ligger i `license.inc`; default-byg er byte-identisk med originalen.


## Verificér

```bash
# Verificer XIOS1 + XIOS4 (kræver Docker image rc759-nasm):
sh tasks/rc759-xios/build_and_verify_xios.sh

# Verificer hele ccpm.sys:
sh tasks/rc759-xios/rebuild_and_verify.sh
```

## Byg Docker-image

```bash
docker build -t rc759-nasm tasks/rc759-xios/docker/
```

NASM-version: **2.15.05** (pinnet i Dockerfile — skift ikke uden re-verificering).

## Installer pre-commit hook

```bash
sh tasks/rc759-xios/hooks/install.sh
```

Hooken afviser commits der bryder byte-identitet for XIOS1/XIOS4.

## Nøglefiler

| Fil | Beskrivelse |
|-----|-------------|
| `xios.asm` | Master assembler-fil (inkluderer xios_code.asm) |
| `xios_code.asm` | Symboliseret XIOS-kode (~9.900 linjer) |
| `ccpm.asm` | Monolitisk ccpm.sys assembler |
| `rasm86.inc` | RASM-86 kompatibilitetsmakroer (d-bit, CS:LODS etc.) |
| `hardware.inc` | RC759 hardware-porte og konstanter |
| `dist/` | Versionerede oracle-binaries (reference for `cmp`) |
| `hooks/` | Pre-commit hook + install-script |

## Reference

- Piccoline Programmer's Guide v2: https://rc700.dk/files/documentation/PICCOLINE_Programmers_Guide_v2.pdf
- DRI CCP/M-86 kilder (ccpmv31.zip): http://www.cpm.z80.de/download/ccpmv31.zip
- Intel 82730: 1987 Intel Microprocessor and Peripheral Handbook Vol.2, kap.7 p.7-34

Se `HANDOFF-2026-11-25.md` for detaljeret status og næste skridt.
