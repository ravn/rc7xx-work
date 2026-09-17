---
name: project-priority-miscompiles-for-upstream
description: Current llvm-z80 priority is fixing miscompiles to unblock upstreaming — code density is deferred
metadata:
  type: project
---

**Prioritering (bekræftet 2026-09-17):** llvm-z80-arbejdet fokuserer nu på at **fjerne miscompiles** så backend-rettelserne kan komme upstream (til llvm-z80/llvm-z80 og videre til llvm/llvm-project). Kodedensitet er stadig et anerkendt problem, men **venter**.

**Why:** Miscompiles blokerer upstream-godkendelse — @zlfn og upstream review-processen accepterer ikke en backend hvor kendt kode fejlkompilerer. Densitet er en optimering man kan lande senere; korrekthed er en gate. Firmware-blokerende density-issues (#314/#323/#340 rcbios+autoload) er reelle, men de gør ikke koden forkert — de gør bare at kompileren ikke kan bruges til at bygge alle produktionsleverancerne endnu.

**How to apply:**
- Når jeg foreslår "næste opgave" eller triager en issue-liste: rangér miscompiles først, missed-opts/density sidst.
- Kendte åbne miscompiles pr. 2026-09-17: #341 (ISR HL-clobber uden push — filet 2026-09-17 fra #317-triage; miscompile-verificeret), #331 (dynamic SP-frame for callee-saved — user-flaget "unsound", overvej luk), #318 (spill straddler inline-asm). Verificer altid at listen er aktuel med `gh issue list` før anbefaling. **Lukket 2026-09-17:** #335 (bss-self-clear, not reproducible), #317 (interrupt RETI uden EI, matches upstream design), #325 (ISR externals reentrant, fixed 2026-09-14 af `9b3737a` + `a97af74`), rc700#124 (ez80 IX clobber, upstream), #332 (-Oz stack-arg offset, fixed 2026-09-17 af `2c7789473ecb` — BSS-spill peephole SP-read guard).
- **Density-issues er PARKET indtil llvm-z80 upstream miscompile-arbejdet er færdigt** (bekræftet 2026-09-17). Konkret: #314, #323, #340, #326, #315, #313, #298, #300, #334, #333, #289, #290, #288, autoload 2 KB cap-restaurering, cpnos/rcbios density-regressions. Disse forbliver OPEN på GitHub men markeres ikke som "next up" i triage. Ingen individuel parkerings-kommentar filet (spam). Genoptages efter miscompile-gate cleared.
- Density-issues må ikke bruges til at forsinke en miscompile-fix.
- Undtagelse: hvis en density-fix er en biproduct af en miscompile-fix (samme code path), ok at tage begge — men density er ikke driveren.
- Retning: bringe llvm-z80/llvm-z80 (fork-of-record) til modenhed hvor rettelser kan filtreres videre til llvm/llvm-project. Se også `[[feedback_upstream_routing_two_targets]]` og `[[feedback_explain_before_filing]]`.
