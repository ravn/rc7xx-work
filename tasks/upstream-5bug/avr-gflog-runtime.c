/*
 * avr-gflog-runtime.c — runtime cycle harness for avr-gflog-missed-opt.c.
 *
 * Compiles together with avr-gflog-missed-opt.c, links with avr-gcc +
 * avr-libc, runs in simavr.  Reports 32-bit cycle total for a 256-call
 * sweep of gf_log() over its full uint8_t input domain via simavr's
 * console hook (GPIOR0 = 0x3E → host stdout).
 *
 * Build:
 *   clang --target=avr -mmcu=atmega328p -Os -std=c89 \
 *         -Wno-deprecated-non-prototype \
 *         -I${SIMAVR_SRC}/sim \
 *         -c avr-gflog-missed-opt.c -o gflog.o
 *   clang --target=avr -mmcu=atmega328p -Os -std=c89 \
 *         -I${SIMAVR_SRC}/sim \
 *         -c avr-gflog-runtime.c -o runtime.o
 *   avr-gcc -mmcu=atmega328p runtime.o gflog.o -o gflog.elf
 *   timeout 30 simavr gflog.elf
 *
 * Expected last-line output:
 *   With fix:    CYCLES=0009173d   (=  595773)
 *   Without fix: CYCLES=000c99ce   (=  825294)
 *
 * Notes:
 *   - Timer1 with no prescaler (TCCR1B = 0x01) so 1 tick = 1 CPU cycle.
 *   - Overflow-counted into a 32-bit total.
 *   - `volatile uint8_t sink` prevents the optimizer from eliding the
 *     gf_log() return value.
 *   - The `for (;;) {}` at the end is a halt loop; simavr is invoked
 *     with `timeout 30` to bound runtime.  Exit code 124 (timeout) is
 *     expected and not an error.
 */

#include <stdint.h>
#include "simavr/sim/avr/avr_mcu_section.h"

#define F_CPU 16000000UL
AVR_MCU_SIMAVR_CONSOLE(0x3E);
AVR_MCU(F_CPU, "atmega328p");

/* atmega328p I/O register addresses (datasheet §35.1 register summary). */
#define TCCR1A   (*(volatile uint8_t *)0x80)
#define TCCR1B   (*(volatile uint8_t *)0x81)
#define TCNT1L   (*(volatile uint8_t *)0x84)
#define TCNT1H   (*(volatile uint8_t *)0x85)
#define TIFR1    (*(volatile uint8_t *)0x36)
#define TOV1_BIT 0x01

/* Defined in avr-gflog-missed-opt.c. */
extern uint8_t gf_log(uint8_t x);

static volatile uint8_t *console = (volatile uint8_t *)0x3E;
static void putch(char c) { *console = c; }
static void putstr(const char *s) { while (*s) putch(*s++); }
static void puthex(uint8_t v) {
    const char hex[] = "0123456789abcdef";
    putch(hex[(v >> 4) & 0xF]);
    putch(hex[v & 0xF]);
}
static void puthex16(uint16_t v) {
    puthex((uint8_t)(v >> 8));
    puthex((uint8_t)(v & 0xFF));
}
static void puthex32(uint32_t v) {
    puthex16((uint16_t)(v >> 16));
    puthex16((uint16_t)(v & 0xFFFF));
}

static uint16_t read_tcnt1(void) {
    uint8_t lo, hi;
    lo = TCNT1L;    /* low first; AVR latches high into TEMP */
    hi = TCNT1H;
    return ((uint16_t)hi << 8) | lo;
}

volatile uint8_t sink;

int main(void) {
    uint16_t i;
    uint16_t overflows;
    uint32_t cycles;

    putstr("gf_log AVR cycle oracle\n");

    TCCR1A = 0;
    TCCR1B = 0x01;
    overflows = 0;
    TCNT1L = 0;
    TCNT1H = 0;
    TIFR1 = TOV1_BIT;

    putch('S');

    for (i = 0; i < 256; i++) {
        sink = gf_log((uint8_t)i);
        if (TIFR1 & TOV1_BIT) {
            overflows++;
            TIFR1 = TOV1_BIT;
        }
    }

    cycles = ((uint32_t)overflows << 16) | read_tcnt1();

    putch('E');
    putstr("\nCYCLES=");
    puthex32(cycles);
    putstr("\n");

    for (;;) {}
}
