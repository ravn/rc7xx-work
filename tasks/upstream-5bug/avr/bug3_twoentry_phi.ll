; AVR-side codegen comparison for 5-bug "Bug 3" — SimplifyCFG foldTwoEntryPHINode
; on non-PGO code.  Bug claim: upstream folds branch -> select even when target
; says branches are predictable.
;
; Run on AVR:  llc -O2 -mtriple=avr -mcpu=atmega328p bug3_twoentry_phi.ll -o -
;   branch_form:  cp/cpc/breq/ldi/eor/ret   = 5 instr
;   select_form:  cp/cpc/breq/ldi/eor/ret   = 5 instr
; Result: byte-identical AVR codegen for both.  Verdict: WEAKENED on AVR.

define i8 @branch_form(i8 %x, i16 %c) {
entry:
  %t = icmp eq i16 %c, 0
  br i1 %t, label %merge, label %then
then:
  %xor = xor i8 %x, 27
  br label %merge
merge:
  %r = phi i8 [ %xor, %then ], [ %x, %entry ]
  ret i8 %r
}

define i8 @select_form(i8 %x, i16 %c) {
entry:
  %t = icmp eq i16 %c, 0
  %xor = xor i8 %x, 27
  %r = select i1 %t, i8 %x, i8 %xor
  ret i8 %r
}
