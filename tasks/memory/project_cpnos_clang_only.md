---
name: cpnos-rom — dual-compiler port in progress
description: cpnos-rom was clang-only through 2026-04-26 then user reversed direction 2026-05-05 ("please make cpnos build with sdcc"); active port from clang-only to clang+SDCC dual-build
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
**Status update 2026-05-05:** the user reversed the earlier
clang-only stance with a direct directive to make cpnos-rom build
under SDCC.  Port is in progress.  History below preserved for
context.

**Earlier (still applies during transition):** cpnos-rom is allowed to
be clang-only.  Reaffirmed by user 2026-04-26 during Phase 3
(naked-C migration).

**Why:** rcbios-in-c is dual-compiler (SDCC + clang) for historical
reasons — it predates the LLVM-Z80 backend being viable.  cpnos-rom was
written after clang Z80 became usable and never needed an SDCC build
path.  The user's "for now" leaves room to revisit if priorities
change, but as of 2026-04-26 the project is single-target.

**How to apply:**
- When migrating cpnos-rom code, use clang-native idioms freely:
  `__attribute__((naked))`, `__asm__ volatile(...)` with GCC syntax,
  `__attribute__((section(...)))`, designated initializers, etc.
- Don't add SDCC compatibility shims like rcbios-in-c's
  `clang/intrinsic.h` (`#define __naked` to nothing, `#define
  __asm__(x) ((void)0)` to swallow SDCC-style inline asm).  Those exist
  only because rcbios needs both compilers.
- IDE LSP via macOS system clang will flag Z80-specific inline-asm
  syntax (`+{de}` constraints, Z80 mnemonics) as errors.  Those are
  pre-existing false-positives on a Mach-O target that doesn't
  understand the Z80 backend; do not chase them.
- If the user ever asks to make cpnos-rom dual-compiler, surface this
  memory first so the previous decision is on the table.
