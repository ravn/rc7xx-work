---
name: Prefer C over inline asm
description: Whenever the same code can be expressed in C, do not reach for inline asm just because it's slightly smaller; minimal asm is a project goal.
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
In `cpnos-rom` and the rest of `/Users/ravn/z80/`, prefer ordinary C
constructs (for-loops, `__builtin_memcpy`, byte-by-byte stores, etc.)
over hand-written `__asm__ volatile("...")` blocks even when the asm
form saves a handful of bytes.

**Why:** stated project goal -- "as little assembly as reasonably
possible if the same code can be expressed in C".  Reasoning: keeps the
source readable, lets the compiler optimize freely as the backend
improves, makes diffs easy to review, avoids the maintenance tax of
pinning a particular instruction sequence.

**How to apply:**
- Don't replace a small for-loop with an `__asm__ volatile("ldir" ...)` block
  for ~6-10 B.  File an llvm-z80 codegen issue instead so the C form
  improves over time.
- Existing inline-asm blocks (e.g. ZP_INIT LDIR in `cpnos_main.c`,
  insert_line LDDR in `resident.c`) predate this rule and aren't
  in scope to revert until there's a confirmed cleaner C path.
- The "for-copy loop" idiom can often be tightened by writing the
  first element manually and then `__builtin_memcpy`'ing the
  remaining N-1: clang's Z80 backend unrolls full 8-byte memcpys
  but emits an LDIR-via-runtime-stub call for sizes just below 8,
  so the manual-first-byte split drops to a single CALL site.
  Saved 6 B vs for-loop in `netboot_mpm.c` LOGIN copy 2026-04-30.
