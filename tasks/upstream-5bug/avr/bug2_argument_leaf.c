/* AVR cross-target test for 5-bug "Bug 2" — TruncInstCombine Argument-leaf.
   Verifies that K&R-form and ANSI-form rotl() compute identical values when
   run on AVR through simavr.  Build + run via this directory's Makefile.

   Existing AVR codegen datum (pristine upstream, sonnyboy): K&R = 20 instr,
   ANSI = 3 instr at -Os/-O2/-O3.  This file adds the runtime confirmation:
   for all 6 sampled inputs, both forms compute the same rotated value.
   STRENGTHENS the upstream filing at llvm/llvm-project#202112. */
#include <stdint.h>
#include "/Users/ravn/z80/simavr/simavr/sim/avr/avr_mcu_section.h"

#define F_CPU 16000000UL
AVR_MCU_SIMAVR_CONSOLE(0x3E);
AVR_MCU(F_CPU, "atmega328p");

static volatile uint8_t *console = (volatile uint8_t *)0x3E;
static void putch(char c) { *console = c; }
static void putstr(const char *s) { while (*s) putch(*s++); }
static void puthex(uint8_t v) {
  const char hex[] = "0123456789abcdef";
  putch(hex[(v>>4)&0xF]); putch(hex[v&0xF]);
}

uint8_t rotl_knr(x) uint8_t x; { return (x << 1) | (x >> 7); }
uint8_t rotl_ansi(uint8_t x)    { return (x << 1) | (x >> 7); }

int main(void) {
  uint8_t inputs[] = {0x00, 0x01, 0x80, 0xff, 0x5a, 0xa5};
  uint8_t i, ok = 1;
  for (i = 0; i < sizeof(inputs); i++) {
    uint8_t k = rotl_knr(inputs[i]), a = rotl_ansi(inputs[i]);
    putstr("in="); puthex(inputs[i]);
    putstr(" knr="); puthex(k);
    putstr(" ansi="); puthex(a);
    if (k != a) { putstr(" MISMATCH"); ok = 0; }
    putch('\n');
  }
  putstr("VERDICT: "); putstr(ok ? "PASS\n" : "FAIL\n");
  __asm__ volatile("cli\n\tsleep" : : : "memory");
  for(;;){}
  return 0;
}
