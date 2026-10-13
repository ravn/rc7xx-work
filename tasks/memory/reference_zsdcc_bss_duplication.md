---
name: reference-zsdcc-bss-duplication
description: zsdcc 4.5 duplicates BSS vars in data_compiler when .h files exist in ucpp cwd — three triggers, one workaround
metadata:
  type: reference
---

**Symptom:** `z80asm: error: duplicate definition: _varname` when building
with `zcc +cpm -clib=sdcc_iy` from a directory containing `.h` files.

**Root cause (verified 2026-10-12, ravn/z88dk#88):**

ucpp uses `-iquote "."` which scans `.h` files in cwd as side-channel
includes. When any `.h` file is present, zsdcc 4.5 + `-SO3` emits global
BSS variables in BOTH `bss_compiler` AND `data_compiler`. z80asm sees the
same symbol twice and rejects.

**Three independent triggers:**

1. **`.h` files in cwd** during link step — ucpp scans them silently.
2. **Explicit `= 0` initializers** on globals: `byte x = 0;` → zsdcc
   emits in `data_compiler` not `bss_compiler`. Remove `= 0` (C spec
   guarantees zero-init for globals; semantically equivalent).
3. **`#pragma constseg <name>`** in C source — causes re-emission of BSS
   after the sentinel section. Guard with `#ifdef __SDCC` and avoid with
   zsdcc 4.5 + `-SO3`.

**Workaround:**

Build in `/tmp` (clean directory). Before the link step that compiles
`rom.c`, move all `.h` files to an `inc/` subdirectory that is not cwd.
Pass the subdir via `-I` flags only for steps that need them.

```makefile
# In zsdcc-prom target:
BDIR=/tmp/zsdcc_build; mkdir -p $$BDIR/inc/sdcc $$BDIR/inc/clang
# ... copy sources to $$BDIR, headers to $$BDIR/inc/ ...
# compile boot_rom.c with -Iinc/sdcc (needs build_stamp.h)
# compile intvec.c with -Iinc
# move rom.h, sdcc/, clang/ into $$BDIR/inc/ before link step
# link rom.c with -Iinc -Iinc/sdcc -Iinc/clang
```

Implemented in `autoload-in-c/Makefile` target `zsdcc-prom` on branch
`work/zsdcc-sccz80-builds-20261012`.

**Status (2026-10-12):** Workaround partially working — BSS duplication
resolved, but `prom0_BOOT.bin` not generated (separate linker-section
issue with `create-app` + multi-section output). WIP.

**Also fixed in z88dk (ravn/z88dk@8a1e181):** `sdcc_opt.1` IF 0/ENDIF
missing ENDIF — separate bug, now fixed. zsdcc 4.5 generates `IF 0` in
`.area _INITIALIZED` output but `ENDIF` was never emitted; z80asm aborted
with "unbalanced control structure".

Related: `[[reference_z88dk_triple_tradeoffs]]`, ravn/z88dk#88.
