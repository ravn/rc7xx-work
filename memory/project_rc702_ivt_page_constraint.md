---
name: RC702 IVT page placement constraint
description: Under Z80 IM 2 the IVT page (I*256) cannot overlap RC702 display memory at 0xF800..0xFFCF; I=0xFF page is unusable
type: project
originSessionId: 9adba288-d140-4e53-8e2b-2f1cfaedce42
---
Z80 IM 2 forms the vector-fetch address as `(I << 8) | (device_byte & 0xFE)`. The I register fixes a 256-byte page; the CPU reads its ISR pointer from somewhere inside that page determined by the interrupting device's vector low byte.

**On RC702 the display memory occupies 0xF800..0xFFCF** (2000 bytes, 80×25). Therefore:

- **I = 0xFF is forbidden** — the I=0xFF page is 0xFF00..0xFFFF, of which 0xFF00..0xFFCF is on-screen character RAM. Any spurious or misprogrammed interrupt with vector low byte < 0xD0 would have the CPU jump to a pointer composed of screen bytes.
- **I = 0xF8..0xFE all forbidden** — same reason; the entire 0xF800..0xFFCF range is display.
- The 48 B scratch at 0xFFD0..0xFFFF (frame counter at 0xFFFC..0xFFFF + 44 B free) is fine as **scratch RAM**, but **not viable as an IM 2 IVT page**.

**Why:** told to assistant before; the "move IVT to 0xFFD0 / set I=0xFF" plan that surfaced in CLAUDE.md session-47 notes is unsafe.

**How to apply:**
- For #29 (relocate IVT off the resident region), do NOT propose the I=0xFF / 0xFFD0 path.
- Valid IVT pages on this board are pages whose entire 256 B range is owned by the slave AND not display memory. Practical candidates: 0xEC00 / 0xED00 (BSS scratch — carve 36 B for IVT, shift BSS up; zero resident cost) or 0xF500 (clang's current location, inside resident — costs resident bytes, hence session-47 SDCC blocker).
- Clang currently uses `__ivt_start = 0xF500` (I=0xF5). SDCC port should mirror with a page-aligned `RESIDENT_IVT` section, OR move both compilers to a BSS-scratch page (0xEC00/0xED00) to free 36 B of resident.
