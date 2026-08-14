# Experiment: wlink + DR C `.L86` libraries (2026-08-14)

Goal: get Open Watcom `wlink` to link against Digital Research C's `.L86`
standard library.

## Result (verified)

**wlink links DR C's `.L86` library successfully** — via an offline format
conversion, with **no wlink source change**. Proven end-to-end at the
linker/library level; a *cleanly running* CMD needs DR runtime-startup
bring-up (see "Remaining gap").

## Why the `.L86` is rejected directly

`wlib`/`wlink` detect the library format by the **first byte** of the file
(`bld/nwlib/c/proclib.c`, if/else chain): AR (`!<arch>`), Watcom MLIB
(`LIBMAG`), import-DLL, then **OMF library iff `buff[0] == LIB_HEADER_REC`**
where `LIB_HEADER_REC = 0xF0` (`bld/watcom/h/pcobj.h:52`, Microsoft LIBHED).
Otherwise -> `BadLibrary()` -> *"invalid library"*.

DR's `.L86` starts with **`0xA4`** — Intel's *older* library header
(`LIBHED 0xA4` / `LIBNAM 0xA6` / `LIBLOC 0xA8` / `LIBDIC 0xAA`). It matches no
recognizer, so it is rejected — **even though the object modules inside are
standard Intel OMF** that Watcom's object reader ingests fine (`dmpobj` decodes
every record; a repackaged module links with no format error).

So `.L86` = Intel-OMF library wrapper (0xA4 family) around 129 standard Intel
8086 OMF modules (incl. old `TYPDEF 0x8E`, which Watcom also accepts).

## The working route (offline repackage, Route B)

```
./build_drclib.sh ../rc759-drc-official/clears.l86 drclib.lib
```
1. `split_l86.py` walks OMF records and cuts each `THEADR..MODEND` span into a
   separate `.obj` (129 modules), skipping the `0xA4/A6/A8/AA` wrapper records.
2. `wlib` repackages the modules into a standard Watcom `.lib` **with a full
   symbol dictionary** (printf/malloc/strlen/fopen/sprintf/qsort/... -> module).
   No module rejected.
3. `wlink ... library drclib.lib` then links normally.

### Verified linker behaviour
- Leaf symbol: a stub calling `blkmove` -> wlink pulls `drclib.lib(0BLKN)`,
  resolves it, no undefined. Map: `Module: drclib.lib(0BLKN)`.
- Transitive: a stub calling `printf` -> wlink auto-pulls **~58 DR modules**
  (PRINTF->DOPRT->long-math LONGAR/ULDIV/LISI->stdio WRITE/FLSBUF/CHANNELS->
  heap MALLOC/MINITHEAP->**OSIF** BDOS gateway->crt0 MAIN/XMAIN/MINIT/EXIT...).
  **Only `main` is left undefined** — the whole DR runtime is self-contained
  in the library (you do NOT hand-write `__BDOS`; DR's `OSIF` provides it).

## Whole-lib vs I/O-only (the deferred question, now evidence-based)

DR I/O is **not** self-contained: its EXTDEFs pull `__BDOS` (OSIF), DR's 32-bit
long-math ABI (`_si4/_li4/_spl/...`, LONGAR), and heap/file substrate
(`_blkio/__open/_allocc/MINIT*`). Pulling "just I/O" drags the whole DR runtime.
But since that runtime is *complete inside `clears.l86`* and auto-resolves, the
natural unit is the **whole converted lib** (needs only a `main`), not a curated
I/O subset. Cherry-picking only makes sense for *leaf* routines with zero DR
EXTDEFs (e.g. blkmove/segmove/swab).

## Remaining gap (for a cleanly *running* CMD)

Linking a `format cpm86` CMD with DR's own startup works and the CMD **loads and
executes DR's `m.init`** under emu2-cpm86 (verified: entry must be forced to
CGROUP:0000 because CP/M-86 enters at CS:0000 and ignores the OMF entry field —
`file MINIT.obj` first). But DR's C startup then errors ("Cannot cre[ate]" +
garbage) initializing its console/file **channels** under emu2's CCP/M-86. That
is DR runtime-environment bring-up (base page / channel / console-mode
semantics), i.e. the "adopt DR's runtime model" decision — separate from, and
downstream of, the linker/library interop proven here.

## Files
- `split_l86.py` — the `.L86` -> OMF-module splitter (the key deliverable).
- `build_drclib.sh` — one-shot: split + `wlib` -> `drclib.lib`.
- `drclib.lib` / `drclib.lst` — converted Watcom lib + symbol map (from official
  `rc759-drc-official/clears.l86`).
