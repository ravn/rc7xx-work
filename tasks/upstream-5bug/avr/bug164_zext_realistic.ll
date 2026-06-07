target triple = "z80-unknown-elf"
@a = global i16 0
@b = global i16 0
@c = global i16 0
@d = global i16 0

; What TruncInstCombine WOULD produce when it narrows a longer i16 chain
; whose value is consumed by i16-typed uses.  The chain has real i8 work,
; then a single zext, then i16 uses.

define void @wide_form(i16 %x, i16 %p) {
  %m = and i16 %x, 255
  %s1 = shl i16 %m, 1
  %s2 = xor i16 %s1, 42
  %s3 = add i16 %s2, %p     ; the chain has real work
  store i16 %s3, ptr @a
  %u2 = mul i16 %s3, %p
  store i16 %u2, ptr @b
  %u3 = sub i16 %s3, %p
  store i16 %u3, ptr @c
  %u4 = xor i16 %s3, %p
  store i16 %u4, ptr @d
  ret void
}

define void @narrow_form(i16 %x, i16 %p) {
  %xl = trunc i16 %x to i8
  %s1 = shl i8 %xl, 1
  %s2 = xor i8 %s1, 42
  %v = zext i8 %s2 to i16   ; bridge once, reuse
  %s3 = add i16 %v, %p
  store i16 %s3, ptr @a
  %u2 = mul i16 %s3, %p
  store i16 %u2, ptr @b
  %u3 = sub i16 %s3, %p
  store i16 %u3, ptr @c
  %u4 = xor i16 %s3, %p
  store i16 %u4, ptr @d
  ret void
}
