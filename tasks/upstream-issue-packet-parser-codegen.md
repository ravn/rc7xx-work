# [Z80] Closing the code density gap on CISC loops: 118 B (.bss: 4 B) -> 67 B (.bss: 0 B) vs 63 B optimal asm

Using `packet-parser.c` as a benchmark, we investigated the code density gap between LLVM-Z80 and hand-crafted assembly on byte loops with stack parameters and in-place updates. Addressing five interaction points between mid-end passes and the backend reduces code size from **118 B + 4 B .bss** in upstream `main` to **67 B + 0 B .bss** under `-Os` (100% lit and e2e runtime testsuite pass).

This matches the **67-byte theoretical minimum for compliant C** (the 4-byte delta to 63-byte pure assembly is standard callee-saved `push ix` / `pop ix`).

---

### Progression & Inner Loop Comparison

| Target | Text Size | Static `.bss` | Inner Loop Size | Loop Test | In-place Updates |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Upstream `main`** | 118 bytes | 4 bytes | ~65 bytes | Stack reloads | Separate load/store via RAM |
| **Upstream `reimpl`** | 101 bytes | 1 byte | ~65 bytes | Stack reloads | Separate load/store via RAM |
| **Downstream (`-Os`)** | **67 bytes** | **0 bytes** | **16 bytes (`djnz`)** | **1 byte (`cp (hl)`)** | **`set 7,(ix+0)` / `inc (ix+0)`** |
| **Hand-crafted Asm** | 63 bytes | 0 bytes | 14 bytes | 1 byte (`cp (hl)`) | `set 7,(iy+0)` / `inc (iy+0)` |

```z80
; Downstream 16-byte inner loop (hardware djnz, zero stack/RAM access):
.L_loop:
    cp      (hl)            ; 1 B: invariant delim held in accumulator A
    jr      nz, .L_else     ; 2 B
    inc     e               ; 1 B: matches++ in register E
    set     7, (ix+0)       ; 4 B: native CISC in-place bit set
    jr      .L_latch        ; 2 B
.L_else:
    inc     (ix+0)          ; 3 B: native CISC in-place increment
.L_latch:
    inc     hl              ; 1 B: ptr++
    djnz    .L_loop         ; 2 B: hardware loop counter
```

---

### Key Bottlenecks & Architectural Questions

1. **Allocatable `IX` when `!hasFP`:** Reserving `IX` unconditionally starves the allocator of a 16-bit pointer register, forcing `flags` to the stack. Un-reserving `IX` when `!hasFP(MF) && !STI.hasSM83()` (with `hasSuperClassEq(&GR16RegClass)` and `RELOAD_ANY16` for stack pointer args) enables `set 7,(ix+0)` and `inc (ix+0)`. Would upstream welcome un-reserving `IX` for pointer allocations when no frame pointer is needed?
2. **CISC Store-Phi Sinking in MachineIR:** Generic `InstCombine` merges conditional stores into a single store at `if.end` fed by a `phi [or, inc]`. This destroys the pattern for in-place CISC instructions and clobbers `A`. Sinking `G_STORE` with `G_PHI` back into predecessor blocks recreates discrete RMW trees. Where would upstream prefer such a CISC de-merging pass in the pipeline?
3. **Loop-Invariant Accumulator Hoisting:** Freeing `A` from the merged store allows `A` to hold loop-invariant `delim` across iterations for `cp (hl)`, which also frees `E` for `matches` and eliminates the static `.bss` frame entirely. Is pre-emit peephole or MachineLICM preferred for this?
4. **Loop Latch Rotation & `BReg` for `DJNZ`:** Block layout inversion (latch placed before header with conditional exit on zero) and Greedy RA assigning `B` to other values prevent hardware `djnz`. Rotating inverted latches and constraining countdown loop counters to `BReg` reliably unlocks `djnz`. Would upstream welcome target-level block placement tuning or pre-RA counter splitting?
5. **Preheader Reload Hoisting & Stack Coalescing:** `MachineSink` sinks stack argument reloads into loop preheaders, splitting them from earlier argument reloads in dominating predecessors (like `len` before `len == 0`). Hoisting them back allows `reuseLDHLAddress` to coalesce all 4 parameters into a single `add hl, sp; ld b,(hl); inc hl; ...` stream (saving 4 B). Would upstream prefer preheader reload hoisting or tuning `shouldSink`?

We would appreciate your thoughts on which of these areas you would like to explore or how you prefer to structure them in upstream.
