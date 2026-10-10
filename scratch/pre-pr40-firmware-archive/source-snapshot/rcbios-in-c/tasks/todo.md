# BIOS-in-C Phase Tracker

## Session 23 (2026-04-19/20) — SIO flow control bug + integration test

**Completed:** See `tasks/session23-sio-flow-control.md` for the full story.

- RTS flow-control bug: per-byte WR5/WR1 rewrites in `list_lpt`,
  `bios_punch_body`, `serial_conout` were clobbering the RX ISR's
  RTS-deassert.  Fixed.
- `readi()` now arms both SIO channels and runs before cold-boot banner.
- SIO-B got symmetric RTS flow control (ISR + reassert in serial_conin).
- MAME rc702.cpp: `rs232b_defaults` `FLOW_CONTROL` 0x00 → 0x01.
- New integration test: `make sio-echo-test` — 4096-byte bidirectional
  error-free echo on both SIOs via direct BIOS calls.  Currently passes.
- BIOS size: 6013 → 6002 B.

**Follow-ups:**
- [ ] Use `RXTHLO=240` for RX ring hysteresis (currently unused —
      reassert happens only at buffer-empty, which causes long pauses).
- [x] Retest session-22 CP/NET bring-up: RC702 → z80pack MP/M now
      works end-to-end (LOGIN PASSWORD → NETWORK H:=B: → DIR H:).
      Root cause turned out to be clang BIOS codegen clobbering D/E
      while SNIOS's `MSGOUT` expected E to survive `B$PUNCH`; fix
      committed in SNIOS `SENDBY` (41bc0fa).
- [ ] Make the integration test exit on completion-marker detection
      instead of a 30 s wall-clock kill.
- [ ] **CP/NET + MP/M on physical hardware.**  End-to-end validate
      the same `CPNETLDR → LOGIN PASSWORD → NETWORK H:=B: → DIR H:`
      sequence on a real RC702 talking to an external MP/M server
      over RS-232 SIO-A.  Needs: working cable, physical MP/M server
      (or FT2232H + laptop-hosted z80pack), and tests/ harness.
- [x] **Deeper CP/NET verification against MP/M** — done via
      `cpnet/chksum_roundtrip_test.sh`: deterministic 2 KB fixture +
      PIPNET push-and-pull + three-way CHKSUM comparison against a
      pre-computed reference (0xFC00).  End-to-end byte-exact.

      Key finding: **use `PIPNET.COM`, not plain `PIP`, against MP/M.**
      Stock CP/M 2.2 PIP clobbers MP/M's FCB reserved bytes,
      triggering a Close Checksum Error (NDOS Err 06 per DRI CP/NET
      manual §3.2.1).  PIPNET from `cpnet-z80/dist/` is the
      CP/NET-aware replacement.  See ravn/rc700-gensmedet#15 (closed)
      for the write-up.

- [ ] **No CP/NET "remote login" feature exists** — worth noting
      for context.  CP/NET is one-way: requester uses server's
      devices.  `NETWORK CON:=n` maps the *requester's* CON: to the
      *server's* console hardware — the opposite of remote shell.
      If a MP/M-shell-from-RC702 experience is wanted, it would
      need a custom terminal emulator built on BDOS 66/67 (Send/
      Receive Message), or an RC702-side telnet client.  Not
      planned; record here so future readers don't re-investigate.

- [ ] **Round-trip test should use its own MAME-exit marker**
      instead of the 90 s wall-clock kill.  When CP/NET is
      healthy, the $$$.SUB sequence completes in ~15 s — the
      harness leaves MAME idling for 75 s afterward.  A simple
      "done sentinel" (e.g. writing a magic byte to a known
      memory address from the last SUB command, detected by
      the Lua tap) would tighten that up.

## Session 17 (Apr 2026) — SIO-B shadow console + baud rate investigation

**Completed:**
- SIO-B console mode with ENQ probe (`bios_hw_init.c`, `bios.c`, `bios.h`)
- `IOBYTE_DEFAULT_SIOB = 0x96` (CON:=BAT → kbd + SIO-B + CRT echo)
- Polled `siob_conout` fixes cold-boot deadlock (was calling interrupt-driven
  `list_lpt` before EI)
- Host daemon `siob_daemon.py` + deploy flow

**Key finding:** SIO-A async RX is hard-capped at 38400 by the Z80 SIO's x1
mode clock recovery. All x1 mitigations (flow control, stop bits, gaps,
timer vs counter CTC, FTDI adapter upgrade) tested and documented as
ineffective in `session17-siob-console.md`. TX works at 250000 x1.

**Follow-up tasks spawned:**
- [x] `parallel-port-transfer.md` — investigate PIO Ch.A for faster
      host I/O. **Resolved 2026-04-25**: superseded by Option P design
      on PIO-B / J3, see `../../docs/cpnet_fast_link.md`. The
      `parallel-port-transfer.md` task doc carries a SUPERSEDED banner.
- [ ] `siob-console-dipswitch.md` — replace ENQ probe with DIP switch
- [ ] `two-port-deploy-script.md` — formalize SIO-B console deploy flow

## Completed Phases
- **Phase 1a**: Skeleton (builds, correct binary layout)
- **Phase 1b**: CRT display refresh ISR and keyboard input
- **Phase 1d**: CONOUT display driver with escape sequences
- **Phase 1e**: Floppy disk driver (blocking/deblocking, multi-density T0, verified 4 images)
- **Phase 1f**: Boot sequence — CP/M boots to A> prompt on MAXI 8" disk

## Remaining Work

### SIO serial ring buffer (READI)
- [ ] Arm SIO Ch.A receiver for serial ring buffer in cold boot
- [ ] Enable RTS flow control

### MINI (5.25") support

**Status: not functional.** Two independent blockers:

1. **BIOS too big for MINI ROM slot.** Current BIOS is 6657 bytes, MINI
   limit is 6144 — over by 513 bytes. Needs code-size reduction or
   conditional feature exclusion before MINI builds are viable.
2. **`dpb_mini_512` primitives are wrong for MINI data tracks.**
   Discovered 2026-04-16 while introducing the DISKDEF macro. The current
   primitives `DISKDEF(26, 128, 1, 1024, 243, 64, 1, 0)` describe an
   FM-128B 26-spt single-sided format — matches an 8"-style track 0
   layout but NOT the real 5.25" MINI data tracks (which are
   `9 sectors × 512 B/S × 2 sides = 72 CP/M sectors/track`, likely
   BLS=2048). Reaching this DPB via `fd0[drive] = 0x10` and reading a
   data track would misbehave — either report wrong capacity, mis-
   translate sectors, or read garbage.

**Selection mechanism (for reference):** `fspa[(fd0[drive] >> 3) & 3]`
maps format codes to FSPA entries. `fd0 = 0x10` selects FSPA[2] which
holds `dpb_mini_512`. Default CONFI (boot_confi.c) has fd0 = {0x08,
0x08, 0x20, 0xFF, ...} — so dpb_mini_512 is **never reached with the
shipped CONFI**, only when MAME boots the `rc702mini` target with a
MINI-system disk whose embedded CONFI has 0x10 entries.

**Todo for when MINI is unblocked:**
- [ ] Shrink the BIOS by 513 bytes (see `tasks/bios-size-issues.md`)
- [ ] Replace `dpb_mini_512` primitives with real MINI data-track
      geometry. Rough sketch: `DISKDEF(9, 512, 2, 2048, ??, 64, 1, 0)`.
      DSM computation needs the actual MINI data-track count (34 tracks
      × 9 spt × 512 / 2048 = 76.5 blocks/track × 34 = hmm, depends on
      exact disk geometry — verify from the RC702 manual before
      committing numbers).
- [ ] Verify MAME `rc702mini` boot with a real MINI system disk once
      both blockers are resolved.
- [ ] Reconcile the existing comment "5.25" DD 512 B/S (MINI)" in
      bios.c with whatever the final primitives turn out to be.

### Integration testing — BUG: TYPE/STAT/ASM produce no output
- [x] DIR works correctly (lists files on maxi 8" disk)
- [x] Warm boot works (loads CCP+BDOS from track 1)
- [ ] **BUG**: TYPE, STAT, ASM produce no output — they read 2 directory sectors, get all-E5, then warm boot
- [ ] Test with MINI disk images

#### Debug findings (2026-03-09)
The MAME Lua trace script (`mame_fdc_trace.lua`) captures BIOS READ calls via
a BSS debug buffer (dbg_idx at 0xDFE1, dbg_buf at 0xDFE2, 252 bytes / 63 entries).

**What works:**
- Cold boot: loads CCP+BDOS from track 1 sectors 0-43 → C400-D9FF. OK.
- Warm boot: same 44-sector load. OK.
- DIR: lists files correctly (uses BDOS Search First/Next, functions 17/18).
- Screen output: clean, no garbage (earlier FE00 debug writes removed).

**What fails:**
- TYPE DUMP.ASM: reads trk=2 sec=0 (dma=DE35) and sec=1 (dma=DE35), then
  immediately warm boots. DIRBF is all 0xE5 (empty). No file data reads.
- STAT and ASM also produce no output and silently return to A> prompt.
- These commands use BDOS Open (15) + Read Sequential (20), unlike DIR which
  uses Search First/Next (17/18).

**Verified correct:**
- DMA port programming: instruction-by-instruction match with original BIOS.
  Ports FA(smsk), FB(mode), FC(clbp), F2(ch1 addr lo/hi), F3(ch1 wc lo/hi), FA(unmask).
  DI/EI wraps all 8 port writes.
- DMA target: `fdc_dma_addr` only ever set to `&hstbuf[0]` (line 296 in chktrk).
- Deblocking math: deblock_shift=3 → 2 right shifts (divide by 4, correct for 512B sectors).
  deblock_mask=3 → offset = (cpm_sector & 3) << 7 (0/128/256/384). Correct.
- Sector translation: xlt_maxi_512[0]=1 maps host sector 0 to FDC sector 1. Correct.
- wboot_c calls bios_seldsk_c(0) at start and again before jumping to CCP.

**Hypotheses to investigate:**
1. FDC returns wrong data for track 2 directory sectors (different from what DIR reads).
   Need to compare: run DIR first (capture its trace), then TYPE (capture its trace).
   The comparative Lua test is prepared but not yet executed.
2. The BDOS Open codepath reads directory differently than Search First/Next.
   Both should read the same physical sectors, but the processing differs.
3. hstbuf might contain stale/wrong data after the track 2 read — need to dump
   hstbuf contents in the Lua script after directory reads.
4. disk_error (disk error flag) might be set, causing hostbuf_valid=0, which forces re-reads
   that also fail — need to trace disk_error.

**Debug infrastructure in bios.c (temporary, remove when done):**
- `dbg_idx` (uint8_t) and `dbg_buf[252]` (static BSS) — trace ring buffer
- `dbg_trace_read()` — called at entry of rwoper(), logs cpm_track/cpm_sector/cpm_dma_addr
- Lua script resets dbg_idx=0 after each A> prompt to separate command traces

### Code quality
- [ ] Audit all BIOS wrappers returning uint16_t for DE→HL sdcccall(1) correctness
- [ ] Consider replacing assembly interrupt wrappers with __interrupt C functions
- [ ] Write compile-time validation for DPH and DPB layouts against
      the CP/M 2.2 spec at https://www.idealine.info/sharpmz/dpb.htm.
      Use `_Static_assert` (or `static_assert` in C23) on:
      - `sizeof(disk_parameter_header) == 16`
      - `sizeof(disk_parameter_block) == 15`
      - `offsetof(disk_parameter_header, xlt) == 0`
      - `offsetof(disk_parameter_header, dirbf) == 8`
      - `offsetof(disk_parameter_header, dpb) == 10`
      - Similar for DPB field offsets (spt at 0, bsh at 2, ...).
      Analog of verify_skew.py but checked at build time — would catch
      accidental struct reorderings or field additions that break the
      BDOS ABI. Most useful when new fields are added for future
      CP/M 3.x or MP/M compatibility.
- [ ] **Dynamic disk_parameter_header table size**. Currently `dph_table[2]` is hardcoded (2 drives max
      — see `disk_parameter_header dph_table[2]` and `if (drno >= 1)` guard in bios_hw_init.c). Should
      scale to all configured drives per `fd0[]` (up to 16 entries). Requires:
      - disk_parameter_header array sized from `CFG.infd` non-0xFF count (compile-time or BSS)
      - Init loop in bios_hw_init.c instead of hand-rolled dph0/dph1
      - Matching BSS size bump for chk0..chk15, all0..all15 (or merged arrays)
      - Check CP/M assumption that disk_parameter_header block is linear in memory

### Session 16 (2026-04-15/16) — type correctness and baud prep
- [x] fdc_dma_addr: word → byte* (−35B clang, partial-constant-fold fix)
- [x] cpm_dma_addr: word → byte* (0B clang, +4B sdcc, semantic cleanup)
- [x] BUFF → BDOS_DMAADDR with (byte *) type; CCP_BASE typed
- [x] FSPA/disk_parameter_header const-correct (void* → typed fields; 6 casts removed)
- [x] bios_seldsk_c returns disk_parameter_header* (not word)
- [x] Default SIO-A and SIO-B to 38400 ×1 (CTC count=16, WR4=0x04)
      prep for 76800/115200 on real hardware — only CTC count changes
- [x] siob-baud test harness: auto-extract BSS addresses from bios.elf
- [x] llvm-z80#71: SRL A → RRCA when followed by AND mask (−13B clang)

### Session 16 — open follow-ups
- [ ] **Test 76800 / 115200 on physical RC700 hardware**
      MAME ×1 receive at >38400 fails (null_modem TX sends bytes but
      Z80-DART doesn't receive them). Real HW should work per Z80-SIO
      datasheet (×1 up to ~880 kbaud). Needs the FTDI cable.
- [ ] Investigate MAME Z80-DART ×1 receive at >38400 baud.
      Null_modem confirmed to transmit at 76800 (22 bytes read from TCP
      stream), but ring buffer stays empty. Filed upstream? Need to
      check MAME mailing list / issue tracker before filing.
- [ ] PROM rom.c: review typed address #defines (BOOT_DIR_OFF, etc.)
      for same treatment as CCP_BASE/BDOS_DMAADDR — may remove more casts.
- [ ] ravn/z88dk#2: SDCC uses byte-wise LD a,(nn) for const pointer
      copies instead of LD rr,(nn) — ~2-4B per site. Consider adding
      SDCC peephole in z88dk's sdcc fork if small.

### Session 17 (2026-04-16) — readability and naming pass
- [x] Clang -std=c23 adopted; all compiler warnings eliminated (5 clang, 5 SDCC)
- [x] FDC register vocabulary moved to bios.h: FDC_MSR_*, FDC_ST0_* named constants
      replace 9 raw binary patterns in bios.c + bios_hw_init.c
- [x] Comprehensive FDC result-phase documentation at fdc_read_result() —
      per-command byte layout + ST0/ST1/ST2/ST3 bit definitions
- [x] Major variable rename pass — 25+ CP/M cryptic 5-char mnemonics replaced
      with descriptive names (cpm_disk/track/sector, hostbuf_*, last_seek_*,
      unalloc_*, fdc_track/sector, current_format*, need_pre_read, is_read)
- [x] ISR helper renames: fl_flg/clfit/watir/wfitr → fdc_irq_fired/arm/wait/
      wait_rearm. Also: rstab→fdc_result, fdc_result()→fdc_read_result()
- [x] Type rename: DPB→disk_parameter_block, DPH→disk_parameter_header;
      .dpb field kept short (CP/M idiom, avoids type/field collision)
- [x] Disk format table rename: tran0/8/16/24 → xlt_maxi_128/512/mini_512/
      xlt_identity; dpb0/8/16/24 → dpb_maxi_128/512/mini_512/maxi_256
- [x] sec_rw loop: goto→for loop with break; static BSS `repet` preserved
- [x] Skew table build-time verification (verify_skew.py) — analog of DRI
      XLT macro; hooked into Makefile as bios-target prerequisite
- [x] MAME boot verified after rename: clang build loads SW1711-I8, reaches
      A> prompt, 2685 sectors zero errors

### Session 17 — open follow-ups
- [x] FSPA initializer migrated to designated initializers (bios.c:106-149).
      Both clang and SDCC accept designated init for FSPA's struct-of-scalars
      layout. Size unchanged.
- [ ] Investigate what `disk_type = 0xFF` actually means in the original
      RC702 reference BIOS. Current field was named `is_hard_disk` but
      reverted to `disk_type` because:
      a) The field has no reader in our code — dead until HD support is
         implemented, so the semantic is unverified.
      b) `rc703-div-bios-typer/` (original authored RC703 BIOS) may
         document the meaning; check there before re-assuming "0xFF = HD".
      c) boot_confi.c uses format code 0x20 for HD drives in fd0[] — that
         is a DIFFERENT field from FSPA.disk_type. Relation unclear.
- [ ] Audit remaining short-name variables for clarity: `drno` (now
      `max_drive_num`) was a good case; are there others like `disk_error`,
      `hostbuf_valid`, `hostbuf_dirty`, `sio_b_tx_ready`, `sio_a_tx_ready`, `cerflg`, `delay_ticks` that
      should also be renamed?
- [ ] `rsflag` semantic verification — currently interpreted as
      "pre-read required". Trace through rwoper() to confirm the
      three-state-flag semantics (0/1/secmsk) matches the documented
      CP/M deblocking algorithm.
- [ ] Consider migrating DRI `OS2CCP.ASM` / `OS3BDOS.ASM` to the z88dk
      assembler at build time so `make all` produces CCP+BDOS.cim
      alongside the BIOS (currently only the BIOS is built; CCP+BDOS
      comes from an existing disk image).
- [ ] Build-time TCAP verification: once ZCPR3 integration happens,
      add a verify script for cpm/rc700_z3termcap.h analogous to
      verify_skew.py, checking CP/M TCAP field layout matches manual §7.2.

### Build CCP+BDOS from source and inject on track 1
- [x] Assemble `cpm/OS2CCP.ASM` (CCP) and `cpm/OS3BDOS.ASM` (BDOS)
      from DRI CP/M 2.2 sources. Reference: https://www.jbox.dk/rc702/cpm.shtm
      Assembler: zmac `-8 --dri` (MAC-compatible, 8080 mnemonics).
      Origin: CCP at 0xC400, BDOS at 0xCC00.

**Two zmac bugs found and fixed** (patch file: `zmac/zmac_dri_fixes.patch`):
  - `!` after `;` was treated as comment content; DRI MAC treats it
    as a statement separator that ends the comment.  Without this
    fix, `nosub: ;no submit file! call del$sub` (OS2CCP line 229)
    silently drops the `call del$sub`, causing ~14B drift through
    the rest of the file.
  - Continuation lines after `!` could start at column 0 with no
    whitespace before the mnemonic, making zmac parse the mnemonic
    as a label.  Fix: prepend a space to continuation lines in
    `--dri` mode.  Triggered by `cmp b!inx h` (OS3BDOS line 1688).

**OS3BDOS.ASM now includes `patch1 equ on`** — the well-known DRI
  CP/M 2.2 Patch #1 (optional blocking/deblocking BIOS).  Required
  to match RC702 system disks byte-for-byte.  See
  https://github.com/brouhaha/cpm22/blob/main/bdos.asm for the
  conditional-assembly reference.

**Result**: CCP+BDOS assembled from `cpm/*.ASM` matches SW1711-I8.imd's
  track-1 CCP+BDOS byte-for-byte EXCEPT for the 6-byte DRI serial
  stamp (3 bytes at CCP offset 0x328 / mem 0xC728 + 3 bytes at BDOS
  start / mem 0xCC00).

### Decoded DRI serial format (confirmed on 14 RC702/RC703 disks)

6-byte layout per CCP's `serialize:` check (OS2CCP.ASM line 273):
```
  byte 0:   manufacturer code, low byte
  byte 1:   version code (0x16 = CP/M 2.2)
  byte 2:   manufacturer code, high byte
  bytes 3-5: per-disk serial, 24-bit big-endian
```

Regnecentralen's DRI-assigned manufacturer code is `0x08D5 = 2261`.
(Not in the public retrotechnology.com registry — this is a new
data point for CP/M-serial research.)

The 6-byte stamp appears in TWO places (CCP `serial:` field at
0xC728 and BDOS start at 0xCC00) and MUST match between them.
CCP's `userfunc` calls `serialize` before running any `.COM`,
which byte-compares the two stamps and halts the machine via
`di! hlt` (badserial handler, OS2CCP line 477) if they differ.
Built-in commands (DIR, ERA, TYPE, SAVE, REN, USER) don't trigger
the check.

**Survey data** (bytes 3-5 per disk, big-endian decimal = printed serial):
```
  SW1711-I8                  00 00 00   →      0   (master, label "2773")
  SW1311-I8 Piccolo 703      00 0A 07   →   2567
  Compas 2.13DK (SW7803/2)   00 02 EA   →    746
  CPM rel 2.1 (MINI)         00 05 EA   →   1514
  CPM rel 2.2 (MINI)         00 00 00   →      0   (master)
  CPM med COMAL80            00 00 01   →      1
  SW1711-I5 r1.4             00 03 7C   →    892   label "0892" ✓
  SW1711-I5 r2.0             00 00 00   →      0   (master)
  SW1711-I5 r2.1             00 0B 9C   →   2972   label "2972" ✓
  SW1711-I5 r2.2             00 0E 14   →   3604   label "3604" ✓
  SW1711-I5 r2.3             00 10 9C   →   4252
  SW1711-I5 copy             00 0B D6   →   3030
  RC703 r1.2                 00 13 89   →   5001
```
(COMAL_v1.07_SYSTEM_RC702 had all-zero bytes including manufacturer
— anomalous, possibly not a standard CP/M install.)

**Masters** are the four disks with serial 0 (no per-copy stamp).
They're templates RC kept to press duplicates from.

**Timeline**: serials are monotonic across RC's entire product line
(shared pool — not per-SKU).  Sorted by serial: Compas r1.4 (746)
→ SW1711-I5 r1.4 (892) → CPM rel 2.1 MINI (1514) → SW1311-I8 r1.0
(2567) → SW1711-I5 r2.1 (2972) → SW1711-I5 copy (3030) → r2.2
(3604) → r2.3 (4252) → RC703 r1.2 (5001).  Within each product
line, newer releases have higher serials.

**The SW1711-I8.imd IMD-header label "2-261-2773" fits precisely
between SW1311-I8 (2567) and SW1711-I5 r2.1 (2972)** — the slot
where an SW1711-I8 release 2.1 stamped contemporaneously with the
other r2.1 disks would belong.  So "2773" isn't a random archivist
note: it's a real RC ledger number for that master, just never
written into the bytes (which stay zero because the disk was kept
as a duplication master, not a customer copy).

Implication for the "new path" deploy pipeline: if we wanted to
reproduce real RC customer disks byte-exactly, we'd stamp an
assigned serial into bytes 3-5 of both the CCP and BDOS serial
fields at build time.  For our reproduction purposes, leaving
the bytes zero (master convention) is correct and safe — the
CCP's serialize check passes (0 == 0).

**Build infrastructure** (`cpm/Makefile`, `cpm/stamp_serial.py`,
`cpm/verify_against_imd.py`):
- `make SERIAL=2-261-XXXX` builds stamped CCP + BDOS + concatenated
  CCP+BDOS.cim (5632 B, padded to proper section sizes)
- Also emits `stamped/serial.hex` — a tiny 3-record Intel HEX
  overlay with just the two 6-byte stamps (at 0xC728 and 0xCC00),
  intended for MLOAD composition with the base CCP+BDOS
- `make verify REF=<imd>` compares the built output against an
  IMD's deinterleaved track 1 (handles MAXI 8"/MINI 5.25"/RC703
  geometries automatically)
- Default `SERIAL=2-261-0000` (master convention) produces output
  byte-identical to SW1711-I8.imd (verified 5632/5632)
- `SERIAL=4252` verifies byte-identical to SW1711-I5 r2.3
- SERIAL format accepts "2-261-XXXX", bare "XXXX", "2261-XXXX",
  or raw hex "D5 16 08 00 XX XX"

### DRI Patch #1 varies across RC releases

Surveying the 5-byte `diskwr2:` region (offset 0x12D2 in the
CCP+BDOS logical image) across all 13 disks in the collection
reveals Patch #1 is NOT uniformly applied:

```
  patch1=ON  (our default):  SW1711-I8, rel 2.2 MINI,
                              SW1711-I5 r2.2, r2.3, RC703 r1.2
  patch1=OFF (unpatched):     SW1311-I8, rel 2.1 MINI, COMAL80,
                              SW1711-I5 r2.0, r2.1, I5 copy
  patch1=OFF but variant:     Compas 2.13DK, SW1711-I5 r1.4
                              (00 00 21 00 DE — byte 4 is DE not D6,
                              some other BDOS variation)
```

Implication: the `patch1 equ on` default in `cpm/OS3BDOS.ASM`
matches about half the disks.  For the other half, the BDOS
doesn't have the blocking/deblocking patch — which makes sense
if those disks target BIOSes that don't do deblocking.

- [ ] Consider adding `PATCH1=on|off` Makefile variable analogous
      to SERIAL, so reproduction against unpatched disks is
      possible.  Not urgent — our RC702 BIOS is a deblocking one,
      so patch1=on is the correct default for our work.

- [ ] Figure out the RC702 track-1 layout for CCP+BDOS (the bytes
- [ ] Figure out the RC702 track-1 layout for CCP+BDOS (the bytes
      that the warm-boot BIOS reads back into 0xC400-0xD9FF — 44
      sectors × 128 bytes = 5632 bytes per current BIOS).
- [ ] Compare our build's output against what's already on working
      RC702 system disks (e.g. SW1711-I8.imd). Expect byte-match
      except serial number field — identify where serial lives.
- [ ] Write a tool (or extend patch_bios.py in ../rcbios/) to inject
      CCP+BDOS.bin onto track 1 of a disk image for MAME boot test.
- [ ] Verify warm boot from an injected disk image reaches A> prompt
      without errors.

### Replace CCP with ZCPR3.x / Z-System  —  PARKED (2026-04-16)

Not on the agenda.  Retained as research notes — the DRI CP/M 2.2
CCP+BDOS reproduction work (above) is independent of anything ZCPR-
related and is the active track.  If BDOS/CCP replacement is ever
revisited, the staged plan below is the starting point.

**Terminology (verified 2026-04-16):**
- **ZCPR3** — CCP-only replacement. ~2KB, same slot as stock DRI CCP.
  Introduced 1984 by Richard Conn. Current/final version is 3.4.
- **ZRDOS** — BDOS replacement, Z80-optimized. ~3.5KB (14 pages).
  Same slot as stock BDOS. Commercial, from Echelon.
- **Z-System** (commercial) — ZCPR3 + ZRDOS bundle from Echelon.
  Total ~5.5KB, same total slot as CCP+BDOS.
- **NZ-COM** — automatic Z-System installer. Runs as `.COM` on CP/M 2.2,
  no BIOS changes required. Good for initial experimentation.

**RC702 track-1 budget:** 5632 bytes (44 × 128B sectors) for CCP+BDOS
loaded at 0xC400. Stock DRI fills it exactly (CCP 2048 + BDOS 3584).
ZCPR3+ZRDOS has the same footprint → should fit without BIOS changes.

**ZCPR3 system segments** (optional — disable for minimal install):
- ENV/Z3T — Environment Descriptor (256B): 128B environ (dynamic,
  zeroed at cold boot) + ~32B TCAP (static terminal table) + other
- RCP (Resident Command Package — built-in commands in RAM)
- FCP (Flow Command Package — IF/ELSE/XIF, 128B zero-init by BIOS)
- NDR (Named Directory Register)
- IOP (I/O Package — custom device redirection)
These live in memory ABOVE BDOS, not in the track-1 load. Full support
requires BIOS cold boot to zero-fill and relocate segment buffers.
A minimal ZCPR3 without segments behaves as a plain better-CCP and
needs no RC702 BIOS changes.

**TCAP in BIOS**: Since RC702 has a fixed display (8275 + our escape
sequences), the ZCPR3 TCAP can be compiled statically into the BIOS
image at a known RAM address, with the ENV pointer patched into the
CCP at build/install time. Skips the `*.Z3T` file-loading path entirely.
Cold boot still zeroes the 128B environ portion; the TCAP is static data.

User-supplied RC702 TCAP files (in `cpm/`):
- `cpm/rc700_z3termcap.h` — annotated C source, name field "RC700",
  all other bytes byte-identical to rc700.z3t. THIS is the canonical
  form; the .z3t binaries below are vendor reference.
- `cpm/rc700.z3t` — original binary, name "Rc700 patched3" + 2-byte
  vendor tag (80×24, CLS=0x0C, home=0x1E, `%r%+ %+ ` cursor positioning).
- `cpm/rc700gr.z3t` — original binary, graphics variant (name
  "Rc700 patched7", differs at offsets 0x25-0x29 for SO/SE highlight
  codes that enable the display's attribute mode).

Integration: `#include "cpm/rc700_z3termcap.h"` from a BIOS module
to get `static const unsigned char rc702_tcap[128]`. Point the ZCPR3
Environment Descriptor's TCAP slot at this symbol. No `.Z3T` loader
needed. Header contains a WARNING comment listing specific capability
bytes that should be verified against actual RC702 behavior before
trusting (the original was written long ago, not reviewed since).

**Staged plan:**
- [ ] **Stage 1 — NZ-COM quick-test**: boot stock RC702 CP/M, copy
      NZCOM.COM + NZCOM.LBR, run `NZCOM` from A>. No BIOS changes.
      Proves the hardware path and lets us try the command-line gains
      (aliases, history, named dirs) before committing.
- [ ] **Stage 2 — minimal ZCPR3 as CCP-only swap**: build ZCPR3 with
      segments disabled (fits 2048B CCP slot), inject via track-1 tool
      from prior task. Stock RC702 BIOS should load it unchanged.
- [ ] **Stage 3 — ZCPR3+ZRDOS full swap**: replace both CCP and BDOS
      on track 1. Still fits 5632B budget. Verify BIOS syscall handlers
      still work (ZRDOS is 2.2-ABI-compatible per docs).
- [ ] **Stage 4 — enable system segments**: extend our rcbios to
      zero-init FCP buffer during cold boot, reserve RAM for ENV/RCP/
      NDR/TCAP. This unlocks aliases, named dirs, terminal abstraction.
      Likely requires BSS layout changes and new CONFI fields.

**Sources:**
- NZ-COM manual: http://gaby.de/ftp/pub/cpm/nzcom.pdf
- ZCPR3 installation manual: https://oldcomputers.dyndns.org/public/pub/manuals/zcpr/zcpr3_installation_manual.pdf
- ZCPR 3.3 User's Guide (Jay Sage): http://gaby.de/ftp/pub/cpm/znode51/specials/manuals/zcpr3.pdf
- Z-System downloads (Gaby): http://www.gaby.de/edownf.htm

## Parked ideas (rough notes, no detail)

These lived as Claude memory entries but the detail files have been lost over
time — only the one-line summaries survive. Recorded here so the ideas don't
vanish entirely.

### z88dk `regnecentralen` library additions
TODO: SEM702 chargen, serial parameter helpers, cursor control helpers,
extended BIOS call wrappers. (Index description only; detail lost.)

### CP/NET client in PROM
CP/NET over the parallel port → diskless CP/NOS client in the autoload PROM.
Roadmap sketch only; detail lost.

## Deferred (do not resume until the user says so)

### Circular DMA scroll (zero-copy via ch2/ch3 split)
Postponed because MAME testing showed flickering. The current memcpy_z80
scroll (16× LDI Duff's device) stays in use. The zero-copy approach needs
validation on real RC700 hardware before being worth reviving — MAME's
timing model may not faithfully reproduce the 8275 DRQ interaction.
