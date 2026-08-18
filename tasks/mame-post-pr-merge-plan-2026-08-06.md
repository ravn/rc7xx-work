# MAME post-merge plan — assuming PR #15805 (rc702) lands upstream

Author: Copilot (AI), 2026-08-06. Prompt: "vi antager vores mame pr går igennem."
Status: **planning only** — no code changed. Trigger for execution = mamedev/mame
merges PR #15805 into `upstream/master`.

## Where PR #15805 stands (verified 2026-08-06)

- OPEN, title "regnecentralen: RC702 now working", head `upstream-rc702-clean`.
- **All CI green** (build-linux gcc+clang, windows gcc+clang x64/arm64, macOS,
  include-guard validate all SUCCESS). Previous `action_required` cleared after the
  screen_device rebase; now just waiting on a maintainer to click merge.
- 3 commits, 7 files, +795/−86: `rc702.cpp`, `rc702.lay`, `mame.lst`,
  `pio_port/{keyboard,pio_port}.{cpp,h}` under **`src/mame/regnecentralen/`**.

## What the PR ALREADY carries (will be upstream after merge — do NOT re-file)

- rc702/rc703 driver core, CP/M boot working.
- 560-col screen visarea fix (col 80 on-screen) — `rc702.cpp:707-712`.
- jbox/RC752 amber palette + layout border — `rc702.cpp:500-501`.
- pio_port slot device + keyboard (driver-local path).
- 8275 dot-clock modelled as PLL output; clock consolidation.

## What stays FORK-ONLY after the merge

### A. Local-only forever (must NEVER go upstream)
- **Clang-PROM ROM hashes + disabled ROM warning screen**
  (`610b8aa6587`, `07872bcb27a`, `d0c31e219ca`). Upstream must keep the original
  ROA375/ROA327 hashes; our clang-built PROM has different bytes. Keep as a local
  patch on the fork only.
- **cpnet_bridge diagnostic logging** (µs-timestamp logerror, debugscript fix) —
  intertwined with cpnet_bridge, debug-only.
- **z80 daisy-chain IRQ annotation** (`390ebf4658e`) — debug-only tracing.

### B. Generic MAME bugs — candidates for a SEPARATE upstream PR to mamedev
These benefit all MAME users and are cleanly separable from rc702:
- **z80pio `check_interrupts`: port N.ius must not block port N itself**
  (`2eb88ceac44`, tracked ravn/mame#13). Root cause of the rcbios/cpnos PIO-IRQ
  deadlock. **Highest-value generic fix.**
- **z80pio `set_mode`: set `m_mode` BEFORE the output callback** (`72c5e46cfa7`).
- **luaengine_mem: tap callbacks use `invoke()` not `invoke_direct()`**
  (`7ff227117cd`, tracked mame#10). Needed by our lua test harness; generic.
NOTE: the z80pio logging commit `4ade3656f89` mixes a generic logerror change with
cpnet_bridge diagnostics — cherry-pick only the two clean fixes above for upstream.

### C. rc702 feature follow-ups — possible SECOND rc702 PR to mamedev (optional)
- **rc702sem702** SEM702 RAM-chargen variant (`2ade6a2df82`).
- **2716/2732 PROM socket jumper + 4 KB prom1** (`30cd8e23738`, `d0a7dcd81f2`,
  `9ff362da529`) — needed for the SDCC 4 KB MAME-only path.
- Second floppy drive default, rc703maxi, RS232 defaults, etc. — evaluate per-item.

### D. Cannot upstream as-is (host-side infra)
- **cpnet_bridge slot device** (`src/devices/bus/rc702/pio_port/cpnet_bridge.{cpp,h}`)
  — opens a host TCP socket to the CP/NET bridge; MAME upstream won't take a
  host-socket device like this. **This is our biggest ongoing local dependency**
  (required for `cpnos-polypascal-test`). Keep fork-only.

## Path divergence to reconcile on the post-merge rebase

The PR puts the pio_port slot bus at **`src/mame/regnecentralen/pio_port/`**
(keyboard + pio_port). The fork master moved the whole thing to
**`src/devices/bus/rc702/pio_port/`** and added `cpnet_bridge` there.

On rebasing fork `master` onto post-merge `upstream/master`:
1. Adopt upstream's `src/mame/regnecentralen/pio_port/` location for keyboard +
   pio_port (drop the fork's `src/devices/bus/rc702/` copies of those two).
2. Relocate **cpnet_bridge** into the upstreamed `pio_port` slot enumeration
   (either move the two files under `src/mame/regnecentralen/pio_port/` and add to
   `mame.lst`/the slot option table, or keep a thin `src/devices/bus/rc702/` and
   reference upstream's pio_port). Verify the slot option name (`cpnet_bridge`) the
   rc700 build scripts pass still resolves.
3. Re-apply the local ROM-hash/warning patch (section A) last, as a clearly-labelled
   fork-only commit.
4. Rebuild `SUBTARGET=regnecentralen` (or `SOURCES=rc702.cpp`) and re-run
   `cpnos-polypascal-test` (PIO) + `rcbios` MAME boot to confirm nothing regressed.

## Immediate next actions (do NOT need the merge)
- Nothing blocking. Optionally prep the section-B generic-fix PR branch now off
  `upstream/master` so it's ready to file once #15805 is merged (avoids review
  contention on the same driver). Requires per-filing go-ahead before posting
  (feedback_explain_before_filing).
