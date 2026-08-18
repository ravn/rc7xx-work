/* mame_bracket.h -- bracket a benchmark's REPS loop with two OUT 0x2FE bus
 * cycles so the MAME rc759 host can time it FROM OUTSIDE (never self-timed).
 *
 *   MAME_START()  emits word 0xB000 on the undecoded I/O port 0x2FE
 *   MAME_END()    emits word 0xE000 on the same port
 *
 * The rc759 driver does not decode 0x2FE (floppy ends at 0x290, iSBX starts at
 * 0x300), so both writes are side-effect-free on emulated hardware; a MAME
 * io-space write-tap (tools/mame_time.lua) still sees each bus cycle and reads
 * MAME's emulated clock (emu.time()) at each edge. The elapsed emulated seconds
 * between START and END is the time the REAL rc759 (80186 at its emulated clock)
 * would take to run the loop -- boot and crt0/printf overhead sit OUTSIDE the
 * bracket, so they are excluded by construction.
 *
 * Only compiled in when MAME_BRACKET is defined; otherwise MAME_START/END are
 * no-ops, so the size (`make compare`) and Unicorn-clock (`make speed`) builds
 * are byte-for-byte unaffected. Each compiler emits the OUT its own way:
 *   Watcom : #pragma aux inline asm (no linked object needed)
 *   Aztec  : #asm/#endasm inline blocks (MAME_AZTEC)
 *   DR C   : extern FAR stub linked from tools/mame-mark-far.asm (MAME_DRC),
 *            since DR C 1.11 has no inline asm.
 */
#ifndef MAME_BRACKET_H
#define MAME_BRACKET_H

#ifdef MAME_BRACKET

/* Each build passes exactly one of MAME_WATCOM / MAME_AZTEC / MAME_DRC. We use
 * plain #ifdef (not #if defined(...)) throughout: Aztec C 3.40a's K&R
 * preprocessor lacks the defined() operator (ERROR 109), but #ifdef works. */
#ifdef MAME_WATCOM
/* Pragma lives in a separate file: Aztec 3.40a's cpp errors on `#pragma` even
 * in a skipped #ifdef, so it must never appear in a file Aztec lexes. */
#include "mame_mark_watcom.h"
#endif

#ifdef MAME_AZTEC
mame_start()
{
#asm
    mov  dx,02FEh
    mov  ax,0B000h
    out  dx,ax
#endasm
}
mame_end()
{
#asm
    mov  dx,02FEh
    mov  ax,0E000h
    out  dx,ax
#endasm
}
#define MAME_START() mame_start()
#define MAME_END()   mame_end()
#endif

#ifdef MAME_DRC
/* Provided by the FAR stub tools/mame-mark-far.asm, linked in by the drc leg
 * (DR C 1.11 has no inline asm). */
extern void mame_start();
extern void mame_end();
#define MAME_START() mame_start()
#define MAME_END()   mame_end()
#endif

#else /* !MAME_BRACKET -- ordinary size/Unicorn builds: no-ops */
#define MAME_START()
#define MAME_END()
#endif

#endif /* MAME_BRACKET_H */
