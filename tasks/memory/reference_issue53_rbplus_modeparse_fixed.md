# ravn/z88dk#53 — fopen "rb+" mode-parse: FIXED

**Status (2026-08-11): FIXED + regression-tested + CLOSED (completed).**

Bug: classic stdio `_freopen1.c` parsed the fopen mode string *positionally* and
only accepted `+` in the single slot right after the primary letter. So `"rb+"`
(b before +) never applied `O_RDWR` and silently opened read-only — `fwrite`
returned 0. `"r+b"` worked. Shared classic stdio → affected sccz80, SDCC, and
llvmz80 identically.

Fix (`libsrc/classic/stdio/_freopen1.c`): scan the remaining mode chars for `+`
(update) and `b` (binary) regardless of order; apply `+` before `b` so the
O_RDWR branch's `flags = _IOREAD|_IOWRITE|_IOTEXT` assignment does not clobber
the binary `flags ^= _IOTEXT` toggle. Landed on `master` merge `68e18d08db`
(fix commit `4658ca9c4a`).

Regression test: `test/clang/runtime_fileio_rbplus.{c,sh}`. **ABSOLUTE-assertion**
(asserts writes return 128), deliberately NOT an sccz80/llvmz80 oracle
comparison — both toolchains shared the bug, so a toolchain-diff test would have
PASSED on buggy code. Verified test FAILS pre-fix (rbplus=0) and PASSES post-fix
(rbplus=128) on both toolchains. Suite: **63 PASS / 0 FAIL / 2 SKIP / 1 XFAIL**.

## How to rebuild the classic clib after editing libsrc/classic/**
`.lib` files in `lib/clibs/` are gitignored build artifacts (only sources are
tracked). `make -C libsrc` (full) rebuilds ALL machine targets and is very slow
(>30 min, silent). Targeted + fast: `touch` the changed source, then
`make -C libsrc cpm_clib.lib cpmixiy_clib.lib` (staging → `libsrc/*.lib`), then
`cp libsrc/cpm_clib.lib libsrc/cpmixiy_clib.lib lib/clibs/`. `zcc +cpm` default
clib links `lib/clibs/cpm_clib.lib` for BOTH sccz80 and llvmz80 (classic).

## Known-adjacent, NOT fixed
`"a+"` still drops `O_APPEND` when upgrading to O_RDWR (pre-existing; unchanged).
Noted in the #53 close comment; not filed as a separate issue.
