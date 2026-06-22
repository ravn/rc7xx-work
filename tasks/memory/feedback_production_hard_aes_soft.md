---
name: production-hard-aes-soft
description: Production is the hard goal; AES + compiler-comparison + upstream-correctness are important but soft. Audit work spans both, fix priority follows production.
metadata:
  type: feedback
---

User-stated priority frame (2026-06-21):

> AES is important too.  I strive for compiler correctness for
> upstream submissions, but the hard goals are production oriented.

**Why:** when scoping any cost-model / regalloc / codegen investigation,
the production triplet (autoload-in-c / cpnos-in-c PROM1 / rcbios BIOS)
is the *load-bearing* workload -- it must work, byte-counts must
stay in their hard caps, MAME boots must succeed.  AES corpus +
compiler-comparison-corpus are *additional* signal that informs
upstream credibility and benchmark stories, but they don't gate
production decisions.

**How to apply:**
- Empirical audits should cover BOTH production AND AES at minimum;
  ignoring AES misses gaps that production's `-disable-lsr` etc.
  hide.
- When ranking fixes by leverage, weight production wins higher than
  AES-only wins.  A fix that helps both is best; a fix that only
  helps AES at LSR-active configs is interesting but lower priority
  than a fix that moves a production byte.
- When AES and production findings diverge (e.g. production clean,
  AES has gaps), the gap is real but the production framing has
  already absorbed the cost (via flags / sledgehammers / parked
  features).  Acknowledge both before recommending.
- When the only candidate fixes are AES-only, they're often candidates
  for upstream-submission framing rather than production-quality
  improvements -- different filing route, different acceptance
  criteria.

Related: [[feedback_explain_before_filing]] (upstream filings need
per-filing go-ahead; production fixes don't);
[[project_finishing_firmware_components]] (the four production
components are the "finished" bar this work serves).
