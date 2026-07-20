# Bug class: Z80Pseudo undersized by getInstSizeInBytes → BranchRelaxation
# under-relaxes far `jr` (#266, #267, and ~14 latent siblings)

Recorded 2026-07-20 after fixing #267.

## The class
`Z80InstrInfo::getInstSizeInBytes` ends its special-case handling with
`if (MI.isPseudo()) return 0;`. Any instruction defined as `Z80Pseudo`
(isPseudo=1) that is NOT enumerated in the special size switch is therefore
reported as **0 bytes** — even though `Z80ExpandPseudo` later expands it (AFTER
BranchRelaxation runs in addPreEmitPass) into a multi-byte sequence.

Consequence: BranchRelaxation under-counts function size → a `jr`/`djnz` whose
real displacement exceeds ±127 B is left as `jr`. The object emitter
(`Z80AsmBackend::relaxInstruction`) silently relaxes it to `jp` for `-filetype=obj`,
but textual `.s` keeps the invalid `jr`. clang's integrated assembler hides it;
an EXTERNAL Z80 assembler (z88dk z80asm, used by `zcc +cpm -compiler=llvmz80`)
rejects it with "integer range".

## Fixed so far
- #266 — MUL16/UDIV16/UMOD16/SDIV16/SMOD16 + SUB/ADC/SBC_HL_rr_* : sized in the
  IsSM83 switch.
- #267 — the 8 variable-shift pseudos SHL8_VAR/LSHR8_VAR/ASHR8_VAR/ROTL8_VAR/
  ROTR8_VAR/SHL16_VAR/LSHR16_VAR/ASHR16_VAR : sized (Z80 8/8/8/7/7/7/10/10,
  SM83 9/9/9/8/8/8/11/11). head=INC B+DEC B+JR Z=4; term Z80 DJNZ=2 / SM83
  DEC B+JR NZ=3; bodies SLA/SRL/SRA A=2, RLCA/RRCA/ADD HL,HL=1, 16-bit right
  shift SRL/SRA H + RR L=4.

## STILL LATENT (same class, still sized 0) — audited 2026-07-20
## → ALL FIXED 2026-07-21 (systemic pass). Kept here for the audit trail.
All were `Z80Pseudo` and expand multi-byte in Z80ExpandPseudo.cpp:
- LDIR_GUARDED, LDDR_GUARDED, MEMSET_LDIR_GUARDED  (guarded block copy/fill)
- LOAD_IDX8, STORE_IDX8  (#27 opt-in indexed load/store, `-z80-idx-addr`)
- MUL8, UDIV8, UMOD8, SDIV8, SMOD8  (8-bit mul/div/mod)
- UADDSAT8, USUBSAT8, SADDSAT8, SSUBSAT8  (saturating add/sub)

## FIXED 2026-07-21 — systemic pass (all of the above)
Measured each expansion's real size with the #240 drift guard as an oracle
(temporarily switched its report to errs()+continue, ran llc
`-z80-verify-inline-runtime-size` over a .ll exercising every pseudo, read the
"expansion is N bytes" report, then restored the fatal report). Measured
(Z80/SM83): MUL8 12/13, UDIV8 15/16, UMOD8 14/15, SDIV8 37/38, SMOD8 34/35,
UADDSAT8 5, USUBSAT8 4, SADDSAT8/SSUBSAT8 8 (Z80-only, JP PO form),
LDIR/LDDR_GUARDED 6, MEMSET_LDIR_GUARDED 15, LOAD/STORE_IDX8 3. (SM83 loop
terminators DEC B+JR NZ = 3 vs Z80 DJNZ = 2 → +1 on the loop pseudos.) All added
to the IsSM83 switch in getInstSizeInBytes AND registered in
`isInlineRuntimeSizedPseudo` so the drift guard validates them going forward.
Lit: `issue-267-pseudo-size-drift-guard.ll` (mul8/div8/mod8/sat8/var-shift) +
`-z80-verify-inline-runtime-size` RUN lines added to `issue-27-iy-indexed-addr.ll`
(IDX8) and `issue-105-ldir-guarded.ll` (GUARDED). Full Z80 lit: 207 PASS + 5 XFAIL.

## SEPARATE root cause of the fmt64@-O2 failure (do NOT confuse with the above)
The systemic sizing above did NOT by itself fix `fmt64.c @ -O2` (still
"integer range: $80" at line 1659). Diagnosed 2026-07-21: it was NOT a backend
undercount at all, but our own z88dk bridge `z88dk/lib/llvmz80/
bridge_postproc.sh`. It had a final perl stage rewriting every conditional
`jr cc,label` → `jp cc,label` (2 B → 3 B). Measured on fmt64: clang `.s` = 204
conditional `jr`; assembled `.asm` = 0 `jr` / 203 `jp`. That +1 B per site runs
AFTER clang's BranchRelaxation and grows the byte span of an enclosing
UNCONDITIONAL `jr` that clang had correctly left at exactly 127 B in its own
model (where jr cc = 2 B). One intervening `jr nz`→`jp nz` tipped it to 128
($80) → z80asm reject. The rewrite was a stale workaround from before the #267
backend fix, and is BOTH redundant (clang's Z80 backend already relaxes
conditional jr itself: isBranchOffsetInRange covers JR_Z/NZ/C/NC; insertBranch
picks jr in-range / jp out-of-range) AND harmful. Removed it → fmt64@-O2
assembles clean, and jr stays 2 B when in range (size win: ~203 B on fmt64).
LESSON: when a bridge/post-processor rewrites instructions in a way that changes
byte sizes, it invalidates the compiler's own branch-relaxation decisions. The
compiler must be the single source of truth for jr-vs-jp; a post-pass must not
change instruction sizes after relaxation.

## Audit command
    grep -oE "case Z80::[A-Z0-9_]+" Z80ExpandPseudo.cpp | sed 's/case Z80:://' | sort -u
compared against the special-size switches in getInstSizeInBytes
(Z80InstrInfo.cpp, the two IsSM83 blocks + COPY16_PUSHPOP). Anything in the
former, not the latter, that expands to >0 bytes is undersized.
