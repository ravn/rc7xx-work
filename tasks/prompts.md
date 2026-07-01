# Prompts

## 2026-06-24 (B17 carry-chain fix)

> do b17
> when was this decision made?
> can you fix it?
> remember thorough testcases
> note i want the thorough test suite part of the future tests to run
> remember killing ninja causes full rebuilds, don't do that unless absolutely necessary

## 2026-04-06 (session 12)

> #60
> #58
> i dont want to use the docker build anymore now i have a native build
> please rebuild the debug build
> now what?
> #7
> please investigate if the conout path can be improved
> no it was a mistake. now what?
> automatically investigate problems in session found creating tasks and issues as necessary. summarize your work and findings in the project, and commit
> fix redundant or a
> what now?
> I want the prom to optionally show a qr code in line 4 onwards (QR investigation — see tasks/qr-code-investigation.md)
> fact: I only have SDL2 available
> the rc700 emulator is present at ~/git/rc700 you may try that
> it looks like the screen is fed by two different dma channels in turn. I want to change that.
> drop the qr code for now, but put your findings in the project

## 2026-03-31 (session 4)

> open a new branch and investigate #37
> investigate the failures
> does the failing test cases pass when run directly on the host with the native compiler?
> the tests assume 16-bit ints
> now that you have found out how to print you can convert the failure count to printing a unique line for each test. Possibly this was done originally. Then you can immediately see which test failed.
> you should fix the generator if this works
> why did the compilation pass if there was no implementation of putchar
> it may be the bss overlaying issue we've seen before where multiple variables not in scope at the same time, is placed in the same memory location
> yes (file #38)
> for now use undocumented
> fact: always check that the checksums from mame are the same as expected for the prom to test, to avoid stale builds
> be absolutely certain it is the right prom
> fact: Black screen in mame means the 50hz interrupt routine isn't working as expected
> we now have a new prom size baseline
> automatically investigate problems in session found creating tasks and issues as necessary (x2)
> Look into #38 on a new branch
> you must also validate yourself that the test is correct
> would the "shadow-regs" have an influence on this?
> the bug may have been introduced when I added ix and iy to registers allowed to be used
> i have decided that the original work with enabling ix and iy as registers is incomplete, and i would like to put the current state aside as an issue and revert to not having ix and iy as registers
> file an issue about clang needing to measure both with ix handling stack and BSS in memory when going for optimal code size (#40)
> now that ix and iy are not considered for registers anymore, investigate the 16-bit int correctness. You should fix the generator script when done investigating

## 2026-03-28 (session 3)

> #29 (+static-stack incorrect code). I would also like the test cases to both inline and not inline

> i want to have a set of tests and programs that compile with several compilers and those who are either smaller or faster than llvm-z80 should be investigated thoroughly to see how it is done and if possible add this to clang, with the usual mindset of starting with the cpu and its instructions and going backwards from there. Start with setting up the framework allowing several compilers and start with z88dk zsdcc.

> i want the new compiler comparison to look at the generated tests in edgecase-testing (can you suggest a better name?)

> automatically investigate problems in session found creating tasks and issues as necesary. summarize your work and findings in the project, and commit

> i have freed up space

> i have stopped docker and cleaned.

> i keep running out of diskspace

> the docker raw diskimage under docker desktop grew to 90 gb

> the z88dk image is not v2.4 but 2.4

> restarted computer because docker hung

> docker ready, continue

> automatically investigate problems in session found creating tasks and issues as necesary. summarize your work and findings in the project, and commit

> #32

> 1

> perhaps its a peephole optimization?

## 2026-03-28 (continued)

> #22

> #26

> #24

> #16

> chatgpt has made me a z80 specific test generator i would like to add to the llvm-z80 project and include in the test suite / i have added two files. Please make them work with clang

## 2026-03-26

> fact: always record my prompts in the project. Never apologize, show thinking, be concise and accurate. I want to optimize the z80 backend to the clang compiler located at https://github.com/ravn/llvm-z80, against my testcases in https://github.com/ravn/rc700-gensmedet where the autoload-in-c is the first and perhaps the rcbios-in-c the next. I want to check them out (I can use ssh and gh) in this repository as well as additional projects needed to build. Then look at the instructions in each. I have docker but not brew (never ask for it, never try it). You can use z88dk in a docker container instead of rebuilding from source. I have worked extensively with you on both projects. I want to use CLion as the IDE but work with you on the command line. goal is to reach the same code density with clang as with sdcc. I want you to see the patterns in the code generated by sdcc, and figure out how to make clang generate the same or better. Never make pull requests against other repos.

> i want you to think out loud at all times. i dont want you to store memory in ~/.claude, but only in the projects themselves

> (shallow clone for llvm-z80)

> adjust, i want to work in a single folder

> create clion support here for opening llvm-z80 rc700-gensmedet/autoload-in-c and rc700-gensmedet/rcbios-in-c from this folder.

> add https://github.com/z88dk/z88dk which is where the sdcc compiler used here lives. I want to enhance it to generate docker images for arm64 too

> i want to fork z88dk to my own github account and use that as the remote for this

> fact: never ever create pull requests without being told

> undo. I want the prom build to use docker instead of a local z88dk instance

> a lot of work has happened on llvm-z80 upstream and i cannot merge. Please investigate what has happened, and make a plan for bringing my fork up to date with the latest

> unshallow clone

> fact: i always want no-ff merges

> i previously found that i didn't have the tooling on my mac to build llvm-z80 and we ended up using docker for this. Please list what is necessary to build, and I'll decide

> I'll go with the build image then

> docker is up

> goal: get the llvm-z80 clang compiler to generate as good code as sdcc (z88dk) for my autoload-in-c project. Do this by going back on the code generated by sdcc and understand why the compact code was generated for the original C, and then look at what clang generated and figure out how to improve it. I do not want workarounds, but proper fixing of the underlying algorithms (of which peep hole optimisms may be fine, but check thoroughly first)

> please create and maintain assembly list files (output from the assembler) for both compilers

> todo later: see if the clang listing can have interleaved c

> unpark runtime bugs

> i want the compiler to detect when to use ix as a stack register and when to use it as an index pointer

> put it first in the list. then investigate and summarize before replanning

> fact: The size of the prom is for code only, the bss is allocated in memory after loading. It is therefore not a priority to minimize the size of bss, just minimizing the code size. Please adjust size calculations to not include the size of the bss

> fact: If the screen is not black, the crt refresh interrupt is active

> fact: you must verify the timestamp in the bios banner (to ensure the binary was rebuilt)

> put it first in the list. then investigate and summarize before replanning

> investigate what "clang -Weverything -c ..." can tell me

> fact: You don't need to care about long sessions. I would like to know though when it is a good time to clear up context and start a new session

> a lot of work has happened on llvm-z80 upstream and i cannot merge. Please investigate what has happened, and make a plan for bringing my fork up to date with the latest

> please build arm64 docker image for version 2.4

> build with the tag z88dk:v2.4

> the prom should build with the newly build docker image

> changes z88dk docker build from latest to v2.4

## 2026-03-27

> start #14

> can you automate this test fully so I do not need to confirm until you have reached a conclusion?

> you may use a debugger and the mame gdbstub to look inside if needed

> it may be that two interrupt routines are firing at the same time?

> todo later: Experiment with HITech C to see how well it does.

> you are making issues in the upstream llvm project, not my clone. Never do that - only in my clone. Please move them and apologize

> todo: If we know at a given time that a register (for instance a) contains a specific value, it may be faster in time and denser in code to initialize another register (including HL=0 from H=A and L=A if we know that A is 0) instead

> also when considering whether a byte sequence is better than another byte sequence do not only look at the length but also the execution time. Go back in history to see if any decisions taken would be influenced by this.

> 5 (duplicate LD rr,imm peephole)

> park it for now - it may be applicable when looking at the bios

> 2 (PUSH/POP instead of IX-indexed spills)

> clear context and start #1 (loop index→pointer conversion)

> in this snippet d is loaded with zero in the branch where we know that a is zero so it would be more efficient to just load d with a. (ld d,a instead of ld d,$0 when A is known zero after OR A; JR Z)

> #1

## 2026-03-27 (session 2)

> #1 (loop index→pointer conversion)

> make the simple solution

> please boot mame and let me test

> please boot mame with a polypascal disk and let me test

> fine, all seems ok

> would it make the code smaller if the init_* routines could be inlined in sdcc?

> automatically investigate problems found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit

> 1 (signed 16-bit comparison bloat, ravn/llvm-z80#19) — parked: MBB split crashes, needs replanning

## 2026-03-27 (session 3)

> #20 (multi-value BSS spill across CALL)

> automatically investigate problems found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit

## 2026-03-28

> investigate if there are any patterns that are not as concise in clang binary as in sdcc binary

> investigate "Signed 16-bit > 0 comparison"

> automatically investigate problems found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit

> #21

> automatically investigate problems found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit

> #25

> #23

## 2026-03-29 (session 19)

> #32 — fix it without undocumented instructions

> automatically investigate problems in session found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit

> look into "Bit test" bug → already fixed, i1 edge case fixed (13B→3B)
> fix "(val & 0x80) != 0" → ISel SLT/SGE 0 RLCA optimization
> boot mame → verified, -skip_gameinfo for checksum warning
> revisit issues #32/#30/#14/#33/#28 → #14 resolved (IY unreserved)
> unreserve IY, test-gen SDCC comparison with T-states
> z88dk-ticks I/O → TICKS.md, putchar via -iochar 1
> CP/M experiments (branch experiment/clang-z88dk-libc):
>   elf2rel pipeline, mandelbrot (905B fixed-point, 3555B float)
>   z88dk stdlib, stdio.h headers, clang2z88dk.sh
> Issues filed: #35 (no libc), #36 (va_arg), #37 (LD A,IYH), ravn/z88dk#1
> Docker: z88dk:2.4 rebuilt natively ARM, llvm-z80-test with sdcc

> automatically investigate problems in session found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit

## 2026-03-31 (session 5)

> fix #41
> now investigate why decimal line number printing fails
> i would like for the 02 and 03-optimization level tests to have as many tests as can fit - please find out for each and test
> todo later: investigate if there are additional tests that could be added to the generator
> investigate if #41 can be closed
> now i want the rcbios to work with clang. please investigate and open tasks and issues as appropriate
> to do later: Investigate if clang can be taught to get parameters in BC,DE, and/or HL and return in C with vendor specific attributes
> (design discussion: two jump tables, all asm in bios_shims.s, minimal shared source changes)
> linker script → bios_shims.s → hal.h → compile+link: 6373 bytes, naked stubs gc'd
> summarize in project and commit
> boot in mame and let me test
> everything looked fine
> automatically investigate problems in session found creating tasks and issues as necesary. summarize your work and findings in the project, and commit
> next → Makefile targets (clang_bios, clang_mame, clang_asm, clang_clean)
> automatically investigate problems in session found creating tasks and issues as necesary. summarize your work and findings in the project, and commit
> next → size optimization: BSS load forwarding in Z80LateOptimization.cpp
> volatile fix (-45B), memcpy scroll (-39B), conout assembly analysis
> todo later: investigate z88dk intrinsics for CP/M ABI return values (https://www.z88dk.org/wiki/doku.php?id=libnew:intrinsic)
> todo later: investigate z88dk GDB debugging interface (https://deepwiki.com/z88dk/z88dk/7.2-gdb-debugging-interface)
> fact: conout must be optimized for speed
> make an issue of memmove hanging in rcbios for sdcc → rc700-gensmedet#6
> a custom memmove for clang mapping directly to assembly could be useful

## 2026-04-01 (session 7)

> #45
> yes (implement issue #45: LD (addr),rr for 16-bit stores to constant addresses)
> todo later: add +cpmdisk and semigraphics support for rc700 to z88dk
> (selected memmove at bios.c:1036) do a minimal memmove shim that resolves to lddr here
> the memmove shim should be inlined → should be just three ld and a lddr
> (selected _bss_compiler_head at boot_entry.c:60) look into why _bss_compiler_head - BIOS_BASE is not a constant resolved at link time
> (selected ffd2 at bios_src.lis:3290) tackle it now → filed #46, fold causes R_Z80_16 overflow, deferred to linker fix
> why is 1 better than 2? → it's not, Z80 has 16-bit address space, wrapping is always correct → linker fix (#47)
> summarize in project and commit
> why is this not calculated at linktime? → stale .lis file, already fixed
> isnt this redundant? (ld de + ld (bss),de) → filed #48, BSS store/load for constant pointer locals
> what would it take to optimize this into an otir? → inline asm workaround, filed #49 for compiler support
> is hl the right value already for the second otir? → yes, sioa[9] contiguous with siob[11]
> note in the issue that the compiler should know the register value after otir
> test mame boot → PASS, CRC verified, banner RC700 CL
> automatically investigate problems, summarize, commit
> (selected fd0 loop) can this be a memcpy? → yes, -13B
> is 16 a property of cfg.infd? → no, sizeof(fd0)
> issue: LDIR is slower than unrolling into LDI commands → filed #50
> todo later: investigate DMA controller for screen scrolling instead of CPU copy (unused DMA channel + completion interrupt as lock)

## Session #8 (2026-04-01/02)

### memcpy_z80 experiment
- Implement Duff's device 16xLDI memcpy for scroll speed optimization
- Pure C with inline asm `{de}`,`{hl}`,`{bc}` constraints → generates clean 16xLDI+JP PE
- Benchmarked with z88dk-ticks: 20% faster than LDIR for >=16B
- API: `memcpy_z80(dest, src, blocks16, remainder)` — all compile-time constants
- Branch: experiment/duff-memcpy

### Banner bug investigation (#51)
- BIOS cold boot banner missing — never reaches display memory
- Automated compiler bisect: broke at commit 1fa0b125 (session #7 direct addressing)
- MAME debugger trace: `puts_p` enters but `bios_conout_c` never called for banner
- Memory inspection: banner string at $EB32 contains 0x00 at runtime
- Root cause: BSS self-clobber in `relocate_bios()` with +static-stack
  - Compiler stored p+1 to BSS static, *p=0 corrupted stored pointer
  - LDIR destination became $EB00 instead of $EB69, zeroing .rodata
- Fix: inline asm BSS clear, sentinel word in linker script

### Spill class bug (#52)
- `-verify-regalloc` catches: SPILL_GR16 rejects Anyi16 class
- getLargestLegalSuperClass returned Anyi16 (includes SP)
- Fix: widen SPILL/RELOAD pseudos to Anyi16, restrict superclass to GR16
- Lit test: spill-regclass.ll

### Filed issues
- ravn/llvm-z80#51 — Boot banner missing (BSS self-clobber) — FIXED
- ravn/llvm-z80#52 — SPILL_GR16/RELOAD_GR16 reject Anyi16 — FIXED
- ravn/llvm-z80#53 — +static-stack allocates trivially-constant locals to BSS

### Key findings
- Base Z80 compiler (pre-fork) produces correct BIOS code
- Without +static-stack: BIOS 6617B (+908B), works correctly
- memcpy_z80 no longer blocked by #51 — boots with banner at 5742B

### Build system refactor
- Rename clang_z80/ to clang/, create sdcc/ folder
- COMPILER?=clang variable selects which compiler builds bios.cim
- Sub-Makefiles handle build rules (Docker mounts parent as workdir)
- SDCC build via z88dk:2.4 Docker image
- Fixed SDCC compatibility: guarded clang asm, lddr_copy
- Common sentinel check: verify_relocation() called from coldboot()
- Both compilers verified: clang 5746B, SDCC 5577B, both MAME boot

### MAME ROM warning
- Disabled show_warnings in ui.cpp (CRC changes every build)
- ROM definitions keep original hashes for documentation
- ROM size set to 0x1000 (4KB 2732 EPROM)

### DMA channel configuration
- Made DMA channel assignments compile-time configurable in hal.h
- DMA_CH_HD/FLOPPY/DISPLAY/DISATTR constants with encoding macros
- Am9517A register values derived automatically (port addr, mode, mask)
- Zero runtime overhead — all values constant-fold
- Branch: feature/dma-channel-config (unmerged, ready)

### DMA and CONOUT analysis
- ROA375 PROM uses zero-copy hardware scrolling via DMA split
  - ch2/ch3 split circular buffer: scroll = update 2-byte offset
  - No memcpy needed — eliminates scroll CPU cost entirely
- isr_crt timing: ~320-380T per invocation, 50Hz, ~0.4% CPU
- MAME FDC DREQ emulation: dreq1_w hardwired in rc702.cpp
- Memory-to-memory DMA: software request, no DREQ lines needed

### Todos recorded
- Clang vs SDCC BIOS size gap analysis
- CLion debugger via MAME gdbstub
- MAME DMA port/DREQ sync with BIOS defines
- 26th status line via DMA split
- Circular display buffer (zero-copy scroll)
- Build variants: compatible and fast directories
- T-states reference for compiler output

## Session #9 (2026-04-02/03)

### CLion integration
> CLion full BIOS integration, MAME run configs
> Various CLion warnings/diagnostics fixes

### Native macOS clang build
> build clang natively on macos
> autoload Makefile native toggle
> -Os → -Oz (broke FDC timing → fixed via delay_ms)

### delay_ms() refactor
> delay should take milliseconds
> look in rcbios for original timings (391ms FDC, 3ms WAITFL)
> use z80_delay_ms() for SDCC, inline asm for clang
> fix DELAY_T=76 → 16 (was 4.75x too slow)
> verify with ticks (16.07T measured = 16T correct)
> configure clock frequency (CRT_CPU_CLOCK_HZ=4000000)

### Cleanup
> remove unused files (34 files, -4373 lines)
> move build artifacts into compiler directories
> parallel clang/sdcc builds
> rename COMALBOOT → LEGACYBOOT, floppy_boot → floppy_legacy_boot
> volatile floppy_operation_completed_flag
> .clang-format (K&R, mandatory braces)
> top-level Makefile (make toolchain)

### CLion full BIOS integration
> i want clion to fully understand the bios as is now, and then set MAME up as a deployment target with debugging
> can clion be told to use another compiler?
> clion needs to be told the level of c compliance enforced by zsdcc compiler compatability
> please mark port input variables as not always returning zero to clion
> clion flags for(;;)
> make clion not flag Function 'isr_enter' is never used / Function 'isr_exit' is never used
> is this intentional? cpmrbp = cpmrbp;
> todo later: get clang to build on macos
> automatically investigate problems in session found creating tasks and issues as necesary. summarize your work and findings in the project, and commit

## 2026-04-04 (session 10)

> what now?
> investigate Clang vs SDCC BIOS gap analysis
> i did 26 lines instead of 25 by reprogramming the crt.  please investigate https://github.com/ravn/rc702-bios
> (26-line CRT investigation, 8275 datasheet transcription, kox.pas analysis)
> (serial transfer to physical RC700, cable wiring, flow control)
> i want the bios to empty the serial buffer when full before enabling it again
> (BIOS RTS drain-to-empty: 5300→59 CTS drops per transfer)
> (BIOS-only hex via MLOAD+BDOSCCP.COM workflow, 363 records ~24s)
> (macOS FTDI tcdrain broken, Linux works)

## 2026-04-06 (session 11)

> i have moved bios development to another machine.   I would like to investigate the autoprom further here.
> park the hi-tech c comparison
> investigate thoroughly if there are any z80 optimization techniques applicable to the prom that has not yet been looked into, and if there are any compiler issues that could help
> there was a comment about fixing fastcall?
> automatically investigate problems in session found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit
> #59
> can't the compiler guarantee that the counter is 8 bit?
> (approved plan for ISel narrowing)
> #56 - and consider "BIT 7" commands too
> (implemented SHL 6-7 via RRCA+AND)
> #55
> (implemented ADD HL,DE commutativity peephole)
> now do #61
> (implemented in-memory INC/DEC (HL) peephole)
> should #54 be fixed with inlining?
> i did this in sdcc, by having a peep hole optimization that looked for jumps to a label immediately following it
> (filed design note on #54, implemented #57 comparison reversal as post-RA peephole instead)
> it appears that the rc700 cannot do 4kb proms at the moment so prom limit is 2kb for now.
> todo later: I want a QR on the rc700 screen. This requires using semigraphic characters (the 2x3 blocks)
> automatically investigate problems in session found creating tasks and issues as necesary.  summarize your work and findings in the project, and commit
## Session 14: -Weverything, banner cleanup

- Investigate clang -Weverything -c on PROM sources
- Make -Weverything default, handle all warnings properly
- Convert banner to normal zero-terminated string
- Unify banner generation across compilers
- No trailing spaces in banner
- SDCC banner: convert from DEFM hack to const char[]
- Analyse, raise issues and tasks, summarize and commit

## Session 18: Serial speed limits, sync mode, J8 bus expansion (2026-04-18)

- what now?
- you found that the rc700 could _send_ serially at 250000 baud but only receive at 38400. Verify mame supports this split speed
- please check. (CTC-to-SIO wiring on real RC702 hardware)
- please add your findings to the project
- what is the maximum clock the sio can be fed if i decide for a pcb modification?
- why does the sio chip accept x1 if it is unreliable?
- could we simulate a lock phase-locked to the incoming data?
- fact: i am trying to avoid hardware modifications on the rc700
- in the long run i may look into connecting to the j8 connector which expose the full z80 bus. consider what communication speeds that may provide. there is already a mem700 ram disk
- i am not sure that the dma controller is wired up for this
- please check. (RC702tech.pdf and RC702-RC703 technical manual for DMA/J8 wiring)
- please save your findings in the project
- note that rc703 is a later model referring to mic704 and mic705
- please record whatever else you found in the project too
- i would like to follow the "Most practical path: HDLC over NRZI with FT2232H MPSSE" to actually trying if it works
- fact: i would like both the sio-a and the pio approach for best possible performance under cp/net for remote file sever usage
- and please plan the nrzi
- (discovered: Z80-SIO/2 has NO DPLL or BRG -- those are SCC features. Revised to SDLC with CTC external clock)
- the mame programmer did not have access to the physical hardware... (filed ravn/mame#3: z80dart->z80sio)
- i can buy a better adapter if the current one cannot do it
- if there is a pin to the sio that is currently unassigned that could be used... (answer: no, SYNCA is output in SDLC mode)

## 2026-05-25 (AGENTS migration + #189 regalloc drill)
- what should I have told you for you to decide to take the step back yourself? (-> added feedback_zoom_out_on_recurring_pattern memory rule)
- I have AGENT.md I copy project to project -- add the memories to it or another copyable file? (using Claude, Copilot, others)
- migrate AGENT.md into AGENTS.md; behavioral + house-style preamble
- if AGENTS.md is stale, move it away and create the new one
- I want AGENTS.md identical in all projects (except new rules); "this workspace" stuff in a separate file -> PROJECT.md
- commit all three and merge session-73t; push all three; delete the merged session-73t branches; prune merged branches in the other repos
- given the new set of rules, what should you do now? (x2 -> branch-hygiene convention + lessons.md propagated-file-verification rule)
- the goal is still to fix the remaining parts of the z80 backend properly by getting to the core problems, derive descriptions of what needed fixing, with test cases, and submit upstream for discussion
- you may also investigate the upstream documentation thoroughly as you go
- i am primarily focussed on bringing things to z80 backend upstream, then upstream-upstream llvm (unless the bugs interfere with the z80 backend)
- go ahead with all three (#189 drill: plan reprioritization + correctness run + commit writeup)
- go (push + lit XFAIL + issue comment); go as long as you reasonably can (implement the #189 fix)
- go (resume #189 implementation drill: step-1 subreg-class confirmation + pre-RA MIR mechanism)
- can you explain why this is hard?
- why is the fix simple if we cannot model the z80 correctly? (legality-vs-cost framing)
- please document this thoroughly (-> drill doc: legality-vs-cost insight + empirical MIR mechanism + two ruled-out APIs)
- write the pass (-> built Z80NarrowSubRegGR16; found redundant; real lever = getLargestLegalSuperClass re-widening, flag-gated; production byte-identical; crc_one fixed)
- would it benefit to take a step back and do a deeper investigation? (-> yes; sweep showed ~20 files, whack-a-mole; reframed around the invariant)
- run the taxonomy sweep (-> issue112-189-iy-leak-taxonomy: Class A undoc-emission ELIMINATED suite-wide, Class B miscompile fixed+verified i32/i64, Class C residual density only)
- land the two fixes (-> committed+merged session-73ab: getLargest gate + Z80NarrowNoIndex pass; llvm-z80 6070083, workspace 9ff0b8b; no push)
- keep going as far as reasonably can (-> closed verification gap: test_173 i128 0x4761, test_174 float 0x0007, all opt levels default config; Class C correctness verified across i32/i64/i128/float)
- b (-> pushed both repos; commented result on ravn/llvm-z80#189)
- start the create-time-chokepoint session (-> REFUTED in 30-min drill: Class C is all whole-pair IY-as-extra-register, not byte-decompose leak; size win i128 -120 vs loss fixed-point +21 = genuine #38 cost-model tradeoff; chokepoint would harm wins. No code change; finding documented in taxonomy doc.)
- can you explain in laymans terms what we are pursuing (-> desk/filing-cabinet/awkward-drawer analogy)
- to do later: reinvestigate if EXX extra bank could be useful (-> backlog note in tasks/todo.md, links #7 + #114)
- commit then what? (-> committed EXX note; laid out next options; user picked option 2 = smaller upstream thread)
- 2 (-> #180 peephole audit: completed C1 migration. Found XOR0xFF->CPL peephole still live for i16 ==/!=-1 cmp fallback; migrated that to ISel CPL emit; retired the peephole. Byte-identical lit, fail/fatal unchanged.)
- go (-> pushed #180/#181 commits; commented #180 progress; closed #181)
- keep going as far as reasonably can (-> #180 triage: 73s C2 already verified all candidates LIVE (not dead-removable); non-gated migration fruit exhausted (#6 done; #8 post-RA-dependent; #10 thin); rest gated on #177/#178/#179. Reported, recommended stop or fresh #177/#38 session.)
- #177 (-> scoped into a plan: tasks/issue177-tti-scoping-2026-05-26.md. Key findings: TTI mostly built+wired; it's IR-level so does NOT unlock #180 MIR/regalloc peepholes (#180 claim corrected); LICM/CSE flags redundant (global disablePass); -disable-lsr contested, re-measure; #184 i16 cost stays held.)
- keep going as far as reasonably can (-> executed #177 plan Tasks 1+2 measurement on cpnos: Task1 LICM/CSE flags confirmed REDUNDANT byte-identical (only cpnos has them); Task2 -disable-lsr = +2B on cpnos but raw payload IDENTICAL (compression artifact, LSR size-neutral on cpnos code; contrast AES +333B). Findings into plan doc; production source left pristine.)
- what now? (-> proposed forks; pushed pending #177 commits)
- change the rule about pushing to own repositories (-> attempted standing-push memory rule; BLOCKED by auto-mode classifier as memory-poisoning; explained the settings-rule mechanism; user chose to keep ask-then-push)
- finish #177 (-> Tasks 1-3: cpnos LICM/CSE flag cleanup committed; -disable-lsr validated on all 3 prod targets (all pessimize w/o it); Task 3 gate REFUTED via measurement -- LICM/CSE-on pessimizes at -Oz AND MachineCSE miscompiles at -O2; filed #198; #177 closed)
- are there debug flags...? / yes / what should I have told you... (-> recommended + built assertions build build-macos-asserts; extended zoom-out rule to methodology/tooling, reactive + proactive)
- can we do something while we wait? -> EXX shadow-bank probe (-> reinvestigated #114; verdict: keep parked, modest payoff + single-owner conflict with +shadow-regs ISR)
- wire -verify-machineinstrs into test-runner/CI (-> landed opt-in clang -verify flag; surface 171/174 backend-wide; CI gate deferred to post-#199 (later: post the 3-class cluster))
- remember to clean stale logs (-> ack, applied rm-before-produce)
- how many bugs could've been found faster with asserts build? (-> ~1/3-1/2, weighted to the peephole-liveness family)
- are there other useful flags or tools? / use them / go (-> opt-bisect-limit, llc -run-pass, llvm-reduce, -Rpass-missed; used opt-bisect to localize #198 to machine-cse-on-rj_sb_inv)
- it is very important you only state facts when certain (-> hardened feedback_state_certainty to HARD; corrected #198 overclaims)
- this should go in AGENTS.md (proactive tooling survey) / save that / i want [certainty] in AGENTS.md (-> both rules added to AGENTS.md across all 3 repos, committed+pushed)
- 1+2 / go / go for as long as you can (x N) (-> implemented+verified #198 fix (cross-block guard class-agnostic) + MIR test; merged, closed #198; triaged all 3 verifier classes; reconciled #199 dup of #194; recorded fix paths)
- all, keep going as long as you can (x2) (-> pushed; triaged illegal-vreg=#112/#189, too-few-operands=#200; #194 mechanism verified; stopped at decision/risk-gated remainder)
- analyse, raise issues and tasks, summarize and commit (-> filed #200; updated #197 with 3-class checklist; session summary + todo + timeline + this; committing)
- where are we? (-> status: all clean/pushed; #177/#198/#201 + SP-write guard + IY size-gate landed)
- all, keep going as long as you can (-> let's give #38 a go)
- please explain where this made a difference in my three projects (-> per-function byte deltas: BIOS _specc/_bios_reader_body/_bg_clear_from, autoload _main_relocated, cpnos _scroll_lines)
- the number of bytes is important... if slower register for speed flags. do IX like IY later (-> measured IY size-win/speed-cost; recorded gate-to-size-opt + IX-later + hang-later)
- implement (-> implemented size-gated IY un-reserve; verification caught test_58 miscompile; reverted)
- what did you fix? (-> explained the BSS-spill SP-write guard)
- both (-> pushed the fix; re-applied + verified + landed the IY size-gate ~33B win)
- where are we? (-> session status)
- all, keep going as long as you can (-> verify-clean cluster: triaged all 3 classes; fixed multiple-vreg-defs via tied-INC16 fresh-dst (+ test_38 miscompile); checkpointed before delicate #194)
- analyse, raise issues and tasks, summarize and commit (-> filed rc700#100; session summary + timeline + prompts; committing)
- all, keep going as long as you can (-> Cluster 3 #200: SPILL_GR16/RELOAD_GR16 offset-operand-count verifier fix; codegen-neutral, oracles green, cpnos payload byte-identical 2028 B)
- go (-> continued Cluster 3 verifier sweep; #194 + #209 PUSH AF/EX DE,HL fixed+committed, cpnos -6 B; characterized remaining PUSH_HL liveness-reconciliation class + wrapped)
- all, keep going as long as you can (#2 -> drilled the PUSH_HL verifier class: SP-relative frame-spill HL-borrow, over-conservative save reads undef HL; STOP per discipline (frame expansion = highest miscompile risk, exact site unconfirmed). Verified BIOS clang 5897 B unchanged (no regression). Documented next-session drill.)
- all, keep going as long as you can (#3 -> pinpointed PUSH_HL: SP-relative spill HL-borrow, isRegLiveAt cascading over-report; filed #210 (non-production: default config only, runtime-correct). STOP per discipline (frame-expansion miscompile risk). All targets verified.)
- all, keep going as long as you can (#4 -> verified Cluster 0 batch already closed; fixed+closed #124 (cmake benchmark cache, build-only, verified clean configure); assessed #137 as a focused-session feature; wrapped)
- investigate 137 thoroughly (-> #137 IMPLEMENTED+verified: test-runner now captures port-1 console text on a failing test and prints it under the FAIL line. Root mechanism: z88dk-ticks `-iochar 1` routes `out (1),a` to stdout; runs WITHOUT `-trace` (separate run) so output is clean (the trace firehose is 32542 lines with chars glued in). New emulator::capture_port_output + strip trailing cycle-count line; TestResult.note field; rendered in display.rs + run_all.rs. Verified end-to-end on a throwaway 2-fail fixture (showed `FAIL @0022 got=0019 exp=0063`), passing tests get no note, 21-test slice green. Tooling-only, zero codegen risk.)
- whar now? investigate if needed (-> assessed open-issue board: Cluster 0 verify-close items already closed; laid out 4 live options via AskUserQuestion)
- [chose #210 verifier fix] (-> FIXED #210. Found the filed root cause WRONG: Z80 uses FORWARD frame-index elimination (eliminateFrameIndicesBackwards=false), no cascade. Real causes (from MIR): (1) isRegLiveAt over-reported HL when halves redefined separately -> per-unit liveness; (2) GR8 half spill/reload forced HL save -> save only if other half live + IMPLICIT_DEF dead dest; (3) #209-family emitSPRelativeAddr flag-preserving PUSH_AF reads dead A -> undef. aes256 verify 0 errors (was ~24); -verify suite A/B 757->753 (no regression); oracles 799/0 + 793/0 unchanged; AES 13/13; cpnos 2022 B + polypascal PASS 50.97s; lit 127+5->129+5. Pushed, closed #210.)
- I want you to focus on getting the verification correct (-> characterized the -verify surface: 2313 errors, LAYERED (verifier aborts at first failing pass; clearing one layer reveals the next). Fixed the dominant frame-lowering layer error: IX-frame large-frame prologue PUSH_HL read undef $hl when HL not live-in -> mark undef (mirrors no-FP path). -verify -full fatal 753->618, Pass 96->231 (+135 fully-verifying compiles). Metadata-only: oracles 799/0+793/0 exact baselines, cpnos 2022 B unchanged, lit 129+5->130+5. Dropped a zero-effect speculative GR16-bystander change (no failing test). Pushed 919329e3. Next layer: post-RA Z80LateOptimization peephole liveness (AND_A/SBC_A_A/DJNZ undef).)
- show your thinking (x2, standing rule)
- all, keep going as long as you can (#197 layer-clearing marathon -> 4 more commits after #210/prologue: (1) MBB-splitting expansion CFG fix (MUL8/UDivMod8 AddMBB/SubMBB, no duplicate successor) + function-wide live-in recompute [caught+reverted a broken naive dedup via the diff-oracle's +13 fatals, root-caused to mid-block-branch idiom]; (2) AND A $a-undef in 16-bit SBC/ADC lowering [biggest class, 707->0 at O2, conditional on A-live-in via LivePhysRegs]; (3) lit test. All metadata-only: oracles 799/0/50 + 793/0/50 exact baselines throughout, cpnos 2022 B byte-neutral, aes 0, lit 127+5 -> 132+5. -verify fatal compiles 753 -> ~600. Commits 3c54090f, c4af4ad2, d9721bf. Residual: SBC A,A (carry-materialize) + frame-lowering bystander borrow (SPILL_GR16/PUSH_HL) classes.)
- all, keep going as long as you can / investigate -verify -full fatal compiles / are we making progress? -> SBC A,A don't-care $a-read marked undef (10 sites, result independent of A); O2 SBC_A_A undef 132->0; oracles 799/0/50 + 793/0/50 exact; cpnos 2022 B; lit 132+5 -> 133+5. Commits 6ac22257 + 3822f24f (lit CHECK fix). INVESTIGATION of remaining -verify -full fatals: ~600 fatal compiles, concentrated in float tests (test_46_f32 394 errors, test_45/43/08/44, test_174). Dominant remaining class is undef-$hl reads in heavily-spilled blocks (e.g. test_46 main bb.21: COPY $hl / SPILL_GR16 $hl / PUSH_HL all read undef HL; block has NO liveins line) -- a MISSING-LIVE-IN class, NOT the SP-relative bystander borrow (those PUSH_HL turned out to be call-arg pushes of defined HL). Next: bisect which pass drops bb.21's HL live-in (spill inserter? post-RA?). Investigation hung ~10min on test_92/test_96 (separate slowness).
- continue towards no verification errors / fix GHA / where are we / fix Node.js 20 -> (1) GHA failure was already fixed (6ac22257 typo'd CHECK -> 3822f24f green); (2) implemented Z80PruneCallFrameDefs pre-RA pass: prunes ADJCALLSTACKUP's worst-case Defs=[SP,HL,A] to actual AdjAmount clobber set, run from addPreRegAlloc before first liveness -> clears the DOMINANT float-call verifier class (test_46 394->0). BROAD regalloc change, fully gated: oracles 799/0/50 + 793/0/50 (no miscompile), AES 13/13 PASS and SMALLER (09_prod 2559->2526), cpnos +1B (2023, under cap), lit 133+5->134+5. (3) Node.js 20 deprecation fixed in z80-ci.yml (checkout@v5 + FORCE_JAVASCRIPT_ACTIONS_TO_NODE24). Commit cf2f512.
- i have now started working on sonnyboy directly in addition to remotely from macbook (-> session-start pull + handoff read on sonnyboy; repaired z80pack submodule working tree emptied by an aborted submodule update (reset --hard to c37fd9c1, user-approved); found rc700-gensmedet pins z80pack b2eb2f36 which exists ONLY on the macbook (never pushed) -- macbook must push; memory: reference_host_sonnyboy.md + per-host workspace-root generalization of the no-home-search ban)
- i have added the public key for this machine to github (-> verified ssh -T "Hi ravn!"; added global insteadOf rewrite https://github.com/ravn/ -> git@github.com:ravn/; REMOVED pre-existing opposite rewrite that forced ssh->https; gh CLI still needs `gh auth login`)
- file 1 on our repo (-> drilled bug 1 before filing: original #182 repro ASSERTS AGAIN at HEAD 2c3d594c (upstream merge re-imported the hasDedicatedExits assert above our generic-layer fix); root cause = Z80LoopIdiomFill violates deleteDeadLoop's caller contract; old lit test = stale oracle (llc passes, clang pipeline shape crashes). Filed ravn/llvm-z80#217 with clang-HEAD IR + proposed fix (formDedicatedExitBlocks in the pass + revert generic divergence). Bug 1 DROPPED from upstream queue.)
- where did this manifest? (-> bug5 provenance: cpnos PROM shrink, PASSWORD copy into CP/NET frame (#73) -> distilled #87 -> root-caused to InstCombine SimplifyAnyMemTransfer fold, local guard 475a65378517)
- please open the copy routine in clion / clion allows remote development (-> opened InstCombineCalls.cpp:172; learned sonnyboy runs CLion RemoteDev backend, user views via Gateway; /ide connected; fixed stale cpnos-rom ref in workspace CMakeLists)
- continue (-> cmake configure verified clean; BUG5 draft still awaiting per-filing go-ahead; proceeding to BUG2 presentation)
- 2 [continue 5-bug queue] (-> duplicate searches llvm/llvm-project for bugs 2-5: none found; BUG5 presented (draft + provenance #73/#87, cpnos init.c:435 login_pwd memcpy); BUG2 presented (draft from session-77 writeup); both AWAITING go-ahead)
- save state and prepare for shutdown (-> tasks/upstream-5bug/ created: STATUS.md + repros + draft-bug2/5.md; handoff addendum 3; committed+pushed)
- clean up CLAUDE.md (-> dedup Current Sizes bullets, refresh stale numbers to 2026-05-31 state, compress session history to 1-3 lines each per user choice, per-host workspace paths)
- I have run out of tokens... help being more efficient in this project (-> token-efficiency overhaul: MEMORY.md index compressed 32->22 KB, rc700 CLAUDE.md staleness fixes, new rule feedback_token_efficiency.md [filtered output/background runs/handoff+fresh-session], feedback_show_thinking.md tiered)
- i want the scroll wheel to scroll the window, not the prompts / inside screen in terminal.app / 1 fixed it (-> Terminal.app profile: uncheck "Scroll alternate screen"; noted terminal env in user_profile.md)
- where were we with llvm bugs / write missing drafts (-> drafts 3+4 written: bug3 reframed as "threshold dead without weights" with verified contrast-pair repro bug3-twoentry-phi-no-pgo.ll; bug4 reframed to upstream all-or-nothing outside-user bail; all 4 drafts now awaiting per-filing verdicts)
- analyse, raise issues and tasks, summarize and commit (-> verified fork cleanup complete via gh [#18-25+#176 closed]; todo.md refreshed [stale #205/#194 corrected, current queue at top]; handoff 2026-06-07-upstream-5bug-drafts-ready.md; no new filings — drafts 2-5 remain per-filing verdict-gated)
- iterate bug-2 understanding (walker structure, ||-merge question, Constant-vs-Argument leaf asymmetry, two-number width model, three kinds of "no") / file on my own repo to iterate (-> ravn/llvm-z80#218 staged with upstream permalink; move upstream on user signal)
- you forgot the c source (-> verified K&R rotl produces the exact repro IR at -O1; added C + ANSI-prototype zext contrast to #218; draft-bug2.md synced)
- i was looking for the original K&R source showing the problem (-> rj_sb_inv from Levin byte-oriented AES-256 added to #218 with attribution; measurement corrected: 147 B K&R vs 16 B ANSI ~9x, post-fix 31 B; prior 4.7x was pre-vs-post-fix mislabel)
- the github editor did not pick up your edits, please apply (-> review points 1-5 applied to #218: repro IR+command in main body, de-hedged root cause + construction-vs-analysis + ANSI-zext contrast inline, rj_sb_inv restored with corrected 147/16/31 numbers, stale 4.7x appendix dropped, cpp fences)
- still rather wordy, prefer my summary clearly mine + deeper explanation clearly yours (-> #218 restructured two-voice: user summary verbatim, attributed Claude deep-dive with repro/contrast/rj_sb_inv/corrected numbers; no duplication of stale 4.7x)
- put it as an issue on the actual source location (-> FILED llvm/llvm-project#202112 with L95-L105 permalink embed; staging #218 closed w/ cross-ref; STATUS row 2 -> filed)
- please keep an eye on the filed bugs (-> remote routine llvm-upstream-bug-watch created, daily 06:00 UTC, reads STATUS.md FILED entries + #217, reports at claude.ai/code/routines; STATUS.md notes the watcher + wording contract)
- stage 4 (-> ravn/llvm-z80#219 staged: two-voice scaffold w/ summary placeholder, L274-L288 permalink, both repro fns, corrected case-(a) attribution for gf_log)
- add the c source for the intermediate code in the issue [bug 4] (-> bound_check/mask_escape C verified via clang -O1 i386 -> exact repro shape; added to #219 with width-down note + cast-count caveat)
- we need z88dk-ticks present, available in z88dk (-> symlinked z88dk/src/ticks/z88dk-ticks into ~/.local/bin; test-runner now FATAL-free; host memory updated)
- i need a very thorough test case for this / FACT: all upstream bugs need very thorough test cases (-> lit matrix trunc-narrow-icmp-graph-side-soundness.ll [11 neg + 3 pos + control, fails pre-fix] + runtime test_222 matrix [84+14 subcases, 25 diverge at O2+]; rule saved as feedback_thorough_tests_for_upstream_bugs)
- is the test suite comprehensive or do you need more? (-> audit found 4 gaps incl. signed 7-vs-8-bit boundary that changes the fix; lit matrix extended to 25 fns)
- does it also trigger at a modern target? / is there an upstream supported target this triggers for? (-> NO: the unsound code is fork-only; upstream refuses all such outside users; exposure = anything compiled WITH the fork, any triple [Z80+SM83])
- are you absolutely sure this is an upstream bug? doesn't it belong in llvm-z80? (-> routing sure [limitation is upstream code], filing NOT — #219 evidence contaminated by the unsound gate; hold until re-measure)
- are there other 8-bit targets than avr? (-> in-tree: AVR only; MSP430 nearest 16-bit; 6502/Z80/SM83 out-of-tree)
- can upstream be compiled with multiple targets? avr build please / use upstream tree not fork (-> ~/llvm-upstream rebuilt X86;AArch64;AVR;MSP430)
- triage all possibly-upstream bugs against the avr build (-> tasks/upstream-5bug/avr-triage-2026-06-07.md: bug2 STRENGTHENED [K&R rotl 20 vs ANSI 3 instr, 6.7x on in-tree AVR]; bug3 WEAKENED->fork-only [no in-tree threshold override, select=branch on AVR]; bug4 HOLD [micro-shapes equalize + contaminated numbers]; bug5 consistency-argument-only [AVR swallows i64])
- update 2 with your avr findings, keep it brief (-> comment posted on llvm/llvm-project#202112: AVR 20-vs-3 instr at all opt levels, asm snippets)
- now look at 4 / leave 219, find out how the avr port works and fix z80 in the same way / both / avr as density oracle (-> bug4 verdict: sound territory already covered by generic InstCombine [%add.narrow], recommend revert-not-fix + no upstream filing; AVR mechanism = ldd/std Z+q displacement; gap quantified: i64 copy z80 65 instr vs avr 37; Fix A SHIPPED on branch avr-style-wide-access: pre-legalizer store(load)->G_MEMMOVE combine, 65->2 instr [ld bc,8; jp ___memmove_rt], lit+clang fixtures PASS; Fix B [#27 IDX16 extension] NOT started)
- i need a very thorough test case (-> see 2026-06-07 lit+runtime matrix entries above; branch icmp-narrow-soundness-tests)
- i need to go, wrap up and commit (-> both llvm-z80 branches pushed [avr-style-wide-access, icmp-narrow-soundness-tests], main untouched/CI-safe; handoff 2026-06-07-avr-absorption-fixA.md)
- where were we? (-> session status summary: #221 DJNZ -g + #222 filed today; design doc for memset.pattern target hook DRAFT awaiting review; upstream 5-bug queue per STATUS.md)
- finish the work on retire Z80LoopIdiomFill / [Both -- doc + issue body + prototype branch] (-> POC already on llvm-z80 main 6839ebc implementing stages 1-5+7+8; verified production: autoload 1669 [-4 from #221, not POC], cpnos PROM1 2030 exact, BIOS 5905 exact, Z80 lit 151+5, PreISelIntrinsicLowering subset 8/8. Design doc DRAFT->v1 with POC status + K=3 deferral rationale. New tasks/upstream-memset-pattern-issue-body.md ready to file at llvm-z80/llvm-z80 on per-filing go-ahead. Stage 6 [delete fork intrinsic] gated on K=3 i24-generalisation; Z80LoopIdiomFill retirement itself out of scope -- requires upstream LoopIdiomRecognize change. llvm-z80 commit d953651.)
- yes. why is retirement much larger? (-> explained: pass retirement requires growing upstream LoopIdiomRecognize to recognize multi-byte K-pattern fill -- security-sensitive code, no in-tree motivating consumer until Z80 mainlines, hundreds of LOC to replicate the recogniser's semantics, cyclic dep on Z80-upstream. This turn's RFC is the small opt-in step. Sub-repo commits pushed at user authorization: llvm-z80 d953651, rc700 85c7fb6+f07e263.)
- is Z80LoopIdiomFill correctly named then (-> No: `Z80` overclaims target-specificity [body is generic SCEV recognition], `Fill` ambiguous [vs memset]. Recommend `Z80PatternFillRecognize`, mirrors upstream LoopIdiomRecognize naming. Offered rename in follow-up.)
- yes. can we override LoopIdiomRecognize or make it overridable (-> 1] Rename DONE: Z80LoopIdiomFill->Z80PatternFillRecognize across file+class+helpers+pipeline-name+DEBUG_TYPE+display+comments+lit-tests+docs; lit 151+5 unchanged, autoload 1669/cpnos 2029 [-1 ZX0 noise]/BIOS 5905. 2] Override question answered in new design doc section 7.3: a TTI hook `tryRecognizeCustomLoopIdiom` symmetric to `shouldExpandExperimentalMemSetPattern` IS possible but deliberately NOT proposed -- recognition contracts open-ended, no rule-of-three second consumer, the lowering hook + a future direct K-pattern addition to LoopIdiomRecognize covers the same ground without an extensibility surface. Status-quo parallel pass via addIRPasses is the de-facto extensibility today. llvm-z80 commit 65cb811, pushed.)
- add your findings to the project (-> three durable landings: llvm-z80/tasks/upstream-coherence-map-2026-05-22.md Tier I row for memset.pattern hook [b5dc3b4]; rc700-gensmedet/tasks/timeline.md follow-up entry [dc7ceb9]; new memory rule tasks/memory/feedback_fork_local_pass_naming.md [d524249] -- reusable lesson "fork-local pass naming = upstream-candidacy honesty". All pushed.)
- list open issues / #2 [bugs 3+5] / c [both: STATUS.md + reframe bug5] / move 3 back to z80 fir now / reevaluate ravn/rc700-gensmedet issues / please add labels / then both [fix #101 + close bucket A] / c [retarget bucket C] / d [bucket D] / #30 / what is server.py? / do we use it? / delete it / yes [delete dependents] / what is open? / park 34 32 31 . investigate 50+89 / open 89 in browser / go / fix the lld plumbing / yes [adopt LTO BIOS] / run mame boot smoke / set -flto, not opt in / park 17 / investigate 83+84 / explain 84 / park 84 / explain 85+87 / 85 / 87 / wind down (-> single working session 2026-06-10 spanning issue triage + upstream debt management + LTO production adoption + cpnos cleanup. NET RESULTS: rc700 open issues 42->22 [-20: 9 closes, 4 retargets, 7 parks, 8 labels new]; bug 3 moved fork-internal ravn/llvm-z80#223; llvm/llvm-project bug 5 v2 reframed consistency-led [draft-bug5-v2.md, AWAITING per-filing go-ahead]; cpnet/server.py + 6 dependents removed [-2001 LOC dead code]; lld z80/sm83 bitcode-triple plumbing [978fca2 + lit test]; LTO default for clang BIOS [bcc9f97, BIOS 5905->5890 = -15 B, mame-test PASS]; #85 closed-not-actionable [investigation showed shim layer structurally required]; #87 partial [3 statics, polypascal-test PASS]; CLAUDE.md BIOS headline 5905->5890. 16 commits across 3 repos, all pushed.)
- open rc700 issues + triage 5 more + CP/NET TOD research arc + #103 issue tree (-> single working session 2026-06-10 continuation. NET RESULTS: rc700 open issues 22 -> 20 (5 closures #9 #36 #42 #45 #52, 1 fix+close #53 tap.lua DSPSTR->SIGNON_ROW1 commit 701bb39, 5 new issues filed). Research arc on #33: DRI CP/NET 1.2 manual (unix4fun mirror) confirms protocol has only 7 documented requester functions (64/65/66/67/70/71/106), no TOD path; cpnet-z80 server.asm fnctab routes BDOS 104/105 to neterr spec-faithfully; cross-checked all 3 CP/M 3 BIOSes (cpmsim/picosim/imsaisim) DO seed from host RTC at BIOS TIME, but both MP/M XIOSes read only GETSEC for minute-edge with 4 other sub-field constants absent — unfinished copy-from-skeleton, not architectural. Compupro NETDATE claim retracted as confabulation (no source). Path 1 (Function 66/67 + non-reserved FMT 128-255) chosen as DRI-blessed extension mechanism. Counter-design evolution within #103: 32-bit (2.72yr wrap, recent epoch workaround) -> 64-bit (kills wrap) -> 48-bit (fits BCDEHL, atomic register-packed read, 178k yr headroom, Unix epoch). Existing 32-bit BIOS CLOCK vendor extension at 0xDA56 widened in place via 4-way A-dispatch (A=0/1 legacy 32 DE+HL, A=2/3 new 48 BCDEHL); storage 6 bytes at 0xFFFA-0xFFFF. Issue tree: #103 MP/M XIOS SCB seed scoped to bnkxios-net-2.mac only / #104 rcbios CLOCK widen / #105 cpnos parity / #106 TODSRV.COM master service / #107 snios_get_tod slave seeding. rc700 commit 91d8a14 (timeline + prompts).)

## 2026-06-14 — INIR PIO-B Step 2+4 implementation

> we are currently trying to get inir pio b working

After laying out three paths forward in chat (hand-rolled asm / INI+CKS-fold / ring-shrink-TPA-grow / skip-2nd-drain), user picked **1+3**: hand-rolled asm `transport_pio_recv_block` AND bundle ring-shrink + TPA-grow layout migration in same commit.

> compare bytes received by mame with bytes sent by mpm
> do you need to inspect what mpm is doing?
> can you ask mame what the cpu is doing? It may be stuck on the INIR instruction, and you can inspect the registers to see if they are as expected
> save all your findings and go back to the working configuration. I still want the autoload dma

(-> Wire-level byte trace via cpnet_bridge logerror to /tmp/cpnos_dir_bridge.log showed slave received correct bytes through EOT of 41-byte response, then silent. Confirmed mpm-side inspection not needed (slave-side hang). Then ran cpnos-polypascal-test-trace target which produces /tmp/z80_trace.txt with full instruction trace; debugger inspection pinpointed PC=0xF301 dead-loop at _resident_handoff (netboot returned 0), 17 isr_pio_par fires with 2 going to drop path (12 % ring overflow). Root cause: ring-shrink (256->16) and INIR are coupled -- INIR drains data direct to msg, bypasses ring; without INIR data flows through ring and 41-byte bursts overflow 16 B. In MAME no working configuration exists for the bundle. PARKED Steps 2+4 + layout migration; shipped only Steps 0+1 (autoinit DMA strip 9592c2d + Step 1 scaffold 50cc0bf). Working tree reset to HEAD; polypascal-test PASS 53.61 s confirms autoload DMA + Step 0/1 baseline green. Session writeup committed as d724796.)

---
2026-06-23 (session restart after crash)
> machine crashed. where were we?
> continue

---
2026-06-23 (continued)
> 236+237
> continue
> continue. stopping not relevant anymore

---
2026-06-25 (dcc corpus investigation)
> for those tests where dcc is faster than clang investigate why?
> for ">2B " execution probably hung. look at pc
> investigate "The one actionable compiler gap (for llvm-z80): loop strength reduction — arrays indexed by a loop variable should be transformed to pointer-increment form. " thoroughly
> fix "     tr: Illegal byte sequence"
> 3 is because dcc does not support a specific conversion? investigate 1+2
> what do you need me to answer?
> document your findings fully

> [autoload SEM702 font] jeg tænker det er fint den bliver en del af payload, bare pas på det ikke ramler mod barrierer
> er define_sextants optimal maskinkode?
> du burde kunne se kildetekst for maskinkoden
> ser ud til hl er gemt i iy via stakken, kunne det ikke bare være blevet dér?
> kunne hl ikke bare være gemt på stakken med push-pop uden at mellemlande i iy?
> jatak, især at sp er ukrænkelig (det vil jeg gerne følge op på senere)
> analyse, raise issues and tasks, summarize and commit.
