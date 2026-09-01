# Mistral Vibe - Quick Start Guide

**CANONICAL LOCATION:** `tasks/memory/agent_mistralvibe_quick_start.md`
**CREATED:** 2026-08-31
**AGENT:** Mistral Vibe (mistral-medium-3.5)

## 🚀 IMMEDIATE STARTUP CHECKLIST

When beginning a new session, **always do this first:**

### 1. Read Essential Files
```bash
# Project rules (5 min)
read_file /Users/ravn/z80/AGENTS.md
read_file /Users/ravn/z80/PROJECT.md
read_file /Users/ravn/z80/CLAUDE.md

# Memory index (3 min)
read_file /Users/ravn/z80/tasks/memory/MEMORY.md

# Current status (5 min)
read_file /Users/ravn/z80/tasks/todo.md
```

### 2. Check Environment
```bash
# Verify workspace
pwd  # Should be /Users/ravn/z80 or /home/ravn/z80

# Check git status
cd /Users/ravn/z80 && git status && git submodule status

# Verify no external processes
ps aux | grep -E "mame|emu2|pce" | grep -v grep
```

### 3. Verify Tools
```bash
# LLVM-Z80 compiler
ls -la /Users/ravn/z80/llvm-z80/build-macos/bin/clang

# MAME emulator
ls -la /Users/ravn/z80/mame/regnecentralend

# Docker
which docker && docker ps
```

---

## 📋 COMMON TASKS QUICK REFERENCE

### Build Tasks

#### Build LLVM-Z80 (after backend changes)
```bash
cd /Users/ravn/z80/llvm-z80
cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build-macos
ninja -C build-macos clang llc lld  # ALL THREE - HARD rule
```

#### Build MAME (RC702 only)
```bash
cd /Users/ravn/z80/mame
make SUBTARGET=regnecentralen \
     DEBUG=1 \
     SOURCES="src/mame/regnecentralen/rc702.cpp,src/mame/regnecentralen/pio_port/*.cpp" \
     TOOLS=1 SYMLEVEL=3 SYMBOLS=1 OSD=sdl -j 10
```

#### Build RC700 Firmware (clang)
```bash
cd /Users/ravn/z80/rc700-gensmedet/autoload-in-c
make clang_prom          # Build PROM with clang
make clang_asm           # Show assembly
make mame                # Test in MAME
```

#### Build Open Watcom
```bash
cd /Users/ravn/z80/open-watcom-v2
./build.sh             # Full toolchain build
./build.sh rel         # Install to rel/
```

---

### Test Tasks

#### Run LLVM lit tests
```bash
cd /Users/ravn/z80/llvm-z80
build-macos/bin/llvm-lit llvm/test/CodeGen/Z80/
```

#### Run test-runner
```bash
cd /Users/ravn/z80/z80-utils/test-runner
cargo run                  # default O1/O2/Os
cargo run -- clang          # clang C suite
cargo run -- clang -static-stack  # production config
cargo run -- bench           # clang vs SDCC benchmark
```

#### Test MAME boot
```bash
# RC702
cd /Users/ravn/z80/mame
./regnecentralend rc702 -bios 0 -window -skip_gameinfo -nothrottle -sound none -seconds_to_run 60

# RC759
./regnecentralend rc759 -window -nothrottle -sound none -seconds_to_run 400
```

---

## 🔍 DEBUGGING QUICK REFERENCE

### Common Debug Patterns

#### 1. PROM Size Check
```bash
# Check autoload PROM size
cd /Users/ravn/z80/rc700-gensmedet/autoload-in-c
ls -la clang/*.rom
wc -c clang/roa375.clang.ic66  # Should be <= 2048

# Check cpnos PROM1 size
ls -la cpnos-in-c/*.rom
wc -c cpnos-in-c/prom1.clang  # Should be <= 2048
```

#### 2. MAME Debug Output
```bash
# Verbose boot
./regnecentralend rc702 -bios 0 -window -verbose -debug

# Log to file
./regnecentralend rc702 -bios 0 -window -log 2>&1 | tee mame.log
```

#### 3. Disassembly Inspection
```bash
# View generated Z80 assembly
cd /Users/ravn/z80/rc700-gensmedet/autoload-in-c
make clang_asm
less clang/roa375.clang.asm

# Search for specific patterns
grep -n "LDIR\|DJNZ\|CP.*HL" clang/roa375.clang.asm
```

#### 4. Memory Layout Check
```bash
# Check linker script
cd /Users/ravn/z80/rc700-gensmedet/autoload-in-c
cat link.ld

# Check symbol sizes
llvm-z80/build-macos/bin/llvm-nm -n --size-sort clang/*.o | head -20
```

---

## 📊 STATUS CHECK COMMANDS

### RC700/RC702 Status
```bash
# Check PROM sizes
echo "=== Autoload PROM ==="
ls -la /Users/ravn/z80/rc700-gensmedet/autoload-in-c/clang/*.rom

echo "=== BIOS ==="
ls -la /Users/ravn/z80/rc700-gensmedet/rcbios-in-c/clang/*.com

echo "=== cpnos ==="
ls -la /Users/ravn/z80/rc700-gensmedet/cpnos-in-c/*.rom
```

### RC759 Status
```bash
# Check Open Watcom build
ls -la /Users/ravn/z80/open-watcom-v2/rel/binl/

# Check test results
grep -E "PASS|FAIL" /Users/ravn/z80/cpm86-compiler-comparison/RESULTS.md | head -20
```

### LLVM-Z80 Status
```bash
# Lit test summary
cd /Users/ravn/z80/llvm-z80
build-macos/bin/llvm-lit --summary llvm/test/CodeGen/Z80/ 2>&1 | grep -E "PASS|FAIL|XFAIL"

# Backend file sizes
ls -la llvm/lib/Target/Z80/*.cpp | awk '{print $5, $9}'
```

---

## 🎯 PRIORITY TASK REFERENCE

### High Priority (Do First)

#### 1. RC750 ROM Dump
- **Goal:** Find RC750 Partner boot ROM
- **Status:** ❌ BLOCKED - No dump available
- **Files:** `mame/src/mame/regnecentralen/rc750.cpp`
- **Next:** Search archives, contact RC700 community

#### 2. ZIP Deflate Divergence
- **Goal:** Resolve emu2 vs MAME runtime difference
- **Status:** 🔍 Active investigation
- **Files:** `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/`
- **Plan:** `cpm86-compiler-comparison/PLAN_zip_deflate_mame_2026-08-25.md`
- **Control:** STORE-only mode PASS on both

#### 3. cpnos Headroom
- **Goal:** Increase free space from 34B to >=50B in PROM1
- **Status:** ⚠️ Needs user direction
- **Options:**
  - (a) Land #173 BSS spill peephole (3-4h, ~5-10B)
  - (b) `BOOT_MARK_ENABLED=0` (15 min, ~67B, loses diagnostics)
- **Recommendation:** Option (a)

### Medium Priority

#### 4. C++ Support
- **Goal:** Verify Open Watcom C++ layer
- **Status:** ⚠️ Not executed
- **Command:** `cd open-watcom-v2 && ./contrib/ravn/watcom-cpm86-libc/build-cpp.sh`

#### 5. Test Suite Completion
- **Goal:** Run remaining Watcom test suites
- **Commands:**
  ```bash
  cd open-watcom-v2/contrib/ravn/watcom-cpm86-libc
  ./build-diskio.sh      # 661 checks
  ./build-fscanf.sh      # 672 checks
  ./build-stdcbench.sh  # Standard benchmarks
  ./build-whetstone.sh   # Performance test
  ```

#### 6. clibtest Gaps
- **Goal:** Implement missing functions
- **Files:** `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/`
- **Missing:** chsize, dup2, umask
- **Reference:** `KNOWN_ISSUES.md` #3

---

## 🛠️ TOOL SPECIFIC NOTES

### Git Workflow
```bash
# Always check status first
git status
git submodule status

# For non-trivial changes, create branch
git checkout -b feature/my-feature

# Commit with proper message
git commit -a -m "Description of change

Generated by Mistral Vibe.
Co-Authored-By: Mistral Vibe <vibe@mistral.ai>"

# Merge with --no-ff
git merge --no-ff origin/main
```

### Search Patterns
```bash
# ALWAYS use absolute paths starting with /Users/ravn/z80/

# Find files
find /Users/ravn/z80 -name "*.cpp" -path "*/mame/*" | grep rc702

# Grep for patterns
grep -r "BOOT_MARK_ENABLED" /Users/ravn/z80/rc700-gensmedet/

# Find recent changes
find /Users/ravn/z80 -name "*.md" -mtime -7
```

### File Operations
```bash
# Read file
read_file /Users/ravn/z80/path/to/file.cpp

# Edit file (ALWAYS read first!)
edit file_path:"/Users/ravn/z80/path/to/file.cpp" \
  old_string:"old content" \
  new_string:"new content"

# Write new file
write_file file_path:"/Users/ravn/z80/path/to/newfile.cpp" \
  content:"file content"
```

---

## 💡 COMMON PITFALLS TO AVOID

### ❌ NEVER Do These

1. **Search outside workspace**
   ```bash
   # BAD
   find ~ -name "*.cpp"
   grep -r pattern /
   
   # GOOD
   find /Users/ravn/z80 -name "*.cpp"
   grep -r pattern /Users/ravn/z80
   ```

2. **Kill running emulators**
   ```bash
   # BAD
   pkill -9 regnecentralend
   pkill -9 emu2
   
   # GOOD - Wait for natural exit or Ctrl-C once
   ```

3. **Unquoted `===` in shell**
   ```bash
   # BAD
   echo === Separator ===
   
   # GOOD
   echo --- Separator ---
   ```

4. **Commit without lit test**
   ```bash
   # For LLVM changes, ALWAYS add lit test first
   ```

### ⚠️ Be Careful With These

1. **PROM size changes** - Verify within 2048B
2. **Dual-compiler parity** - Test both z88dk and clang
3. **MAME changes** - Verify boot still works
4. **Upstream filing** - Need explicit user direction

---

## 📚 QUICK REFERENCE: KEY CONSTRAINTS

### RC700/RC702
- **PROM0 (autoload):** 2048 bytes MAX (HARD CAP)
- **PROM1 (cpnos):** 2048 bytes MAX (HARD CAP)
- **Current usage:** 1643B + 2014B = 3657B
- **Current free:** 405B + 34B = 439B total

### C Standard
- **Compatible subset:** C23 features that work in both clang and z88dk
- **Works:** true/false, nullptr, typeof, 0b, designated init
- **Doesn't work in z88dk:** constexpr, [[attributes]], digit separators

### MAME
- **OSD:** sdl (NOT sdl3)
- **Mode:** -window (NEVER fullscreen)
- **Flags:** -nothrottle for unattended, -sound none
- **Timeout:** ALWAYS use -seconds_to_run N

### Build
- **LLVM-Z80:** ninja clang llc lld (ALL THREE after backend changes)
- **z88dk:** Docker (z88dk:2.4 image)
- **Open Watcom:** ./build.sh rel

---

## 🎓 LEARNING RESOURCES

### Architecture Documentation
- `rc700-gensmedet/RC702_HARDWARE_TECHNICAL_REFERENCE.md` - RC702 hardware
- `rc700-gensmedet/ROA327_CHARACTER_ROM.md` - Character ROM analysis
- `rc700-gensmedet/cpnet.md` - CP/NET documentation

### Development Guides
- `llvm-z80/CLAUDE.md` - LLVM-Z80 specific guidance
- `mame/src/mame/regnecentralen/README.md` - MAME driver guide
- `open-watcom-v2/contrib/ravn/README-cpm86.md` - CP/M-86 development

### Project Management
- `tasks/todo.md` - Current work list
- `tasks/finishing-roadmap-2026-06-03.md` - Finishing plan
- `tasks/memory/MEMORY.md` - All durable rules

---

## 🏆 SUCCESS CRITERIA CHECKLIST

Before marking any task complete, verify:

- [ ] **Code compiles** without warnings
- [ ] **LLVM changes:** Lit test added and PASS
- [ ] **MAME changes:** Boot test PASS
- [ ] **Size changes:** Within PROM limits (2048B)
- [ ] **Dual-compiler:** Both z88dk and clang build (if applicable)
- [ ] **Test suite:** Relevant tests PASS
- [ ] **Documentation:** Updated (comments, README, etc.)
- [ ] **Memory notes:** Added to `tasks/memory/` if durable
- [ ] **Git:** Committed with proper message

---

## 📞 HELP & SUPPORT

### When Stuck
1. **Re-read MEMORY.md** - Most answers are there
2. **Search tasks/memory/** for similar issues
3. **Check git history** - `git log --grep="keyword" --all`
4. **Ask user** - Provide context and what you've tried

### Useful Commands for Investigation
```bash
# Search for error messages
grep -r "error message" /Users/ravn/z80/

# Find similar fixes
git log --all --grep="keyword" --oneline

# Check recent changes
git log --since="2026-08-01" --oneline

# View file history
git log --oneline path/to/file
```

---

## 📝 SESSION TEMPLATE

```
User Request: [specific task]

Mistral Vibe Response:
1. Read relevant memory files
2. Search workspace for existing solutions
3. Report findings
4. Propose plan
5. Execute with verification
6. Document results

Example:
User: "Investigate ZIP deflate issue"
Mistral Vibe:
- Read: tasks/memory/MEMORY.md, cpm86-compiler-comparison/PLAN_zip_deflate_mame_2026-08-25.md
- Search: grep -r "deflate" /Users/ravn/z80/cpm86-compiler-comparison/
- Report: Found active investigation in PLAN_zip_deflate_mame_2026-08-25.md
- Propose: Run STORE-only control test, isolate zlib state
- Execute: Run test, compare outputs
- Document: Add findings to investigation file
```

---

**CANONICAL LOCATION:** `tasks/memory/agent_mistralvibe_quick_start.md`
**LAST UPDATED:** 2026-08-31
**MAINTAINER:** Mistral Vibe
