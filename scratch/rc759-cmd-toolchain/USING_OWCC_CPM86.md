# Using the production Open Watcom CP/M-86 toolchain (`owcc -bcpm86`) on macOS

This is the how-to for building, running and validating CP/M-86 `.CMD` programs
with the Open Watcom fork in this workspace. The macOS (arm64) release lives in
`open-watcom-v2/rel/`; the CP/M-86 target is **first-class** (`-bt=cpm86`).

Background / design: `tasks/memory/reference_cpm86_vs_msdos_model.md`.
Build / re-stage recipe: `tasks/memory/reference_watcom_submodule_build_apple_silicon.md`.
Linker `format cpm86` details: `tasks/memory/reference_watcom_wlink_cpm86_format.md`.

## 1. Activate the toolchain

```sh
source scratch/cpm86-tools/ow-macos-env.sh
```

This sets `WATCOM=…/open-watcom-v2/rel`, prepends `rel/armo64` (Mach-O arm64 host
tools) to `PATH`, and points `INCLUDE` at `rel/h`. (`scratch/cpm86-tools/` holds the
per-machine, gitignored toolchain: the env script and the `emu2` emulator.) Layout:

| What | Where |
|------|-------|
| host tools (owcc, wcc, wlink, wlib, wdis …) | `$WATCOM/armo64/` |
| CP/M-86 target runtime | `$WATCOM/lib286/cpm86/{clibs.lib, cstartcpm.obj}` |
| headers | `$WATCOM/h` |

`rel/` is regenerable, gitignored, per-machine build output — not committed.

## 2. Build a CP/M-86 program (recommended: the `owcc` driver)

```sh
owcc -bcpm86 -mcmodel=s -O2 -o HELLO.CMD hello.c
```

- `-bcpm86` selects the CP/M-86 system (via `specs.owc`): compiles `-bt=cpm86`
  **and** links `wlink format cpm86` with the `_cpm` runtime — one command.
- `-mcmodel=s` = small model (separate code/data groups; pairs with the compiler's
  `-ms`). Use `-mcmodel=t` for a single-group `.COM`-like image.
- `-O2` optimises. Standard C library (stdio, string, stdlib, malloc, …) is linked
  automatically from `clibs.lib`.

### Distinguishing CP/M-86 in source

`-bt=cpm86` predefines **`__CPM86__`** *and* the DOS family `__DOS__`/`_DOS`/`MSDOS`
(CP/M-86 is a DOS-family target — same 8086 codegen; it differs only in runtime and
`.CMD` format). So:

```c
#ifdef __CPM86__
    /* CP/M-86-specific path (e.g. BDOS INT 0E0h) */
#endif
```

`-bt=dos` does **not** define `__CPM86__`, so the guard cleanly separates the two.

### Manual two-step (advanced / when you need custom link control)

```sh
wcc foo.c -bt=cpm86 -0 -ms -s -zq -i="$WATCOM/h" -fo=foo.o
wlink format cpm86 option quiet name FOO.CMD \
      file "$WATCOM/lib286/cpm86/cstartcpm.obj" \
      file foo.o library "$WATCOM/lib286/cpm86/clibs.lib"
```

A valid CP/M-86 `.CMD` starts with a group-descriptor header byte `0x01`
(type-1 code group).

## 3. Run it

```sh
scratch/cpm86-tools/emu2-cpm86/emu2 HELLO.CMD      # fast arm64 CP/M-86 emulator
```

emu2 is the quick oracle; real hardware/MAME (RC759) is the final check for
production firmware.

## 4. Validate the production build

After any rebuild/re-stage of the compiler, run the end-to-end validator:

```sh
./scratch/rc759-cmd-toolchain/validate-cpm86-build.sh
```

It checks: host tools + emu2 present; the compiler macro gate (`__CPM86__`
+ DOS family under `-bt=cpm86`, and its absence under `-bt=dos`, via
`test_cpm86_target.c`); and a full `owcc -bcpm86` → clib → `wlink format cpm86`
build of `validate_prog.c` (fixed marker) and `mandel_watcom.c` (rendering) run
on emu2. Prints `RESULT: PASS`/`FAIL` and exits non-zero on any failure.

Last validated 2026-08-18: **PASS** (8/8 checks) against the release-staged
`rel/armo64/wcc` carrying the first-class `-bt=cpm86` patch.

## 5. Rebuild the compiler after a source change

If you patch the compiler (e.g. `bld/cc/c/cmdlnx86.c`), rebuild + officially
re-stage just `wcc` (no full build needed), then re-validate:

```sh
cd open-watcom-v2
export OWROOT="$(pwd)" OWTOOLS=CLANG OWNOWGML=1 OWDOCBUILD=0
. ./cmnvars.sh
cd bld/cc/i86 && builder build && builder rel      # cprel -> rel/armo64/wcc
cd "$OWROOT"
# builder rel re-creates foreign host dirs; re-prune to stay macOS-only:
( cd rel && rm -rf binl binl64 binnt binnt64 binp binw binb64 bino64 armb64 arml64 armo nlm rdos )
cd .. && ./scratch/rc759-cmd-toolchain/validate-cpm86-build.sh
```

Note: the `wcc` banner date (e.g. "Version 2.0 beta Aug 16 …") is a stale
bootstrap version-stamp, not the compile time — confirm a change took effect via
behaviour (the validator), not the banner.
