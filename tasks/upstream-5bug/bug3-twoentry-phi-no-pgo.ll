; Bug 3 repro: foldTwoEntryPHINode consults getPredictableBranchThreshold()
; ONLY when branch weights exist; non-PGO code is speculated regardless of
; the target's declared branch predictability.
;
; RUN A: opt -passes=simplifycfg -predictable-branch-threshold=0 -S
;   @cond_xor_noweights -> folded to select + unconditional xor (BUG: the
;   threshold override is never consulted because there are no weights)
;   @cond_xor_weights   -> branch kept (threshold IS consulted, suppresses fold)
;
; The two functions are identical except for !prof metadata.

define i8 @cond_xor_noweights(i8 %x, i16 %c) {
entry:
  %tobool = icmp eq i16 %c, 0
  br i1 %tobool, label %merge, label %then

then:
  %xor = xor i8 %x, 27
  br label %merge

merge:
  %r = phi i8 [ %xor, %then ], [ %x, %entry ]
  ret i8 %r
}

define i8 @cond_xor_weights(i8 %x, i16 %c) {
entry:
  %tobool = icmp eq i16 %c, 0
  br i1 %tobool, label %merge, label %then, !prof !0

then:
  %xor = xor i8 %x, 27
  br label %merge

merge:
  %r = phi i8 [ %xor, %then ], [ %x, %entry ]
  ret i8 %r
}

!0 = !{!"branch_weights", i32 1, i32 1}
