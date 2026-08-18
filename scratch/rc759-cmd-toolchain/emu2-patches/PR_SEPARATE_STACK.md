cpm86: give small-model programs a genuinely separate entry-time stack

## What

When a CP/M-86 `CMD` does not declare its own explicit STACK group (group type 4), the loader now enters the program with `SS:SP` pointing at a small dedicated scratch stack segment allocated *below* the base/data segment, instead of unconditionally setting `SS = DS = cpm_base_seg`. The far-return "exit trampoline" (to the PSP's INT 20h) moves into that new stack segment along with `SP`.

Single file, `src/cpm86.c` (+54 / −14). No DOS or CP/M-80 path is touched; the change is inside `cpm86_load_cmd()` and only affects programs that don't supply their own stack group.

## Why

Real Concurrent CP/M-86 does **not** hand a loaded transient `SS == DS`. Per the DR CP/M-86 System Guide §4.1.2, it hands a small (96-byte / 6-paragraph) scratch stack in a segment below the base/data segment; a conforming program is expected to switch to its own `SS = DS` stack early in startup.

The old loader set `SS = DS` unconditionally, which is *more lenient* than real hardware: a `crt0` that forgets the `SS = DS` switch runs "by accident" under emu2 (because `SS == DS` trivially), but corrupts memory on real CCP/M-86, where a near pointer to an `SS`-relative stack local resolves against the wrong segment.

That leniency made emu2 a *false* oracle. A Watcom-built freestanding Dhrystone 2.1 port passed under the old emu2 but printed a wrong `Int_1_Loc` on real MAME `rc759` running genuine Concurrent CP/M-86 3.1: Proc_2's `*Int_Par_Ref = ...` never reached the actual stack slot once real hardware's `SS` genuinely differed from `DS`. This change makes emu2 reproduce the same `SS != DS` environment, so a PASS under emu2 is real evidence again rather than a coincidence of a too-forgiving loader.

## Verification

- Builds clean (`make`); the fix compiles with no new warnings.
- The Watcom Dhrystone port that silently mis-behaved on real hardware now exhibits the *same* `SS != DS` hazard under emu2, so the discrepancy that real MAME `rc759` showed is reproduced (emu2 and the hardware oracle now agree on the failure mode).
- Programs that declare their own STACK group (type 4) are unaffected — the scratch stack is only synthesized when no explicit stack group is present.

## Provenance

Analysis and patch prepared with GitHub Copilot (Claude) by @ravn; the behavioural fault was found by cross-checking emu2 against a cycle-accurate MAME `rc759` running genuine Concurrent CP/M-86 3.1, and the spec basis is the DR CP/M-86 System Guide §4.1.2.
