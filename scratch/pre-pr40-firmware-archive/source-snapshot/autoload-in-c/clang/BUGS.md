# LLVM-Z80 Backend Bugs Found

## Bug 1: address_space(2) crashes Legalizer

**Symptom**: `fatal error: unable to legalize instruction: G_LOAD ... addrspace 2`

**Trigger**: Using `__attribute__((address_space(2)))` pointer dereference for port I/O:
```c
#define __io __attribute__((address_space(2)))
return *(volatile __io byte *)(byte)(addr);  // crashes
```

**Workaround**: Use inline assembly for port I/O:
```c
#define port_in(port) \
    ({ byte _v; __asm__ volatile("in a, (" _XSTR(port) ")" : "=a"(_v)); _v; })
```

**Pass**: Legalizer (GlobalISel)

---

## Bug 2: "hl" inline asm constraint crashes IRTranslator

**Symptom**: `fatal error: unable to translate instruction: call (in function: z80_set_sp)`

**Trigger**: Using `"hl"` as an inline assembly input constraint:
```c
static inline void z80_set_sp(word addr) {
    __asm__ volatile("ld sp, hl" : : "hl"(addr));  // crashes
}
```

**Workaround**: Use a macro with stringified immediate:
```c
#define z80_set_sp(addr) __asm__ volatile("ld sp, " #addr)
```

**Pass**: IRTranslator (GlobalISel)

---

## Non-bug: Known Backend Weakness

**Bit test generates clunky code**: `status & 0x80` produces:
```asm
xor  128
ld   c,a
ld   a,255
xor  128
cp   c
jr   c,...
```
Instead of optimal: `bit 7,a; jr z,...` (2 bytes vs 8 bytes)
