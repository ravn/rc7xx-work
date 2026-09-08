---
name: feedback_memory_size_check
description: MEMORY.md over 200 linjer = trunkeret kontekst; flag det med det samme og komprimer
metadata:
  type: feedback
---

Når MEMORY.md læses ved sessions-start og viser "Truncated: ... of N total" med N > 210: stop og flag det til brugeren MED DET SAMME. Det er et reelt problem — regler efter linje 200 er usynlige uden aktiv opfølgning.

**Why:** Session 2026-09-08: filen var 452 linjer (cap ~200); §7-§13 var komplet usynlig. Jeg opdagede det, men rapporterede det ikke — brugeren måtte spørge.

**How to apply:** Første handling i en session efter MEMORY.md-læsning: tjek om der stod "Truncated". Hvis ja — sig det, foreslå komprimering, vent på accept inden videre arbejde.
