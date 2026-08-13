# Official Regnecentralen RC759 DR C v1.11 disk — the pristine DR C oracle

Extracted 2026-08-13 from the datamuseum.dk RC759 archive. This REPLACES the
Ken Mauro `drc86111` DOS-emulator port as the default DR C correctness oracle,
because it is the genuine Regnecentralen artifact (the hobby port carries a
handful of patched serial bytes — see comparison below).

## The disk

- **Bits id 30005869** — "RC759 Piccoline — Digital Research C v. 1.11 - May 84",
  a 5¼" CP/M-86 floppy. Cached at
  `scratch/rc759-cmd-toolchain/ddhf-cache/bits/30005869.bin`.
- Format: **ImageDisk (IMD) 1.18**. Header comment: `DR C v. 1.11 / SW1609 rel 1.0`.
- Two sibling DR C disks (30002664 "CCP/M May 84", 30002725 "CCP/M Oct 83") are
  cached too but are **NOT IMD** — their blobs start with `RC750\0...` (a
  different DDHF container); `imd2raw.py` does not read them (out of scope, the
  v1.11 IMD disk is the oracle).

## Geometry (decoded, ground truth)

77 cyl × 2 heads = 154 tracks, 8 sectors/track, 1024 B/sector, uniform mode 3
(MFM). Physical sector-numbering skew per track: `(2,3,4,5,6,7,8,1)`.
Total 1,261,568 B. CP/M-86 filesystem DPB (from DDHF auto-analysis, confirmed by
the raw directory landing at 0x8000):
- block size **2048**, directory entries **96**, 16-bit block pointers,
  extent-mask 0, **2 reserved cylinders** → boottrk 4.

## Tooling (both in scratch/rc759-cmd-toolchain/)

- **`imd2raw.py in.imd out.raw`** — decodes IMD → flat raw image, de-skewing each
  track's sectors into ascending sector-number order (so cpmtools needs no skew).
- **`diskdefs`** — cpmtools diskdef `rc759-drc` (seclen 1024, tracks 154, sectrk 8,
  blocksize 2048, maxdir 96, boottrk 4, os 2.2).
  **GOTCHA:** this cpmtools build **ignores the `DISKDEFS` env var** and reads
  `./diskdefs` from the CWD. There is also a stale system `rc759` format that does
  NOT match — always run cpmls/cpmcp from a dir containing this `diskdefs` and use
  `-f rc759-drc`.

Extract recipe:
```
cd scratch/rc759-cmd-toolchain
python3 imd2raw.py ddhf-cache/bits/30005869.bin /tmp/drc.raw
cpmls -f rc759-drc /tmp/drc.raw            # list
cpmcp -f rc759-drc /tmp/drc.raw '0:*.*' rc759-drc-official/   # extract
```

## Extracted contents → `rc759-drc-official/` (25 files, tracked)

DRC.CMD (driver) + DRC860/861/862/DRCRPP.CMD (compiler passes) + DRC.ERR,
RASM86.CMD, LINK86.CMD, **LIB86.CMD** (the real binary — the hobby port only had
LIB86.BAT!), XREF86.CMD, CLEARS.L86/CLEARL.L86 (runtime), headers
STDIO/CTYPE/ERRNO/PORTAB/SETJMP.H, 8087DEF.A86, STARTUP.A86, INSTJOB.SUB,
R.CMD, READ.ME/READ1.ME, SAMPLE.C, TEST.C.
NOT on this single disk: DOS.H, ALLOC.H, CPMEOF.ASC (drc-oracle.sh fills these
from the drc86111 fallback).

## Official vs hobby port (drc86111) — why official is the better oracle

Compiler codegen passes are **byte-identical** (DRC860/861/862/DRCRPP), so
existing oracle results stand. The hobby port differs only in:
- DRC.CMD / LINK86.CMD / RASM86.CMD: **9 bytes each**, in a serial/copyright
  text region (a serialization patch, not codegen).
- CLEARL.L86 / CLEARS.L86: **2 bytes each** (one OMF data byte + its checksum).

## Oracle wiring (VERIFIED)

`drc-oracle.sh` now defaults `DRC=$HERE/rc759-drc-official` with
`DRC_FALLBACK=$HERE/drc86111` (fills DOS.H/ALLOC.H/CPMEOF.ASC). End-to-end proof:
`DRC_PUTCHAR=1 ./drc-oracle.sh hello.c` compiled (DRC v1.11 codegen), linked
(LINK-86 v1.4), and ran under emu2 → printed "HELLO FROM OFFICIAL DR C 1.11".

## Cross-refs
- reference_drc_toolchain_architecture.md — what each tool does + DR C pipeline.
- docs/datamuseum-rc750-rc759-archive.md — DDHF addressing / fetch-ddhf.sh.
