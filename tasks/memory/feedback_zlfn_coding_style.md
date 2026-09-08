---
name: feedback_zlfn_coding_style
description: @zlfn's (upstream llvm-z80 maintainer) coding and design philosophy — distilled from PR #40 review. Apply when writing tests, designing conventions, or deciding what to expose at language level.
metadata:
  type: feedback
---

Destilleret fra @zlfn's refactor af PR #40 (z88dk calling conventions, merged 2026-09-08).

## Test-disciplin

**Pin slot offsets, not just results.** Brug `CHECK-NEXT:` (ikke løse `CHECK:` med spring) til at fastlåse den præcise instruktionssekvens, inkl. `ld hl,#N; add hl,sp` for hvert argument-slot. En test der kun tjekker det endelige svar kan acceptere en forkert ABI hvis input er symmetriske.

**Distinct-coefficient formula.** Brug `a - 2b` (shl + sub) i stedet for `a - b` som kontrolformel. En byttet slot-rækkefølge er usynlig med `a - b` hvis begge sider tilfældigvis giver samme resultat; med `a - 2b` ændrer enhver swap svaret.

**Kildekrydsreferencer i tests.** Når et register-assignment verificeres, citér den faktiske z88dk/SDCC assemblerfil der bekræfter det (f.eks. "Verified from z88dk source: libsrc/.../rs232_put.asm reads its i8 argument with `ld a, l`").

**Why:** @zlfn's commit 8c81ba7 (PR #40) tilføjede netop disse: vores originale tests var for løse til at fange en byttet ABI.

## Design: backend-interne conventions frem for user-facing

**Z80_Builtin i stedet for z80_allreg.** Bruger-eksponerede "all-register" conventions der tildeler reserverede registre (IX/IY) miscompiler og er en bug. Backend-interne conventions (som AVR/MSP430 gør det) er det rette mønster for runtime-kald. Fjern user-facing attributter der overtræder arkitektur-invarianter.

**LDIR_GUARDED pseudo i stedet for memmove_rt helper.** Inline-pseudo-instruktioner er bedre end opfundne runtime-hjælpere for operationer der naturligt folder til et fast antal instruktioner.

## Design: sprogelementer vs. bibliotek

**Kritiske sektioner hører hjemme i biblioteket, ikke sproget.** clang bærer intet critical-section-attributt for nogen target; AVR eksponerer bare `__builtin_avr_sei`/`cli`, og save/restore ligger i avr-libc. `__critical` på et Z80-target er problematisk fordi:
1. Det betyder forskelligt på Z80 vs SM83 (IFF2 kan ikke læses tilbage på SM83).
2. Det gør function-scope critical sections nemme — en anti-pattern der skjuler voksende kritiske sektioner.

Brug i stedet `CRITICAL_BEGIN`/`CRITICAL_END` makroer via inline-asm (se @zlfn's snippet i PR #40-kommentarer).

**`__attribute__((interrupt))` er allerede der.** Det emitterer `reti` og gemmer/gendanner registre. EI/DI er eksplicitte (reti på Z80 aktiverer IKKE interrupts — det kræver eksplicit EI inden RETI hvis nødvendigt).

## Arbejdsstil

**Fix selv i stedet for review-loops.** @zlfn: "I'll check it, add the necessary fixes, and then merge it — rather than that, I think it would be faster for me to fix it myself." Stil åbne spørgsmål om design, men forvent at upstream-maintaineren retter og merger direkte.

**Reducer redundans aggressivt.** @zlfn droppede `z80_allreg` (forkert), skiftede navne til hvad SDCC/z88dk faktisk bruger (`z80_smallc` -> `smallc`), og fjernede formatting-churn fra core-filer. Sæt navne efter den faktiske brug, ikke vores interne termer.

**Why:** PR #40 review 2026-09-08. @zlfn er primær maintainer af llvm-z80/llvm-z80 og har dybere arkitekturkendskab end os.

## How to apply

- Ved skrivning af nye lit-tests: pin hvert slot-offset med CHECK-NEXT, brug distinct-coefficient formula, citér kilden der verificerer register-assignments.
- Ved design af nye CC-attributter: spørg "kan dette miscompile ved at bruge reserverede registre?" og "er dette en library-concern eller et sprogelement?" Foretrækk backend-interne conventions (usynlige for brugeren) for runtime-kald.
- Når @zlfn reviewer: forvent direkte fixes fra hans side; vores opgave er at stille de rigtige spørgsmål og verificere at vores brug-cases stadig er dækket.
