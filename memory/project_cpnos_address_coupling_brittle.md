---
name: cpnos.com / resident BIOS address coupling is brittle
description: cpbios.asm shim layer was placed on the wrong side of the cpnos-rom / cpnos.com build boundary; should follow the rcbios pattern instead
type: project
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
`cpnos-build/src/cpbios.asm` hard-codes the resident BIOS-JT addresses
as `.equ` constants (`rbcout EQU 0ED0Ch`, etc.) and contains shim
wrappers (`coshim`/`cshim`/`cishim`/`lshim`) that translate the CP/M
register convention (char in C, BC/DE preserved) to clang `sdcccall(1)`
(char in A, callee-saves-nothing).

**When this came in:** commit b2bf1f8 (2026-04-22) — "cpnos-rom: replace
DRI Altos cpbios.asm with RC702 trampoline; keep traces".  The commit
message states the shim layer's purpose explicitly: bridging the ABI
mismatch + register preservation.

**Why it's the wrong cut:** the same problem (clang sdcccall(1) ↔ CP/M
ABI) was already solved correctly in `rcbios-in-c/clang/bios_shims.s`,
where each BIOS-JT entry is a `_<entry>_shim` label that does the
register translation and tail-jumps to the naked C body.  Both shim
and body live in the **same build** — no cross-build address coupling,
no risk of drift.

In cpnos-rom the equivalent shims were exiled to `cpnos-build/src/`,
which is a separate RMAC+LINK build that produces the network-loaded
`cpnos.com`.  Result: every time the resident BIOS-JT VMA moves, the
hand-typed `rbcout`/`rbconst`/... constants in cpbios.asm must be
updated **and** cpnos.com must be relinked **and** every disk image
that carries cpnos.com must be refreshed.  Missing any step is
silent: cpnos.com loads, CCP runs, but every console byte routed
through the shim chain lands in the wrong place (today: 0xDE0C ended
up inside loaded NDOS code).

**Bonus trap:** two MP/M disk images carry their own copy of cpnos.com
(`mpm-net2-1.dsk`, `cpnetsmk-1.dsk`); the launcher prefers the smoke
disk if present, so updating only the library disk silently fails.

**Why this is documented:** burned a long debugging session
2026-04-25.  User flagged the architectural mistake afterward; this
note exists so future-me sees the WHEN/WHY/correct-pattern when
encountering similar symptoms.

**How to apply:**
- Don't add new hand-typed cross-build address constants.  If a
  resident-side address must be referenced from a network-loaded
  binary, generate the constants from `nm` of the resident ELF into
  a `.inc` file the disk-side assembler `INCLUDE`s.
- Better: don't put the shim there at all.  Follow the rcbios pattern:
  shim in the resident, JT entries point at `_<entry>_shim`, shim
  saves regs + translates args + tail-jumps to the naked C body.
- The disk-side cpbios.asm should ideally do nothing more than its
  17-entry `BIOS:` table whose entries `JP rb<entry>` directly into
  the resident's JT slots — no register manipulation in cpnos.com.
- If a CP/NOS regression looks "healthy on the wire but no local
  console output", suspect this coupling first.
- Single-disk-image install is now wired into `make cpnos-install`
  (refreshes both `mpm-net2-1.dsk` and `cpnetsmk-1.dsk`); don't
  bypass it.
