# rc7xx-work

> Remember to check out all the submodules!  That is where everything is.




This umbrella project holds all the necessary project for working with the RC70x and RC75x families of computers from the Danish vendor Regnecentralen, including emulator and compiler support.   Claude Code has been doing all the heavy lifting for me - it has been great fun.

The RC702 is my pet project, as it was the machine I inherited from DIKU when they closed down their RC700 lab in the late 80'es and used for several years.  It is a Z80 based machine with a 4 MHz clock, 64 KB of RAM, and a 2 KB EPROM containing the autoload firmware and an another optional 2 KB EPROM for diskless operation.  It ran CP/M 2.2.   I disassembled the BIOS then to add a keyboard and modem buffer to make it more usable as my daily machine.  Now, both the firmware ROA327 and the CP/M BIOS has been reverse engineered and converted to C to get the latest benefits of modern compilers and toolchains.  A lot of work has been done to improve the experimental llvm-z80 backend to generate better code for the Z80 CPU which is very different from what LLVM was designed for, and generally llvm creates code as good or better as most other compilers. 

_Credit:  This could not have been done without the work of Michael Ringgaard who did a lot of work on what was available and possible in 2010-2015, including collecting everything under the sun and writing an emulator, and putting everything online on https://www.jbox.dk/rc702/index.shtm
and later work on 
https://github.com/ringgaard/rc700_

* Accurate emulation in MAME, including the multiple disk formats.
* Source code for everything needed from RESET to A> (CP/M itself in progress).
* BIOS now supports IOBYTE allowing Claude to remote control the machine.
* Modern compiler - LLVM with z80 backend and z88dk runtime library.
* CP/NET boot loader in C in 2 KB EPROM has been implemented to allow booting from MP/M over serial port A.
* z88dk platform support for the rc702, including semi-graphic support with optimized sprites and customizable fonts, and MAME-compatible disk images.

The RC759 "Piccoline" was a 16-bit machine with a 4 MHz clock, 80186 cpu and typically 256 KB of RAM targetting schools.  It had a bigger brother the RC750 "Partner" targetting business typically with a harddisk, color monitor and up to a megabyte of RAM.  Both ran first Concurrent CP/M-86 3.1 and later Concurrent DOS 4.1 which were technically superior to MS-DOS, but as they were not 100% IBM PC compatible they never gained much traction outside Denmark.  This is not my primary interest but for completeness sake I gave this a shot too.

* Initial support in MAME.  Goal is to have full CCP/M-86 support and graphics working in Comal80.
* Modern compiler support - Open Watcom v2 is the best 16-bit 8086 compiler in 2026 and it turned out to be relatively easy with Claude Code to adapt the standard library to CP/M-86.   This also include C++ (as of late 90'es).
* Perhaps some work will be done to look into the proms and possibly also reverse engineer the XIOS.  Still up in the air.




## Getting started (possibly out of date)

On a stock Ubuntu host, one command installs every build dependency
plus Claude CLI (idempotent, opt-out flags available):

```sh
bash scripts/setup-ubuntu.sh
```

Then follow [BOOTSTRAP.md](BOOTSTRAP.md) to clone the workspace
recursively, set your `ANTHROPIC_API_KEY`, and run `claude`.

For macOS hosts and per-machine detail, see [BOOTSTRAP.md](BOOTSTRAP.md).
For project structure and the working agreement with Claude, see
[PROJECT.md](PROJECT.md), [AGENTS.md](AGENTS.md), and [CLAUDE.md](CLAUDE.md).

