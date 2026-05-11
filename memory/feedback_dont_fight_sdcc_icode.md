---
name: Don't preempt SDCC's iCode allocator with static-locals
description: SDCC keeps auto-locals in registers within a basic block; forcing them to file-scope static BSS converts cheap register accesses (1 B) to expensive memory accesses (3 B). Don't fight the allocator.
type: feedback
---

When optimizing cpnos-rom or rcbios C code for size on SDCC, **do
not** force locals to `static` BSS to "save the IX frame".  SDCC's
local-only iCode allocator keeps auto-locals in registers within
each basic block; explicit `static` makes every read/write into
`ld a, (var)` (3 B) where SDCC was using `ld a, c` (1 B).

**Why:** Empirical test 2026-05-10 in `cpnos-rom/snios_c.c`: refactored
`try_send_frame` and `try_recv_frame` locals to file-scope `static`
hoping to eliminate SDCC's IX-frame.  Result: SDCC resident +98 B
WORSE (clang -18 B better; net -80 B regression).  The IX-frame
elimination saving (~15 B per function) was outweighed by the
per-access regression × dozens of accesses.

**How to apply:**

- For SDCC: leave function locals as plain `auto` (default).  Trust
  the allocator.  Only consider `static` when:
  - The function takes the address of the local (`&var`) AND that
    address must persist across calls (rare).
  - You have measured the specific IX-frame elimination delta
    AND it exceeds the per-access regression.
- For clang: `+static-stack` (already enabled on cpnos-rom) handles
  the "no-recursion → no-stack" optimization automatically without
  the `static` keyword.  Don't add explicit `static` to mirror what
  `+static-stack` already does -- it makes SDCC worse without
  helping clang.

- The IX-frame is technical debt visible in
  `cpnos-rom/tasks/check_no_frame_ptr_baseline.txt`.  When a
  function shows up there, the right fix is **splitting the function
  into smaller helpers** (so each helper has fewer simultaneously-
  live locals and fits in registers naturally), not forcing all
  locals to `static`.

**Cross-reference:** ravn/rc700-gensmedet#83 documents this lesson
in the Phase 5+6 SNIOS state-machine investigation.

**Diagnostic discipline corollary:** when proposing a size-saving
optimization, always rebuild and inspect with the TARGET build's
actual flags (cpnos-rom uses `--target=z80 -Oz +static-stack
-disable-lsr` plus a long list of warnings).  A quick `clang -Oz`
test compile without those flags can show codegen patterns that
don't exist in the real build, leading to misleading hypothesis-
savings estimates.
