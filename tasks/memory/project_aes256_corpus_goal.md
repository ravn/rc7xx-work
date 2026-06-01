---
name: project-aes256-corpus-goal
description: "AES-256 corpus drives clang-z80 to SDCC parity AND collects SDCC bugs as upstream-bound queue; both tracks file issues with test cases, no fixes here."
metadata: 
  node_type: memory
  type: project
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

**Provenance:** the AES-256 source came from Peter Dassow's Z80 C-compiler
comparison page http://www.z80.eu/c-compiler.html (download
http://z80.eu/downloads/aes256.zip) — byte-oriented AES-256 by Ilya O. Levin
(literatecode.com), CP/M tweaks by Peter Dassow.  Full provenance in the
corpus `README.md`.

The `rc700-gensmedet/tasks/aes256-corpus/` directory has two
parallel strategic goals (see `GOAL.md` in that directory):

1. **Clang track** — drive ravn/llvm-z80 output to zsdcc parity on
   AES (currently 1.42× larger / 4.66× slower). Each per-function
   gap → reduced C reproducer → filed `ravn/llvm-z80` issue.
   First issue: ravn/llvm-z80#156 (+static-stack miscompile).
   Top remaining gaps: `aes_mc_inv` (+549 B), `aes_mixColumns`
   (+289 B), `rj_sb_inv` (+126 B, 5.2×), `gf_log` (+121 B, 4.78×).

2. **SDCC track** — collect zsdcc miscompiles as `ravn/z88dk`
   issues with reproducers (already filed: #5 `--nogcse` late-r
   bug, #6 sdcc_ix wrong AES output). Goal: when SDCC engagement
   deepens, summarise the queue against upstream SDCC.

**Why:** AES is the first real-world C workload where clang loses
to zsdcc by a wide margin, reversing the synthetic micro-corpus
result. The biggest gaps land on exactly the open Phase 3 Cluster
A regalloc issues (#89, #27) per [[project_z80_backend_unfinished]]
and the upstream collaboration model in [[project_z80_upstream_goal]].

**How to apply:** When the user asks for AES-related work, recall
this two-track frame. Don't propose fixes here — fixes land in
`llvm-z80/` (clang) or `z88dk/` (sdcc) in separate sessions,
re-measured here via `make sweep` afterward. The persistent tables
(`clang-flag-sweep.md`, `sdcc-flag-sweep.md`) are the regression
oracle — diff them after any compiler change.

The corpus's `findings.md` has the per-function gap table; the
corpus's `GOAL.md` has the priority order and the
file-but-don't-fix discipline. Issues go to `ravn/llvm-z80` (clang
gaps) or `ravn/z88dk` (sdcc bugs), never upstream directly per
[[feedback_no_upstream_issues]].
