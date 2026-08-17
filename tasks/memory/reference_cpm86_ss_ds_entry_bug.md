---
name: reference_cpm86_ss_ds_entry_bug
description: CP/M-86 small model does NOT hand a program SS=DS at entry -- crt0 must switch itself. Real bug found + fixed 2026-08-16 (build-cpm86.sh's cpmstart.asm), plus a matching emu2-cpm86 loader fix so emu2 stops masking this bug class.
metadata:
  type: reference
---

**The wrong assumption (verified WRONG 2026-08-16):** `open-watcom-v2/contrib/ravn/cpmstart.asm`
used to say "The emulator/CCP sets CS=DS=ES=SS to the single program group...
so no segment/stack setup is needed here." False. Per the DR CP/M-86 System
Guide §4.1.2 and confirmed by directly reading DR C 1.11's own `startup.a86`
(`m.init.stack`, in `scratch/rc759-cmd-toolchain/rc759-drc-official/`), the
loader hands a small-model program a small **throwaway scratch stack in a
segment separate from DS**. The program is responsible for switching to
`SS=DS` itself, with `SP` from base-page word 6 (the code/data group's "top of
stack" length field), as its first act:

```asm
push ds     ; SS = DS  (8086 has no direct mov ss,ds)
pop  ss
mov  sp, word ptr [6]   ; SP = base-page word 6 (group top)
```

(DR C wraps this in `cli`/`popf` so an interrupt can never observe a stale SS
paired with the old SP or vice versa.)

**Why this matters for correctness, not just style:** Watcom small-model near
pointers are DS-relative by convention, but the CPU's own `[BP+...]`
stack-frame addressing is SS-relative. Both only agree if `SS==DS`. Take the
address of an on-stack local and pass it to another function as a plain near
pointer (`Proc_2(&Int_1_Loc)` — completely ordinary C, present verbatim in
unmodified Dhrystone 2.1) and the callee's write via that pointer lands at the
**wrong physical address** whenever the loader's entry-time SS differs from
DS. The local is silently never updated.

**How it was found:** an unmodified Dhrystone 2.1 port (`contrib/ravn/dhry.c`,
built via `build-cpm86.sh`) passed under `emu2-cpm86` but printed
`Int_1_Loc: 1` (should be 5) on **real MAME rc759** running genuine Concurrent
CP/M-86 3.1. A register dump confirmed real hardware measured `CS=DS=ES=4C86`
but `SS=4C80` — a live discrepancy, not a MAME bug (per user: "ccp/m-86 er
oraklet"). `emu2` had been giving `SS=DS` trivially (a single flat segment),
which is *more lenient* than real hardware and was silently masking the bug —
the canonical case for `[[feedback_prior_art_before_own_fix]]`-style "ask
where expected comes from": emu2's PASS was an equivalence artifact of its own
loader shortcut, not evidence of correctness.

**Two fixes landed together (2026-08-16), so both oracles agree:**
1. `open-watcom-v2` `contrib/ravn/cpmstart.asm` (commit `dc3c9f9fd7`, `master`)
   — added the `SS=DS`/`SP=[6]` switch as the program's first instructions.
   `HELLO.CMD`/`DHRY.CMD`/`BIGDATA.CMD` rebuilt so the checked-in artifacts
   match.
2. `emu2-cpm86` (`johnsonjh/emu2-cpm86`, cloned to
   `cpm86-crossdev/downloaded/emu2-cpm86/`, **not a submodule of this
   workspace — fix is local to that clone only, not yet upstreamed or
   otherwise persisted**) `src/cpm86.c` `cpm86_load_cmd()` — when a CMD
   declares no explicit type-4 STACK group, the loader now allocates a small
   6-paragraph scratch segment and hands SS/SP there (mirroring the spec's
   96-byte default), instead of unconditionally `cpuSetSS(cpm_base_seg)`.
   Verified: HELLO/DHRY/BIGDATA still pass under the patched emu2; the
   *unfixed* dhry.c (old cpmstart.asm) now correctly FAILS under the patched
   emu2 too (matching real MAME), proving the emu2 fix actually closes the gap
   rather than just reshuffling which environment happens to be lenient.

**Verification, both directions, both platforms:**
| crt0 | emu2-cpm86 (patched) | MAME rc759 (real CCP/M-86) |
|---|---|---|
| old (no SS=DS switch) | FAIL Int_1_Loc=1 | FAIL Int_1_Loc=1 |
| new (SS=DS switch) | PASS Int_1_Loc=5 | PASS Int_1_Loc=5 |

**Scope:** this affects every program built through `build-cpm86.sh`'s
freestanding path (small/8080 model, own BDOS calls, no DR C or Watcom clib
runtime) that takes the address of an on-stack local and passes it across a
function call as a near pointer — a completely ordinary C pattern, not
something exotic. Programs linking DR C's own runtime or the full Watcom
clib (`contrib/ravn/watcom-cpm86-libc/`) were never at risk; their own
crt0/`m.init.stack`-equivalents already did this switch.

**The emu2-cpm86 fix is NOT durable yet** — it lives in a plain git clone
under `cpm86-crossdev/downloaded/`, outside any tracked submodule. If that
directory is ever recreated (`rm -rf` + reclone), the fix is lost silently
and emu2 will go back to masking this bug class. Options not yet decided:
vendor the patch as a `.patch` file in-repo, add it as a real submodule, or
upstream it to `johnsonjh/emu2-cpm86`.

Related: `[[reference_cpm86_cmd_header]]` (the §4.1.2 spec text + a prior,
independent real-hardware register dump — `CS=2150 DS=216D SS=214A`, already
showing SS≠DS back on 2026-08-14, which this session's bug is a second,
independent confirmation of), `[[reference_cpm86_toolchain_linux_build]]`
(how the emu2-cpm86/cpmtools/MAME toolchain was built on this host).
