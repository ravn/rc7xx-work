---
name: codegen-rules
description: Rules for llvm-z80 compiler/codegen changes — read before touching Z80 backend, ISel, peepholes, calling conventions, or ABI
metadata:
  type: feedback
---

Read this file before ANY llvm-z80 compiler/codegen/ABI change.

## Framing

- **CRITICAL — [Z80 backend unfinished](project_z80_backend_unfinished.md): goal is to FINISH correctly, not optimize a finished one**
- **CRITICAL — [Z80 staged collaboration model](project_z80_upstream_goal.md): near-term llvm-z80/llvm-z80; long-term llvm/llvm-project**

## Correctness

- **[Compiler is not trusted](feedback_compiler_not_trusted.md) — HARD: inspect generated asm BEFORE blaming source/runtime/hardware**
- **[Verdict AFTER real pass output](feedback_verdict_after_real_pass_output.md) — HARD: show IR/asm the pass actually produces + contamination BEFORE stating verdict**
- **[AVR density oracle](feedback_avr_density_oracle.md) — HARD: before blaming generic pass, compile for AVR; AVR-cheap+Z80-expensive = our gap**
- **[double is float32 on z80](project_double_is_float32_retire_softfloat.md) — since #277: double==float==32-bit binary32; sf libcalls; math32 runtime; softfloat RETIRED**
- [Z80AutoStaticStack cross-TU soundness](autostaticstack_cross_tu_soundness_2026-08-11.md) — auto-inject gated hasLocalLinkage()||!ReachesExternal; test_09 fixed

## Peepholes

- **[Peephole safety guards](feedback_peephole_safety_guards.md) — HARD: erase/move/convert peepholes need complete liveness + slot-aliasing + iterator guards**
- **[Peephole adjacency uses next_nodbg](feedback_peephole_next_nodbg.md) — HARD: never raw std::next; DBG_VALUE pseudos break adjacency**
- **[Peephole lit tests must exercise -g](feedback_peephole_test_with_g.md) — HARD: every peephole test has TWO RUN lines (-O2 and -O2 -g)**
- [Root-cause over peephole](feedback_root_cause_over_peephole.md) — favor upstream fixes over post-RA peepholes
- [Late-opt audit](reference_late_opt_audit.md) — session-37 Keep/Migrate/Delete of all 46 peepholes

## ABI / calling conventions

- **[z88dk classic calling conventions under clang](reference_z88dk_calling_conventions.md) — __smallc=sdcccall(0); __z88dk_callee+fastcall are compositions; plan in llvm-z80/tasks/plan-2026-07-10**
- **[zlfn coding style](feedback_zlfn_coding_style.md) — HARD: CHECK-NEXT + slot offsets; distinct-coefficient formula; backend-internal CCs; critical sections are library not language**
- **[Z80 copies have spurious mayLoad/mayStore](feedback_z80_copy_spurious_mem_flags.md) — HARD: use !MI.memoperands_empty(), not mayLoad()/mayStore()**
- **[zeroext is ABI, not source-narrow](feedback_zeroext_is_abi_not_source.md) — HARD: use computeKnownBits before narrowing**
- **[TruncInstCombine: swap before probe](feedback_truncinstcombine_swap_before_probe.md) — HARD: modify IR users BEFORE getBestTruncatedType; rollback on failure**

## Known issues / parked

- [pi CSE / branch-fold miscompile PARKED](project_pi_cse_branchfold_parked.md) — don't flip -z80-enable-cse default ON until upstream fix
- [Fork-local pass naming](feedback_fork_local_pass_naming.md) — Z80* prefix is locative; target-agnostic body -> name with operation
- [#212-class HL borrow-save audit](project_212_class_borrow_save_pattern.md) — PUSH_HL without IMPLICIT_DEF trips verifier; 5+ latent sites #239
- **[Z80Pseudo undersize -> far-jr under-relaxation](issue267_pseudo_undersize_class.md) — #266+#267 fixed; LDIR/IDX8/MUL8/DIV8/SAT8 still latent**
- **[M6: narrow i16 EQ/NE of byte sext](reference_m6_sext_icmp_narrowing.md) — ravn/llvm-z80#259; IR-level narrowing chosen; no upstream report until verified**
- [Sieve-gap passes](reference_sieve_gap_passes.md) — Z80SinkColdLoopIV(-2.3%) + Z80PinLoopPointer(net-regresses); trackers #256/#250/#251

## z88dk bridge / ABI

- **[clang double duty: ez80clang + llvmz80](reference_clang_double_duty_ez80_llvmz80.md) — HARD: gate on __LLVMZ80, never bare __clang__**
- **[z88dk clang register ABI](reference_z88dk_clang_register_abi.md) — ez80clang bridges were STACK; llvmz80 is REGISTER (HL/DE); bridges rewritten**
- **[z88dk __z88dk_callee/__smallc ABI mismatch class](z88dk_z88dk_callee_llvmz80_abi_class.md) — clang push-order opposite of classic; narrows uint8_t to 1B; ~1500 decls unaudited**
- **[z88dk direction: classic forward, newlib compat-only](reference_z88dk_direction_classic_not_newlib.md) — maintainer-stated; classic is strategic target for llvmz80**
- [CANDIDATE BUG: llvmz80 miscompiles graphics.h](project_llvmz80_z88dk_callee_graphics_miscompile.md) — __smallc __z88dk_callee drops most args; blocks <graphics.h>; unanalysed
- [llvmz80 double-reverse suspects](reference_llvmz80_double_reverse_suspects.md) — z80_outp + sem702_loadglyph; same class as bdos #52; need runtime verification
