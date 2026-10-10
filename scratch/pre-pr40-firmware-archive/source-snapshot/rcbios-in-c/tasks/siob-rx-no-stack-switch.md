# SIO-B RX ISR: drop the stack switch (2026-04-11)

## Why
Previous session showed "characters slowly crawling backwards filling up
the display" at ~10 Hz when SIO-B test-console traffic hit the new
`__naked` + `isr_enter_full/isr_exit_full` path.  User hypothesis:
ISRs are fighting over the interrupt stack in upper memory (ISTACK at
0xF600) + the shared `_sp_sav` global — corruption happens as a result.

Z80 hardware disables IFF1 on interrupt entry, so *nested* ISRs
shouldn't be possible.  But the new SIO-B RX was the only difference
between working (no corruption) and broken, so moving it off the
shared-state path is the cheapest way to eliminate the whole category
of suspicion.

## Change
- `bios.c`: `isr_sio_b_rx` goes from `__naked` + `isr_enter_full/exit_full`
  to `__critical __interrupt(10)` — same form as its siblings
  (`isr_sio_b_tx/ext/spec`).  Runs on the interrupted program's own
  stack, no SP switch, no `_sp_sav` access.  Stack footprint ~10 bytes
  (AF/BC/DE/HL, plus IY on SDCC) — within CP/M's 32-byte guarantee.
- `rxbuf_b` gained `volatile`.  Clang DCE'd the ring-buffer store in
  the first build because nothing in `bios.c` reads `rxbuf_b` (consumer
  lives in the test harness).  The old `__naked` inline-asm store was
  opaque to the optimizer, which is why SIO-A never tripped this.
- `clang/bios_shims.s`: `_isr_sio_b_rx_wrapper` removed.
- `bios_hw_init.c`: clang path references `isr_sio_b_rx` directly.
- `isr_sio_a_rx` stays `__naked` + ISTACK for now (RTS flow control +
  overrun logic is more involved; known working; revisit after SIO-B
  stabilizes).

## Verification so far
- Clang build: 5826 → 5875 B (+49 B).  SDCC not rebuilt.
- Disassembly at `_isr_sio_b_rx`: push AF/BC/DE/HL → `in a,($9)` →
  store to `rxbuf_b[rxhead_b]` → advance `rxhead_b` → pop → EI/RETI.
  No `_sp_sav` reference anywhere.  Confirmed correct.
- **Not yet tested on hardware.**  User manually installed the new
  BIOS; the forever-loop test (`siob_forever.asm` + `siob_forever_test.py`)
  was prepared but not run.

## How to resume
1. Confirm the RC700 is running the new BIOS — check banner timestamp
   or look at `_isr_sio_b_rx` address via DDT (should be
   `push af; push bc; push de; push hl; in a,($9); …` at whatever
   location `bios.elf` shows; current build has it at 0xE49D).
2. Run `python3 siob_forever_test.py` from this directory.  It:
   - uploads `siob_forever.bin` (97 B) to `FOREVER.COM` via DDT S
   - runs `FOREVER` (prints banner, then loops forever echoing every
     SIO-B byte as 2 hex digits + space on SIO-A)
   - sends N bytes one-at-a-time on `/dev/ttyUSB1` and checks the hex
     echo on `/dev/ttyUSB0`
3. Expected: banner + `01 02 03 …` echo, machine stays responsive.
   If machine corrupts again → the SIO-B RX ISR is not the culprit;
   look elsewhere (SIO-B init order, shared-register races with CRT
   ISR, etc.)
4. On a clean run, also rebuild the SDCC path to verify
   `__critical __interrupt(10)` + `volatile rxbuf_b[]` compiles there
   too, then merge `sio-b-test-console` into `main` via `--no-ff`.

## Open issues (orthogonal)
- `CPM56.COM` produced by `mk_cpm56.py` does not include the validator
  checksum, so on HEX transfer errors it silently runs `SYSGEN` over a
  corrupt image instead of halting.  User flagged this during the
  April 11 deploy.  Needs separate investigation.
- The deploy showed 88 CTS drops across 318 HEX lines — worth
  revisiting the HEX send pacing.
