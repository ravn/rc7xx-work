# Plan: Implementering af de 4 Codegen-Optimeringer i `reimpl`

**Dato:** 2026-11-15  
**Kontekst:** LLVM-Z80 (`reimpl`-branch) vs håndskreven Z80 assembly (refereret i `packet-parser.c` og `packet-parser-opt.s`).

---

## 1. Mål og Baggrund

Målet er at reducere kløften mellem compiler-genereret kode (i øjeblikket 118 bytes / 4 B `.bss`) og den optimale håndskrevne Z80 assembly (63 bytes / 0 B `.bss` under SDCC ABI).

Vi skal implementere 4 konkrete backend-optimeringer i LLVM-Z80 (`reimpl`):

1. **LICM / Kommutativ inversion for `cp (hl)`:**
   Læg loop-invariante sammenligningsværdier i `A` før løkken, så `cp (hl)` kan sammenligne direkte mod bufferen i `HL` uden memory-reloads.
2. **In-place bit/byte-modifikation via `IX`/`IY` (`set b, (ix+d)` og `inc (ix+d)`):**
   Fold load-modify-store mønstre (`*p |= mask` og `(*p)++`) til direkte RAM-instruktioner på indeksregistre.
3. **Loop-tæller i `B` og `DJNZ` emission:**
   Sørg for at 8-bit count-down induction variables allokeres til register `B`, så `djnz` udnyttes optimalt.
4. **Memory-inkrement for globale 8-bit variabler (`inc (hl)`):**
   Fold `var++` / `var--` på faste adresser til `ld hl, _var; inc/dec (hl)` (4 bytes / 21 T) i stedet for `ld a, (_var); inc a; ld (_var), a` (7 bytes / 30 T), når `HL` er ledigt.

---

## 2. Teknisk Analyse og Implementeringsplan pr. Optimering

### Optimering 1: Kommutativ inversion for `cp (hl)` ved loop-invarianter
* **Problem i dag:**
  I `*ptr == delim` er `ptr` variant (øges i løkken) og `delim` er loop-invariant. Compilerens ISel matcher `cp (hl)` ved at binde `delim` til `(HL)` og `ptr` til `A` (`ld a, (de)`). Da `delim` ligger på stakken, genindlæses adressen på `delim` fra hukommelsen i hver iteration (`ld hl, (frame+2)`).
* **Løsning i LLVM-Z80:**
  * I `Z80ISelLowering.cpp` / DAGCombine for `ISD::SETCC`:
    Når vi har `setcc (load ptr), invariant, SETEQ`:
    Tving kanonisering til `setcc invariant, (load ptr), SETEQ`, hvis `ptr` er en aktiv pegepind (f.eks. induction variable) og invarianten kan ligge i et register.
  * Register Allocator / Calling Conv:
    Sikre at akkumulatoren `A` tildeles invarianten før løkken, så loop-kernen blot indeholder:
    ```assembly
    cp  (hl)
    ```
* **Test og verifikation:**
  * Lit test i `llvm/test/CodeGen/Z80/` der verificerer `cp (hl)` med variant i `HL` og invariant i `A`.

---

### Optimering 2: In-place bit/byte operationer via `IX`/`IY`
* **Problem i dag:**
  `*flags |= 0x80` og `(*flags)++` sænkes til fulde 3-trins RMW sekvenser via registre. Da registrene er brugt op, genererer compileren 9 instruktioner pr. skrivning for at gemme/genindlæse fra stakken.
* **Løsning i LLVM-Z80:**
  * `Z80InstrInfo.td` har allerede definitioner for `SET8mr`, `RES8mr` og `INC8m`/`DEC8m` for `(INDEX8+d)`.
  * I `Z80DAGToDAGISel.cpp` / DAGCombiner:
    * Match `(store (or (load ptr), (shl 1, bit)), ptr)` $\rightarrow$ `SET8mr ptr, bit`.
    * Match `(store (add (load ptr), 1), ptr)` $\rightarrow$ `INC8m ptr`.
  * Tillad `GR16_INDEX` (`IX`/`IY`) som gyldige base-registre for disse patterns under address-mode selection.
* **Test og verifikation:**
  * Lit test for `set b, (ix+d)` og `inc (ix+d)` genereret direkte fra C-pointer operationer.

---

### Optimering 3: Tildeling af Loop Induction Variable til `B` og `DJNZ`
* **Problem i dag:**
  `len` allokeres til `C`, og løkken afsluttes med `dec c; jr z`.
* **Løsning i LLVM-Z80:**
  * Commit `d6d20f71e8ee` tilføjede LSR cost-model for DJNZ. Vi skal færdiggøre forbindelsen til Target Register Allocation:
    * Betinget loop med countdown fra 8-bit værdi skal have en stærk reg-alloc præference/affinitet for `B` (`Z80::B`).
    * Peephole / Post-RA pass: Erstat `DEC B` + `JR NZ, label` med `DJNZ label`.
* **Test og verifikation:**
  * Lit test der verificerer emission af `djnz` for `for (uint8_t i = n; i != 0; --i)`.

---

### Optimering 4: Fold global variabel `var++` til `ld hl, _var; inc (hl)`
* **Problem i dag:**
  Globale variableinkrementer (`packet_errors++`) bliver til:
  ```assembly
  ld  a, (_packet_errors) ; 3B, 13T
  inc a                   ; 1B,  4T
  ld  (_packet_errors), a ; 3B, 13T
  ; I alt: 7 bytes, 30 T
  ```
* **Løsning i LLVM-Z80:**
  * I `Z80ISelLowering.cpp` (i `PerformDAGCombine` eller tablegen ISel):
    Match `(store (add (load:i8 (tglobaladdr:$addr)), 1), (tglobaladdr:$addr))`.
    Hvis `HL` er død/ikke-allokeret i konteksten:
    Generer:
    ```assembly
    ld  hl, $addr           ; 3B, 10T
    inc (hl)                ; 1B, 11T
    ; I alt: 4 bytes, 21 T (sparer 3 bytes og 9 T-states)
    ```
* **Test og verifikation:**
  * Lit test i `llvm/test/CodeGen/Z80/` der bekræfter `inc (hl)` / `dec (hl)` for globale tællere.

---

## 3. Trinvis Udrulningsplan og Status

| Fase | Opgave | Filer | Succeskriterium | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Fase 1** | Optimering 4: Global `inc/dec (hl)` | `Z80InstructionSelector.cpp`, `Z80InstrInfo.td` | Faldende kode-størrelse for `var++`; grøn testsuite | **Fuldført** (Fundet præ-eksisterende på `reimpl` via `104c1f9d2e77`; verificeret `ld hl, _var; inc (hl)`) |
| **Fase 2** | Optimering 2: `set/res b, (hl)` in-place | `Z80InstructionSelector.cpp`, `Z80InstrInfo.td`, `Z80InstrInfo.cpp` | In-place ram-modifikation uden stakspills | **Fuldført** (Commit `a57eb8390efa`: `SET8_IND`/`RES8_IND` pseudoer post-RA) |
| **Fase 3** | Optimering 1: Kommutativ `cp (hl)` fold | `Z80InstructionSelector.cpp` | `cp (hl)` på venstreside ved lighedstests; fjerner stak-reloads | **Fuldført** (Commit `98c81d228e54`: reducerede `parse_packet_c` fra 118 B til 101 B og `.bss` fra 4 B til 1 B) |
| **Fase 4** | Optimering 3: DJNZ i `Z80BranchCleanup` | `Z80BranchCleanup.cpp`, `Z80InstrInfo.td` | `djnz` emitteres for `dec b; jr nz` loops med flag-sikkerhed | **Fuldført** (Commit `3fe973feb7e9`: branch cleanup fold med flag og SM83 guards) |
| **Fase 5** | E2E Rekompilering og regressionstest | `packet-parser.c`, `djnz-loop.c`, `setres-hl-indirect.c` | Alle 4.658 test i `check-z80` og 182 Z80 lit-test består | **Fuldført** (100% PASS i alle suites) |

---

## 4. Sikkerheds- og Verifikationsregler
* Før hver kodeændring: Skriv en faldende lit-test først (AGENTS.md mandatory rule).
* Verificer med både `build-macos-asserts/bin/llvm-lit` og e2e runtime test med `z80-run`.
* Hver optimering isoleres i sin egen commit på `reimpl`.
