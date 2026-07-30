---
name: z88dk lib rebuild is native (no Docker) — CLAUDE.md "via Docker" note is stale
description: bin/z88dk-{sccz80,zsdcc}, bin/z80asm are native macOS arm64; rebuilding z88dk LIBRARIES needs no Docker
type: reference
---

**Correction (2026-07-24):** the CLAUDE.md "z88dk via Docker container (do not
rebuild from source)" note is **stale**. `bin/z88dk-sccz80`, `bin/z88dk-zsdcc`
(ZSDCC 4.5.0 #15242, May 2026) and `bin/z80asm` are all **native macOS arm64**
binaries that run standalone. Rebuilding the z88dk **libraries** needs no Docker.
("do not rebuild from source" applies to the compiler *binaries*, not to using
them to rebuild libs.)

**Lib rebuild recipe (native, verified 2026-07-24):**
- `export ZCCCFG=$PWD/lib/config PATH=$PWD/bin:$PATH` (from z88dk root).
- Classic CP/M clib: `make -C libsrc TARGETS=cpm -k -j$(sysctl -n hw.ncpu)`.
- Classic crt + `l/llvmz80` bridges (strerror table, imath, qsort live here in
  `z80_crt0.lib`): `make -C libsrc TARGETS=z80 -k -j…`.
- Install into `lib/clibs/`: `make -C libsrc install` (copies `libsrc/*.lib`).
- newlib: `make -C libsrc/newlib cpm-clean && make -C libsrc/newlib cpm`.
- z80asm `-d` reuses stale `.o` → run the `*-clean` (or `make -C libsrc clean`)
  before a source-changing rebuild, else the lib keeps old objects.
- `.lib` files are gitignored build artifacts (`libsrc/.gitignore **/*.lib`);
  the fix lives in SOURCE, downstream users rebuild.

Gotcha fixed en route: ravn's `libsrc/stdlib/c/sccz80/strtol.asm` used IX under a
bare `IF __CLASSIC`, breaking 8080/8085/gbz80 classic builds; now guarded
`IF !__CPU_INTEL__ && !__CPU_GBZ80__`. See
[[reference_newlib_signed_mod_z88dk_bug]].
