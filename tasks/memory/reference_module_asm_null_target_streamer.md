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
