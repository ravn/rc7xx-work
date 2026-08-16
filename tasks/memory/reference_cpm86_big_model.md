---
name: CP/M-86 "big" memory model (DR C §2.4.2) — the target for Watcom large-model cpm86 generation
description: DR C's big memory model (far code, near data, heap in ES) is the reference structure Watcom FORMAT CPM86 must emit for large-model programs (phase-2); small model works today, large does not.
metadata:
  type: reference
---

The DR C Language Programmer's Guide **§2.4.2 "Big Memory Model"** describes the
CP/M-86 large-model layout we need Watcom to generate (user, 2026-08-16). It is
the authoritative reference because small model works on the native Watcom cpm86
target today but **large does not** (`[[reference_watcom_cpp_cpm86]]`), and big
model is the path past the 64 KB/segment small-model wall toward the full RC759
TPA (~293 KB). Manual: `cpm86-crossdev/docs/manuals/DRI_C_Programming_86.{pdf,txt}`
(`[[reference_dri_cpm86_manuals_location]]`).

**KNOWN (verified from §2.4.1/§2.4.2, this session):**
- Selected with the DR C **`-b`** option; links against **`CLEARL.L86`** (big-model
  crt0/lib), vs `CLEARS.L86` for small.
- **Code = far, multiple segments.** Code is NOT grouped into CGROUP. Every code
  segment is a SEPARATE segment with a unique name; no single code segment > 64 KB;
  total code limited only by available memory. (Do NOT use RASM-86 GROUP to put
  code in CGROUP as small model does.) → inter-segment (far) calls.
- **Data = near, one DGROUP ≤ 64 KB** (DS). All data + common/external segments
  grouped together, same as small model.
- **Stack = its own segment ≤ 64 KB** (SS). Initial size set in the runtime
  start-up; final size adjustable at LINK-86 time.
- **Heap = the extra segment** (ES), grows up, size limited only by available
  memory, adjustable at link time.
- Figure 2-2 layout (low→high): CODE SEGMENT(s) [CS] · DATA/DGROUP ≤64K [DS] ·
  STACK ≤64K [SS] · HEAP grows-up = max available memory [ES].

Contrast small model (§2.4.1): single CGROUP (≤64K) + single DGROUP (≤64K), heap
on top of data growing up toward a stack growing down — all within DGROUP.

**INFERENCE (not yet verified — my mapping, treat as guess):** DR C "big"
(far code / near data) maps to Watcom's **medium** model (`-mm`, far code + near
data), or **large** (`-ml`) if far data is also wanted. The user says "large";
confirm which Watcom model actually produces the multi-code-segment .CMD before
relying on it.

**GAP / next reference to fetch:** the exact .CMD group-descriptor mechanics for
multiple code segments (how LINK-86 combines segments into groups and positions
them in the .CMD, and how the CP/M-86 loader relocates >1 code group given only 8
header descriptors) live in the **Programmer's Utilities Guide §7.5 / §7.5.2
(CGROUP/DGROUP)** — which the manual cites but which is **NOT cached in the
workspace** (verified 2026-08-16). Fetch/analyse it before implementing Watcom
FORMAT CPM86 phase-2 large model. Deferred-task complement in
`[[reference_watcom_wlink_cpm86_format]]` (FORMAT CPM86 is phase-1 small-only;
8080 model rejected).
