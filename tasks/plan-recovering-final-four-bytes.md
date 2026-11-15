# Plan: Indhentning af de Sidste 4 Bytes (71 B -> 67 B) [FULDFØRT]

**Dato:** 2026-11-15  
**Resultat:** FULDFØRT — Koden kompilerer nu til præcis **67 bytes** under `-Os` (0 B `.bss`, 16 B DJNZ indre løkke).  
Dette matcher det absolutte teoretiske minimum for compliant C (63 B optimal håndskreven Z80 assembly + 4 B standard ABI `push ix / pop ix`).  
**Commit:** `58bce35ae06e` på `work/packet-parser-codegen`.

---

## 1. Nuværende Status og Progression

* Upstream `main`: 118 bytes (.bss: 4 bytes)
* Upstream `reimpl`: 101 bytes (.bss: 1 byte)
* Efter Fase 5: 74 bytes (.bss: 0 bytes)
* Efter Fase 6: 72 bytes (.bss: 0 bytes)
* Efter Fase 7: 71 bytes (.bss: 0 bytes)
* **Efter Fase 8: 67 bytes (.bss: 0 bytes, 16 B DJNZ inner loop, in-place CISC RMW)**
* **Teoretisk compliant C-minimum: 67 bytes** (100% nået!)
* **Håndskrevet ren assembler: 63 bytes** (4 bytes forskel til C skyldes callee-saved `push ix; pop ix`)

---

## 2. Rodårsagen til de Sidste 4 Bytes

### Hvorfor de opstår (Disassembly-sammenligning)

I vores nuværende 71-bytes kode:
```assembly
; Blok 1: %if.end (11 bytes)
9:  e5           push    hl              ; 1 B: gem base
a:  21 06 00     ld      hl, 6           ; 3 B: offset til len
d:  39           add     hl, sp          ; 1 B
e:  46           ld      b, (hl)         ; 1 B: b = len
f:  e1           pop     hl              ; 1 B: genskab base
10: 78           ld      a, b            ; 1 B
11: b7           or      a               ; 1 B
12: 28 27        jr      z, $3b          ; 2 B: hop hvis len == 0

; Blok 2: %for.body.lr.ph (17 bytes)
14: 19           add     hl, de          ; 1 B: ptr = base + offset
15: e5           push    hl              ; 1 B: gem ptr
16: 21 07 00     ld      hl, 7           ; 3 B: offset til delim og flags
19: 39           add     hl, sp          ; 1 B
1a: 7e           ld      a, (hl)         ; 1 B: a = delim
1b: 23           inc     hl              ; 1 B
1c: 5e           ld      e, (hl)         ; 1 B: flags low
1d: 23           inc     hl              ; 1 B
1e: 56           ld      d, (hl)         ; 1 B: flags high
1f: d5           push    de              ; 1 B
20: dd e1        pop     ix              ; 2 B: ix = flags
22: e1           pop     hl              ; 1 B: genskab ptr
23: 1e 00        ld      e, 0            ; 2 B: matches = 0
; I alt Blok 1 + Blok 2: 28 bytes!
```

I håndskrevet assembler (`packet-parser-opt.s`):
```assembly
7:  19           add     hl, de          ; 1 B: ptr = base + offset
8:  eb           ex      de, hl          ; 1 B: gem ptr i DE (uden stak-push!)
9:  21 02 00     ld      hl, 2           ; 3 B: offset til len på stakken
c:  39           add     hl, sp          ; 1 B: adresser stakken ÉN gang for alle!
d:  46           ld      b, (hl)         ; 1 B: b = len
e:  23           inc     hl              ; 1 B
f:  7e           ld      a, (hl)         ; 1 B: a = delim
10: 23           inc     hl              ; 1 B
11: 4e           ld      c, (hl)         ; 1 B: flags low
12: 23           inc     hl              ; 1 B
13: 66           ld      h, (hl)         ; 1 B: flags high
14: 69           ld      l, c            ; 1 B: hl = flags
15: e5           push    hl              ; 1 B
16: fd e1        pop     iy              ; 2 B: iy = flags
18: eb           ex      de, hl          ; 1 B: genskab ptr i HL (uden stak-pop!)
19: 0e 00        ld      c, 0            ; 2 B: matches = 0
1b: 04           inc     b               ; 1 B
1c: 05           dec     b               ; 1 B
1d: 28 10        jr      z, .L_exit      ; 2 B: test len == 0
; I alt: 24 bytes!
```

$$\text{Forskellen er: } 28\text{ B} - 24\text{ B} = \mathbf{4\text{ bytes}}$$

### Årsagen i LLVM-pipelinen
1. **Tidlig Instruction Selection:** ISel placerer oprindeligt alle 3 argument-reloads (`len`, `delim`, `flags`) i `entry`-blokken.
2. **Generic `MachineSink` (Pass 52):** LLVM's generiske `MachineSink` opdager, at `delim` og `flags` ikke bruges i `if.end`, men først i løkken. Derfor synker `MachineSink` dem ned i `for.body.lr.ph`.
3. **Konsekvens på CISC:** På RISC med 32 registre er sinking gavnligt (mindsker registerpres i `entry`). Men på Z80 splitter det argumenterne i to separate blokke, så PrologEpilogInserter (PEI) er tvunget til at generere `add hl, sp` to gange (med to sæt `push hl / pop hl`), i stedet for at traversere stakken sekventielt i ét hug.

---

## 3. Løsningsmodeller

Der er to mulige tekniske tilgange til at løse problemet i Z80-backend'en:

### Tilgang 1: Pinning af sammenhængende stak-argumenter mod `MachineSink` (Anbefalet)
* **Idé:**
  I `Z80InstrInfo::shouldSink(const MachineInstr &MI)`:
  Undersøg om en instruktion er en stak-reload (`RELOAD_GR8`, `RELOAD_GR16`, `RELOAD_ANY16`) fra en fast argument-slot (`%fixed-stack`).
  Hvis der i samme blok findes flere konsekutive argument-reloads, der kan flettes til en sammenhængende `inc hl`-sekvens af `reuseLDHLAddress`, skal `shouldSink` returnere `false` for at forhindre sinking i at splitte dem ad.
* **Fordel:**
  Benytter LLVM's standardiserede `TargetInstrInfo::shouldSink`-hook uden at indføre nye passes.
* **Udfordring der skal løses:**
  I vores foreløbige test faldt størrelsen med det samme til **69 bytes** (-2 B), men vi skal sikre:
  1. At loop-invarianten i `A` ikke overskrives af `rx_status & 1` i `entry`.
  2. At `BReg`-begrænsningen på `len` bevares, så `DJNZ` stadig genereres i alle tilfælde.

### Tilgang 2: Pre-PEI Speculativ Argument-Coalescing
* **Idé:**
  I `Z80PushPopSpills.cpp` (der kører lige før PEI efter RA):
  Når en loop-preheader (`bb.2`) har reloads fra `%fixed-stack` (`delim`, `flags`), og dens umiddelbare forgænger (`bb.1`) også har en reload fra `%fixed-stack` (`len`), hejses reloads spekulativt op i forgængeren, forudsat at registrene ikke er live på fejlgrenen (`bb.8`).
* **Fordel:**
  Rører ikke GlobalISel eller tidlige passes; opererer udelukkende efter at registerallokering og loop-struktur er fastlagt.
* **Udfordring:**
  Kræver præcis validering af liveness og flytning af virtual registers eller tidlige fysiske registre.

---

## 4. Konkret Implementeringsplan (Trin for Trin)

### Trin 1: TDD Failing Test
* Opret `llvm/test/CodeGen/Z80/coalesce-contiguous-arg-reloads.ll`.
* Testcasen skal verificere:
  1. Kun ÉN `add hl, sp`-sekvens i hele funktionen.
  2. Sekventiel `inc hl` gennem stak-parametrene (`len`, `delim`, `flags`).
  3. Bevarelse af `djnz` og in-place memory ops (`set 7, (ix+0)`).
* Bekræft at testen fejler på den nuværende kodebase.

### Trin 2: Implementer `shouldSink`-politikken i `Z80InstrInfo`
* I `Z80InstrInfo.cpp`:
  Specialiser `shouldSink` så den beskytter konsekutive `%fixed-stack`-loads mod sinking, hvis de deler base-pointer.
* Juster `Z80AccumulatorCopies` eller pre-RA passes, så `delim` placeres i `A` efter `rx_status & 1` evalueringen, så `A` ikke overskrives.

### Trin 3: Verifikation af 67–69 bytes
* Kompiler `packet-parser.c` under `-Os`.
* Verificer at koden når **67 bytes** (eller 68–69 bytes hvis `push hl / pop hl` bevares frem for `ex de, hl`).

### Trin 4: Fuld Regressionstest
* Kør hele LLVM-Z80 lit-suiten (191 tests) for at sikre nul utilsigtede bivirkninger på andre funktioner.
* Kør alle 92 e2e runtime-tests på tværs af alle optimeringsniveauer (`-O0`, `-O1`, `-O2`, `-O3`, `-Os`, `-Oz`).

---

## 5. Succeskriterier
1. `_parse_packet_c` kompileres til $\le 69\text{ bytes}$ under `-Os` (mål: 67 bytes).
2. 100% grøn testsuite (191+ lit tests, 92 e2e runtime tests).
3. Resultaterne og analysen indføjes i det endelige upstream issue-udkast.
