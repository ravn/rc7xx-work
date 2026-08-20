---
name: Concurrent CP/M-86 v3.1 source — cached (newer than the 2.0 tree)
description: A newer CCP/M-86 kernel/utility source distribution than the v2.0 tree, obtained from the Tim Olmstead Memorial CP/M Library, with what it settles vs v2.0.
metadata:
  type: reference
---

**What / where.** Concurrent CP/M-86 **v3.1** (1984) full source distribution, cached
at `/Users/ravn/z80/scratch/ccpm31-src/` (`ccpmv31.zip`, 814490 bytes, sha256
`43d41e0be8d60def9e960de7a33581af49e315b738d51cfbbf9f3f6ad0580587`; 12 disks D1..D12,
393 files, mostly PL/M + ASM86). Banner `D2/CPYRIGHT.DEF`: "Concurrent CP/M-86 v3.1,
Copyright (c) 1982,1983,1984". Downloaded 2026-08-21 from the **Tim Olmstead Memorial
CP/M Library** (`http://www.cpm.z80.de/download/ccpmv31.zip`), the authoritative DRI
source archive. **Do NOT re-download.**

**Why it matters.** It is the **newest publicly-available CCP/M source** — strictly
newer than our v2.0 tree (`scratch/ccpm86-src/`, `ccpm8620.zip`, July-5-1983 account,
kern banner "V2.1"). A generic web search WRONGLY claimed nothing above 2.0 exists;
cpm.z80.de `source.html` lists it explicitly ("CCP/M v. 3.1 SOURCES ... 12 disk set
... from 1984 (including IBM PC & CompuPro XIOS)"). The same page also has MP/M-86 2.0
source (`mpm862sr.zip`) and CP/M-86 1.1 (`c8611src.zip`, already local as
`scratch/cpm86-11-src/`).

**What 3.1 settles that 2.0 left stubbed (verified 2026-08-21).** The v2.0 `LOAD.SUP`
reads the `.CMD` Program-Flag byte 127 but only acts on **bit 7 (fixups)**; its 8087
handling is commented out. v3.1 **enforces the 8087 bits**:
- `D2/CMDH.DEF`: `opt_8087 equ 040H` (bit 6 = optional/CONDITIONAL), `need_8087 equ
  020H` (bit 5 = required/REQUIRED), `susp_mode equ 008H` (bit 3 = suspend if
  background — NEW), and bit 7 still = fixups.
- `D1/LOAD.SUP` `ndpchk:` (l.109-127) does `test ch_lbyte[bx],need_8087` / `test
  ch_lbyte[bx],opt_8087`, compares `owner_8087`, sets `lod_ndp`; later
  `or p_flag[bx],pf_8087` (l.585) and allocates the long/emulator UDA
  (`u8087len`/`em87len`, +96 bytes).
- This confirms the DRI Programmer's Reference Guide §3.1.2 bit map (bit5=REQUIRED,
  bit6=optional) directly from OS source, and maps LINK-86's `8087REQUIRED`/
  `8087CONDITIONAL` switches (READ.ME of the Nov-1983 Assembler Plus Tools) to bit 5 /
  bit 6. See `[[reference_cpm86_cmd_header_ccpm_source]]` and
  `[[reference_dr_assembler_plus_tools_nov1983]]`.

**Relation to `.CMD` reloc work.** 3.1 `LOAD.SUP` (l.440 `test lod_lbyte,80h`) keeps
the same bit-7 fixup mechanism as 2.0, so our
`[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]` conclusions hold; 3.1 is a useful
cross-check for any loader-behaviour question where the 2.0 snapshot is incomplete.
