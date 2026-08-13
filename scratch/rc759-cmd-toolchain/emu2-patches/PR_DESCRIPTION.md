# PR: Run Digital Research C headless — FCB bit-7, auxiliary groups, BDOS 47 chaining

**Target:** `johnsonjh/emu2-cpm86` `master`
**Source:** `ravn/emu2-cpm86` branch `cpm86-drc-headless`
**Status:** prepared, NOT yet opened.

---

## Summary

Three small, self-contained fixes to the CP/M-86 host that together let the
Digital Research **DR C 1.11** compiler toolchain (DRC driver → DRC860/861
passes → LINK-86) run **fully headless** under emu2 — compile, link, and run a C
program with no interactive input. Each commit is independent and useful on its
own; none changes DOS/CP/M-80 behaviour (all are gated on `cpm86_active` or on
CP/M-86-specific structures).

## Commits

1. **cpm86: mask bit-7 FCB interface attributes in filenames** — CP/M-86 carries
   "interface attributes" in bit 7 of the 8 name + 3 type bytes of an FCB; they
   are not part of the filename. Tools that set them (DR C does) otherwise get
   truncated names such as `SRCFILE` → `SRCFI`. Masked only when `cpm86_active`.

2. **cpm86: load auxiliary groups (CMD types 5-8)** — relocatable CMD files keep
   a self-relocation buffer in an auxiliary group and abort at startup unless
   that group's base-page descriptor is populated. The loader now allocates and
   loads each auxiliary group image (CMD group types 5-8 → base-page descriptor
   slots 4-7) so such programs self-relocate. DR C's own passes are relocatable
   CMDs and need this.

3. **cpm86: implement BDOS 47 (P_CHAIN, Chain To Program)** — load and run the
   program named in the default DMA buffer, reusing the current PSP and freeing
   the outgoing program's segments first. Multi-pass tools chain their stages
   this way; without it only the first program runs. Also transparently strips a
   leading `R` run-loader token so passes invoked via DR's `R` utility load
   directly (avoiding unimplemented BDOS 59).

## Verification

Built the emu2 tree clean (`make`, `-Wall -Werror`). End-to-end under the patched
emu2, entirely headless:

```
DRC.CMD "srcfile -b"            # DR C compile  → srcfile.obj (real DR C OMF)
LINK86.CMD "SAMPLE,CLEARL.L86[S]"   # DR C link  → SAMPLE.CMD
SAMPLE.CMD                     # runs, prints 0..3 TESTING C + FINISHED!
```

(DR C defaults to the **large** memory model, so link with `CLEARL.L86`, not
`CLEARS.L86`.)

## Notes / limitations

- Auxiliary-group segments are not reclaimed on chain (the relocation buffers are
  tiny); acceptable for a one-shot compile host.
- BDOS 59 (P_LOAD) itself remains unimplemented; the `R`-token short-circuit in
  BDOS 47 covers the DR C use of it.
