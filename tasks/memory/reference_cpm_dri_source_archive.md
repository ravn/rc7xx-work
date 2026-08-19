# Reference: authoritative Digital Research OS source archive

**Resource (user-provided fact, 2026-08-19):** original Digital Research
source code for the CP/M family lives at **https://www.cpm.z80.de/source.html**
("The Unofficial CP/M Website" — Digital Research Source Code).

Note: the site uses a **self-signed TLS cert**; `curl` needs `-k` (or fetch via
a browser). `web_fetch` fails the TLS handshake on it.

## Why this matters here — it is an INDEPENDENT oracle beyond emu2

emu2 (`emu2-cpm86/`) is our own reimplementation of the CP/M-86 loader, so it
is NOT authoritative for loader/relocation semantics — only MAME running a
genuine OS, OR the genuine DRI OS *source*, is. This archive is that source.

Directly relevant downloads for the open Stage B question (does the genuine
CCP/M loader walk the `.CMD` relocation table, or does the program
self-relocate? — see `[[reference_drc_cpm86_reloc_format]]` VERIFICATION
STATUS):

- **CCP/M-86 2.0 SOURCES (1.74M)** — "complete distribution of Concurrent
  CP/M-86 v2.0, July 5 1983", mostly PL/M + build tools, but the kernel is
  8086 assembler. The transient **Program Load** routine is `kern/load.sup`
  (P_LOAD path), with the header/fixup field defs in `kern/cmdh.def` and the
  base-page layout in `kern/basep.fmt` → authoritative answer to who applies
  `.CMD` fixups on the RC759's actual OS family (the loader does).
- **CCP/M-86 and CP/M-86 sources (196K)** — CCP/M-86 2.0 + ASM86/DDT86 sources.
- **CP/M-86 SOURCE (28K)** — commented disassembly, tentatively v1.1
  (`BDOS.A86`, "12 january 82").
- **CP/M-86 1.1 SOURCES (112K)** — original DRI, ASM; ROM bootstrap + BIOS for
  iSBC86/12.
- **MP/M-86 2.0 SOURCES (560K)** — DRI original disks.
- **CP/NET-86 SOURCE (42K)** — commented disassembly (relevant to the Z80-side
  CP/NET work too: CPNET-80 SOURCE 44K).

Also present: CP/M 1.x/2.0/2.2/3.0, MP/M I/II, CP/M-68K, PL/M compilers,
LINK/ASM tooling.

## RESOLVED 2026-08-19 — guard-coordinated dual reloc (loader OR crt0)

Downloaded **CCP/M-86 2.0 SOURCES** (`ccpm8620.zip`) → `scratch/ccpm86-src/`.
`kern/load.sup` (the transient Program-Load routine) + `kern/cmdh.def` show the
genuine Concurrent CP/M-86 loader (dated 29 June 1983) CAN apply `.CMD` fixups:
it tests byte-127 bit 7 (`load.sup:405`), reads the fixup table from the file
record named by `ch_fixrec` (header word 0x7D), and does `add es:[di],dx` per
4-byte record. BUT this is only half the story. DR C programs carry the SAME
table AND a CLEARL crt0 self-reloc walker, coordinated by a **relocatable guard
immediate** that is itself a fixup target: the loader relocating sets the guard
nonzero → crt0 skips self-reloc; a non-relocating loader (emu2, early CP/M-86)
leaves guard=0 → crt0 self-relocates. Never both. So the earlier "loader
relocates, NOT self-reloc" wording (and its predecessor "self-reloc only") were
BOTH over-swings — the truth is the guard-coordinated dual path. emu2 is
therefore NOT buggy for DR C. Full verified account:
`[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]`. Full header decode:
`[[reference_cpm86_cmd_header_ccpm_source]]`. Still verify wlink output under
MAME (emu2 exercises only the self-reloc/guard=0 path).

See also: `[[reference_drc_cpm86_reloc_format]]`,
`[[reference_cpm86_cmd_header]]`,
`[[tasks/plan-cpm86-big-model-2026-08-18]]`.
