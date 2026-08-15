# Scratch mini-clib retired (issue #12)

The hand-written scratch C library and its two build drivers were removed on
2026-08 as part of issue #12 ("one clib"):

- `cpm86-clib/`      — hand-written mini-clib (cpmio.c, printf.c, fileio.c,
                       stdlib.c, string.c, cpprt.c, ehsupp.c, cstartcpm.obj, ...)
- `wpp-cpm86.sh`     — C++ driver that linked against the mini-clib
- `wcc-cpm86.sh`     — C driver that linked against the mini-clib

Everything they provided now lives in the canonical Open Watcom port:

    open-watcom-v2/contrib/ravn/watcom-cpm86-libc/

That port uses the REAL Watcom C runtime library and adds the CP/M-86 OS seams.
The C++ layer (iostreams + exceptions + setjmp) was rebased onto it and is
MAME rc759-verified (cppfeat 8/0, mame_cpptest 6/0):

    open-watcom-v2/contrib/ravn/watcom-cpm86-libc/build-cpp.sh
    open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/crt0cpp.asm  (XI/YI ctor/dtor walk)
    open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/cpprt.c      (__clib_malloc/free)
    open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/ehsupp.c     (EH/longjmp OS seams)

The MAME verification harness under `mame-tests/` is retained — it is generic
(installs a prebuilt CMD and boots MAME) and is used to verify the contrib port.

To recover the removed files: `git log --diff-filter=D -- scratch/rc759-cmd-toolchain/cpm86-clib`.
