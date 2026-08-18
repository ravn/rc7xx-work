/* mame_mark_watcom.h -- Watcom-only OUT 0x2FE bracket markers, split out of
 * mame_bracket.h because Aztec C 3.40a's K&R preprocessor errors on the token
 * `#pragma` (ERROR 58 "illegal #") even inside a skipped #ifdef block. Keeping
 * the pragma in a file that only the Watcom leg #includes means Aztec never
 * lexes it. Included solely from mame_bracket.h under #ifdef MAME_WATCOM. */
extern void mame_start(void);
extern void mame_end(void);
#pragma aux mame_start =    \
    "mov dx,02FEh"          \
    "mov ax,0B000h"         \
    "out dx,ax"             \
    modify [dx ax];
#pragma aux mame_end =      \
    "mov dx,02FEh"          \
    "mov ax,0E000h"         \
    "out dx,ax"             \
    modify [dx ax];
#define MAME_START() mame_start()
#define MAME_END()   mame_end()
