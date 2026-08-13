# wlink vs DR C OMF / .L86 libraries (verified 2026-08-13)

Goal context: make Open Watcom **wlink** build CP/M-86 **CMD** files directly,
100% compatible with DR **LINK-86**, so we can retire the emulated LINK86 from
the pipeline. That requires wlink to consume DR C's runtime libraries.

## Verified findings (empirical, `open-watcom-v2/build/binbuild/bwlink`)

1. **DR C OMF object modules: wlink READS them fine.**
   All 131 modules extracted from `drc86111/CLEARL.L86` link through wlink with
   ZERO object-format errors. The only diagnostics are `E2028 ...undefined
   reference` for DR group/segment frame symbols (`_NES/_NCS/_NSS/_NDS/_NST/
   _WES/_WCS/...`) — a linkage artifact of linking the runtime in isolation, NOT
   a format problem. DR's RASM-86 OMF encoding is compatible with wlink's OMF
   reader (`bld/wl/c/objomf.c`).

2. **The `.L86` library CONTAINER: wlink CANNOT read it.**
   Feeding `CLEARL.L86` as a `library` and forcing a symbol reference (e.g.
   `atoi`) gives: `Error! E2012: file ...CLEARL.L86: invalid library file
   attribute`. Cause: wlink's library sniffer (`bld/wl/c/libr.c` ~l.358) accepts
   only `header[0]==0xF0` (OMF `LIB_HEADER_REC`, `watcom/h/pcobj.h`) or the
   `"!<arch>"` AR magic. `.L86` starts with DR's own `0xA4` library-header
   record, so it is rejected at the front door. (An UNREFERENCED `library` line
   appears to "work" only because wlink parses libraries lazily — on first
   symbol resolution.)

## DR `.L86` file layout (decoded)

```
[ 0xA4 , 0xA6 , 0xA8 , 0xAA ]   DR library header + symbol dictionary (front)
[ 131 x ( THEADR 0x80 .. MODEND 0x8A ) ]   ordinary Intel-8086 OMF modules
[ trailing symbol index ]       (~last ~100 bytes; a naive OMF walk overruns here)
```
Module THEADRs carry RASM-86 stamps ("RASM-86 1.30 2/20/84") and short names
("0BLKN", "_segmove"). Publics include `atoi/atol/atof/strcat/strncmp/strrchr/
zalloc/_blkio/...` (DR C uses NO leading underscore on C names).

## Path to the goal (reuse DR runtime under wlink)

- **Unpacker written**: `scratch/rc759-cmd-toolchain/unpack_l86.py CLEARL.L86 out/`
  splits a `.L86` into `NNN_<name>.obj` OMF modules (verified: 131 clean modules).
- **VERIFIED END-TO-END (2026-08-13)**: `l86-to-lib.sh CLEARL.L86 CLEARL.lib`
  (unpack + `bwlib -q -b -c`) builds a real OMF `.lib` (0xF0 header). wlink then
  links against it natively: a test object referencing `atoi` resolves cleanly
  under `format dos`, and the map shows wlink pulled `CLEARL.lib(ATOI)` PLUS its
  transitive deps `CLEARL.lib(CTYPE)` and `CLEARL.lib(INCDEC)` — so DR's internal
  library symbol/dependency graph resolves correctly through wlink's OMF
  dictionary. No object-format or undefined errors. (Under `format dos com` you
  get benign `W1019 segment relocation` warnings because .COM is single-segment;
  the real CMD format, which HAS segment groups, is the correct target.)
  Both DR runtimes convert: CLEARL.L86 -> 131 modules, CLEARS.L86 -> 129 modules.
- Two ways to make wlink link DR's runtime:
  - (a) **Repackage** the unpacked modules into an OMF `.lib` with **wlib**
    (`l86-to-lib.sh`, DONE + verified) — the pragmatic path, no wlink change.
  - (b) Teach wlink to read the DR `.L86` container (a reader in `libr.c`). More
    invasive; preserves the exact library bytewise. Now unnecessary given (a).
- The unresolved `_NES/_WCS/...` frames are DR C's group-base symbols; they must
  be satisfied by the DR C startup/group definitions (what LINK-86 provides via
  its group model) — part of the Watcom<->DR C ABI/group bridge, not a format gap.

## Native CMD output side (separate from the library question)

wlink dispatches output formats in `bld/wl/c/loadfile.c` (~l.274) by
`FmtData.type`; the MS-DOS 16-bit writer `bld/wl/c/loaddos.c` (`FiniDOSLoadFile`
= MZ .EXE, `WriteCOMGroup` = flat .COM) is the closest template for a new
`loadcpm.c` (`FiniCPMLoadFile`) that emits CP/M-86's 128-byte Group-Descriptor
header. Register a new `MK_CPM` bit in `bld/wl/h/_formats.h` + `formats.h`, hook
the dispatcher in `loadfile.c`, add `ProcCpmFormat` parsing (model on
`bld/wl/c/cmddos.c`). This replaces BOTH DR LINK-86 and the python
`omf2cmd.py`/`mkcmd.py` post-processors.
