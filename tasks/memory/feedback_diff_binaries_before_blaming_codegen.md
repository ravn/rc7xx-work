---
name: Diff binaries before blaming codegen
description: HARD. When two compiler configurations seem to produce different runtime behavior, run `cmp -l` on the output binaries FIRST. If they are byte-identical, the codegen is the same — the failure is in the environment (stale daemons, leftover state, port leaks, flaky harness). Don't chase a phantom codegen bug.
type: feedback
---

**HARD: when comparing two compiler configurations that "behave
differently" at runtime, diff the output binaries before believing
the symptom is a codegen bug.**

If `cmp -l a.bin b.bin` reports 0 differences, the two binaries are
byte-identical.  The CPU will execute exactly the same instructions
in both cases.  A behaviour difference therefore CANNOT be a codegen
miscompile — it must be environmental:

  - A stale daemon (e.g. cpmsim orphan on :4002 — see
    ravn/rc700-gensmedet#96).
  - Leftover screen sessions, MAME instances, or kernel state.
  - Test-harness flake (timing window, retry exhaustion, etc.).
  - A different *input* feeding the binary (disk image, ROM file,
    etc.).
  - A wholly different binary being executed (stale install).

**Why:** Session 58 (ravn/llvm-z80#134) flagged a "polypascal-test
failure at PPAS launch" when declaring `z80_preserves_regs("d", "e",
"h", "l", "b", "c")` instead of `("d", "e", "b", "c")` on
`xport_send_byte` in cpnos-rom.  I spent a chunk of time bisecting
the register set looking for which combination broke codegen.  The
broader six-name set produced **byte-identical bytes** to the
narrower four-name set — clang's regalloc happened not to have
anything live in HL across the calls today, so the extra HL
preservation was inert.  A simple `cmp` upfront would have caught
this in seconds.  Instead I filed #134 as a "regalloc regression"
and shipped the conservative subset, only to retract both decisions
the next session.

**How to apply:**

1. **Before bisecting attribute sets, mask combinations, or
   regalloc-affecting knobs**: build two configurations, save both
   output binaries, `cmp -l a b | wc -l`.  Zero → it's environmental.
2. **Before filing a "miscompile" bug**: same check.  Codegen
   variance manifests as byte differences in the relevant section.
3. **When a test passes one run and fails the next with no source
   change**: ALWAYS suspect harness state first.  Re-run with a
   fresh environment (kill stale processes, clear /tmp dump files,
   verify port availability — see feedback_kill_stale_servers_on_
   test_target).
4. The Linux/macOS `cmp -l` outputs the byte offsets that differ;
   filtered through `wc -l` it gives a quick count.  If you see
   non-zero, dump the offset range with `xxd` slices to localize.

Sanity-check binaries cost seconds and protect against multi-hour
detours into phantom backend bugs.
