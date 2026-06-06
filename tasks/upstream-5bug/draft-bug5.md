(For llvm/llvm-project. AWAITING per-filing go-ahead. User may prepend own framing.)

Title: InstCombine folds small memcpy to a load+store of an integer type the target declares non-native, defeating memcpy lowering on 8/16-bit targets

`InstCombinerImpl::SimplifyAnyMemTransfer` folds any 1/2/4/8-byte `llvm.memcpy` into a single `load iN` + `store iN`. The fold never checks whether iN is a native integer width for the target (datalayout `n...`).

On targets whose widest native integer is 8 or 16 bits, the folded `load i64`/`store i64` cannot be matched by any instruction; instruction selection shreds it into 8 byte loads + 8 byte stores. The memcpy it replaced would have lowered to a compact copy sequence or a runtime call (on Z80, `LDIR`: we measured ~28-40 bytes of shredded stores vs ~12 bytes for the `LDIR` form on real 8-byte struct copies at `-Oz`). The fold is profitable only when the integer width is native; when it is not, it destroys the "this is a copy" semantic that the backend would otherwise lower well -- and IR has no way to recover it.

Repro (any build of `opt`, current main):

    target datalayout = "e-p:16:8-i16:8-i32:8-i64:8-n8:16"

    define void @copy8(ptr %dst, ptr %src) {
      call void @llvm.memcpy.p0.p0.i16(ptr align 8 %dst, ptr align 8 %src, i16 8, i1 false)
      ret void
    }

    declare void @llvm.memcpy.p0.p0.i16(ptr, ptr, i16, i1)

`opt -passes=instcombine -S` produces:

    %1 = load i64, ptr %src, align 8
    store i64 %1, ptr %dst, align 8

Note that InstCombine already consults native-width legality for its own type-shrinking decisions (`InstCombinerImpl::shouldChangeType`, built on `DL.isLegalInteger`); this fold seems to be the outlier in not doing so. Gating it on `DL.isLegalInteger(Size * 8)` (no-op for every target where the width is native) would restore the memcpy lowering path on small-integer targets.

Found while developing an out-of-tree 8-bit (Z80) backend; the repro above is target-independent.
