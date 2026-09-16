---
name: feedback_zx0_optimize_compressed_not_raw
description: For ZX0-compressed PROMs (autoload) optimize COMPRESSED size, not raw bytes — raw-size codegen wins can INCREASE compressed size.
metadata:
  type: feedback
---

**HARD for the autoload 2 KB grind:** the PROM payload is ZX0-compressed, so the
metric is **compressed** bytes, never raw. Raw-size codegen improvements can make
the compressed PROM BIGGER, because ZX0 compresses highly-repetitive byte runs to
near-nothing while high-entropy sequences cost their full length.

**Why / measured (2026-09-16):** restoring `x<<7 -> rrca; and $80` (−4 raw B, a
genuine general codegen win) made autoload **2071 -> 2073** (compressed 1952 ->
1954, +2). The replaced `add a,a` ×7 is seven identical `0x87` bytes → ZX0-free;
`rrca; and 0x80` is three varied incompressible bytes. Same class as #232 (LSR:
raw −1 B but ZX0 +13 B). Reverted the shl7 change for autoload.

**How to apply:** before touching codegen for the autoload 2 KB goal, measure the
COMPRESSED delta (`wc -c clang/text_compressed.zx0` / `prom.clang.bin`), not raw
`.text`. A per-function raw-size diff (e.g. the +39 raw B vs pre-PR#40 baseline)
OVERSTATES the compressed regression — `add a,a`/repeated-byte chains cost ~0
compressed. Real compressed savings come from reducing HIGH-ENTROPY content or the
number of distinct operations, or from source/algorithmic reduction — not from raw
peephole byte-shaving. See [[project_rc702_2kb_prom_hard_limit]],
`llvm-z80/tasks/analysis-autoload-over-2kb-after-pr40-2026-09-16.md`.
