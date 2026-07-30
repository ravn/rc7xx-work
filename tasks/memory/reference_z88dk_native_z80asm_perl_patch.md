---
name: reference_z88dk_native_z80asm_perl_patch
description: Native macOS z88dk-fork z80asm rebuild needs a 1-line make_lib_list.pl patch (Modern::Perl -> feature 'say'); after upstream merges rebuild z80asm THEN cpm libs
metadata:
  type: reference
---

Rebuilding the **dev-fork z88dk** (`/Users/ravn/z80/z88dk`) z80asm natively on
macOS trips on a missing Perl module:

- `src/z80asm/dev/z80asm_lib/make_lib_list.pl` does `use Modern::Perl;` purely
  for `say` (12-line file-list generator for the z80asm runtime helper lib).
  System perl 5.34 lacks Modern::Perl and it's not vendored. Fix carried on our
  fork: `use feature 'say';` (commit on master 2026-07-28, `64f43a9805`). The
  assembler C code itself needs no Perl. If a clean build re-fails here, or a
  future upstream merge reverts the line, re-apply that one-liner.
- Gotcha: a failed run leaves an **empty** `z88dk-z80asm_lib.lst` (shell
  `> file` redirect fires before the perl error); make then won't regenerate it
  and z80asm errors "source file expected". `rm` the stale `.lst` before rebuild.

Rebuild sequence that works (native, no Docker, no zsdcc):
1. `make -C src/z80asm PREFIX=$PWD PREFIX_SHARE=$PWD install`  (rebuilds+installs
   z80asm to bin/). The top-level `make bin/z88dk-z80asm` does NOT recompile
   (rule only depends on src/config.h) — call the sub-make.
2. `./build.sh -b -p cpm`  (skip binaries, build+install cpm libs to the new
   `lib/clibs/` paths). Needed after any upstream merge that moved libs, e.g. the
   newlib +cpm migration (#3023/#3025) — the new `cpm_01_file.asm` file driver
   only assembles under the rebuilt z80asm.

Verify: `test/clang/run_all.sh` (classic) and `TEST_CLIB=newlib_iy .../run_all.sh`
with LLVMZ80EXE + NTVCM set. Baseline 2026-07-28: classic 25 PASS / newlib_iy
24 PASS. See [[reference_z88dk_runtime_verify_ntvcm]],
[[reference_z88dk_direction_classic_not_newlib]].
