---
name: feedback_upstream_review_local_first
description: Upstream reviewer feedback skal løses lokalt og vises brugeren for godkendelse før push til PR-branch.
metadata:
  type: feedback
---

**Reglen:** INTET sendes udenfor brugerens egne repositories (`ravn/*`) uden udtrykkelig tilladelse. Ved mindste tvivl: spørg først.

Dette dækker: push til PR-branches, kommentarer på issues/PRs, force-push, opdatering af eksisterende PRs som svar på reviewer-feedback — ALT der rammer et eksternt repo.

**Why:** 2026-09-29: suborb kommenterede på PR #3158. Rettede koden, kørte tests — og var ved at committe + force-pushe PR-branchen uden at vise brugeren resultatet eller vente på godkendelse. Brugeren var meget utilfreds. Den eksisterende `feedback_explain_before_filing`-regel dækkede ikke opdatering af eksisterende PRs — den blindvinkel er nu lukket.

**How to apply:** Uanset hvad der skal ske udenfor `ravn/*`: stop, forklar hvad du vil gøre, vent på eksplicit "ja" eller "push" FØR handling. Ingen undtagelser for "små" ændringer.
