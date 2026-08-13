# DR C (Digital Research C) toolchain architecture — how it builds a .CMD

Answers "is LINK86 part of DR C, and if not how does DR C work?" Verified from
the `drc86111` archive (Ken Mauro DR C 1.11 CP/M-86 port) contents + its batch
files, 2026-08-13.

## Short answer

LINK86 is **Digital Research's system linker** — historically part of DR's
Programmer's Utilities / CP/M-86 toolset, SHARED across DR language products
(C, PL/I-86, RASM-86, ...), NOT a C-only component. BUT it IS bundled in this DR
C distribution (`LINK86.CMD` + `LINK86.BAT` are in `drc86111/`), and DR C
absolutely REQUIRES it: the DRC compiler only produces OMF `.obj`; LINK86 does
the OMF -> `.CMD` linking against the C runtime library. So both are true —
LINK86 ships WITH and is NEEDED BY DR C, but it is a general DR tool, not part of
the compiler proper. (This is exactly why "native wlink CMD" means REPLACING
LINK86, a shared DR component.)

## The toolchain pieces (all in drc86111/)

- **DRC** — the C compiler. Driver `DRC.CMD` chains the compiler phases
  `DRC860.CMD` (preprocess) -> `DRC861.CMD` (codegen) [-> `DRC862.CMD`], with
  `DRCRPP.CMD` (preprocessor helper). Output: an OMF `.obj`. (Per-phase split
  from drc-oracle.sh notes; DRC862/DRCRPP exact roles inferred, not fully
  confirmed.) Errors table `DRC.ERR`; K&R C89.
- **RASM86** (`RASM86.CMD`) — DR's Relocatable Macro Assembler for `.a86`
  sources. Output: OMF `.obj`. (Open Watcom `bwasm` stands in for it in our
  pipeline; `-nm=` sets the OMF module name.)
- **LINK86** (`LINK86.CMD`) — DR's OMF linker. Links `.obj` + runtime `.L86`
  library into a runnable CP/M-86 `.CMD`. v1.4 here. (THEADR module-name limit
  35 chars -> ERROR 10; see wlink-cpm86-plan.md.)
- **LIB86** (`LIB86.BAT` -> `cpm86 lib86`) — DR's `.L86` library manager
  (list publics/externals/modules/map/xref; build/maintain libraries). The
  LIB86.CMD binary itself is NOT in this archive (only the .BAT wrapper).
- **DDT86** (`DDT86.CMD`) — DR's Dynamic Debugging Tool.
- **C runtime libraries**: `CLEARS.L86` (SMALL/8080 model, 129 modules) and
  `CLEARL.L86` (LARGE/big model, 131 modules). The C program links against one.
- **Headers**: STDIO.H, CTYPE.H, ALLOC.H, DOS.H, FLOAT.H, CONIO.H, BIOS.H,
  ERRNO.H, PORTAB.H.

## The build pipeline (from DRC.BAT / MAKE.BAT / LINK86.BAT)

Standard DR C build of `prog.c` (+ optional companion asm `mod.a86`):
```
copy /b prog.c + cpmeof.asc  srcfile.c   ; pad source with EOF ESC bytes
cpm86 drc    srcfile -b                   ; compile C  -> srcfile.obj (-b = big/large model)
cpm86 rasm86 mod $nc                       ; assemble optional .a86 -> mod.obj
cpm86 link86 prog=srcfile[,mod]            ; LINK -> prog.cmd  (links runtime .L86)
```
- `cpm86` is the CP/M-86 emulator/runner prefix (John Lopushinky's, under DOS).
  In OUR pipeline `emu2` (patched, ravn/emu2-cpm86) plays that role, and
  `drc-oracle.sh` implements exactly this chain (compile -b, link with
  CLEARL.L86[S], optional putchar-far).
- **EOF padding quirk**: DR C wants source EOF-padded with ESC bytes
  (`cpmeof.asc` appended via `copy /b`); `.h` files carry embedded ESCs at EOF —
  do not strip them. Only needed under the emulator, not real CP/M-86.
- `DRCS.BAT` uses `drc srcfile -a` to emit a `.cmd` more directly (tiny/8080
  path); the mainline is `-b` + LINK86.

## Model selection

- `-b` (DRC) = big/LARGE model -> link with `CLEARL.L86`. DR C DEFAULTS to large
  model; externals are FAR-called (see putchar-far.asm requirement).
- small/8080 model -> `CLEARS.L86`.

## Cross-refs
- reference_wlink_drc_omf_l86.md — wlink reads DR OMF; .L86 -> wlib repackage.
- reference_watcom_drc_abi_bridge.md — -ecc + aux pragma Watcom<->DR C bridge.
- reference_dri_cpm86_manuals_location.md — DR C Programmer's Guide location.
- scratch/rc759-cmd-toolchain/drc-oracle.sh — our emu2 reimplementation of the
  DRC.BAT chain.
