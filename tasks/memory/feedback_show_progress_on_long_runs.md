---
name: feedback_show_progress_on_long_runs
description: Vis løbende fremdrift på lange kørsler, ikke kun slutresultatet
metadata:
  type: feedback
---

Brugeren vil se **løbende fremdrift på lange kørsler** (builds, regressioner,
test-matricer) mens de kører — ikke kun det endelige resultat.

**Why:** En tavs baggrundskørsel er ikke til at skelne fra en hængt/racende én
(det skete konkret 2026-08-21: to run-all-models racede tavst, loggen stod tom,
og status var uklar). Live-fremdrift giver tillid til at noget faktisk sker og
afslører problemer tidligt.

**How to apply:** Når en kørsel tager mere end ~30 s, læg en Monitor på der
streamer meningsfulde fasemarkører live (fx "bygger model c", hver PASS/FAIL,
matrix ved slut) — én event pr. faseskift, ikke spam og ikke kun ved slut. Skriv
til en logfil kørslen appender til, og emit nye interessante linjer efterhånden.
Undgå at poll'e stille; brug baggrundskørsel + Monitor. Se også
[[feedback_no_home_search]] for baggrundskørsels-disciplin.
