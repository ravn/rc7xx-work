; AVR-side check for ravn/llvm-z80#179 — MachineScheduler reload-after-test
; reordering.  Pattern: dec-and-test of the same value where the test wants the
; ORIGINAL.  On Z80, the scheduler emits dec-then-reload-then-test, causing a
; redundant LD A,r reload.  On AVR (32 GPR, no implicit accumulator), the
; scheduler typically allocates a separate register for the dec result, so
; the test reads the original without a reload.
;
; Compile & inspect:
;   llc -O2 -mtriple=avr -mcpu=atmega328p bug179_test_then_dec.ll -o -
; Look for: any "redundant reload" pattern in the AVR output.

target triple = "avr-atmel-none"
target datalayout = "e-P1-p:16:8-i8:8-i16:8-i32:8-i64:8-f32:8-f64:8-n8-a:8"

@out_dec = global i8 0
@out_test = global i8 0

define void @test_then_dec_pattern(i8 %x) {
entry:
  %dec = add i8 %x, -1
  %iszero = icmp eq i8 %x, 0
  store i8 %dec, ptr @out_dec
  %r = zext i1 %iszero to i8
  store i8 %r, ptr @out_test
  ret void
}
