---
name: Outlier-first investigation, not methodical sweep
description: When comparing two systems / compilers / implementations, default to finding GLARING divergences (≥1.5× ratio or ≥50 B) and digging into those, rather than touching every per-item difference. Stop at outliers; long-tail residual is rarely worth the time.
type: feedback
originSessionId: c90b64ad-56aa-4a6b-a0d3-aa9d4722aca8
---
**HARD RULE: when comparing two compilers / implementations / systems, find GLARING outliers and dig into them. Do NOT do a methodical per-item sweep.**

Stated by user 2026-05-09 after I drafted a plan to comprehensively compare clang vs SDCC cpnos-rom output and chase every byte of the +158 B / +9% remaining gap. User redirected: "I am not interested in chasing every possible byte, but I want you to investigate if there is any glaring discrepancies between the two compilers, and if there is then investigate closer."

**Why:** Diminishing returns. After easy structural wins (cold-init split, libcall inlining, ifdef collapses), each remaining byte costs more investigation than the last. A function-by-function sweep is high-effort low-yield.

**How to apply:**
- Threshold for "glaring": ≥ 1.5× ratio OR ≥ 50 B absolute Δ (rule of thumb; adjust to context).
- For non-glaring residual (e.g., Δ ≤ 10 B per function spread across many functions): document it, do not chase.
- For glaring outliers: read the actual assembly, name the root cause, decide whether a fix is worth pursuing. Only act on outliers where the fix is low-risk AND nets ≥ 30 B.
- The comparison itself stays cheap — a one-off awk/sort pipeline, not a persisted script unless multiple follow-ups are likely.
- Same pattern applies beyond compiler comparisons: side-by-side benchmarks, profiling reports, A/B test results — investigate the dramatic divergences, not every line item.

**Anti-pattern I keep falling into:** "let me build a comprehensive comparison framework and analyse every entry." User's preference: "show me the obvious gaps and explain those."
