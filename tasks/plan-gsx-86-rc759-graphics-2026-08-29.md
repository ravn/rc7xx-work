# GSX-86 Graphics System Analysis for RC759 - 2026-08-30

## Overview

This document analyzes the **GSX-86 Graphics System Extension** for Concurrent CP/M-86 on the **Regnecentralen RC759 Piccoline**, with the goal of implementing graphics support in MAME.

**Key finding:** The RC759 hardware (Intel 82730 CRT controller) supports **graphics modes** that are currently **not fully emulated** in MAME. The GSX-86 software layer provides the API, but the underlying graphics rendering is incomplete.

**NEW (2026-08-30):** 
- Partial implementation **already exists** (see Current Status below)
- Found GSX-86 test disk with GRAPHICS.CMD, SCRN*.CMD demos, and MPBBC284.SYS printer driver in `scratch/rc759-gsx-test/`
- Detailed Intel 82730 graphics mode documentation referenced in PICCOLINE Programmer's Guide v2

---

## Viden kilder (Sources of Knowledge)

---

### 1. Project Files (Verificeret / Verified)
- **`/Users/ravn/z80/scratch/zip-a-extract/graphics.cmd`** - GSX-86 v1.3 (14 Feb 84) from Digital Research
  - Contains strings: `"GSX-86  Graphics System Extension  14 Feb 84  V1.3"`
  - Copyright Digital Research, Inc. 1983
  - Serial No. 5044-0261-007041
- **`/Users/ravn/z80/mame/src/devices/video/i82730.cpp/.h`** - Intel 82730 device emulation (HAS `set_gfx_mode()` and `m_gfx_mode`)
- **`/Users/ravn/z80/mame/src/mame/regnecentralen/rc75x.cpp/.h`** - Shared RC759/RC750 implementation (HAS `gfx_update_row` stub + mode check in `txt_update_row`)
- **`/Users/ravn/z80/mame/src/mame/regnecentralen/rc759.cpp`** - RC759-specific implementation (HAS PPI->i82730 connection at lines 307-308)
- **`/Users/ravn/z80/rc700-gensmedet/docs/RC702_VPB701_GRAPHICS.md`** - RC702 graphics (µPD7220 GDC) - different hardware
- **`/Users/ravn/z80/scratch/rc759-gsx-test/`** - GSX-86 test disk with GRAPHICS.CMD v1.3, SCRN*.CMD demos, MPBBC284.SYS printer driver
- **`/Users/ravn/z80/scratch/zip-a-extract/graphics.cmd`** - Original Digital Research GSX-86 v1.3 (14 Feb 84)

### 2. Hardware Documentation (Referenced)
- **Intel 82730 Text Coprocessor datasheet (Preliminary)**
  - archive.org: https://archive.org/details/Intel-82730TextCoprocessor-PreliminaryOCR
  - Referenced in rc759.cpp header
- **PICCOLINE Programmer's Guide v2** (CCP/M-86 3.1 / XIOS 2.3)
  - RC759-specific I/O map, NVM config layout, console escapes
  - Referenced in rc759.cpp header

### 3. Existing Task Documentation
- **`tasks/rc759-i82730-cursor-and-cmdq-2026-08-17.md`** - Current i82730 cursor implementation status

---

## Current Status (2026-08-30)

### What Works
1. **Text mode** - Fully implemented and verified
   - Alphanumeric 560x250
   - Hardware cursor (block or underline)
   - Amber color palette (P3 phosphor)
   - Proper cursor blinking

2. **i82730 Device** - Core functionality
   - Mode set command (0x04)
   - Display list processing
   - Row buffer loading
   - Cursor tracking
   - Interrupt handling

3. **Graphics mode infrastructure** - **PARTIALLY IMPLEMENTED**
   - `m_gfx_mode` variable exists in rc75x_state (set via PPI port C bit 6)
   - PPI port C bit 6 controls graphics mode (0Ch = graphics, 0Dh = alphanumeric)
   - **`m_gfx_mode` IS USED** in rendering, but implementation is incomplete:
     - `rc759.cpp:307-308`: `m_gfx_mode = BIT(data, 6); m_txt->set_gfx_mode(m_gfx_mode);`
     - `rc75x.cpp:24-28`: `if (m_gfx_mode) { gfx_update_row(...); return; }`
     - `gfx_update_row()` exists but **only generates test checkerboard pattern**
   - **CRITICAL FINDING:** The connection chain PPI -> rc75x_state -> i82730_device -> txt_update_row **IS COMPLETE**, but gfx_update_row doesn't use VRAM data yet

### What's Missing
1. **Graphics modes** - **PARTIALLY IMPLEMENTED, INCOMPLETE**
   - High-res graphics: 560x256, 1 bit/pixel
   - Medium-res graphics: 280x256, 2 bits/pixel
   - These are selected via **PPI port C bit 6** (`m_gfx_mode` in rc75x_state)
   - The `m_gfx_mode` flag **IS** connected to i82730 device and **IS** checked in rendering pipeline
   - **BUT:** `gfx_update_row()` only generates test checkerboard, doesn't use VRAM data

2. **GSX-86 Integration**
   - GRAPHICS.CMD is the GSX-86 loader
   - Requires graphics-capable hardware driver
   - RC759 XIOS must support graphics mode switching

---

## Hardware Analysis: Intel 82730 Graphics Capabilities

### From rc759.cpp comments (lines 37-47):
```
Video modes (82730, per the guide) -- only alphanumeric is currently
emulated, and only in monochrome (see rc75x.cpp txt_update_row):
  alphanumeric        560x250, char cell from 32 KB pixel RAM
  high-res graphics   560x256, 1 bit/pixel   (m_gfx_mode, not emulated)
  medium-res graphics 280x256, 2 bits/pixel  (m_gfx_mode, not emulated)
```

### Graphics Mode Selection
- **PPI Port C bit 6** controls graphics mode
- In rc759.cpp, line 307: `m_gfx_mode = BIT(data, 6);`
- In rc75x.h, line 112: `int m_gfx_mode;`
- **OUT 76H, 0Ch** = graphics mode
- **OUT 76H, 0Dh** = alphanumeric mode

### Video Memory
- 32 KB pixel RAM @ 0xD0000 (from rc759.cpp line 23)
- Shared between text and graphics modes
- In text mode: character cells
- In graphics mode: bitmap data

---

## GSX-86 Software Architecture

### Overview
GSX-86 (Graphics System Extension) is Digital Research's standardized graphics API for CP/M-86, similar to GGI (Graphics Graphics Interface) on other platforms.

### Components

#### 1. GRAPHICS.CMD
- **Purpose:** GSX-86 loader/installer
- **Version:** 1.3 (14 Feb 1984)
- **Function:** 
  - Checks for existing GSX installation
  - Loads and installs GSX-86
  - Binds default graphics driver
  - Sets up interrupt vectors

#### 2. Graphics Drivers (Device-Specific)
GSX-86 requires **hardware-specific drivers** for:
- **Screen/Display** - For RC759: i82730 graphics mode driver
- **Printer** - For RC759: Parallel (Centronics) printer driver

The GRAPHICS.CMD file found contains error messages:
- `"GSX-86 is not installed"`
- `"Unable to Open Assign.Sys"`
- `"Unable to Open Default Driver file"`
- `"Unable to Bind Default Driver"`

This confirms the driver-binding architecture.

#### 3. Default Driver Files
Based on the error messages in GRAPHICS.CMD, the installation process:
1. Reads ASSIGN.SYS for device redirection
2. Opens default driver file (likely named based on hardware)
3. Binds driver to GSX-86
4. Installs interrupt handlers

---

## RC759 Graphics Mode Implementation Requirements

### Hardware Level (i82730 Device)

#### Missing Features in `i82730_device`:

1. **Graphics Mode Detection**
   - The device needs to know when graphics mode is active
   - This comes from PPI port C bit 6, but the i82730 device doesn't currently receive this
   - **Solution:** Add a callback or direct connection from PPI to i82730

2. **Graphics Data Interpretation**
   - In text mode: data words = character code + attributes
   - In graphics mode: data words = pixel data
   - Need to differentiate between these in `load_row()` and rendering

3. **Bitmap Rendering**
   - Current `m_update_row_cb` (txt_update_row) assumes text mode
   - Need a separate or enhanced callback for graphics mode
   - Graphics mode uses direct pixel manipulation

4. **Pixel Data Format**
   - High-res (560x256): 1 bit/pixel, 70 bytes per row (560/8)
   - Medium-res (280x256): 2 bits/pixel, 70 bytes per row (280/4)
   - Need to understand the exact pixel packing format

### Driver Level (rc75x/rc759)

#### Current Implementation:
- `txt_update_row` in rc75x.cpp only handles text mode
- Uses VRAM as character codes pointing to font data
- Renders each character cell individually

#### Required Changes:

1. **Mode-Aware Row Callback**
   ```cpp
   // In rc75x.cpp, need to branch based on m_gfx_mode
   if (m_gfx_mode) {
       // Graphics mode rendering
       gfx_update_row(bitmap, data, lc, y, x_count, cursor);
   } else {
       // Text mode rendering (current)
       txt_update_row(bitmap, data, lc, y, x_count, cursor);
   }
   ```

2. **Graphics Mode Row Renderer**
   - Interpret data as raw pixel data
   - Map to bitmap pixels
   - Handle color palette (1-bit or 2-bit)

3. **Palette Support**
   - Current palette_w handles IRGB format for text attributes
   - Graphics mode may use different palette interpretation
   - RC759 has 32-entry palette @ I/O 0x180-0x1be

---

## Implementation Plan

### Phase 1: Research & Documentation (This Document)
- [x] Identify GSX-86 components in project
- [x] Understand i82730 graphics capabilities
- [x] Map hardware connections (PPI -> i82730)
- [x] **Found GSX-86 test disk with GRAPHICS.CMD and MPBBC284.SYS printer driver** in `scratch/rc759-gsx-test/`
- [ ] **Find RC759-specific screen driver file** (search in progress)
- [ ] **Document exact pixel data format for both graphics modes** (from PICCOLINE Programmer's Guide)

### Phase 2: i82730 Device Enhancement

#### Task 2.1: Add graphics mode support to i82730_device
- **File:** `mame/src/devices/video/i82730.h`
- **Changes:**
  - ✅ `m_gfx_mode` state variable ALREADY EXISTS (line 50 in i82730.cpp constructor)
  - ✅ `set_gfx_mode()` method ALREADY EXISTS (lines 106-110 in i82730.cpp)
  - ⬜ Extend device to use `m_gfx_mode` in rendering (CURRENTLY UNUSED in rendering)

#### Task 2.2: Add graphics mode data interpretation
- **File:** `mame/src/devices/video/i82730.cpp`
- **Changes:**
  - ✅ `set_gfx_mode()` method ALREADY RECEIVES mode changes from PPI via rc759.cpp
  - ⬜ Modify `load_row()` to handle graphics data format
  - ⬜ Graphics mode: VRAM contains pixel data directly, not character codes
  - ⬜ Add graphics-specific row update callback

#### Task 2.3: Enhance screen_update for graphics
- **File:** `mame/src/devices/video/i82730.cpp`
- **Changes:**
  - ⬜ Modify `screen_update()` to handle graphics mode rendering
  - ⬜ Need to understand how graphics mode affects display timing

### Phase 2.5: Graphics Mode Pixel Format Research

#### Task 2.5.1: Document i82730 graphics memory layout
- **From PICCOLINE Programmer's Guide:**
  - High-res graphics: 560x256, 1 bit/pixel
  - Medium-res graphics: 280x256, 2 bits/pixel
  - Both modes use the same 32 KB VRAM @ 0xD0000
  - Pixel data organized in blocks:
    - High-res: 16x16 pixel blocks, 1 bit/pixel
    - Medium-res: 8x16 pixel blocks, 2 bits/pixel
  - Pixel address calculation: word = (X/block_width) * 256 + Y

#### Task 2.5.2: Implement pixel address calculation
- **High-res (560x256):**
  - Block width = 16 pixels
  - Word address = (X/16) * 256 + Y
  - Each word contains 16 bits (1 pixel per bit)
  - 70 words per row (560/16 = 35 blocks, but 70 words? Need verification)

- **Medium-res (280x256):**
  - Block width = 8 pixels  
  - Word address = (X/8) * 256 + Y
  - Each word contains 16 bits (2 bits per pixel, so 8 pixels per word)
  - 35 words per row (280/8 = 35)

#### Task 2.5.3: Palette handling for graphics
- **From rc759.cpp:** Palette @ I/O 0x180-0x1be (32 entries, IRGB format)
- **Graphics mode palette selection:**
  - High-res: 2 colors selected from 32-entry palette via bits 10-13 of attribute
  - Medium-res: 4 colors selected from 32-entry palette via bits 10-13
  - Need to understand how palette indices map to actual colors

### Phase 3: RC759 Integration

#### Task 3.1: Connect PPI to i82730 graphics mode
- **File:** `mame/src/mame/regnecentralen/rc759.cpp`
- **Changes:**
  - ✅ ALREADY IMPLEMENTED: `ppi_portc_w()` at lines 307-308: `m_gfx_mode = BIT(data, 6); m_txt->set_gfx_mode(m_gfx_mode);`
  - ✅ The callback chain PPI -> rc75x_state::m_gfx_mode -> i82730_device::m_gfx_mode **IS COMPLETE**

#### Task 3.2: Modify txt_update_row to handle graphics mode
- **File:** `mame/src/mame/regnecentralen/rc75x.cpp`
- **Changes:**
  - ✅ ALREADY IMPLEMENTED: `txt_update_row()` at lines 24-28 checks `m_gfx_mode` and calls `gfx_update_row()`

#### Task 3.3: Implement gfx_update_row for i82730 graphics
- **File:** `mame/src/mame/regnecentralen/rc75x.cpp`
- **Changes:**
  - ⬜ **CRITICAL: Replace checkerboard with VRAM data** (lines 75-112)
  - ⬜ Interpret VRAM data as pixel data, not character codes
  - ⬜ Handle both high-res (1 bpp) and medium-res (2 bpp) formats
  - ⬜ Map pixel data to bitmap using correct palette

#### Task 3.4: Palette configuration for graphics
- **File:** `mame/src/mame/regnecentralen/rc75x.cpp`
- **Changes:**
  - Current `palette_w` handles IRGB format for text attributes
  - ⬜ For graphics mode: palette indices come from VRAM data
  - ⬜ Need to map graphics palette indices to the 32-entry palette
  - ⬜ High-res: 2 colors from palette entries (bits 10-13 select which 2)
  - ⬜ Medium-res: 4 colors from palette entries (bits 10-13 select which 4)

#### Task 3.5: Update i82730 device to support graphics mode
- **Files:** `mame/src/devices/video/i82730.h`, `i82730.cpp`
- **Changes:**
  - ✅ `m_gfx_mode` state variable ALREADY EXISTS
  - ✅ `set_gfx_mode(bool mode)` method ALREADY EXISTS
  - ⬜ Modify `load_row()` to interpret data differently in graphics mode
  - ⬜ In graphics mode: data words = pixel data, not character codes
  - ⬜ Modify `screen_update()` to handle graphics mode timing (may differ from text mode)

#### Task 3.6: Connect rc75x to i82730 graphics mode
- **File:** `mame/src/mame/regnecentralen/rc75x.cpp`
- **Changes:**
  - ✅ ALREADY IMPLEMENTED: The connection **IS COMPLETE**

### Phase 4: Testing & Verification

#### Task 4.1: Create test disk images
- Build GSX-86 disk with test programs
- Include both high-res and medium-res graphics tests
- Include GRAPHICS.CMD and required drivers

#### Task 4.2: Manual testing in MAME
- Boot RC759 with GSX disk
- Run GRAPHICS.CMD
- Test basic graphics operations
- Verify mode switching

#### Task 4.3: Automated verification
- Use headless mode with snapshots
- Compare against expected output
- Test edge cases (mode switching, palette changes)

---

## Known Issues & Challenges

### 1. Missing Driver Files
- The GRAPHICS.CMD file is found, but the actual **i82730 graphics driver** is not located
- The driver would be a .SYS or .DRV file that GSX-86 loads
- **Action:** Search for driver files in RC759 software distributions

### 2. Pixel Data Format Uncertainty
- The exact format of pixel data in VRAM for graphics mode is not documented
- Intel 82730 datasheet may have this information
- **Action:** Research 82730 graphics mode memory layout

### 3. Palette Interpretation
- Current palette handling is for text attributes
- Graphics mode may use palette differently
- **Action:** Verify palette behavior in graphics mode

### 4. VRAM Sharing
- Text and graphics modes share the same 32 KB VRAM
- Mode switching must properly handle VRAM contents
- **Action:** Ensure VRAM is correctly interpreted in each mode

### 5. Performance Considerations
- Graphics mode rendering may be slower than text mode
- Need to optimize pixel data conversion
- **Action:** Profile and optimize as needed

---

## References for Further Research

### Internal Project References
- `tasks/rc759-i82730-cursor-and-cmdq-2026-08-17.md` - i82730 cursor implementation
- `tasks/rc759-fdc-dma-nvram-findings-2026-08-12.md` - RC759 findings
- `tasks/rc759-firmware-keymap-2026-08-18.md` - Firmware keyboard mapping

### External References (to fetch if needed)
- Intel 82730 datasheet: https://archive.org/details/Intel-82730TextCoprocessor-PreliminaryOCR
- Digital Research GSX-86 documentation
- PICCOLINE Programmer's Guide v2

---

## Next Steps

1. **Implement graphics mode support in i82730 device**
   - Add `m_gfx_mode` to i82730_device
   - Add `set_gfx_mode()` method
   - Modify rendering to handle graphics mode

2. **Connect PPI to i82730 via rc75x_state**
   - When `m_gfx_mode` changes in rc75x_state, notify i82730 device
   - Modify callback chain: PPI -> rc75x_state -> i82730_device

3. **Implement gfx_update_row callback**
   - Interpret VRAM as pixel data
   - Handle 1-bit and 2-bit pixel formats
   - Map to bitmap with correct palette

4. **Test with GRAPHICS.CMD**
   - Create test disk image with GSX-86
   - Boot RC759 in MAME
   - Run GRAPHICS.CMD and verify graphics mode works

## Implementation Priority

The most critical issue is that `m_gfx_mode` in rc75x_state is **not connected** to the i82730 device. The i82730 device always assumes text mode and interprets VRAM as character codes. When graphics mode is selected, the i82730 should interpret VRAM as raw pixel data.

## Quick Start Implementation Plan

### CRITICAL FINDING: Most of this is ALREADY DONE!

1. **i82730_device (i82730.h):**
   ```cpp
   int m_gfx_mode;  // ✅ ALREADY EXISTS (line 50 in constructor)
   void set_gfx_mode(int mode);  // ✅ ALREADY EXISTS (lines 106-110)
   ```

2. **rc759.cpp ppi_portc_w():**
   ```cpp
   // ✅ ALREADY IMPLEMENTED at lines 307-308:
   m_gfx_mode = BIT(data, 6);
   m_txt->set_gfx_mode(m_gfx_mode);  // notifies i82730
   ```

3. **txt_update_row in rc75x.cpp:**
   ```cpp
   // ✅ ALREADY IMPLEMENTED at lines 24-28:
   if (m_gfx_mode) {
       gfx_update_row(bitmap, data, lc, y, x_count, cursor);
       return;
   }
   ```

4. **Implement gfx_update_row in rc75x.cpp:**
   ```cpp
   // ⬜ TODO: Replace checkerboard with VRAM data (lines 75-112)
   void rc75x_state::gfx_update_row(bitmap_rgb32 &bitmap, uint16_t *data, uint8_t lc, uint16_t y, int x_count, int cursor)
   {
       // TODO: Interpret data as pixel data
       // TODO: Handle 1 bpp (high-res) and 2 bpp (medium-res)
       // TODO: Map to bitmap with 32-entry palette
   }
   ```

---

*Document created: 2026-08-29, last updated: 2026-08-30*
*Status: Analysis complete, Phase 3.3 (gfx_update_row implementation) is the CRITICAL NEXT STEP*
