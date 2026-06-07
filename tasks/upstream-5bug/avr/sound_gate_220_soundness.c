/* AVR cross-target soundness witness for the icmp-narrow-through-graph
 * sound gate (ravn/llvm-z80#160 sound version).
 *
 * Same shape as test-runner test_220 / test_221: t = vx+1, t < bound ? r : 99.
 * Unsound i8 narrowing returns 5; sound returns 99 (0x63).
 *
 * Mirrors a generic 8-bit-target argument: the optimization is in
 * AggressiveInstCombine (target-independent middle-end), so a Z80
 * soundness gap appears identically on AVR.  PASS here = sound on both.
 *
 * Expected VERDICT: SOUND (both probes return 99 = 0x63).
 */
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

typedef unsigned char u8;
typedef unsigned int u16;

volatile u16 vx = 260;
volatile u16 vy = 10;

/* test_220 shape — variable-other path (bound = y & 0x0f, single-use). */
static u8 __attribute__((noinline)) pick_var(u16 x, u16 y) {
  u16 t = x + 1;
  u8 r = (u8)t;
  return (t < (y & 0x0fu)) ? r : 99;
}

/* test_221 shape — constant-other path. */
static u8 __attribute__((noinline)) pick_const(u16 x) {
  u16 t = x + 1;
  u8 r = (u8)t;
  return (t < 10u) ? r : 99;
}

int main(void) {
  u8 v = pick_var(vx, vy);
  u8 c = pick_const(vx);
  putstr("pick_var(260,10)=0x"); puthex(v); putch('\n');
  putstr("pick_const(260)=0x");  puthex(c); putch('\n');
  putstr("VERDICT: ");
  if (v == 0x63 && c == 0x63)
    putstr("SOUND\n");
  else
    putstr("UNSOUND\n");
  __asm__ volatile("cli\n\tsleep" : : : "memory");
  for(;;){}
  return 0;
}
