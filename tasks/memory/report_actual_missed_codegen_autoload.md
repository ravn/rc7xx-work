---
name: report-actual-missed-codegen-autoload
description: Rapport over faktiske observerede missede optimeringer via -Rpass-missed i autoload-in-c
type: reference
---

# Rapport: Faktiske Observerede Missede Optimeringer i `autoload-in-c`

**Kommando:**
```bash
clang --target=z80 -Oz -g -nostdlib -ffreestanding -std=c23 \
  -ffunction-sections -fdata-sections \
  -Xclang -target-feature -Xclang +static-frame \
  -Xclang -target-feature -Xclang +shadow-regs \
  -mllvm -disable-lsr \
  "-Rpass-missed=.*" "-Rpass-analysis=.*" \
  -Iclang -I. -c rom.c -o /tmp/rom_remarks.o
```

Rapporten dokumenterer de konkrete årsager og linjer, hvor LLVM-optimereren rapporterer missede optimeringer i produktionskoden.

---

## 1. Register Allocation Spills i Indre Løkker (`-Rpass-missed=regalloc`)

Den dominerende kilde til unødige instruktioner på Z80 er registermangel (kun 3 par: `BC`, `DE`, `HL`).

### Tilfælde A: Array-indeksering kombineret med funktionskald (`rom.c:438`)
```c
void fdc_read_result(void) {
    byte i;
    byte *p = (byte *) &fdc_result;

    for (i = 0; i < 7; i++) {
        p[i] = fdc_read_when_ready();
        if (!(fdc_status() & 0b00010000)) {
            p[i + 1] = dma_status();
            return;
        }
    }
    ...
}
```
* **Remark:** `1 spills 1.57e+01 cost, 1 reloads 1.57e+01 cost, 1 virtual register copy generated in loop`
* **Årsag:** `fdc_read_when_ready()` og `fdc_status()` clobbrer registrene. Fordi `p[i]` kræver bevarelse af både basepointeren `p` og tælleren `i`, kan de ikke begge være i registre over funktionskaldet, og der spilles til stakken/rammen for hver iteration.
* **Løsning:** Omskrivning til pointer-stepping: `*p++ = fdc_read_when_ready();` fjerner indekset `i`.

### Tilfælde B: Tredobbelt nestet forsinkelsesløkke (`rom.c:104-114`)
```c
void delay(byte outer, byte inner) {
    if (!outer) return;
    do {
        byte mid = inner;
        do {
            byte k = 0;
            do {
                __asm__ volatile("");
            } while (--k);
        } while (--mid);
    } while (--outer);
}
```
* **Remark:** `10 virtual registers copies (total copies cost 63,440) generated in loop`
* **Årsag:** 3 niveauer af tællere (`outer`, `mid`, `k`) kæmper om `B`. `Z80SplitDjnzCounters` giver `B` til den inderste (`k`), men Greedy Regalloc må lave kopier for at flytte `mid` og `outer` ind og ud af registre mellem lagene.

---

## 2. Loop Invariant Code Motion (LICM) Blokering (`-Rpass-missed=licm`)

### `rom.c:889-890` (`boot_floppy_or_prom`)
```c
while (1) {
    fdc_read_data_from_current_location(dma_transfer_size);
    if (fdc_cmd.cylinder != 0) break;
    fdc_detect_sector_size_and_density();
}
```
* **Remark:** `failed to move load with loop-invariant address because the loop may invalidate its value`
* **Årsag:** `dma_transfer_size` er en global variabel. Compileren vil gerne hejse læsningen ud af `while(1)`, men da de kaldte funktioner ikke er markeret med `__attribute__((pure))` eller `const`, skal compileren defensivt antage, at de kan have ændret den globale variabel, og genindlæser den i hver iteration.

---

## 3. Inlining Blokeret af Target-Feature Konflikt (`-Rpass-missed=inline`)

### `rom.c:907, 909, 925, 929`
* **Remark:** `'fdc_detect_sector_size_and_density' not inlined into 'floppy_legacy_boot' because it should never be inlined (cost=never): conflicting target features`
* **Årsag:** Modulet kompileres med specifikke backend-features (`+static-frame`, `+shadow-regs`). Hvis funktioner er defineret med eller uden specifikke attributter, der ændrer målets feature-sæt, nægter LLVM's inliner at slå dem sammen.
