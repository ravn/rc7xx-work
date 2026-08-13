# Plan: native CP/M-86 `.CMD` output in `wlink` (ravn/open-watcom-v2#10)

Status: investigation + design. No code written yet. All citations are into
`bld/wl/` of the freshly-built `ravn/open-watcom-v2` fork
(`/Users/ravn/z80/scratch/open-watcom-v2`).

Related: issue ravn/open-watcom-v2#10; RC759 CMD toolchain in
`scratch/rc759-cmd-toolchain/` (working `mkcmd.py` interim wrapper).

---

## 1. How wlink emits an output format (verified from source)

The output pipeline is format-dispatched in one place and each format owns a
`Fini<Fmt>LoadFile()` (and, for raw, a `BinOutput()`):

- **Format enum / bit flags** — `bld/wl/h/_formats.h:36` `FORMATS()` macro, one
  `pick_format(bit, MK_NAME, index, "desc", "jp-desc")` per format. Highest bit
  currently used is `MK_RDOS_16 = 0x00100000` (`_formats.h:57`). Next free bit is
  **`0x00200000`**. The enum is materialised in `bld/wl/h/formats.h:37` and there
  is a *parallel* message table in `msg.c` (the enum comment says "there is a
  corresp. table in MSG.C").
- **Format attribute groups** — `bld/wl/h/formats.h:45-66` (`MK_16BIT`,
  `MK_REAL_MODE`, `MK_SEGMENTED`, `MK_ALLOW_16`, `MK_END_PAD`, ...). CP/M-86 is
  16-bit real-mode segmented, so a new `MK_CPM` must join `MK_16BIT`,
  `MK_REAL_MODE`, `MK_SEGMENTED`, `MK_ALLOW_16` (and probably `MK_END_PAD`).
- **Feature gate** — `bld/wl/h/wlinkcfg.h:34-42` defines one macro per built-in
  format (`#define _EXE 0`, `#define _RAW 7`, `#define _RDOS 8`, ...). They are
  all defined, so `#ifdef _RAW` compiles that format into the full linker. Add
  **`#define _CPM 9`**.
- **The dispatch** — `bld/wl/c/loadfile.c:254` `finiLoad()` is a chain of
  `if( FmtData.type & MK_xxx ) { Fini<xxx>LoadFile(); return; }`, each wrapped in
  `#ifdef _xxx`. This is where a `#ifdef _CPM ... FiniCPMLoadFile()` clause goes.
  Note raw/hex short-circuit at the very top (`loadfile.c:260-270`), so CMD output
  is only reached when `-b`/`format raw` are *not* in effect.
- **Command parsing** — the `format <kw>` sub-keyword table lives at
  `bld/wl/c/cmdall.c:2066` (`"Dos", ProcDosFormat, MK_DOS`; `"Raw", ProcRawFormat,
  MK_RAW`; ...). Sub-format keywords like `COM` are in per-format tables, e.g.
  `bld/wl/c/cmddos.c:525` `"COM", ProcCom, MK_COM`, and `ProcCom` just sets
  `FmtData.def_ext = E_COM` + the flag (`cmddos.c:517`).
- **Group image writers (reusable)** — `bld/wl/c/loadfile.c:1179`
  `WriteGroupLoad(group, repos)` writes one group's bytes; `CalcGroupSize(group)`
  gives its size; `PadLoad()` / `SeekLoad()` / `WriteLoad()` are the primitives.
  `bld/wl/c/loadraw.c:98` `BinOutput()` shows the canonical "iterate `Groups`
  linked list, position each group, `WriteGroupLoad`" loop. **This is 90% of what
  a CMD group-image writer needs.**
- **Header + relocations model** — `bld/wl/c/loaddos.c:288` `FiniDOSLoadFile()`
  builds a `dos_exe_header`, and `WriteDOSRootRelocs`/`DumpRelocList`
  (`loaddos.c:55-130`) walk `Root->reloclist` / `sect->reloclist` and emit
  `dos_addr` (seg:off) relocation records, sizing the header with
  `__ROUND_UP_SIZE_PARA(...)`. **This is the model for the CMD fixup table.**

Take-away: wlink already has (a) a group-iterating raw image writer and (b) a
relocation-dumping DOS writer. A CMD loader is essentially "DOS-header shape +
raw group images", with the DRI 8-descriptor header instead of the MZ header.

---

## 2. The CMD container to emit (verified against real CMDs + RC759 loader)

128-byte header = up to 8 × 9-byte group descriptors:
`db type` (1=CODE, 2=DATA, 3=EXTRA, 4=STACK, 9=pure code) · `dw length` ·
`dw base` · `dw min` · `dw max` — sizes in 16-byte **paragraphs**, `base=0` =
relocatable. Group images follow, **each padded to a 128-byte record**. Header
offset `0x7F` = flag byte; **bit 7 = "fixup records present"**, in which case a
fixup table trails the group images.

Memory models map onto linker groups:
- **8080**: single group; loader sets `CS=DS=SS=ES` equal.
- **Small**: `CODE` (type 1) + `DATA` (type 2); loader sets `CS`=code,
  `DS=ES=SS`=data.
- **Compact**: CODE/DATA/EXTRA/STACK.

Verified RC759 / CCP/M-86 3.1 loader contract (measured 2026-08-12): small-model
loader sets `CS`=code group and `DS=SS`=data group with **`DS = CS + code-group
paragraphs`**; `DS:0000-00FF` is the base page; BDOS entry is `INT 0E0h`
(function in `CL`, arg in `DX`). Entry is `CS:0000`.

---

## 3. Concrete change set (6 edits + 2 new files)

| # | File | Change |
|---|------|--------|
| 1 | `bld/wl/h/_formats.h:57` | add `pick_format( 0x00200000, MK_CPM, 21, "CP/M-86", "CP/M-86" )` |
| 2 | `bld/wl/h/formats.h:45-66` | add `MK_CPM` to `MK_16BIT`, `MK_REAL_MODE`, `MK_SEGMENTED`, `MK_ALLOW_16`, `MK_END_PAD` |
| 3 | `bld/wl/h/wlinkcfg.h:42` | add `#define _CPM 9` |
| 4 | `bld/wl/c/cmdall.c:2066` | add `"CPm", ProcCPMFormat, MK_CPM, 0,` to the format table |
| 5 | `bld/wl/c/loadfile.c:~275` | add `#ifdef _CPM if( FmtData.type & MK_CPM ){ FiniCPMLoadFile(); return; } #endif` |
| 6 | `bld/wl/wlobjs.mif:~68` | add `$(_subdir_)loadcmd.obj &` and `$(_subdir_)cmdcpm.obj &` to the object list (`loaddos.obj` at line 58, `loadraw.obj` at line 68) |
| A | **new** `bld/wl/c/cmdcpm.c` + `bld/wl/h/loadcmd.h` | `ProcCPMFormat` (set `FmtData.def_ext=".cmd"`, model flags) + optional sub-keywords `SMall`/`COMpact`/`8080` |
| B | **new** `bld/wl/c/loadcmd.c` | `FiniCPMLoadFile()`: build 8-descriptor header from `Groups`, write group images (reuse `WriteGroupLoad`), pad each to 128-byte record, optional fixups |
| C | `msg.c` / usage tables | add the parallel format-name entry the enum comment warns about; add `format cpm` help in `cmdhelp.c:200` region |

`FiniCPMLoadFile()` sketch:
1. Walk `Groups` (`loadfile.c` global) once to classify each `group_entry` by
   `group->leaders->class->flags` (CODE vs DATA/BSS vs STACK) and compute
   `__ROUND_UP_SIZE_PARA(CalcGroupSize(group))`.
2. Emit up to 8 group descriptors (type from classification, `length`/`min`/`max`
   in paragraphs, `base=0` for relocatable).
3. `WriteLoad` the 128-byte header (pad to 128).
4. For each group: position with `PadLoad`/`SeekLoad` and `WriteGroupLoad(group,
   repos)`, then pad to the next 128-byte record.
5. If relocatable-with-fixups: set header `0x7F` bit 7 and dump a fixup table
   modeled on `WriteDOSRootRelocs` (`loaddos.c:55`).

---

## 4. Phasing

- **Phase 1 (MVP, matches today's `mkcmd.py`):** 8080 + small model, `base=0`,
  **no fixups**. Reuses the raw group-writer path entirely. Deliverable: `wcc
  hello.c && wlink format cpm file hello` produces a `.CMD` that runs on RC759.
- **Phase 2:** compact model (EXTRA/STACK groups) + full fixup table (bit-7 flag),
  modeled on the DOS reloc dumper. Enables real relocatable multi-segment C.
- **Phase 3:** wire `wcl`/`owcc` so `-bcpm` / `system cpm` selects the format and
  the right startup/clib (needs a CP/M-86 crt0 + BDOS glue — separate from wlink).

---

## 5. Open questions / risks (unverified — must test)

1. **OMF input compatibility.** wlink reads OMF via `objomf.c`; DR C's `.L86`
   objects/libraries must parse cleanly. *Untested* — we may keep the DR C clib
   but link it through wlink; needs a real link attempt.
2. **Fixup source.** Whether wlink's `Root->reloclist` for a 16-bit real-mode
   group gives exactly the seg-relative fixups the CMD format expects. Verify by
   comparing wlink's DOS-EXE relocs for the same objects.
3. **Entry point.** CMD small model entry is `CS:0000`; confirm wlink's default
   start-address handling puts the entry first in the CODE group (DOS EXE uses a
   `start` symbol; CMD ignores CS:IP from a symbol and just enters CS:0000).
4. **Runtime (not wlink's job).** A compiled C program still needs a crt0 that
   sets `DS=SS` per the measured loader contract and a BDOS (`INT 0E0h`) glue
   layer. wlink support is necessary but not sufficient.

---

## 6. Test plan (oracle already exists)

- Unit: `wlink format cpm` on a hand-`wcc`'d trivial `.obj`; byte-compare the
  128-byte header against a known-good `dir.cmd` (extracted, in `/tmp`) and against
  `mkcmd.py` output for the same code/data sizes.
- End-to-end: drop the produced `.CMD` as `menu.cmd` on a copy of `mandel.img` via
  `cpmcp -f drc-rc759`, boot the DMA-fixed RC759 in MAME, snapshot — reuse the
  exact flow proven in `scratch/rc759-cmd-toolchain/` (NASM→mkcmd→RC759).
- Regression: `format raw bin` must still work unchanged (CMD path is only taken
  when raw/hex are off — `loadfile.c:260`).

---

## Empirical finding (2026-08-13): real CMD files on RC759 disks use base=0, no fixups

Parsed the 128-byte headers of six shipping `.CMD` programs from the RC759 disks
(disk1/disk4) with a group-descriptor decoder:

| Program | Groups | CODE | DATA/other | Total image | fixups (0x7F bit7) |
|---------|--------|------|-----------|-------------|--------------------|
| dir     | 2 (CODE+DATA)        | 1520 B  | 592 B          | 2112 B  | no |
| ddt86   | 1 (CODE)             | 14112 B | 0              | 14112 B | no |
| rctekst | 1 (CODE)             | 19456 B | 0              | 19456 B | no |
| asm86   | 2 (CODE+DATA)        | 19152 B | 6960 B         | 26112 B | no |
| ed      | 2 (CODE+DATA)        | 7904 B  | 1472 B         | 9376 B  | no |
| comal80 | 3 (CODE+DATA+STACK)  | 32928 B | 11952+4096 B   | 48976 B | no |

Key observations:
- **No shipping program sets the fixups flag (0x7F bit7).** All are `base=0`,
  relocated purely by the loader placing each group at a segment base — no
  explicit in-file fixup/reloc table. This includes the 3-group compact program
  (comal80).
- **Each single group stays <= 64 KB** (e.g. rctekst CODE `min=4096 para =
  65536 B` = exactly one 64 KB segment; ed DATA `max=4095`). The 64 KB ceiling
  is per-segment (16-bit offset), not a linker limit.
- **>64 KB total is reached by multiple groups**, not a flat segment (comal80 =
  49 KB across 3 groups; two full groups would give ~128 KB).
- The `min` field can exceed `length` (asm86 DATA len=435 para but min=1102 =
  BSS growth request); the loader zero-fills the difference.

**Impact on phasing:** Phase 1 (raw group images, base=0, no fixup table) is
sufficient for *every* program observed on these disks, including multi-group
compact (comal80). The full fixup machinery (Phase 2) is only needed for
programs carrying absolute inter-segment references — none of the sampled
programs do. This widens Phase 1's real-world coverage considerably and means an
MVP `FiniCPMLoadFile()` that classifies groups + writes base=0 images is a
faithful LINK-86 substitute for the common case.

---

## LINK 86 reference version (verified 2026-08-13 from primary source)

**LINK 86 Version 1.5** — Digital Research, documented in *FlexOS 286
Programmer's Utilities Guide* (1073-2043-001, 1986), Section 7.
Verbatim (Section 7.1): "...that LINK 86, Version 1.5, combines relocatable
object files into a command file that runs under any Digital Research operating
system..." Re-confirmed in Section 7.5 ("LINK 86, version 1.5, supports
shareable runtime libraries.").
Source PDF: https://bitsavers.org/pdf/digitalResearch/flexos/flexos_286/1073-2043-001_FlexOS_286_Programmers_Utilities_Guide_1986.pdf
Local copy saved in-project: `docs/1073-2043-001_FlexOS_286_Programmers_Utilities_Guide_1986.pdf`

Context for versions seen in this project:
- RC759 system disks ship the older DRI toolchain: **ASM86 1.1 / DDT86 1.2**
  (Digital Research 1981; verified from the .CMD version strings on disk1).
- The `cpm86-crossdev` environment (session 74a9b612, repo tsupplis/cpm86-crossdev,
  at /Users/ravn/git/open-watcom-v2 — outside this workspace) bundles DR C 1.11
  and a LINK-86 used to build DHRY.CMD via
  `link86 DHRY=DHRY_1,DHRY_2,CLEARS.L86[S]`; that binary's exact banner was not
  captured.
- **1.5 is the newest LINK 86 documented**, and is the best spec reference for
  wlink CMD-output parity.

### Features in LINK 86 1.5 relevant to wlink #10 (verified in the guide)

- **Still emits CMD** — Section 3.3 Table 3-3: "LINK-86 command segments into the
  CMD file it creates." Confirms the group/segment->CMD-descriptor mapping the
  plan targets.
- **Overlays (Section 8)** — `link86 rootfile, parta, partb (overl, over2)`. This
  is DRI's official mechanism for exceeding 64 KB of code: multiple overlaid code
  segments, NOT a flat >64 KB segment. (Answers "can LINK86 make >64 KB
  programs?" — total >64 KB via multiple groups/overlays; each segment still
  <=64 KB.) Overlays are OUT OF SCOPE for Phase 1/2; note as a possible Phase 4.
- **Shareable Runtime Libraries (SRTL, `.186`/`.L86[S]`)** —
  `link86 suprprog,init,term,suprutil.186`. Explains the `CLEARS.L86[S]` seen in
  the DHRY build. Out of scope for a first wlink CMD writer.
- **Dual CMD/286 output** — "a version of LINK 86 that generates CMD and 286
  files cannot generate an EXE file and vice versa." CMD (CP/M-86 family) and 286
  (FlexOS) share the linker family; wlink only needs the CMD side.
- **cinit. segment ordering** — (from cpm86-crossdev observation) LINK-86 places
  the `cinit.` segment first so the initializer `m.init` runs at CS offset 0;
  a wlink CMD writer targeting DR C objects must preserve this segment ordering,
  not just classify by CODE/DATA.

---

## Overlays in LINK 86 — detailed (verified: FlexOS 286 Guide §7.14 + Section 8)

**Purpose.** Overlays run programs larger than available RAM / larger than 64 KB
of code by keeping only the currently-used branch resident. Guide §8.1: "The top
of the highest overlay determines the total amount of memory required ... much
less memory than would be required if all the functions and subfunctions had to
reside in memory simultaneously." This is DRI's answer to ">64 KB programs": not
one flat segment, but a root .CMD plus swapped-in .OVR files.

**Tree structure, max depth 5.** Overlays nest as a tree (Fig 8-2: Menu ->
func1/func2/func3 -> sub1..sub4); "You can nest overlays to a maximum depth of 5
levels." Only one leaf need be resident at a time.

**Link syntax (parentheses define overlays):**
- `link86 root (overlay1)`                    -> ROOT.CMD + OVERLAY1.OVR
- `link86 root (overlay1=part1,part2,part3)`  -> one overlay fused from several .OBJ
- `link86 menu(func1(sub1)(sub2))(func2)(func3(sub3)(sub4))` -> nested tree
- `link86 rootfile, parta, partb (overl, over2)` -> non-overlay files first, overlays last
- RASM-86 code needs a HLL runtime lib on the line to supply the Overlay
  Manager: `link86 root,clears.l86 (part1,part2)` (same CLEARS.L86 seen in the
  DHRY build). Output = one .CMD (root) + one .OVR per overlay.

**Runtime mechanics (two methods):**
- Method 1 (implicit): `extrn overlay1:near` + `call overlay1`; the Overlay
  Manager loads OVERLAY1.OVR from the default drive and returns via RET. No
  special coding, but overlays must be on the default drive and names are fixed
  at link time.
- Method 2 (explicit): `extrn ?ovlay:near` + `call ?ovlay` followed in the code
  segment by `dw <overlay_name_offset>` and `db <load_flag>`. Allows a drive
  code and a run-time-chosen overlay name (e.g. from the console). Load Flag 1 =
  always load; 0 = load only if not already resident.

**Constraints (§8.4):**
- Each overlay has exactly one entry point, assumed at the overlay's load address.
- Only "downward" references allowed (root/higher -> lower in the tree); you
  cannot reference arbitrary routines "upward" except via an overlay's main entry.
- CUMULATIVE / NOCUMULATIVE (§7.14): CUM overlays both code AND data; NOCUM
  overlays code only (data stays resident).

**CMD header confirmation (§7.7.1)** — directly corroborates the descriptor model
this plan targets: "A command file consists of a 128-byte header record followed
by up to eight sections ... CODE, DATA, STACK, EXTRA, X1, X2, X3, and X4." Note
FlexOS/286 allows each section up to 1 MB; classic CP/M-86 keeps each <=64 KB.

**Impact on this plan.** Overlays are a distinct file type (.OVR) plus an Overlay
Manager runtime (supplied by DR C's CLEARS.L86), NOT just a CMD-header variant.
Therefore overlays are OUT OF SCOPE for Phase 1-2 (single .CMD). If ever needed,
they become Phase 4, and even then wlink can only LINK the Overlay Manager in
(from the DR C runtime), not synthesize it. Phase 1-2 CMD parity is unaffected.

---

## Binary size envelope on the RC759 (computed 2026-08-13)

Physical memory (verified `mame/src/mame/regnecentralen/rc759.cpp:179-182`):
384 KB RAM (0x00000-0x5FFFF), VRAM 0xD0000 (separate), BIOS ROM 0xE8000.
Measured program load base: CS=0x2150 -> phys 0x21500 (133 KB in).

Two ceilings; the architectural one always wins:
- **Per-segment cap = 64 KB** (16-bit offset on 8086/80186) -> each CMD group
  is effectively <= 64 KB, regardless of the descriptor's 16-bit paragraph
  field (which could express up to ~1 MB).
- CMD header holds max 8 group descriptors.
- Gross physical window load-base -> top-of-RAM = 0x60000-0x21500 = 0x3EB00 =
  **250.8 KB**; realistic single-program TPA ~150-250 KB after CCP/M-86 3.1
  resident OS + other virtual-console TPAs + disk/dir buffers (exact top needs
  a RAM dump).

What works for ONE binary (no overlays):
| Model   | Groups                    | Max image | Fits TPA |
|---------|---------------------------|-----------|----------|
| 8080    | 1 (CS=DS=SS)              | 64 KB     | yes |
| small   | 2 (CODE+DATA)             | 128 KB    | yes (typical C) |
| compact | 4 (CODE+DATA+EXTRA+STACK) | 256 KB    | partial (>250 KB gross) |
| >64 KB code | -                     | -         | NO -> overlays only |

File-size vs memory-footprint: the .CMD FILE = header(128B) + group images
(each padded to 128B); BSS is NOT stored — descriptor `min` > `length` tells the
loader to zero-fill at load (e.g. asm86 DATA len=435 para but min=1102 para). So
a big-array program has a small file but a large footprint. BOTH must fit: each
image <= 64 KB (offset); sum of all groups' `min` paragraphs <= available TPA.

Phase 1 (small model, 128 KB) covers realistic C programs. >64 KB code is
overlays-only (Section 8), outside wlink's scope.

### TPA measurement note (RAM dump, 2026-08-13)
Booted the DMA-fixed RC759 in MAME and dumped all 384 KB RAM (0x00000-0x5FFFF)
via Lua at emulated t~175 s (past OS init). Finding: at the A> idle state the OS
has already touched most of RAM (buffers, multiple virtual consoles), so free TPA
is NOT identifiable by scanning for zero-filled regions. Pinning the exact TPA
top requires parsing CCP/M-86 SYSDAT memory-allocation tables or a BDOS memory
query (functions 53-58) — deferred; it does not change which memory models work.
The computed bounded envelope (single-program TPA ~150-250 KB, small model 128 KB
always safe) stands. MAME gotcha recorded: keep the frame-notifier subscription
in a global or it is GC'd and stops firing (cost several boot cycles here).

---

## SCOPE DECISION (user, 2026-08-13): small model only, for now

Target right now = **small model**: one 64 KB CODE segment + one 64 KB DATA
segment (2 CMD groups: CODE type 1 + DATA type 2, base=0, no fixups). User: "målet
lige nu er small-modellen, 64 kb kodesegment og 64 kb ram segment. Rammer vi
grænsen på et tidspunkt, så kigger vi på hvad vi så gør."

Consequences for this plan:
- **In scope now:** Phase 1 = 8080 + small model, base=0, no fixup table. This is
  the whole deliverable for the foreseeable future and covers realistic C programs
  (<=128 KB total). Matches what mkcmd.py already does and what LINK-86 emits for
  the common case.
- **Deferred until we actually hit the 64 KB/segment wall:** Phase 2 (compact +
  fixups), Phase 4 (overlays). Do NOT build these pre-emptively. When a real
  program exceeds 64 KB code or 64 KB data, revisit then and choose (compact vs
  overlays) based on whether it's a data or code overflow.
- The exact-TPA question is likewise moot at this scope: 64 KB+64 KB = 128 KB
  fits the RC759 TPA comfortably (bounded 150-250 KB), so no dump/SYSDAT parsing
  needed for the small-model target.

---

## VERIFIED: what bwcc emits for small model, and the real compiled-C gap (2026-08-13)

Compiled a trivial C program with the freshly-built `bwcc -0 -ms` (16-bit small
model) and disassembled the OMF with `bwdis`. Verified output structure:

```
DGROUP  GROUP  CONST, CONST2, _DATA          ; all class 'DATA'
_TEXT   SEGMENT BYTE PUBLIC USE16 'CODE'      ; the code segment
        ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP ; classic small model
_start_:  ...                                 ; PUBLIC entry, cdecl frame
        EXTRN _small_code_:BYTE               ; Watcom runtime marker symbol
```
OMF records: LNAMES {CODE,DATA,BSS,TLS,DGROUP,_TEXT,CONST,CONST2,_DATA};
SEGDEF _TEXT(CODE,46B), CONST(DATA,0), CONST2(DATA,0), _DATA(DATA,11B);
GRPDEF DGROUP; EXTDEF _small_code_; MODEND.

### Consequence (CORRECTION to an earlier assumption)
mkcmd.py wraps ONE raw blob, which was fine only because the hand-asm HELLO laid
out code+data together. Real compiler output has SEPARATE code (`_TEXT`/CGROUP)
and data (`DGROUP`) groups that must become SEPARATE CMD descriptors (CODE type 1
+ DATA type 2) with independently-correct sizes and the loader placing DS=SS=data
group. A flat `wlink format raw` blob cannot express that split. Therefore a
native CMD writer that emits per-group images (wlink `format cpm`, or LINK-86) IS
on the critical path for compiled C small-model — it is NOT merely a nicer
mkcmd.py. This re-confirms Phase 1 as the right build target.

### The crt0/runtime contract a compiled-C CMD needs (small model)
1. A CP/M-86 crt0 placed FIRST in _TEXT (entry at CS:0000): the RC759 loader sets
   CS=code group and DS=SS=data group (measured: DS=CS+codesize para), so crt0
   mainly needs to establish SP in DGROUP, call `_start_`/main, then exit via
   BDOS func 0 (INT 0E0h, CL=0).
2. A BDOS bridge callable from C: `bdos(func, param)` -> `INT 0E0h` (func in CL,
   param in DX) — the only OS entry needed for console/file I/O.
3. Provide the `_small_code_` runtime symbol bwcc references (stack-check/model
   marker); a trivial absolute EXTDEF stub satisfies it.

Net: full compiled-C small-model path = wlink `format cpm` (Phase 1) + crt0.obj +
bdos glue + _small_code_ stub. Each is small; together they make `bwcc x.c ->
link -> x.cmd` boot on the RC759. Build+boot verification is the remaining work.

---

## 2026-08-13 — DR C + LINK-86 oracle disks found & cached (DDHF archive)

User: "dr c er oraklet på at lave c programmer" + "de disketter du henter fra
ddhf caches lokalt i repoet". Both hints converged on the DDHF archive.

### Found (by sweeping cached RC759 analysis pages for LINK/L86)
Three artifacts carry the COMPLETE Digital Research C + LINK-86 dev toolchain:
`30002664`, `30002725`, `30005869`. Contents (mounted with cpmtools):
- **link86.cmd** — LINK-86 Linkage Editor, **19 March 1984, Version 1.4**
  (Serial 3049-0261-000000, DRI 1982-1984). Supports overlays
  ("LINKING OVERLAY", "Overlay Name") and flags `GROUP OVER 64K`,
  `VERSION 2 REQUIRED` (CMD vs 286 output).
- **drc.cmd + drc860/861/862.cmd + drcrpp.cmd + drc.err** — DR C compiler passes.
- **clears.l86 / clearl.l86** — DR C small/large-model C runtime startups (crt0).
  These are the AUTHORITATIVE crt0 contract (entry, SP setup, BDOS exit,
  argv setup) to mirror in our bwcc-based crt0.
- **lib86.cmd** (librarian), **rasm86.cmd** (relocatable assembler),
  **xref86.cmd** (cross-reference).

### Cached locally (per user's caching directive)
- Blobs: `ddhf-cache/bits/{30002664,30002725,30005869}.bin` (fetch-if-missing via
  `fetch-ddhf.sh`). Byte-format = same `RC759 ` header as local disk1-4.img;
  mount with `cpmls -f drc-rc759` (needs diskdefs in rc759-pce/images).
- Analysis pages (dir listings): `ddhf-cache/aa/rc759/analysis-*.html`
  (all 188 RC759 analysis pages now cached from the LINK-86 sweep).
- Extracted tools: `drc-toolchain/{link86.cmd,clears.l86,clearl.l86,drc.cmd,
  lib86.cmd,rasm86.cmd}`.

### Impact on the plan — DR C becomes the verification oracle
The pipeline gains an independent ground truth (does NOT share bwcc's failure
modes), exactly per the user's oracle discipline:
1. **crt0**: read `clears.l86` to get the exact small-model entry/exit contract,
   instead of reverse-engineering it. Mirror it for the bwcc path.
2. **Correctness oracle**: compile the same C source with DR C (drc.cmd) +
   LINK-86 in-emulator -> reference CMD; diff structure/behaviour against our
   `bwcc -> bwlink -> CMD` output. Divergence = our bug.
3. **Canonical linker available**: LINK-86 v1.4 can build CMDs the DRI way
   in-emulator, as a cross-check on our host-side bwlink packaging.

Note LINK-86 here is **v1.4** (1984); the FlexOS 286 guide documents **v1.5**.
Both emit CMD; v1.4 is what actually shipped on RC759-era media.

---

## 2026-08-13 — VERIFIED: Open Watcom C -> DR C LINK-86 -> running CMD (emu2 + RC759)

**Headline result (proven end-to-end):** an Open Watcom-compiled C program runs on the
real RC759 (Concurrent CP/M-86 3.1) in MAME, linked by DR C's own LINK-86 v1.4.
Screen output confirmed: `HELLO-FROM-COMPILED-C` then clean return to `A>`.
Also verified headless under emu2-cpm86.

### Toolchain decision (user's hypothesis (a) confirmed)
Watcom `.obj` **is** linkable by DR C's LINK-86 after a small deterministic OMF
normalization. No need to write our own CMD linker (hypothesis (b) not required).

### The two OMF incompatibilities (both fixed by `omf_classicize.py`)
1. Watcom emits **`LPUBDEF (0xB6)` / `LEXTDEF (0xB4)`** (local publics/externals) for
   static symbols. The 1984 LINK-86 v1.4 predates these -> `OBJECT FILE ERROR 05`.
   Their record bodies are byte-identical to `PUBDEF (0x90)` / `EXTDEF (0x8C)`, so we
   swap the type byte and recompute the OMF checksum. Record order preserved ->
   FIXUPP external indices stay valid.
2. Watcom writes the **full source path in `THEADR`**; a long path -> `OBJECT FILE
   ERROR 10`. Normalizer shortens THEADR to an 8-char uppercase basename.

### Headless CP/M-86 host: emu2-cpm86 (johnsonjh fork of dmsc/emu2)
- Runs `.CMD` directly; runs DR C LINK-86 v1.4 itself. Built with plain `make`.
- Write-back to host needs explicit drive map:
  `EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A emu2 LINK86.CMD "OUT=CRT0C,APPC"`.
- Filenames: keep inputs to short 8.3; a 6-char base once hit a "NO FILE" quirk.

### LINK-86 auto-builds the CMD
Given the OMF groups, LINK-86 emits a proper 2-group CMD by itself
(CODE type1 + DATA type2, DATA `max`=4096 paras heap). No hand-rolled header.

### crt0 status (the one non-oracle piece)
`crt0.asm` still uses the `DS=CS`/`SP=0x600` convention. It works and is UNDERSTOOD:
LINK-86 places CONST2 (the string) inside the CODE group (offset 0x54), so `DS=CS`
reaches it. NOT yet the DR C way. Next: derive crt0 from DR C `startup.a86` /
`CLEARS.L86` and (for libc reuse) resolve the watcall-vs-DR-C-cdecl ABI.

### One-command build
`./ccrc759.sh prog.c [out.cmd]` : bwasm crt0 + bwcc -0 -ms -s -> classicize both
objs -> LINK-86 under emu2 -> `OUT.CMD`. Entry point must be `cmain()`.

### Key paths
- emu2:      scratch/cpm86-tools/emu2-cpm86/emu2
- normalizer: scratch/rc759-cmd-toolchain/omf_classicize.py
- build:     scratch/rc759-cmd-toolchain/ccrc759.sh
- LINK-86:   scratch/rc759-cmd-toolchain/drc-toolchain/link86.cmd (+ clears.l86)
- DR C oracle src: scratch/rc759-cmd-toolchain/drc-oracle/ (startup.a86, read.me, ...)
- DR C 1.11 archive: scratch/rc759-cmd-toolchain/drc86111/ (PCBIOS.A86, headers, BATs)

---

## STATE SNAPSHOT — 2026-08-13

**Where we are:** Open Watcom C -> CP/M-86 `.CMD` for RC759 (CCP/M-86, 8086) is
**working and verified end-to-end**. A compiled C program prints
`HELLO-FROM-COMPILED-C` on both the headless emu2-cpm86 host AND the real RC759 in
MAME, booting to `A>`. Committed on `main` (`c7ac377`).

**Verified pipeline:**
`bwcc` (Open Watcom, `-0 -ms -s`) -> OMF `.obj` -> `omf_classicize.py` (normalize OMF:
LPUBDEF/LEXTDEF -> classic PUBDEF/EXTDEF, shorten THEADR) -> DR C **LINK-86 v1.4**
(headless under **emu2-cpm86**) -> 2-group `.CMD`. One command: `./ccrc759.sh prog.c`.

**Confirmed facts (this segment):**
- Watcom emits `LPUBDEF/LEXTDEF` ONLY for `static` (file-scope) symbols; no bwcc flag
  toggles it (`-d0` doesn't; not debug records). Dropping `static` yields pure classic
  OMF that raw LINK-86 links without the normalizer — but that doesn't scale (real
  code/libc use static) and doesn't fix the independent THEADR long-path `ERROR 10`.
  => `omf_classicize.py` stays the robust general fix.
- DR C is the correctness oracle. DR C tools (LINK-86, and now DRC/RASM86) run headless
  under emu2 with host write-back via `EMU2_DRIVE_A=. EMU2_DEFAULT_DRIVE=A`.

**Open (pending todos):**
- `test-cmd`: compile the SAME source with DR C's own `DRC` under emu2 -> native DR C
  reference `.CMD`; diff vs our Watcom output as a correctness oracle. (next up)
- `write-loadcmd`: replace the `DS=CS` crt0 with a crt0 derived from DR C `startup.a86`
  / `CLEARS.L86` (true oracle startup/ABI).
- `write-cmdcpm`: real small-model 2-group CMD with DS!=CS (deferred until >64KB).
- (bigger) reuse DR C `CLEARS.L86` libc from Watcom code -> resolve watcall-vs-cdecl ABI.

---

## STATE SNAPSHOT — 2026-08-13 (b): DR C runs headless + oracle diff PASS

**Two milestones since snapshot (a):**

### 1. DR C's own compiler now runs FULLY HEADLESS under emu2-cpm86
Compile + link + run a C program with no interactive input, so DR C is now a
*live* diff oracle (not just a reference binary). Recipe (in `drc-build/`):
```
DRC.CMD  "srcfile -b"              # DR C compile -> srcfile.obj (real DR C OMF)
LINK86.CMD "SAMPLE,CLEARL.L86[S]"  # DR C link    -> SAMPLE.CMD  (runs)
```
DR C defaults to the **LARGE** model → link with **CLEARL.L86** (small-model
CLEARS.L86 gives `__BDOS TARGET OUT OF RANGE` + a dead CMD).

This required **three emu2-cpm86 fixes** (forked to `ravn/emu2-cpm86`, branch
`cpm86-drc-headless`, pushed; PR prepared but NOT opened — see
`emu2-patches/PR_DESCRIPTION.md` + the 3 `*.patch` files):
- **FCB bit-7 masking** — CP/M-86 interface attributes in bit 7 of the 11 FCB
  name/type bytes truncated `SRCFILE`→`SRCFI`; mask 0x7F when `cpm86_active`.
- **Auxiliary-group loading** — relocatable CMDs (DR C's passes) keep a
  self-relocation buffer in aux group 4; loader must allocate/load aux groups
  (CMD types 5-8 → base-page descriptor slots 4-7 at 0x18/0x1E/0x24/0x2A) or the
  pass aborts "You must link with LINK86 V1.2 or later."
- **BDOS 47 (P_CHAIN)** — DR C driver chains passes; without it only the banner
  runs. Also strips a leading `R` run-loader token (avoids unimplemented BDOS 59).

emu2 source lives in `scratch/cpm86-tools/emu2-cpm86/` (nested git clone of the
fork). Workspace captures the change as the `emu2-patches/*.patch` series.

### 2. `test-cmd` oracle diff — PASS (byte-identical)
The SAME source (`oracle_common.c`, a BDOS-only console program buildable by
BOTH toolchains — DR C via `__BDOS(2,ch)`, Watcom via `int 0E0h`) produces
**byte-identical** 66-byte runtime output when built by DR C (oracle) vs the
Watcom `ccrc759.sh` pipeline. Validates the Watcom→CMD path against the DR C
oracle on common ground.
- Note: `SAMPLE.C` (printf/libc) can't yet build on the Watcom path — the DR C
  libc watcall-vs-cdecl ABI bridge is the remaining bigger item. The common
  BDOS-only program is the fair current oracle.

**Still open (unchanged, plan-first):**
- `write-loadcmd`: derive a crt0 from DR C `startup.a86`/`CLEARL` (true oracle
  startup/ABI) for the Watcom path. startup.a86 now well-understood.
- `write-cmdcpm`: real small-model 2-group CMD with DS!=CS (>64KB).
- (bigger) reuse DR C `CLEARL.L86` libc from Watcom code → resolve the
  watcall-vs-cdecl ABI so printf-class programs build on the Watcom path.

---

## FINDING — 2026-08-13 (c): write-loadcmd re-framed (crt0 is NOT the gap)

Corrects the earlier framing of `write-loadcmd` ("replace the DS=CS crt0 with one
derived from DR C `startup.a86`"). Verified empirically:

- **CLEARL.L86 already contains DR C's startup** (`m.init`/`_main`). We link
  `srcfile.obj + CLEARL.L86` alone and get a working entry — no hand-written crt0
  needed. LINK-86 makes the FIRST module's start the CMD entry point.
- Linking a **Watcom**-compiled object (`oracle_common.c`, no libc calls) against
  CLEARL leaves exactly **one** unresolved symbol: `_small_code_` — a Watcom
  small-model runtime marker, NOT a DR C startup gap. A CMD is still produced.

**Conclusion:** a crt0 is not the blocker. The real work to use DR C libc
(printf-class) from Watcom code is the **symbol/ABI bridge**, which is the bigger,
still-unscoped item:
  1. Provide/stub Watcom marker symbols (`_small_code_`, etc.).
  2. Bridge the calling convention: Watcom `watcall` (args in AX/DX/...) vs DR C
     `cdecl`-style (args on stack); plus entry naming `cmain` (Watcom) vs `main`
     (what CLEARL's `_main` calls). Needs per-function thunks or a Watcom aux
     pragma forcing stack-based calls to the DR C libc symbols.

`write-loadcmd` and `write-cmdcpm` are therefore **blocked on a design decision**
for that ABI bridge (plan-first). They cannot show independent, verifiable value
until the bridge approach is chosen. Recommend scoping the ABI bridge next as its
own planned task; the oracle harness (`drc-oracle.sh` + `oracle_common.c` +
byte-diff) is ready to validate it.

---

## FINDING — 2026-08-13 (d): ABI bridge — scalar HOLE THROUGH; pointers blocked

The ABI bridge that snapshot (c) called "blocked on a design decision" is now
**solved for scalar arguments/returns** and its pointer limitation is
**root-caused (verified, not hypothesized)**.

### What works (verified, reproducible: `./bridge-scalar.sh` -> PASS)

Watcom-compiled code calls a **genuine DR C 1.11-compiled** routine across the
compiler boundary and gets the right answer, with CLEARL's own startup driving
the program (no hand-written crt0):

- Callee `bridge_add_lib.c`: `add(a,b) int a,b; { return a+b; }` compiled by DR C
  (default LARGE model) -> FAR routine, args at `[bp+6]/[bp+8]`, returns AX, `retf`.
- Caller `bridge_scalar.c`: Watcom `-ml`, bridge expressed purely as an aux pragma
  `#pragma aux drc_add "add" parm caller [] value [ax] far;`. Watcom then emits
  EXACTLY the DR C convention: `push` args right-to-left, `call far add` (bare
  name), `add sp,N` (caller cleans), return in AX.
- Entry exposed as bare far `main` via `#pragma aux drc_main "main" far;` so
  CLEARL's `_main` startup calls us directly.
- Link `APPC,ADDC,WMARKSC,CLEARL.L86` -> 52 KB relocatable large-model CMD.
  Run under patched emu2 -> prints **16** (== add(7,9)), clean exit.

### Two build details that mattered

1. **Must link via CLEARL startup, NOT a hand-written crt0.** A single-group crt0
   collapses to the CP/M-86 "8080 model", which does **not** relocate the
   far-call *segment* operand -> the `call far add` jumped to garbage (emu2:
   `unimplemented opcode 0x63`, i.e. ARPL, at a bogus CS). Linking against CLEARL
   yields a proper multi-group **relocatable** CMD whose loader fixes up far-call
   segments, exactly like a native DR C large-model program (e.g. SAMPLE.CMD).

2. **Watcom model-marker stubs.** Linking a Watcom object against CLEARL leaves
   `_big_code_` / `_small_code_` unresolved (Watcom memory-model markers, not DR C
   startup gaps). Stubbed with `equ 0` in `wmarks.asm`. Also one expected-undefined
   `clear_error` in CLEARL's 8087-emulator path — dead for integer programs.

### What is still blocked: POINTER arguments (root cause VERIFIED)

Passing a string literal to DR C `strlen` returns **0** (should be 5). The Watcom
`-ml` disassembly is the smoking gun — for DGROUP data it pushes **SS** as the
segment:

```
push ss                      ; <- Watcom uses SS as the data segment
mov  ax,offset DGROUP:L$1
push ax
call far strlen
```

Watcom large model assumes **SS == DS == DGROUP** (a guarantee its *own* startup
provides). But DR C's CLEARL startup runs with **SS != DS**, so `strlen` reads the
string from the wrong segment, sees an immediate NUL, and returns 0. An explicit
`(char __far *)` cast does **not** help — Watcom still binds DGROUP data to SS.
(No hang; the earlier "exit hang" was just `strlen` scanning off into garbage.)

**Scope of the bridge today:** scalar in/out (int, long via DX:AX) ✅ ;
pointer args ❌ (SS/DS split).

### Path to unblock pointers (next planned task, one of)

1. **Cleanest:** a small large-model startup shim that sets `SS = DS = DGROUP`
   before calling our far entry, while still producing a multi-group *relocatable*
   CMD (so far-call segments to DR C routines are fixed up). Then Watcom's
   `push ss` == DGROUP and DR C routines read the right segment.
2. Force Watcom to load the real DGROUP segment (segment fixup) instead of `push
   ss` for data pointers — investigate Watcom `-zu`/SS!=DS options.
3. Workaround: copy data into a stack buffer (which genuinely lives in SS) before
   the call.

### Files (tracked)
- `bridge_add_lib.c` — DR C-compiled scalar callee (`add`).
- `bridge_scalar.c`  — Watcom caller; the `#pragma aux` bridge, documented inline.
- `bridge-scalar.sh` — reproducible build+run proof (asserts output == "16").
- `bridge_ml.c`      — earlier strlen/pointer probe (kept; demonstrates the SS/DS
  blocker WITHOUT `-zu`).
- `bridge_pointer.c` — pointer bridge; passes 3 string literals to DR C `strlen`.
- `bridge-pointer.sh`— reproducible proof (asserts output == "5 0 11").

Todos: `abi-large` scalar case DONE; pointer case DONE (finding (e) below).
`abi-small` still blocked (near-call segment merge / TARGET OUT OF RANGE);
large model is the working direction.

---

## Finding (e): POINTER arguments UNBLOCKED — Watcom `-zu` (2026-08-13)

**Result:** Watcom-compiled large-model code now passes C string pointers to a
genuine DR C 1.11 library routine (`strlen`) correctly. `bridge-pointer.sh`
prints **`5 0 11`** for `strlen("HELLO")`, `strlen("")`, `strlen("hello world")`
— reproducible PASS. This closes the pointer gap in finding (d); the ABI bridge
now covers scalars AND data pointers.

**The one-flag fix: compile with `-zu` (SS != DGROUP).** Path 2 of finding (d)
turned out to be the clean solution — no startup shim needed.

Finding (d) root-caused the blocker: for DGROUP data Watcom `-ml` emitted
`push ss`, assuming SS == DS == DGROUP (its own startup's guarantee), but DR C's
CLEARL startup runs SS != DS, so `strlen` read the wrong segment and returned 0.

`-zu` tells Watcom the stack is NOT in the data group, so it can no longer use SS
as the DGROUP segment. Instead it emits a real DGROUP **segment fixup** that the
CMD loader relocates to the true data paragraph — exactly what DR C's own code
does. Disassembly (`bwdis`) before vs after:

```
# WITHOUT -zu (broken):            # WITH -zu (correct):
push ss                            mov ax,DGROUP:CONST   ; <- segment fixup,
mov  ax,offset DGROUP:L$1          push ax               ;    loader-relocated
push ax                            mov ax,offset DGROUP:L$1
call far strlen                    push ax
                                   call far strlen
```

**Causal proof (both endpoints measured):** identical source, same link recipe —
WITHOUT `-zu` → `0 0 0` (wrong); WITH `-zu` → `5 0 11` (correct). The flag is the
sole difference, so it is the cause, not a guess.

**Build recipe (pointer-capable large-model bridge):**
`bwcc -0 -ml -s -q -zu app.c` → classicize OMF → link `APP,WMARKS,CLEARL.L86`
under LINK-86 → run under patched emu2. (Same as the scalar recipe plus `-zu`.)
`-zu` is a strict superset — safe to make it the default for ALL large-model
bridge builds (scalar output is unchanged; it only affects data-pointer segment
emission).

**Scope of the bridge now:** scalar in/out (int, long via DX:AX) ✅ ; data
pointer args ✅ (via `-zu`). Remaining: `abi-small` (near-call segment merge) and
exercising a full DR C libc call chain (e.g. `printf`) end-to-end vs the oracle.

---

## Finding (f): how simple the bridge can be — a reusable header (2026-08-13)

**Result:** the entire per-program source surface collapses to three kinds of line:

```c
#include "drcbridge.h"              /* convention + entry, defined once */

extern unsigned strlen(char *s);
#pragma aux (DRC) strlen;           /* ONE line per DR C routine you call */

DRC_MAIN {                          /* your entry */
    conout('0' + strlen("HELLO"));  /* -> 5 */
}
```

Verified end-to-end by `bridge-min.sh` (PASS, prints 5, fully clean link — only
the dead `clear_error` 8087 stub remains undefined).

### What moved into the reusable header (`drcbridge.h`)
- `#pragma aux DRC "*" parm caller [] value [ax] far;` — DR C large-model cdecl,
  defined ONCE as a named convention. Apply per routine with `#pragma aux (DRC) fn;`.
- `"*"` alias emits the **bare** symbol name (`strlen`, not Watcom's `strlen_`),
  so it matches DR C's exports with no per-symbol alias string.
- Entry: `#pragma aux drc_main "main" far;` + `#define DRC_MAIN void drc_main(void)`.

### Two naming facts that keep the link clean (both verified via `strings`/link log)
- **Name the entry `drc_main`, not `main`.** The literal identifier `main` makes
  Watcom emit a reference to its own startup `_cstart_` (undefined here). Aliasing
  a differently-named function to the bare export `"main"` avoids `_cstart_`
  entirely — CLEARL's startup is the only startup.
- **The only residual Watcom markers are `_big_code_` / `_small_code_`** — model
  markers, stubbed `equ 0` in the fixed `wmarks.asm`. Not per-program.

### What CANNOT be simplified away (verified)
- **`#pragma aux default "*" ...` (module-wide) is too broad** — it rewrites the
  calling convention of *local* helpers too, breaking inline-asm parameter refs
  (e.g. `conout`). Use the *named* convention `(DRC)` applied per external routine;
  it leaves local functions untouched.
- **`-zu` build flag** is mandatory for any pointer arg (finding (e)).
- **`omf_classicize.py`, the marker stub, and the CLEARL link** are fixed
  infrastructure — write once, reuse for every program; not per-call boilerplate.

### Files (tracked)
- `drcbridge.h`   — the reusable bridge header (all the pragmas + DRC_MAIN).
- `bridge_min.c`  — minimal example using it (strlen -> 5).
- `bridge-min.sh` — reproducible proof + the fixed build recipe (asserts "5",
  and asserts the link has no unexpected undefined symbols).

**Bottom line:** per DR C routine = 1 extern + 1 `#pragma aux (DRC) name;`. Per
program = `#include "drcbridge.h"` + `DRC_MAIN`. Build = `bwcc -0 -ml -s -q -zu`,
classicize, link `APP,WMARKS,CLEARL.L86`. That is the floor for the large model.

---

## Finding (g): Watcom-side CP/M-86 target glue, generated from DR C (2026-08-13)

Two user constraints drove this: (1) the DRC bridge convention must apply ONLY to
DR C stdlib routines — our own Watcom libraries stay on the native convention; and
(2) DR C's files stay unmodified — all glue lives on the Watcom side and loads
automatically when you select the CP/M-86 target. Both satisfied and verified.

### (1) The convention is per-symbol, so own code is untouched — VERIFIED
`bridge-mixed.sh`: one program calls DR C `strlen` (via `#pragma aux (DRC) strlen`)
AND our own Watcom `triple()` (plain extern, no pragma). Disassembly proves the
split — `call strlen` (bare name, DR C cdecl) vs `call triple_` (Watcom-mangled,
native watcall) — and it runs: output **`5 21`**. This is exactly why a
module-wide `#pragma aux default` is wrong (it would drag own code onto the DR C
convention); the *named* `(DRC)` applied per stdlib symbol is the right tool.

### (2) Glue on the Watcom side, auto-loaded, DR C untouched — VERIFIED
Mechanism: Watcom auto-includes a file named **`_preincl.h`** from the include
path (its default pre-include, option `-fip`). So the whole bridge can live in a
Watcom-side target dir that the target driver puts on `-i`, with the user writing
NO pragmas.

Also VERIFIED: `#pragma aux (DRC) fn;` binds even when it appears BEFORE the
routine's declaration (the pre-include runs first, DR C's own prototype can come
later), and an unused `(DRC)` pragma for a never-called routine is harmless — so a
single generated `_preincl.h` can safely list the whole stdlib.

### The installation step (transforms DR C -> practical Watcom glue)
`install-cpm86-target.sh` READS `CLEARL.L86`'s export table and EMITS a Watcom-side
target dir (`open-watcom-v2/cpm86/`) — DR C files are never modified:
- `_preincl.h` — the `DRC` convention, the `DRC_MAIN` entry macro, and one
  `#pragma aux (DRC) fn;` for every public DR C stdlib routine (112 symbols,
  derived from CLEARL so it stays in sync). A small blocklist excludes non-callees
  (`main`, `errno`, `sys_nerr`, `nostart`, `nofloat`, `clear_error`).
- `WMARKS.OBJ` — classicized `_big_code_`/`_small_code_`=0 marker stub.

`cc-cpm86.sh` is the "select target" driver: `bwcc -0 -ml -s -q -zu -i<target>`
(auto-includes `_preincl.h`) -> classicize -> `LINK-86 objs,WMARKS,CLEARL.L86`.

### End-to-end proof (no bridge pragmas in user source)
`hello_cpm86.c` is ordinary C — `extern unsigned strlen(char*);` + `DRC_MAIN { ...
strlen("HELLO") ... }`, zero pragmas. `./install-cpm86-target.sh` then
`./cc-cpm86.sh -o HELLO86.CMD hello_cpm86.c` -> runs -> **`5`**. Mixed own+stdlib
through the same driver (`mix86.c + mylib_own.c`) -> **`5 21`**.

### Files (tracked)
- `install-cpm86-target.sh` — generates the Watcom-side glue from CLEARL (DR C untouched).
- `cc-cpm86.sh`             — the CP/M-86 target compile+link driver.
- `hello_cpm86.c`          — demo with NO bridge pragmas (glue auto-loaded).
- `bridge_mixed.c`, `mylib_own.c`, `bridge-mixed.sh` — DR C-stdlib-vs-own isolation proof.
