# sdcccall Calling Conventions (z88dk/sdcc for Z80)

## sdcccall(1) — Register-based (used by this project)

Selected via `--sdcccall 1`. Parameters passed in registers when possible.

### Parameter Passing

For functions without variable arguments:

| 1st param | 2nd param | Rule |
|-----------|-----------|------|
| 8-bit → **A** | 8-bit → **L** | Both in registers |
| 8-bit → **A** | 16-bit → **DE** | Both in registers |
| 16-bit → **HL** | 16-bit → **DE** | Both in registers |
| 16-bit → **HL** | 8-bit → **stack** | 2nd goes on stack! |
| 32-bit → **HLDE** | — | No room for 2nd |
| any | 3rd+ param | **Stack** (right-to-left) |

**Struct/union parameters and all parameters after them are always passed on the stack.**

### Experimentally Verified (z88dk sdcc 4.5.0, `--sdcccall 1 --fomit-frame-pointer`)

All combinations tested with `test_sdcccall.c` — compile and inspect listing:
```
make -f /dev/null test_sdcccall  # or see test_sdcccall.c for standalone build command
```

| Signature | 1st | 2nd | 3rd | IX? |
|-----------|-----|-----|-----|-----|
| `(u8)` | A | — | — | No |
| `(u16)` | HL | — | — | No |
| `(u8, u8)` | A | L | — | No |
| `(u8, u16)` | A | DE | — | No |
| `(u16, u8)` | HL | **stack** | — | **Yes** |
| `(u16, u16)` | HL | DE | — | No |
| `(u8, u8, u8)` | A | L | **stack** | **Yes** |
| `(u8, u8, u16)` | A | L | **stack** | **Yes** |
| `(u8, u16, u8)` | A | DE | **stack** | **Yes** |
| `(u16, u16, u16)` | HL | DE | **stack** | **Yes** |

**Key insight**: The 2nd parameter only goes in a register when:
- 1st is 8-bit (A), 2nd is 8-bit → **L**
- 1st is 8-bit (A) or 16-bit (HL), 2nd is 16-bit → **DE**

When 1st is 16-bit (HL) and 2nd is 8-bit, there is **no register available** —
the 2nd param goes on the stack and requires IX to access.

### Return Values

| Size | Register |
|------|----------|
| 8-bit | **A** |
| 16-bit | **DE** |
| 24-bit | **LDE** |
| 32-bit | **HLDE** |

### Optimization Guidelines

To minimize stack operations (and avoid IX/IY-relative addressing):

1. **Max 2 parameters per function** — 3rd+ always go on stack
2. **Put the 8-bit param first** — unlocks L for the 2nd 8-bit param
3. **Avoid `(u16, u8)`** — the only 2-param form that uses stack
4. **Move excess params to globals** — safe when there's no recursion

Optimal 2-param signatures (no stack access):
```
(u8, u8)   → A, L
(u8, u16)  → A, DE
(u16, u16) → HL, DE
```

Problematic (uses stack even with only 2 params):
```
(u16, u8)  → HL, stack  ← avoid this!
```

Example (this project):
```c
// BAD: 3rd param goes on stack → IX-relative access
void dbg_trace4(uint8_t type, uint8_t p1, uint16_t p2);

// GOOD: 2 params in registers, 3rd moved to global
static uint16_t dbg_p2;
void dbg_trace4(uint8_t type, uint8_t p1);
```

## CP/M BIOS ABI vs sdcccall(1)

CP/M passes BIOS parameters in BC and expects returns in A (8-bit) or HL
(16-bit). This creates mismatches with sdcccall(1):

| | CP/M | sdcccall(1) | Match? |
|---|---|---|---|
| 8-bit param | C (or E) | **A** | No |
| 16-bit param | BC | **HL** | No |
| 8-bit return | A | **A** | **Yes** |
| 16-bit return | HL | **DE** | No |

### `__z88dk_fastcall` — single param in HL, return in HL

`__z88dk_fastcall` overrides the sdcccall convention for a single function.
It accepts exactly one parameter and passes it in HL (8-bit in L, 16-bit in
HL, 32-bit in DEHL). Return values also use HL (not DE as in sdcccall(1)).

```c
uint16_t foo(uint16_t x) __z88dk_fastcall;
/* param: HL, return: HL */

uint8_t bar(uint8_t x) __z88dk_fastcall;
/* param: L, return: L (note: NOT A as in sdcccall(1)) */
```

**Experimentally verified** (z88dk sdcc 4.5.0):
- 16-bit return is in HL (not DE) — matches CP/M convention
- Identity functions (`return param`) optimize to a bare RET
- Only one parameter allowed — additional params cause a compile error
- 8-bit return is in L (not A) — does NOT match CP/M for 8-bit returns

#### Use for CP/M 16-bit returns

CP/M expects 16-bit BIOS returns in HL. sdcccall(1) returns in DE.
`__z88dk_fastcall` returns in HL, bridging the gap:

```c
/* sdcccall(1): returns in DE — needs EX DE,HL glue */
uint16_t bios_seldsk_c(uint8_t drive);

/* __z88dk_fastcall: returns in HL — matches CP/M directly */
uint16_t seldsk_fc(uint8_t drive) __z88dk_fastcall {
    /* drive arrives in L, return value goes in HL */
    return dpbase_addr;   /* HL = disk_parameter_header pointer, matches CP/M */
}
```

**Limitation**: CP/M params arrive in BC, not HL. For entries that receive
BC *and* return HL (e.g., `bios_seldsk`, `bios_sectran`), a small asm stub
is still needed to move BC→HL before calling the `__z88dk_fastcall` function,
or to move BC to a global and let the C code ignore the param register.

**Warning for 8-bit returns**: `__z88dk_fastcall` returns 8-bit in L, not A.
CP/M reads A. Do not use `__z88dk_fastcall` for functions like `bios_const`
that return 8-bit status — use normal sdcccall(1) which returns in A.

### Implications for asm stubs

| BIOS entry | Params | Return | Asm needed? |
|------------|--------|--------|-------------|
| `bios_const` | none | A | No (8-bit return matches) |
| `bios_conin` | none | A | Ring buffer logic + HALT |
| `bios_listst` | none | A | No (8-bit return matches) |
| `bios_reads` | none | A | No (8-bit return matches) |
| `bios_settrk` | BC→var | none | Yes (BC≠HL) |
| `bios_setsec` | BC→var | none | Yes (BC≠HL) |
| `bios_setdma` | BC→var | none | Yes (BC≠HL) |
| `bios_seldsk` | C=drive | HL=disk_parameter_header | Yes (BC param + HL return) |
| `bios_sectran` | BC=sec | HL=sec | Yes (BC→HL identity) |
| `bios_read` | none | A | Stack switch needed |
| `bios_write` | C=type | A | Stack switch needed |
| Stubs (5) | none | none | Bare RET |

Functions returning only 8-bit in A with no params (`bios_const`, `bios_listst`,
`bios_reads`) could theoretically be plain C — sdcccall(1) 8-bit return is in A,
matching CP/M. But `bios_const` needs volatile access patterns and `bios_listst`/
`bios_reads` are single-instruction stubs where C adds overhead.

### Impact: functions that require asm wrappers

Of 14 `__naked` BIOS entry points, the reasons for asm break down as:

**BC parameter mismatch (4 functions)** — would be pure C if sdcccall accepted BC:
- `bios_settrk` — `{ cpm_track = track; }` (currently `ld (cpm_track),bc; ret`)
- `bios_setsec` — `{ cpm_sector = sector; }` (currently `ld (cpm_sector),bc; ret`)
- `bios_setdma` — `{ cpm_dma_addr = addr; }` (currently `ld (cpm_dma_addr),bc; ret`)
- `bios_sectran` — `{ return sector; }` (currently `ld h,b; ld l,c; ret`)

**Stack switch required (5 functions)** — must run on BIOS stack (0xF500), not
caller's stack. Even with BC as a parameter, these need asm for the SP swap:
- `bios_conout` — stack switch + `ld a,c` (char from C register)
- `bios_seldsk` — stack switch + `ld a,c` (drive from C register)
- `bios_write` — stack switch + `ld a,c` (write type from C register)
- `bios_home` — stack switch only (no params)
- `bios_read` — stack switch only (no params)

**Non-returning entry points (2 functions)** — set SP then JP, no return:
- `bios_boot` — `ld sp,#0xF500; jp _bios_boot_c`
- `bios_wboot` — `ld sp,#0xF500; jp _wboot_c`

**Other ABI mismatches (3 functions)** — params/returns in unusual registers:
- `bios_linsel` — params in A (port) and B (line), not sdcccall registers
- `bios_exit` — params in HL (callback) and DE (timer), 2×16-bit non-standard
- `bios_clock` — params/returns in DE+HL, conditional on A

The 5 stack-switch wrappers are the largest source of asm (~100 bytes total).
A compiler extension for "run on alternate stack" would eliminate them entirely.

## sdcccall(0) — Stack-based (legacy, NOT used)

All parameters passed on the stack, right-to-left.

| Size | Return register |
|------|----------------|
| 8-bit | **L** |
| 16-bit | **HL** |
| 24-bit | **EHL** |
| 32-bit | **DEHL** |

**WARNING**: sdcccall(0) and sdcccall(1) are ABI-incompatible. Library functions
compiled with sdcccall(0) will silently produce wrong results when called from
sdcccall(1) code. The Makefile checks for this (div/mod/mul guard).

## `__interrupt` Epilogue — RETN vs EI+RETI

**The `(N)` vector number in `__interrupt(N)` controls the ISR epilogue.**
Omitting it changes the generated return instruction, with fatal consequences.

| Declaration | Prologue | Epilogue | Correct? |
|---|---|---|---|
| `__critical __interrupt(N)` | push AF,BC,DE,HL,IY | `EI; RETI` | **Yes** — re-enables interrupts |
| `__critical __interrupt` | push AF,BC,DE,HL,IY | `RETN` | **FATAL** — interrupts stay disabled |
| `__interrupt(N)` | `EI;` push AF,BC,DE,HL,IY | `RETI` | Risky — EI before saves allows nesting |
| `__interrupt` (bare) | `EI;` push AF,BC,DE,HL,IY | `RETI` | Same risk as above |

**Why `RETN` is fatal**: On the Z80, `RETN` copies IFF2→IFF1 but does not
set either flag.  If interrupts were disabled when the ISR was entered
(which `__critical` ensures), `RETN` returns with interrupts still disabled.
On the RC702, all I/O — keyboard, floppy, serial — is interrupt-driven.
The system freezes after the first ISR fires.

**Why `EI` at entry is wrong**: `__interrupt(N)` without `__critical` puts
`EI` as the very first instruction, before pushing registers.  This allows
a second interrupt to fire immediately, before the first ISR has saved its
context.  For ISRs that share `sp_sav` (the stack-switch variable) or
program the DMA controller, nested interrupts corrupt state.

**RC702 hardware requirement**: The RC702 requires interrupts to be disabled
throughout all interrupt handlers — always.  There is no case where nested
interrupts are safe.  Therefore `__critical` is mandatory on every ISR.

**Correct pattern for this project**: `__critical __interrupt(N)` —
interrupts disabled throughout, `EI; RETI` at the end.

### Experimentally verified (z88dk sdcc 4.5.0)

```
__critical __interrupt(1)  →  push regs ... pop regs; EI; RETI  (0xFB 0xED4D)
__critical __interrupt     →  push regs ... pop regs; RETN       (0xED45)
__interrupt(1)             →  EI; push regs ... pop regs; RETI  (0xFB ... 0xED4D)
__interrupt                →  EI; push regs ... pop regs; RETI  (0xFB ... 0xED4D)
```

The bare `__interrupt` (no number) behaves identically to `__interrupt(N)` —
both generate `EI` at entry and `RETI` at exit.  The `(N)` only matters
when combined with `__critical`, where it switches from `RETN` to `EI; RETI`.

**Rule: every `__interrupt` in this project must include `(N)`.**

## No-Recursion Optimization

Since this BIOS has no recursion (see `STACK_ANALYSIS.md`), all local variables
can be declared `static`. This eliminates stack-allocated locals entirely:

- No IX/IY frame pointer setup
- Direct memory addressing instead of IX-relative
- Stack depth reduced to return addresses only (~2 bytes per call level)

The Makefile enforces this with a build guard that fails if any `ix[+-]` or
`iy[+-]` patterns appear in the compiler listing.

## Inlining

sdcc has **no automatic inlining** at any optimization level. Functions are only
inlined when explicitly marked `static inline` and compiled with `--std-sdcc99`.

Via z88dk: `-Cs"--std-sdcc99"`

### Behavior

- `static inline` expands the function body at each call site
- The original function is eliminated if all calls are inlined
- `__sdcccall(1)` conventions are irrelevant for inlined code (parameters become
  ordinary variables handled by the register allocator)
- `--opt-code-size` does **not** suppress inline expansion

### Cost/benefit (experimentally verified)

Each inlined call saves 27 T-states (CALL=17 + RET=10) but costs ~6 bytes
(inline body minus the eliminated CALL instruction, plus the RET is gone).

| What was inlined | Calls | Size delta |
|------------------|-------|------------|
| `clfit` + `watir` | 14 | +60 bytes |
| `fdc_wait_write` + `fdc_wait_read` | 18 | +70 bytes |
| 6 small functions | ~40 | +159 bytes |

### Per-function inlining analysis

Each function was evaluated for inlining based on: body size (bytes), number of
call sites, whether it's on a hot path (disk I/O), and net size impact.

**Inlined (speed-critical hot path):**

| Function | Body | Calls | Why inline |
|----------|------|-------|------------|
| `fdc_wait_write` | 9B | 15 | FDC status polling loop, called before every register write. 27 T-states saved per FDC access. +70B total for both. |
| `fdc_wait_read` | 9B | 3 | FDC status polling loop, called before every register read. Same reasoning. |

**Not inlined (size cost too high or no speed benefit):**

| Function | Body | Calls | Why not |
|----------|------|-------|---------|
| `fdc_irq_arm` | 7B | 11 | 3 instructions (DI, store, EI). 11 call sites × ~4B = +44B for negligible speed gain — not on a tight loop. |
| `fdc_irq_wait` | 5B | 3 | Busy-wait on `fdc_irq_fired`. Only 3 calls, but the wait itself dominates — saving 27T on entry is meaningless vs thousands of loops. |
| `fdc_irq_wait_rearm` | 6B | 8 | Calls `fdc_irq_wait` + `fdc_irq_arm`. Inlining would expand both, compounding size cost. |
| `fdstop` | 8B | 1 | Called once — no benefit from inlining. |
| `fdc_recalibrate` | ~20B | 2 | Too large to inline, and not called in the sector read/write hot path. |
| `fdc_sense_int` | ~30B | 2 | Too large, contains a loop. |
| `flp_dma_setup` | ~40B | 2 | Large function with many port writes. |
| `wrthst`/`rdhst` | ~15B | 4/1 | Wrappers that call other functions — inlining saves nothing. |

**Decision rule:** Only inline functions where (a) the body is smaller than ~10 bytes,
(b) the function is called in a tight timing-critical loop, and (c) the CALL/RET
overhead (27 T-states) is significant relative to the function body execution time.

### Other compiler tuning (already maxed out)

| Setting | Value | Notes |
|---------|-------|-------|
| `--max-allocs-per-node` | 1000000 | Register allocator search depth (default 3000). Diminishing returns above ~200000. |
| `-SO3` | max | Highest z88dk optimization level. |
| `--fomit-frame-pointer` | on | Avoids IX as frame pointer. |
| `--allow-unsafe-read` | on | Enables some memory access optimizations. |
| `--opt-code-size` | on | Prefers smaller sequences (subroutine calls for stack frame setup). |
| `--std-sdcc99` | on | Enables `inline` keyword support. |
| Unity build | yes | All code in single `bios.c` gives sdcc full cross-function visibility. |

sdcc has no `-finline-functions`, no inline threshold, no automatic inlining at
any optimization level. The `inline` keyword is the only mechanism.

`--stack-auto` has no effect on Z80 (8051-only feature).
