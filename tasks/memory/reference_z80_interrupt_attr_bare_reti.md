---
name: reference-z80-interrupt-attr-bare-reti
description: __attribute__((interrupt)) on Z80 emits bare RETI by design — programmer controls EI, same pattern as AVR sei/cli
metadata:
  type: reference
---

Z80 `__attribute__((interrupt))` er upstream-designet minimalt: den emitter **kun** `RETI` (i stedet for `RET`) og standard register save/restore. **Ingen automatisk `EI`** hverken i prolog eller epilog. Efter én afbrydelse forbliver IFF1=0 medmindre programmør selv har sat EI et sted.

**Kilde:** llvm-z80/llvm-z80 PR #40 (2026-08…), @zlfn's beslutning under review-diskussionen. Bevidst analogi til AVR: `__builtin_avr_sei/cli` er alt AVR eksponerer; save/restore-politik ligger i avr-libc. Ingen anden clang-target har en `__critical`-agtig attribut.

**Hvordan implementere korrekt firmware-ISR:**

```c
void __attribute__((interrupt)) my_isr(void) {
    ...work...
    __builtin_z80_ei();   // sidste C-statement; compiler emitter ei; pops; reti
}
```

Compileren indsætter register-restore-pops mellem `ei` og `reti`, men det er **stack-koherent** ved ethvert INT-sampling-punkt — nested ISR ser en gyldig frame, pusher sit eget, RETIer tilbage, vores pops fortsætter. Ingen korrekthedsproblemer.

**Sekundære designvalg programmør styrer** (ikke compiler-bugs):
- **Peripheral daisy-chain-prioritet:** ønskes RETI's in-service-clear *før* nested-vindue åbnes: brug inline-asm-halesnippet `__asm__("ei\n\treti"); __builtin_unreachable();`, eller `__attribute__((naked))` med fuld-asm-handler.
- **Non-nested / garanteret sekventiel:** skriv bare ikke `ei()` i handleren. Næste INT tages i main-loop's typiske `ei; halt`.

**Anti-pattern:** at file en "compiler emitter ikke EI"-bug (som ravn/llvm-z80#317 var — lukket 2026-09-17 som not-a-bug). Bare RETI er intentional.

**Relaterede filer:**
- `llvm/lib/Target/Z80/Z80CallLowering.cpp:352` (RETI-emission)
- `clang/include/clang/Basic/Attr.td:1091` (`Z80Interrupt` attr)
- `clang/lib/CodeGen/Targets/Z80.cpp:52` (attr → LLVM IR fn-attr)

**Filet 2026-09-17:** ravn/llvm-z80#341 — ISR clobrer HL uden at pushe trods `Z80_Interrupt_CSR` (`Z80CallingConv.td:66`) inkluderer HL. Reproducer verificeret. Sandsynlig rod: late peephole (in-memory INC/DEC, `354d14db1273`) introducerer HL efter PEI så CSR-analyse aldrig ser den som clobbered — samme mønster som #332.
