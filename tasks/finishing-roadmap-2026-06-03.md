# Finishing roadmap — rcbios + autoload-in-c + CP/NET + cpnos (2026-06-03)

Round-2 synthesis of the four per-component finishing-checklists
(written 2026-06-03 under `project_finishing_firmware_components`).

## The four checklists

| Component | File | TL;DR |
|---|---|---|
| autoload-in-c | `rc700-gensmedet/autoload-in-c/tasks/finishing-checklist.md` | **Closest to finished.** 1658/2048 B (390 free). 5 small polish items, ~2 h. |
| cpnos | `rc700-gensmedet/cpnos-in-c/tasks/finishing-checklist.md` | **Highest risk:** 2027/2048 = **21 B free**. Need CI cap-gate + ≥ 50 B headroom recovery. |
| CP/NET | `rc700-gensmedet/cpnet/finishing-checklist.md` | Production-ready; doc drift + 3 cpnos-shared/docs/ files still naming parked cpnos-rom. |
| rcbios | `rc700-gensmedet/rcbios-in-c/tasks/finishing-checklist.md` | Biggest surface (24 `tasks/*.md`); zero bugs, but task-tracking rot. Largest "feels-unfinished" delta. |

## Highest-leverage item per component

| # | Component | Item | Effort | Why |
|---|---|---|---|---|
| 1 | cpnos | **Size-cap CI gate** on `make prom1-lineprog` + retarget default `make` away from parked two-PROM. | ~30 min | Today the 21 B free margin is silent — a compiler change that adds 22 B fails at boot, not at CI. This is the single most leveraged guard across all four. |
| 2 | CP/NET | **Update `cpnos-shared/docs/{CPNET_WIRE_PROTOCOL,PORT_OUTPUTS,MEMORY_MAP}.md`** to reference cpnos-in-c instead of parked cpnos-rom. | ~30 min | The wire spec is load-bearing and currently points at code that isn't shipping. Mechanical fix, high reader-clarity value. |
| 3 | rcbios | **Triage `tasks/*.md`** — archive DONE/CLOSED, mark PARKED, add `tasks/README.md` index. | ~1–2 h | Biggest "feels-unfinished" delta; mechanical; surfaces what's actually left. |
| 4 | autoload-in-c | **Add `make floppy-boot-test`** using in-tree `test-disks/SW1711-I8.imd` + fixed `mame_boot_test.lua`, asserting `A>`. | ~15–30 min | Closes the one real oracle gap; converts today's manual screenshot proof into a repeatable CI hook. |
| 5 | cpnos | **Headroom recovery to ≥ 50 B free.** Pick: (a) ship #173 BSS spill peephole (compiler-side, 3–4 h, ~5–10 B); (b) `BOOT_MARK_ENABLED=0` (~67 B, loses dev diagnostic — requires user-direction). | 3–4 h or ~15 min depending on choice | Without this, item 1's gate keeps firing on every drift. (a) is the right long-term path; (b) is the get-it-finished-now option. |

## Suggested execution order

**Pass 1 — cheap, mechanical wins (≈ 2 h total):**

1. cpnos size-cap CI gate (item 1) — protects everything else from silent
   breakage.
2. autoload-in-c floppy-boot-test target (item 4) — same theme: convert
   manual verification into a repeatable assertion.
3. CP/NET cpnos-shared/docs/ update (item 2) — mechanical, high clarity.

After pass 1, every commit fails fast if cpnos blows the 2 KB cap or
autoload's floppy boot regresses, and the wire-spec points at shipping
code.

**Pass 2 — bigger items (≈ 4–8 h total, can split across sessions):**

4. rcbios task triage (item 3) — cleanest "finished" delta when this is done.
5. cpnos headroom recovery (item 5) — choose (a) or (b); user-direction
   needed for (b).  Without this, every future compiler change risks
   tripping the gate from pass 1.

**Pass 3 — polish (~ 4 h total):**

6. README + size-doc refreshes across all four components.
7. Production-verification doc per component, naming the `make` target
   + canonical screenshot.
8. Re-stamp `cpnet/TEST_RESULTS.md` with current pass-times.

After pass 3, all four checklists' "concrete close-out items" are
complete and the components meet the bar: no open bugs, doc accurate,
oracle automated, sustainable headroom.

## Items deliberately deferred

- **MAME upstream FDC filings** (bugs A + B) — per
  `tasks/memory/feedback_mame_upstream_routing` (HARD): never file in any
  MAME repo without explicit per-issue user permission.  Local fork
  carries the fix; this is maintenance debt that's bounded.
- **llvm-z80 backlog** (#214/#213/#212/#211/#207/#206/#203/#197) — none
  directly block any of the four components; some (#173) feed the cpnos
  headroom-recovery item.  Treat as compiler-track work.
- **Two-PROM cpnos revival** — user-parked 2026-05-17.
- **autoload-in-c QR feature, ID Comal compat** — parked features, not
  finishing items.
- **rcbios SDLC physical link, Danish-keyboard MAME work** — bench-side /
  deferred per their respective tasks/*.md files.

## Decision points needing user input

1. **cpnos headroom (item 5)** — landing #173 (clean, slow) vs flipping
   `BOOT_MARK_ENABLED=0` (immediate, loses dev diagnostic).  My
   recommendation: ship #173, accept the wait; keep `BOOT_MARK_ENABLED`
   ON.  But you may prefer the immediate fix.
2. **rcbios size posture (item from rcbios checklist)** — declare
   "current 5911 B is finished, further shrink is compiler-track work"
   vs. land specific size levers now.  My recommendation: declare
   finished; offload to compiler.
3. **rcbios history archive** — `tasks/history/` subdir vs `git rm` the
   resolved session summaries.  My recommendation: `tasks/history/`
   (cheap, preserves searchability).

## Status

- Round 1 (this doc + four checklists): **DONE 2026-06-03.**
- Round 2 Pass 1: not started.
- Round 2 Pass 2/3: blocked on decisions above (or just-pick-and-go).
