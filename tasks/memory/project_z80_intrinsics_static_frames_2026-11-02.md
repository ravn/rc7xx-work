---
name: project_z80_intrinsics_static_frames_2026-11-02
description: llvm-z80 S1–S4 (intrinsic nocallback, const-port IN/OUT, im/set.i, clang builtins) done on LOCAL branches; firmware status; pitfalls; what is open
metadata:
  type: project
---

**Why this exists:** the pinned `llvm-z80` `da06bcd8acc2` (= ravn/llvm-z80 origin/main) lacked `__builtin_z80_*`, `<intrinsic.h>`, `z80_critical` and `AS_IO`. The user needs machine instructions (DI/EI/HALT/NOP/IN/OUT/IM/LD I,A) from C **without losing static frames**. Inline asm costs static frames unless the #413 edge-stripping hack covers it. Root cause for intrinsics: `CallGraph.cpp:93` gives any declaration without `nocallback` an edge to CallsExternalNode ("could call anything"); the Z80 intrinsics were plain `Intrinsic<>` without it. `nocallback` alone is necessary and sufficient for `Z80NonReentrant`.

**Done 2026-11-02 (branches in `llvm-z80/`, stacked, PUSHED 2026-11-02 to ravn/llvm-z80 as `s1/…`–`s4/…`; backup patches in `tasks/patches/llvm-z80-intrinsics-static-frames-2026-11-02/`):**
- S1 `2a1f1ab9f81a` `IntrNoCallback` on llvm.z80.{in,out,halt,di,ei,nop} (+willreturn on in/out/nop only; halt/di/ei must not claim willreturn/nosync). Lit `static-frames-intrinsics.ll`.
- S2 `7072c68396f4` constant port → `IN A,(n)`/`OUT (n),A` (−2 B each); `Defs/Uses=[A]` on `IN_A_n`/`OUT_n_A`. Lit `port-io-immediate.ll`. Refs ravn/llvm-z80#421. High address byte A15–A8 is *unspecified* (user decision).
- S3 `575307b1713b` `llvm.z80.im0/im1/im2` (three, user decision) and `llvm.z80.set.i`; `LD_I_A` `Uses=[A]` (without it the COPY into A was dead → `ld i,a` used a stale A). Lit `intrinsics-im-set-i.ll`.
- S4 `5746100bc287` clang `__builtin_z80_{di,ei,halt,nop,in,out,im0,im1,im2,set_i}` (clang parts of `2883cdd8bb73`; `<intrinsic.h>` in the clang resource dir deliberately NOT restored). in/out/im*/set_i gated to the `z80` feature (sm83 gets a clean error). Clang tests `z80-builtins*.c`. C→asm verified: `ld a,64; ld i,a`, `im 2`, `out (16),a`, `in a,(17)`, static frame kept.
- Test status: lit CodeGen/Z80 159/160 (`z88dk-runtime.ll` fails IDENTICALLY on the base: expects `l_mulu_32_16x16`, gets `___umulhi3`); cargo runtime 462 total/456 pass/0 fail/6 skip (SM83 inline-asm test, by design), per-test identical to base; 17/17 Z80 clang tests. Mutation checks done (removing the fix makes the new tests fail).

**Pitfalls learned:**
- TableGen turns `_` in the def name into `.` in the IR name: `int_z80_set_i` = `llvm.z80.set.i`. A wrong name (`llvm.z80.set_i`) is a silently ignored unknown function: the call vanishes AND the caller loses its static frame.
- IR `nocallback` on an intrinsic declaration is overwritten by the intrinsic's own attributes; fix it in the `.td`.
- `IntrNoMem`+`IntrHasSideEffects` already = `memory(unknown)`: full compiler barrier (polling loops keep re-reading). Don't switch to `DefaultAttrsIntrinsic` or drop HasSideEffects.
- `llvm.trap/ubsantrap/debugtrap` also lack nocallback (so `__builtin_trap()` kills static frames) — unfixed.
- Build in the existing `llvm-z80/build-linux` (same path → ccache hits); the checkout now sits on branch `s4/…`; restore the pin with `git switch --detach da06bcd8acc2`. See [[feedback_ccache_llvm_build]].
- `z80_rt.a` must be built explicitly: `ninja -C llvm-z80/build-linux lib/z80/z80_rt.a` (rcbios link needs it).

**Firmware with the S4 clang (2026-11-02):** autoload `make prom` OK, 2035 B (cap 2048). rcbios `make bios` OK, 5761 B (CLAUDE.md's 5462 B is from June; cause of +299 B not investigated; no boot test run). cpnos `make prom1-lineprog` FAILS: attribute `z80_preserves_regs` (commit `70eed199d837`, absent on main → ignored) and a backend `report_fatal_error` "target did not implement null MCTargetStreamer" with `-flto -g` (cause unknown). NO MAME boot gate run yet — use Makefile targets only.

**Inline asm left in autoload:** replaceable by builtins: `clang/intrinsic.h:28` (`ld i,a`), `rom.h:295` (`im 2`). Not replaceable: `jump_to` (`push;ret`, rom.h:144), `SET_SP`, ISRs (`rom.c`), boot_rom.c layout asm. #413 stays until all asm is migrated (user: wait).

**Open / next:** (1) fix cpnos (z80_preserves_regs attr + MCTargetStreamer fatal); (2) switch autoload `set_i_reg`/`intrinsic_im_2` to builtins and measure bytes + MAME boot (Makefile targets); (3) `intrinsic_*` mapping in z88dk `include/intrinsic.h` `__LLVMZ80`/`__CLANG` block with `__has_builtin` guard (user: goal is z88dk working correctly; nobody else uses this until released); (4) S6/#413 decision; (5) first push = issue on ravn/llvm-z80 (like #421) then upstream only with explicit per-filing go-ahead; user said: do it locally, if it works "rykker vi det op". Ordering/risks: `tasks/plan-z80-intrinsics-static-frames-2026-11-02.md`.

**Decisions (user):** `AS_IO`/address_space(2) NOT restored; use intrinsics/builtins (+ z88dk functions where fitting); high port byte unspecified; three im intrinsics; ISR mid-body `ei`: no C ISR does it today (autoload/cpnos ISRs are `__naked`; rcbios `ei` only in naked helpers) — keep stack frames there is possible later but not needed now.

Refer to the fork owner only as "the fork owner" (never-mention rule, MEMORY.md §2). Related: [[reference_host_sonnyboy]], [[feedback_static_stack_nonrecursive_only]].

**Handoff for another AI/machine:** `tasks/HANDOFF-z80-intrinsics-2026-11-02.md` (resume commands, expected test numbers, priorities, rules).
