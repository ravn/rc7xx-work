---
name: Compiler zoo fast first
description: Run quick tests first in compiler-zoo, full suite only when explicitly asked
type: feedback
---

Run the fastest/smallest tests first in compiler-zoo comparisons. Only run the full suite (all benchmarks + all categories) when explicitly asked.

**Why:** The full suite takes many minutes (41 programs × 2 compilers × Docker). During iterative development, run a quick subset first.

**How to apply:** Use `--program` filter for quick checks. Default `make` should run just the bench_* programs. Add a `make full` target for bench_* + _cat_*.
