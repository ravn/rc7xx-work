typedef unsigned char u8;
u8   z_in (u8 p)       __asm__("llvm.z80.in");
void z_out(u8 p, u8 v) __asm__("llvm.z80.out");
void wait_ready(void){ while(!(z_in(0x10) & 1)) ; }          /* must re-read port */
u8   twice(void){ u8 a = z_in(0x11); u8 b = z_in(0x11); return a + b; }  /* two reads, both needed */
void dead(void){ (void)z_in(0x12); }                          /* read for side effect */
