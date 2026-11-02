declare i8 @llvm.z80.in(i8)
declare void @llvm.z80.out(i8, i8)

define i8 @rd() {
  %v = call i8 @llvm.z80.in(i8 16)
  ret i8 %v
}
define void @wr() {
  call void @llvm.z80.out(i8 17, i8 65)
  ret void
}
define void @wrv(i8 %v) {
  call void @llvm.z80.out(i8 16, i8 %v)
  ret void
}
define void @poll() {
entry:
  br label %loop
loop:
  %v = call i8 @llvm.z80.in(i8 16)
  %b = and i8 %v, 1
  %z = icmp eq i8 %b, 0
  br i1 %z, label %loop, label %done
done:
  ret void
}
define void @echo(i8 %p) {
  %v = call i8 @llvm.z80.in(i8 %p)
  call void @llvm.z80.out(i8 %p, i8 %v)
  ret void
}
define i8 @two() {
  %a = call i8 @llvm.z80.in(i8 16)
  %b = call i8 @llvm.z80.in(i8 17)
  %c = add i8 %a, %b
  ret i8 %c
}
