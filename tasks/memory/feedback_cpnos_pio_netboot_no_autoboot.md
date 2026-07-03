---
name: cpnos PIO netboot testing — NO -autoboot_script; drive via host-side SIO-B
description: Any MAME -autoboot_script (even empty) breaks the wall-clock-coupled PIO cpnet_bridge netboot; drive cpnos from a host-side SIO-B socket injector with no autoboot.
metadata:
  type: feedback
---

**HARD (verified 2026-07-03):** when MAME-testing cpnos over the PIO
cpnet_bridge (netboot from mpm-net2), do **NOT** pass `-autoboot_script` —
not even an empty one. The MAME Lua engine, once active, hooks the emulation
loop and perturbs device/scheduler timing enough to break the
**wall-clock-coupled** PIO handshake (MP/M answers in real time on z80pack;
the slave's `RECVBY` has no timeout). The slave stalls after its first LOGIN
byte and hangs at the boot banner.

**Proof it's the autoboot *presence*, not speed/overhead/byte-loss:**
no-autoboot at 210 % MAME → PASS (3367 bridge bytes → E>); empty-autoboot at
235 % (faster) → FAIL (1 bridge byte). The Lua never consumes PIO bytes (no
port reads / read-taps; only memory peeks). Throttling per-frame Lua work
does not help; only removing `-autoboot_script` does.

**How to test instead:** drive the slave from a **host-side SIO-B socket
injector** with no autoboot — cpnos `impl_conin` reads `SIO_B_DATA` when
`console_joined` (resident.c), so keystrokes go in over SIO-B and CONOUT is
mirrored out (same pattern as rcbios `polypascal_pio_inject.py`).
Reference impl: `cpnos-in-c/cpnos_polypascal_inject.py`. Gate MP/M readiness
with `scripts/wait_mpm_ready.py` (ENQ→ACK probe, non-contaminating). Use
`-nothrottle`.

Related: [[project_cpnos_parked_awaiting_parallel_cable]] (the parked
"cpnet_bridge PIO timing can't be MAME-verified" caveat is the same class),
[[feedback_polypascal_stage1_flake]], [[reference_mpm_sys_baked_via_gensys]]
(stale-MPM.SYS footgun: never restore disks/local/mpm-net2-1.dsk from the
pristine library copy — it re-introduces a stale baked-in SERVER.RSP; rebuild
via rebuild-mpm-sys.sh --install). Full writeup:
`cpnos-in-c/tasks/cpnet-tod-and-netboot-findings-2026-07-03.md`.
