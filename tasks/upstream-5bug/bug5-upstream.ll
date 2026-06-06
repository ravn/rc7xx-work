target datalayout = "e-p:16:8-i16:8-i32:8-i64:8-n8:16"

define void @copy8(ptr %dst, ptr %src) {
  call void @llvm.memcpy.p0.p0.i16(ptr align 8 %dst, ptr align 8 %src, i16 8, i1 false)
  ret void
}

declare void @llvm.memcpy.p0.p0.i16(ptr, ptr, i16, i1)
