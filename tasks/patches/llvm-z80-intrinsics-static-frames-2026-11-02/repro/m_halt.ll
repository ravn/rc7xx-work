declare i8 @llvm.z80.in(i8)
declare void @llvm.z80.halt()
define i16 @main() {
  %buf = alloca [4 x i16], align 1
  store volatile i16 1, ptr %buf, align 1
  call void @llvm.z80.halt()
  %v = load volatile i16, ptr %buf, align 1
  ret i16 %v
}
