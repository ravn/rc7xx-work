# 4 Codegen-Issues (fra packet-parser analysen)

Disse 4 issues adresserer de resterende 38 bytes overhead i forhold til optimal håndskrevet Z80 assembly i `packet-parser.c`.
Oprettet på `ravn/llvm-z80` den 2026-11-15, og opdateret med dybdegående rodårsagsanalyse og implementeringskøreplan.

- **Issue #431:** [[Z80] Hoist loop-invariant comparison operand into A across pointer loops](https://github.com/ravn/llvm-z80/issues/431)
- **Issue #432:** [[Z80] Keep pointer argument in index register (IX/IY) for in-place memory operations in loops](https://github.com/ravn/llvm-z80/issues/432)
- **Issue #433:** [[Z80] Avoid spilling 8-bit loop match/accumulator counter to static frame (.bss)](https://github.com/ravn/llvm-z80/issues/433)
- **Issue #434:** [[Z80] Coalesce consecutive stack argument loads into sequential SP post-increments](https://github.com/ravn/llvm-z80/issues/434)

---

## Samlet Systemisk Arkitektur & Køreplan (Opdateret 2026-11-15)

Undersøgelsen af maskin-IR (MIR) og Z80 calling conventions viser en direkte årsagssammenhæng mellem alle 4 issues:

1. **z88dk/SDCC runtime-modellen (Issue #432):**
   I z88dk/SDCC er standarden, at det ene indeksregister (typisk `IY`) reserveres til OS/BIOS/runtime, mens det andet (`IX`) frigives til brugerkode.
   I LLVM-Z80 er `IX` allerede defineret som callee-saved i `Z80CallingConv.td` (`Z80_CSR = (add IX)`). PrologEpilogInserter (PEI) gemmer og genskaber automatisk `IX` med `push ix` / `pop ix`.

2. **Hvorfor `IX` var blokeret:**
   - `Z80RegisterInfo.cpp:121` satte `Reserved.set(Z80::IX)` ubetinget, selv når en funktion ikke bruger frame pointer (`!hasFP(MF)`).
   - `Z80InstrInfo.cpp::copyPhysReg` manglede 16-bit `push/pop` kopier mellem `GR16` (`HL/DE/BC`) og `IX`.

3. **Kaskadeeffekt på de andre issues:**
   - Når `copyPhysReg` understøtter 16-bit kopier, og `IX` frigives for funktioner med `!hasFP(MF)`, kan pegepinden `flags` placeres i `IX` (**#432**).
   - `flags` opdateres direkte med hardware-instruktionerne `set 7, (ix+0)` og `inc (ix+0)`.
   - Fordi disse instruktioner ikke rører akkumulatoren `A`, overskrives `A` ikke længere af `ld (de), a`.
   - MachineLICM kan derefter løfte `delim` ind i `A` før løkken, så løkketesten bliver en ren 1-byte `cp (hl)` (**#431**).
   - `BC` og `DE` bliver fuldstændig frie til `len` i `B` (`djnz`) og `matches` i `C` (`inc c`), hvilket fjerner `.bss` statisk frame spildet (**#433**).
   - I funktionsprologen kan uafhængige `TargetFrameIndex` læsninger samles til én base-beregning i `HL` efterfulgt af `inc hl` trin (**#434**).


Alle bodies er formateret med lange flydende linjer (ingen hard-wrapping på paragraffer, for at undgå GitHub `<br>` linjebrud) og overholder AGENTS.md reglerne (adskillelse af verificeret symptom vs. ubekræftet årsagshypotese, ingen @-mentions af tredjeparter).

---

## Issue 1: Hoist loop-invariant comparison operand into accumulator `A`

**Title:**
`[Z80] Hoist loop-invariant comparison operand into A across pointer loops`

**Body:**
```markdown
### Symptom (observed, verified)
When compiling a loop that compares a sequential buffer pointer `*ptr` against an invariant scalar (`delim`) passed on the stack in `packet-parser.c`:
```c
for (uint8_t i = len; i != 0; --i) {
    if (*ptr == delim) ...
    ptr++;
}
```
The compiler emits a 5-instruction stack reload sequence inside the inner loop header:
```assembly
.LBB0_5:
    push    hl
    ld      hl, 5
    add     hl, sp
    ld      a, (hl)
    pop     hl
    cp      (hl)
    jr      nz, .LBB0_3
```
This recomputes the stack pointer offset and reloads `delim` into accumulator `A` on every single iteration, adding 7 bytes of code size and 49 T-states per loop iteration.

### Suspected cause (unconfirmed hypothesis)
MachineLICM or GlobalISel does not identify the stack-frame load of the invariant scalar as loop-invariant when accumulator `A` is clobbered within the loop body or during branch handling, preventing the register allocator from assigning `delim` to `A` outside the loop.

### Expected behavior
The loop-invariant argument should be loaded once before entering the loop (e.g. `ld a, (stack)`), allowing the inner loop test to consist solely of:
```assembly
cp      (hl)
jr      nz, .LBB0_3
```
```

---

## Issue 2: Retain pointer argument in index register (`IX`/`IY`) for in-place memory modifications

**Title:**
`[Z80] Keep pointer argument in index register (IX/IY) for in-place memory operations in loops`

**Body:**
```markdown
### Symptom (observed, verified)
In `packet-parser.c`, a pointer argument `uint8_t *flags` is passed on the stack and updated conditionally in each loop iteration:
```c
if (*ptr == delim) {
    *flags |= 0x80;
} else {
    (*flags)++;
}
```
Inside the loop, the compiler reloads the pointer address from the stack frame for every write:
```assembly
push    hl
ld      hl, 6
add     hl, sp
ld      e, (hl)
inc     hl
ld      d, (hl)
pop     hl
ld      (de), a
```
This sequence costs 9 bytes and over 60 T-states on every iteration.

### Suspected cause (unconfirmed hypothesis)
Because the primary 16-bit register pairs (`BC`, `DE`, `HL`) are occupied by `len`, buffer `ptr`, and accumulator values, the register allocator does not consider the index registers (`IX` or `IY`) for live pointer values across the loop. As a result, the pointer is evicted to the stack frame and reloaded via temporary registers instead of utilizing Z80 indirect index addressing.

### Expected behavior
When primary 16-bit registers are constrained, pointer arguments that undergo bit or arithmetic updates should be allocated to `IX` or `IY` across the loop. This enables direct in-place modifications using `set 7, (iy+0)` and `inc (iy+0)`, eliminating both the stack reloads and the register save/restore overhead.
```

---

## Issue 3: Avoid static frame spill for loop match counter when 8-bit registers are available

**Title:**
`[Z80] Avoid spilling 8-bit loop match/accumulator counter to static frame (.bss)`

**Body:**
```markdown
### Symptom (observed, verified)
In `parse_packet_c`, the accumulator variable `matches` (which starts at 0 and increments when a delimiter is found) is allocated to a 1-byte static frame slot (`L_parse_packet_c.frame`) in `.bss`:
```assembly
; Increment matches in loop:
ld      a, (L_parse_packet_c.frame)
ld      d, a
inc     d
ld      a, d
ld      (L_parse_packet_c.frame), a
```
This adds a 1-byte `.bss` allocation and replaces a 1-byte register increment (`inc c`) with a 9-byte load-modify-store sequence.

### Suspected cause (unconfirmed hypothesis)
Greedy Register Allocator experiences artificial register pressure because `len` is allocated to `C`, `ptr` to `HL`, and `delim` is repeatedly loaded into `A`. With better register assignment (or hoisting invariant stack loads out of the loop), an 8-bit register such as `C` or `D` would be available to hold `matches` across the entire loop.

### Expected behavior
The loop match counter should remain in an 8-bit register (e.g. `C`), allowing increments to compile to a single 1-byte instruction (`inc c`) with zero `.bss` static frame usage.
```

---

## Issue 4: Coalesce sequential stack argument loads in function prologue

**Title:**
`[Z80] Coalesce consecutive stack argument loads into sequential SP post-increments`

**Body:**
```markdown
### Symptom (observed, verified)
When compiling functions with several stack arguments under `-fomit-frame-pointer`, the prologue lowers each stack parameter access as an independent FrameIndex calculation:
```assembly
; Read arg 1:
push    hl
ld      hl, 4
add     hl, sp
ld      a, (hl)
pop     hl
...
; Read arg 2:
push    hl
ld      hl, 6
add     hl, sp
ld      c, (hl)
inc     hl
ld      b, (hl)
...
; Read arg 3:
push    hl
ld      hl, 4
add     hl, sp
ld      c, (hl)
pop     hl
```
In `parse_packet_c`, this pattern of repeated `push hl; ld hl, N; add hl, sp; ...; pop hl` sequences consumes ~28 bytes of code size in the prologue and loop preheader just to calculate offsets from `SP`.

### Suspected cause (unconfirmed hypothesis)
PrologEpilogInserter (PEI) and FrameIndex elimination lower each stack access independently to an absolute displacement from the stack pointer. The backend lacks a peephole pass or DAG combine to identify sequential stack argument loads and share the base address calculation.

### Expected behavior
Consecutive stack parameter loads should share a single stack pointer base calculation (e.g. `ld hl, 2; add hl, sp`), followed by sequential increments (`ld b, (hl); inc hl; ld a, (hl); inc hl; ...`), saving approximately 14 bytes in the prologue.
```

---

## Verificeret Status og Løsninger på `work/packet-parser-codegen` (2026-11-15)

Alle 4 issues er nu fuldt implementeret på branch `work/packet-parser-codegen` i submodule `llvm-z80`, under streng overholdelse af TDD-disciplinen (failing lit test committed først). Alle 186 lit-tests i `CodeGen/Z80` samt samtlige 92 e2e-konfigurationer af `packet-parser.c` (inklusiv simulator-verifikation på runtime-orakelet) består 100%.

### Resultater for `packet-parser.c`
* **Baseline (oprindelig):** 118 bytes text, 4 bytes `.bss`
* **Efter `reimpl` start:** 101 bytes text, 1 byte `.bss`
* **Efter `work/packet-parser-codegen`:** **76 bytes text, 0 bytes `.bss`**
* **Optimal håndskreven assembly:** 63 bytes text, 0 bytes `.bss`

### Commits og Løsningsoversigt
1. **Issue #432 (In-place memory ops med IX):**
   * Commit `8bd17ba41690`: `[Z80] Allow IX register allocation for pointers and in-place memory ops`
     * Un-reserve `Z80::IX` i `Z80RegisterInfo.cpp` når `!hasFP(MF) && !STI.hasSM83()`.
     * Fix `hasSuperClassEq(&Z80::GR16RegClass)` i `getLargestLegalSuperClass`.
     * Sænk skalar frame index loads til `RELOAD_ANY16` i `Z80InstructionSelector.cpp`.
     * Udvid `SET8_IND`/`INC8_IND` m.fl. til `HLI` i `Z80InstrInfo.td` og ekspandér med `+0`.
   * Commit `f5160d15a9ad`: `[Z80] Add failing test for store-phi sinking of in-place RMW operations`
   * Commit `c1256d987428`: `[Z80] Sink G_STORE of G_PHI for CISC in-place RMW operations`
     * `Z80StorePhiSink` pass sanker `G_STORE` tilbage i forgænger-blokkene og opløser loop-carried PHI, så selection matcher `SET 7,(IX+0)` og `INC (IX+0)` direkte in-place.
2. **Issue #434 (Coalescing af sekventielle stak-loads):**
   * Commit `8da98502c5d2`: `[Z80] Add failing test for coalescing consecutive SP-relative stack loads`
   * Commit `f0eff4dace61`: `[Z80] Reuse HL SP-relative address across consecutive stack reloads`
     * Udvidede `reuseLDHLAddress` i `Z80PreEmitPeephole.cpp` til generel Z80 `ld hl, nn; add hl, sp` og erstatter gentagne SP-offset genberegninger med sekventielle `inc hl`/`dec hl`.
3. **Issue #431 (Loop-invariant akkumulator i A):**
   * Commit `e1fb71951697`: `[Z80] Add failing test for hoisting loop-invariant accumulator copy`
   * Commit `9a8a991ad438`: `[Z80] Hoist loop-invariant accumulator load to loop preheaders`
     * Løfter invariant `ld a, r` ud af loop-headeren til loop-preheaders i `Z80PreEmitPeephole.cpp`, udvider livstiden for `$a` hen over løkken og fjerner `isKill()` på løkkens interne læsninger. Løkkens test reduceres til 1-byte `cp (hl)`.
4. **Issue #433 (0 B `.bss` spill for match-tæller):**
   * Automatisk løst af kaskaden: Fordi `flags` er i `IX`, `buf` i `HL`, og `delim` i `A`, tildeles `matches` til register `B` med 0 byte i `.bss`.
