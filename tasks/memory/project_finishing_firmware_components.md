---
name: Long-term goal — finish rcbios, autoload-in-c, CP/NET, cpnos
description: The four firmware components — rcbios, autoload-in-c, CP/NET, cpnos — should be brought to a finished state. (User directive 2026-06-03.)
metadata:
  type: project
---

**Long-term project direction (user 2026-06-03):** bring the four RC702
firmware components to a **finished state**:

  1. **rcbios** — RC700 CP/M 2.2 BIOS (rcbios-in-c).  Currently boots
     end-to-end via the rcbios `mame-test` harness; production size is
     ~5897 B clang vs SDCC ~6091 B (clang −194 B).  See
     `rc700-gensmedet/rcbios-in-c/`.
  2. **autoload-in-c** — RC702 ROA375 boot PROM in C.  Currently boots
     cpnos (PROM1-lineprog path) AND floppy CP/M (verified 2026-06-03
     on `SW1711-I8.imd` to `A>`).  Production size 1658 B / 2 KB hard
     cap.  See `rc700-gensmedet/autoload-in-c/`.
  3. **CP/NET** — networking protocol stack (SNIOS for rcbios; cpnos
     transport_pio/transport_sio).  SIO + PIO transports both verified
     end-to-end via polypascal-test.  See `rc700-gensmedet/cpnet/`,
     `rc700-gensmedet/cpnos-in-c/`.
  4. **cpnos** — CP/NOS PROM1-only slave (cpnos-in-c).  Currently 2022
     B / 2 KB (26 B free), boots through CP/NET to PolyPascal under
     ~51 s.  See `rc700-gensmedet/cpnos-in-c/`.

**Why:** these are the production-target deliverables that the llvm-z80
compiler work is in service of.  All four currently *work*; "finished"
means polished to durable quality (no known bugs, clear docs, oracle
coverage, sustainable size headroom).  The compiler track (closing
ravn/llvm-z80 backlog, AES/cpnos density wins, upstream submissions)
serves these four targets — the compiler is the means, the firmware is
the end.

**How to apply:**
- When prioritising work, prefer items that move one of these four
  components measurably closer to finished (close a known bug, raise
  oracle coverage, recover headroom, document a corner) over generic
  compiler-microbenchmark work.
- Compiler improvements are still valuable — but bias toward those that
  produce a measurable win on at least one of the four (BIOS bytes,
  cpnos bytes, AES corpus speed/size that maps to cpnos, etc.).
- For each component, when in doubt about scope, ask "does this make
  the component more finished, or just more clever?"
- Related: [[project_z80_backend_unfinished]] (the compiler is the
  enabler), [[project_aes256_corpus_goal]] (the AES corpus is the
  compiler oracle that maps to cpnos density),
  [[project_cpnos_prom1_compiler_goal]]-superseded — the 2 KB target
  is achieved; remaining cpnos work is finishing, not shrinking.
