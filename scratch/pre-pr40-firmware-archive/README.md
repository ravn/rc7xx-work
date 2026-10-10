# Pre-PR-40 firmware archive

This archive keeps the September 5, 2026 firmware snapshot and its committed
artifacts separate from the earlier `c863c55` autoload comparison. It is a
workspace-local archive under `scratch/`, version-controlled on branch
`archive/pre-pr40-firmware`; it has not been pushed.

## Revision anchors

| Item | Revision |
|---|---|
| Firmware snapshot | `2951f96a1e3ca212c665c04db5de572bd53eaf74` |
| Pre-merge compiler tag | `compiler-pre-pr40` -> `d52e23342de460f4512a52fe8e0941b50bc2d526` |
| Compiler merge boundary | `48c1b4b461a326f1addf9305478a33b17f8defa0` |
| `autoload-in-c` last component change | `58fe3021da4d9fa703e14d38f3a5bab2bd1bda13` |
| `rcbios-in-c` last component change | `5628a27417f55f202d9ba9214c4060376cd08e1f` |
| `cpnos-in-c` last component change | `8ff343445b32d6a4ef034f77deb05bee6a3cb4a4` |
| Separate autoload source | `c863c55e27f82dadc73e7e15a2fbbc376d4b656c` |

The three component revisions are the most recent changes to those directories
at the firmware snapshot; the exported trees are taken from the common snapshot
commit. `source-snapshot/` contains those source trees, `cpnos-shared/`,
`sw1_config.mk`, and the artifacts that were already tracked in that commit.

## Contents

- `source-snapshot/` — exact Git archive export of the component sources and
  shared build inputs at the firmware snapshot, including its committed
  intermediate files, listings, and binaries.
- `reproductions/autoload-c863c55/source/` — the autoload source tree from
  `c863c55`, kept separate from the September snapshot.
- `reproductions/autoload-c863c55/evidence/` — PROM, listing, raw/compressed
  payloads, and logs from the earlier pre-PR-40 `c863c55` build.
- `reproductions/autoload-c863c55/COMPARISON.md` — same-source historical
  versus current-backend disassembly comparison, including method and limits.
- `reproductions/autoload-c863c55/current-d6658ad-asio/` — current compiler
  listing, ELF, inspection-only over-cap image, and raw/compressed payloads.
- `reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/`
  — source copy and outputs for the `always_inline` attribute counterfactual;
  helper symbols remained separate and the image matched baseline.
- `build-logs/` — toolchain configuration/build logs and per-component build
  logs, plus ccache statistics.
- `generated/` — rebuilt component intermediates, listings, and final binaries.

Build-generated banners contain the build time and checkout hash. Therefore,
rebuilt outputs may differ from tracked outputs in those banner bytes even
when the remaining payload is unchanged. See the component logs and hashes
recorded below before making byte-identity claims.

## Rebuilt artifacts and verification

The tagged compiler was configured from `llvm-z80-pre-pr40` with
`LLVM_CCACHE_BUILD=ON`, verified in the generated build command, then fully
built with `ninja -j10` (4645/4645 steps). Its `clang`, `llc`, `ld.lld`,
`llvm-nm`, `llvm-objcopy`, and `lib/z80/z80_rt.a` were checked at
`d52e23342de460f4512a52fe8e0941b50bc2d526`. Ccache was active, but reuse was
low: counters moved from 0 hits / 2794 misses to 4 hits / 6377 misses (4 of
6381 cacheable calls at the end; 0.06% hit rate).

The firmware snapshot builds used these Make targets:

```text
make -B -C autoload-in-c prom COMPILER=clang LLVM_Z80=<tagged compiler> MAME=<archive>/generated/mame
make -B -C rcbios-in-c bios COMPILER=clang LLVM_Z80=<tagged compiler>
make -C cpnos-in-c prom1-lineprog COMPILER=clang LLVM_Z80=<tagged compiler> CLANG_BUILD=<tagged compiler>/build-macos-asserts/bin
```

Build logs, including the exact expanded paths, are in `build-logs/`. The
historical firmware Makefiles auto-detect `build-macos`, so the build used a
temporary alias in the tagged worktree to its `build-macos-asserts` output.
CP/NOS also hard-codes the main checkout's `llvm-nm` path; a temporary alias at
that path was used for its link step. These build-environment workarounds are
not source edits. For a fresh CP/NOS build, first let its `cpnos-build` target
finish generating `d/cpnos.sys` and `d/cpnos.sym`, then run `prom1-lineprog`;
the top-level Makefile does not declare the generated `.sym` side effect as a
dependency, so parallel first-build ordering can otherwise fail.

| Rebuilt artifact | Size | SHA-256 |
|---|---:|---|
| September snapshot autoload PROM | 2034 B | `af6a4a63c007aa6556b83165e9831c7aa5350dadc2bec6852992bcb823978eac` |
| September snapshot padded autoload image | 4096 B | `50b3d78ed1c04fb38643eb17eaf959f24b96d2e922446584c308726833646617` |
| September snapshot rcbios CIM | 5918 B | `a616ae81e6d1eb08d76013cbc9ea626f5752051d12901fce2bd85374848fbb11` |
| September snapshot CP/NOS PROM1 | 2048 B | `7e6776273d6e956d69d6f5dc0d0017172f62c78bbc0223cefce2de8410102220` |
| CP/NOS raw payload | 1986 B | `aeb6bd21299ba26b668be09137833b08504ad07ce53248d8d64b8fb11a122ab9` |
| CP/NOS compressed payload | 1384 B | `8c0d352ddd976330ff2c9d1aec1ad18224c477e6af251bc12a940ba711905a06` |
| Pre-PR-40 runtime archive input | 50172 B | `ca0a97f2021bb718b0f8e11617e6e8d42f9182761afbc364d3a82bd1608f7410` |
| Separate `c863c55` autoload PROM | 2034 B | `f88166f3057bc9a2fa89721fb00bf10a6fe291e79eb152b7fd5c80569b91d8bd` |
| Separate `c863c55` raw `.text` | 3393 B | `d799d4bb1d6bbb951965596bc9b9c78759bae8f88823a24ddc2456391609cbee` |
| Separate `c863c55` compressed `.text` | 1915 B | `fb4ee49d5b69a16b82978929fa56b4ebf898c7ba1a1e7828e6309eda1d92e8f1` |

The autoload Makefile verified the 3393 -> 1915 B ZX0 round-trip and the 2034
B PROM0 fit; the generated IN/OUT listing includes `IN A,($4)` and
`OUT ($5),A`. The BIOS build verified its RC702 signature. CP/NOS verified
both ZX0 round-trips (604 -> 524 B and 1986 -> 1384 B) and its 2010 B
un-padded size against the 2048 B cap. The private MAME ROM copy is the same
4096 B padded autoload image.

Comparisons are kept separate from source provenance. The September snapshot's
rebuilt autoload raw `.text` differs from the tracked/decompressed `.text` in
14 bytes, all within the embedded build banner; its listing confirms the
timestamp and source hash changed. The CP/NOS raw payload differs from its
tracked version at byte offsets 1252 and 1986, and the compressed PROM1 differs
substantially; the cause of those differences has not been established. The
comparison details are in `build-logs/artifact-comparisons.log`. The earlier
`c863c55` source, outputs, and logs remain isolated under
`reproductions/autoload-c863c55/`.

No MAME boot or firmware runtime test was run for these archived builds. This
archive is local to the workspace, committed on `archive/pre-pr40-firmware`,
and not pushed. The CP/NOS build used sibling `cpnet-z80` revision
`d577cb2ffa187e9c5882a1cce8b27ef45d49e09c`; the autoload compressor/decompressor
came from `z88dk` revision `bad0ed8fa9b1916fa8a4566f25f11951a7f9e7fd`. Those
external dependency trees are not duplicated here because all resulting build
artifacts are preserved for direct inspection.
