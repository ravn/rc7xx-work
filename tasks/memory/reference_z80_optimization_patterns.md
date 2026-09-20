---
name: reference-z80-optimization-patterns
description: Non-upstreamed optimization advice, compiler idioms, remarks, and rules for writing optimal C code for llvm-z80
type: reference
---

# LLVM-Z80 C Optimization & Programming Guide (Internal Reference)

This document collects key optimization guidelines, compiler behavior nuances, and diagnostic tips for `llvm-z80`.

**Note:** This file lives under `tasks/memory/` and is strictly internal to the workspace. It is **not** part of any upstream PR to `llvm-z80/llvm-z80`.

---

## 1. Loops: Use Countdown Loops for DJNZ

The Z80 features the `DJNZ` (*Decrement and Jump if Not Zero*) instruction:
* Decrements register `B` and branches in a single 2-byte instruction (13 T-states taken / 8 T-states fallthrough).
* Saves 3 T-states and 1 byte per iteration over `DEC r; JR NZ` (16 T-states, 3 bytes).
* **Hardware restriction:** `DJNZ` only operates on register `B` and only decrements towards zero.

### Countdown loops
Compilers for modern architectures do not automatically mirror upward loops (`0..N-1`) to countdown loops. To ensure `DJNZ` is emitted, write countdown loops explicitly:

```c
// Recommended: Emits DJNZ on register B
uint8_t n = 50;
do {
    *port = 0;
} while (--n);

// Suboptimal: Emits INC r; CP N; JR NZ (3 instructions, slower and larger)
for (uint8_t i = 0; i < 50; i++) {
    *port = 0;
}
```

### Nested countdown loops
* `llvm-z80` (with `Z80SplitDjnzCounters`) automatically assigns register `B` to the **innermost (hot)** loop via live-range splitting, giving it `DJNZ`.
* The outer loop counter is allocated to another register (such as `C`) and decremented using standard `DEC` and conditional jumps.
* Keep the inner loop counter within 8 bits (`uint8_t`), so it fits in `B`.

```c
void nested_delay(uint8_t outer, uint8_t inner) {
    do {
        uint8_t j = inner;
        do {
            // Hot inner loop: uses DJNZ
            *port = 0;
        } while (--j);
        // Outer loop: uses DEC C; JR NZ
    } while (--outer);
}
```

---

## 2. Memory Access: Pointer Stepping over Array Indexing

The Z80 has only one flexible 16-bit memory pointer register (`HL`). Array indexing with arbitrary offsets (e.g. `buf[i]`) forces 16-bit pointer arithmetic (`ADD HL, rr`) or slow indexed addressing via `IX`/`IY` (`LD A, (IX+d)` costs 19 T-states and 3 bytes).

### Prefer pointer-stepping:
```c
// Recommended: Emits "INC HL" (6 T-states, 1 byte) per iteration
void clear_buffer(uint8_t *buf, uint8_t count) {
    do {
        *buf++ = 0;
    } while (--count);
}

// Suboptimal: Computes (buf + i) each iteration or spills pointers to stack
void clear_buffer(uint8_t *buf, uint8_t count) {
    for (uint8_t i = 0; i < count; i++) {
        buf[i] = 0;
    }
}
```

---

## 3. Data Types: Prefer 8-bit and Unsigned

* **Use `uint8_t` by default:**
  Z80 is an 8-bit CPU. Every 16-bit integer operation (`uint16_t`, `int`) requires twice as many instructions and uses up two 8-bit registers or a register pair.
* **Prefer `unsigned` types:**
  Signed comparisons (`<`, `<=`) require parity/overflow and sign flag analysis on Z80. Unsigned comparisons against zero or carry are direct and zero-cost.
* **16-bit `int` size:**
  On Z80, `sizeof(int) == 2` (16-bit).

---

## 4. Arithmetic: Avoid Arbitrary Multiplication, Division, and Variable Shifts

* **No hardware multiplier:**
  Multiplication (`*`) and division (`/`, `%`) lower to runtime library helper calls (`__mulqi3`, `__divhi3`, etc.). A single 16-bit multiplication can take hundreds of T-states and clobbers working registers.
* **Use powers of two:**
  Multiplications and divisions by powers of two (`x * 4`, `x / 8`) are converted by LLVM into direct 1-bit shifts or additions (`ADD HL, HL`, `SRL`).
* **Variable shifts (`x << n`) are expensive:**
  The Z80 can only shift by 1 bit at a time. Shifting by a variable amount `n` lowers to a runtime loop. Keep bit shifts to small constant amounts (`1`, `2`, or `3`).

---

## 5. Block Transfers: Use `memcpy` (or `restrict`) for `LDIR`

`llvm-z80` recognizes standard `<string.h>` operations and emits hardware block instructions:
* `memcpy` is folded directly into the Z80 hardware block transfer instruction **`LDIR`** or **`LDDR`** (21 T-states per byte transferred entirely in hardware).
* `memset` with a constant value is similarly optimized.

### Why hand-written loops miss `LDIR` without `restrict`:
Due to C standard pointer aliasing rules, a loop like `while (n--) *dst++ = *src++;` cannot be safely folded to `LDIR` because `dst` and `src` might overlap. Unless pointers are qualified with `restrict`, the compiler is forced to emit a byte-by-byte copy loop.

Calling `memcpy(dst, src, n)` explicitly guarantees non-overlapping buffers to the compiler, allowing it to emit `LDIR` immediately. If hand-writing loops, qualify arguments with `restrict`:

```c
// Recommended: Emits hardware LDIR directly
memcpy(dst, src, n);

// Also emits LDIR (compiler proves no overlap via restrict)
void copy_buf(char * __restrict dst, const char * __restrict src, size_t n) {
    for (size_t i = 0; i < n; i++)
        dst[i] = src[i];
}

// Suboptimal: Emits slow manual byte-by-byte loop due to potential aliasing
void copy_buf(char *dst, const char *src, int n) {
    while (n--)
        *dst++ = *src++;
}
```

---

## 6. Bit Manipulations: Direct Bit Tests

Testing a single bit via bitwise AND with a constant power-of-two (e.g. `flags & (1 << 3)`) is lowered directly to the Z80 hardware instruction **`BIT n, r`** (8 T-states, 2 bytes).

Avoid shifting before testing:
```c
// Recommended: Emits "BIT 3, A" (8 T-states, 2 bytes)
if (flags & 0x08) { ... }

// Suboptimal: Emits multiple shift instructions before testing
if ((flags >> 3) & 1) { ... }
```

---

## 7. Calling Conventions and Function Arguments

* **Default convention:** `llvm-z80` implements `__sdcccall(1)` by default, passing arguments in registers (`A`, `HL`, `DE`, `BC`) where possible.
* **Limit argument count:** Keep function signatures to 1–3 arguments. Passing 4 or more arguments exhausts available registers and forces arguments onto the stack, adding `PUSH`/`POP` and frame index overhead.

---

## 8. GCC Builtins are 16-bit

Builtin counting and bitwise functions evaluate across 16-bit words by default:
* `__builtin_clz(x)`, `__builtin_ctz(x)`, `__builtin_popcount(x)`, `__builtin_ffs(x)` evaluate over **16 bits**.
* If 32-bit evaluation is required, explicitly invoke the `l`-suffixed builtins: `__builtin_clzl(x)`.

---

## 9. Floating-Point: Single-Precision Only

On Z80, `float`, `double`, and `long double` are all **32-bit IEEE-754 binary32**. All floating-point operations lower to single-precision software emulation library routines.

---

## 10. Optimization Remarks / Diagnostics (`-Rpass`)

To diagnose why LLVM failed to optimize a particular loop or construct:

* **Missed optimizations (with explanations):**
  ```bash
  clang --target=z80 -O2 -Rpass-missed=.* -Rpass-analysis=.* file.c
  ```
* **Specific to loop idioms (e.g. why `memcpy` / `LDIR` was not emitted):**
  ```bash
  clang --target=z80 -O2 -Rpass-missed=loop-idiom -Rpass-analysis=loop-idiom file.c
  ```
* **Firmware Makefile integration:**
  In `rc700-gensmedet`, you can pass `REMARKS=1` or `REMARKS=loop-idiom`:
  ```bash
  make -C autoload-in-c prom REMARKS=loop-idiom
  make -C rcbios-in-c/clang bios.clang.cim REMARKS=1
  make -C cpnos-in-c cpnos REMARKS=loop-idiom
  ```
