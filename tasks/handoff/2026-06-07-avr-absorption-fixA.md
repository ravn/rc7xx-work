# Handoff 2026-06-07 evening — AVR-absorption work, Fix A done on branch

Host: sonnyboy (being shut down). Everything committed + pushed.

## llvm-z80 branches (main UNTOUCHED, CI safe)

1. **avr-style-wide-access** — Fix A COMPLETE, NOT merged (oracle pending):
   pre-legalizer combine store(load) of i32/i64+ -> G_MEMMOVE.  65 -> 2
   instructions on the bug-5 i64 shape (vs AVR's 37).  Lit PASS (6 fns),
   clang fixture test_223 6/6 PASS.  REMAINING before merge: (a) llc-suite
   fixture test_27_wide_copy_overlap.ll never executed — the llc suite
   reports "Run 'ninja lib/Target/Z80/Z80Runtime'" even after building
   Z80Runtime (plumbing issue, maybe BUILD_DIR or artifact path — diagnose);
   (b) full oracle: lit suite, test-runner full (NOTE: 3 known-fail
   soundness fixtures live on the OTHER branch now, so main/A-branch runs
   are clean), AES 13-config, production byte-compare (cpnos/BIOS/autoload);
   (c) then merge --no-ff + CI watch.
2. **icmp-narrow-soundness-tests** — failing-first matrix for the #160/#165
   miscompile (lit 25 fns + test_220/221/222).  Decision PENDING: revert
   icmp paths (favored — generic InstCombine already narrows provably-narrow
   shapes, evidence: %add.narrow in both compilers) vs sound gate (needs
   graph-side KnownBits, signed = 7-bit bound).  After decision: re-measure
   gf_log/AES/production; #219 (held) + bug-5 filing decision follow.

## Fix B — NOT STARTED

Extend #27 IDX pseudos to 16-bit limbs (LOAD_IDX16/STORE_IDX16, expand to
byte pairs at IX+d/d+1, dst class GR16NoIR, gate at Z80InstructionSelector.cpp:2586-2599
currently `<= 8` bits only; store twin at :2865).  General wide-limb win
(i32/i64/float arithmetic).  Keep behind -z80-idx-addr; measure AES.

## Upstream queue state

- Bug 2 FILED llvm/llvm-project#202112 + AVR datum comment (20-vs-3 instr).
  Daily watcher routine checks it (trig_012Thn7hHeabxS59DsQPzkRS, 06:00 UTC).
- Bug 3: demoted to fork-only (no in-tree threshold constituency).  Bug 4:
  recommend no upstream filing + close #219 (user: "leave 219 for now").
  Bug 5: consistency-argument-only; decide after the revert decision.
- AVR triage: tasks/upstream-5bug/avr-triage-2026-06-07.md.

## Environment notes

- Upstream build now has AVR+MSP430 (`~/llvm-upstream`, de59f9ed, Release).
- z88dk-ticks symlinked into ~/.local/bin (test-runner needs no PATH override).
- New memory rules: feedback_token_efficiency, feedback_thorough_tests_for_upstream_bugs,
  feedback_avr_density_oracle; feedback_show_thinking now TIERED.
