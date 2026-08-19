# DR C 1.11 CP/M-86 relocation — the VERIFIED dual-path mechanism (2026-08-19)

**Supersedes the flip-flopping in `reference_drc_cpm86_reloc_format.md` and
`reference_cpm86_cmd_header_ccpm_source.md`.** This note is grounded in
disassembly of a real DR C large-model `.CMD` + emu2 runtime experiments +
the CCP/M-86 2.0 loader source. Every claim below is labelled VERIFIED.

## The question

A DR C large-model `.CMD` has BOTH:
- header byte 127 (`ch_lbyte`) bit 7 set + `ch_fixrec` fixup table (the OS
  loader's relocation path — `kern/load.sup:405-449`), AND
- a `CLEARL` crt0 that self-relocates at startup.

How can the program be relocated by the loader AND relocate itself without
double-relocating? Answer: **it never does both.** Exactly one actor applies
the fixups, chosen by a self-coordinating guard flag.

## The guard flag (VERIFIED)

CLEARL's entry begins (disassembly of `RELOCSEG.CMD` code group, addr 0x175):

```
0175: b9 00 00     mov cx, 0        ; <-- the 0x0000 immediate is a FIXUP TARGET
0178: e3 01        jcxz 0x17b       ; cx==0 -> fall to self-reloc walker
017a: c3           ret              ; cx!=0 -> RETURN, skip self-relocation
017b: 8b 0e 2d 00  mov cx, [0x2d]   ; aux4 (type-8) group load segment = fixup table
...  -> walks the table doing  add es:[loc], <target group base-page segment>
```

The 16-bit immediate of `mov cx,0` lives at code offset 0x176 = paragraph
0x017, byte 6. **The DR C fixup table contains a record for exactly that
location** (`RELOCSEG.CMD` fixup rec #561: `loc=CODE para=0x017 off=6
target=CODE stored=0x0000`). So:

- **Loader relocates** (byte127 bit7 honoured): loader does
  `add es:[code:0x176], code_seg` → the immediate becomes `code_seg` (nonzero)
  → runtime `mov cx,code_seg` / `jcxz` not taken / `ret` → **CLEARL skips
  self-reloc**. The loader already did it. No double.
- **Loader does NOT relocate** (emu2; also plain CP/M-86 loaders that ignore
  `ch_fixrec`): the immediate stays 0x0000 → `jcxz` taken → **CLEARL
  self-relocates**, walking the same table (reached as the type-8 aux group,
  whose load segment CLEARL reads from base-page slot 0x2d) and adding each
  target group's ACTUAL load segment (read from the base-page group
  descriptors at 0x03/0x09/0x0F/0x15/... that the loader filled in).

The guard is nonzero **iff** the loader ran the fixups. Perfect coordination
with no shared state beyond the relocatable immediate itself.

## CLEARL self-reloc walker (VERIFIED, disasm addr 0x220)

For each 4-byte record `[grp][para:2][offs:1]`:
- `dx` = base-page segment of the TARGET group (low nibble of `grp`), read from
  the descriptor table CLEARL pushed from base-page offsets 0x03..0x2d.
- `es` = base-page segment of the LOCATION group (high nibble) + `para`.
- `add es:[offs], dx`  — same op the loader would do, same value (the actual
  load segment), which is why doing both would double.

## Corroboration: the "LINK86 V1.2 or later" abort (VERIFIED, our dev history)

The self-reloc path first reads `mov cx,[0x2d]` = the AUX4 (type-8) group's load
segment from base-page slot 0x2D; `jcxz` → if 0 it aborts printing **"You must
link with LINK86 V1.2 or later."** (bytes at code 0x19c decode to exactly that
string). So the abort fires only when guard=0 (loader did NOT relocate) AND the
reloc-table aux group is absent from the base page. We hit this for real: our
Unicorn runner (`open-watcom-v2/contrib/ravn/cpm86run_unicorn.py`) originally
loaded only CODE+DATA groups, so CLEARL's `[0x2d]` was 0 and every large-model
`.CMD` aborted with that message (documented in `large-model-runner.sh` history).
Fix was to load ALL groups and fill the base-page descriptors — which is why the
type-8 aux group and base-page slot 0x2D matter. emu2 works because it does load
aux groups and sets slot 0x2D (`CPM_GDESC(0x2A,...)`; segment at 0x2A+3=0x2D).

## Experiments (VERIFIED, emu2)

Artifacts in `scratch/rc759-cmd-toolchain/mame-tests/`:
- `relocseg.c` -> `RELOCSEG.CMD` : prints the segment word of a global far
  function pointer. emu2: `code seg = 00e4` (= emu2 code_seg 0x0098 +
  group-relative 0x004c) — correctly self-relocated.
- `relocall.c` -> `RELOCALL.CMD` : CALLs through the far pointer; prints `ABC`
  under emu2 — the far call reaches its target, so the pointer was correctly
  relocated even though emu2's loader never reads `ch_fixrec`.
- Clearing byte127 bit7 (`RELOCALL_NB7.CMD`): still `ABC` — self-reloc does not
  depend on the loader flag; it is gated by the guard immediate, not bit7.
- Patching the guard immediate to nonzero (`RELOCSEG_GUARD.CMD`): CRASHES under
  emu2 (`unimplemented opcode FF at ...`) — self-reloc skipped, but emu2 did not
  relocate either, so far pointers stay group-relative and the far call jumps
  into garbage. This is the "loader was expected but did not run" failure.
- `reloc_probe.py <cmd>` : parses the header + fixup table, flags far-code
  pointers, locates the guard fixup.

## emu2 status (VERIFIED): NOT a bug

emu2 (`emu2-cpm86/src/cpm86.c`) does not read `ch_fixrec` (0x7D) or apply loader
fixups. That is **correct** for DR C output: with no loader relocation the guard
stays 0 and CLEARL self-relocates. DR C large-model programs run correctly on
emu2 by design. The only thing emu2 cannot host is a program that RELIES on
loader relocation AND has its guard pre-set nonzero (i.e. no self-reloc
fallback) — which DR C never emits. Implementing loader relocation in emu2 would
be a fidelity nicety, but doing it naively (without also honouring a CLEARL-style
guard) would DOUBLE-relocate DR C programs and break them.

## Implication for our wlink Stage B

Our `open-watcom-v2/bld/wl/c/loadcpm86.c` must pick ONE coherent model:

**DECISION (@ravn, 2026-08-19): PURE loader-reloc, and NO type-8 AUX4 copy of
the reloc table.** We emit only the genuine P_LOAD structure (byte-127 bit7 +
`ch_fixrec` + fixup records). We do NOT ship DR C's AUX4 self-reloc duplicate:
emu2 not applying P_LOAD fixups is an **emu2 bug to fix later**
(ravn/emu2-cpm86#1), not worked around in the linker. Medium-model `.CMD`s
verify on MAME (genuine CCP/M) only until that emu2 fix lands. The two models
below are kept for context; the loader-reloc one (minus AUX4) is what we build.

- **Self-reloc model** (what DR C effectively uses on emu2 / plain CP/M-86):
  emit the fixup table + a crt0 that walks it using base-page segments, guarded
  by a relocatable flag = 0. Runs on emu2 AND genuine loaders (guard flips it
  off when a loader relocates). This is the robust choice and matches what
  already works.
- **Pure loader-reloc model**: set byte127 bit7 + `ch_fixrec`, no crt0 walker.
  Runs on genuine CCP/M-86 but NOT on emu2 (or plain CP/M-86). Verify under
  MAME **or the Unicorn runner** — since 2026-08-19 `cpm86run_unicorn.py`
  implements loader relocation (`_apply_fixups()`, a port of `load.sup:402-449`;
  unit-tested in `contrib/ravn/test_cpm86_reloc.py`), so it now applies P_LOAD
  fixups exactly like a genuine loader (verified: DR C LL_l/LL_s/MANDEL/TINY63
  relocate + run there, output identical to the CLEARL self-reloc path). emu2
  still does not (ravn/emu2-cpm86#1).

## Still unverified (would need MAME / genuine RC759)

Whether the RC759's specific boot OS actually honours `ch_fixrec` (Concurrent
CP/M-86 2.0 source says its loader does; the RC759 XIOS/loader edition is
un-probed). Not needed to answer the mechanism question — the guard makes DR C
output correct on either kind of loader.

## Historical note (HYPOTHESIS — unverified, does not affect engineering)

Open question raised 2026-08-19: did DR C's relocation *originate* as pure
runtime self-relocation (CLEARL walking an aux-group table), with the guard
added later once CP/M-86's `P_LOAD` gained loader-side relocation — i.e. the
self-reloc path is a retained-but-superseded fallback? Datable breadcrumb: the
self-reloc abort message is **"You must link with LINK86 V1.2 or later."**, so
the aux-group reloc table has a LINK-86 v1.2 version boundary.

Two readings fit the artifact equally; the binary alone cannot decide:
- **Accretion:** runtime self-reloc first, guard bolted on when the loader could
  relocate, never fully removed.
- **Deliberate dual-target:** the guard is NOT vestigial — its immediate is
  itself a loader-written fixup, so whoever added it already knew the loader
  could relocate; the self-reloc path is intentionally kept as the fallback for
  NON-relocating loaders (plain CP/M-86), yielding one binary that runs on both.

Evidence leaning to the second: a purely vestigial path would run
unconditionally; here it is gated on a flag only the loader touches, so guard
and loader-reloc are contemporaneous by construction. Settling the actual
chronology needs dated DR sources (LINK-86 changelog, CP/M-86 vs Concurrent
release notes), not the binary. Either way our conclusions stand.

Datable facts gathered 2026-08-19 (still too coarse to decide the above):
- Our workspace LINK-86 (`drc86111/LINK86.CMD`) self-identifies as **"LINK-86
  Linkage Editor 19 March 1984 Version 1.4"**, Copyright 1982-1984. So the
  self-reloc abort's required **v1.2 predates March 1984**.
- CP/M-86 first shipped April 1982; CP/M-86 1.1 March 1983; Concurrent CP/M-86
  ~1983-84. No source found gives an exact LINK-86 1.2 date; best bracket
  ~1982-1983. LINK-86 1.2's aux-group reloc table and Concurrent's relocating
  loader fall in the same 1982-84 window, so neither clearly precedes the
  other — the chronology question stays open.

Sharper dated reading (2026-08-19, known-vs-guessed):
- KNOWN: **group-granularity** relocation existed from the start (CP/M-86 1.0,
  1982) — the loader places each group and writes its actual segment into the
  base-page descriptors (0x03..0x2d). That is exactly what CLEARL's self-reloc
  reads, so self-relocation was always viable.
- KNOWN (workspace): the **byte-fixup** load mechanism (byte-127 bit 7 +
  `ch_fixrec`) is undocumented in the DRI manuals (they cover only bits 5/6 =
  8087) and surfaces in the genuine **Concurrent CP/M-86** source dated **29
  June 1983** (`scratch/ccpm86-src/kern/{cmdh.def,load.sup}`).
- GUESSED (cannot verify from workspace — we lack CP/M-86 1.0 loader source;
  disassembling `CPM86.IMG` is the rabbit-hole we chose not to enter): that the
  1982 1.0 loader did NOT honour bit-7 byte-fixups.
- Net reframing: it is less "designed for load-reloc but tools lagged" and more
  "group-reloc shipped in 1982; byte-fixup load-reloc + LINK-86 1.2 emission
  matured together ~1983 (Concurrent, where multitasking rules out a fixed TPA
  and forces embedded-far-pointer relocation); DR C shipped crt0 self-reloc so
  it depends on neither loader generation."

CP/M-86 1.1 source check (2026-08-19, `www.cpm.z80.de/download/c8611src.zip`
→ `scratch/cpm86-11-src/`): does NOT resolve the chronology. The zip is the 1.1
BIOS-adaptation kit + samples (LDBIOS/TBIOS/CBIOS/BIOS, COPYDISK, RANDOM demo,
CPMLDR bootstrap `LDCPM.A86`, plus GENCMD/GENDEF/ASM86 as BINARIES). The BDOS —
where P_LOAD (func 59) lives — ships only as assembled hex `CPM.H86`, no
`.A86`. Text search of all `.A86/.DEF/.LIB` finds NO fixup/reloc/byte-127
/`ch_fixrec`/CMD-load logic. The bootstrap `LDCPM.A86` (loads CPM.SYS) does not
relocate embedded pointers — it reads only the header ABS segment and references
memory via copies of `CS:`. So 1.1's P_LOAD byte-fixup support stays UNVERIFIED
(would need disassembling `CPM.H86`, deferred). Practical stance: our large
model is UNTESTED on early CP/M-86 loader editions — carry that caveat.
