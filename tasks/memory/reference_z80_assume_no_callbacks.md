---
name: reference-z80-assume-no-callbacks
description: Historical experiment: -z80-assume-no-callbacks is absent from compiler d6658ad and is not a current invocation option
metadata:
  type: reference
---

## Status: historical, removed from current compiler

The `-z80-assume-no-callbacks` switch described below was used in an
intermediate static-frame experiment. It is not implemented in the inspected
compiler `d6658ad` (no option or implementation is present in the current
Z80 target sources). Do not use the old command as a current build recipe.

The old experiment treated indirect calls as unable to re-enter the module,
so externally linked entry points could be promoted without changing
`__STDC_HOSTED__`. That whole-module assumption is not present in the current
analysis. The current per-function `target("no-recurse")` feature is a
different, explicit assertion: it is valid only for functions that cannot
have overlapping activations.

The historical benchmark and invocation are retained below for provenance;
their results apply only to the revision that contained the switch.

### Historical behavior

The switch caused `Z80NonReentrant` to treat indirect calls as reaching only
locally address-taken functions, rather than every externally callable
function. It did not alter hosted-C language semantics.

Historical zcc invocation:

```bash
zcc +cpm -compiler=llvmz80 -O2 \
  -Cg-Xclang -Cg-target-feature -Cg-Xclang -Cg+static-frame \
  -Cg-mllvm -Cg-z80-assume-no-callbacks \
  -o prog prog.c
```

See [[reference_z80_ffreestanding_closed_world]] for the related historical
closed-world design and its current status.
