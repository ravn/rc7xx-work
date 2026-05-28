---
name: Check memory for build commands
description: Always check memory for correct build commands before building; store successful commands in memory
type: feedback
originSessionId: ccdbd44a-b64e-4fa9-bead-b4770933b2b1
---
Before building anything (MAME, LLVM, z88dk, etc.), always check memory for the correct build command first. After a successful build, verify the command is stored in memory.

**Why:** Build commands often have critical flags (e.g., MAME requires `OSD=sdl USE_SDL=1`). Using the wrong flags wastes time (SDL3 vs SDL2 failure). The user had to correct this multiple times.

**How to apply:** 
1. Before any build: search memory for the project name + "build"
2. Use the exact flags from memory
3. If a new build succeeds with different flags, update the memory entry
