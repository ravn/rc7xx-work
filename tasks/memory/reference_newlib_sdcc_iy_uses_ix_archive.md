---
name: newlib sdcc_iy links the sdcc_ix archive; clang IX-preservation audit
description: z88dk -clib=sdcc_iy links the sdcc_ix newlib workers; clang only needs IX preserved across calls, and newlib public entries preserve it
type: reference
---

**Fact (verified 2026-07-23, Phase A/B of the newlib-llvmz80 plan):**

1. z88dk `cpm.cfg` `CLIB sdcc_iy` line links the **sdcc_ix** newlib archive
   (`-L…/libsrc/newlib/lib/sdcc_ix -lcpm`) and only adds `--reserve-regs-iy` to
   *user*-code compilation. There is a single prebuilt newlib worker archive
   (sdcc_ix). Picking sdcc_iy does NOT give IY-clean workers — it gives
   IY-reserved user code against the same workers. It's still the right variant
   for clang because clang reserves IY too (not because workers avoid IY).

2. **The `__preserves_regs` correctness question collapses to one register: IX.**
   clang-z80's only callee-saved GPR is `Z80_CSR = (add IX)`; IY is reserved; the
   Z80 CALL opcode's TableGen `Defs = [A, BC, DE, HL, IY, FLAGS]` means clang
   already assumes A/BC/DE/HL/IY die at every call. So a worker preserving fewer
   regs than declared cannot corrupt clang — clang keeps a cross-call live value
   only in IX. The whole risk = does a public newlib entry clobber IX unrestored.

3. **Audit result: no public newlib entry leaks IX** (stdio/malloc/string/atoi
   surface). `_printf` brackets `push ix`/`pop ix`; `_fflush_fastcall` uses
   `push hl / ex (sp),ix / … / pop ix`. Internal helpers hold FILE*/FDSTRUCT* in
   IX across `l_jpix`/`ex (sp),ix` chains but are always bracketed by the public
   shim. sdcc-built workers preserve IX by frame-pointer discipline.

**Audit method (reuse for a wider draw):** build the target with `--list -m`,
take linked modules from the `.map` (4th comma field), intersect with
IX-touching `.asm` under `libsrc/newlib`, classify `push ix`/`pop ix`/`ex (sp),ix`
balance at the *public* entry. See [[plan-newlib-llvmz80-support-2026-07-22]] and
[[reference_z88dk_clang_register_abi]].
