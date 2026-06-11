---
name: minimal-repro-before-source-dive
description: For "why does X fail" questions, do a 30-second minimal repro BEFORE reading the implementation source. The repro answers the actual question (does it fail in this OTHER form too?) much faster than grammar/parser spelunking, and once the repro narrows the failure surface, source-reading becomes targeted instead of exploratory. Don't post "suggested fix" lines in filed issues without first proving the suggestion via repro.
metadata:
  type: feedback
---

**Rule:** when investigating "why does X fail under tool Y", default
to:

1. **Minimal repro first.** Strip the failing input to the smallest
   self-contained form. Try variants the assumed root cause predicts
   would NOT fail. If the variants ALSO fail, the root cause is
   wider than assumed.
2. **Source-read second**, targeted by what the repro revealed.

Don't reverse the order. Reading the implementation when you don't
yet know whether the failure is local or systemic wastes the read.

**Why:** session 2026-06-11 #114 investigation. I was asked "why
isn't `retain` ignored under SDCC". I started by reading SDCC.y to
find the attribute grammar (6+ tool calls in z88dk's src tree),
investigated whether SDCC's preprocessor defined `__attribute__`
away, attempted a Docker run that failed. THEN finally ran:

  echo '__attribute__((used)) const int a = 1;' > t.c
  zcc +z80 -clib=sdcc_iy -Cs"--std-sdcc23" -c t.c
  # syntax error at column 15 -- the second '('

Which immediately showed `used` fails identically to `retain` — the
root cause was the entire `__attribute__` keyword, not the
`retain` token. Five seconds of work would have told me where to
read (or whether I needed to read at all). Instead I read first
and the reads were unfocused.

Worse: I had already filed #114 with a "Suggested fix: guard
`retain`" line — a fix predicated on the wrong root cause. Posting
that suggestion without verifying it was a guess masquerading as
analysis. The correct issue body would have said "root cause TBD,
fix candidates X/Y/Z to be chosen after repro".

**How to apply:**

1. Before reading parser/lexer/runtime source to explain a build or
   parse failure: write the smallest 1-3 line repro that exhibits
   the failure, and 1-2 variants that the assumed root cause says
   SHOULDN'T fail. Run them. Only then read source — and only the
   path the repro narrowed you to.
2. Before writing "suggested fix:" or "root cause:" lines in a
   filed issue, prove them via repro. If you can't prove yet, say
   so explicitly ("root cause TBD") rather than guessing.
3. The 30 seconds the repro takes is shorter than the typical
   parser-source spelunk. Even if the source-read would have been
   right, the repro corroborates and rules out alternate causes
   you haven't thought of.
4. Exception: if you have NO way to run the repro (no compiler /
   tool / environment), then source-read is the only option. State
   that constraint explicitly.

Related rules:
- [[file-bugs-not-fixes]] — upstream filings are bugs, not fix
  proposals; analogous discipline: don't claim a fix until you
  understand the cause.
- [[dig-deeper-before-parking]] — also "do the work before giving
  up"; this rule is "do the work in the right order".
- [[diff-binaries-before-blaming-codegen]] — parallel: cheap mech
  -anical check before semantic analysis.
