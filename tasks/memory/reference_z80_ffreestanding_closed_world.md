---
name: reference-z80-ffreestanding-closed-world
description: Historical design: -ffreestanding once enabled closed-world Z80 static-frame analysis; this behavior is absent in compiler d6658ad
metadata:
  type: reference
---

## Status: historical behavior, not a current recipe

An earlier compiler revision emitted a `"Freestanding"` module flag and
`Z80NonReentrant` used it as a closed-world signal. In the inspected compiler
`d6658ad`, Clang does not emit that module flag and `Z80NonReentrant` does not
read it. Do not rely on `-ffreestanding` to enable static-frame allocation in
that compiler.

The current frame-lowering gate is `+static-frame` plus a function-level
`"nonreentrant"` attribute, with eligibility established by the current
`Z80NonReentrant` analysis. A function-level `target("no-recurse")` assertion
is a context barrier, but is only valid when that function truly cannot have
overlapping activations.

The former e-benchmark numbers in this file were measured with the earlier
closed-world implementation and are revision-specific; they are not a current
`-ffreestanding` performance guarantee.
