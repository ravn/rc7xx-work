---
name: Reproducible full build of the root Open Watcom submodule on Apple Silicon (CLANG)
description: Verified 2026-08-16 recipe to clean-build the entire ravn/open-watcom-v2-ccpm86 submodule toolchain (wcc/wpp/wasm/wlink/wcl/wdis/wlib) natively on an Apple M4, replacing the old two-tree (submodule + scratch) setup.
metadata:
  type: reference
---

**Fact (verified 2026-08-16 on Apple M4):** the whole Open Watcom toolchain
builds cleanly *inside the submodule* `open-watcom-v2` (ravn/open-watcom-v2-ccpm86)
with `OWTOOLS=CLANG`. This retires the old friction where a separate
`scratch/open-watcom-v2` tree was kept because the submodule "couldn't build" —
it can; the earlier failures were config (GCC alias) + a fatal DOSBOX/WGML doc
step, not a real toolchain problem. Prefer a single tree (the submodule).

**Reproducible recipe (this host):**
```
export OWROOT=/Users/ravn/z80/open-watcom-v2   # or /home/ravn/z80/... on sonnyboy
export OWTOOLS=CLANG        # NOT GCC — Apple `gcc` is a clang v4 alias that fails
export OWOBJDIR=binbuild
export OWNOWGML=1           # skip WGML/DOSBOX doc+help build (else FATAL at browser)
export OWDOCBUILD=0
cd "$OWROOT"; . ./cmnvars.sh
sh ./clean.sh && sh ./build.sh
```

**Key gotchas (each cost time 2026-08-16):**
- **`OWNOWGML=1` is mandatory headless.** Without it, `build.sh` aborts FATALLY
  (not skipped) at `bld/browser/nt386` building `docs/nt/wbrw.gh` via `wgml`,
  which needs DOSBOX → `Error(E33) Missing DOSBOX configuration`. `OWDOCBUILD=0`
  alone does NOT skip it. `build.sh` is incremental, so if it dies there you can
  just re-export `OWNOWGML=1` and re-run `build.sh` — it resumes past browser and
  finishes the remaining tools (`plusplus`, `wasm`, `wl`, `wcl`, `posix`).
- **Output-path layout differs per tool** (this made tools look "missing"):
  only `wcc`/`wcc386`/`wdis` land under an `osxa64/binbuild/` subdir; everything
  else lands directly in `osxa64/`:
  - `bld/cc/i86/osxa64/binbuild/wcc.exe`, `bld/cc/386/osxa64/binbuild/wcc386.exe`
  - `bld/ndisasm/osxa64/wdis.exe`
  - `bld/plusplus/i86/osxa64/wpp.exe`, `bld/plusplus/386/osxa64/wpp386.exe`
  - `bld/wasm/osxa64/wasm.exe`
  - `bld/wl/osxa64/wlink.exe`  (carries the `CPM86` FORMAT — CP/M-86 .CMD writer)
  - `bld/wcl/i86/osxa64/wcl.exe`, `bld/wcl/386/osxa64/wcl386.exe`
  - `bld/nwlib/osxa64/wlib.exe`  (the librarian is `nwlib`, not `wlib`)
- **clibext ordering did NOT recur** under the clean CLANG build:
  `bld/watcom/osxa64/clibext.lib` + `clibexts.lib` are produced automatically; the
  old "copy from binbuild/" workaround (issue #11 point 3) was a GCC/partial-tree
  artifact, not needed here.
- **Timing:** cold full build ≈ 40 min compute on an M4 (`clean` ~45 s; first
  `build.sh` ~40 min to the browser abort; incremental resume ~2 min).

**Compile/disasm one file (smoke test):**
```
$OWROOT/bld/cc/i86/osxa64/binbuild/wcc.exe -bt=dos -0 -ms -s -i=$OWROOT/bld/watcom/h f.c -fo=f.o
$OWROOT/bld/ndisasm/osxa64/wdis.exe -a f.o
```

Tracking issue: ravn/rc7xx-work#11 (build friction, now resolved). Related build
of the CP/M-86 wlink writer: `reference_watcom_wlink_cpm86_format.md`.

## macOS release install (`rel/`) — for local cpm86 testing (verified 2026-08-18)

`build.sh rel` (the `rel` stage; `build.sh` alone only COMPILES) stages a release
install under `$OWROOT/rel/`. **On macOS the macOS host tools land in `rel/armo64/`**
(Mach-O arm64: wcc, wcc386, wpp, wasm, wlink, wlib, wcl, owcc, wdis — cprel renames
the `osxa64` build dir to `armo64` in the install). The cpm86 TARGET runtime is
`rel/lib286/cpm86/{clibs.lib, cstartcpm.obj}`; headers in `rel/h`.

**Watcom cross-builds ALL host OSes in one pass** (its bootstrapped `wlink` emits
PE/LX/ELF/Mach-O), so a plain `rel` also fills `rel/binl` (ELF Linux), `rel/binnt`
(PE Windows), `rel/binp` (LX OS/2), `rel/binw` (NE Win3.x), `rel/nlm`, `rel/rdos`.
These are NORMAL byproducts, not stray/Docker artifacts — the same macbook build
minute produces PE + LX + ELF + Mach-O. `rel/` is regenerable build output,
gitignored (submodule `.gitignore`), per-machine. For a macbook-only test tree you
can safely `rm -rf` the foreign host dirs (`binl binl64 binnt binnt64 binp binw
binb64 bino64 armb64 arml64 armo nlm rdos`), leaving `armo64` + `h/lh/rh` +
`lib286/lib386` (~236M → ~109M).

**Activate + test (verified: compiles a valid CP/M-86 .CMD that runs on emu2):**
```
source scratch/cpm86-tools/ow-macos-env.sh    # sets WATCOM=rel, PATH+=rel/armo64, INCLUDE=rel/h
owcc -bcpm86 -mcmodel=s -O2 -o HELLO.CMD hello.c
scratch/cpm86-tools/emu2-cpm86/emu2 HELLO.CMD  # prints program output, rc=0
```
Valid cpm86 `.CMD` starts with a group-descriptor header `01 ..` (type-1 code group).
