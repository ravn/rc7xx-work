# Plan: native CP/M-86 `.CMD` output in `wlink` (ravn/open-watcom-v2#10)

**Goal (decided, user 2026-08-14): native `.CMD` output in wlink itself.** The
DR C LINK-86 pipeline (Watcom OMF → `omf_classicize.py` → LINK-86 under emu2) is
the **oracle/scaffolding** — it already produces byte-verified running CMDs, so
it is how we validate wlink's output, NOT the deliverable. #10 is not parked.

Status: **Phase 1 IMPLEMENTED + RUNS ON REAL RC759 HARDWARE** (2026-08-14, fork
branch `wlink-cpm86-cmd-format`, commit `7014acfb`). `wlink format cpm86` emits
byte-correct CMDs; a wlink-built CMD **booted and ran on the real RC759 (CCP/M-86
3.1) in MAME** and printed `HELLO FROM A WLINK format cpm86 CMD ON REAL RC759`
(done-signal `0xAC57` caught by `done_signal.lua`). Proof screenshot:
`wlink-cmd-test/RC759_WLINK_CMD_PROOF.png`. Also runs under emu2-cpm86 (8080).
Reproducible artifacts in `wlink-cmd-test/` (rc759_2group.asm, t8080.asm, hi*.c).

**Verified RC759 CMD shape (the one that runs on hardware):** 2 groups
(CODE type 1 + DATA type 2). A single-group (8080) CMD does NOT run on RC759 —
the base page lands at the code segment's offset 0 and clobbers the entry
(confirmed: menu.cmd invoked, no output; 2-group version then worked). The DATA
group must be ≥16 paras so the loader's 256-byte base page fits (used 96p).

**MEASURED entry registers on real RC759 (2026-08-14, `regs.asm` dumped them):**
```
CS=2150  DS=216D  ES=216D  SS=214A  SP=005C
```
So the CCP/M-86 loader **sets DS and ES itself** (both = the data group;
`DS = CS + code_paras` — here 0x216D-0x2150 = 0x1D = 29 = the CODE group size).
The earlier claim that "crt0 must set DS=SS=CS" was WRONG — the HELLO test only
did so because it kept its string in the CODE group. **Correct small-model crt0
(now VERIFIED on real RC759 — `crt0sm.asm`):**
- Do NOT touch DS/ES (loader already points them at the data group).
- DO set a real stack: the loader's `SP=0x5C` is a ~92-byte scratch stack, so
  crt0 does `mov ax,ds; mov ss,ax; mov sp,offset DGROUP:stktop`.
- Program data lives at **DS:0100** — the base page occupies DS:0000-00FF, so
  DGROUP needs a 0x100 reservation first (`op dosseg` + a `BEGDATA` seg).

**COMPILED-C NOW RUNS ON REAL RC759 (2026-08-14):** a `wcc -0 -ms` C program
(`smain.c`) + `crt0sm.asm`, linked `wlink format cpm86 op dosseg`, printed
`SMALL-MODEL C ON RC759 VIA WLINK format cpm86` on the real RC759 (done-signal
`0x5A11`). This closes the compiled-C small-model path end-to-end.
Full CP/M-86 header + loader contract + DR C stack handling with spec citations:
`tasks/memory/reference_cpm86_cmd_header.md`. Proof screenshots in
`wlink-cmd-test/`: `RC759_ENTRY_REGISTERS.png`, `RC759_WLINK_CMD_PROOF.png` (asm),
`RC759_SMALLMODEL_C_PROOF.png` (compiled C).

## Phase 3 clib linkage — DONE (2026-08-14)
`owcc -bcpm86 prog.c -o prog.cmd` now links a C program using clib end-to-end and
the CMD runs under emu2-cpm86 (printed "HELLO FROM WATCOM CLIB ON CPM86").
- **wlink deliverable:** removed `option nodefaultlibs` from the `system begin
  cpm86` block in `open-watcom-v2/bld/wl/lnk/specs.sp` (fork, one-line diff). The
  compiled object carries a COMENT `CMT_DEFAULT_LIBRARY "clibs"` record (small
  model) exactly like DOS, so wlink auto-fetches `clibs.lib` from libpath — no
  explicit `library` directive needed. Verified: byte-identical dos/cpm86 objects;
  differential strlen link (present→resolved, absent→undefined).
- **crt0:** `cstartcpm.obj` (assembled from `wlink-cmd-test/crt0sm.asm` with
  `wasm -0`) provides `_cstart_`/`__STK`/`_small_code_`; pulled via `libfile
  cstartcpm.obj` in the cpm86 block. Saved to `cpm86-clib/cstartcpm.obj`.
- **clib:** Watcom-native `cpm86-clib/clibs.lib` (hand-written C + Watcom cgsupp
  i4d/i4m). Install both into `$WATCOM/lib286/cpm86/` via
  `cpm86-clib/build-and-install.sh`.
- **owcc driver:** its `specs.owc` already contains `system begin cpm86 / ARCH
  i86 -bt=cpm86`. owcc/wcc/wlink are found via `_searchenv(..., "PATH")`, so put a
  bin dir with `specs.owc`+`wcc`+`wasm`+`wlink` on PATH. Benign warnings: W1080
  (16-bit object), W1023 (no starting address → CS:0000 = _cstart_, runs fine).

## L86 (DR C library) interop — feasibility (2026-08-14, VERIFIED)
Question: can wlink link directly against DR C's `.L86` standard library?
**Working experiment: `l86-experiment/` (README + `split_l86.py` + `build_drclib.sh`).**
Proven: `.L86` -> 129 OMF modules -> `wlib` -> Watcom `.lib`; wlink auto-resolves
the entire transitive DR runtime (only `main` left). Running-CMD gap = DR startup
channel init, not the linker. Details below.

Byte-level findings (dmpobj on `drc86111/CLEARS.L86`, 80640 B):
- `.L86` = **Intel OMF library format**: `LIBHED(0xA4)` + `LIBNAM(0xA6)` +
  `LIBLOC(0xA8)` + `LIBDIC(0xAA)` wrapping **129** standard Intel 8086 OMF modules
  (THEADR×129 / MODEND×129; SEGDEF/LEDATA/GRPDEF/COMENT/FIXUPP/PUBDEF/EXTDEF/LNAMES
  + old **`TYPDEF(0x8E)`**). dmpobj decodes every record — no unknowns.
- **wlib rejects the wrapper**: `Error! 'CLEARS.L86' is an invalid library` —
  Watcom's librarian/linker only read Microsoft-style OMF libs (`LIBHED 0xF0` +
  512-B-page dictionary), AR, COFF; not the 0xA4 Intel style.
- **But the object modules are Watcom-ingestible.** Extracted module 1
  (THEADR@0x0a..next THEADR@0x147): `wlink` links it with no format error; `wlib`
  repackages it into a valid Watcom `.lib` **with a correct symbol dictionary**
  (`_segmove/blkfill/blkmove/swab`), TYPDEF and all.

Conclusion — two routes:
- **Route A (patch wlink/wlib to read 0xA4 libs):** feasible but real source work
  (new library-format recognizer beside 0xF0/AR/COFF: detect 0xA4, walk
  LIBLOC/LIBDIC for module offsets + build dictionary). NOT needed given B.
- **Route B (offline repackage, RECOMMENDED, no wlink change):** split `.L86` at
  THEADR..MODEND boundaries → feed modules to `wlib` → standard Watcom `.lib` that
  wlink links normally. Proven at single-module level; scaling = a ~30-line splitter
  (boundaries = successive THEADR offsets; last module ends before `LIBNAM 0xA6`).

**ABI caveat (format ingestion != working link).** The DR library's EXTDEFs expose
a DR *runtime substrate* that "just the I/O routines" cannot escape: `__BDOS` (DR's
CP/M-86 BDOS gateway, 16 refs), DR's 32-bit long-math family (`_si4/_li4/_spl/_slp/
_sbl/_gtl/_srl/_nel/_ltl/_adel/_eql/_adl/_sll/_mll/_lia...` — DR's analogue of
Watcom i4d/i4m, different names+ABI), and file/heap internals (`_blkio/__open/
_allocc/_freec/__chinit/___atab/_chkuser`). So DR I/O is **not self-contained** —
pulling it in drags DR's whole runtime model.

=> **whole-lib vs I/O-only (defer, but framed):** taking "only I/O" still requires
providing DR-compatible `__BDOS` + the `_?i4`/`_?l` long-math ABI + heap/file
substrate. The clean split is instead: keep the working hand-written Watcom-native
`clibs.lib`, and only cherry-pick *leaf* DR routines with zero DR-runtime EXTDEFs
(e.g. blkmove/segmove/swab) via Route B. Adopting DR I/O wholesale means adopting
DR's runtime (its BDOS gateway + long-math ABI + base-page/_v_* vectors).

## TODO (later)
- **Get Watcom to generate DDT86 symbol files.** DDT86 (DRI's CP/M-86 debugger on
  the RC759 disks) reads a `.SYM` symbol file for symbolic debugging; Watcom emits
  DWARF/Watcom debug info, not DRI `.SYM`. Add a post-link step (or a wlink option)
  that writes a DDT86-compatible `.SYM` from the link's public symbols, so
  wlink-built CMDs can be symbolically debugged with DDT86 on real RC759.

Remaining (Phase 3, crt0/runtime — NOT a wlink issue):
- **Small model needs a 0x100 base-page reservation at the start of DGROUP.**
  The CP/M-86 loader (emu2 line 568: `memset(data_seg, 0, 0x100)`) zeroes the
  first 256 bytes of the data group for the base page, clobbering Watcom data
  placed at `DGROUP:0000`. LINK-86-built programs reserve it; a Watcom CP/M-86
  crt0 must add a 0x100 `BEGDATA` segment first in DGROUP so real data starts at
  `DS:0100`. The 8080/tiny model sidesteps this (base page 0-0xFF, code ORG 100h)
  and already runs. `_cstart_`/`_small_code_`/BDOS-exit crt0 links clean (crt0.asm).

**Two Open Watcom trees in the workspace (do not confuse them):**
- **`/Users/ravn/z80/open-watcom-v2`** — the tracked git *submodule*, remote
  `ravn/open-watcom-v2` (our **fork-of-record**). This is where the native-CMD
  edits must land so they get committed/pushed.
- **`/Users/ravn/z80/scratch/open-watcom-v2`** — an untracked, fully *built*
  scratch clone whose remote is **upstream** `open-watcom/open-watcom-v2` ( pristine
  master, no ravn commits). Used only to compile wlink and to read source from.

All source citations below are `bld/wl/` line numbers; the code is identical in
both trees (the fork only adds `contrib/ravn`), so they were read from the
already-built scratch clone, but the edits belong in the fork submodule.

Related: issue ravn/open-watcom-v2#10; RC759 CMD toolchain in
`scratch/rc759-cmd-toolchain/` (working `mkcmd.py` interim wrapper). Oracle-track
research log (DR C LINK-86 pipeline, ABI bridge, emulator work): `cpm86-toolchain-log.md`.

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
  16-bit real-mode segmented, so a new `MK_CPM86` must join `MK_16BIT`,
  `MK_REAL_MODE`, `MK_SEGMENTED`, `MK_ALLOW_16` (and probably `MK_END_PAD`).
- **Feature gate** — `bld/wl/h/wlinkcfg.h:34-42` defines one macro per built-in
  format (`#define _EXE 0`, `#define _RAW 7`, `#define _RDOS 8`, ...). They are
  all defined, so `#ifdef _RAW` compiles that format into the full linker. Add
  **`#define _CPM86 9`**.
- **The dispatch** — `bld/wl/c/loadfile.c:254` `finiLoad()` is a chain of
  `if( FmtData.type & MK_xxx ) { Fini<xxx>LoadFile(); return; }`, each wrapped in
  `#ifdef _xxx`. This is where a `#ifdef _CPM86 ... FiniCPM86LoadFile()` clause goes.
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

## 3. Concrete change set (7 edits + 2 new files)

Verified against the RDOS_16 precedent (`cmdrdv.c` + `loadrdv.c`) — the nearest
16-bit real-mode format. Phase 1 is *smaller* than RDOS: no `FmtData.u` struct
(no selectors/segments), no relocations.

| # | File | Change |
|---|------|--------|
| 0 | `bld/wl/h/ldefext.h:72` | add `pick( E_CMD, "cmd" )` (RDOS added `E_RDV`; `def_ext` needs the enum) |
| 1 | `bld/wl/h/_formats.h:57` | add `pick_format( 0x00200000, MK_CPM86, 21, "CP/M-86", "CP/M-86" )` (give line 57 a trailing `\`) |
| 2 | `bld/wl/h/formats.h:45-66` | add `MK_CPM86` to `MK_16BIT`, `MK_REAL_MODE`, `MK_SEGMENTED`, `MK_ALLOW_16`, `MK_END_PAD` |
| 3 | `bld/wl/h/wlinkcfg.h:42` | add `#define _CPM86 9` |
| 4 | `bld/wl/c/cmdall.c:2066` | add `"CPM86", ProcCPM86Format, MK_CPM86, 0,` to the format table |
| 5 | `bld/wl/c/loadfile.c:~275` | add `#ifdef _CPM86 if( FmtData.type & MK_CPM86 ){ FiniCPM86LoadFile(); return; } #endif` |
| 6 | `bld/wl/wlobjs.mif:~68` | add `$(_subdir_)loadcpm86.obj &` and `$(_subdir_)cmdcpm86.obj &` to the object list (`loaddos.obj` at line 58, `loadraw.obj` at line 68) |
| A | **new** `bld/wl/c/cmdcpm86.c` + `bld/wl/h/loadcpm86.h` | `ProcCPM86Format` (set `FmtData.def_ext = E_CMD`, `LinkState |= LS_FMT_DECIDED`) + sub-keywords `SMall`/`8080`; mirrors `cmdrdv.c` |
| B | **new** `bld/wl/c/loadcpm86.c` | `FiniCPM86LoadFile()`: build 8-descriptor header from `Groups`, write group images via `WriteGroup` (loadfile.c:757, the level `loadrdv.c` uses), pad each to 128-byte record, optional fixups |
| C | `msg.c` / usage tables | add the parallel format-name entry the enum comment warns about; add `format cpm86` help in `cmdhelp.c:200` region |

`FiniCPM86LoadFile()` sketch (mirrors `FiniRdosLoadFile`, loadrdv.c:317 —
reserve header, write groups, write header last since sizes are only known after):
1. `SeekLoad( 128 )`; `Root->u.file_loc = 128` — reserve the 128-byte header.
2. Walk `Groups` (loadfile.c global); classify each by `group->leaders->pieces->iscode`
   vs `isidata`/`isuninit` (the `GetRdosSegs` pattern). Descriptor `length` =
   `__ROUND_UP_SIZE_PARA(group->size) >> 4` (stored bytes), `min` = same over
   `group->totalsize` (incl BSS). BSS is *not* written — `min > length` makes the
   loader zero-fill (matches asm86: len=435, min=1102).
3. For each group: `WriteGroup( group )`, then `PadLoad` to the next 128-byte record.
4. `SeekLoad( 0 )`; write the up-to-8 × 9-byte descriptors + `db type` header.
5. Fixups (Phase 2 only): set header `0x7F` bit 7 and dump a table modeled on
   `WriteDOSRootRelocs` (`loaddos.c:55`).

---

## 4. Phasing

- **Phase 1 (MVP, matches today's `mkcmd.py`):** 8080 + small model, `base=0`,
  **no fixups**. Reuses the raw group-writer path entirely. Deliverable: `wcc
  hello.c && wlink format cpm86 file hello` produces a `.CMD` that runs on RC759.
- **Phase 2:** compact model (EXTRA/STACK groups) + full fixup table (bit-7 flag),
  modeled on the DOS reloc dumper. Enables real relocatable multi-segment C.
- **Phase 3:** wire `wcl`/`owcc` so `-bcpm86` / `system cpm86` selects the format and
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

- Unit: `wlink format cpm86` on a hand-`wcc`'d trivial `.obj`; byte-compare the
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
MVP `FiniCPM86LoadFile()` that classifies groups + writes base=0 images is a
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
native CMD writer that emits per-group images (wlink `format cpm86`, or LINK-86) IS
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

Net: full compiled-C small-model path = wlink `format cpm86` (Phase 1) + crt0.obj +
bdos glue + _small_code_ stub. Each is small; together they make `bwcc x.c ->
link -> x.cmd` boot on the RC759. Build+boot verification is the remaining work.


---
## Archived detail
The pre-2026-08-14 plan (incl. the 2026-08-13 DR C / LINK-86 oracle findings a–k,
state snapshots, and the ABI-bridge write-ups) was condensed out of this active
plan. Full verbatim copy preserved in `wlink-cpm86-plan-archive-2026-08-13.md`.
