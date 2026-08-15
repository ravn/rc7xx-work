# Plan: enable C++ iostreams + exceptions on native cpm86 (Watcom `wcl -l=cpm86`)

Status baseline (2026-08-15): native Watcom C++ on cpm86 already works for
classes, templates, virtuals, `new`/`delete`, and global ctors/dtors (see
`tasks/memory/reference_watcom_cpp_cpm86.md`). The two remaining standard-C++
features are **iostreams** and **exceptions**. Both are *officially supported*
16-bit-DOS Watcom features — the libraries exist prebuilt for `generic.086` (all
5 memory models); only the cpm86 *setup/seams* are missing.

## What already exists (no porting needed)
- Compiler: `wpp` (16-bit C++), links via `wlink FORMAT CPM86`.
- Headers: `<OW>/bld/hdr/dos/h/` has `iostream`, `iostream.h`, `iomanip`,
  `setjmp.h`, `stdlib.h`, … — just need to be on the include path.
- Libraries (`generic.086/ms`, small model):
  - `plibs.lib` (base rt, no-EH) — already used today.
  - `iosts.lib` (iostreams, no-EH) / `iosxs.lib` (iostreams, **EH**).
  - `plbxs.lib` (base rt, **EH**), `runxs.lib`, `strxs.lib`, `conxs.lib` (EH variants).

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

## Deliverables / order
1. Add the fd shim (`write`/`read`/`isatty`/`lseek`/`close`) + setjmp/longjmp +
   `__wint_thread_data` to the cpm86 clib (`cpm86-clib/`, via `build-clib.sh`).
2. Extend `wcc-cpm86.sh` (or a variant) to: stage `h/` include dir, and select
   the EH vs no-EH library set based on a flag, auto-adding `iosts/iosxs.lib`.
3. Verify Track A (iostreams) first (only needs the fd shim), then Track B
   (exceptions). emu2 as the fast oracle, MAME rc759 as the authoritative check.

## Open questions to resolve during implementation
- Exact `__wint_thread_data` layout/accessor for 16-bit (single-thread stub).
- Whether the predefined `cout/cin/cerr` fd binding needs any init beyond linking
  `iosts.lib` (does the lib self-register fds 0/1/2, or does startup?).
- `\n`→`\r\n` translation policy for the fd `write` (TTY vs raw).
- Memory-model headroom: iostreams pulls a lot — small model 64 KB may force
  large model (`-ml` + `plibl/iostl.lib`), which needs FORMAT CPM86 large-model
  support (currently phase-1 small-only).
