---
name: project-sdcc-slave-stack-room
description: cpnos SDCC PROM1 slave resident must end at/below 0xF60E or its stack (SP=0xF680) overruns into resident SNIOS data -> netboots but hangs at cpnos.sys handoff; a build guard enforces this
metadata:
  type: project
---

**PARKED 2026-07-28** (user direction) as a known problem — tracked in
ravn/rc700-gensmedet#125 (label `parked`). The build guard stays ON (fails the
sdcc build loudly), so nothing ships silently broken; the resident shrink is not
being pursued now. Unpark trigger = user asks to make the sdcc slave boot, or
someone needs the sdcc MAME-only path. clang (production) is unaffected and works.

The cpnos-in-c **SDCC** PROM1 line-program slave has a hard resident-size
ceiling driven by its stack, distinct from the PROM byte budget:

- The slave inits **SP = 0xF680** (sdcc-prom1lineprog/bootstrap.asm). The stack
  grows DOWN. It cannot move higher: 0xF680..0xF7FF are the locale tables
  (needed for SEM702/Danish), 0xF800 is the display.
- The resident image (bios_jt at 0xEE00, growing UP) must therefore END well
  below 0xF680. clang keeps `__stack_low = 0xF60E` (>=114 B reserved stack;
  clang's resident actually ends 0xF5C2 = 190 B free) and boots to E>.
- **SDCC's less-dense output overran this** (2026-07-28): its resident ends at
  0xF62A -- only 86 B of stack, 28 B into clang's reserved zone. A deep netboot
  call chain overruns into the resident SNIOS RODATA/DATA/CHECKSUM
  (0xF61D..0xF62A), silently corrupting it, so the slave netboots RC700.NOS
  fully (dots + locale line print) but then HANGS at the cpnos.sys handoff --
  cpnos.sys's first SNIOS CP/NET frame is malformed, the master never ACKs,
  no E> ever appears.

**Why (diagnosis discipline):** this looked like a boot hang; two wrong
hypotheses were REFUTED with hard data before the real one -- (1) NOT IOBYTE
(console output reaches BOTH the CRT and SIO-B after netboot, so routing works),
(2) NOT address-coupling (clang and sdcc have identical handoff addresses
bios_jt=0xEE00, snios_jt=0xEE33, matching cpnos.sys's NIOS=0xEE33). The user's
"is the sdcc build too big for the space before the stack?" was correct; the
map's `__RESIDENT_CHECKSUM_tail` vs SP=0xF680 is the decisive measurement.

**How to apply:** a build guard `cpnos-in-c/cpnos-build/check_sdcc_stack_room.py`
(wired into the sdcc `prom1-lineprog` recipe after pass 2) FAILS the build loudly
when the resident top exceeds 0xF60E -- never ship a silently-broken sdcc slave.
To actually make the sdcc slave boot, shave >= 28 B (ideally ~100 B) from the
SDCC resident (RESIDENT_CODE / z88dk library pull-ins) so it clears 0xF60E, then
verify with `make cpnos-polypascal-test COMPILER=sdcc` reaching E>. This is a
SECONDARY target: sdcc is MAME-only (4 KB PROM, PROMCFG=2), clang is production.
The sdcc BUILD env itself (z80.lib path + object-prereq ordering) was fixed
separately in commit 0ad582d.

Related: [[project_cpnos_address_coupling_brittle]] (the handoff-address
fragility this ruled out), [[feedback_user_guesses_not_constraints]] (probe the
user's guess -- here it was right), [[feedback_audit_oracle_not_just_fix]]
(the guard is the detector built after the bug), [[project_rc702_2kb_prom_hard_limit]].
