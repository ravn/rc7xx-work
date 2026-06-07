/* AVR cross-target test for 5-bug "Bug 4" — TruncInstCombine outside-user bail.
   Tests at gf_log scale (the macro shape that's actually painful on Z80).
   Verifies K&R and ANSI forms compute identical values for 8 sampled inputs.

   AVR codegen (this build): both forms ~24 instr — essentially equal cost.
   Z80 production: K&R = 153 B, ANSI = 28 B = 5.4x cost.  WEAKENED on AVR. */
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

uint8_t gf_log_knr(x) uint8_t x;
{
  uint8_t atb = 1, i = 0, z;
  do { if (atb == x) break;
       z = atb; atb <<= 1; if (z & 0x80) atb^= 0x1b; atb ^= z; } while (++i > 0);
  return i;
}
uint8_t gf_log_ansi(uint8_t x)
{
  uint8_t atb = 1, i = 0, z;
  do { if (atb == x) break;
       z = atb; atb <<= 1; if (z & 0x80) atb^= 0x1b; atb ^= z; } while (++i > 0);
  return i;
}

int main(void) {
  uint8_t inputs[] = {0x01, 0x03, 0x10, 0x80, 0xff, 0x5a, 0xa5, 0x42};
  uint8_t i, ok = 1;
  for (i = 0; i < sizeof(inputs); i++) {
    uint8_t k = gf_log_knr(inputs[i]), a = gf_log_ansi(inputs[i]);
    putstr("in="); puthex(inputs[i]); putstr(" knr="); puthex(k);
    putstr(" ansi="); puthex(a);
    if (k != a) { putstr(" MISMATCH"); ok = 0; }
    putch('\n');
  }
  putstr("VERDICT: "); putstr(ok ? "PASS\n" : "FAIL\n");
  __asm__ volatile("cli\n\tsleep" : : : "memory");
  for(;;){}
  return 0;
}
