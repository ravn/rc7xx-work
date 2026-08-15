# Watcom OWN disk FILE\* path on CP/M-86 via an FCB random-record seam — PROVEN

2026-08-15, milestone #10 / **rc7xx-work#7 disk half** (the console-write half
landed as milestone #3). `build-diskio.sh` + `test/disktest.c` run Open Watcom's
**UNCHANGED** buffered FILE\* layer — `fopen`/`fclose`/`fwrite`/`fputs`/`fprintf`/
`fread`/`fgets`/`fgetc`/`fseek`/`ftell`/`remove` — against **real CP/M-86 disk
files** under emu2. Self-checking oracle: 28 `VERIFY`s → `DISKIO: PASS`, purity
`INT21h=0 · BDOS=14`. All 8 build scripts stay green (no regression).

## The one seam: `port/diskio.c`

SUPERSEDES `stdioshim.c` in this build (owns the same console `__qwrite`/`isatty`)
and adds the five low-level primitives `fopen` bottoms out into — `_sopen` /
`__qread` / `__qwrite` / `__close` / `__lseek` — plus `lseek` / `_tell` /
`remove` / `unlink`, all over CP/M-86 **FCB random-record BDOS** (INT 0E0h).

- **Record model does the work.** CP/M has no byte-granular length (128-byte
  records only), so use `READ RANDOM` fn 33 / `WRITE RANDOM` fn 34: `record =
  pos>>7`, `offset = pos&127`. An unwritten record reads back as EOF (BDOS AL=1
  unwritten / 4 past-EOF) → fill the work buffer with `Ctrl-Z` (0x1A); a
  partial last record keeps a `Ctrl-Z` tail on disk = CP/M text-EOF **for free**.
  Text read stops at first `Ctrl-Z`; binary does not (binary length only known to
  nearest 128 B — inherent CP/M limit). SEEK_END rounds up to a sector.
- **DMA:** set BOTH fn 51 SETDMASEG (DX=DS via `mov ax,ds`) and fn 26 SETDMA
  (DX=&dma) before each random op; don't trust the load-time default DMA base.
- **FCB (36 B):** [0]drive(0=default,1=A) [1..8]name [9..11]type [12]ex [13]s1
  [14]s2 [15]rc [16..31]alloc [32]cr [33..35]r0/r1/r2 random record LE. OPEN
  (15)/MAKE (22) return 0xFF on fail; CLOSE 16, DELETE 19, FILESIZE 35.

## Link-closure gotchas (why fseek/ftell/fopen needed extra help)

- **fseek/ftell call the PUBLIC `lseek()`/`_tell()`, NOT `__lseek`.** The stock
  `lseek.c`/`tell.c` drag in the whole per-handle iomode table
  (`__GetIOMode`/`__SetIOMode`/`__handle_check`/`__NFiles`) this minimal seam
  omits, so `diskio.c` provides its OWN thin `lseek`/`_tell` routing straight to
  `__lseek` (`_tell(h)` == `lseek(h,0,SEEK_CUR)`).
- **fopen chain:** `fopen`→`_fsopen`→`__allocfp`+`__doopen`(static in fopen.c)→
  `_sopen`. Link objects: `fopen.obj fclose.obj allocfp.obj freefp.obj`.
  Read path: `fgetc.obj` (has `__filbuf`/`__fill_buffer`→`__qread`) `fgets.obj
  fread.obj feof.obj`. Data globals: `comtflag.obj` (`_commode=0`),
  `textmode.obj` (`_fmode=O_TEXT`).
- **Unreachable TTY-branch stubs** (disk streams never take `fp->_flag&_ISTTY`):
  `fgetc`'s fill calls `__flushall(_ISTTY)` + `getche()`; `fopen` lowercases its
  mode char via `tolower()`. Stubbed in `port/stubs.c` **guarded by
  `-DDISKIO_LSEEK`** so the other builds' `stubs.obj` stays byte-identical.
  `-DDISKIO_LSEEK` also excludes the stub `__lseek` (diskio.c owns the real one).
- **errno:** `stubs.c` owns the `int errno` global; `port/errnoptr.c` supplies
  `__get_errno_ptr()` (=&errno) — link BOTH; do NOT re-define `__get_errno_ptr`
  in stubs.c (duplicate with errnoptr.obj in the owtests/whetstone builds).

## The eventual gold-standard oracle (documented next step)

Watcom ships its own self-checking stream-I/O regression tests — the disk
analogue of `float01–04`: `bld/clibtest/streamio/c/iotest.c` (full FILE\*),
`bld/clibtest/handleio/c/iotest.c` (low-level open/read/write/lseek), and
`bld/clibtest/file/c/filetest.c`. Each needs a few more seam primitives than a
v1 round-trip before it can run byte-for-byte unchanged: streamio/iotest uses
`tmpfile`/`tmpnam`/`fscanf`/`fopen("CON")`; handleio uses `chsize`/`dup`/
`filelength`/`eof`; filetest uses `rename`/`access`/`chmod`/`stat`/`utime`.
`test/disktest.c` is the focused v1 gate; graduating to Watcom's own iotest.c is
the recommended follow-up.
