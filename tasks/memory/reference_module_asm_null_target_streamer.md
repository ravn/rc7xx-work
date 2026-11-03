# Module assembly requires a null target streamer

When LLVM serializes bitcode containing module-level inline assembly, LTO's
`ModuleSymbolTable::CollectAsmSymbols` scans the assembly through the target's
null `MCTargetStreamer`. Targets that do not register one fail with
`target did not implement null MCTargetStreamer`; function-body inline assembly
does not exercise this path.

Z80 and SM83 register `MCTargetStreamer` as their null target streamer in
`Z80MCTargetDesc.cpp`. The regression test
`llvm/test/CodeGen/Z80/module-asm-symbols.ll` checks symbol extraction for both
targets and module-summary generation. It was observed to fail on the S4
baseline and pass after the registration. The original C reproducer and the
previously failing cpnos object compilations also pass with LTO after the fix.

On the tested S4 branch, the wider Z80 CodeGen suite was 160/161; the only
failure, `z88dk-runtime.ll`, was already failing on the base. On 2026-11-03,
the complete PIO/E:-default cpnos PROM build passed at 2024/2048 bytes, with
both ZX0 round-trips passing. MAME boot remains unverified: the configured
emulator rejects the `cpnet_bridge` PIO slot, and its source tree lacks
`cpnet_bridge.cpp`.

## 2026-11-03 forced-build verification

The null-streamer fix is committed as `adca21931a5f` on the pushed branch
`fix/cpnos-lto-null-streamer` in `ravn/llvm-z80`; it is not merged into the
primary compiler checkout. The isolated S4 toolchain was rebuilt from that
branch. The C reproducer passed with and without debug info, and `llvm-nm`
found `_alias` and `_f` in both bitcode files.

Using that toolchain, forced Makefile builds passed for autoload (`2035 B`),
rcbios (`5761 B`), and the cpnos PROM1 image (`2048 B`, padded to its 2 KB
cap). The cpnos build used `TRANSPORT=pio-irq`, `CPNOS_DEFAULT_DRIVE=0x04`,
and `MIRROR_SIOB=1`; the Makefile's ZX0 round-trip checks passed. No MAME boot
was run. The issue is already tracked by `ravn/llvm-z80#411`; the missing
bridge is covered by `ravn/mame-rc702-rc759-rc750#50` and `#54`.

The isolated S4 build used the ccache wrapper, but recorded only 6 hits from
107 cacheable calls. Separate worktree paths therefore remain a cold-cache
cost; `--link-dest` saves disk space but does not normalize ccache paths.
