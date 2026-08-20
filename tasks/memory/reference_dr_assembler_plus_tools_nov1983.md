---
name: DR "Assembler Plus Tools" for CP/M-86 (November 1983) — versions & relevance
description: The genuine Digital Research CP/M-86 assembler/linker/debugger toolchain added to the workspace, with per-tool version numbers and how it maps to our tracked work.
metadata:
  type: reference
---

**Location:** `/Users/ravn/z80/cpm86-assembler-plus-november-1983/` (added by user
2026-08-20). Digital Research Inc. "Assembler Plus Tools for the CP/M-86 Family of
Operating Systems", **November 1983**. Genuine DR CP/M-86 transient tools (`.CMD`).

## Tool versions (from each binary's sign-on strings)

| Tool          | File          | Version | Date/©              | Role                     |
|---------------|---------------|---------|---------------------|--------------------------|
| RASM-86       | RASM86.CMD    | **1.2** | 10/31/83, ©1982,83  | Relocating assembler     |
| LINK-86       | LINK86.CMD    | **1.2** | ©1982,83            | Linkage editor           |
| LIB-86        | LIB86.CMD     | **1.1** | ©1982,83            | Library manager          |
| XREF-86       | XREF86.CMD    | **1.1** | ©1982,83            | Cross-reference          |
| SID-86        | SID86.CMD     | **1.x** | 07/12/82, ©1982     | Symbolic debugger (oldest)|
| (include)     | 8087DEF.A86   | —       | —                   | 8087 opcode defs for RASM-86 |

All share Serial No. `4007-0000-001720`. SID-86 is the oldest component (1982-only
copyright, dated Jul 1982) — RASM/LINK/LIB/XREF are the 1983 "plus" updates.

## READ.ME (Nov 1983) — documented changes, consistent with these versions

- **LINK-86 1.2:** new `8087REQUIRED` / `8087CONDITIONAL` switches (set an 8087 flag
  in the `.CMD` header record — OS refuses to load, or requires 8087 simulation,
  respectively) and `$MY` (send `.MAP` to printer); `MAP NOCOMMON` param; undefined
  symbol now reports file+module; three new errors CLASS/GROUP/SEGMENT NOT FOUND.
- **RASM-86 1.2:** `$NC` switch (do NOT upper-case — "supports users of C language
  software"); 8087 opcodes supported *iff* you `include 8087DEF.A86` (whose header
  says future RASM-86 will remove the need — matches the READ.ME note).
- **SID-86:** does NOT support symbol files for LARGE/COMPACT/MEDIUM model programs;
  must use LINK-86's `.MAP` and add the relative segment location to SID-86's
  displayed absolute segment. Consistent with SID-86 being the old 1.x/1982 build.

## Relevance to our work

- Directly tied to `KNOWN_ISSUES.md` §8 item **"DDT86/SID86 debug symbols in the
  .CMD"** — the actual SID-86 debugger is now in the workspace. The READ.ME's
  symbol/`.MAP` consumption model (relative+absolute segment) is exactly what that
  enhancement must reconcile with `wlink`-emitted debug info.
- LINK-86's 8087 header flags (`8087REQUIRED`/`CONDITIONAL`) inform the `.CMD`
  header / 8087-model work.
- All five tools are real CP/M-86 `.CMD` transients → usable as real-world test
  programs under emu2 and MAME rc759.

## The authoritative manual — "Programmer's Utilities Guide" (investigated 2026-08-21)

The manual that documents this tool bundle is **"Programmer's Utilities Guide for the
CP/M-86 Family of Operating Systems", Digital Research, 1983** (covers RASM-86,
LINK-86, LIB-86, XREF-86). Its existence + exact title/year is CONFIRMED from the
bibliography of the DR C manual ALREADY in the workspace:
`cpm86-crossdev/docs/manuals/DRI_C_Programming_86.pdf` p3 — cites it as "Programmer's
Utilities [Guide]" alongside the "C Language Programmer's Guide for the CP/M-86
Family". That DR C manual itself references RASM-86/LINK-86/LIB-86/XREF-86 throughout
(so the tools are already partially documented locally, appendix-level).

**Full-workspace search (2026-08-21): the standalone Programmer's Utilities Guide is
NOT cached.** Present PDFs are the CP/M-86 *Programmer's Guide* (Jan83), *System
Guide* (Jun83), *Concurrent* Programmer's Reference (Jan84), and the FlexOS 286
Programmer's Utilities Guide (`scratch/rc759-cmd-toolchain/docs/1073-2043-001_...`) —
none is the plain CP/M-86-family utilities guide.

Where to get it (not yet downloaded — user last redirected away from caching):
- **Concurrent variant (near-identical tool docs):** bitsavers
  `pdf/digitalResearch/concurrent/Concurrent_CPM-86_Programmers_Utilities_Mar83.pdf`
  (3.3 MB). Documents the same RASM-86/LINK-86/LIB-86/XREF-86.
- **Plain CP/M-86-family 1983 variant:** the exact cited edition — archive.org /
  retroarchive. retroarchive `drilib.html` also has `progutl.zip` (53 KB, "Programmers
  Utilities for the IBM/PC — covers RASM 86, XREF 86, LINK 86, LIB 86; was part of the
  DR C manual"), i.e. a text extract, not the standalone scan.
- bitsavers `pdf/digitalResearch/cpm-86/` does NOT contain it (only Programmer's/
  System/Users guides).

If cached later, follow the contrib/ravn .pdf + .txt convention and add a "Do NOT
re-download" note.

## Newer tool versions on Internet Archive? (investigated 2026-08-21)

KNOWN (verified this session):
- Workspace SID-86 binary sign-on = `SID86 1.` dated `07/12/82`, ©1982 only — i.e.
  version **1.x from July 1982**, the oldest tool in the bundle. This is our only
  local SID-86 copy (full-workspace search: `cpm86-assembler-plus-november-1983/SID86.CMD`
  is the sole SID86*/SID-86* file).
- Internet Archive **full-text keyword search** for "SID-86"/"SID86"/"RASM-86" returns
  only unrelated noise (wrestling videos, CIA reading-room docs, almanacs) — archive.org
  does NOT usefully index these DR CP/M-86 transient tools by name. So archive.org
  fulltext is NOT a reliable route to a "newer SID-86".

NOT verified (do not state as fact until checked):
- Whether a SID-86 newer than 1.x/Jul-1982 exists. Later DR products (Concurrent
  CP/M-86, Concurrent DOS 86) shipped their own debuggers, but I have NOT confirmed a
  higher-numbered stand-alone SID-86 build. LINK-86 in the workspace is v1.2 (Nov83)
  and elsewhere v1.4 (19 Mar 1984) — so the linker did get newer builds; SID-86's
  version history is unconfirmed.

Better sources to actually check versions (not archive.org fulltext):
- **bitsavers software collection** (`bits/`, not `pdf/`) + DR tool disk images.
- **retroarchive.org/cpm** DR software/tool disks.
- Version is only authoritative from a binary's own sign-on string (as done for the
  workspace copy above) — a scan/manual won't fix the tool version.

### The one real "newer SID86" hit on archive.org (2026-08-21)

Full search surfaced exactly ONE genuine SID86 item (rest = noise):
`mkl-20250402-10-mkl-A7100-SCP-1700-Symbolischer-Debugger-sid86` (dated **1986**),
"robotron Software für Arbeitsplatzcomputer A7100 unter SCP 1700 — Symbolischer
Debugger SID86", **VEB Robotron Projekt Dresden**. It is a **117 MB German manual
scan** (PDF + OCR), NOT a tool binary — and it documents the East-German **robotron
A7100 / SCP 1700** (a CP/M-86 clone) build of SID-86, not a newer Digital Research
release. So: archive.org does NOT host a DR SID-86 newer than our 1.x/Jul-1982; the
only newer artefact is a 1986 *clone* debugger manual in German. Not useful as a DR
version bump; potentially interesting only as extra SID-86 usage documentation.

## LINK-86 8087REQUIRED / 8087CONDITIONAL → exact .CMD header bits (verified 2026-08-21)

The READ.ME says both switches "set a flag in the header record of the .CMD file".
The exact flag is the **Program Flag = byte 127 (07FH)** of the CMD header. Verified
against the cached Concurrent CP/M Programmer's Reference Guide (Jan84) §3.1.2, p.80
(`open-watcom-v2/contrib/ravn/Concurrent_CPM_Programmers_Reference_Guide_Jan84.pdf`),
and consistent with our authoritative header note `[[reference_cpm86_cmd_header_ccpm_source]]`:

| LINK-86 switch     | byte 127 bit | mask | OS behaviour when NO 8087 present                     |
|--------------------|--------------|------|-------------------------------------------------------|
| **8087CONDITIONAL**| **bit 6**    | 0x40 | Program LOADS; uses 8087 *emulation/simulation* routines |
| **8087REQUIRED**   | **bit 5**    | 0x20 | Program is **NOT loaded** (BDOS error 17 / 11H "No 8087 in system") |

Guide verbatim (p.80): "Setting bit 6 (bit 0 is least significant bit) of the Program
Flag indicates optional 8087 support ... if the 8087 is present, the program uses it;
otherwise, the program will emulate it. If bit 5 of the Program Flag is set, it
indicates that the 8087 must be present ... If no 8087 is present and bit 5 ... is
set, [the program is not loaded]." LINK-86 "is used to set the program's header record
for optional or required 8087 support." When 8087 support applies the OS also
allocates an extra **96 bytes to the UDA** (p.80/99/254).

Note the SAME byte 127 carries **bit 7 (0x80) = load-time fixup records present** (OS
source `cmdh.def:18`/`load.sup:405`; NOT in DRI manuals). So a relocatable 8087-required
`.CMD` has byte 127 = 0xA0 (0x80|0x20). Relevant to our wlink `format cpm86` writer:
if we ever emit 8087 programs, set bit 5/6 here alongside the bit-7 fixup flag.
