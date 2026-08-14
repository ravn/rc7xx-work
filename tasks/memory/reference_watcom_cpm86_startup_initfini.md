# Watcom CP/M-86 retarget — authoritative startup & init/fini mechanism (from OW docs+src)

2026-08-14. Investigated Open Watcom's own documentation + startup source to resolve the
stdio auto-flush gotcha and validate the whole CP/M-86 retarget model. All authoritative.

## The docs bless this exact retarget model
`docs/doc/cg/cromable.gml` — chapter **"Creating ROM-based Applications"** — is the official
porting guide for "not running in a DOS, OS/2, QNX, or Windows environment" (= CP/M-86). It:
- Lists the **ROMable (OS-independent) functions** usable as-is (printf/sprintf/qsort/str*/
  math/itoa/ltoa/...). This is Layer 1 (Watcom clib UNCHANGED) — documented, not a hack.
- States the OS-dependent low-level functions we must supply (write/read/open/close/lseek/
  **sbrk**, `_matherr`) — Layer 2 (our BDOS seams). Exactly our architecture.
- Section **"Modifying the Startup Code"** points to `cplibrt` for the startup sources.

## Reference startup chain (16-bit, `cplibr.gml` §cplibrt + real source)
`CSTRT086.ASM` (asm, first part) -> `CMAIN086.C` (`_CMain`, calls main). Real files in
`scratch/open-watcom-v2/bld/clib/startup/{a/cstrt086.asm,c/cmain086.c}`.
- `cstrt086.asm:423` `call __InitRtns` ; then `:424` `jmp __CMain`.
- `cmain086.c`: `_CMain()` = `exit( main(___Argc,___Argv) )`.

## The init/fini table machinery (THE answer to the flush gotcha)
Segments bracketed by `clib/startup/a/xiyi.asm`:
  `DGROUP group XIB,XI,XIE,YIB,YI,YIE`  (XI = init table, YI = fini table).
`clib/startup/c/initrtns.c` defines the walkers (`_Start_XI.._End_XI`, `_Start_YI.._End_YI`):
- **`__InitRtns(limit)`** walks XI, calls each `struct rt_init` (near/far, priority-ordered;
  255 = run all). `iob.c` registers **`__InitFiles`** here.
- **`__FiniRtns(min,max)`** walks YI. `exit()` (`exit.c:95`) calls `__FiniRtns(FINI_PRIORITY_EXIT,
  255)` then `_exit`. **`__full_io_exit` (stdio auto-flush-at-exit) registers in YI.**
- `exit()` -> `__FiniRtns` -> `_exit` -> `__exit` (the sole OS terminate seam = our BDOS
  INT E0h CL=0).

## Consequence for our crt0 (crt0sm.asm)
Current minimal crt0 skips the tables and terminates via raw INT E0h, so `__InitFiles` never
runs and auto-flush never happens -> the per-caller `fflush(stdout)` requirement.
**Documented-correct fix (cheap — 3 hooks):**
 1. Link `xiyi.asm` so XIB/XI/XIE/YIB/YI/YIE bracket into DGROUP (resolves `_Start_XI` etc.).
 2. `call __InitRtns` with limit 255 before main (runs file init, etc.).
 3. Terminate through Watcom `exit()` (walks YI -> auto-flush), not raw INT E0h.
This makes ALL Watcom stdio, `atexit`, locale init work with no per-caller fflush. Our only
remaining OS seam stays `__exit`/`_exit` (BDOS terminate) + the low-level write/read/... shims.
Lighter fallback still valid for a console-only proof: skip tables, explicit `fflush(stdout)`.

## Doc locations (workspace, do not re-download)
`open-watcom-v2/docs/doc/cg/cromable.gml` (ROM porting), `.../cg/cplibr.gml §cplibrt` (startup
files), source under `scratch/open-watcom-v2/bld/clib/startup/`.

## Milestone 3 PROVEN (2026-08-14): genuine stdio FILE* write-path on CP/M-86
`build-stdio.sh` runs Watcom's UNCHANGED buffered FILE* path (printf/fprintf/
puts/fputs -> __fprtf/fputc -> __flush -> __qwrite) under emu2, oracle-matched,
0x INT 21h (BDOS=2). Two seams in `port/stdioshim.c`:
- `__qwrite(handle,buf,len)` — overrides the DOS low-level write; console
  handles 1/2 via BDOS C_WRITE (INT E0h,CL=2), bytes VERBATIM (Watcom text-mode
  fputc already did \n->\r\n; adding CR here double-CRs).
- `isatty(h)` — replaces the DOS INT21h/AH=44h IOCTL; returns tty for 0/1/2,
  which also line-buffers stdout.
KEY layout fact: FILE has NO _base field; `_FP_BASE(fp)=fp->_link->_base` where
`_link` is a __stream_link. The static __iob has `_link=NULL`, so stdout is
UNUSABLE until `__InitFiles` (initfile.c) attaches a malloc'd __stream_link to
each std FILE. __InitFiles is genuinely DOS-free (only lib_nmalloc) -> link the
real initfile.obj + call it once at startup (we call it from main(); a fuller
crt0 runs it via __InitRtns). stubs needed: errno, flushall, __lseek, fsync,
__full_io_exit (all unused on the console write path). emu2 appends a trailing
\r\n at program exit (not our output). Fork commit dd3f048e.
