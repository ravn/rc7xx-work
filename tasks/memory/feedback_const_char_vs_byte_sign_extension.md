---
name: feedback_const_char_vs_byte_sign_extension
description: const char* vs const byte* in comparison functions causes sign-extension in Z80 codegen — compiler emits 16-bit promoted comparisons instead of direct byte compare
metadata:
  type: feedback
---

When a function takes `const char *` (signed) and compares it byte-by-byte with
`const byte *` (unsigned), the C standard requires integer promotion before comparison.
On Z80 with clang, this causes the compiler to sign-extend the `char` to `int` (16-bit)
before comparison — producing complex BSS-spilling code instead of a simple
`ld a,(de); cp (hl)` loop.

**Example (autoload `check_sysfile`):**

Before fix (40 B in c863c55 → 87 B in current):
```c
static byte check_sysfile(const byte *dir, const char *pattern) {
    if (*dir++ != *pattern++) ...  // mixed sign → sign-extension → complex codegen
```

After fix (87 B → ~40 B):
```c
static byte check_sysfile(const byte *dir, const byte *pattern) {
    if (*dir++ != *pattern++) ...  // both unsigned → direct comparison
```

Callers with string literals need explicit cast:
```c
check_sysfile(dir, (const byte *)"SYSM")
```

**Rule:** For byte-comparison loops in Z80 firmware, BOTH pointer parameters must be
`const byte *` (unsigned char). Even `const char *` for ASCII-only data will cause
the compiler to generate sign-extension overhead.

**Fix applied:** `autoload-in-c/rom.c` commit 805805d (2026-10-09). Saved 43 B PROM.
