# Mistral Vibe - Detailed Project Understanding

**CANONICAL LOCATION:** `tasks/memory/agent_mistralvibe_project_understanding.md`
**CREATED:** 2026-08-31
**AGENT:** Mistral Vibe (mistral-medium-3.5)

## Executive Summary

This document captures my **detailed technical understanding** of the RC700/RC759 MAME emulation project, including architecture, current state, known issues, and future work. It serves as both a knowledge base for my contributions and a reference for cross-agent collaboration.

---

## 🏗️ PROJECT ARCHITECTURE

### Umbrella Structure

The project uses a **monorepo pattern** with git submodules:

```
z80/ (this repo - ravn/rc7xx-work)
├── .gitmodules              # Submodule definitions
├── mame/                    # ravn/mame fork
│   └── src/mame/regnecentralen/  # RC702/RC759/RC750 drivers
│
├── llvm-z80/               # ravn/llvm-z80 fork (owner: zlfn)
│   └── llvm/lib/Target/Z80/  # Z80 backend
│
├── rc700-gensmedet/         # ravn/rc700-gensmedet
│   ├── autoload-in-c/       # ROA375 boot PROM in C
│   ├── rcbios-in-c/         # CP/M BIOS in C
│   ├── cpnos-in-c/          # CP/NOS slave PROM1-only
│   └── cpnet/               # CP/NET boot loader
│
├── z88dk/                   # ravn/z88dk fork
│   └── libsrc/l/llvmz80/    # LLVM-Z80 runtime integration
│
└── open-watcom-v2/          # Open Watcom v2 fork
    └── contrib/ravn/        # CP/M-86 support
        └── watcom-cpm86-libc/  # C library for CCP/M-86
```

### Build Dependencies

```
RC700 Firmware
    ├─ Build: llvm-z80 (clang) OR z88dk (SDCC)
    └─ Test: MAME (rc702 driver)

RC759 Firmware
    ├─ Build: Open Watcom v2
    └─ Test: MAME (rc759 driver) OR emu2

Compiler Toolchain
    ├─ llvm-z80: cmake + ninja (native)
    ├─ z88dk: Docker (z88dk:2.4 image)
    └─ Open Watcom: Docker or native
```

---

## 🎯 CURRENT STATUS MATRIX

### RC700/RC702/RC703 (Z80-based)

#### Hardware Emulation Status

| Component | Implementation | Status | Notes |
|-----------|---------------|--------|-------|
| **CPU** | z80_device | ✅ Complete | 4 MHz, full instruction set |
| **Memory** | Banked RAM/ROM | ✅ Complete | 64KB RAM, 2x2KB PROM |
| **CRTC** | i8275_device | ✅ Complete | 560x250, 80 cols |
| **FDC** | upd765a_device | ✅ Complete | uPD765, DMA via AM9517A |
| **DMA** | am9517a_device | ✅ Complete | Channels 0-3 configured |
| **CTC** | z80ctc_device | ✅ Complete | Baud rate generator |
| **SIO** | z80sio_device | ✅ Complete | 2 channels (J1/J2) |
| **PIO** | z80pio_device | ✅ Complete | Keyboard + slot |
| **7474** | ttl7474_device | ✅ Complete | Floppy timing |
| **Beeper** | beep_device | ✅ Complete | Sound output |
| **Keyboard** | generic_keyboard | ✅ Functional | PIO-A wired |
| **Floppy** | floppy_connector | ✅ Complete | 8" and 5.25" |
| **SEM702** | RAM chargen | ✅ Complete | Ports 0xD1-D3 |

#### Firmware Status

| Component | Size (clang) | Size (SDCC) | Status | Boot Test |
|-----------|-------------|-------------|--------|-----------|
| **autoload-in-c** | 1643/2048 B | - | ✅ **Production** | ✅ PASS |
| **rcbios-in-c** | 5462 B | 6091 B | ✅ Production | ✅ PASS |
| **cpnos-in-c** | 2014/2048 B | 2151 B | ✅ Production | ✅ PASS |
| **CP/NET** | - | - | ✅ Production | ✅ PASS (PIO) |

**Size Comparison:** clang beats SDCC by **~10% average** on production targets.

#### Machine Variants

| Variant | Status | Differences |
|---------|--------|-------------|
| **rc702** | ✅ Functional | 8" DSDD, 8 MHz FDC |
| **rc702mini** | ✅ Functional | 5.25" DD, 4 MHz FDC |
| **rc703** | ✅ Functional | 5.25" QD (80-track) |
| **rc702sem702** | ✅ Functional | SEM702 RAM chargen |

#### Known Issues

| Issue | Priority | Status | Impact |
|-------|----------|--------|--------|
| Keyboard MCU (8048+2758) | Medium | ❌ Not dumped | Uses generic_keyboard |
| RC703 Hard Drive | Medium | ❌ Not implemented | Ports 0x60-0x67 |
| RC703 Extra CTC | Medium | ❌ Not implemented | Ports 0x44-0x47 |

---

### RC759 Piccoline (80186-based)

#### Hardware Emulation Status

| Component | Implementation | Status | Notes |
|-----------|---------------|--------|-------|
| **CPU** | i186_device | ✅ Complete | 6 MHz, 2 DMA ch, 3 timers |
| **PIC** | i8259_device | ✅ Complete | Cascaded to CPU INT0 |
| **CRTC** | i82730_device | ✅ **SOLVED 2026-08-30** | Text + graphics |
| **PPI** | i8255_device | ✅ Complete | Ports 0x70-0x76 |
| **FDC** | wd2797_device | ✅ Complete | Ports 0x280-0x290 |
| **RTC** | mm58167_device | ✅ Complete | Ports 0x5a/0x5c |
| **Sound** | sn76489a_device | ✅ Complete | Port 0x56 |
| **NVM** | nvram_device | ✅ Complete | Ports 0x80-0xfe |
| **Keyboard** | HLE serial | ✅ Complete | Port 0x20, IR1 |
| **Centronics** | ctronics_device | ✅ Complete | Ports 0x250/0x260 |
| **Cassette** | cassette_device | ✅ Complete | PPI port A/C |
| **iSBX** | isbx_slot_device | ✅ Complete | Serial module |
| **Floppy** | floppy_connector | ✅ Complete | 5.25" drives |

#### Software Status

| Component | Status | Notes |
|-----------|--------|-------|
| **Boot ROM** | ✅ Available | From hampa.ch/pce |
| **CCP/M-86** | ✅ Boots | v3.1, ~290s emulated |
| **XIOS** | ✅ Functional | v2.3 |
| **BDOS** | ✅ Tested | 128-byte oracle PASS |
| ** Info-ZIP** | ⚠️ Partial | STORE-only PASS, deflate FAIL |

#### Graphics Status (SOLVED 2026-08-30)

| Mode | Status | Resolution | Colors |
|------|--------|------------|--------|
| Alphanumeric | ✅ Complete | 560x250 | 32-entry IRGB palette |
| High-res graphics | ✅ Complete | 560x256 | 1 bit/pixel |
| Medium-res graphics | ❌ Not implemented | 280x256 | 2 bits/pixel |

**Key Fix:** 82730 emulation now uses 32-entry IRGB palette + per-character palette-select bits.

#### Known Issues

| Issue | Priority | Status | Impact |
|-------|----------|--------|--------|
| ZIP deflate divergence | 🔴 **HIGH** | 🔍 Active investigation | emu2 vs MAME difference |
| 82730 palette | Medium | ✅ **SOLVED** | Was hard-coded black/white |
| Floppy I/O errors | Medium | 🔍 Debugged | `rc759-fdc-dma-nvram-findings-2026-08-12.md` |
| Ethernet (82586) | Low | ❌ Not emulated | Optional hardware |
| DPC module | Low | ❌ Not emulated | Optional hardware |

---

### RC750 Partner (80186-based)

#### Hardware Emulation Status

| Component | Implementation | Status | Notes |
|-----------|---------------|--------|-------|
| **CPU** | i186_device | ✅ Inherited | Same as RC759 |
| **PIC** | i8259_device | ✅ Inherited | Same as RC759 |
| **CRTC** | i82730_device | ✅ Inherited | Same as RC759 |
| **PPI** | i8255_device | ✅ Inherited | Same as RC759 |
| **FDC** | fd1797_device | ⚠️ Placeholder | **Needs verification** |
| **SCSI** | - | ❌ Not implemented | Optional |
| **Serial** | i8274_device | ❌ Not implemented | **Needs port map** |
| **Boot ROM** | - | ❌ **MISSING** | No dump available |

**Status:** MACHINE_NOT_WORKING - **blocked on ROM dump**

---

## 🔧 COMPILER STATUS

### llvm-z80 (Z80 Backend)

#### Architecture
- **Backend Type:** GlobalISel (not SelectionDAG)
- **Target:** z80-unknown-cpm
- **ABI:** sdcccall(0/1) calling conventions
- **Features:**
  - Full Z80 instruction set
  - GlobalISel instruction selection
  - Post-RA peephole optimization
  - Custom linker scripts for PROM builds

#### Key Files

| File | Purpose | Size | Last Modified |
|------|---------|------|---------------|
| `Z80InstructionSelector.cpp` | Instruction selection | Largest | Core selection logic |
| `Z80LateOptimization.cpp` | Post-RA peepholes | Most modified | Most frequent changes |
| `Z80ExpandPseudo.cpp` | Pseudo-instruction expansion | - | Post-RA |
| `Z80CallLowering.cpp` | Calling convention lowering | - | sdcccall(0/1) |
| `Z80LegalizerInfo.cpp` | Legalization rules | - | Type legalization |
| `Z80RegisterBankInfo.cpp` | Register bank selection | - | Bank assignment |

#### Test Status
- **Lit tests:** 164 PASS + 6 XFAIL ✅
- **CI status:** Green ✅
- **Test runner:** `cargo run` (O1/O2/Os, clang, bench)

#### Code Density Achievements

| Target | clang | SDCC | Improvement |
|--------|-------|------|-------------|
| BIOS | 5462 B | 6091 B | -10.3% |
| cpnos PROM1 | 2014 B | 2151 B | -6.4% |
| AES-256 corpus | - | - | -22% |

#### Remaining Waste (ISA-fundamental)
- **BSS load/store traffic:** 30-48% of large functions
- **Root cause:** 8-bit memory is A-only → BSS-via-A + A-shuttle moves irreducible
- **Status:** No known cost-effective fixes remaining

#### Upstream Status
- **Fork:** ravn/llvm-z80 (owner: zlfn)
- **Upstream target:** llvm/llvm-project
- **Queue:** `llvm-z80/tasks/upstream-filing-queue.md`
- **Strategy:** Collaborative maturation, then upstream submission

---

### Open Watcom v2 (80186 Compiler)

#### Build Status
- **Full build:** ✅ Complete (`./build.sh rel`)
- **Toolchain:** wcc, wlink, wlib, wpp, wasm
- **Platform:** cpm86 is first-class target
- **Library:** `contrib/ravn/watcom-cpm86-libc/`

#### CP/M-86 Library Status

| Component | Status | Notes |
|-----------|--------|-------|
| **string.h** | ✅ Complete | All functions |
| **ctype.h** | ✅ Complete | All functions |
| **stdlib.h** | ✅ Complete | atoi, itoa, strtol, qsort, rand, getenv, getopt |
| **malloc** | ✅ Complete | Full family |
| **stdio.h** | ✅ Complete | FILE* layer, 16/16 MAME tests |
| **float** | ✅ Complete | 32-bit IEEE-754 (binary32) |
| **printf("%f")** | ✅ Fixed | Requires `__LLVMZ80_IEEE_PRINTF` |

#### Test Coverage

| Test Suite | Status | Platform | Notes |
|-----------|--------|----------|-------|
| float01-04 | ✅ PASS | Linux + MAME | Watcom's own tests |
| streamio (iotest.c) | ✅ PASS | Linux + MAME | Disk FILE* + console |
| BDOS 128 | ✅ PASS | MAME | Memory oracle |
| diskio | ⚠️ Not run | - | 661 round-trip checks |
| fscanf | ⚠️ Not run | - | 672 checks |
| clibtest | ⚠️ Partial | - | chsize/dup2/umask gaps |
| stdcbench | ⚠️ Not run | - | Standard benchmarks |
| whetstone | ⚠️ Not run | - | Performance test |

#### Key Fixes

1. **BDOS 128 oracle (2026-08-25):**
   - emu2 MCB pool now honors CPM86_TPA_KB at runtime
   - `-m 190` reproduces MAME's exact memory limits
   - Fix: `emu2-cpm86` commit `fe9dfb9`

2. **Disk I/O bug (2026-08-18):**
   - Root cause: Pure-reader handle's OWN BD_READRAND unreliable
   - Fix: `contrib/ravn/watcom-cpm86-libc/port/diskio.c`
   - Commit: `3f815e6c53`

3. **Memory model (2026-08-25):**
   - MCB pool sized to CPM86_TPA_KB
   - New `-m <kb>` CLI option

---

### z88dk (SDCC-based Toolchain)

#### Status
- **Fork:** ravn/z88dk
- **Branch:** rc700-gensmedet-1 (carries K&R REGPARM patch)
- **Build:** From source (not prebuilt)
- **Docker:** z88dk:2.4 image for SDCC builds

#### Integration
- **LLVM-Z80 bridge:** `libsrc/l/llvmz80/`
- **ABI:** `CALLING_CONVENTION.md`
- **Compatibility:** C23 subset works in both clang and z88dk

#### Features
- **Target:** `+cpm -compiler=llvmz80`
- **Runtime:** sdcccall(0/1) bridging
- **Graphics:** Semi-graphic support with sprites and fonts
- **Disks:** MAME-compatible disk images

---

## 🧪 TEST INFRASTRUCTURE

### LLVM-Z80 Tests

```bash
# Lit tests
build/bin/llvm-lit llvm/test/CodeGen/Z80/

# Test runner (z80-utils/test-runner)
cargo run                  # default O1/O2/Os
cargo run -- clang          # clang C suite
cargo run -- clang -static-stack  # production config
cargo run -- bench           # clang vs SDCC size benchmark
```

### MAME Tests

```bash
# RC702 boot test
./regnecentralend rc702 -bios 0 -window -skip_gameinfo -flop1 disk.imd

# RC702mini
./regnecentralend rc702mini -bios 0 -window -skip_gameinfo -flop1 disk.imd

# RC703
./regnecentralend rc703 -bios 1 -window -skip_gameinfo -flop1 disk.imd

# RC759
./regnecentralend rc759 -window -flop1 disk.imd
```

### Production Verification

```bash
# PROM builds (autoload-in-c)
cd rc700-gensmedet/autoload-in-c
make rom_parts          # SDCC build
make clang              # Clang build
make clang_asm          # Show clang assembly
make mame               # SDCC PROM + boot test in MAME
make clang_prom         # Clang PROM + install to MAME/RC700
```

---

## ⚡ PERFORMANCE METRICS

### Code Density (Production Targets)

| Target | clang Size | SDCC Size | Delta | Status |
|--------|------------|-----------|-------|--------|
| autoload PROM | 1643/2048 B | - | - | ✅ 405B free |
| BIOS | 5462 B | 6091 B | -10.3% | ✅ Production |
| cpnos PROM1 | 2014/2048 B | 2151 B | -6.4% | ⚠️ 34B free |
| AES-256 | - | - | -22% | ✅ Size win |

### Boot Times

| Machine | Emulated Time | Status |
|---------|---------------|--------|
| RC702 | ~5s | ✅ CP/M prompt |
| RC759 | ~290s | ✅ CCP/M-86 menu |

### Test Coverage

| Category | Count | Status |
|----------|-------|--------|
| LLVM lit tests | 164 PASS + 6 XFAIL | ✅ Green |
| MAME boot tests | 4 variants | ✅ PASS |
| Watcom tests | 4/8 suites | ⚠️ Partial |
| BDOS oracle | 1 test | ✅ PASS |

---

## 🔍 KNOWN ISSUES & BLOCKERS

### 🔴 HIGH PRIORITY (Active Blockers)

#### 1. RC750 ROM Dump
- **Issue:** No boot ROM dump available
- **Sources checked:** hampa.ch/pce, rc700.dk, DDHF
- **Impact:** RC750 driver cannot be tested
- **Status:** ❌ **BLOCKED** - Needs physical hardware or archive find
- **Next:** Search for RC750 owners, contact museums/archives

#### 2. ZIP Deflate Divergence
- **Issue:** Runtime difference between emu2 and MAME
- **Symptom:** `s=350, actual=349` error in deflate
- **Status:** 🔍 Active investigation
- **Plan:** `infozip-cpm86-builds/PLAN_zip_deflate_mame_2026-08-25.md`
- **Control:** STORE-only mode PASS on both
- **Impact:** Full Info-ZIP support blocked

#### 3. cpnos Headroom
- **Issue:** Only 34B free in 2048B PROM1
- **Risk:** Compiler changes could break boot
- **Options:**
  - (a) Land #173 BSS spill peephole (~5-10B, 3-4h)
  - (b) `BOOT_MARK_ENABLED=0` (~67B, loses diagnostics)
- **Recommendation:** Option (a) - ship #173
- **Status:** ⚠️ Needs user direction

### ⚠️ MEDIUM PRIORITY (Important but Not Blocking)

#### 4. C++ Support
- **Issue:** `build-cpp.sh` not executed
- **Component:** Open Watcom C++ layer
- **Status:** ⚠️ Not verified
- **Next:** Run build-cpp.sh, test clibtest C++ group

#### 5. clibtest Gaps
- **Issue:** chsize, dup2, umask not implemented
- **File:** `contrib/ravn/watcom-cpm86-libc/port/`
- **Status:** ⚠️ Known gaps
- **Reference:** `KNOWN_ISSUES.md` #3

#### 6. RC750 I/O Port Map
- **Issue:** Provisional placeholders need verification
- **Source:** Partner Programmer's Guide v3 (Appendix B is OCR-blank)
- **Status:** ⚠️ Needs real hardware documentation
- **Current:** Placeholder addresses in `rc750_io()`

#### 7. Medium-res Graphics (RC759)
- **Issue:** 280x256, 2 bits/pixel not emulated
- **Component:** i82730_device
- **Status:** ❌ Not implemented
- **Priority:** Low (high-res graphics works)

### 🟢 LOW PRIORITY (Future Work)

#### 8. MAME Upstream Integration
- **Issue:** Local fork changes need upstream submission
- **Status:** ⚠️ Parked - needs explicit user direction
- **Queue:** `mame-upstream-fdc-findings-2026-06-02.md`

#### 9. Ethernet Support (82586)
- **Issue:** Not emulated
- **Status:** ❌ Not implemented
- **Priority:** Low (optional hardware)

#### 10. DPC Module
- **Issue:** Disk/Printer-Adaptor not emulated
- **Status:** ❌ Not implemented
- **Priority:** Low (optional hardware)

---

## 📈 FUTURE WORK ROADMAP

### Phase 1: Unblock Critical Path (1-2 weeks)

1. **RC750 ROM dump**
   - Search archives and museums
   - Contact RC700 community
   - Consider emulation without ROM (BIOS calls only)

2. **ZIP deflate debug**
   - Isolate zlib state divergence
   - Create minimal repro
   - Cross-check with STORE-only as control

3. **cpnos headroom**
   - Decide: #173 peephole vs BOOT_MARK_ENABLED=0
   - Implement chosen solution
   - Add CI gate for PROM1 size

### Phase 2: Complete Test Coverage (2-4 weeks)

1. **C++ support**
   - Run `build-cpp.sh`
   - Test clibtest C++ group
   - Document results

2. **Watcom test suites**
   - Run `build-diskio.sh` (661 checks)
   - Run `build-fscanf.sh` (672 checks)
   - Run `build-stdcbench.sh`
   - Run `build-whetstone.sh`

3. **clibtest gaps**
   - Implement chsize, dup2, umask
   - Verify all clibtest groups

### Phase 3: Polish & Documentation (4-8 weeks)

1. **MAME upstream**
   - Prepare PRs for RC702/RC759/RC750
   - Submit FDC fixes (ravn/mame#13 candidate)
   - Document all local changes

2. **llvm-z80 upstream**
   - Package changes for llvm/llvm-project
   - Write per-filing explanations
   - Get community review

3. **Documentation**
   - Update README files
   - Write user guides
   - Document build processes
   - Add screenshots of successful boots

### Phase 4: Advanced Features (Ongoing)

1. **Graphics improvements**
   - Medium-res graphics (280x256, 2bpp)
   - Palette emulation enhancements
   - Cursor and scroll improvements

2. **Network support**
   - 82586 Ethernet emulation
   - CP/NET over Ethernet

3. **Performance**
   - MAME optimization for RC700/RC759
   - JIT compilation for faster emulation

---

## 🛠️ TOOLS & INFRASTRUCTURE

### Build Tools

| Tool | Version | Location | Notes |
|------|---------|----------|-------|
| **cmake** | Latest | CLion bundle | `reference_build_binaries` |
| **ninja** | Latest | CLion bundle | `reference_build_binaries` |
| **clang** | Latest | llvm-z80/build-macos/bin | Native build |
| **lld** | Latest | llvm-z80/build-macos/bin | Required for LTO |
| **Docker** | Latest | System | SDCC, z88dk, emu2 |
| **Rust** | Stable | rustup | test-runner |
| **Python** | 3.x | System | Various scripts |

### Development Environment

| Host | Path | Notes |
|------|------|-------|
| **macbook** | `/Users/ravn/z80/` | Primary development |
| **sonnyboy** | `/home/ravn/z80/` | Linux build host |

### Test Environments

| Environment | Purpose | Status |
|-------------|---------|--------|
| **MAME (SDL2)** | Primary emulator | ✅ Functional |
| **emu2** | Alternate CP/M-86 emulator | ✅ Functional |
| **Docker** | Cross-platform builds | ✅ Functional |
| **GitHub Actions** | CI | ✅ Green |

---

## 📚 KEY DOCUMENTATION FILES

### Project Management
- `AGENTS.md` - Cross-project working agreements
- `PROJECT.md` - Project-specific rules
- `CLAUDE.md` - Claude Code guidance
- `BOOTSTRAP.md` - Fresh-clone procedure
- `tasks/todo.md` - Current work list (83KB!)
- `tasks/memory/MEMORY.md` - Durable rules index

### Technical Documentation
- `rc700-gensmedet/RC702_HARDWARE_TECHNICAL_REFERENCE.md` - Hardware reference
- `rc700-gensmedet/ROA327_CHARACTER_ROM.md` - Character ROM analysis
- `rc700-gensmedet/cpnet.md` - CP/NET documentation
- `llvm-z80/CLAUDE.md` - LLVM-Z80 specific guidance

### Status & Planning
- `tasks/finishing-roadmap-2026-06-03.md` - Firmware finishing plan
- `tasks/plan-cpm86-big-model-2026-08-18.md` - CP/M-86 big model plan
- `tasks/plan-gsx-86-rc759-graphics-2026-08-29.md` - Graphics plan (SOLVED)

### Memory & Lessons
- `tasks/memory/project_*.md` - Project facts
- `tasks/memory/feedback_*.md` - Agent feedback rules
- `tasks/memory/reference_*.md` - Technical references
- `tasks/lessons.md` - Lessons learned

---

## 🎯 QUICK REFERENCE: IMPORTANT PATHS

### Source Files
```
# MAME drivers
mame/src/mame/regnecentralen/rc702.cpp
mame/src/mame/regnecentralen/rc759.cpp
mame/src/mame/regnecentralen/rc750.cpp
mame/src/mame/regnecentralen/rc75x.cpp/rc75x.h

# LLVM-Z80 backend
llvm-z80/lib/Target/Z80/Z80InstructionSelector.cpp
llvm-z80/lib/Target/Z80/Z80LateOptimization.cpp
llvm-z80/lib/Target/Z80/Z80ExpandPseudo.cpp

# Firmware
rc700-gensmedet/autoload-in-c/main.c
rc700-gensmedet/rcbios-in-c/bios.c
rc700-gensmedet/cpnos-in-c/main.c

# CP/M-86 library
open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/diskio.c
open-watcom-v2/contrib/ravn/watcom-cpm86-libc/cpm86/
```

### Build Artifacts
```
# LLVM-Z80
llvm-z80/build-macos/bin/clang
llvm-z80/build-macos/bin/llc
llvm-z80/build-macos/bin/lld

# MAME
mame/regnecentralend

# Open Watcom
open-watcom-v2/rel/binl/wcc
open-watcom-v2/rel/binl/wlink
```

### Test Files
```
# LLVM lit tests
llvm-z80/llvm/test/CodeGen/Z80/*.ll

# Test runner
z80-utils/test-runner/testcases/clang/*.c

# MAME scripts
mame/scripts/mame_capture.sh
```

---

## ✅ VERIFICATION CHECKLIST

Before considering any task complete, verify:

- [ ] **LLVM changes:** Lit test added and PASS
- [ ] **MAME changes:** Boot test PASS
- [ ] **Compiler changes:** Both z88dk and clang build
- [ ] **Size changes:** PROM size within limits (2048B)
- [ ] **Test runner:** Relevant tests PASS
- [ ] **Documentation:** Updated (README, comments, etc.)
- [ ] **Cross-agent:** Notes added to `tasks/memory/`

---

## 🔄 MAINTENANCE NOTES

### Last Full Project Scan
- **Date:** 2026-08-31
- **Scope:** Complete workspace analysis
- **Status:** All submodules present and functional

### Agent Integration
- **Claude Code:** Primary agent, deep history
- **Copilot:** Secondary agent, occasional contributions
- **Mistral Vibe:** New agent, fresh perspective

### Synchronization
- **Method:** Shared `tasks/memory/` directory
- **Format:** Markdown files with canonical location headers
- **Index:** `MEMORY.md` maintains complete index

---

## 📝 CHANGE LOG

| Date | Change | Author |
|------|--------|--------|
| 2026-08-31 | Initial agent introduction and project understanding | Mistral Vibe |

---

**CANONICAL LOCATION:** `tasks/memory/agent_mistralvibe_project_understanding.md`
**DO NOT EDIT:** This file is maintained by Mistral Vibe. Updates welcome via PR or direct edit with notification.
