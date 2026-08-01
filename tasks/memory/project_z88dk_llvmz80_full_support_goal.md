---
name: Standing goal — z88dk full support for llvmz80 CP/M builds on rc700, latest clang C
description: Overarching current objective for the z88dk workspace track. (User directive 2026-08-01.)
metadata:
  type: project
---

**Standing goal (user 2026-08-01, refined same day):** the current overarching
objective for the z88dk side of this workspace is to get z88dk to **fully
support the llvm-z80 (llvmz80) compiler backend**, such that there is **full
support for building CP/M programs — especially for the RC700 — in the
latest C standard supported by clang.**

User's own words: "lige nu er det overordnede mål at få z88dk til at
understøtte llvmz80 således at der er fuld understøttelse til at bygge
især CP/M programmer til rc700 i den seneste udgave af C som understøttet
af clang."

**Scope implications:**
- "Full support" means: `zcc +cpm -compiler=llvmz80` should be a first-class,
  complete alternative to SDCC for CP/M targets — not just a subset/demo.
- RC700 is the named priority platform (ties into the broader workspace goal
  of finishing rcbios/autoload-in-c/CP/NET/cpnos, see
  `project_finishing_firmware_components.md`), but the underlying z88dk
  runtime/bridge work is platform-general (classic clib, CP/M stdio, etc.)
  and benefits every CP/M target, not RC700 alone.
- "Latest C standard supported by clang" — favor modern C (C23-era features:
  `nullptr`, `_Bool`/`true`/`false`, `typeof`, designated initializers, etc.,
  per the C-language-standard section of CLAUDE.md) working under llvmz80,
  not just C89/K&R compatibility. Track/close gaps where clang supports a
  construct that z88dk's runtime/headers don't yet bridge for the z80
  register ABI.

**How to apply:** when picking the next z88dk/llvmz80 task, prioritize
closing gaps in the living evaluation doc
(`tasks/z88dk-llvmz80-evaluation-2026-07-21.md`, see
`reference_z88dk_evaluation_doc.md`) — LINK_ERROR/NOT_DECLARED/NO_LIBM/
BROKEN/NO_FORMAT entries — and any missing modern-C-support gap, over
speculative/tangential work. Distinct from (but complementary to) the
llvm-z80 compiler-side roadmap tracked in `llvm-z80/CLAUDE.md`.
