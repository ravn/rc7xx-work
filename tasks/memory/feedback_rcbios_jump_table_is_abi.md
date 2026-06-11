---
name: rcbios-jump-table-is-abi
description: The rcbios BIOS jump table at 0xDA00 is ABI. Any entry that a compiled CP/M program can call (including vendor extensions like the CLOCK entry at 0xDA56) is backward-compat-load-bearing and must not be deleted, repositioned, or stubbed. "Replace with FN-105 over BDOS-66/67" or similar additive paths are fine; "remove because there's a better way now" is not. New entries may be added at end of the table.
metadata:
  type: feedback
---

**Rule:** treat the rcbios BIOS jump table at `0xDA00` as a frozen
ABI for compiled CP/M programs. Entries — including vendor
extensions like the CLOCK entry at `0xDA56` — MUST NOT be deleted,
repositioned, or stubbed even if a "better" wire-level alternative
exists. New paths are additive; old paths stay callable.

**Why:** session 2026-06-11. We had filed #111 to delete the
32-bit CTC-tick counter and its `0xDA56` vendor extension on the
reasoning "FN-105 over BDOS-66/67 (verified by #110) is now the
canonical TOD path". User stopped it: *"#111 is not to be
implemented as it would break backward compatibility."* The rcbios
jump table is exposed to user programs on disk; replacing or
shorting any entry is a binary-compat break for those programs.

**How to apply:**

1. Before proposing to remove or stub ANY entry in
   `rcbios-in-c/bios_jump_vector_table.c`, including vendor
   extensions, ask: "is this entry callable by a compiled CP/M
   program that exists on a system disk?" The default answer is
   YES. Don't propose the removal.
2. "Replace with the new wire path" is the wrong framing.
   The right framing is "**add** the new wire path as a recommended
   route; leave the legacy entry intact". rcbios is willing to
   carry two ways to do the same thing in service of compatibility.
3. New jump-table entries may be added at the END of the table
   (after current last slot) — that doesn't shift existing
   addresses. Inserting in the middle would, and is forbidden.
4. Reposition is forbidden for the same reason as deletion: a
   compiled program calls a fixed address.
5. Behavior changes inside an entry are subject to the same scrutiny:
   if it used to return X and now returns Y, callers can break. Add
   a sub-mode byte (A register dispatch) for new behavior; default
   sub-mode preserves legacy semantics.

**Exception:** the rule does not apply to internal C-level symbols
that are not part of the jump table (e.g. `bios_clock` is fine to
refactor as long as the jump-table slot at `0xDA56` still calls in
correctly). The constraint is on the address-level ABI, not the
implementation underneath.

Related rules:
- [[no-literal-addresses]] — code-internal addresses are
  linker-derived; the jump-table addresses are the EXCEPTION
  (they're the published ABI).
- [[cpnet-12-only]] — analogous "compatibility is non-negotiable"
  constraint for the network protocol layer.
- [[finishing-firmware-components]] — "finished" means stable for
  callers, not "stripped to minimum".
