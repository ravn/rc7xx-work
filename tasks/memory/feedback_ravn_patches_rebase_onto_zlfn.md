---
name: feedback-ravn-patches-rebase-onto-zlfn
description: Ravn's arbejde er altid patches oven på zlfn's upstream beslutninger — aldrig merge-equals, altid rebase
metadata:
  type: feedback
---

**The rule (stated by user 2026-10-11):**
> "alle mit arbejde skal lægges ovenpå hvad zlfn beslutter sig til"

**Hvad det betyder konkret:**

Når zlfn (ejer af `llvm-z80/llvm-z80` upstream) laver ændringer der
overlapper med ravn/-forkens arbejde, er zlfn's valg autoritativt.
Ravn's egne commits er altid "patches oven på" — aldrig "parallel
sideløsning der merges som ligeværdig".

**Praktiske konsekvenser:**

1. **Konflikt-opløsning ved merge af upstream work:** behold zlfn's
   version, cherry-pick ravn's unikke tilføjelser oven på. Ikke
   "cherry-pick bedste fra hver side".
2. **Design-valg:** når ravn/-forken har en pragmatisk shortcut
   (fx hardcoded symbol-navne) og zlfn landede en principiel vej
   (fx libcall-table-routing), skiftes ravn's tilgang ud med zlfn's.
   Ravn's shortcut er en workaround der ophæves ved rebase.
3. **Branch-strategi for upstream-integration:** `git rebase upstream/<zlfn-branch>`
   på ravn's work-branch, ikke `git merge upstream/<zlfn-branch>` på ravn/main.
   Rebase gør det eksplicit at ravn's commits er top-layer.
4. **Beslutnings-præcedens:** hvis zlfn og ravn har forskellige views
   på et design (fx calling convention default, triple-struktur),
   venter ravn på zlfn's beslutning og bygger derpå. Ravn påvirker
   gennem forklaring/PR-review ([[feedback_explain_before_filing]]),
   ikke gennem parallelle alternative implementationer.

**Why:** zlfn er owner-of-record for `llvm-z80/llvm-z80`-økosystemet
og den som indleder design-samtaler. Ravn's fork er en produktions-
sti (RC702 PROM-firmware) hvor nogle ting SKAL fungere nu — pragmatiske
patches er OK som interrim, men de må aldrig låse ravn/-forken til
en divergent arkitektur. Når upstream opstiller en bedre vej,
adopteres den.

Konkret kontekst 2026-10-11: upstream PR
`llvm-z80/llvm-z80#112` erstatter ravn's "minimal viable product"
z88dk-integration (ravn/#396 cdf7fba) med en infrastruktur baseret
på `RuntimeLibcalls.td` + nye `CallingConv`-værdier. Planen for
integration (`llvm-z80/tasks/plan-integrate-zlfn-pr112-z88dk-runtime.md`)
rebaser ravn-patches oven på zlfn's stak, ikke merge-og-opløs.

**How to apply:**

- Ved upstream-integration: default til `git rebase` eller
  cherry-pick-oven-på, ikke `git merge`.
- Konflikt-opløsning: zlfn's side vinder altid; ravn's bidrag beholdes
  som specifik tilføjelse, aldrig som alternativ.
- Hvis en ravn-patch nu er overflødig (zlfn landede en bedre løsning):
  drop patchen; dokumenter at det var en interrim.
- Design-diskussioner udløses af zlfn's beslutninger, ikke af vores
  implementationer. Vi forklarer, foreslår, reviewer — vi presser ikke.
- Hvis en upstream-beslutning er direkte problematisk for RC702-pipelinen:
  rapportér til bruger, lad bruger facilitere diskussionen med zlfn.
  Lav ikke en parallel implementation uden eksplicit tilladelse.

**Supersedes/strengthens:** [[feedback_ravn_open_upstream_never]]
(acting i ravn/* ok, upstream ikke uden go-ahead) + 
[[feedback_explain_before_filing]] (forklar vores bidrag ved filing).
Denne regel går dybere: ravn/-forken er altid downstream af zlfn,
ikke parallel.

Relateret: [[feedback_upstream_routing_two_targets]] (hvor filer
hvor), issue llvm-z80/llvm-z80#112 (den konkrete trigger).
