typedef unsigned char u8;
volatile u8 sink;
/* static helpers: only reachable from entry, so they can use static frames */
static __attribute__((noinline)) u8 helper(u8 a, u8 b, u8 c) {
  volatile u8 buf[6]; buf[0] = a; buf[1] = b; buf[2] = c;
  __builtin_z80_set_i(a);            /* LD I,A  */
  __builtin_z80_im2();               /* IM 2    */
  __builtin_z80_out(0x10, buf[0]);   /* OUT (n),A */
  return __builtin_z80_in(0x11) + buf[1] + buf[2];   /* IN A,(n) */
}
u8 entry(void) {
  __builtin_z80_di();
  u8 r = helper(0x40, 2, 3);
  __builtin_z80_ei();
  return r;
}
