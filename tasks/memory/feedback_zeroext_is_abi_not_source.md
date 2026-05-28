---
name: zeroext-is-abi-not-source
description: "zeroext on a multi-byte integer parameter is an ABI signal (extension to slot width), not a source-narrowness signal — do not trust it as proof that the value's source type was narrower than the IR type"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

`zeroext` on a parameter slot wider than i8 (e.g. `i16 zeroext` on Z80
where int = i16) is an **ABI extension signal**: "the caller has
zero-extended this value to the natural ABI slot width."  It does NOT
imply the source-level type was narrower than the slot.

On Z80 specifically: `uint16_t x` and post-K&R-promotion `uint8_t x`
both produce `define f(i16 noundef zeroext %0)` in IR.  The two are
indistinguishable at the call boundary in current LLVM IR.

**Why:** Session 71 implemented #162 Option 3 (call-boundary trunc-sink
in AggressiveInstCombine) on the assumption that `i16 zeroext` callee
params indicate u8-source narrow-ness, and so high bits of the caller's
arg can be dropped via implicit narrowing.  Result: 318 test-runner
miscompiles, because `dense_map(uint16_t x) { switch (x) { case 1000:
... } }` got its arg narrowed to `i8 trunc(1000) = -24` and the switch
broke.  See [[parked-162-context]] +
https://github.com/ravn/llvm-z80/issues/162#issuecomment-4457134375.

**How to apply:** Any IR-level optimisation that wants to narrow a
value based on `zeroext` MUST also verify the value's high bits are
provably zero via `computeKnownBits` (or another independent source of
narrow-ness proof — explicit `and X, MASK`, upstream `zext from iN`,
range metadata).  The attribute alone is not enough on multi-byte ABI
targets.

The narrow case can be recovered by:

1. A frontend tag (new attribute) that *only* gets emitted on
   K&R-promoted narrow integer params, separate from generic ABI
   zeroext.
2. A per-callee body peek: if the callee starts with `trunc iN %0 to
   iM`, the high (N-M) bits are observably discarded; narrowing at the
   boundary preserves semantics.
3. Tighter KnownBits propagation through rotate-idiom DAGs (the
   `(x<<1)|(x>>7)` shape transiently widens by 1 bit before
   reconstructing).

None of these is a quick patch.

Related: [[reference_z80_tool_paths]], [[feedback_test_before_fix]],
[[feedback_no_commit_first_version]] (value oracle caught the
miscompiles), [[feedback_diff_binaries_before_blaming_codegen]].
