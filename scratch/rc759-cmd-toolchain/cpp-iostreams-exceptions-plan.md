# Plan: enable C++ iostreams + exceptions on native cpm86 (Watcom `wcl -l=cpm86`)

Status baseline (2026-08-15): native Watcom C++ on cpm86 already works for
classes, templates, virtuals, `new`/`delete`, and global ctors/dtors (see
`tasks/memory/reference_watcom_cpp_cpm86.md`). The two remaining standard-C++
features are **iostreams** and **exceptions**. Both are *officially supported*
16-bit-DOS Watcom features — the libraries exist prebuilt for `generic.086` (all
5 memory models); only the cpm86 *setup/seams* are missing.

## VERIFIED 2026-08-15 (build-tree audit — corrects the "Key facts" below)
Audited the from-scratch OW build tree; three premises changed, net = *cheaper*:

1. **iostream is NOT prebuilt for the DOS/cpm86 target.** The only prebuilt
   16-bit iostream `.lib`s are under `iostream/windows.086/` (`iosts/iosxs.lib`).
   There is NO `generic.086` iostream `.lib`. (The earlier note claiming "generic.086,
   all 5 models" and the `runxs/strxs/conxs.lib` names were wrong — `conxs.lib`
   is the *containers* lib under `contain/`, not console.)
2. **But the generic.086/ms iostream OBJECTS are already compiled** by the
   from-scratch build: `iostream/generic.086/ms/*.obj` (no-EH) **and**
   `iostream/generic.086/ms/xobjs/*.obj` (EH) — 2175 objs total. So we do NOT
   port or recompile iostream; we just **archive** the right obj set into a lib
   with `wlib`, exactly like `cpm86-clib/build-clib.sh` builds `clibs.lib`.
3. **The base runtimes ARE prebuilt for generic.086/ms:** `plibs.lib` (no-EH,
   used today) and `plbxs.lib` (**EH**) both present. `plbxs.lib` references
   `__wint_thread_data` (confirmed via strings) → that seam is real for `-xs`.
4. **The fd seam symbol is `write` (mangled `write_` in flfoverf.obj)**, matching
   the clib POSIX `_write` in `dos/h/io.h`. Provide `write`/`read` in cpm86 clib.

Net effect: Track A shrinks to "archive an existing obj set + add a `write` shim
+ include path". No iostream source porting.

## What already exists (no porting needed)
- Compiler: `wpp` (16-bit C++), links via `wlink FORMAT CPM86`.
- Headers: `<OW>/bld/hdr/dos/h/` has `iostream`, `iostream.h`, `iomanip`,
  `setjmp.h`, `stdlib.h`, … — just need to be on the include path.
- Libraries / objects (`generic.086/ms`, small model):
  - `plibs.lib` (base rt, no-EH) — already used today. `plbxs.lib` (base rt, **EH**).
  - iostream: compiled OBJs present (`iostream/generic.086/ms/*.obj` no-EH,
    `.../xobjs/*.obj` EH) — archive to `iost_s.lib` / `iosx_s.lib` ourselves.

## Track A — iostreams (cout/cin/cerr), no exceptions
1. **Include path**: stage `bld/hdr/dos/h` as `$WATCOM/h` (or pass `-i=`), so
   `#include <iostream>` resolves.
2. **Link `iosts.lib`** (small, no-EH) after the user objects; it pulls
   streambuf/ostream/istream from the iostream lib and base rt from `plibs.lib`.
3. **The one real seam — POSIX fd-level `write`/`read`**: `filebuf::overflow`
   bottoms out at `::write( fd(), buf, len )` (bld/cpplib/iostream/cpp/flfoverf.cpp;
   `read` symmetrically). cpm86 has no fd layer, so provide a minimal fd shim in
   the cpm86 clib:
   - `int write(int fd, const void *buf, unsigned len)` → fd 1/2 (stdout/stderr)
     → BDOS C_WRITE per byte (reuse `_conout_`); translate `\n`→`\r\n` if we want
     TTY semantics (or leave raw and let ostream `endl` emit `\n`; decide once).
   - `int read(int fd, void *buf, unsigned len)` → fd 0 → BDOS console input
     (C_READ / RAWIO) for cin; can stub to 0 (EOF) initially if input not needed.
   - `int isatty(int fd)`, `long lseek(...)`, `int close(int)` → console stubs.
   - Provide the standard `fd()` of the predefined streams = 0/1/2 (the iostream
     lib's static `cout/cin/cerr` init should already bind fd 1/0/2).
4. **Static-init**: cout/cin/cerr are global objects → their ctors run via our
   already-working XI walk. Confirm the iostream lib's init object is in XI.
5. Test: `#include <iostream>` … `std::cout << "hi" << N << std::endl;` → expect
   the text on the RC759 console (emu2 first, then MAME).

## Track B — exceptions (`-xs`)
1. **Compile `-xs`** and link the **EH library variants**: `plbxs.lib` +
   (if iostreams) `iosxs.lib` + `runxs.lib` + `strxs.lib` + `conxs.lib`. (Mixing
   `-x` and non-`-x` objects is unsupported — pick one per program.)
2. **Missing clib seams** (from the earlier `-xs` link failure):
   - `_setjmp_` / `longjmp` — 16-bit setjmp/longjmp. Source is in Watcom's clib
     (per-CPU asm); assemble it standalone into the cpm86 clib, or hand-write the
     ~15-instruction 8086 small-model setjmp/longjmp (save/restore
     BX,CX,DX,SI,DI,BP,SP,CS?,DS,ES,flags + return addr).
   - `__wint_thread_data` — the per-thread runtime data block (errno, EH chain).
     Single-threaded cpm86 → provide one static block + the accessor Watcom
     expects (`__wint_thread_data` symbol / `__initthread`). Confirm exact shape
     from `bld/clib` thread-data source.
   - `__wcpp_4_fs_handler_rtn__`, `__wcpp_4_throw__`, `__wcpp_4_catch_done__` —
     these come from `plbxs.lib` once linked (were undefined only because the
     no-EH `plibs.lib` was used); no new code.
3. **crt0**: EH may need the fs-root/handler established at startup — already
   registered as an XI entry (`___wcpp_4_data_init_fs_root_`) which our XI walk
   now runs. Verify no extra startup hook is required for `-xs`.
4. Test: `try { throw 5; } catch(int e){ … }` → expect "caught 5"; then a throw
   across a function boundary + an object with a dtor (stack unwinding runs it).

## Deliverables / order (verified concrete steps)
0. **Baseline first** (AGENTS.md): confirm the current C++ subset still links —
   `wcc-cpm86.sh` path with a `.cpp` + `plibs.lib` — and run one known-good
   ctor/dtor test under emu2 so we have a "before" endpoint before touching libs.
1. **Archive the iostream libs** (new step in `cpm86-clib/`, mirror
   `build-clib.sh`): `wlib -q -b -n iost_s.lib +iostream/generic.086/ms/*.obj`
   (no-EH) and `iosx_s.lib` from `.../xobjs/*.obj` (EH). Sanity-check for any
   Windows-only externals with `wlib -l` / undefined-symbol scan before trusting.
2. **fd shim in cpm86 clib** (`cpm86-clib/`, add to `build-clib.sh` obj set):
   `int write(int fd, const void *buf, unsigned len)` → fd 1/2 → BDOS C_WRITE
   per byte (reuse `_conout`); `int read(int fd, void *buf, unsigned len)` → fd 0
   → BDOS console in (stub to 0/EOF initially); `isatty`/`lseek`/`close` console
   stubs. Match the clib name (`_write`/`write_` — confirm which the objs import).
3. **Driver**: add a C++/iostreams mode to `wcc-cpm86.sh` (or a `wpp-cpm86.sh`):
   stage `bld/hdr/dos/h` on `-i`, compile with `wpp`, and select the lib set:
   no-EH = `iost_s.lib + plibs.lib + clibs.lib`; EH (`-xs`) =
   `iosx_s.lib + plbxs.lib + clibs.lib` + the setjmp/`__wint_thread_data` seams.
4. **Verify Track A** (iostreams, needs only steps 1-3 no-EH):
   `std::cout << "hi" << N << std::endl;` → text on RC759 console. emu2 first,
   then MAME rc759. Confirm cout/cin/cerr ctors run via the existing XI walk.
5. **Track B** (exceptions, `-xs`): add `_setjmp_`/`longjmp` (hand-write the
   ~15-instr 8086 small-model version or assemble Watcom's) + a single static
   `__wint_thread_data` block/accessor. `__wcpp_4_throw__/catch_done__/fs_handler`
   come from `plbxs.lib` (already present). Test `try/throw/catch` + a dtor across
   an unwind. emu2 → MAME.

**Test discipline (AGENTS.md):** each Track ships a failing-first runtime oracle
(emu2 expected-output check) committed before the fix, plus MAME rc759 as the
authoritative second oracle. "Builds/links" is NOT "works" for either track.

## Open questions to resolve during implementation
- Exact `__wint_thread_data` layout/accessor for 16-bit (single-thread stub).
- Whether the predefined `cout/cin/cerr` fd binding needs any init beyond linking
  `iosts.lib` (does the lib self-register fds 0/1/2, or does startup?).
- `\n`→`\r\n` translation policy for the fd `write` (TTY vs raw).
- Memory-model headroom: iostreams pulls a lot — small model 64 KB may force
  large model (`-ml` + `plibl/iostl.lib`), which needs FORMAT CPM86 large-model
  support (currently phase-1 small-only).
