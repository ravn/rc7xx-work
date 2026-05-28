---
name: Always check for undocumented instructions
description: After any compilation, check assembly output for IXH/IXL/IYH/IYL usage without +undocumented flag and file issues
type: feedback
---

After compiling Z80 code, always check for undocumented instruction usage (IXH, IXL, IYH, IYL sub-registers) when +undocumented is not enabled. These are fatal compilation errors — the backend must never generate them without the flag.

**Why:** Multiple bugs found (#33 XOR IXH in XOR_CMP, #37 LD A,IYH for sign-extension). These cause sdasz80 assembler failures and wrong behavior in strict emulators.

**How to apply:** After generating assembly, grep for `ixh|ixl|iyh|iyl` and file an issue if found without +undocumented. This applies to any test compilation, not just the PROM build.
