/* AVR cross-target test for 5-bug "Bug 5" — InstCombine memcpy->illegal-int fold.
   8-byte memcpy.  Upstream InstCombine may fold to i64 load/store at -O1+.
   AVR backend lowers either way to call memcpy; runtime: 8 bytes copied. */
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

void copy8(uint8_t *dst, uint8_t *src) { __builtin_memcpy(dst, src, 8); }

uint8_t src_buf[8] = {0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88};
uint8_t dst_buf[8];

int main(void) {
  uint8_t i, ok = 1;
  copy8(dst_buf, src_buf);
  for (i = 0; i < 8; i++) {
    putstr("dst["); puthex(i); putstr("]=");
    puthex(dst_buf[i]); putstr(" src="); puthex(src_buf[i]);
    if (dst_buf[i] != src_buf[i]) { putstr(" MISMATCH"); ok = 0; }
    putch('\n');
  }
  putstr("VERDICT: "); putstr(ok ? "PASS\n" : "FAIL\n");
  __asm__ volatile("cli\n\tsleep" : : : "memory");
  for(;;){}
  return 0;
}
