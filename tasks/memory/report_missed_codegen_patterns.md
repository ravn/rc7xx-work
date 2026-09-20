---
name: report-missed-codegen-patterns
description: Rapport over kendte missede compiler- og optimeringsmønstre på Z80 (ikke til PR)
type: reference
---

# Rapport: Missede Optimeringsmønstre i LLVM-Z80 (Ikke til Upstream PR)

**Formål:** Denne rapport samler og dokumenterer de specifikke mønstre i C-kildekode, hvor `llvm-z80` (og LLVM mid-end) i dag genererer suboptimal maskinkode, samt de bagvedliggende årsager til, at compileren ikke automatisk fanger dem.

Dette dokument er **strengt internt** i `tasks/memory/` og er **ikke** en del af PR-indsendelser til upstream.

---

## 1. Mønster: Opadgående tællerløkker vs. DJNZ (Missed Loop Reversal)

### Symptom
Et simpelt C-loop skrevet som `for (i = 0; i < N; i++)` eller `for (i = 1; i <= N; i++)` forbliver en opadgående optælling med `INC r; CP N; JR NZ` (3 instruktioner, 21-27 T-states pr. iteration) i stedet for hardware-`DJNZ` (1 instruktion, 13 T-states).

### Hvorfor LLVM ikke vender løkken automatisk
1. **Side-effects og C-semantik:** Hvis loop-kroppen tilgår volatile adresser, I/O-porte eller kalder funktioner, forbyder C-standarden ændring af eksekveringsrækkefølgen.
2. **SCEV & Canonical Form:** LLVM's `ScalarEvolution` (SCEV) og `LoopStrengthReduce` (LSR) standardiserer løkker mod opadgående `0..N-1`. Moderne CPU'er (x86, ARM) har ingen fordel ved nedtælling, så LLVM har ingen generisk transformation til at spejle tælleretningen mod nul.
3. **Loop unrolling:** På `-O2`/`-O3` med små konstante trip-counts (f.eks. 10) vælger LLVM ofte loop-unrolling frem for at bibeholde løkken.

### Nuværende workaround i C
Skriv tidskritiske løkker eksplicit som countdown-loops mod nul:
```c
uint8_t n = 10;
do {
    ...
} while (--n);
```

### Mulig fremtidig løsning i LLVM
En mid-end IR-pass eller target-specifik MachineFunctionPass før regalloc, der verificerer, at tælleren kun bruges i loop-termineringen (ingen adressedannelse `buf[i]`), og omskriver SCEV-formen til en countdown-phi mod nul.

---

## 2. Mønster: Fremadskridende hukommelseskopiering uden `restrict` (Missed LDIR)

### Symptom
En manuel fremadskridende C-kopiløkke:
```c
while (n--) {
    *dst++ = *src++;
}
```
bliver oversat til en manuel byte-for-byte løkke på Z80 (`DEC BC; LD A, (DE); INC DE; LD (HL), A; INC HL; JR NZ` = ~46 T-states pr. byte) i stedet for hardware-`LDIR` (21 T-states pr. byte).

### Hvorfor LLVM ikke folder til `LDIR`
1. **Pointer Aliasing:** Ifølge ANSI/ISO C må `dst` og `src` gerne overlappe i hukommelsen (f.eks. hvis `dst == src + 1`).
2. **Fremad-semantik:** En sekventiel fremadskridende kopiering ved overlap (`dst = src + 1`) resulterer i gentagelse af den første byte over hele bufferen (run-length propagation).
3. **`LDDR` er ikke en erstatning:** `LDDR` kopierer baglæns, hvilket ved overlap giver et helt andet dataresultat end en fremadskridende C-løkke.
4. Uden bevis for, at bufferne er disjunkte, tvinges LLVM's `LoopIdiomRecognize` af C-standarden til at afvise omskrivning til `memcpy` / `LDIR`.

### Nuværende workaround i C
* Brug altid `memcpy(dst, src, n)`. Programmøren garanterer her uafhængighed, og compileren folder direkte til `LDIR`.
* Alternativt kvalificér pointerne med `restrict` (`char * restrict dst, const char * restrict src`), som beviser disjunkthed over for alias-analysen.

---

## 3. Mønster: Variable og multi-bit skift (Shift Emulation Loops)

### Symptom
Operationer som `x << n` (hvor `n` er en variabel) eller `x >> 5` resulterer i lange instruktionskæder eller runtime-loops.

### Hvorfor det er dyrt på Z80
1. Z80 har ingen hardware-barrel-shifter; den kan udelukkende skifte eller rotere 1 bit ad gangen via ALU (`SLA`, `SRL`, `RLC` osv.).
2. Multi-bit skift med variabler genererer kald til runtime-biblioteket (`__ashlsi3`, `__lshrsi3`), som koster hundredevis af T-states og overskriver registerfiler.

### Nuværende workaround i C
* Hold bit-skift til små faste konstanter (`1`, `2`, `3`).
* Brug maskering (`&`) og tabeller frem for dynamiske skift i hot paths.

---

## 4. Mønster: 16-bit array-indeksering i indre løkker (LSR Base Spill)

### Symptom
Når arrays indekseres med et variabelt indeks `buf[i]` inde i en løkke, forsøger LLVM's `LoopStrengthReduce` (LSR) ofte at vedligeholde flere samtidige 16-bit induktionsvariable (basepointer, slutpointer, aktuelt element).

### Hvorfor det rammer hårdt på Z80
1. Z80 har kun 3 generelle 16-bit registerpar (`BC`, `DE`, `HL`).
2. Når LSR allokerer 3 eller 4 samtidige 16-bit værdier, løber registrene tør, og compileren tvinges til at lave `PUSH`/`POP` eller gemme i rammen (`(IX+d)`) inde i det inderste loop.

### Nuværende workaround i C
Brug direkte pointer-stepping (`*buf++`) med en simpel tæller i stedet for array-indeksering (`buf[i]`).

---

## 5. Mønster: Diagnosticering via Optimization Remarks

For at opdage disse og lignende mønstre i kildekoden kan man instruere Clang i at rapportere, hvorfor den opgav en optimering:

* **Advarsler om opgivne optimeringer (missed):**
  ```bash
  clang --target=z80 -O2 -Rpass-missed=loop-idiom -Rpass-analysis=loop-idiom fil.c
  ```
* **Firmware-integration (Makefiles):**
  I `autoload-in-c`, `rcbios-in-c` og `cpnos-in-c` kan analysen aktiveres direkte:
  ```bash
  make prom REMARKS=loop-idiom
  make bios REMARKS=loop-idiom
  make cpnos REMARKS=loop-idiom
  ```
