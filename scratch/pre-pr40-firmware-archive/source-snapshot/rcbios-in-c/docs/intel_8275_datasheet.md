# Intel 8275 Programmable CRT Controller

Transcribed from the 1984 Intel datasheet (24 pages).
Source: https://bitsavers.org/components/intel/8275/1984_8275.pdf

## Overview

The 8275 is a single chip device to interface CRT Raster Scan Displays
with Intel Microcomputer Systems. Its primary function is to refresh the
display by buffering the information from main memory and keeping track
of the display position of the screen.

Features:
- Programmable Screen and Character Formats
- Six Independent Visual Field Attributes
- Eleven Visual Character Attributes (Graphic Capability)
- Cursor Control (4 Types)
- Light Pen Detection and Registers
- Dual Row Buffers
- Programmable DMA Burst Mode
- Single +5 Volt Supply
- 40 Pin Package

## Pin Description

| Pin | Name | I/O | Description |
|-----|------|-----|-------------|
| Vcc | | | +5V power supply |
| GND | | | Ground |
| CCLK | I | Character Clock (from dot timing logic) |
| DB0-DB7 | I/O | Bi-directional three-state data bus lines. Outputs enabled during read |
| CS | I | Chip Select. Read and write are enabled by CS |
| RD | I | Read input. Control signal to read registers |
| WR | I | Write input. Control signal to write commands/parameters and data into row buffers during DMA |
| A0 | I | Port Address. High selects "C" port (command/status), low selects "P" port (parameter/data) |
| INT | O | Interrupt request |
| DRQ | O | DMA request output. Single line requesting DMA controller for a DMA cycle |
| DACK | I | DMA acknowledge. Input from DMA controller acknowledging the requested DMA cycle has been granted |
| LPEN | I | Light pen input |
| HRTC | O | Horizontal retrace. Active during programmed horizontal retrace interval. VSP is high and LTEN output is low |
| VRTC | O | Vertical retrace. Active during programmed vertical retrace interval. During this period VSP output is high and LTEN is low |
| LC0-LC3 | O | Line counter. Output used to address the character generator for the current line position on the screen |
| CC0-CC6 | O | Character codes. Output from the row buffers used for character generator ROM bank selection |
| GPA0, GPA1 | O | General purpose attribute codes. Outputs enabled by the general purpose field attribute codes |
| LA0, LA1 | O | Line attribute codes. These attribute codes have to be decoded externally to generate the horizontal and vertical line continuations for the graphics displays specified by the character attribute codes or field attribute codes |
| HLGT | O | Highlight. Output signal used to intensify the display at particular positions on the screen as specified by the character attribute codes or field attribute codes |
| RVV | O | Reverse video. Output signal used to indicate the CRT circuitry to reverse the video signal. Active at cursor position if a reverse video block cursor is programmed or at the positions specified by the field attribute codes |
| LTEN | O | Light enable. Output signal used to enable the video signal to the CRT. Active at the programmed underline cursor position, and at the positions specified by the field attribute codes during generation of graphics display |
| VSP | O | Video suppression. Output signal used to blank the video signal to the CRT. Active: during horizontal and vertical retrace intervals; at the top and bottom lines of rows if number of lines/row is greater than or equal to 9; when an end of row or end of screen code is detected; when a DMA underrun occurs (at regular intervals: 1/16 frame frequency for cursor, 1/32 frame frequency for character and field attributes) to create blinking displays as specified by cursor, character attribute, or field attribute programming |

## System Operation

The 8275 provides a "window" into the microcomputer system memory.

Display characters are retrieved from memory and displayed on a row by
row basis. The 8275 has two row buffers. While one row buffer is being
used for display, the other is being filled with the next row of
characters to be displayed. The number of display characters per row and
the number of character rows per frame are software programmable.

The 8275 requests DMA to fill the row buffer that is not being used for
display. DMA burst length and spacing is programmable. The controller
can also be programmed to request a single DMA at a time or bursts of
2, 4, or 8 bytes.

The 8275 displays character rows one line at a time.

### Display Row Buffering

Before the start of a frame, the 8275 requests DMA and one row buffer
is filled with characters. When the first horizontal sweep is started,
characters are output to the character generator from the row buffer
just filled. Simultaneously, DMA begins filling the other row buffer
with the next row of characters. After all the lines of the character
row are scanned, the roles of the two row buffers are reversed and the
same procedure is followed for the next row.

This is repeated until all of the character rows are displayed.

## Display Format

### Screen Format

The 8275 can be programmed to generate from 1 to 80 characters per row,
and from 1 to 64 rows per frame.

The 8275 can also be programmed to blank alternate rows. In this mode,
the first row is displayed, the second blanked, the third displayed, etc.
DMA is not requested for the blanked rows.

### Row Format

The 8275 is designed to hold the line count stable while outputting the
appropriate character codes during each horizontal sweep. The line count
is incremented during horizontal retrace and the whole row of character
codes are output again during the next sweep. This is continued until
the whole character row is displayed.

The number of lines (horizontal sweeps) per character row is programmable
from 1 to 16.

The output of the line counter can be programmed to be in one of two modes:
- **Mode 0**: the output of the line counter is the same as the line number.
- **Mode 1**: the line counter is offset by one from the line number.

Mode 0 is useful for character generators that leave address zero blank
and start at address 1. Mode 1 is useful for character generators which
start at address zero.

### Underline Placement

Underline placement is programmable (from line number 0 to 15). This is
independent of the line counter mode.

If the line number of the underline is greater than 7 (line number MSB = 1),
then the top and bottom lines will be blanked.

If the line number of the underline is less than or equal to 7
(line number MSB = 0), then the top and bottom lines will not be blanked.

If the line number of the underline is greater than the maximum number of
lines, the underline will not appear.

## Raster Timing

The character counter is driven by the character clock input (CCLK).
It counts out the characters being displayed (programmable from 1 to 80).
It then causes the line counter to increment, and it starts counting out
the horizontal retrace interval (programmable from 2 to 32).

The line counter is driven by the character counter. It is used to
generate the line address outputs (LC0-3) for the character generator.
After it counts all of the lines in a character row (programmable from
1 to 16), it increments the row counter, and starts over again.

The row counter is an internal counter driven by the line counter. It
controls the functions of the row buffers and counts the number of
character rows displayed. After the row counter counts all of the rows
in a frame (programmable from 1 to 64), it starts counting out the
vertical retrace interval (programmable from 1 to 4).

## DMA Timing

The 8275 can be programmed to request burst DMA transfers of 1 to 8
characters. The interval between bursts is also programmable (from 0
to 55 character clock periods × 11).

This allows the user to tailor his DMA overhead to fit his system needs.

The first DMA request of the frame occurs one row time before the end of
vertical retrace. DMA requests continue as programmed, until the row
buffer is filled. If the row buffer is filled in the middle of a burst,
the 8275 terminates the burst and resets the burst counter. No more DMA
requests occur until the beginning of the next row. At that time, DMA
requests are activated as programmed until the other buffer is filled.

The first DMA request for a row will start at the first character clock
of the preceding row. If the burst mode is used, the first DMA request
may occur a number of character clocks later. This number is equal to
the programmed burst space.

If, for any reason, there is a DMA underrun, a flag in the status word
will be set.

The DMA controller is typically initialized for the next frame at the
end of the current frame.

### Interrupt Timing

The 8275 can be programmed to generate an interrupt request at the end
of each frame. This can be used to reinitialize the DMA controller.
If the 8275 interrupt enable flag is set, an interrupt request will
occur at the beginning of the last display row.

IRQ will go inactive after the status register is read.

A reset command will also cause IRQ to go inactive, but this is not
recommended during normal service.

Another method of reinitializing the DMA controller is to have the DMA
controller itself interrupt on terminal count. With this method, the
8275 interrupt enable flag should not be set.

Note: Upon power-up, the 8275 Interrupt Enable Flag may be set. As a
result, the user's cold start routine should write a reset command to
the 8275 before system interrupts are enabled.

## Visual Attributes and Special Codes

The characters processed by the 8275 are 8-bit quantities. The character
code outputs provide the character generator with 7 bits of address. The
Most Significant Bit is the extra bit and is used to determine if it is
a normal display character (MSB = 0), or if it is a Visual Attribute or
Special Code (MSB = 1).

There are two types of Visual Attribute Codes: Character Attributes and
Field Attributes.

### Field Attributes

The field attributes are control codes which will affect the visual
characteristics of a field of characters starting at the character
following the field attribute code up to the character which precedes
the next field attribute code. A field attribute code does not have to
occupy a display position. Any of the following field display can be
independently selected for a field:

- Blink
- Highlight
- Reverse Video
- Underline

Field Attribute Code format:

```
MSB                              LSB
 1  T  O  U  R  C  G  G
 |  |  |  |  |  |  |  |
 |  |  |  |  |  |  +--+-- GENERAL PURPOSE (GPA1, GPA0)
 |  |  |  |  |  +-------- REVERSE VIDEO
 |  |  |  |  +----------- BLINK
 |  |  |  +-------------- UNDERLINE
 |  |  +----------------- HIGHLIGHT
 |  +-------------------- (always 0 for field attributes)
 +----------------------- (always 1 for attributes/special codes)
```

H = 1 FOR HIGHLIGHTING
B = 1 FOR REVERSE VIDEO (note: datasheet labels this confusingly)
U = 1 FOR UNDERLINE
GG = GPA1, GPA0

More than one attribute can be enabled at the same time. If the blinking
and reverse video attributes are enabled simultaneously, only the
reversed characters will blink.

### Character Attributes

Character attribute codes are codes that can be used to generate graphics
symbols without the use of a character generator. This is accomplished by
selectively activating the Line Attribute outputs (LA0-1), the Video
Suppression output (VSP), and the Light Enable output. The dot level
timing circuitry then can use these signals to generate the proper symbols.

Character Attribute Code format:

```
MSB                              LSB
 1  1  C  C  C  C  B  H
 |  |  |  |  |  |  |  |
 |  |  |  |  |  |  |  +-- HIGHLIGHT
 |  |  |  |  |  |  +----- BLINK
 |  |  +--+--+--+-------- CHARACTER ATTRIBUTE CODE (4 bits)
 |  +-------------------- (always 1 for character attributes)
 +----------------------- (always 1 for attributes/special codes)
```

Character attribute codes produce the following graphics:

| Code | Symbol | Description |
|------|--------|-------------|
| 0000 | ┌ | Top Left Corner |
| 0001 | ┐ | Top Right Corner |
| 0010 | └ | Bottom Left Corner |
| 0011 | ┘ | Bottom Right Corner |
| 0100 | ┬ | Top Intersect |
| 0101 | ┤ | Right Intersect |
| 0110 | ├ | Left Intersect |
| 0111 | ┴ | Bottom Intersect |
| 1000 | ─ | Horizontal Line |
| 1001 | │ | Vertical Line |
| 1010 | ┼ | Crossed Lines |
| 1011 | | Not Recommended |
| 1100 | | Special Codes (see below) |
| 1101 | | Illegal |
| 1110 | | Illegal |
| 1111 | | Illegal |

Character Attribute Code 1011 is not recommended for normal operation.
Since none of the attribute outputs are active, the character generator
will not be disabled, and an indeterminate character will be generated.

Character Attribute Codes 1101, 1110, and 1111 are illegal.

### Special Codes

Four special codes are available to help reduce memory, software, or DMA
overhead.

Special Control Character format:

```
MSB                              LSB
 1  1  S  S  x  x  x  x
```

| S S | Function |
|-----|----------|
| 0 0 | End of Row |
| 0 1 | End of Row-Stop DMA |
| 1 0 | End of Screen |
| 1 1 | End of Screen-Stop DMA |

- **End of Row (00)**: activates VSP and holds it to the end of the line.
- **End of Row-Stop DMA (01)**: causes the DMA Control Logic to stop DMA
  for the rest of the row when it is written into the Row Buffer. It
  affects the display in the same way as the End of Row Code (00).
- **End of Screen (10)**: activates VSP and holds to the end of the frame.
- **End of Screen-Stop DMA (11)**: causes the DMA Control Logic to stop
  DMA for the rest of the frame when it is written into the Row Buffer.
  It affects the display in the same way as the End of Screen character.

If the Stop DMA feature is not used, all characters after an End of Row
character are ignored, except for the End of Screen character, which
operates normally. All characters after an End of Screen character are
ignored.

**Note**: If a Stop DMA character is not the last character in a burst or
row, DMA is not stopped until after the next character is read. In this
situation, a *dummy* character must be placed in memory after the Stop
DMA character.

### Visible vs. Invisible Field Attributes

The 8275 can be programmed to produce visible or invisible field
attribute characters.

If the 8275 is programmed in the **visible** field attribute mode, all
field attributes will occupy a position on the screen. They will appear
as blanks caused by activation of the Video Suppression output (VSP).

If the 8275 is programmed in the **invisible** field attribute mode, the
8275 FIFO is activated. Each row buffer has a corresponding FIFO. These
FIFOs are 16 characters by 7 bits in size.

When a field attribute is placed in the row buffer during DMA, the buffer
input controller recognizes it and places the next character in the
proper FIFO.

Since the FIFO is 16 characters long, no more than 16 field attribute
characters may be used per line in this mode. If more are used, a bit
in the status word is set, and the first characters in the FIFO are
written over and lost.

**Note**: Since the FIFO is 7 bits wide, the MSB of any characters put
in it are stripped off. Therefore, a Visual Attribute or Special Code
must not immediately follow a field attribute code. If this situation
does occur, the Visual Attribute or Special Code will be treated as a
normal display character.

## Cursor

The cursor location is determined by a cursor line and character position
register which are loaded by command to the controller. The cursor can be
programmed to appear on the display as:
1. a blinking underline
2. a blinking reverse video block
3. a non-blinking underline
4. a non-blinking reverse video block

The cursor blinking frequency is equal to the screen refresh frequency
divided by 16.

## Device Programming

The 8275 has two programming registers: the Command Register (CREG) and
the Parameter Register (PREG). It also has a Status Register (SREG).

| A0 | Operation | Register |
|----|-----------|----------|
| 0 | Read | PREG |
| 0 | Write | PREG |
| 1 | Read | SREG |
| 1 | Write | CREG |

The 8275 expects to receive a command and a sequence of 0 to 4
parameters, depending on the command. If the proper number of parameter
bytes are not received before another command is given, a status flag
is set, indicating an improper command.

## Instruction Set

| Command | No. of Parameter Bytes |
|---------|----------------------|
| Reset | 4 |
| Start Display | 0 |
| Stop Display | 0 |
| Read Light Pen | 2 (read) |
| Load Cursor | 2 |
| Enable Interrupt | 0 |
| Disable Interrupt | 0 |
| Preset Counters | 0 |

### 1. Reset Command

```
Command:  Write, A0=1:  0 0 0 x x x x x   (Reset command)
Param 1:  Write, A0=0:  S H H H H H H H   (Screen Comp #1)
Param 2:  Write, A0=0:  V V R R R R R R   (Screen Comp #2)
Param 3:  Write, A0=0:  U U U U L L L L   (Screen Comp #3)
Param 4:  Write, A0=0:  M F C C Z Z Z Z   (Screen Comp #4)
```

Action: After the reset command is written, DMA requests stop, 8275
interrupts are disabled, and the VSP output is used to blank the
screen. HRTC and VRTC continue to run. HRTC and VRTC timing are random
on power-up. As parameters are written, the screen composition is
defined.

#### Parameter S — Spaced Rows

| S | Function |
|---|----------|
| 0 | Normal Rows |
| 1 | Spaced Rows (alternate rows blanked, no DMA for blanked rows) |

#### Parameter HHHHHHH — Horizontal Characters/Row

| H6..H0 | No. of Characters per Row |
|---------|--------------------------|
| 0000000 | 1 |
| 0000001 | 2 |
| ... | ... |
| 1001111 | 80 |
| 1010000 | Undefined |
| ... | ... |
| 1111111 | Undefined |

Characters per row = H + 1 (valid range: 1 to 80)

#### Parameter VV — Vertical Retrace Row Count

| V1 V0 | No. of Row Counts per VRTC |
|-------|---------------------------|
| 0 0 | 1 |
| 0 1 | 2 |
| 1 0 | 3 |
| 1 1 | 4 |

#### Parameter RRRRRR — Vertical Rows/Frame

| R5..R0 | No. of Rows/Frame |
|--------|------------------|
| 000000 | 1 |
| 000001 | 2 |
| ... | ... |
| 011000 | 25 |
| 011001 | 26 |
| ... | ... |
| 111111 | 64 |

Rows per frame = R + 1

#### Parameter UUUU — Underline Placement

| U3..U0 | Line Number of Underline |
|--------|-------------------------|
| 0000 | 0 |
| 0001 | 1 |
| ... | ... |
| 1111 | 16 |

**Note**: UUUU MSB determines blanking of top and bottom lines
(1 = blanked, 0 = not blanked).

#### Parameter LLLL — Number of Lines per Character Row

| L3..L0 | No. of Lines/Row |
|--------|-----------------|
| 0000 | 1 |
| 0001 | 2 |
| ... | ... |
| 1111 | 16 |

Lines per character row = L + 1

#### Parameter M — Line Counter Mode

| M | Line Counter Mode |
|---|------------------|
| 0 | Mode 0 (No Offset) |
| 1 | Mode 1 (Offset by 1 Count) |

#### Parameter F — Field Attribute Mode

| F | Field Attribute Mode |
|---|---------------------|
| 0 | Transparent (invisible, uses FIFO) |
| 1 | Non-Transparent (visible, occupies screen position) |

#### Parameter CC — Cursor Format

| C1 C0 | Cursor Format |
|-------|---------------|
| 0 0 | Blinking reverse video block |
| 0 1 | Blinking underline |
| 1 0 | Nonblinking reverse video block |
| 1 1 | Nonblinking underline |

#### Parameter ZZZZ — Horizontal Retrace Count

| Z3..Z0 | No. of Character Counts per HRTC |
|--------|--------------------------------|
| 0000 | 2 |
| 0001 | 4 |
| 0010 | 6 |
| ... | ... |
| 1111 | 32 |

Horizontal retrace characters = (Z + 1) * 2

### 2. Start Display Command

```
Command:  Write, A0=1:  0 0 1 S S S B B   (Start Display)
```

No parameters.

| S S S | Burst Space Code: No. of Character Clocks Between DMA Requests |
|-------|--------------------------------------------------------------|
| 0 0 0 | 0 |
| 0 0 1 | 7 |
| 0 1 0 | 15 |
| 0 1 1 | 23 |
| 1 0 0 | 31 |
| 1 0 1 | 39 |
| 1 1 0 | 47 |
| 1 1 1 | 55 |

| B B | Burst Count Code: No. of DMA Cycles per Burst |
|-----|----------------------------------------------|
| 0 0 | 1 |
| 0 1 | 2 |
| 1 0 | 4 |
| 1 1 | 8 |

Action: 8275 interrupts are enabled, DMA requests begin, video is
enabled, Interrupt Enable and Video Enable status flags are set.

### 3. Stop Display Command

```
Command:  Write, A0=1:  0 1 0 x x x x x   (Stop Display)
```

No parameters.

Action: Disables video, interrupts remain enabled, HRTC and VRTC
continue to run. Video Enable status flag is reset, and the "Start
Display" command must be given to re-enable the display.

### 4. Read Light Pen Command

```
Command:  Write, A0=1:  0 1 1 x x x x x   (Read Light Pen)
Param 1:  Read, A0=0:   Row Number
Param 2:  Read, A0=0:   Character Position (Row Number)
```

### 5. Load Cursor Position

```
Command:  Write, A0=1:  1 0 0 x x x x x   (Load Cursor)
Param 1:  Write, A0=0:  C C C C C C C C   (Cursor X position)
Param 2:  Write, A0=0:  R R R R R R R R   (Row Number)
```

### 6. Enable Interrupt Command

```
Command:  Write, A0=1:  1 0 1 x x x x x   (Enable Interrupt)
```

No parameters. The interrupt enable status flag is set and interrupts
are enabled.

### 7. Disable Interrupt Command

```
Command:  Write, A0=1:  1 1 0 x x x x x   (Disable Interrupt)
```

No parameters. Interrupts are disabled and the interrupt enable status
flag is reset.

### 8. Preset Counters Command

```
Command:  Write, A0=1:  1 1 1 x x x x x   (Preset Counters)
```

No parameters.

Action: The internal timing counters are preset, corresponding to a
screen display position at the top left corner. Two character clocks
are required for this operation. The counters will remain in this state
until any other command is given.

This command is useful for system debug and synchronization of
clustered CRT displays on a single CPU. After this command, two
additional clock cycles are required before the first character of the
first row is put out.

## Status Flags

```
Status Read (A0=1):  0  IE  IR  LP  IC  VE  DU  FO
```

| Flag | Description |
|------|-------------|
| IE | (Interrupt Enable) Set or reset by command. Enables vertical retrace interrupt. Automatically set by "Start Display" and reset with "Reset" command |
| IR | (Interrupt Request) Set at the beginning of display of the last row of the frame if the interrupt enable flag is set. Reset after a status read operation |
| LP | Light Pen flag. Set when LPEN input is activated and light pen registers have been loaded. Automatically reset after a status read |
| IC | (Improper Command) Set when a command parameter string is too long or too short. Automatically reset after a status read |
| VE | (Video Enable) Indicates video operation of the CRT is enabled. Set on "Start Display" command, reset on "Stop Display" or "Reset" command |
| DU | (DMA Underrun) Set whenever a data underrun occurs during DMA transfers. Upon detection of DU, the DMA operation is stopped and the screen is blanked until after the vertical retrace interval. Reset after a status read |
| FO | (FIFO Overrun) Set whenever the FIFO is overrun (more than 16 field attributes per row in transparent mode). Reset on a status read |

## Electrical Characteristics

### D.C. Characteristics (TA = 0°C to 70°C, Vcc = 5V ±5%)

| Symbol | Parameter | Min | Max | Units |
|--------|-----------|-----|-----|-------|
| VIL | Input Low Voltage | -0.5 | 0.8 | V |
| VIH | Input High Voltage | 2.0 | Vcc+0.5V | V |
| VOL | Output Low Voltage | | 0.45 | V |
| IOH | Output High Current | | -400 | uA |
| ICC | Supply Current | | 180 | mA |

### A.C. Characteristics

| Symbol | Parameter | 8275 Min | 8275 Max | 8275-2 Min | 8275-2 Max | Units |
|--------|-----------|----------|----------|------------|------------|-------|
| tCLK | Clock Period | 480 | | 320 | | ns |
| tCC | Character Code Output Delay | | 150 | | 150 | ns |
| tHR | Horizontal Retrace Output Delay | | 200 | | 150 | ns |
| tLC | Line Count Output Delay | | 400 | | 250 | ns |
| tAT | Control/Attribute Output Delay | | 275 | | 250 | ns |
| tVR | Vertical Retrace Output Delay | | 275 | | 250 | ns |
| tRQ | IRQ from RD | | 250 | | 250 | ns |
| tWQ | DRQ from WR | | 250 | | 250 | ns |
| tNQ | DRQ from WR (falling) | | 200 | | 200 | ns |

8275: max CCLK = 2.08 MHz (480 ns period)
8275-2: max CCLK = 3.125 MHz (320 ns period)

## References and cross-references

### Alternate datasheet PDF mirrors (in case one goes down)
- bitsavers 1984: https://bitsavers.org/components/intel/8275/1984_8275.pdf (primary — this transcription)
- bitsavers 1979: https://bitsavers.org/components/intel/8275/1979_8275.pdf
- bitsavers 1981 design guide: https://bitsavers.org/components/intel/8275/1981_8275_design.pdf
- elektronikjk.pl mirror: http://www.elektronikjk.pl/elementy_czynne/IC/8275.pdf
- jbox.dk (RC702 hardware archive): https://www.jbox.dk/rc702/hardware/intel-8275.pdf

All are scanned image PDFs. Use Docker poppler to render for transcription:
```
docker run --rm -v /tmp:/data minidocks/poppler pdftoppm -png -r 300 /data/file.pdf /data/out
```

### CP/M 2.2 Manual (for BIOS interaction context)
- PDF: http://www.cpm.z80.de/manuals/cpm22-m.pdf
- Browsable HTML: https://www.cpm.z80.de/manuals/archive/cpm22htm/

### Where the 8275 is used in this codebase
- `bios.h:481-504` — ConfiBlock `par1-par4` bit field documentation (reset parameters)
- `roa375/roa375.asm:428-436` — 8275 reset parameter bytes with comments (original ROA375 PROM)
- `rcbios/ANALYSIS.md:613-631` — PAR1-PAR4 field table from the reverse-engineered BIOS

### External writeups
- eeeguide.com overview: https://www.eeeguide.com/internal-architecture-of-8275-crt-controller/
