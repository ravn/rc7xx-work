# z88dk clang-clib runtime verification: use ntvcm, not z88dk-ticks

**Runner:** a prebuilt CP/M 2.2 emulator lives in the workspace at
`ntvcm/ntvcm` (git submodule; source `ntvcm/ntvcm.cxx`). Run a `+cpm` program
with `ntvcm/ntvcm FOO.COM`. The `test/clang/*.sh` red-green harnesses take it
via the `NTVCM` env var (they SKIP, exit 0, when it's not found).

**Why not z88dk-ticks:** `z88dk-ticks` does NOT emulate the `+test` target's
console trap. `+test` console output goes through `SYSCALL` in
`lib/target/test/classic/test_crt0.asm:95`, which emits `defb $ED,$FE`
(`CMD_PRINTCHAR`). Verified this session: a trivial `printf("HELLO42\n")`
built `+test -compiler=llvmz80` and run under `z88dk-ticks` (plain, `-trace`,
`-iochar N`) produced NO stdout and exit 0. So `-iochar`/port capture is a
dead end for `+test`; ticks is only good for cycle counts / memory, not
console. For console-output red-green, build `+cpm` and run under `ntvcm`.

**`+test` vs `+cpm` link the SAME classic clib** (same `libsrc/`, same
`calloc_callee`/`__calloc.asm`/`malloc-classic`), differing only in crt0 +
I/O layer — so link-symbol proofs are equivalent, but only `+cpm`+ntvcm
gives runnable console output here (ntvcm is present; no other emulator is).

**Idiomatic test home:** `z88dk/test/clang/` (e.g. `runtime_stdlib.c/.sh`,
`runtime_mem.c/.sh`) — the clang-ABI regression suite for the
`zcc -compiler=llvmz80` + z88dk clib path. Add new clib-ABI red-green tests
there.
