(For llvm/llvm-project. AWAITING per-filing go-ahead. User may prepend
own framing. Supersedes `draft-bug5.md` which led with a Z80-specific
cost claim; AVR triage 2026-06-07 showed the cost argument doesn't
generalise — AVR backend swallows the illegal-width fold as byte traffic
at zero cost.  This v2 draft leads with the internal-consistency
argument, which stands on its own and is what we'd file if anything.)

Title: InstCombine: SimplifyAnyMemTransfer asymmetric with shouldChangeType on `DL.isLegalInteger`

InstCombine is internally inconsistent about whether to introduce
integer operations of widths the target declares non-native.

`InstCombinerImpl::shouldChangeType` — the function the rest of
InstCombine consults before *changing* a value's type — gates on
`DL.isLegalInteger`:

    // InstructionCombining.cpp, current main
    bool InstCombinerImpl::shouldChangeType(unsigned FromWidth,
                                            unsigned ToWidth) const {
      ...
      bool ToLegal = ToWidth == 1 || DL.isLegalInteger(ToWidth);
      ...
    }

`InstCombinerImpl::SimplifyAnyMemTransfer`, by contrast, folds any
1/2/4/8-byte `llvm.memcpy` into a `load iN` + `store iN` *without*
consulting `isLegalInteger`:

    // current main, the relevant arm of SimplifyAnyMemTransfer
    case 1: case 2: case 4: case 8: case 16: case 32:
      IntType = IntegerType::get(MI->getContext(), Size << 3);
      ...
      // create load IntType / store IntType -- no native-width check

Either an `iN` operation is acceptable here regardless of native width
(and `shouldChangeType` is over-conservative), or it is not (and this
fold has a missed gate).  We don't think the former is the considered
position — the contract `shouldChangeType` is enforcing is precisely
"don't create operations the target can't pattern-match in one piece"
— but that's what's load-bearing in this report, not the cost claim of
any one target.

Repro (verified on upstream `de59f9ed`, 2026-06-07; the behaviour is
the function of `SimplifyAnyMemTransfer`'s arm referenced above, no
local patch in the loop):

    target datalayout = "e-p:16:8-i16:8-i32:8-i64:8-n8:16"

    define void @copy8(ptr %dst, ptr %src) {
      call void @llvm.memcpy.p0.p0.i16(ptr align 8 %dst, ptr align 8 %src,
                                       i16 8, i1 false)
      ret void
    }

    declare void @llvm.memcpy.p0.p0.i16(ptr, ptr, i16, i1)

`opt -passes=instcombine -S` produces:

    %1 = load i64, ptr %src, align 8
    store i64 %1, ptr %dst, align 8

The same pass would have refused to *change* an existing value's type
to i64 under this datalayout (`shouldChangeType(_, 64)` returns false
because `n8:16` doesn't include 64).  We think it should refuse to
*introduce* one too.

In-tree exposure: every in-tree target we tried — AVR, MSP430 — lowers
the post-fold i64 byte-traffic cleanly during instruction selection,
so this is a missed-optimisation report, not a miscompile.  No
in-tree target loses real codegen quality from the fold; the report is
about InstCombine being uniform about its own non-native-width
contract.  (Targets without that recovery path do lose codegen quality
— hence the original cost-led framing of this report on an
out-of-tree Z80 backend — but the consistency claim stands without
that evidence.)

Suggested direction: gate the fold on `DL.isLegalInteger(Size * 8)`
(no-op for every in-tree target where the widths it produces are
already native, and uniformly applies the policy `shouldChangeType`
already enforces).

Found while developing an out-of-tree 8-bit (Z80) backend, where the
fold's effect on memcpy lowering motivated the investigation; the
repro and the consistency argument above are target-independent.
