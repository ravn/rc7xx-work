---
name: CP/M-86 "big" memory model (DR C §2.4.2) — the target for Watcom large-model cpm86 generation
description: DR C's big memory model (far code across multiple segments, near DGROUP, far/ES heap) fully documented from primary sources — DR C Language Programmer's Guide + CP/M-86 System Guide + FlexOS Programmer's Utilities Guide (renumbered edition of the same LINK-86 manual DR C's guide cites). Reference for Watcom FORMAT CPM86 phase-2 (large model); small model works today, big does not.
metadata:
  type: reference
---

Primary source: **DR C Language Programmer's Guide §2.4 "Memory Models"**
(`cpm86-crossdev/docs/manuals/DRI_C_Programming_86.txt`, lines ~1886-2033;
`[[reference_dri_cpm86_manuals_location]]`). It is the authoritative reference
because small model works on the native Watcom cpm86 target today but **big
does not** (`[[reference_watcom_cpp_cpm86]]`), and big model is the path past
the 64 KB/segment small-model wall toward the full RC759 TPA (~293 KB).

## The product only has two models: small and big

Direct quote (§2.4): *"The C compiler supports two different memory models...
small [and] big."* No medium/compact/large — unlike some other DRI C products
(the shared, multi-OS `startup.a86` crt0 source carries a generic C32/D32
`Small/Medium/Compact/Large` selector table used elsewhere in the DRI
toolchain family, but the **CP/M-86 C product itself only exposes these two**
via the compiler's `-b` flag). Don't reach for "compact"/"medium" language
when describing this — it isn't part of this product's vocabulary and only
confuses the mapping.

## §2.4.2 Big Memory Model — as stated in the manual

> Use the big model for programs that use a maximum of 64K bytes of data, a
> maximum of 64K bytes of stack, but require a large code section and heap.
> To specify big model compilation, use the `-b` command line compiler
> option... All program code segments are separate segments with a unique
> name. No individual code segment can exceed 64K bytes. The total amount of
> code is limited to the amount of available memory... The stack occupies a
> separate segment limited to 64K... The heap data occupies the extra
> segment. The heap size is limited only by the amount of available memory
> and is adjustable at link time.

So, precisely:
- **Code**: NOT grouped into CGROUP (unlike small model). Every code segment
  separate, unique name, each ≤64 KB (8086 hardware limit on any *one*
  segment — not a DR-C-imposed limit), total code = available memory. Inter-
  segment calls are far (confirmed elsewhere in the manual, line ~5573:
  *"Calls to assembly functions under the big model use far calls"*).
- **Data (DGROUP)**: near, ≤64 KB, same as small model — all data + common/
  external segments grouped together.
- **Stack**: its own segment, capped at 64 KB (same cap as small model's
  stack) — big model does NOT relax the stack limit, only code and heap.
- **Heap**: the extra segment (ES), grows up, size limited only by available
  memory (≈1 MB), adjustable at LINK-86 time. This is the ONE thing that
  grows past 64 KB on the data side.
- Selected with `-b`; links `CLEARL.L86` (big-model crt0/lib) vs `CLEARS.L86`
  for small.
- Figure 2-2 layout (low→high physical memory): CODE SEGMENT(s) [CS] →
  DGROUP ≤64 KB [DS] → STACK ≤64 KB [SS] → HEAP grows-up, max available
  memory [ES].

Contrast small model (§2.4.1): single CGROUP ≤64 KB + single DGROUP ≤64 KB,
heap on top of DGROUP data growing up toward a stack growing down inside the
*same* DGROUP — no separate stack or heap segment at all.

## Section-number cross-reference — resolved

§2.4's own text says: *"read Section 7 in the Programmer's Utilities Guide on
LINK-86 first. Section 7.5 in the utilities guide explains how LINK-86
combines the different program segments into groups and positions them in
the executable .CMD file. Section 7.5.2... defines... CGROUP... DGROUP."*
That "Programmer's Utilities Guide" is **not** cached under that exact title,
but the cached **FlexOS 286 Programmer's Utilities Guide**
(`scratch/rc759-cmd-toolchain/docs/1073-2043-001_FlexOS_286_Programmers_
Utilities_Guide_1986.txt`) documents the identical LINK-86 tool almost
verbatim — because **FlexOS 286 is a later, renamed edition of CP/M-86
itself** (Digital Research's own OS lineage, not just "another DRI product
that happens to share the linker" — user, 2026-08-18), so its Utilities Guide
is directly the successor edition of the very manual DR C's guide cites, just
reorganized/renumbered (its LINK-86 chapter is "§7", command-file options are
"§7.7" instead of "§7.5"). Content, not numbering, is what transfers. This
resolves the earlier open "GAP" (2026-08-16 note) about
whichever numbering — the mechanics below come straight from that chapter.

## How code > 64 KB across multiple segments fits in ONE .CMD header slot

The `.CMD` header's "8 group descriptors" limit (`[[reference_cpm86_cmd_header]]`
— 128-byte header, 8×9-byte Group Descriptors, G-Type 1=Code/2=Data/3=Extra/
4=Stack/5-8=Auxiliary) is **not** a limit on segment *count* — it's a limit on
how many independently-addressed *sections* the file has. A single "Code
Group" descriptor (G-Type=1) covers a section whose `G-Length` field is a
16-bit *paragraph* count, so up to ≈0xFFFF×16 ≈ 1 MB — nothing in the header
caps a section at 64 KB. LINK-86's command-file `CODE[SEGMENT[...],
CLASS[...], GROUP[...]]` option (FlexOS Utilities Guide §7.7.1/§7.7.2, Table
7-2) lets you list an arbitrary number of separately-named 8086 code segments
and have LINK-86 concatenate them all, back-to-back, into that one Code
section. Since a CP/M-86 `.CMD` loads at a **fixed, non-relocatable base
address** (no runtime fixup/relocation table in the ordinary case —
`[[reference_watcom_wlink_cpm86_format]]`), LINK-86 computes each segment's
absolute paragraph address at *link time* and burns it directly into every
far-call/far-pointer reference — no loader relocation needed for the
multi-segment case any more than for the single-segment case. Big model just
means: don't group the code segments into CGROUP (which would force them to
share one 64 KB frame, i.e. small model's default); leave them as separate
segments and they land side-by-side in the same Code Group descriptor,
addressed via far calls.

## How heap > 64 KB works (the Extra Group, G-Type=3)

Same descriptor mechanism, for data instead of code: G-Min/G-Max on the Extra
Group descriptor can request up to ≈1 MB, allocated by the CP/M-86 loader as
ONE contiguous block based at ES. But a *single* 8086 memory access can only
address 64 KB from a given segment base (offset is 16-bit) — the header
mechanism doesn't make one pointer magically span the whole heap; that's a
*compiler/runtime* concern, not a linker/loader one.

**Open sub-question, NOT resolved by the manual text searched so far:**
whether DR C's compiler under `-b` makes *every* pointer uniformly far
(4-byte segment:offset, so the same pointer type transparently reaches both
DGROUP and the heap with no near/far keyword exposed to the C programmer —
plausible, since 1980s K&R-era DR C has no `near`/`far` type qualifiers and
the manual's `malloc`/`calloc`/etc. declarations (§3, `char *malloc()` etc.)
show no model-conditional pointer syntax at all), or whether it does
something narrower (e.g. only heap-typed pointers are far). The generic,
multi-OS `startup.a86` crt0 (`scratch/rc759-cmd-toolchain/drc-oracle/
startup.a86`, `C32`/`D32` flags) shows the codegen-macro layer (`LDX`→`MOV`
vs `LDS`, `CALLC`→`CALL` vs `CALLF`) is switched by a single global model
flag pair, consistent with "pointer representation is a whole-program
setting, not per-variable" — but this is DR-C's *shared* runtime source
across products, not confirmed CP/M-86-specific. **Verify by compiling and
disassembling an actual `-b` TEST.C-style program** (per plan below) rather
than reasoning further from manual text — the manual doesn't state pointer
width explicitly anywhere searched.

If pointers are uniformly far under `-b`, then a *single* malloc'd allocation
is still capped at 64 KB (offset is 16-bit; no "huge pointer" normalization
implied anywhere in the manual), even though the *total* heap can be ≈1 MB
across many allocations, each living in its own far-addressable slice.

## Far vs. huge pointers (why the distinction matters here)

From Watcom's own memory-model docs (`open-watcom-v2/docs/doc/cmn/wmodels.gml`
— generic 8086 terminology, industry-standard, not CP/M-86-specific but
directly explains the mechanism at issue above):

- **Far pointer** (the "big" data model): 4 bytes, 16-bit segment + 16-bit
  offset. Can point anywhere in the 1 MB address space, but **a single object
  must not cross a 64 KB segment boundary** — the compiler enforces this by
  placing each object entirely within one segment. Critically,
  **incrementing a far pointer only adjusts the offset**; Watcom's docs state
  it plainly: *"the compiler assumes that the offset portion of a far pointer
  will not be incremented beyond 64 KB"* — walk past that and the offset just
  wraps (silently wrong), it does not carry into the segment. Consequence:
  a 40,000-`int` array (80,000 bytes) does not fit under far/big — it's one
  object exceeding 64 KB.
- **Huge pointer**: same 4-byte segment:offset layout, but with
  **normalized arithmetic** — incrementing/adding carries offset overflow
  into the segment, so the pointer correctly walks past a 64 KB boundary.
  This removes the big model's single-object-size cap. The cost: every
  pointer increment/index calls a runtime normalization routine — Watcom's
  docs: *"the code generated in the huge data model is not very efficient...
  should be used only if needed."*

Applied to CP/M-86 big model: the DR C manual describes ordinary far-pointer
behavior for the heap (Extra segment) with no mention of huge-pointer
normalization anywhere searched — consistent with "the *total* heap can
exceed 64 KB (many separate far-addressed allocations), but a *single*
allocation/object probably cannot" being the actual DR C behavior, pending
the Phase 0 disassembly check above to confirm.

## Compact model = Stage A's real name (decided 2026-08-18)

Working session with the user landed on NOT inventing a new mechanism at all
— Watcom already has a named model for "code stays 64 KB, data stays 64 KB,
but the heap gets its own far-addressed segment": **compact** (`-mc`, small
code + big data). Source-verified this session:

- `bld/cc/c/cmdlnx86.c`'s model-switch table: `case OPT_ENUM_mem_model_mc:
  ... DataPtrSize = TARGET_FAR_POINTER; bit |= CGSW_X86_BIG_DATA |
  CGSW_X86_CHEAP_POINTER;` — confirmed empirically too (`wcc -mc` predefines
  `__COMPACT__`/`M_I86CM`).
- `bld/clib/heap/c/fmalloc.c`: `#if defined(__BIG_DATA__) void
  *malloc(size_t amount) { return _fmalloc(amount); } #endif` — Watcom
  builds a SEPARATE clib variant per model (already observed:
  `library/msdos.086/mc/clibc.lib` in `bld/clib/builder.ctl`'s DOS section);
  the compact-model variant of that library has plain `malloc()` already
  redirected to the far-heap allocator, INSIDE Watcom's own build — no user
  C code needs to call `_fmalloc()` explicitly, nor know it exists. This was
  an explicit requirement (user, 2026-08-18: "jeg vil gerne have at denne
  mekanisme sker i watcom selv, ikke brugerkode").

**Tradeoff, accepted (user, 2026-08-18: "det er fint compact har 4-byte
pointere"):** compact model makes ALL pointers 4-byte far by default
(`DataPtrSize = TARGET_FAR_POINTER` applies program-wide, not just to
malloc's return type) — every ordinary pointer dereference, not just heap
access, pays the far-pointer cost (extra segment load, no implicit
DS-relative addressing). This is coarser than a hand-built "only heap
pointers are far" scheme would be, but it's free (zero new compiler work)
and it's what "compact model" has always meant on every other 8086 Watcom
target — reusing existing, well-tested machinery beats inventing a
CP/M-86-specific pointer-width scheme.

**Documented split going forward:**
- **small** (today, unchanged) = 64 KB code + 64 KB data, with heap AND
  stack both sharing that same 64 KB DGROUP (as documented above, §2.4.1).
- **compact** (Stage A target) = 64 KB code + 64 KB data, PLUS a separate
  far-addressed heap (Extra/ES segment, `.CMD` G-Type=3) outside DGROUP.
  Stack still shares DGROUP with regular data, same as small — compact only
  moves the heap out, nothing else. All pointers become far under this
  model (see far-vs-huge explanation above for what that costs).
- **big model** (DR C's own two-model vocabulary, Stage B target) remains
  the *harder* one: multiple far CODE segments too, not just a far heap —
  this is closer to what Watcom would call **large** (`-ml`: big code + big
  data) than compact, since it needs far calls as well as far data. Confirm
  this mapping empirically when Stage B starts (Phase B3 in the plan) rather
  than assuming.

## How you actually tell CP/M-86 how much heap you want

The real LINK-86 syntax, found as **live (commented-out but authentic)
examples in DR C's own build scripts** —
`scratch/rc759-cmd-toolchain/drc86111/{DRC,BUILD,MAKE}.BAT`:

```
rem cpm86 link86 %1=srcfile [extra[max[7000]]], %2
rem cpm86 link86 %1=srcfile, %2 [extra[max[3000]]]
```

i.e. `LINK86 prog=srcfile [EXTRA[MAXIMUM[hex-paragraphs]]]` — matches the
FlexOS Utilities Guide §7.7.1 Table 7-2 `EXTRA` file-section option exactly
(abbreviation `M` for `MAXIMUM`, paragraph units, hex). `7000H` paragraphs =
0x70000 bytes ≈ 448 KB — a "give me most of the TPA" example value. **This
is link-time only** — there is no runtime "ask CP/M-86 for more heap" call;
whatever `MAXIMUM` (and optionally `ADDITIONAL` for a guaranteed *minimum*,
Table 7-2's other EXTRA-relevant parameter) you link with becomes the fixed
Extra Group Descriptor's G-Max (and G-Min) in the `.CMD` header — the loader
allocates that once, at program load, and that's the heap's ceiling for the
whole run.

**Note DR C's own default is to specify NOTHING** (`cpm86 link86
%1=srcfile`, no `EXTRA[...]` at all, in the actual non-commented command
these batch files run) — per FlexOS Utilities Guide Table 7-3's defaults,
`EXTRA`'s default `MAXIMUM` is **0**. That's consistent with EXTRA being the
one section with no program *content* driving its size (unlike CODE/DATA,
whose size the linker can infer from what's actually placed in them) — if
nothing in the linked program ever references an Extra-group symbol, there's
nothing to size, so it defaults to nothing. **Our wlink port's new
heap-size option (Phase A1: working name `OPTION FARHEAP=<size>`) is the
direct equivalent of this `EXTRA[MAXIMUM[...]]` LINK-86 syntax** — same
semantics (link-time-fixed ceiling, written into G-Max), possibly worth
naming/spelling it to visually echo LINK-86's own `EXTRA[MAX[...]]` for
anyone cross-referencing against DR C's toolchain, rather than inventing
unrelated terminology.

## "Big model" ↔ Watcom naming — PARKED (user, 2026-08-18)

Explicitly deferred: don't chase whether DR C's "big model" (Stage B) maps
to Watcom's `large` (`-ml`) or something else until the linker-behavior
side of Stage A/B is well understood first ("det gemmer vi til du har styr
på hvordan linkeren skal opføre sig"). The earlier paragraph above floating
"large" as the likely candidate stands as a *guess*, not a decision — revisit
only when Stage B actually starts (Phase B3).

Deferred-task complement: `[[reference_watcom_wlink_cpm86_format]]` (FORMAT
CPM86 is phase-1 small-model-only today; 8080 model rejected). Implementation
plan: `tasks/plan-cpm86-big-model-2026-08-18.md`.
