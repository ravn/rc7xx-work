---
name: ninja clang llc together
description: After llvm-z80 backend changes, rebuild BOTH clang and llc — `ninja llc` alone leaves the clang symlink pointing at a stale binary still linked against the previous libLLVMZ80CodeGen.a, so downstream cpnos-rom / rcbios / autoload-in-c builds appear unchanged.
type: feedback
originSessionId: 90f5a17f-7f0a-47da-8820-66f3b9c19063
---
**Rule:** Any change to a pass in `llvm/lib/Target/Z80/` requires
`ninja -C build-macos clang llc` (both binaries).  `ninja llc` alone
is not enough.

**Why:**
- `clang` and `llc` are linked from separate ninja targets against
  the same `libLLVMZ80CodeGen.a` static archive.
- After modifying a Z80 backend pass, `ninja llc` relinks the
  archive AND `llc`.  The `clang` binary continues to use the
  previously-linked image of the archive that's baked into the
  existing `clang-23` executable.
- The `bin/clang` symlink points at `clang-23`.  Until that
  binary is relinked (via `ninja clang` or `ninja all`), every
  clang invocation runs the OLD backend pass.

**How to apply:**
- When running any size or correctness check that uses the clang
  driver (cpnos-rom build, rcbios build, autoload build, or any
  Makefile that invokes `$(LLVMZ80)/build*/bin/clang`), always
  precede with `ninja -C build-macos clang llc`.
- `build-macos/bin/llc` direct invocation is fine after `ninja llc`
  alone — but those are llvm-lit lit tests and isolated llc runs,
  NOT downstream multi-stage builds.

**Symptom this rule catches:**
- Size benchmark on cpnos-rom reports "byte-identical to baseline"
  for a peephole that DOES fire on production code.  Compiler
  appears not to have changed.  Time-sink: re-running the same
  measurement multiple times, suspecting MIR-level filtering bugs,
  re-checking gates that are actually correct.
- First observed: session 60b (2026-05-12), #132 cross-MBB BSS-spill
  peephole.  Reported byte-identical at session 60 commit;
  re-measuring after `ninja clang` showed −2 B saved on cpnos-rom
  payload (1906 → 1904 B).

**Verification short-cut when in doubt:**
- Compare timestamps: `ls -la build-macos/bin/clang-23
  build-macos/bin/llc lib/libLLVMZ80CodeGen.a`.  If `clang-23` is
  older than `libLLVMZ80CodeGen.a`, clang is stale.
