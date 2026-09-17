---
name: feedback-self-compact-during-long-builds
description: Kør /compact selv under lange byg i stedet for at vente passivt
metadata:
  type: feedback
---

Under lange byg (ninja LLVM debug/asserts, docker-byg af sdcc/z88dk, MAME-boot-tests
osv.) må jeg selv invokere `/compact` i stedet for at sidde og vente på baggrunds-jobbet.

**Why:** Brugeren fortalte det direkte 2026-09-16 mens `build-macos-asserts` blev
genbygget — konteksten var ved at fylde op, og der var ingen grund til at spilde
tokens på venten når komprimering kan ske parallelt.

**How to apply:** Når et baggrunds-job forventes at tage mere end nogle få minutter
(typisk ninja af hele LLVM eller Docker-byg), og der ikke er nyttigt arbejde at
lave sideløbende, kør `/compact` mens jeg venter. Baggrunds-jobbet fortsætter
uforstyrret, og jeg bliver notificeret når det er færdigt.
