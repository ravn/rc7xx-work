---
name: feedback_adapt_to_upstream_static_frame
description: For #316 static-frame regression (and similar upstream-overlap cases), focus on adapting OUR side to upstream, not maintaining a divergent fork of our old mechanism.
metadata:
  type: feedback
---

Bruger 2026-09-11, om #316 (static-frame gået inert efter 23.1.0): **"fokus skal
være på at tilpasse os upstream."**

Kontekst: brugerens egen `Z80AutoStaticStack`/`AutoStaticFrame` (maj–aug 2026,
auto-inject `+static-frame` på ikke-rekursive fns) blev funktionelt afløst af
upstreams uafhængige `Z80NonReentrant`+`Z80StaticFrameAlloc` (2026-09-06), som er
enevældig skriver af `"nonreentrant"` (den attribut `usesStaticFrame` kræver) og
strengere pga. en syntetisk `CallsExternalNode→ExternalCallingNode`-kant.

**Why:** brugeren vil ikke bære en divergent fork af sin gamle analyse; upstream er
retningen. Genindsæt IKKE den gamle mekanisme som autoritet (det var "Mulighed 3",
forkastet).

**BESLUTNING 2026-09-11 (bruger):** vi implementerer IKKE selv — vi beder **upstream
træffe en arkitektbeslutning**. Bevist undervejs: (a) build-vejen (whole-program +
internalisér) genopretter stort set intet på autoload (2→3), fordi ISR'en når hele
programmet gennem den eksporterede entry; (b) en per-modul-stramning til *lokalt*
address-taken er USUND — lit-testen `static-frames-indirect-isr.ll` afviser den korrekt
(ekstern-linkage kan være address-taken i anden TU). Enhver sund per-modul-fix =
upstreams nuværende adfærd. Densitet kan kun genvindes sundt via whole-program-signal
ELLER en programmør-assertion (`assume-nonreentrant`, symmetrisk til `no-static-frame`
opt-out). Derfor: **arkitektur-beslutnings-forespørgsel til llvm-z80/llvm-z80.**

**How to apply:** udkast ligger i `llvm-z80/tasks/upstream-draft-static-frame-architecture.md`
— fil IKKE uden bruger-go-ahead (per [[feedback_explain_before_filing]]); route =
llvm-z80/llvm-z80 (Z80-specific), aldrig official llvm; intet fork-ejer-navn; ingen PR.
Fuld gennemgang: `static-frame-316-options-explained.md` (§1-10) +
`analysis-static-frame-regression-2026-09-11.md`. Relateret:
[[feedback_static_stack_nonrecursive_only]] (static-frame-fejl miskompilerer TAVST).
