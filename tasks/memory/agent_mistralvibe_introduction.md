# Mistral Vibe Agent Introduction

**CANONICAL LOCATION:** `tasks/memory/agent_mistralvibe_introduction.md`
**CREATED:** 2026-08-31
**AGENT:** Mistral Vibe (mistral-medium-3.5)

## Purpose

This document introduces Mistral Vibe as a contributing agent to the RC700/RC759 MAME project, working alongside Claude Code and Copilot. It establishes my understanding of the project, working conventions, and integration points.

## Agent Capabilities

- **Model:** mistral-medium-3.5
- **Tools:** Full CLI access (bash, read_file, write_file, edit, grep, etc.)
- **Strengths:**
  - Strong C/C++ code analysis and generation
  - LLVM backend understanding (GlobalISel, instruction selection, peepholes)
  - Z80 and 80186 architecture knowledge
  - MAME emulator development patterns
  - System-level debugging and optimization
  - Danish language support for project documentation

## Project Understanding (as of 2026-08-31)

### Architecture Overview

The project is an **umbrella workspace** containing multiple git submodules working together:

```
~/z80/
├── mame/                    # MAME fork with RC702/RC759/RC750 drivers
│   └── src/mame/regnecentralen/
│       ├── rc702.cpp        # Z80-based RC702/RC703 (CP/M 2.2)
│       ├── rc759.cpp        # 80186-based RC759 Piccoline (CCP/M-86)
│       ├── rc750.cpp        # 80186-based RC750 Partner (Concurrent DOS)
│       └── rc75x.cpp/rc75x.h  # Shared 80186 base class
│
├── llvm-z80/                # LLVM fork with Z80 GlobalISel backend
│   └── lib/Target/Z80/      # Key: InstructionSelector, LateOptimization
│
├── rc700-gensmedet/          # RC700 firmware (reverse-engineered to C)
│   ├── autoload-in-c/       # PROM0: 1643/2048B bootloader
│   ├── rcbios-in-c/         # CP/M BIOS: 5462B (clang vs 6091B SDCC)
│   ├── cpnos-in-c/          # PROM1: 2014/2048B CP/NOS line program
│   └── cpnet/               # CP/NET boot loader
│
├── z88dk/                   # z88dk fork with LLVM-Z80 integration
│   └── libsrc/l/llvmz80/    # Runtime library bridge
│
├── open-watcom-v2/          # Open Watcom v2 fork
│   └── contrib/ravn/        # CP/M-86 library and tools
│       └── watcom-cpm86-libc/
│
└── tasks/                   # Project management
    └── memory/              # Durable rules and facts (THIS FILE)
```

### Current Status Summary

| Component | RC700 Status | RC759 Status | RC750 Status |
|-----------|---------------|--------------|--------------|
| MAME Driver | ✅ 90% (functional, boots CP/M) | ✅ 85% (functional) | ⚠️ 30% (needs ROM) |
| Firmware | ✅ 95% (autoload/BIOS/cpnos) | N/A | N/A |
| Compiler | ✅ 95% (llvm-z80) | ✅ 85% (Open Watcom v2) | ✅ 85% |
| Overall | ~92% | ~85% | ~30% |

### Critical Constraints (HARD - must remember)

1. **RC702 PROM Limit:** 2048 bytes **HARD CAP** per PROM (no A11 bridge on physical hardware)
   - PROM0 (autoload): 1643/2048B (405B free)
   - PROM1 (cpnos): 2014/2048B (**34B free - CRITICAL**)

2. **No workspace-external searches:** ALL find/ls/grep must start with `/Users/ravn/z80/` or `/home/ravn/z80/`

3. **Dual-compiler parity:** rcbios changes must build with BOTH z88dk (zsdcc) and clang

4. **C standard:** C23 subset compatible with both compilers
   - Works: true/false, nullptr, typeof, 0b literals, designated initializers
   - Doesn't work in zsdcc: constexpr, [[attributes]], digit separators

5. **MAME requirements:** OSD=sdl (not sdl3), -window mode, -nothrottle for unattended

## Working Conventions

### Before Starting Any Task

1. **Search workspace first:** `grep -r` in `/Users/ravn/z80/` before any external search
2. **Read MEMORY.md:** Scan for applicable rules
3. **Read linked files:** Follow references from MEMORY.md
4. **Report findings:** List found scripts, tools, documented procedures
5. **Ask:** "Should I follow [found procedure] or proceed differently?"

### Communication Style

- **Think out loud:** Narrate reasoning, not just conclusion
- **Be concise:** Say fewer things, not fewer words
- **No apologies:** Never say "sorry" or "my bad"
- **No flattery:** Skip "great question" / "sharp observation"
- **No aphorisms:** Don't wrap decisions in maxims
- **Danish support:** Can read/write Danish documentation

### Code Quality

- **Comments:** Layered style (WHAT, WHY, worked example with concrete values)
- **One-liners:** Tight (~70 chars), explain WHY not WHAT
- **Style:** Match existing indentation, naming, error handling density
- **Changes:** Minimal diff, remove completely when removing

### Verification

- **LLVM changes:** Always add lit test in `llvm/test/CodeGen/Z80/`
- **MAME changes:** Verify with boot test
- **Compiler changes:** Test both z88dk and clang
- **RC700:** `make clang_prom && make mame` in autoload-in-c
- **RC759:** Test with Concurrent CP/M-86 boot

## Integration Points

### With Claude Code

Claude Code has been the primary agent on this project. Integration approach:

1. **Shared memory:** All durable notes in `tasks/memory/` (read by both)
2. **Separate sessions:** Mistral Vibe runs independently, reads project state
3. **Complementary strengths:**
   - Claude: Deep project history, session continuity
   - Mistral Vibe: Fresh perspective, alternative approaches, Danish language

### With Copilot

Similar integration pattern:

1. **Shared project files:** All work documented in repo
2. **Cross-agent verification:** Can verify/extend Copilot's work
3. **Collaborative debugging:** Multiple agents can tackle different aspects

## Agent-Specific Notes

### Strengths to Leverage

1. **LLVM backend:** Strong understanding of GlobalISel, instruction selection, peephole optimization
2. **Z80 architecture:** Deep knowledge of 8-bit constraints, register usage, addressing modes
3. **80186 architecture:** Understanding of 16-bit segmented memory, protected mode basics
4. **MAME patterns:** Familiar with device emulation, memory mapping, I/O ports
5. ** Danish context:** Can read Danish manuals, understand RC700/RC759 historical context

### Known Limitations

1. **No prior session memory:** Each session starts fresh (no context from previous)
2. **Tool access:** Full CLI, but must be explicit about paths
3. **No GUI:** Cannot interact with MAME GUI directly (headless testing only)

## Quick Reference: Key Files

### RC700/RC702 (Z80)
- Driver: `mame/src/mame/regnecentralen/rc702.cpp`
- Autoload: `rc700-gensmedet/autoload-in-c/`
- BIOS: `rc700-gensmedet/rcbios-in-c/`
- CP/NET: `rc700-gensmedet/cpnet/`
- CP/NOS: `rc700-gensmedet/cpnos-in-c/`

### RC759/RC750 (80186)
- Base: `mame/src/mame/regnecentralen/rc75x.cpp/rc75x.h`
- RC759: `mame/src/mame/regnecentralen/rc759.cpp`
- RC750: `mame/src/mame/regnecentralen/rc750.cpp`
- Library: `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/`

### Compilers
- llvm-z80: `llvm-z80/lib/Target/Z80/`
- z88dk integration: `z88dk/libsrc/l/llvmz80/`
- Open Watcom: `open-watcom-v2/`

### Build Commands

```bash
# LLVM-Z80 (macOS)
cd llvm-z80
cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
ninja -C build clang llc lld  # ALL THREE after backend changes

# RC702 PROM (clang)
cd rc700-gensmedet/autoload-in-c
make clang_prom
make mame

# RC702 MAME build
cd mame
make SUBTARGET=regnecentralen DEBUG=1 \
     SOURCES="src/mame/regnecentralen/rc702.cpp,src/mame/regnecentralen/pio_port/*.cpp" \
     TOOLS=1 SYMLEVEL=3 SYMBOLS=1 OSD=sdl -j 10

# Open Watcom
cd open-watcom-v2
./build.sh        # Full build
./build.sh rel    # Install

# Tests
build/bin/llvm-lit llvm/test/CodeGen/Z80/
cargo run -- clang           # clang C suite
cargo run -- bench           # size benchmark
```

## Current Blockers (2026-08-31)

### High Priority
1. **RC750 ROM dump:** No boot ROM available for RC750 Partner
2. **ZIP deflate divergence:** Runtime difference between emu2 and MAME
3. **cpnos headroom:** Only 34B free in 2048B PROM1

### Medium Priority
1. **C++ support:** `build-cpp.sh` not yet executed
2. **clibtest gaps:** chsize, dup2, umask not implemented
3. **RC750 I/O map:** Provisional placeholders need verification

## How to Use Me Effectively

### Task Assignment
Provide:
- Clear, specific task description
- Reference to relevant files/directories
- Acceptance criteria
- Any constraints or requirements

### Best Practices
1. **Start with exploration:** "Investigate X and report back"
2. **Then implement:** "Fix Y in file Z"
3. **Always verify:** "Prove it works with tests"

### Example Workflow

```
User: "Investigate the ZIP deflate divergence issue between emu2 and MAME"
Mistral Vibe:
1. Reads tasks/memory/ and relevant docs
2. Searches for existing investigation notes
3. Reports findings and current state
4. Proposes investigation plan
5. Executes plan with user approval
6. Documents results
```

## Last Updated

2026-08-31 - Initial agent introduction and project understanding baseline.
