---
name: C23 subset for sources
description: Use tested C23 features when refactoring — both compilers support them
type: feedback
---

When refactoring, use C23 features that are tested working in both clang Z80 and z88dk zsdcc 4.5.0. Prefer these over older equivalents (e.g. `true`/`false` keywords over `stdbool.h`, `nullptr` over `NULL`).

**Why:** Both compilers support a useful subset of C23. Using modern idioms improves readability without breaking either build.

**How to apply:** See CLAUDE.md "C Language Standard" section for the full tested/not-working list. Key safe features: `true`/`false`, `nullptr`, `0b` literals, `typeof`, `_Static_assert`, for-loop declarations. Do NOT use: `constexpr`, `[[attributes]]`, digit separators.
