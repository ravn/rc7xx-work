; AVR-side codegen comparison for ravn/llvm-z80#164 — TruncInstCombine zext
; re-insertion cost model.  Hand-rolled wide_form (i16 throughout) vs
; narrow_form (i8 chain + 4 explicit zext re-extensions at uses).
;
; Run on AVR:  llc -O2 -mtriple=avr -mcpu=atmega328p bug164_zext_reinsertion.ll
;   wide_form   = 34 instr
;   narrow_form = 39 instr  (+5 / +15%)
; Run on Z80:
;   wide_form   = 21 instr
;   narrow_form = 29 instr  (+8 / +38%)
; Verdict: STRENGTHENED.  Both targets pay; Z80 pays more.

target triple = "z80-unknown-elf"
@a = global i16 0
@b = global i16 0
@c = global i16 0
@d = global i16 0

define void @wide_form(i16 %x, i16 %p) {
  %m = and i16 %x, 255
  %add = add i16 %m, %p
  store i16 %add, ptr @a
  %u2 = mul i16 %add, %p
  store i16 %u2, ptr @b
  %u3 = sub i16 %add, %p
  store i16 %u3, ptr @c
  %u4 = xor i16 %add, %p
  store i16 %u4, ptr @d
  ret void
}

define void @narrow_form(i16 %x, i16 %p) {
  %xl = trunc i16 %x to i8
  %addl = add i8 %xl, 0
  %a_v = zext i8 %addl to i16
  %a_add = add i16 %a_v, %p
  store i16 %a_add, ptr @a
  %b_v = zext i8 %addl to i16
  %b_mul = mul i16 %b_v, %p
  store i16 %b_mul, ptr @b
  %c_v = zext i8 %addl to i16
  %c_sub = sub i16 %c_v, %p
  store i16 %c_sub, ptr @c
  %d_v = zext i8 %addl to i16
  %d_xor = xor i16 %d_v, %p
  store i16 %d_xor, ptr @d
  ret void
}
