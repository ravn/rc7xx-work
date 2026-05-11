---
name: Volatile blocks clang's loop-idiom recognition
description: Default-add volatile is a footgun on clang Z80 — it disables LoopIdiomRecognize entirely for the affected store, blocking memcpy/memset/LDIR-overlap pattern lowering. Only mark stores volatile when there's a real concurrent-access or memory-mapped-IO reason.
type: feedback
originSessionId: d49656b8-663b-4e0e-91a6-0a48af163349
---
**LLVM's `LoopIdiomRecognize::isLegalStore` rejects volatile stores
unconditionally** (line 461 of
`llvm/lib/Transforms/Scalar/LoopIdiomRecognize.cpp`):

```cpp
if (SI->isVolatile())
    return LegalStoreKind::None;
```

On clang Z80 this matters because LIR is the pass that converts:
- `for (i=0; i<n; i++) p[i] = 0;` → `memset(p, 0, n)` → LDIR
- `for (n=N; n; --n) *p++ = const16;` → `store + memcpy-with-overlap`
  → LDIR-overlap (the Z80 pattern-fill idiom)

If the pointer is `volatile`, all of these stay as per-iteration
loops — typically 4-8 B per iteration of loop overhead that LDIR
collapses to a 2-byte instruction.

**Why this matters on Z80 specifically:** the LDIR/LDDR/CPIR
instructions are sub-byte loop replacements (1 byte + 2-byte
prefix), so missing the pattern recognition is a multi-byte loss
per loop instance.  On register-rich ISAs the loop form costs
maybe 4-6 instructions; on Z80 with `+static-stack` it costs
3 B per BSS spill across calls and runs in tens of cycles per
iteration instead of 16-23 T-states per byte for LDIR.

**When `volatile` IS correct:**

- Memory-mapped I/O (port-mapped already uses `_port_out`, not
  pointer stores).
- ISR-shared state where the ISR writes and the mainline reads
  (or vice versa).  E.g. `pio_rx_head/tail`, `kbd_head/tail`,
  `cur_dirty` — these MUST be volatile for correctness.
- Memory regions whose contents change due to hardware (DMA target
  buffers, etc.).

**When `volatile` is unnecessary / a footgun:**

- Local pointers used only in single-actor cold-init code (no
  ISRs active yet, no concurrent CPU activity).  Setting up an
  IVT, copying a payload, zeroing BSS — all run before EI/IM2.
- Stack-local scratch variables.
- Function parameters used only as iteration cursors.

**How to apply (cpnos-rom specific):**

- Audit init.c, cpnos_main.c, relocator.c for `volatile` on local
  pointers / scratch.  If the function runs before interrupts are
  enabled, drop the qualifier.  Each removed volatile that touches
  a stride-loop unblocks LIR.

- Example fix: `setup_ivt`'s local `volatile uint16_t *ivt` →
  `uint16_t *ivt`.  Saves 3 B INIT_CODE (commit `4da684d`,
  2026-05-10) and lets clang emit the LDIR-overlap idiom for the
  18-word fill loop.

**Verification:**

If you suspect a loop is missing LIR optimization due to volatile,
test by removing the qualifier in a copy and re-compiling:

```bash
clang --target=z80 -Oz ... -S -emit-llvm file.c -o file.ll
grep -E "memcpy|memset|memmove" file.ll
```

A successful conversion will show `call void @llvm.memset.*` or
`call void @llvm.memcpy.*` instead of the manual store loop.
