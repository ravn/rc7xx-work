---
name: feedback_upstream_review_local_first
description: Upstream reviewer feedback skal løses lokalt og vises brugeren for godkendelse før push til PR-branch.
metadata:
  type: feedback
---

**Reglen:** Når en upstream reviewer (suborb, feilipu, m.fl.) kommenterer på en PR, løses feedbacken LOKALT. Præsenter ændringen i chat. Vent på eksplicit go-ahead FØR push til PR-branch eller force-push.

**Why:** 2026-09-29: suborb kommenterede på PR #3158 om duplikeret logik. Rettede koden, kørte tests — og var ved at committe + force-pushe PR-branchen i ét hug uden at vise brugeren resultatet eller vente på godkendelse. Brugeren afbrød og var meget utilfreds.

**How to apply:** Løs feedback → kør tests → vis diff/forklaring i chat → vent på "ja" eller "push" → DEREFTER commit og push.
