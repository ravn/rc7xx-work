; AVR-side codegen check for ravn/llvm-z80#128 — MachineLICM/MachineCSE
; pessimization on tiny register files.  Tests whether AVR (32 GPR) suffers
; the same LICM-hoist-then-spill pattern that hurts Z80 (3 effective pairs).
;
; Loop body has 4 live u8 values; hoisted invariants `h1` and `h2`.  On Z80
; (LICM on), `h1` and `h2` BSS-spill into the loop body, costing bytes.
; On AVR (LICM on), they live in registers across the loop.
;
; Compile & inspect:
;   llc -O2 -mtriple=avr -mcpu=atmega328p bug128_licm_cse.ll -o -
;   llc -O2 -mtriple=avr -mcpu=atmega328p -disable-machine-licm \
;       -disable-machine-cse bug128_licm_cse.ll -o -
; Diff the two; if AVR has zero delta, MachineLICM is harmless on AVR
; (hypothesis: AVR's 32 GPR keep the hoisted values resident).

target triple = "avr-atmel-none"
target datalayout = "e-P1-p:16:8-i8:8-i16:8-i32:8-i64:8-f32:8-f64:8-n8-a:8"

@arr = external global [256 x i8]
@sink = external global i8

define void @licm_bait(i16 %base, i16 %step) {
entry:
  %m1 = mul i16 %base, 7
  %h1_16 = add i16 %m1, 1                       ; invariant 1
  %h1 = trunc i16 %h1_16 to i8
  %m2 = mul i16 %step, 11
  %h2_16 = add i16 %m2, 13                      ; invariant 2
  %h2 = trunc i16 %h2_16 to i8
  br label %loop

loop:
  %i = phi i8 [ 0, %entry ], [ %i.next, %loop ]
  %ix0 = zext i8 %i to i16
  %ip0 = getelementptr [256 x i8], ptr @arr, i16 0, i16 %ix0
  %v0 = load i8, ptr %ip0
  %a = xor i8 %v0, %h1                          ; uses h1
  %i1 = add i8 %i, 1
  %ix1 = zext i8 %i1 to i16
  %ip1 = getelementptr [256 x i8], ptr @arr, i16 0, i16 %ix1
  %v1 = load i8, ptr %ip1
  %b = xor i8 %v1, %h2                          ; uses h2
  %i2 = add i8 %i, 2
  %ix2 = zext i8 %i2 to i16
  %ip2 = getelementptr [256 x i8], ptr @arr, i16 0, i16 %ix2
  %v2 = load i8, ptr %ip2
  %c = add i8 %v2, %a
  %i3 = add i8 %i, 3
  %ix3 = zext i8 %i3 to i16
  %ip3 = getelementptr [256 x i8], ptr @arr, i16 0, i16 %ix3
  %v3 = load i8, ptr %ip3
  %d = add i8 %v3, %b
  %e = xor i8 %c, %d
  store volatile i8 %e, ptr @sink
  %i.next = add i8 %i, 1
  %done = icmp eq i8 %i.next, 50
  br i1 %done, label %end, label %loop

end:
  ret void
}
