---
name: reference_rc759_ccpm86_4console_and_keyboard
description: RC759 Piccoline 4-konsol CCP/M-86 arkitektur, PIN.RSP/XIOS konsolskift og MAME tastaturmapping for Mac/bærbare
metadata:
  type: reference
---

# RC759 Piccoline: 4-Konsol CCP/M-86 og Tastatur-arkitektur

Dokumentation af 4-konsol systemet under Concurrent CP/M-86 3.1 på Regnecentralen RC759 Piccoline, den underliggende konsolskift-mekanisme mellem XIOS og Digital Researchs PIN.RSP, samt MAME HLE-tastaturdriverens tilpasninger til moderne tastaturer (MacBook Air m.fl.).

---

## 1. 4-Konsol Kernel (CCPM.SYS) på SW1400

Distributionsdisken **SW1400 CCP/M-86 version 3.1a** (Bits:30004229 / `scratch/rc759-cmd-toolchain/ddhf-cache/derived/sw1400-r3.1a-disk1.img`) indeholder allerede en fuldt funktionel 4-konsol kerne ud af boksen:

- **Kernefil**: `CCPM.SYS` (94.848 bytes) – 4-konsol varianten (til forskel fra 1-konsol varianten `CCPM1.SYS` på 77.568 bytes).
- **Banner ved boot**:
  ```text
  PICCOLINE XIOS version 3.1   Januar 1987
    384 K bytes hovedlager
    6 Mhz CPU
    2 Diskettestation(er)
    2 Databuffer(e)
    1 Katalogbuffer(e)
    261 K bytes brugerlager
  Concurrent CP/M-86 3.1
  Copyright (C) 1983, Digital Research
  System med 4 konsoller
  ```
- **Undgå menu / direkte til A>**:
  På standarddisken starter `0:STARTUP.0` automatisk `menu imenu\r\n`.
  I `mame/rc759_sw/sw1400-nomenu.img` er `STARTUP.0` fjernet. Dermed booter systemet direkte til kommandolinjen `A>` på alle 4 virtuelle konsoller.

---

## 2. Arkitektur: Hvem skifter konsol? (XIOS vs. PIN.RSP)

Konsolskift i Concurrent CP/M-86 håndteres i et tæt samspil mellem hardware-driveren (RC759 XIOS) og operativsystemets procesinput-proces (**PIN.RSP**):

```
[Tastetryk: Ctrl + Keypad 0..3]
        │
        ▼
[RC759 Tastaturmatrix (scancodes 97, 93, 94, 95)]
        │
        ▼
[XIOS ctrl-oversættelsestabel (offset 0x36af6): koder 0xF5, 0xF6, 0xF7, 0xF8]
        │
        ▼
[XIOS IO_CONIN (funktion 1 / XCHAR.LIB kontroltabel ved offset 0x3125)]
        │ Returnerer AH = 0xFF (ct$switch), AL = 0..3 (virtuel konsol nr.)
        ▼
[PIN.RSP (Digital Research Process Input)]
        │ Registrerer AH == ct$switch
        │ 1. Opdaterer CCB (Console Control Block)
        │ 2. Kalder 'call switch;' internt i PIN
        │ 3. Kalder XIOS funktion 7: IO_SWITCH (opdaterer skærmbuffer/i82730)
        ▼
[Skærmbillede skifter til den valgte virtuelle konsol (0, 1, 2 eller 3)]
```

### XIOS Keyboard Scancode & Matricetabeller
Tastaturet i RC759 afleverer positionsscancoder (0..98) til I/O-porten via 8255/8259-interrupts:
* `row_0`:
  * Pos 0: Ubrugt
  * Pos 1: `Tab`
  * Pos 2..11: Tasterne `'1'` .. `'0'` (Bemærk: Tasten `1` er scancode 2, ikke 1!)
* `row_3` bit 7 (pos 55): `Alt` modifier (boot-ROM og XIOS sporer denne)
* `row_1` bit 13 (pos 29): `Ctrl` modifier
* `row_5` / `row_6`: Det numeriske tastatur (Keypad):
  * Pos 97: `0_PAD`
  * Pos 93: `1_PAD`
  * Pos 94: `2_PAD`
  * Pos 95: `3_PAD`

Når `Ctrl` holdes nede, slår XIOS op i `ctrl`-tabellen (disk-offset `0x36af6`):
* Pos 97 (`0_PAD`) $\rightarrow$ `0xF5`
* Pos 93 (`1_PAD`) $\rightarrow$ `0xF6`
* Pos 94 (`2_PAD`) $\rightarrow$ `0xF7`
* Pos 95 (`3_PAD`) $\rightarrow$ `0xF8`

Disse koder oversættes i XIOS `IO_CONIN` til `AH = 0xFF` (`ct$switch`) og `AL = 0..3`.

### Vinduesstyring (VMENU / A3 / A4)
* **`Ctrl + A3`** (pos 74 / `Ctrl + End` i MAME): Kalder `w_wake` i XIOS. Dette aktiverer kun vinduesstyring, hvis `im_here >= 1` (sættes af programmet `VMENU.CMD`).
* **`Ctrl + A4`** (pos 75 / `Ctrl + NumLock` i MAME): Fuld skærm til/fra.

---

## 3. MAME Tastatur-tilpasning til Mac og moderne laptops

### Problemet på MacBook / moderne tastaturer
1. **Intet fysisk numerisk tastatur**: MacBook Air (og de fleste 13"-14" laptops) har intet numerisk tastatur og ingen indbygget Fn-keypad.
2. **macOS stjæler `Ctrl + F1..F4`**:
   macOS reserverer som standard faste systemgenveje under *Tastatur $\rightarrow$ Tastaturgenveje*:
   * `Ctrl + F1`: Slå tastaturnavigation til/fra
   * `Ctrl + F2`: Fokus til menulinjen
   * `Ctrl + F3`: Fokus til Docken
   * `Ctrl + F4`: Fokus til næste/aktive vindue
   Disse opfanges af macOS WindowServer, før SDL/MAME ser tastetrykkene.
3. **Hardware medietaster**: Øverste tastrække sender skærmlysstyrke/lydstyrke medmindre `Fn` holdes nede eller systemindstillingen ændres.

### Løsning i MAME (`mame/src/mame/regnecentralen/rc759_kbd.cpp`)
I driveren implementeres dynamisk ommåling af scancodes under `key_make`, `key_break` og `key_repeat` via `m_mapped_code[128]`:

```cpp
bool ctrl_down = (m_key_rows[1]->read() & 0x2000) != 0;
bool alt_down = (m_key_rows[3]->read() & 0x0080) != 0;

if (ctrl_down && alt_down)
{
    switch (raw_code)
    {
    case 2:  code = 97; break; // Ctrl+Alt+1 (scancode 02) -> Keypad 0 (Konsol 0)
    case 3:  code = 93; break; // Ctrl+Alt+2 (scancode 03) -> Keypad 1 (Konsol 1)
    case 4:  code = 94; break; // Ctrl+Alt+3 (scancode 04) -> Keypad 2 (Konsol 2)
    case 5:  code = 95; break; // Ctrl+Alt+4 (scancode 05) -> Keypad 3 (Konsol 3)
    case 11: code = 97; break; // Ctrl+Alt+0 (scancode 11) -> Keypad 0 (Konsol 0)
    default: break;
    }
}
else if (ctrl_down)
{
    switch (raw_code)
    {
    case 59: code = 97; break; // Ctrl+F1  -> Keypad 0 (Konsol 0)
    case 60: code = 93; break; // Ctrl+F2  -> Keypad 1 (Konsol 1)
    case 61: code = 94; break; // Ctrl+F3  -> Keypad 2 (Konsol 2)
    case 62: code = 95; break; // Ctrl+F4  -> Keypad 3 (Konsol 3)
    case 68: code = 74; break; // Ctrl+F10 -> A3 (Window Manager)
    case 69: code = 75; break; // Ctrl+F11 -> A4 (Full Screen Toggle)
    default: break;
    }
}
```

### Verificerede genveje i MAME på Mac
* **`Ctrl + Option + 1`** $\rightarrow$ **Konsol 0**
* **`Ctrl + Option + 2`** $\rightarrow$ **Konsol 1**
* **`Ctrl + Option + 3`** $\rightarrow$ **Konsol 2**
* **`Ctrl + Option + 4`** $\rightarrow$ **Konsol 3**
*(samt `Ctrl + Option + 0` $\rightarrow$ Konsol 0)*
