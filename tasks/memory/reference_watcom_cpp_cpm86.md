---
name: Watcom C++ to CP/M-86 — freestanding subset works today; iostreams/exceptions need porting
description: Empirical assessment (emu2-verified 2026-08-15) of how much C++ Watcom compiles to CP/M-86 via the native cpm86 target.
metadata:
  type: reference
---

**Assessment (5 emu2-verified tests, 2026-08-15):** Watcom's 16-bit C++ frontend
`wpp` (bld/plusplus/i86/osxa64/wpp.exe) compiles C++ to CP/M-86 with NO errors,
and `wlink FORMAT CPM86` links it — the ONLY missing piece for a large subset is
the C++ runtime, which **already exists prebuilt for 8086**:
`bld/cpplib/library/generic.086/ms/plibs.lib`. Drop that on the cpm86 libpath
(`$WATCOM/lib286/cpm86/plibs.lib`) and it links. Build via `wcl -l=cpm86 x.cpp`
(same env as `[[reference_watcom_wlink_cpm86_format]]`; add a `wpp` PATH symlink).

Boundary map:
- **WORKS today** (plibs.lib on libpath): classes, methods, virtuals/vtables,
  **templates**, `operator new`/`delete` (runs over our clib malloc/free), local
  objects. (Tests: `Counter` local → n=3; `Box<int>` new/delete → r=42.)
- **Global/static object constructors: FIXED 2026-08-15.** Previously a global
  `G g; g.v` came back 0 — the ctor never ran because the crt0 didn't walk the
  C++ static-init (XI) table. Fixed in `wlink-cmd-test/crt0sm.asm` (→ cstartcpm.obj):
  the compiler places each global ctor's 6-byte `rt_init` record (type/priority/
  near-rtn/pad) into segment **XI** ('DATA'), bracketed by XIB/XIE. crt0 now
  defines the XIB/XI/XIE(+YIB/YI/YIE) brackets in DGROUP and a small `__init_rtns`
  that replicates Watcom `__InitRtns(255)` — runs every XI entry in ascending-
  priority order before `main` (no-op when XI empty, so pure-C is unaffected).
  Verified: `G g`→v=77; 7 globals with an order-dependent ctor → total=60,
  counter=4.
- **Global destructors: FIXED 2026-08-15 too.** crt0 now also runs `__fini_rtns`
  after main (replicates `__FiniRtns(0,255)` — walks YI in DESCENDING priority =
  reverse of ctors = LIFO). The dtor-registration path pulls `__clib_fatal` from
  plibs.lib, so a terminating stub was added to the cpm86 clib (`stdlib.c`).
  Verified: ctors first/second, main, dtors second/first. The cpm86 clib is now
  rebuilt reproducibly by `cpm86-clib/build-clib.sh` (wcc .c→.o + wlib archive;
  headers from `<OW>/bld/hdr/dos/h`), not a hand-made artifact.
- **iostreams + exceptions: DONE 2026-08-15 (emu2-verified), issue #9.** Both work
  on the native cpm86 target. **Consolidated onto the Open Watcom clib port under
  issue #12 (MAME rc759-verified: cppfeat 8/0, mame_cpptest 6/0):** the layer now
  builds with `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/build-cpp.sh`
  (`--eh` selects the exception lib set), NOT the retired scratch driver. The
  scratch mini-clib + `wpp-cpm86.sh`/`wcc-cpm86.sh` were removed (breadcrumb:
  `scratch/rc759-cmd-toolchain/CLIB_RETIRED.md`); seams now live in the port as
  `port/crt0cpp.asm` (XI/YI ctor/dtor walk), `port/cpprt.c` (`__clib_malloc`/
  `__clib_free`), `port/ehsupp.c` (near `__longjmp_handler`, overlay-stack nulls,
  `__clib_exit`/`__clib_fatal`). Everything else (`__get_std_stream` via the
  __iob FILE layer, `ltoa`/`ultoa`, `strupr` aliased `strupr_=_strupr_`, buffered
  flush) is genuine unchanged Watcom clib. Key findings (original, on scratch):
  - iostream is NOT prebuilt for generic.086 (only windows.086), but the
    from-scratch OW build compiled the generic.086/ms iostream OBJECTS
    (`iostream/generic.086/ms/*.obj` no-EH, `.../xobjs/*.obj` EH) — just archive
    them (`cpm86-clib/build-ioslibs.sh` → iost_s.lib / iosx_s.lib), no porting.
  - No raw fd write/read shim needed: cout/cin/cerr route through the __iob FILE
    layer. The only iostream seams (in `cpm86-clib/cpprt.c`): `__get_std_stream`
    → &__iob[h]; `__clib_flush` no-op; `__clib_malloc/free` → heap;
    `ltoa/ultoa/strupr`.
  - Exceptions (`-xs`) link `iosx_s.lib`+`plbxs.lib`; `__wint_thread_data`/
    `__wcpp_4_throw__/catch_done__` come from plbxs.lib. Missing clib seams
    (`cpm86-clib/ehsupp.c` + `setjmp86.obj` from Watcom's stjmp086.asm assembled
    `-d__SMALL__`): `_setjmp_/longjmp_`, `___longjmp_handler`,
    `__get_ovl_stack/__restore_ovl_stack` (null), `__clib_exit`.
  - PITFALL: `__longjmp_handler` is a NEAR fn pointer w/ arg convention
    `[__ax __dx]` (ljmphdl.h), NOT far. A __far no-op `retf`s against longjmp's
    near `call`, unbalancing the stack → plain C setjmp/longjmp silently breaks
    while C++ EH still works (EH's ljmpinit replaces the handler). A direct
    setjmp/longjmp test catches it; the EH test masks it.

**16-bit DOS C++ is OFFICIALLY supported by Open Watcom** (verified 2026-08-15) —
so cpm86 C++ inherits a mature, maintained runtime, not an experiment:
- `wpp` = the C++ compiler "for 16-bit Intel platforms" (docs cpwcc.gml); docs:
  "compilers support both 16-bit and 32-bit application development"; `MSDOS`
  macro defined for "16-bit DOS" target.
- The official release installs the FULL 16-bit C++ runtime into `lib286/` from
  `generic.086`, all 5 memory models (s/c/m/l/h): `plib{s,c,m,l,h}.lib` (runtime),
  `plbx{s,c,m,l,h}.lib` (**exception-handling** variants), `cplx*.lib` (complex).
  iostream headers ship too (`bld/hdr/dos/h/iostream`, `iostream.h`, `iomanip`).
- This is the SAME `generic.086` lib borrowed for cpm86. So the earlier iostreams
  and exception "failures" were MISSING SETUP, not missing support: `<iostream>`
  failed only because no `h/` include path was staged; `-xs` failed only because
  `plbxs.lib`+`setjmp` weren't installed on the cpm86 side. Both could work on
  cpm86 by copying the official DOS 16-bit headers/libs + a console/setjmp seam.
- Caveat: it is Watcom's OWN older C++ dialect (~early/mid-90s: partial templates,
  own class/iostream lib, NOT modern C++/STL).

Structural limit: ONLY small model (-ms) works right now (user-confirmed
2026-08-16: "large virker ikke lige nu på cp/m-86"). Small model = 64 KB code +
64 KB data → ~128 KB total program ceiling, of which ~100 KB is free after the
fixed runtime. LARGE/compact model does NOT currently work, so the full RC759
TPA (~293 KB reported on-screen) is NOT reachable; do not propose -ml as a
working build path until phase-2 wlink support lands.

Verified CMD sizes (segment descriptors from the CMD header, 2026-08-16):
plain-C setjmp test 11.4 KB; iostreams 15.6 KB; full C++ (cppfeat: polymorphism
+ templates + operator<< + EH) 25.3 KB (12.5 KB code + 12.6 KB data). The bulk
is FIXED C++/iostream/EH runtime overhead (~13 KB over the ~11 KB C baseline);
app logic itself is a few hundred bytes, so a much larger program grows the
image only by its own added code, well within the 64 KB/segment small-model
wall. So "freestanding/embedded C++" (classes/templates/virtuals/new-delete) is
usable now; full standard C++ is a larger runtime-port effort like the clib
retarget was.

**Large memory model (DR C) — TO ANALYSE LATER (deferred task, not #12).** For the
large memory model, DR C supports multiple code segments plus a heap that fills
the rest of the TPA. Details: the DR C manual §2.4.2 (multi-code-segment large
model) and `test.c` in §2.5. Action when unblocked: once a `.cmd` with multiple
code segments has actually been produced, disassemble/analyse its segment layout
to understand how the multiple code segments + TPA-filling heap are arranged.
This is a path toward reaching the full RC759 TPA (~293 KB) that the small-model
64 KB/segment wall cannot. Not part of the #12 clib consolidation.
